module Book exposing (main)

import Chapters.Window
import ElmBook


main : ElmBook.Book ()
main =
    ElmBook.book "Toy BEAM OS"
        |> ElmBook.withChapters
            [ Chapters.Window.chapter
            ]