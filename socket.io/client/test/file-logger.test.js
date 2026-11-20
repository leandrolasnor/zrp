import test from "node:test"
import assert from "node:assert/strict"
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { createFileLogger } from "../file-logger.js"

const withTempDir = run => {
  const dir = mkdtempSync(join(tmpdir(), "zrp-client-log-"))

  try {
    return run(dir)
  } finally {
    rmSync(dir, { recursive: true, force: true })
  }
}

test("writes leveled messages to the log file", () => {
  withTempDir(dir => {
    const filePath = join(dir, "socket-io-client.log")
    const logger = createFileLogger({ filePath })

    logger.log("connected")
    logger.warn("retrying")
    logger.error("failed")

    const lines = readFileSync(filePath, "utf8").trim().split("\n")
    assert.equal(lines.length, 3)
    assert.match(lines[0], /^\d{4}-\d{2}-\d{2}T.* INFO connected$/)
    assert.match(lines[1], /^\d{4}-\d{2}-\d{2}T.* WARN retrying$/)
    assert.match(lines[2], /^\d{4}-\d{2}-\d{2}T.* ERROR failed$/)
  })
})

test("rotates the log file when it reaches the size limit", () => {
  withTempDir(dir => {
    const filePath = join(dir, "socket-io-client.log")
    writeFileSync(filePath, "x".repeat(64))

    const logger = createFileLogger({ filePath, maxSize: 10, maxFiles: 2 })
    logger.log("new entry")

    assert.match(readFileSync(filePath, "utf8").trim(), /INFO new entry$/)
    assert.equal(readFileSync(`${filePath}.1`, "utf8"), "x".repeat(64))
  })
})
