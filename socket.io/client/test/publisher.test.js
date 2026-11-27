import test from "node:test"
import assert from "node:assert/strict"
import { createPublisher, QUEUE } from "../publisher.js"

const fakeAmqpConnection = ({ fail = false, confirmed = true, failConfirm = false } = {}) => {
  const calls = {
    assertQueue: [],
    sendToQueue: [],
    waitForConfirms: 0,
    close: 0
  }

  const channel = {
    async assertQueue(...args) {
      calls.assertQueue.push(args)
    },
    sendToQueue(...args) {
      if (fail) throw new Error("send failed")
      calls.sendToQueue.push(args)
      return confirmed
    },
    async waitForConfirms() {
      calls.waitForConfirms += 1
      if (failConfirm) throw new Error("confirm failed")
    },
    async close() {
      calls.close += 1
    }
  }

  return {
    calls,
    amqpConnection: {
      async withChannel(callback) {
        try {
          return await callback(channel)
        } finally {
          await channel.close()
        }
      }
    }
  }
}

const makeLogger = () => {
  const logs = []
  return {
    logs,
    logger: {
      log: message => logs.push(message),
      warn() {}
    }
  }
}

test("publishes the server message verbatim and waits for broker confirmation", async () => {
  const { amqpConnection, calls } = fakeAmqpConnection()
  const { logs, logger } = makeLogger()
  const publish = createPublisher({ amqpConnection, logger })
  const message = '{"monsterName":"Joker","dangerLevel":"God"}'

  await publish(message)

  assert.deepEqual(calls.assertQueue, [[
    QUEUE,
    { durable: true, arguments: { "x-dead-letter-exchange": "un.dlx" } }
  ]])
  assert.equal(calls.sendToQueue[0][0], QUEUE)
  assert.equal(calls.sendToQueue[0][1].toString(), message)
  assert.deepEqual(calls.sendToQueue[0][2], { persistent: true })
  assert.equal(calls.waitForConfirms, 1)
  assert.equal(calls.close, 1)
  assert.deepEqual(logs, [message])
})

test("publishes malformed content verbatim", async () => {
  const { amqpConnection, calls } = fakeAmqpConnection()
  const publish = createPublisher({ amqpConnection, logger: makeLogger().logger })
  const message = '{"monsterName":"Joker"'

  await publish(message)

  assert.equal(calls.sendToQueue[0][1].toString(), message)
  assert.throws(() => JSON.parse(calls.sendToQueue[0][1].toString()))
})

test("rejects when sendToQueue reports backpressure", async () => {
  const { amqpConnection } = fakeAmqpConnection({ confirmed: false })
  const { logs, logger } = makeLogger()
  const publish = createPublisher({ amqpConnection, logger })

  await assert.rejects(() => publish('{"monsterName":"Joker"}'), /backpressure/)
  assert.deepEqual(logs, [])
})

test("rejects when the broker does not confirm", async () => {
  const { amqpConnection } = fakeAmqpConnection({ failConfirm: true })
  const { logs, logger } = makeLogger()
  const publish = createPublisher({ amqpConnection, logger })

  await assert.rejects(() => publish('{"monsterName":"Joker"}'), /confirm failed/)
  assert.deepEqual(logs, [])
})
