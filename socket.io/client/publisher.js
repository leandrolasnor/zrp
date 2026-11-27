export const QUEUE = "un"

// O cliente é apenas um forwarder: não inspeciona nem valida o que vem do server.
// O canal é um ConfirmChannel (ver amqp.js): `waitForConfirms` só resolve
// depois que o broker confirma a publicação, e é isso que habilita o ACK
// ao socket.io/server.
export const createPublisher = ({ amqpConnection, queue = QUEUE, logger = console }) => async message => {
  return amqpConnection.withChannel(async channel => {
    await channel.assertQueue(queue, {
      durable: true,
      arguments: {
        "x-dead-letter-exchange": "un.dlx"
      }
    })

    const confirmed = channel.sendToQueue(queue, Buffer.from(message), { persistent: true })

    if (confirmed === false) {
      throw new Error("rabbitmq backpressure: message not sent")
    }

    await channel.waitForConfirms()

    // Só entra no log o que o broker confirmou; falhas não são registradas aqui.
    logger.log?.(message)
    return true
  })
}
