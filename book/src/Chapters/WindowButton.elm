module Chapters.WindowButton exposing (chapter)

import ElmBook.Actions
import ElmBook.Chapter
import UI.WindowButton


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "WindowButton"
        |> ElmBook.Chapter.renderComponentList
            [ ( "Close"
              , UI.WindowButton.close { onClick = ElmBook.Actions.logAction "clicked close button" }
              )
            , ( "Graph"
              , UI.WindowButton.graph { onClick = ElmBook.Actions.logAction "clicked graph button" }
              )
            ]
