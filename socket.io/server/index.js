import { Server } from "socket.io"
import { createClient } from "redis"
import { faultRateFromEnv, randomPayload } from "./occurrence.js"
import { createEmitter } from "./emitter.js"
import { connectWithRetry, createInsurgencyTime } from "./redis.js"
// Os logs vão para o stdout do container e são coletados pelo `make logs`.
// import { createFileLogger } from "./file-logger.js"

const INSURGENCY_DEFAULT = Number(process.env.INSURGENCY_TIME || 20000)
// const logger = createFileLogger()
const logger = console

let stopped = false
let lastRedisErrorLog = 0

const redis = createClient({ url: process.env.REDIS_URL })
redis.on("error", error => {
  const now = Date.now()
  if (now - lastRedisErrorLog < 60000) return
  lastRedisErrorLog = now
  logger.warn(`redis error: ${error.message}`)
})

// O Redis é opcional: o serviço sobe mesmo sem ele e usa o fallback.
connectWithRetry({ client: redis, logger, isStopped: () => stopped })

const insurgencyTime = createInsurgencyTime({ redis, fallback: INSURGENCY_DEFAULT, logger })
const { stream } = createEmitter({
  insurgencyTime,
  createPayload: randomPayload,
  fallbackTimeout: INSURGENCY_DEFAULT,
  logger
})

const io = new Server({})

io.on("connection", socket => {
  stream(socket).catch(error => logger.error(`occurrence stream failed: ${error.message}`))
})
io.on("error", error => logger.error(`socket.io error: ${error.message}`))

io.listen(3003)
io.httpServer.on("error", error => logger.error(`http server error: ${error.message}`))

logger.log(`socket.io server listening on 3003 (fault rate: ${faultRateFromEnv()})`)

const shutdown = async signal => {
  logger.log(`${signal} received, shutting down`)
  stopped = true
  io.disconnectSockets(true)
  io.close()

  try {
    if (redis.isOpen) await redis.quit()
    else await redis.disconnect()
  } catch (error) {
    logger.warn(`redis shutdown failed: ${error.message}`)
  }

  process.exit(0)
}

process.on("SIGTERM", () => shutdown("SIGTERM"))
process.on("SIGINT", () => shutdown("SIGINT"))
