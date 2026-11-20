export const AMQP_RETRY_MS = 1000

// Mantém uma conexão AMQP persistente. O caller só é chamado quando a conexão
// está de pé; se cair, a reconexão acontece em background.
export const createAmqpConnection = ({
  amqp,
  url,
  retryMs = AMQP_RETRY_MS,
  delay = ms => new Promise(resolve => setTimeout(resolve, ms)),
  isStopped = () => false,
  logger = console
}) => {
  let connection = null
  let connecting = null
  let lastErrorLog = 0

  const logConnectionError = error => {
    const now = Date.now()
    if (now - lastErrorLog < 60000) return
    lastErrorLog = now
    logger.warn?.(`amqp connect failed: ${error.message}`)
  }

  const connect = async () => {
    if (isStopped()) return null
    if (connection) return connection
    if (connecting) return connecting

    connecting = (async () => {
      while (!connection && !isStopped()) {
        try {
          connection = await amqp.connect(url)
          connection.on?.("error", error => {
            logger.warn?.(`amqp error: ${error.message}`)
            connection = null
          })
          connection.on?.("close", () => {
            connection = null
          })
          logger.log?.("RabbitMQ connected")
        } catch (error) {
          if (isStopped()) break
          logConnectionError(error)
          await delay(retryMs)
        }
      }

      connecting = null
      return connection
    })()

    return connecting
  }

  const withChannel = async callback => {
    let activeConnection = await connect()
    if (!activeConnection) return undefined

    let channel
    try {
      channel = await activeConnection.createChannel()
      return await callback(channel)
    } catch (error) {
      logger.warn?.(`amqp channel failed: ${error.message}`)
      connection = null
      throw error
    } finally {
      try {
        await channel?.close()
      } catch {
        // canal já estava fechado
      }
    }
  }

  const close = async () => {
    connecting = null
    const current = connection
    connection = null

    try {
      await current?.close()
    } catch (error) {
      logger.warn?.(`amqp shutdown failed: ${error.message}`)
    }
  }

  return { connect, withChannel, close, get connection () { return connection } }
}
