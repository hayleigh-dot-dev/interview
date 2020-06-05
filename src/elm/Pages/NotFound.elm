module Pages.NotFound exposing ( view )

{- Imports ------------------------------------------------------------------ -}
import Browser
import Html exposing (Html)
import Html.Attributes
import Html.Events


{- View --------------------------------------------------------------------- -}
type alias Handlers =
  {
  }

view : Handlers -> Browser.Document msg
view handlers =
  { title = ""
  , body = 
    [
    ]
  }
