module Ui.Section exposing
  ( Builder, empty
  , withTitle, withDescription, addClass, addAttr, addChild, addChildren
  , toHtml
  )

-- Imports ---------------------------------------------------------------------
import Html as Html exposing (Html, Attribute)
import Html.Attributes

-- Types -----------------------------------------------------------------------
type alias Builder msg =
  { title : String
  , description : String
  , classes : List String
  , attrs : List (Attribute msg)
  , children : List (Html msg)
  }

empty : Builder msg
empty =
  { title = ""
  , description = ""
  , classes = []
  , attrs = []
  , children = []
  }

-- Functions -------------------------------------------------------------------
withTitle : String -> Builder msg -> Builder msg
withTitle title builder =
  { builder | title = title }

withDescription : String -> Builder msg -> Builder msg
withDescription description builder =
  { builder | description = description }

addClass : String -> Builder msg -> Builder msg
addClass class ({ classes } as builder) =
  { builder | classes = classes ++ [class] }

addAttr : Attribute msg -> Builder msg -> Builder msg
addAttr attr ({ attrs } as builder) =
  { builder | attrs = attrs ++ [attr] }

addChild : Html msg -> Builder msg -> Builder msg
addChild child ({ children } as builder) =
  { builder | children = children ++ [child] }

addChildren : List (Html msg) -> Builder msg -> Builder msg
addChildren children builder =
  { builder | children = builder.children ++ children }

-- Builders --------------------------------------------------------------------
-- standard : Builder msg
-- standard =
--   empty
--     |> withClass "container"
--     |> withClass "mx-auto"

-- standard : String -> String -> List (Attribute msg) -> List (Html msg) -> Html msg
-- standard title description attrs children =
--   Html.section (Html.Attributes.class "container mx-auto bg-gray-200 my-4 px-10 py-4 rounded-lg" :: attrs)
--     [ Html.h2 [ Html.Attributes.class "border-b-2 border-black mb-2 text-2xl text-bold" ]
--       [ Html.text title ]
--     , Html.p [ Html.Attributes.class "mb-4 text-justify" ]
--       [ Html.text description ]
--     , Html.div [ Html.Attributes.class "container" ] children
--     ]

-- full : String -> String -> List (Attribute msg) -> List (Html msg) -> Html msg
-- full title description attrs children =
--   Html.section (Html.Attributes.class "w-screen bg-gray-200 my-4 px-10 py-4 rounded-lg" :: attrs)
--     [ Html.h2 [ Html.Attributes.class "border-b-2 border-black mb-2 text-2xl text-bold" ]
--       [ Html.text title ]
--     , Html.p [ Html.Attributes.class "mb-4 text-justify" ]
--       [ Html.text description ]
--     , Html.div [ Html.Attributes.class "container" ] children
--     ]
  
-- View ------------------------------------------------------------------------
toHtml : Builder msg -> Html msg
toHtml { title, description, classes, attrs, children } =
  Html.section 
    ( Html.Attributes.class "bg-gray-200 my-4 px-10 py-4 rounded-lg"
      :: (String.join " " classes |> Html.Attributes.class)
      :: attrs )
    [ Html.h2 [ Html.Attributes.class "border-b-2 border-black mb-2 text-2xl text-bold" ]
      [ Html.text title ]
    , Html.p [ Html.Attributes.class "mb-4 text-justify" ]
      [ Html.text description ]
    , Html.div [ Html.Attributes.class "container" ] children
    ]