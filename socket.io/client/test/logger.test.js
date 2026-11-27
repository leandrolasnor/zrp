import test from "node:test"
import assert from "node:assert/strict"
import { createLogger } from "../logger.js"

test("does not throttle payload logs", () => {
  const messages = []
  const logger = createLogger({ log: message => messages.push(message) })

  logger.log("first")
  logger.log("second")
  logger.log("third")

  assert.deepEqual(messages, ["first", "second", "third"])
})

test("throttles repeated warnings by level and lets other levels through", () => {
  let now = 0
  const originalNow = Date.now
  Date.now = () => now

  try {
    const messages = []
    const logger = createLogger({
      warn: message => messages.push(["warn", message]),
      error: message => messages.push(["error", message])
    })

    logger.warn("first")
    logger.warn("suppressed")
    now = 30000
    logger.warn("still suppressed")
    now = 61000
    logger.warn("allowed again")
    logger.error("other level")

    assert.deepEqual(messages, [
      ["warn", "first"],
      ["warn", "allowed again"],
      ["error", "other level"]
    ])
  } finally {
    Date.now = originalNow
  }
})
