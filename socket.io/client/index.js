import { io } from "socket.io-client"
import amqp from "amqplib"
import { createAmqpConnection } from "./amqp.js"
import { createPublisher } from "./publisher.js"
import { createOccurrenceHandler } from "./handler.js"
import { createLogger } from "./logger.js"
import { createStartup } from "./startup.js"

const logger = createLogger(console)
let stopped = false

const socketUrl = `${process.env.SOCKET_IO_SERVER}:${process.env.SOCKET_IO_SERVER_PORT}`
const amqpConnection = createAmqpConnection({
  amqp,
  url: process.env.AMQP_SERVER,
  isStopped: () => stopped,
  logger
})
const publish = createPublisher({ amqpConnection, logger })
const handleOccurrence = createOccurrenceHandler({ publish, logger })

// O client fica de pé esperando o servidor; socket.io-client reconecta sozinho.
const socket = io(socketUrl, {
  reconnection: true,
  reconnectionDelay: 1000,
  reconnectionDelayMax: 5000
})

const startup = createStartup({ socket, amqpConnection, handleOccurrence, logger })

const start = () => {
  startup.start().catch(error => logger.warn(`startup failed: ${error.message}`))
}

socket.on("connect", () => {
  logger.log("socket.io.server connected")
  start()
})

socket.on("disconnect", reason => {
  startup.stop()
  logger.warn(`socket.io.server disconnected: ${reason}`)
})

socket.on("connect_error", error => {
  logger.warn(`socket.io.server connect failed: ${error.message}`)
})

start()

const shutdown = async signal => {
  logger.log(`${signal} received, shutting down`)
  stopped = true
  startup.stop()
  socket.disconnect()
  await amqpConnection.close()
  process.exit(0)
}

process.on("SIGTERM", () => shutdown("SIGTERM"))
process.on("SIGINT", () => shutdown("SIGINT"))
