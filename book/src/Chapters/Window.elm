module Chapters.Window exposing (chapter)

import ElmBook.Chapter
import UI.Window
import Html


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Window"
        |> ElmBook.Chapter.renderComponent
          (UI.Window.view { title = "Test"
          , content = Html.text "Test" })