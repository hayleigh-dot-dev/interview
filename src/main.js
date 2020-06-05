import { Elm } from './elm/Main.elm'
import * as WebSocket from './js/WebSocket.js'
import * as QItems from './js/QItems.js'

const app = Elm.Main.init({
  flags: QItems.all
})

const socket = WebSocket.init({
  toWebSocket: app.ports.toWebSocket,
  fromWebSocket: app.ports.fromWebSocket
})
