module UI.Window exposing (Config, StatusBarItem, view)

import Html exposing (Html)
import Html.Attributes
import UI.Color exposing (color)
import UI.Divider


type alias Config msg =
    { title : String
    , content : Html msg
    , statusBar : List (StatusBarItem msg)
    }


type alias StatusBarItem msg =
    { label : String
    , onClick : Maybe msg
    }


view : Config msg -> Html msg
view config =
    Html.div
        [ Html.Attributes.style "border" ("1px solid " ++ color.activeWindowOuterBorder)
        , Html.Attributes.style "background-color" color.chromeBg
        ]
        [ Html.div
            [ Html.Attributes.style "border-width" "1px"
            , Html.Attributes.style "border-style" "solid"
            , Html.Attributes.style "border-top-color" color.activeWindowInnerTopLeftBorder
            , Html.Attributes.style "border-left-color" color.activeWindowInnerTopLeftBorder
            , Html.Attributes.style "border-bottom-color" color.activeWindowInnerBottomRightBorder
            , Html.Attributes.style "border-right-color" color.activeWindowInnerBottomRightBorder
            , Html.Attributes.style "padding" "1px 3px"
            ]
            [ viewWindowTitle config.title
            , viewContent config.content
            , viewStatusBar config.statusBar
            ]
        ]


viewWindowTitle : String -> Html msg
viewWindowTitle title =
    Html.div
        [ Html.Attributes.style "padding-left" "3px"
        , Html.Attributes.style "padding-bottom" "2px"
        , Html.Attributes.style "font-family" "ChiKareGo2, sans-serif"
        , Html.Attributes.style "font-size" "16px"
        , Html.Attributes.style "image-rendering" "pixelated"
        , Html.Attributes.style "text-rendering" "optimizeSpeed"
        , Html.Attributes.style "color" color.windowTitleText
        ]
        [ Html.text title ]


viewContent : Html msg -> Html msg
viewContent content =
    Html.div
        [ Html.Attributes.style "background-color" color.windowContentBg
        , Html.Attributes.style "border" ("1px solid " ++ color.windowContentBorder)
        ]
        [ content ]


viewStatusBar : List (StatusBarItem msg) -> Html msg
viewStatusBar items =
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "gap" "8px"
        , Html.Attributes.style "padding-left" "4px"
        , Html.Attributes.style "padding-bottom" "4px"
        , Html.Attributes.style "padding-top" "5px"
        ]
        (List.map viewStatusBarItem items
            |> List.intersperse UI.Divider.vertical
        )


viewStatusBarItem : StatusBarItem msg -> Html msg
viewStatusBarItem item =
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "font-family" "Geneva 9.2"
        , Html.Attributes.style "font-size" "16px"
        , Html.Attributes.style "image-rendering" "pixelated"
        , Html.Attributes.style "text-rendering" "optimizeSpeed"
        ]
        [ Html.text item.label ]
