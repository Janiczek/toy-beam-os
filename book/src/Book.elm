module Book exposing (main)

import Chapters.Color
import Chapters.Divider
import Chapters.MenuBar
import Chapters.Window
import Chapters.Font
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
            , Chapters.Font.chapter
            , Chapters.Divider.chapter
            , Chapters.MenuBar.chapter
            , Chapters.WindowButton.chapter
            , Chapters.Window.chapter
            ]
