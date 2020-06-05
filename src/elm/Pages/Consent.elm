module Pages.Consent exposing ( Model, init, Msg, update, view )

{- Imports ------------------------------------------------------------------ -}
import Browser
import Html exposing (Html)
import Html.Attributes
import Html.Events

{- Model -------------------------------------------------------------------- -}
type alias Model =
  {
  }

init : Model
init =
  {
  }


{- Update ------------------------------------------------------------------- -}
type Msg
  = None

update : Msg -> Model -> Model
update msg model =
  case msg of
    None ->
      model

{- View --------------------------------------------------------------------- -}
type alias Handlers msg =
  { tagger : Msg -> msg
  }

view : Model -> Handlers msg -> Browser.Document msg
view  model handlers =
  { title = ""
  , body = 
    [
    ]
  }
