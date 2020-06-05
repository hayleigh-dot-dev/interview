port module Ports.WebSocket exposing ( send, onMessage )

{- Imports ------------------------------------------------------------------ -}
import Json.Decode
import Json.Encode


{- Ports -------------------------------------------------------------------- -}
port toWebSocket : Json.Encode.Value -> Cmd msg
port fromWebSocket : (Json.Decode.Value -> msg) -> Sub msg


{- Functions ---------------------------------------------------------------- -}
{-| -}
send : Json.Encode.Value -> Cmd msg
send =
  toWebSocket

{-| -}
sendMany : List Json.Encode.Value -> Cmd msg
sendMany =
  List.map toWebSocket >> Cmd.batch

{-| -}
onMessage : Json.Decode.Decoder a -> (a -> msg) -> (Json.Decode.Value -> msg) -> Sub msg
onMessage decoder tagger unknown =
  fromWebSocket (\json ->
    case Json.Decode.decodeValue decoder json of
      Ok data ->
        tagger data

      Err _ ->
        unknown json
  )
