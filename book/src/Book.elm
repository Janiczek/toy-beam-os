module Book exposing (main)

import Chapters.Button
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
            -- Atoms
            [ Chapters.Color.chapter
            , Chapters.Font.chapter
            , Chapters.Divider.chapter
            , Chapters.Icon.chapter
            , Chapters.Button.chapter
            , Chapters.WindowButton.chapter

            -- Molecules
            , Chapters.MenuBar.chapter
            , Chapters.Window.chapter
            , Chapters.Wallpaper.chapter
            , Chapters.Screen.chapter
            ]
