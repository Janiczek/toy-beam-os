module Chapters.Button exposing (chapter)

import ElmBook.Chapter
import Html
import UI.Button


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Button"
        |> ElmBook.Chapter.renderComponentList
            [ ( "Default", UI.Button.view { state = UI.Button.Default } [] [ Html.text "Default" ] )
            , ( "Active", UI.Button.view { state = UI.Button.Active } [] [ Html.text "Active" ] )
            , ( "Disabled", UI.Button.view { state = UI.Button.Disabled } [] [ Html.text "Disabled" ] )
            ]
