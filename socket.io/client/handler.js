import { createLogger } from "./logger.js"

// ACK manual: o socket.io/server só recebe confirmação quando o RabbitMQ
// confirmou a publicação. Falha de publicação NÃO gera ACK.
export const createOccurrenceHandler = ({ publish, logger = console }) => {
  const log = createLogger(logger)

  return async (data, ack) => {
    try {
      await publish(data)
    } catch (error) {
      log.warn(`failed to publish occurrence: ${error.message}`)
      return false
    }

    if (typeof ack === "function") ack()
    return true
  }
}
