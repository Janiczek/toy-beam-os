module Chapters.Color exposing (chapter)

import ElmBook.Chapter
import Html
import Html.Attributes
import UI.Color


colorFields : List ( UI.Color.Color -> String, String )
colorFields =
    [ ( .activeWindowOuterBorder, "activeWindowOuterBorder" )
    , ( .activeWindowInnerBottomRightBorder, "activeWindowInnerBottomRightBorder" )
    , ( .activeWindowInnerTopLeftBorder, "activeWindowInnerTopLeftBorder" )
    , ( .inactiveWindowOuterBorder, "inactiveWindowOuterBorder" )
    , ( .activeChromeBg, "activeChromeBg" )
    , ( .inactiveChromeBg, "inactiveChromeBg" )
    , ( .windowContentBorder, "windowContentBorder" )
    , ( .windowContentBg, "windowContentBg" )
    , ( .windowContentCanvasBg, "windowContentCanvasBg" )
    , ( .activeStatusBarText, "activeStatusBarText" )
    , ( .inactiveStatusBarText, "inactiveStatusBarText" )
    , ( .activeWindowTitleText, "activeWindowTitleText" )
    , ( .inactiveWindowTitleText, "inactiveWindowTitleText" )
    , ( .dividerBg, "dividerBg" )
    , ( .dividerShadow, "dividerShadow" )
    ]


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Colors"
        |> ElmBook.Chapter.renderComponent
            (Html.div []
                (colorFields
                    |> List.map
                        (\( getter, name ) ->
                            Html.div
                                [ Html.Attributes.style "display" "flex"
                                , Html.Attributes.style "align-items" "center"
                                , Html.Attributes.style "margin-bottom" "8px"
                                ]
                                [ Html.div
                                    [ Html.Attributes.style "width" "32px"
                                    , Html.Attributes.style "height" "32px"
                                    , Html.Attributes.style "background-color" (getter UI.Color.color)
                                    , Html.Attributes.style "margin-right" "12px"
                                    , Html.Attributes.style "border" "1px solid #ccc"
                                    ]
                                    []
                                , Html.div [] [ Html.text name ]
                                , Html.div
                                    [ Html.Attributes.style "margin-left" "12px"
                                    , Html.Attributes.style "font-family" "monospace"
                                    , Html.Attributes.style "color" "#555"
                                    ]
                                    [ Html.text (getter UI.Color.color) ]
                                ]
                        )
                )
            )
