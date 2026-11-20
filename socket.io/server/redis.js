export const createInsurgencyTime = ({ redis, fallback, logger = console }) => async () => {
  if (!redis?.isOpen) return fallback

  try {
    const value = await redis.get("INSURGENCY_TIME")
    const parsed = Number(value)

    return value !== null && Number.isFinite(parsed) ? parsed : fallback
  } catch (error) {
    logger.warn?.(`failed to read INSURGENCY_TIME: ${error.message}`)
    return fallback
  }
}

export const connectWithRetry = async ({
  client,
  retryMs = 1000,
  delay = ms => new Promise(resolve => setTimeout(resolve, ms)),
  isStopped = () => false,
  logger = console
}) => {
  while (!client.isOpen && !isStopped()) {
    try {
      await client.connect()
    } catch (error) {
      if (isStopped()) break

      logger.warn?.(`redis connect failed: ${error.message}`)
      try {
        await client.disconnect?.()
      } catch {
        // cliente ainda não estava conectado
      }
      await delay(retryMs)
    }
  }
}
