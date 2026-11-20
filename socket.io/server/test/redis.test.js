import test from "node:test"
import assert from "node:assert/strict"
import { connectWithRetry, createInsurgencyTime } from "../redis.js"

test("createInsurgencyTime uses the value stored in redis", async () => {
  const redis = { isOpen: true, get: async () => "3500" }
  const insurgencyTime = createInsurgencyTime({ redis, fallback: 20000 })

  assert.equal(await insurgencyTime(), 3500)
})

test("createInsurgencyTime falls back when redis is closed", async () => {
  const redis = { isOpen: false, get: async () => "3500" }
  const insurgencyTime = createInsurgencyTime({ redis, fallback: 20000 })

  assert.equal(await insurgencyTime(), 20000)
})

test("createInsurgencyTime falls back on invalid or missing values", async () => {
  const empty = createInsurgencyTime({
    redis: { isOpen: true, get: async () => null },
    fallback: 20000
  })
  const invalid = createInsurgencyTime({
    redis: { isOpen: true, get: async () => "abc" },
    fallback: 20000
  })

  assert.equal(await empty(), 20000)
  assert.equal(await invalid(), 20000)
})

test("createInsurgencyTime falls back and logs when redis fails", async () => {
  const warnings = []
  const insurgencyTime = createInsurgencyTime({
    redis: {
      isOpen: true,
      get: async () => {
        throw new Error("redis down")
      }
    },
    fallback: 20000,
    logger: { warn: message => warnings.push(message) }
  })

  assert.equal(await insurgencyTime(), 20000)
  assert.deepEqual(warnings, ["failed to read INSURGENCY_TIME: redis down"])
})

test("connectWithRetry retries until redis connects", async () => {
  let attempts = 0
  const delays = []
  const client = {
    isOpen: false,
    async connect() {
      attempts += 1
      if (attempts < 3) throw new Error("connection refused")
      this.isOpen = true
    },
    async disconnect() {}
  }

  await connectWithRetry({
    client,
    retryMs: 50,
    delay: async ms => delays.push(ms),
    logger: { warn() {} }
  })

  assert.equal(attempts, 3)
  assert.deepEqual(delays, [50, 50])
  assert.equal(client.isOpen, true)
})
