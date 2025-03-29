import { Server } from "socket.io"
import { random } from 'supervillains'
import _ from 'lodash'
import { config } from 'dotenv'
import { createClient } from 'redis'
config()

const redis = createClient({ url: process.env.REDIS_URL })
redis.on('error', err => console.log('Redis Client Error', err))
await redis.connect()
const insurgency_time = async () => await redis.get('INSURGENCY_TIME')
insurgency_time().then(async t => {
  if (Number(t) == 0) await redis.set('INSURGENCY_TIME', process.env.INSURGENCY_TIME)
})

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

const emitOccurrence = async socket => {
  let payload = occurrence()
  console.log(payload)
  insurgency_time().then(t => {
    socket.timeout(t).emit("occurrence", payload, (err) => {
      if (err) emitOccurrence(socket)
    })
  })
}

io.on("connection", (socket) => {
  emitOccurrence(socket)
});

io.listen(3003);
