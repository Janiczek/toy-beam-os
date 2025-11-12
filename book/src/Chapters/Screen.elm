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
                          , { title = "Hello, World!"
                            , content = Html.text "First make it work, then make it beautiful."
                            , isActive = True
                            , statusBar =
                                [ { label = "PID: 21", onClick = Nothing }
                                , { label = "Msgs: 3", onClick = Nothing }
                                ]
                            , onClose = Just (ElmBook.Actions.logAction "clicked close button")
                            , onGraph = Just (ElmBook.Actions.logAction "clicked graph button")
                            }
                          )
                        , ( ( 172, 78 )
                          , { title = "System Monitor"
                            , content = Html.text ""
                            , isActive = False
                            , statusBar = [ { label = "PID: 99", onClick = Nothing } ]
                            , onClose = Just (ElmBook.Actions.logAction "clicked close button")
                            , onGraph = Nothing
                            }
                          )
                        ]
                    }
              )
            ]
