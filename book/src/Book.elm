module Book exposing (main)

import Chapters.Color
import Chapters.Divider
import Chapters.Window
import Chapters.WindowButton
import ElmBook
import ElmBook.ThemeOptions


main : ElmBook.Book ()
main =
    ElmBook.book "Toy BEAM OS"
        |> ElmBook.withThemeOptions
            [ ElmBook.ThemeOptions.useHashBasedNavigation
            ]
        |> ElmBook.withChapters
            [ Chapters.Color.chapter
            , Chapters.Divider.chapter
            , Chapters.WindowButton.chapter
            , Chapters.Window.chapter
            ]
