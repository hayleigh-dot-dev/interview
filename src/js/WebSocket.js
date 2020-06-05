export function init (elm) {
  const ws = new WebSocket('ws://qmul-qsort.herokuapp.com/')

  // When the socket connection opens, set up the subscription from elm so we
  // can start sending data.
  ws.onopen = () => {
    elm.toWebSocket.subscribe(data => {
      ws.send(
        JSON.stringify(data)
      )
    })
  }

  // When the socket receives a message just parse it and send it straight to
  // elm.
  ws.onmessage = ({ data }) => {
    elm.fromWebSocket.send(
      JSON.parse(data)
    )
  }
}
