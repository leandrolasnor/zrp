export const DEFAULT_MAX_ATTEMPTS = 3

export const createEmitter = ({
  insurgencyTime,
  createPayload,
  fallbackTimeout = 20000,
  maxAttempts = DEFAULT_MAX_ATTEMPTS,
  wait = ms => new Promise(resolve => setTimeout(resolve, ms)),
  logger = console
}) => {
  const readTimeout = async () => {
    try {
      return await insurgencyTime()
    } catch (error) {
      logger.warn?.(`failed to read INSURGENCY_TIME: ${error.message}`)
      return fallbackTimeout
    }
  }

  const emitOccurrence = async (socket, attempt = 1) => {
    if (!socket.connected || attempt > maxAttempts) return undefined

    const payload = createPayload()
    // Espelha o log do client: registra exatamente o payload enviado ao socket.
    logger.log?.(payload)
    const timeout = await readTimeout()

    // O ACK é manual por natureza: o client só invoca o callback depois que o
    // RabbitMQ confirmar a publicação. O timeout controla a tentativa.
    socket.timeout(timeout).emit("occurrence", payload, error => {
      if (!error) return

      logger.warn?.(`occurrence ack timeout (attempt ${attempt}/${maxAttempts})`)
      emitOccurrence(socket, attempt + 1)
    })

    return timeout
  }

  // Fica ativo somente enquanto houver cliente conectado.
  const stream = async socket => {
    while (socket.connected) {
      const timeout = await emitOccurrence(socket)
      await wait(timeout ?? fallbackTimeout)
    }
  }

  return { emitOccurrence, stream }
}
