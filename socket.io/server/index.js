import { Server } from "socket.io"
import { random } from 'supervillains'
import _ from 'lodash'
import { config } from 'dotenv'

config()
const io = new Server({ /* options */ });
const occurrence = () => {
  return {
    "location": {
      "lat": Math.random() * (90 + 90) - 90,
      "lng": Math.random() * (180 + 180) - 180
    },
    "dangerLevel": _.sample(['God', 'Dragon', 'Tiger', 'Wolf']),
    "monsterName": random()
  }
}

const emitOccurrence = socket => {
  let payload = occurrence()
  console.log(payload)
  socket.timeout(process.env.INSURGENCY_TIME).emit("occurrence", payload, (err) => {
    if (err) {
      // no ack from the server, let's retry
      emitOccurrence(socket);
    }
  });
}

io.on("connection", (socket) => {
  emitOccurrence(socket)
});

io.listen(3003);
