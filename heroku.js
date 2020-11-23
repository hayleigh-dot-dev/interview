const Cors = require('cors')
const Express = require('express')
const WebSocket = require('ws')

const Port = process.env.PORT || 3000

const server = Express()

server.use(Cors())
server.listen(Port)

const socket = new WebSocket.Server({ server })

const clients = {}

socket.on('connection', ws => {
  const id = Date.now()

  clients[id] = ws

  ws.on('message', data => {
    broadcast(data, ws)
  })

  ws.on('close', () => {
    delete clients[id]
  })
})

function broadcast(message, senderWs) {
  Object.values(clients).forEach(ws => {
    if (senderWs === ws) return

    ws.send(message)
  })
}