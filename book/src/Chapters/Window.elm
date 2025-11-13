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
                    { id = 0
                    , title = "Counter"
                    , content = Html.text "Test"
                    , status = UI.Window.Active
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
                    , onDragStart = Nothing
                    , onFocus = Nothing
                    }
              )
            , ( "No status bar, active"
              , UI.Window.view
                    { id = 0
                    , title = "About This Computer"
                    , content = Html.text "Test"
                    , status = UI.Window.Active
                    , statusBar = []
                    , onClose = Nothing
                    , onGraph = Nothing
                    , onDragStart = Nothing
                    , onFocus = Nothing
                    }
              )
            , ( "Full, dimmed"
              , UI.Window.view
                    { id = 0
                    , title = "Control Panels"
                    , content = Html.text "Test"
                    , status = UI.Window.Dimmed
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
                    , onDragStart = Nothing
                    , onFocus = Nothing
                    }
              )
            , ( "No status bar, dimmed"
              , UI.Window.view
                    { id = 0
                    , title = "General Controls"
                    , content = Html.text "Test"
                    , status = UI.Window.Dimmed
                    , statusBar = []
                    , onClose = Nothing
                    , onGraph = Nothing
                    , onDragStart = Nothing
                    , onFocus = Nothing
                    }
              )
            , ( "Full, dragged"
              , UI.Window.view
                    { id = 0
                    , title = "Control Panels"
                    , content = Html.text "Test"
                    , status = UI.Window.Dragged (0,0)
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
                    , onDragStart = Nothing
                    , onFocus = Nothing
                    }
              )
            , ( "No status bar, dragged"
              , UI.Window.view
                    { id = 0
                    , title = "General Controls"
                    , content = Html.text "Test"
                    , status = UI.Window.Dragged (0,0)
                    , statusBar = []
                    , onClose = Nothing
                    , onGraph = Nothing
                    , onDragStart = Nothing
                    , onFocus = Nothing
                    }
              )
            ]
