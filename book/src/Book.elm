module Book exposing (main)

import Chapters.Color
import Chapters.Divider
import Chapters.Font
import Chapters.Icon
import Chapters.MenuBar
import Chapters.Screen
import Chapters.Wallpaper
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
            , Chapters.Font.chapter
            , Chapters.Divider.chapter
            , Chapters.Icon.chapter
            , Chapters.WindowButton.chapter

            --
            , Chapters.MenuBar.chapter
            , Chapters.Window.chapter
            , Chapters.Wallpaper.chapter
            , Chapters.Screen.chapter
            ]
