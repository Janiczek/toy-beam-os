module Chapters.Window exposing (chapter)

import ElmBook.Actions
import ElmBook.Chapter
import Html exposing (Html)
import Html.Attributes
import UI.Window


notFullWidth : Html msg -> Html msg
notFullWidth content =
    Html.div
        [ Html.Attributes.style "max-width" "480px"
        , Html.Attributes.style "width" "fit-content"
        , Html.Attributes.style "position" "relative"
        ]
        [ content ]


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Window"
        |> ElmBook.Chapter.renderComponentList
            [ ( "Full, active"
              , notFullWidth <|
                    UI.Window.view
                        { id = 0
                        , title = "Counter"
                        , content = Html.text "Test"
                        , status = UI.Window.Active { isDragging = False }
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
              , notFullWidth <|
                    UI.Window.view
                        { id = 0
                        , title = "About This Computer"
                        , content = Html.text "Test"
                        , status = UI.Window.Active { isDragging = False }
                        , statusBar = []
                        , onClose = Nothing
                        , onGraph = Nothing
                        , onDragStart = Nothing
                        , onFocus = Nothing
                        }
              )
            , ( "Full, dimmed"
              , notFullWidth <|
                    UI.Window.view
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
              , notFullWidth <|
                    UI.Window.view
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
              , notFullWidth <|
                    UI.Window.view
                        { id = 0
                        , title = "Control Panels"
                        , content = Html.text "Test"
                        , status = UI.Window.Active { isDragging = True }
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
              , notFullWidth <|
                    UI.Window.view
                        { id = 0
                        , title = "General Controls"
                        , content = Html.text "Test"
                        , status = UI.Window.Active { isDragging = True }
                        , statusBar = []
                        , onClose = Nothing
                        , onGraph = Nothing
                        , onDragStart = Nothing
                        , onFocus = Nothing
                        }
              )
            , ( "Drag ghost"
              , notFullWidth <|
                    Html.div
                        [ Html.Attributes.class UI.Window.draggedWindowClass
                        , Html.Attributes.style "width" "240px"
                        , Html.Attributes.style "height" "64px"
                        ]
                        []
              )
            ]
