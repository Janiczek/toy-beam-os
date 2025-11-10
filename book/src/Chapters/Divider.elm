module Chapters.Divider exposing (chapter)

import ElmBook.Chapter
import Html
import Html.Attributes
import UI.Divider


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Divider"
        |> ElmBook.Chapter.renderComponentList
            [ ( "Vertical"
              , Html.div
                    [ Html.Attributes.style "height" "10px"
                    , Html.Attributes.style "display" "flex"
                    ]
                    [ UI.Divider.vertical ]
              )
            ]
