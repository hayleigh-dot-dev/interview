module Pages.QSort exposing 
  ( Model, decoder, init
  , Msg, encodeMsg, msgDecoder
  , update
  , view 
  )

{- Imports ------------------------------------------------------------------ -}
import Browser
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode
import Json.Encode
import Maybe.Extra
import Set exposing (Set)
import Ui.Button
import Ui.Colour
import Ui.Section

{- Model -------------------------------------------------------------------- -}
{-| -}
type Model
  = BasicSort BasicData
  | NormalSort NormalData

{-| -}
isComplete : Model -> Bool
isComplete qsort =
  case qsort of
    BasicSort _ ->
      False

    NormalSort { unsorted } ->
      List.length unsorted == 0

{-| -}
type alias BasicData =
  { title : String
  , description : String
  , statements : List Statement
  , unsorted : List Statement
  , selected : Maybe Statement
  }

{-| -}
type alias NormalData =
  { title : String
  , description : String
  , statements : List (Maybe Statement)
  , unsorted : List Statement
  , selected : Maybe Statement
  , length : Int
  , shape : List Int
  }

{-| -}
type alias Statement =
  { title : String
  , key : String
  , description : List String
  , image : Maybe String
  , rating : Rating
  }

{-| -}
type Rating
  = Negative
  | Neutral
  | Positive

{-| -}
init : String -> String -> Set String -> Model
init title description items =
  BasicSort
    { title = title
    , description = description
    , statements = []
    , unsorted = Set.toList items |> List.map (\s -> Statement s "" [] Nothing Neutral)
    , selected = Nothing
    }


{- Update ------------------------------------------------------------------- -}
{-| -}
type Msg
  = None
  | Select Statement
  | Rate Rating
  | Sort Int
  | StepForward
  | StepBackward

{-| -}
update : Msg -> Model -> Model
update msg model =
  case ( msg, model ) of
    ( None, _ ) ->
      model

    {- Select --------------------------------------------------------------- -}
    ( Select statement , BasicSort ({ statements, unsorted, selected } as data) ) ->
      if Just statement == selected then
        BasicSort { data | selected = Nothing }
      else if List.member statement statements || List.member statement unsorted then
        BasicSort { data | selected = Just statement }
      else
        BasicSort { data | selected = Nothing }

    ( Select statement, NormalSort ({ statements, unsorted, selected } as data) ) ->
      if Just statement == selected then
        NormalSort { data | selected = Nothing }
      else if List.member (Just statement) statements || List.member statement unsorted then
        NormalSort { data | selected = Just statement }
      else
        NormalSort { data | selected = Nothing }

    {- Rate ---------------------------------------------------------------- -}
    ( Rate rating, BasicSort ({ statements, unsorted, selected } as data) ) ->
      BasicSort
        { data 
          | unsorted = 
              unsorted |> List.filterMap (Just >> (\s -> 
                if s == selected then 
                  Nothing 
                else 
                  s
              ))
          , statements =
              statements
                |> List.filterMap (Just >> (\s -> if s == selected then Nothing else s))
                |> Just
                |> Maybe.map2 (::) (Maybe.map (\s -> { s | rating = rating }) selected)
                |> Maybe.withDefault statements
          , selected =
              Nothing
        }

    ( Rate rating, NormalSort ({ statements, unsorted, selected } as data) ) ->
      NormalSort
        { data
          | unsorted =
              if List.member selected statements then
                List.map Just unsorted
                  |> (::) (Maybe.map (\s -> { s | rating = rating }) selected)
                  |> List.filterMap identity
              else
                unsorted |> List.map (\s ->
                  if Just s == selected then 
                    { s | rating = rating}
                  else
                    s
                )
          , statements =
              statements |> List.map (\s ->
                if s /= selected then
                  s
                else
                  Nothing
              )
        }

    {- Sort ----------------------------------------------------------------- -}
    ( Sort _, BasicSort data ) ->
      BasicSort data

    ( Sort position, NormalSort ({ statements, unsorted, selected } as data) ) ->
      NormalSort
        { data
          | statements =
              statements |> List.indexedMap (\i s ->
                if i == position && Maybe.Extra.isJust selected then
                  selected
                else if i /= position && s == selected then
                  Nothing
                else
                  s
              )
          , unsorted =
              unsorted |> List.filter (Just >> (/=) selected)
          , selected = Nothing
        }

    {- StepForward ---------------------------------------------------------- -}
    ( StepForward, BasicSort { title, description, statements } ) ->
      let
        nearestSquare : Int -> Int
        nearestSquare n =
          Basics.toFloat n
            |> Basics.sqrt
            |> Basics.round
            |> \x -> x ^ 2

        squareRoot : Int -> Int
        squareRoot n =
          Basics.toFloat n
          |> Basics.sqrt
          |> Basics.round
      in
      NormalSort
        { title = title
        , description = description
        , statements = List.repeat (List.length statements |> nearestSquare) Nothing
        , unsorted = statements
        , selected = Nothing
        , length = List.length statements |> nearestSquare
        , shape = 
            List.length statements 
              |> nearestSquare 
              |> squareRoot
              |> (\root -> List.range 1 root ++ (List.reverse <| List.range 1 <| root - 1))
        }

    ( StepForward, NormalSort data ) ->
      NormalSort data

    {- StepBackward --------------------------------------------------------- -}
    ( StepBackward, BasicSort data ) ->
      BasicSort data

    ( StepBackward, NormalSort { title, description, statements, unsorted } ) ->
      BasicSort
        { title = title
        , description = description
        , statements = []
        , unsorted = unsorted ++ List.filterMap identity statements
        , selected = Nothing
        }


{- View --------------------------------------------------------------------- -}
{-| -}
type alias Handlers msg =
  { tagger : Msg -> msg
  }

{-| -}
ratingToString : Rating -> String
ratingToString rating =
  case rating of
    Negative  -> "Negative"
    Neutral   -> "Neutral"
    Positive  -> "Positive"

{-| -}
view : Model -> Handlers msg -> Browser.Document msg
view model handlers =
  { title = ""
  , body = 
    [ Html.main_
      [ Html.Attributes.class "container md:mx-auto px-4 pt-8" ]
      [ case model of
          BasicSort data ->
            viewBasicSort data
              |> Html.map handlers.tagger

          NormalSort data ->
            viewNormalSort data
              |> Html.map handlers.tagger
      ]
    , Html.footer
      [ Html.Attributes.class "flex mt-4 py-2 container md:mx-auto px-4 pb-8" ]
      [ Html.a
        [ Html.Attributes.class 
            <| "flex-1 mr-10 bg-transparent hover:bg-blue-500 text-blue-700 "
            ++ "font-semibold hover:text-white py-2 px-4 border border-blue-500 "
            ++ "hover:border-transparent rounded"
        , Html.Attributes.href "#2" 
        ]
        [ Html.text "back" ]
      , if isComplete model then
          Html.a
            [ Html.Attributes.class 
                <| "flex-1 ml-10 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 "
                ++ "px-4 rounded"
            , Html.Attributes.href "#success"
            ]
            [ Html.text "submit" ]
        else
          Html.button
            [ Html.Attributes.class 
                <| "flex-1 ml-10 bg-blue-500 text-white font-bold py-2 px-4 rounded "
                ++ "opacity-50 cursor-not-allowed"
            ]
            [ Html.text "submit" ]
      ]
    ]
  }

{-| -}
viewBasicSort : BasicData -> Html Msg
viewBasicSort { title, description, statements, unsorted, selected } =
  let
    instructions =
      Html.div
        []
        [ Html.h3 
          [ Html.Attributes.class "font-bold text-xl" ]
          [ Html.text "Instructions" ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "For this part of the exercise you must rate features on whether "
              ++ "they might have a positive or negative effect on your programming "
              ++ "practice, or none at all."
          ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "Select an item from the list on the left. A description and "
              ++ "sometimes an image will appear on the right. This can be helpful "
              ++ "if you're not familiar with the feature being described."
          ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "The language features you'll be presented with come from a variety "
              ++ "of different languages and paradigms, and examples have been chosen "
              ++ "to exemplify how and where they're most typically used. Try not "
              ++ "to focus too much on the syntax of a particular example (unless "
              ++ "the syntax is the main focus of that example) and instead try "
              ++ "to imagine that feature's impact regardless of whether your preferred "
              ++ "language does or can support it."
          ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "We estimate this task will take around 30 minutes, dependent on "
              ++ "your familiarity with each of the features presented. Don't forget "
              ++ "you are free to leave this questionnaire and return at a later "
              ++ "time, your progress is saved."
          ]
        , Html.hr [ Html.Attributes.class "border border-black mb-4" ] []
        ]

    unsortedList =
      Html.div [ Html.Attributes.class "flex my-2 h-96" ]
        [ Html.div [ Html.Attributes.class "flex-1 mr-4" ]
          [ viewStatementList selected Select unsorted ]
        , Html.div [ Html.Attributes.class "flex-1 overflow-y-scroll overflow-x-hidden" ]
          [ selected |> Maybe.map viewStatementInfo
              |> Maybe.withDefault (Html.text "")
          ]
        ]

    controls =
      Html.div [ Html.Attributes.class "flex my-2" ]
        [ Ui.Button.builder
            |> Ui.Button.withText "Negative"
            |> Ui.Button.withColour (Ui.Colour.lighten Ui.Colour.red)
            |> Ui.Button.withHandler (Rate Negative)
            |> Ui.Button.withClass "flex-1 p-2 mr-4" 
            |> Ui.Button.toHtml
        , Ui.Button.builder
            |> Ui.Button.withText "Neutral"
            |> Ui.Button.withColour (Ui.Colour.lighten Ui.Colour.grey)
            |> Ui.Button.withHandler (Rate Neutral)
            |> Ui.Button.withClass "flex-1 p-2 mx-2" 
            |> Ui.Button.toHtml
        , Ui.Button.builder
            |> Ui.Button.withText "Positive"
            |> Ui.Button.withColour (Ui.Colour.lighten Ui.Colour.green)
            |> Ui.Button.withHandler (Rate Positive)
            |> Ui.Button.withClass "flex-1 p-2 ml-4" 
            |> Ui.Button.toHtml
        ]

    sortedList =
      Html.div [ Html.Attributes.class "flex mt-4 h-64" ]
        [ Html.div [ Html.Attributes.class "flex-1 mr-4" ]
          [ List.filter (.rating >> (==) Negative) statements
              |> viewStatementList selected Select
          ]
        , Html.div [ Html.Attributes.class "flex-1 mx-2" ]
          [ List.filter (.rating >> (==) Neutral) statements
              |> viewStatementList selected Select
          ]
        , Html.div [ Html.Attributes.class "flex-1 ml-4" ]
          [ List.filter (.rating >> (==) Positive) statements
              |> viewStatementList selected Select
          ]
        ]

    nextButton =
      Html.div [ Html.Attributes.class "flex mb-4" ]
        [ Ui.Button.builder
          |> Ui.Button.withText "Next Step"
          |> Ui.Button.withColour (
            if List.isEmpty unsorted then
              Ui.Colour.blue
            else
              Ui.Colour.grey
          )
          |> Ui.Button.withHandler StepForward
          |> Ui.Button.withClass "flex-1 p-2"
          |> Ui.Button.withClass (
            if List.isEmpty unsorted then
              ""
            else
              "cursor-not-allowed"
          )
          |> Ui.Button.withAttr (Html.Attributes.disabled (not <| List.isEmpty unsorted))
          |> Ui.Button.toHtml
        ]
  in
  Ui.Section.empty
    |> Ui.Section.withTitle title
    |> Ui.Section.withDescription description
    |> Ui.Section.addClass "container mx-auto"
    |> Ui.Section.addAttr (Html.Attributes.attribute "data-q-sort" "basic")
    |> Ui.Section.addChild instructions
    |> Ui.Section.addChild unsortedList
    |> Ui.Section.addChild controls
    |> Ui.Section.addChild sortedList
    |> Ui.Section.addChild nextButton
    |> Ui.Section.toHtml

{-| -}
viewNormalSort : NormalData -> Html Msg
viewNormalSort { title, description, statements, unsorted, selected, shape, length } =
  let
    instructions =
      Html.div
        []
        [ Html.h3 
          [ Html.Attributes.class "font-bold text-xl" ]
          [ Html.text "Instructions" ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "In this part of the exercise you'll need to arrange the features "
              ++ "you just rated from most negatively impactful to your practice "
              ++ "to most positively impactful."
          ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "A rating of -5 corresponds to 'Most Negatively Impactful' and "
              ++ "a rating of 5 corresponds to 'Most Positively Impactful'. Ratings "
              ++ "closer to 0 indicate that the feature has little to no impact "
              ++ "on your practice. For ratings that hold more than on feature, "
              ++ "there is no signficance to ordering. This means that two items "
              ++ "rated at 3 have roughly the same impact on your practice."
          ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "Start by picking out the most impactful features and working your "
              ++ "way inwoards. Don't worry if you have more items in one category "
              ++ "than another, the scale is relative. This means a feature rated "
              ++ "at -5 isn't necessarily as impactful as a feature rated at 5."
          ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "The language features you'll be presented with come from a variety "
              ++ "of different languages and paradigms, and examples have been chosen "
              ++ "to exemplify how and where they're most typically used. Try not "
              ++ "to focus too much on the syntax of a particular example (unless "
              ++ "the syntax is the main focus of that example) and instead try "
              ++ "to imagine that feature's impact regardless of whether your preferred "
              ++ "language does or can support it."
          ]
        , Html.p
          [ Html.Attributes.class "mb-2" ]
          [ Html.text
              <| "We estimate this task will take around 30 minutes, dependent on "
              ++ "your familiarity with each of the features presented. Don't forget "
              ++ "you are free to leave this questionnaire and return at a later "
              ++ "time, your progress is saved."
          ]
        , Html.hr [ Html.Attributes.class "border border-black mb-4" ] []
        ]

    statementInfo =
      Html.div [ Html.Attributes.class "flex h-96 overflow-y-scroll mb-4" ]
        ( selected |> Maybe.map viewSplitStatementInfo
            |> Maybe.withDefault [ Html.text "" ]
        )

    normalDistribution =
      Html.div [ Html.Attributes.class "flex justify-between my-2" ]
        ( List.indexedMap Tuple.pair statements
            |> viewNormalDistribution selected shape
        )

    sortButtons =
      Html.div [ Html.Attributes.class "flex my-2" ]
        [ Ui.Button.builder
            |> Ui.Button.withText "Negative"
            |> Ui.Button.withColour (Ui.Colour.lighten Ui.Colour.red)
            |> Ui.Button.withHandler (Rate Negative)
            |> Ui.Button.withClass "flex-1 p-2 mr-4" 
            |> Ui.Button.toHtml
        , Ui.Button.builder
            |> Ui.Button.withText "Neutral"
            |> Ui.Button.withColour (Ui.Colour.lighten Ui.Colour.grey)
            |> Ui.Button.withHandler (Rate Neutral)
            |> Ui.Button.withClass "flex-1 p-2 mx-2" 
            |> Ui.Button.toHtml
        , Ui.Button.builder
            |> Ui.Button.withText "Positive"
            |> Ui.Button.withColour (Ui.Colour.lighten Ui.Colour.green)
            |> Ui.Button.withHandler (Rate Positive)
            |> Ui.Button.withClass "flex-1 p-2 ml-4" 
            |> Ui.Button.toHtml
        ]

    unsortedList =
      Html.div [ Html.Attributes.class "flex my-2 h-64" ]
        [ Html.div [ Html.Attributes.class "flex-1 mr-4" ]
          [ List.filter (.rating >> (==) Negative) unsorted
              |> viewStatementList selected Select
          ]
        , Html.div [ Html.Attributes.class "flex-1 mx-2" ]
          [ List.filter (.rating >> (==) Neutral) unsorted
              |> viewStatementList selected Select
          ]
        , Html.div [ Html.Attributes.class "flex-1 ml-4" ]
          [ List.filter (.rating >> (==) Positive) unsorted
              |> viewStatementList selected Select
          ]
        ]
  in
  Ui.Section.empty
    |> Ui.Section.withTitle title
    |> Ui.Section.withDescription description
    |> Ui.Section.addClass "container mx-auto"
    |> Ui.Section.addAttr (Html.Attributes.attribute "data-q-sort" "normal")
    |> Ui.Section.addChild instructions
    |> Ui.Section.addChildren
      [ statementInfo
      , Html.hr [ Html.Attributes.class "border border-black mb-4" ] []
      , Html.div [ Html.Attributes.class "flex justify-between my-2" ]
        ( length 
            |> Basics.toFloat 
            |> Basics.sqrt 
            |> (*) 2 
            |> Basics.floor
            |> (\n -> n - 2)
            |> List.range 0
            |> List.map (\n -> n + 1 - (length |> Basics.toFloat |> Basics.sqrt |> Basics.floor))
            |> List.map (\n -> 
              Html.span 
                [ Html.Attributes.class "flex-1 mx-2 text-center font-bold" ] 
                [ Html.text (String.fromInt n) ]
            )
        )
      , normalDistribution
      , Html.hr [ Html.Attributes.class "border border-black mb-4" ] []
      , sortButtons
      , unsortedList
      ]
    |> Ui.Section.toHtml

{-| -}
viewStatementList : Maybe Statement -> (Statement -> msg) -> List Statement -> Html msg
viewStatementList selected handler statements =
  Html.ul [ Html.Attributes.class "h-full overflow-y-scroll overflow-x-hidden" ]
    ( statements |> List.map (\statement ->
        viewStatementItem (Just statement == selected) (handler statement) statement
      )
    ) 

{-| -}
viewStatementItem : Bool -> msg -> Statement ->  Html msg
viewStatementItem active handler { title, key } =
  Html.li 
    [ Html.Events.onClick handler
    , Html.Attributes.class "cursor-pointer my-2 p-2"
    , if active then
        Html.Attributes.class "bg-blue-300 hover:bg-blue-500"
      else
        Html.Attributes.class "bg-gray-300 hover:bg-gray-400"
    ] 
    [ Html.span [ Html.Attributes.class "font-bold pr-2" ] [ Html.text <| "[" ++ key ++ "]" ]
    , Html.span [ Html.Attributes.class "text-justify" ] [ Html.text title ]
    ]

{-| -}
viewStatementInfo : Statement -> Html msg
viewStatementInfo { title, description, image } =
  Html.div
    []
    [ Html.h3 [ Html.Attributes.class "text-xl font-bold mb-4" ] 
      [ Html.text title ]
    , image |> Maybe.map (\src ->
        Html.img [ Html.Attributes.src src, Html.Attributes.class "w-full" ] []
      ) |> Maybe.withDefault (Html.text "")
    , Html.div [] ( description |> List.map (\text ->
        Html.p [ Html.Attributes.class "text-justify py-2 pr-4" ] 
          [ Html.text text ]
      ))
    ]

{-| -}
viewSplitStatementInfo : Statement -> List (Html msg)
viewSplitStatementInfo { title, description, image } =
  [ Html.div [ Html.Attributes.class "flex-1 pr-4" ]
    [ Html.h3 [ Html.Attributes.class "text-xl font-bold" ] 
      [ Html.text title ]
    , Html.div [] ( description |> List.map (\text ->
        Html.p [ Html.Attributes.class "py-2 text-justify" ] 
          [ Html.text text ]
      ))
    ]
  , Html.div [ Html.Attributes.class "flex-1 pl-4" ]
    [ image |> Maybe.map (\src ->
        Html.img [ Html.Attributes.src src, Html.Attributes.class "w-full" ] []
      ) |> Maybe.withDefault (Html.text "")
    ]
  ]

{-| -}
viewNormalDistribution : Maybe Statement -> List Int -> List (Int, Maybe Statement) -> List (Html Msg)
viewNormalDistribution selectedStatement items statements =
  List.foldl (\n  (ns, ss) -> List.take n ss |> (\ss_ -> (ss_ :: ns, List.drop n ss))) ([], statements) items
    |> Tuple.first
    |> List.map (\ss ->
      Html.ul [ Html.Attributes.class "flex-1 mx-2 flex-col" ]
        ( ss |> List.map (viewQSortItem selectedStatement)
        )
    )  

{-| -}
viewQSortItem : Maybe Statement -> (Int, Maybe Statement) -> Html Msg
viewQSortItem selectedStatement (n, s) =
  case s of
    Just ({ key } as statement) ->
      Html.li
        [ Html.Attributes.class "w-full mb-2 h-10 hover:bg-blue-500 rounded flex content-center items-center align-center cursor-pointer" 
        , if selectedStatement == s then
            Html.Attributes.class "bg-blue-300"
          else
            Html.Attributes.class "bg-gray-400"
        , Html.Events.onClick (Select statement) ]
        [ Html.div
          [ Html.Attributes.class "font-bold p-2 mx-auto" ]
          [ Html.text <| "[" ++ key ++ "]" ]
        ]

    Nothing ->
      Html.li
        [ Html.Attributes.class "w-full mb-2 h-10 bg-gray-400 hover:bg-gray-500 rounded flex content-center align-center cursor-pointer" 
        , Html.Events.onClick (Sort n)
        ] []

{- JSON decoders ------------------------------------------------------------ -}
{-| -}
decoder : Json.Decode.Decoder Model
decoder =
  let
    basicData title description statements unsorted =
      { title = title
      , description = description
      , statements = statements
      , unsorted = unsorted
      , selected = Nothing
      }

    nearestSquare n =
      Basics.toFloat n
        |> Basics.sqrt
        |> Basics.round
        |> \x -> x ^ 2

    squareRoot n =
      Basics.toFloat n
       |> Basics.sqrt
       |> Basics.round

    normalData title description statements unsorted length =
      { title = title
      , description = description
      , statements = statements
      , unsorted = unsorted
      , selected = Nothing
      , length = length
      , shape = 
          List.length statements 
            |> nearestSquare 
            |> squareRoot
            |> (\root -> List.range 1 root ++ (List.reverse <| List.range 1 <| root - 1))
      }

  in
  Json.Decode.field "type" Json.Decode.string |> Json.Decode.andThen (\t ->
    case t of
      "BasicSort" ->
        Json.Decode.map BasicSort <| Json.Decode.map4 basicData
          ( Json.Decode.field "title" Json.Decode.string )
          ( Json.Decode.field "description" Json.Decode.string )
          ( Json.Decode.field "statements" 
              <| Json.Decode.list statementDecoder )
          ( Json.Decode.field "unsorted" 
              <| Json.Decode.list statementDecoder )

      "NormalSort" ->
        Json.Decode.map NormalSort <| Json.Decode.map5 normalData
          ( Json.Decode.field "title" Json.Decode.string )
          ( Json.Decode.field "description" Json.Decode.string )
          ( Json.Decode.field "statements" 
              <| Json.Decode.list 
              <| Json.Decode.nullable statementDecoder )
          ( Json.Decode.field "unsorted" 
              <| Json.Decode.list statementDecoder )
          ( Json.Decode.field "length" Json.Decode.int )
          -- (Decode.field "shape" <| Decode.list Decode.int)

      _ ->
        Json.Decode.fail <| "Unknown type: " ++ t
  )

{-| -}
msgDecoder : Json.Decode.Decoder Msg
msgDecoder =
  Json.Decode.field "$" Json.Decode.string |> Json.Decode.andThen (\t ->
    case t of
      "None" -> 
        Json.Decode.succeed None

      "Select" ->
        Json.Decode.map Select
          ( Json.Decode.field "data" statementDecoder )

      "Rate" ->
        Json.Decode.map Rate
          ( Json.Decode.field "data" ratingDecoder )

      "Sort" ->
        Json.Decode.map Sort
          ( Json.Decode.field "data" Json.Decode.int )

      "StepForward" ->
        Json.Decode.succeed StepForward

      "StepBackward" ->
        Json.Decode.succeed StepBackward

      _ ->
        Json.Decode.fail <| "Unknown msg: " ++ t
  )

{-| -}
statementDecoder : Json.Decode.Decoder Statement
statementDecoder =
  Json.Decode.map5 Statement
    ( Json.Decode.field "title" Json.Decode.string )
    ( Json.Decode.field "key" Json.Decode.string )
    ( Json.Decode.field "description" 
        <| Json.Decode.list Json.Decode.string )
    ( Json.Decode.field "image"
        <| Json.Decode.nullable Json.Decode.string )
    ( Json.Decode.field "rating" ratingDecoder )

{-| -}
ratingDecoder : Json.Decode.Decoder Rating
ratingDecoder =
  Json.Decode.string |> Json.Decode.andThen (\r ->
    case r of
      "Negative"  -> Json.Decode.succeed Negative
      "Neutral"   -> Json.Decode.succeed Neutral
      "Positive"  -> Json.Decode.succeed Positive
      _           -> Json.Decode.fail <| "Unknown rating: " ++ r
  )

{- JSON encoders ------------------------------------------------------------ -}
{-| -}
encodeMsg : Msg -> Json.Encode.Value
encodeMsg msg =
  case msg of
    None ->
      Json.Encode.object
        [ ( "$", Json.Encode.string "None" )
        ]

    Select statement ->
      Json.Encode.object
        [ ( "$", Json.Encode.string "Select" )
        , ( "data", encodeStatement statement )
        ]
  
    Rate rating ->
      Json.Encode.object
        [ ( "$", Json.Encode.string "Rate" )
        , ( "data", encodeRating rating )
        ]
  
    Sort position ->
      Json.Encode.object
        [ ( "$", Json.Encode.string "Sort" )
        , ( "data", Json.Encode.int position )
        ]
  
    StepForward ->
      Json.Encode.object
        [ ( "$", Json.Encode.string "StepForward" )
        ]
  
    StepBackward ->
      Json.Encode.object
        [ ( "$", Json.Encode.string "StepBackward" )
        ]

{-| -}
encodeStatement : Statement -> Json.Encode.Value
encodeStatement { title, key, description, image, rating } =
  Json.Encode.object
    [ ( "title", Json.Encode.string title )
    , ( "key", Json.Encode.string key )
    , ( "description", Json.Encode.list Json.Encode.string description )
    , ( "image", Maybe.withDefault Json.Encode.null 
          <| Maybe.map Json.Encode.string image )
    , ( "rating", encodeRating rating )
    ]

{-| -}
encodeRating : Rating -> Json.Encode.Value
encodeRating rating =
  ratingToString rating
    |> Json.Encode.string
