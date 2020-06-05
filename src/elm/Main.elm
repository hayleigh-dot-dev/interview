module Main exposing (main)

{- Imports ------------------------------------------------------------------ -}
import Browser
import Browser.Navigation
import Dict exposing (Dict)
import Html
import Json.Decode
import Json.Encode
import Pages.Consent as Consent
import Pages.Info as Info
import Pages.NotFound as NotFound
import Pages.QSort as QSort
import Ports.WebSocket
import Url exposing (Url)
import Set


{- Main --------------------------------------------------------------------- -}
main : Program Flags Application Msg
main =
  Browser.application
    { init = init
    , update = update
    , onUrlRequest = onUrlRequest
    , onUrlChange = onUrlChange
    , view = view
    , subscriptions = subscriptions
    }


{- Model -------------------------------------------------------------------- -}
{-| -}
type alias Application =
  ( Model
  , String
  , Browser.Navigation.Key
  )

{-| -}
type alias Model =
  { pages : Dict String Page
  }

{-| -}
type Page
  = Info
  | Consent Consent.Model
  | QSort QSort.Model

{-| -}
type alias Flags =
  Json.Decode.Value

{-| -}
init : Flags -> Url -> Browser.Navigation.Key -> ( Application, Cmd Msg )
init flags url key =
  let
    qsort =
      Json.Decode.decodeValue QSort.decoder flags
        |> Result.withDefault (QSort.init "" "" Set.empty)
      
  in
  ( ( { pages =
          Dict.fromList
            [ ( "info", Info )
            , ( "consent", Consent Consent.init )
            , ( "qsort", QSort qsort )
            ]
      }
    , "info"
    , key
    )
  , Cmd.none  
  )

{- Update ------------------------------------------------------------------- -}
type Msg
  = ConsentMsg Consent.Msg
  | QSortMsg Bool QSort.Msg
  | NavigateTo String
  | NavigateOffsite String
  | None

update : Msg -> Application -> ( Application, Cmd Msg )
update msg ( model, currentPage, key ) =
  case msg of
    ConsentMsg consentMsg ->
      let
        updateConsent page =
          case page of
            Consent m -> Consent (Consent.update consentMsg m)
            _         -> page

      in
      ( ( { model
            | pages = 
                Dict.update 
                  "consent" 
                  ( Maybe.map updateConsent )
                  model.pages
          }
        , currentPage
        , key
        )
      , Cmd.none
      )

    QSortMsg external qsortMsg ->
      let
        updateQSort page =
          case page of
            QSort m -> QSort (QSort.update qsortMsg m)
            _       -> page

      in
      ( ( { model
            | pages = 
                Dict.update 
                  "qsort" 
                  ( Maybe.map updateQSort ) 
                  model.pages
          }
        , currentPage
        , key
        )
      , if external then
          Cmd.none

        else
          Ports.WebSocket.send (QSort.encodeMsg qsortMsg)
      )

    NavigateTo page ->
      ( ( model
        , page
        , key
        )
      , Browser.Navigation.pushUrl key ("#" ++ page)
      )

    NavigateOffsite url ->
      ( ( model
        , currentPage
        , key
        )
      , Browser.Navigation.load url
      )

    None ->
      ( ( model
        , currentPage
        , key
        )
      , Cmd.none
      )

{- View --------------------------------------------------------------------- -}
view : Application -> Browser.Document Msg
view ( model, currentPage, _ ) =
  case Dict.get currentPage model.pages of
    Just Info ->
      Info.view
        {
        }

    Just (Consent consentModel) ->
      Consent.view consentModel
        { tagger = ConsentMsg
        }

    Just (QSort qsortModel) ->
      QSort.view qsortModel
        { tagger = QSortMsg False
        }

    _ ->
      NotFound.view
        {
        }

{-| -}
onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest request =
  case request of
    Browser.Internal { fragment } ->
      NavigateTo <| Maybe.withDefault "info" fragment

    Browser.External url ->
      NavigateOffsite url

{-| -}
onUrlChange : Url -> Msg
onUrlChange url =
  None

{- Subscriptions ------------------------------------------------------------ -}
subscriptions : Application -> Sub Msg
subscriptions _ =
  Sub.batch
    [ Ports.WebSocket.onMessage
        QSort.msgDecoder
        (QSortMsg True)
        (always None)
    ]
