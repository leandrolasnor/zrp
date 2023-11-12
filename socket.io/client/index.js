import { io } from "socket.io-client";
import amqp from "amqplib";

const queue = "threats";

const send_event = async (data) => {
  let connection;
  try {
    connection = await amqp.connect("amqp://rabbitmq:5672");
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
const socket = io('http://socket.io.server:3003');
socket.on("connect", () => {
  console.log('Connected');
});
socket.on("disconnect", () => {
  console.log("disconnect"); // false
});
socket.on("occurrence", (data) => {
  send_event(data)
});
