module Ui.Button exposing
  ( builder
  , withText, withColour, withHandler, withAttrs, withAttr, withClass
  , toHtml
  )

-- Imports ---------------------------------------------------------------------
import Html as Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events as E
import Ui.Colour exposing (Colour)

-- Types -----------------------------------------------------------------------
type alias Button msg =
  { text : Maybe String
  , colour : Maybe Colour
  , handler : Maybe msg
  , attrs : List (Attribute msg)
  }

-- Functions -------------------------------------------------------------------
builder : Button msg
builder =
  { text = Nothing
  , colour = Nothing
  , handler = Nothing
  , attrs = []
  }

withText : String -> Button msg -> Button msg
withText text button =
  { button
  | text = Just text
  }

withColour : Colour -> Button msg -> Button msg
withColour colour button =
  { button
  | colour = Just colour
  }

withHandler : msg -> Button msg -> Button msg
withHandler handler button =
  { button
  | handler = Just handler
  }

withAttrs : List (Attribute msg) -> Button msg -> Button msg
withAttrs attrs button =
  { button
  | attrs = attrs ++ button.attrs
  }

withAttr : Attribute msg -> Button msg -> Button msg
withAttr attr button =
  { button
  | attrs = attr :: button.attrs
  }

withClass : String -> Button msg -> Button msg
withClass class button =
  { button
  | attrs = Html.Attributes.class class :: button.attrs
  }

-- Html ------------------------------------------------------------------------
toHtml : Button msg -> Html msg
toHtml button =
  let
    attrs =
      [ Maybe.map (Ui.Colour.toString >> (++) "bg-" >> Html.Attributes.class) button.colour
      , Maybe.map (Ui.Colour.darken >> Ui.Colour.toString >> (++) "hover:bg-" >> Html.Attributes.class) button.colour
      , Maybe.map E.onClick button.handler
      ] |> List.filterMap identity
  in
  Html.button (attrs ++ button.attrs)
    [ Html.text <| Maybe.withDefault "" button.text ]