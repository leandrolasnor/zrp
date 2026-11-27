import test from "node:test"
import assert from "node:assert/strict"
import { createAmqpConnection } from "../amqp.js"

const silentLogger = () => ({ log() {}, warn() {} })

test("retries until rabbitmq connects and reuses the connection", async () => {
  let attempts = 0
  const delays = []
  const channel = {
    async close () {}
  }
  const connection = {
    on () {},
    async createConfirmChannel () { return channel },
    async close () {}
  }
  const amqpConnection = createAmqpConnection({
    amqp: {
      async connect () {
        attempts += 1
        if (attempts < 3) throw new Error("connection refused")
        return connection
      }
    },
    url: "amqp://rabbit",
    retryMs: 50,
    delay: async ms => delays.push(ms),
    logger: silentLogger()
  })

  const first = await amqpConnection.connect()
  const second = await amqpConnection.connect()

  assert.equal(attempts, 3)
  assert.deepEqual(delays, [50, 50])
  assert.equal(first, connection)
  assert.equal(second, connection)
})

test("withChannel creates and closes a confirm channel on the live connection", async () => {
  const closed = []
  let channelsCreated = 0
  const channel = { async close () { closed.push(true) } }
  const connection = {
    on () {},
    async createConfirmChannel () {
      channelsCreated += 1
      return channel
    },
    async close () {}
  }
  const amqpConnection = createAmqpConnection({
    amqp: { async connect () { return connection } },
    url: "amqp://rabbit",
    logger: silentLogger()
  })

  const result = await amqpConnection.withChannel(async () => "ok")

  assert.equal(result, "ok")
  assert.equal(channelsCreated, 1)
  assert.deepEqual(closed, [true])
})

test("drops the connection when the channel fails so the next publish reconnects", async () => {
  const connections = []
  const makeConnection = () => ({
    on () {},
    async createConfirmChannel () {
      throw new Error("channel closed")
    },
    async close () {}
  })
  const amqpConnection = createAmqpConnection({
    amqp: {
      async connect () {
        const connection = makeConnection()
        connections.push(connection)
        return connection
      }
    },
    url: "amqp://rabbit",
    logger: silentLogger()
  })

  await amqpConnection.connect()
  await assert.rejects(
    () => amqpConnection.withChannel(async () => {}),
    /channel closed/
  )
  assert.equal(amqpConnection.connection, null)

  await amqpConnection.connect()
  assert.equal(connections.length, 2)
})
