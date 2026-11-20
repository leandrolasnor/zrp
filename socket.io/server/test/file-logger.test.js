import test from "node:test"
import assert from "node:assert/strict"
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { createFileLogger } from "../file-logger.js"

const withTempDir = run => {
  const dir = mkdtempSync(join(tmpdir(), "zrp-server-log-"))

  try {
    return run(dir)
  } finally {
    rmSync(dir, { recursive: true, force: true })
  }
}

test("writes leveled messages to the log file", () => {
  withTempDir(dir => {
    const filePath = join(dir, "socket-io-server.log")
    const logger = createFileLogger({ filePath })

    logger.log("listening")
    logger.warn("redis error")
    logger.error("stream failed")

    const lines = readFileSync(filePath, "utf8").trim().split("\n")
    assert.equal(lines.length, 3)
    assert.match(lines[0], /^\d{4}-\d{2}-\d{2}T.* INFO listening$/)
    assert.match(lines[1], /^\d{4}-\d{2}-\d{2}T.* WARN redis error$/)
    assert.match(lines[2], /^\d{4}-\d{2}-\d{2}T.* ERROR stream failed$/)
  })
})

test("rotates the log file when it reaches the size limit", () => {
  withTempDir(dir => {
    const filePath = join(dir, "socket-io-server.log")
    writeFileSync(filePath, "x".repeat(64))

    const logger = createFileLogger({ filePath, maxSize: 10, maxFiles: 2 })
    logger.log("new entry")

    assert.match(readFileSync(filePath, "utf8").trim(), /INFO new entry$/)
    assert.equal(readFileSync(`${filePath}.1`, "utf8"), "x".repeat(64))
  })
})
