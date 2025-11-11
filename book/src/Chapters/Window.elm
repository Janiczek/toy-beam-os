module Chapters.Window exposing (chapter)

import ElmBook.Actions
import ElmBook.Chapter
import Html
import UI.Window


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Window"
        |> ElmBook.Chapter.renderComponentList
            [ ( "Full, active"
              , UI.Window.view
                    { title = "Counter"
                    , content = Html.text "Test"
                    , isActive = True
                    , statusBar =
                        [ { label = "PID: 21", onClick = Nothing }
                        , { label = "Msgs: 3", onClick = Nothing }
                        , { label = "State", onClick = Nothing }
                        , { label = "Code", onClick = Nothing }
                        , { label = "CPU: 1% (335 r/s)", onClick = Nothing }
                        , { label = "Mem: 3 kB", onClick = Nothing }
                        ]
                    , onClose = Just (ElmBook.Actions.logAction "clicked close button")
                    , onGraph = Just (ElmBook.Actions.logAction "clicked graph button")
                    }
              )
            , ( "No status bar, active"
              , UI.Window.view
                    { title = "About This Computer"
                    , content = Html.text "Test"
                    , isActive = True
                    , statusBar = []
                    , onClose = Nothing
                    , onGraph = Nothing
                    }
              )
            , ( "Full, inactive"
              , UI.Window.view
                    { title = "Control Panels"
                    , content = Html.text "Test"
                    , isActive = False
                    , statusBar =
                        [ { label = "PID: 21", onClick = Nothing }
                        , { label = "Msgs: 3", onClick = Nothing }
                        , { label = "State", onClick = Nothing }
                        , { label = "Code", onClick = Nothing }
                        , { label = "CPU: 1% (335 r/s)", onClick = Nothing }
                        , { label = "Mem: 3 kB", onClick = Nothing }
                        ]
                    , onClose = Nothing
                    , onGraph = Nothing
                    }
              )
            , ( "No status bar, inactive"
              , UI.Window.view
                    { title = "General Controls"
                    , content = Html.text "Test"
                    , isActive = False
                    , statusBar = []
                    , onClose = Nothing
                    , onGraph = Nothing
                    }
              )
            ]
