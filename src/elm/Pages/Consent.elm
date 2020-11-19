module Pages.Consent exposing (Model, Msg, init, update, view)

{- Imports ------------------------------------------------------------------ -}

import Browser
import Html exposing (Html)
import Html.Attributes
import Html.Events



{- Model -------------------------------------------------------------------- -}


type alias Model =
    { explained : Bool
    , withdrawal : Bool
    , understand : Bool
    , personalData : Bool
    , name : String
    , date : String
    }


init : Model
init =
    { explained = False
    , withdrawal = False
    , understand = False
    , personalData = False
    , name = ""
    , date = ""
    }


hasConsent : Model -> Bool
hasConsent { explained, withdrawal, understand, personalData } =
    explained && withdrawal && understand && personalData



{- Update ------------------------------------------------------------------- -}


type Msg
    = Toggle Checkbox
    | Input TextField String


type Checkbox
    = Explained
    | Withdrawal
    | Understand
    | PersonalData


type TextField
    = Name
    | Date


update : Msg -> Model -> Model
update msg model =
    case msg of
        Toggle Explained ->
            { model | explained = not model.explained }

        Toggle Withdrawal ->
            { model | withdrawal = not model.withdrawal }

        Toggle Understand ->
            { model | understand = not model.understand }

        Toggle PersonalData ->
            { model | personalData = not model.personalData }

        Input Name name ->
            { model | name = name }

        Input Date date ->
            { model | date = date }



{- View --------------------------------------------------------------------- -}


type alias Handlers msg =
    { tagger : Msg -> msg
    }


view : Model -> Handlers msg -> Browser.Document msg
view model handlers =
    { title = ""
    , body =
        [ Html.main_
            [ Html.Attributes.class "py-2 container md:mx-auto px-4 pt-8" ]
            [ Html.h1
                [ Html.Attributes.class "text-2xl mb-2" ]
                [ Html.text "Consent Form" ]
            , Html.p []
                [ Html.span
                    [ Html.Attributes.class "font-bold" ]
                    [ Html.text "Title of Study: " ]
                , Html.span []
                    [ Html.text "Understanding Programming Practice in Audio Software Programming" ]
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.span
                    [ Html.Attributes.class "font-bold" ]
                    [ Html.text "Queen Mary Ethics of Research Committee Ref: " ]
                , Html.span []
                    [ Html.text "2308" ]
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "Thank you for considering taking part in this research. "
                        ++ "The person organizing the research must explain the project to "
                        ++ "you before you agree to take part."
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "If you have any questions arising from the Information Sheet or "
                        ++ "explanation already given to you, please ask the researcher before "
                        ++ "you decide whether to join in. You should save a copy of this "
                        ++ "Consent Form to keep and refer to at any time. If you are willing "
                        ++ "to participate in this study, please check the appropriate "
                        ++ "responses and sign and date the declaration underneath."
                ]
            , Html.p []
                [ Html.text "You can contact the researcher at the following email address: "
                , Html.a
                    [ Html.Attributes.href "mailto:andrew.thompson@qmul.ac.uk" ]
                    [ Html.text "andrew.thompson@qmul.ac.uk" ]
                ]
            , viewConsent handlers model
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.span
                    [ Html.Attributes.class "font-bold" ]
                    [ Html.text "Participant's name: " ]
                , Html.input
                    [ Html.Attributes.class "ml-2 border-b-2"
                    , Html.Attributes.value model.name
                    , Html.Events.onInput (Input Name >> handlers.tagger)
                    ]
                    []
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.span []
                    [ Html.text "Date: " ]
                , Html.input
                    [ Html.Attributes.class "ml-2 border-b-2"
                    , Html.Attributes.value model.date
                    , Html.Events.onInput (Input Date >> handlers.tagger)
                    ]
                    []
                ]
            , Html.h2
                [ Html.Attributes.class "text-xl mt-4 mb-2" ]
                [ Html.text "Investigator's Statement:" ]
            , Html.p
                [ Html.Attributes.class "mb-4" ]
                [ Html.text <|
                    "I Andrew Thompson confirm that I have carefully explained the "
                        ++ "nature, demands and any foreseeable risks (where applicable) of "
                        ++ "the proposed research to the volunteer and provided a copy of "
                        ++ "this form."
                ]
            ]
        , Html.footer
            [ Html.Attributes.class "flex mt-4 py-2 container md:mx-auto px-4 pb-8" ]
            [ Html.a
                [ Html.Attributes.class <|
                    "flex-1 mr-10 bg-transparent hover:bg-blue-500 text-blue-700 "
                        ++ "font-semibold hover:text-white py-2 px-4 border border-blue-500 "
                        ++ "hover:border-transparent rounded"
                , Html.Attributes.href "#info"
                ]
                [ Html.text "back" ]
            , if hasConsent model then
                Html.a
                    [ Html.Attributes.class <|
                        "flex-1 ml-10 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 "
                            ++ "px-4 rounded"
                    , Html.Attributes.href "#interview"
                    ]
                    [ Html.text "next" ]

              else
                Html.button
                    [ Html.Attributes.class <|
                        "flex-1 ml-10 bg-blue-500 text-white font-bold py-2 px-4 rounded "
                            ++ "opacity-50 cursor-not-allowed"
                    ]
                    [ Html.text "next" ]
            ]
        ]
    }


viewConsent : Handlers msg -> Model -> Html msg
viewConsent handlers model =
    Html.section
        [ Html.Attributes.class "my-4" ]
        [ Html.div
            [ Html.Attributes.class "flex" ]
            [ Html.input
                [ Html.Attributes.class "flex-shrink mr-4"
                , Html.Attributes.type_ "checkbox"
                , Html.Attributes.checked model.explained
                , Html.Events.onClick (handlers.tagger <| Toggle Explained)
                ]
                []
            , Html.span
                [ Html.Attributes.class "flex-1" ]
                [ Html.text <|
                    "I agree that the research project named above has been explained to me to "
                        ++ "my satisfaction in verbal and/or written form."
                ]
            ]
        , Html.div
            [ Html.Attributes.class "flex" ]
            [ Html.input
                [ Html.Attributes.class "flex-shrink mr-4"
                , Html.Attributes.type_ "checkbox"
                , Html.Attributes.checked model.withdrawal
                , Html.Events.onClick (handlers.tagger <| Toggle Withdrawal)
                ]
                []
            , Html.span
                [ Html.Attributes.class "flex-1" ]
                [ Html.text <|
                    "I understand that if I decide at any other time during the research that I "
                        ++ "no longer wish to participate in this project, I can notify the researchers "
                        ++ "involved and be withdrawn from it immediately."
                ]
            ]
        , Html.div
            [ Html.Attributes.class "flex" ]
            [ Html.input
                [ Html.Attributes.class "flex-shrink mr-4"
                , Html.Attributes.type_ "checkbox"
                , Html.Attributes.checked model.understand
                , Html.Events.onClick (handlers.tagger <| Toggle Understand)
                ]
                []
            , Html.span
                [ Html.Attributes.class "flex-1" ]
                [ Html.text <|
                    "I have read both the notes written above and the Information Sheet about "
                        ++ "the project, and understand what the research study involves"
                ]
            ]
        , Html.div
            [ Html.Attributes.class "flex" ]
            [ Html.input
                [ Html.Attributes.class "flex-shrink mr-4"
                , Html.Attributes.type_ "checkbox"
                , Html.Attributes.checked model.personalData
                , Html.Events.onClick (handlers.tagger <| Toggle PersonalData)
                ]
                []
            , Html.span
                [ Html.Attributes.class "flex-1" ]
                [ Html.text <|
                    "I agree to take part in the study, which will include use of my "
                        ++ "personal data"
                ]
            ]
        ]
