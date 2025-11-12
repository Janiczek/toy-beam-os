module Chapters.Icon exposing (chapter)

import ElmBook.Chapter
import Html
import Html.Attributes
import UI.Icon


icons_16_16 : List ( String, UI.Icon.Icon_16_16 -> String )
icons_16_16 =
    [ ( "logo", .logo )
    ]


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Icon"
        |> ElmBook.Chapter.renderComponentList
            (icons_16_16
                |> List.map (\( name, getter ) -> ( name, UI.Icon.view_16_16 getter ))
            )
