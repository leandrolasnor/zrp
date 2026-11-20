import test from "node:test"
import assert from "node:assert/strict"
import { createOccurrenceHandler } from "../handler.js"

const silentLogger = () => ({ log() {}, warn() {} })

test("acks the server only after publishing is confirmed", async () => {
  const published = []
  const acked = []
  const handler = createOccurrenceHandler({
    publish: async message => published.push(message),
    logger: silentLogger()
  })

  const result = await handler('{"monsterName":"Joker"}', () => acked.push(true))

  assert.equal(result, true)
  assert.deepEqual(published, ['{"monsterName":"Joker"}'])
  assert.deepEqual(acked, [true])
})

test("does not ack the server when publishing fails", async () => {
  const acked = []
  const handler = createOccurrenceHandler({
    publish: async () => {
      throw new Error("amqp down")
    },
    logger: silentLogger()
  })

  const result = await handler('{"monsterName":"Joker"}', () => acked.push(true))

  assert.equal(result, false)
  assert.deepEqual(acked, [])
})

test("works when the server sends no ack callback", async () => {
  const handler = createOccurrenceHandler({ publish: async () => {}, logger: silentLogger() })

  await handler('{"monsterName":"Joker"}')
})
