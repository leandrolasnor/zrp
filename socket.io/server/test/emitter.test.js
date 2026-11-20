import test from "node:test"
import assert from "node:assert/strict"
import { createEmitter, DEFAULT_MAX_ATTEMPTS } from "../emitter.js"

const fakeSocket = () => {
  const timeouts = []
  const emits = []
  const acks = []

  return {
    connected: true,
    timeouts,
    emits,
    acks,
    timeout(timeout) {
      timeouts.push(timeout)
      return {
        emit(event, payload, ack) {
          emits.push({ event, payload })
          acks.push(ack)
        }
      }
    }
  }
}

const flush = () => new Promise(resolve => setImmediate(resolve))

const makeEmitter = overrides => createEmitter({
  insurgencyTime: async () => 1000,
  createPayload: () => '{"monsterName":"Joker"}',
  logger: { warn() {} },
  ...overrides
})

test("emits the payload using the timeout from redis", async () => {
  const socket = fakeSocket()
  const emitter = makeEmitter({ insurgencyTime: async () => 1234 })

  await emitter.emitOccurrence(socket)
  await flush()

  assert.deepEqual(socket.timeouts, [1234])
  assert.equal(socket.emits.length, 1)
  assert.equal(socket.emits[0].event, "occurrence")
  assert.equal(socket.emits[0].payload, '{"monsterName":"Joker"}')
  assert.equal(socket.acks.length, 1)
})

test("a successful ack stops the retries", async () => {
  const socket = fakeSocket()
  const emitter = makeEmitter()

  await emitter.emitOccurrence(socket)
  await flush()
  socket.acks[0]()
  await flush()

  assert.equal(socket.emits.length, 1)
})

test("an ack timeout retries up to maxAttempts and then stops", async () => {
  const socket = fakeSocket()
  const emitter = makeEmitter({ maxAttempts: DEFAULT_MAX_ATTEMPTS })

  await emitter.emitOccurrence(socket)
  await flush()

  for (let attempt = 0; attempt < DEFAULT_MAX_ATTEMPTS; attempt += 1) {
    socket.acks[attempt](new Error("ack timeout"))
    await flush()
  }

  assert.equal(socket.emits.length, DEFAULT_MAX_ATTEMPTS)
  assert.equal(socket.acks.length, DEFAULT_MAX_ATTEMPTS)
})

test("does not emit for a disconnected socket", async () => {
  const socket = fakeSocket()
  socket.connected = false
  const emitter = makeEmitter()

  await emitter.emitOccurrence(socket)

  assert.equal(socket.emits.length, 0)
})

test("falls back when reading the insurgency time fails", async () => {
  const socket = fakeSocket()
  const warnings = []
  const emitter = makeEmitter({
    insurgencyTime: async () => {
      throw new Error("redis down")
    },
    fallbackTimeout: 4321,
    logger: { warn: message => warnings.push(message) }
  })

  await emitter.emitOccurrence(socket)
  await flush()

  assert.deepEqual(socket.timeouts, [4321])
  assert.equal(warnings.length, 1)
})

test("streams occurrences only while a client is connected", async () => {
  const socket = fakeSocket()
  const waits = []
  const emitter = makeEmitter({
    wait: async ms => {
      waits.push(ms)
      if (waits.length === 2) socket.connected = false
    }
  })

  await emitter.stream(socket)

  assert.equal(socket.emits.length, 2)
  assert.deepEqual(waits, [1000, 1000])
})

test("stream stays idle when there is no connected client", async () => {
  const socket = fakeSocket()
  socket.connected = false
  const waits = []
  const emitter = makeEmitter({ wait: async ms => waits.push(ms) })

  await emitter.stream(socket)

  assert.equal(socket.emits.length, 0)
  assert.deepEqual(waits, [])
})
