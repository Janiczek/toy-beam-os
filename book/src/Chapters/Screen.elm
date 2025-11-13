module Chapters.Screen exposing (chapter)

import ElmBook.Actions
import ElmBook.Chapter
import Html
import Html.Attributes
import UI.Screen


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Screen"
        |> ElmBook.Chapter.renderComponentList
            [ ( "Default"
              , UI.Screen.view
                    { windows =
                        [ ( ( 32, 64 )
                          , { id = 0
                            , title = "Hello, World!"
                            , content = Html.text "First make it work, then make it beautiful."
                            , statusBar =
                                [ { label = "PID: 21", onClick = Nothing }
                                , { label = "Msgs: 3", onClick = Nothing }
                                ]
                            , onClose = Just (ElmBook.Actions.logAction "clicked close button")
                            , onGraph = Just (ElmBook.Actions.logAction "clicked graph button")
                            }
                          )
                        , ( ( 172, 78 )
                          , { id = 1
                            , title = "System Monitor"
                            , content = Html.text ""
                            , statusBar = [ { label = "PID: 99", onClick = Nothing } ]
                            , onClose = Just (ElmBook.Actions.logAction "clicked close button")
                            , onGraph = Nothing
                            }
                          )
                        ]
                      , onWindowDragStart = \a b -> ElmBook.Actions.logActionWithString "window dragged" (Debug.toString (a,b))
                      , onWindowFocus = ElmBook.Actions.logActionWith String.fromInt "window focused"
                      , draggingWindow = Nothing
                    }
              )
            , ( "Dragging window in foreground"
              , UI.Screen.view
                    { windows =
                        [ ( ( 32, 64 )
                          , { id = 0
                            , title = "Hello, World!"
                            , content = Html.text "First make it work, then make it beautiful."
                            , statusBar =
                                [ { label = "PID: 21", onClick = Nothing }
                                , { label = "Msgs: 3", onClick = Nothing }
                                ]
                            , onClose = Just (ElmBook.Actions.logAction "clicked close button")
                            , onGraph = Just (ElmBook.Actions.logAction "clicked graph button")
                            }
                          )
                        , ( ( 172, 78 )
                          , { id = 1
                            , title = "System Monitor"
                            , content = Html.text ""
                            , statusBar = [ { label = "PID: 99", onClick = Nothing } ]
                            , onClose = Just (ElmBook.Actions.logAction "clicked close button")
                            , onGraph = Nothing
                            }
                          )
                        ]
                      , onWindowDragStart = \a b -> ElmBook.Actions.logActionWithString "window dragged" (Debug.toString (a,b))
                      , onWindowFocus = ElmBook.Actions.logActionWith String.fromInt "window focused"
                      , draggingWindow = Just 0
                    }
              )
            , ( "Dragging window in background"
              , UI.Screen.view
                    { windows =
                        [ ( ( 32, 64 )
                          , { id = 0
                            , title = "Hello, World!"
                            , content = Html.text "First make it work, then make it beautiful."
                            , statusBar =
                                [ { label = "PID: 21", onClick = Nothing }
                                , { label = "Msgs: 3", onClick = Nothing }
                                ]
                            , onClose = Just (ElmBook.Actions.logAction "clicked close button")
                            , onGraph = Just (ElmBook.Actions.logAction "clicked graph button")
                            }
                          )
                        , ( ( 172, 78 )
                          , { id = 1
                            , title = "System Monitor"
                            , content = Html.text ""
                            , statusBar = [ { label = "PID: 99", onClick = Nothing } ]
                            , onClose = Just (ElmBook.Actions.logAction "clicked close button")
                            , onGraph = Nothing
                            }
                          )
                        ]
                      , onWindowDragStart = \a b -> ElmBook.Actions.logActionWithString "window dragged" (Debug.toString (a,b))
                      , onWindowFocus = ElmBook.Actions.logActionWith String.fromInt "window focused"
                      , draggingWindow = Just 1
                    }
              )
            ]
