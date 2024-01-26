import { io } from "socket.io-client";
import amqp from "amqplib";
import { config } from 'dotenv'

config()

const queue = "threats";

const send_event = async (data) => {
  let connection;
  try {
    connection = await amqp.connect(`${process.env.AMQP_SERVER}`);
    const channel = await connection.createChannel();

    await channel.assertQueue(queue, { durable: true });
    channel.sendToQueue(queue, Buffer.from(JSON.stringify(data)));
    console.log(data);
    await channel.close();
  } catch (err) {
    console.warn(err);
  } finally {
    if (connection) await connection.close();
  }
}

// const socket = io('https://zrp-challenges-dev-production.up.railway.app');
const socket = io(`${process.env.SOCKET_IO_SERVER}:${process.env.SOCKET_IO_SERVER_PORT}`);
socket.on("connect", () => {
  console.log('Connected');
});
socket.on("disconnect", () => {
  console.log("disconnect"); // false
});
socket.on("occurrence", (data) => {
  send_event(data)
});
