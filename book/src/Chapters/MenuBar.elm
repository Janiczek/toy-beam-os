module Chapters.MenuBar exposing (chapter)

import ElmBook.Chapter
import Html
import UI.MenuBar


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "MenuBar"
        |> ElmBook.Chapter.renderComponent
               (UI.MenuBar.view)