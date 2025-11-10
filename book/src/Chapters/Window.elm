module Chapters.Window exposing (chapter)

import ElmBook.Chapter
import Html
import UI.Window


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Window"
        |> ElmBook.Chapter.renderComponent
            (UI.Window.view
                { title = "Counter"
                , content = Html.text "Test"
                , statusBar =
                    [ { label = "PID: 21", onClick = Nothing }
                    , { label = "Msgs: 3", onClick = Nothing }
                    , { label = "State", onClick = Nothing }
                    , { label = "Code", onClick = Nothing }
                    , { label = "CPU: 1% (335 r/s)", onClick = Nothing }
                    , { label = "Mem: 3 kB", onClick = Nothing }
                    ]
                }
            )
