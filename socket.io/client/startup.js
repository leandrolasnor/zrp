export const createStartup = ({ socket, amqpConnection, handleOccurrence, logger = console }) => {
  let started = false

  const isReady = () =>
    socket.connected && Boolean(amqpConnection.connection)

  const start = async () => {
    await Promise.all([
      new Promise(resolve => {
        if (socket.connected) return resolve()
        socket.once("connect", resolve)
      }),
      amqpConnection.connect()
    ])

    if (started || !isReady()) return false

    socket.on("occurrence", handleOccurrence)
    started = true
    logger.log?.("ready (socket.io + rabbitmq)")
    return true
  }

  const stop = () => {
    if (!started) return
    socket.off("occurrence", handleOccurrence)
    started = false
  }

  return { start, stop, isReady, get started () { return started } }
}
