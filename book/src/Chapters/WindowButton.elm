module Chapters.WindowButton exposing (chapter)

import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import UI.WindowButton


buttons : List ( String, UI.WindowButton.Config msg -> Html msg )
buttons =
    [ ( "Close", UI.WindowButton.close )
    , ( "Graph", UI.WindowButton.graph )
    ]


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "WindowButton"
        |> ElmBook.Chapter.renderComponentList
            (buttons
                |> List.map
                    (\( name, button ) ->
                        ( name
                        , Html.div []
                            [ button { onClick = ElmBook.Actions.logAction "clicked button", isDimmed = False }
                            , button { onClick = ElmBook.Actions.logAction "clicked button", isDimmed = True }
                            ]
                        )
                    )
            )
