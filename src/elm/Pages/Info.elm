module Pages.Info exposing (view)

{- Imports ------------------------------------------------------------------ -}

import Browser
import Html exposing (Html)
import Html.Attributes
import Html.Events



{- View --------------------------------------------------------------------- -}


type alias Handlers =
    {}


view : Handlers -> Browser.Document msg
view handlers =
    { title = "Participant Information"
    , body =
        [ Html.main_
            [ Html.Attributes.class "py-2 container md:mx-auto px-4 pt-8" ]
            [ Html.h1
                [ Html.Attributes.class "text-2xl mb-2" ]
                [ Html.text "Information Sheet" ]
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
            , Html.img
                [ Html.Attributes.src "images/qmul-logo.png"
                , Html.Attributes.class "mx-auto my-2"
                ]
                []
            , Html.p
                [ Html.Attributes.class "mb-2 font-bold" ]
                [ Html.text "Information for Participants" ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "We would like to invite you to be part of this research project, "
                        ++ "if you would like to. You should only agree to take part if you want "
                        ++ "to, it is entirely up to you. If you choose not to take part there "
                        ++ "won’t be any disadvantages for you and you will hear no more about it."
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "Please read the following information carefully before you decide "
                        ++ "to take part; this will tell you why the research is being done and "
                        ++ "what you will be asked to do if you take part. Please ask if there "
                        ++ "is anything that is not clear or if you would like more information."
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "If you decide to take part you will be asked to complete a short "
                        ++ "consent form to say that you agree."
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "You are always free to withdraw at any time and without giving "
                        ++ "a reason."
                ]
            , Html.hr
                [ Html.Attributes.class "border"
                ]
                []
            , Html.section
                [ Html.Attributes.class "my-4" ]
                [ Html.p
                    [ Html.Attributes.class "mb-2 font-bold" ]
                    [ Html.text "About the Study" ]
                , Html.p
                    [ Html.Attributes.class "mb-2" ]
                    [ Html.text <|
                        "In this study we are interested in discovering the different "
                            ++ "types of programming practice found in audio software programming. "
                            ++ "Someone's programming practice refers to details about how they "
                            ++ "might program, how long they program for, what tools they use, and "
                            ++ "so on. In particular, we're interested in responses from programmers "
                            ++ "that create "
                    , Html.span
                        [ Html.Attributes.class "italic" ]
                        [ Html.text "interactive audio applications" ]
                    , Html.text "."
                    ]
                , Html.p
                    [ Html.Attributes.class "mb-2" ]
                    [ Html.text <|
                        "This information could be useful when attempting to evaluate "
                            ++ "existing programming languages and libraries for audio software "
                            ++ "programming, as well as providing a possible guide for any future "
                            ++ "languages or tools."
                    ]
                , Html.p
                    [ Html.Attributes.class "mb-2" ]
                    [ Html.text <|
                        "In this study you will be interviewed about your programming practice. "
                            ++ "This will include questions about the sort of things you make, "
                            ++ "the language(s) you use, and the features you like and dislike "
                            ++ "about those languages. Additionally you will be asked to complete "
                            ++ "an exercise that has you rating various programming language features "
                            ++ "according to their affect on your programming practice. There might "
                            ++ "be some features you are unfamiliar with in this task, this is OK! "
                            ++ "This study targets developers from a wide range of backgrounds. "
                            ++ "The interviewer will do their best to explain the feature and ask "
                            ++ "that you imagine what impact that feature might have if it was "
                            ++ "present in the languages you are familiar with."
                    ]
                ]
            , Html.hr
                [ Html.Attributes.class "border mb-2"
                ]
                []
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "It is up to you to decide whether or not to take part. If you do "
                        ++ "decide to take part you should save this information sheet to "
                        ++ "keep. On the next page you will be asked to fill in a consent "
                        ++ "form that you may also want to keep."
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "Please read Queen Mary’s privacy notice for research participants "
                        ++ "for important information about your personal data and your rights "
                        ++ "in this respect, available "
                , Html.a
                    [ Html.Attributes.class "underline"
                    , Html.Attributes.href "http://www.arcs.qmul.ac.uk/media/arcs/policyzone/Privacy-Notice-for-Research-Participants.pdf"
                    ]
                    [ Html.text "here" ]
                , Html.text "."
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "If you have any questions or concerns about the manner in which the "
                        ++ "study was conducted please, in the first instance, contact the researcher "
                        ++ "responsible for the study. If this is unsuccessful, or not appropriate, "
                        ++ "please contact the Secretary at the Queen Mary Ethics of Research Committee, "
                        ++ "Room W104, Queens’ Building, Mile End Campus, Mile End Road, London, E1 "
                        ++ "4NS or research-ethics@qmul.ac.uk."
                ]
            , Html.p
                [ Html.Attributes.class "mb-2" ]
                [ Html.text <|
                    "If you have any questions relating to data protection, please contact "
                        ++ "Data Protection Officer, Queens’ Building, Mile End Road, London, E1 "
                        ++ "4NS or data-protection@qmul.ac.uk."
                ]
            ]
        , Html.footer
            [ Html.Attributes.class "flex mt-4 py-2 container md:mx-auto px-4 pb-8" ]
            [ Html.span
                [ Html.Attributes.class "flex-1 mr-10" ]
                []
            , Html.a
                [ Html.Attributes.class <|
                    "flex-1 ml-10 bg-blue-500 hover:bg-blue-700 text-white font-bold "
                        ++ "py-2 px-4 rounded"
                , Html.Attributes.href "#consent"
                ]
                [ Html.text "next" ]
            ]
        ]
    }
