import test from "node:test"
import assert from "node:assert/strict"
import { createStartup } from "../startup.js"

const fakeSocket = () => {
  const listeners = new Map()
  return {
    connected: false,
    on (event, handler) {
      listeners.set(event, handler)
    },
    once (event, handler) {
      const wrapper = (...args) => {
        listeners.delete(event)
        handler(...args)
      }
      listeners.set(event, wrapper)
    },
    off (event, handler) {
      if (listeners.get(event) === handler) listeners.delete(event)
    },
    connect () {
      this.connected = true
      listeners.get("connect")?.()
    },
    disconnect () {
      this.connected = false
    },
    has (event) {
      return listeners.has(event)
    }
  }
}

const fakeAmqpConnection = ({ connected = true } = {}) => ({
  connection: connected ? {} : null,
  async connect () {
    if (connected) this.connection = {}
    return this.connection
  }
})

test("waits for socket.io before registering the handler", async () => {
  const socket = fakeSocket()
  const amqpConnection = fakeAmqpConnection()
  const handleOccurrence = () => {}
  const startup = createStartup({ socket, amqpConnection, handleOccurrence, logger: { log () {} } })

  let resolved = false
  const starting = startup.start().then(result => {
    resolved = true
    return result
  })
  await Promise.resolve()
  assert.equal(resolved, false)
  assert.equal(socket.has("occurrence"), false)

  socket.connect()
  assert.equal(await starting, true)
  assert.equal(socket.has("occurrence"), true)
  assert.equal(startup.started, true)
})

test("waits for rabbitmq before registering the handler", async () => {
  const socket = fakeSocket()
  socket.connected = true
  const amqpConnection = fakeAmqpConnection({ connected: false })
  const startup = createStartup({ socket, amqpConnection, handleOccurrence () {}, logger: { log () {} } })

  let resolved = false
  const starting = startup.start().then(result => {
    resolved = true
    return result
  })
  await Promise.resolve()
  assert.equal(resolved, false)
  assert.equal(socket.has("occurrence"), false)

  amqpConnection.connected = true
  amqpConnection.connection = {}
  assert.equal(await starting, true)
  assert.equal(socket.has("occurrence"), true)
})

test("start is idempotent and stop removes the handler", async () => {
  const socket = fakeSocket()
  socket.connected = true
  const amqpConnection = fakeAmqpConnection()
  const startup = createStartup({ socket, amqpConnection, handleOccurrence () {}, logger: { log () {} } })

  assert.equal(await startup.start(), true)
  assert.equal(await startup.start(), false)
  assert.equal(socket.has("occurrence"), true)

  startup.stop()
  assert.equal(socket.has("occurrence"), false)
  assert.equal(startup.started, false)
})
