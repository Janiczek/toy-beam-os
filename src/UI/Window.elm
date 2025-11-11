module UI.Window exposing (Config, StatusBarItem, view)

import Html exposing (Html)
import Html.Attributes
import UI.Color exposing (color)
import UI.Divider
import UI.WindowButton
import Html.Extra

type alias Config msg =
    { title : String
    , content : Html msg
    , statusBar : List (StatusBarItem msg)
    , isActive : Bool
    , onClose : Maybe msg
    , onGraph : Maybe msg
    }


type alias StatusBarItem msg =
    { label : String
    , onClick : Maybe msg
    }


view : Config msg -> Html msg
view config =
    Html.div
        [ Html.Attributes.style "border"
            ("1px solid "
                ++ (if config.isActive then
                        color.activeWindowOuterBorder

                    else
                        color.inactiveWindowOuterBorder
                   )
            )
        , Html.Attributes.style "background-color"
            (if config.isActive then
                color.activeChromeBg

             else
                color.inactiveChromeBg
            )
        ]
        [ Html.div
            ([ [ Html.Attributes.style "border-width" "1px"
               , Html.Attributes.style "border-style" "solid"
               , Html.Attributes.style "padding" "1px 3px"
               , Html.Attributes.style "display" "flex"
               , Html.Attributes.style "flex-direction" "column"
               , Html.Attributes.style "gap" "0px"
               ]
             , if config.isActive then
                [ Html.Attributes.style "border-top-color" color.activeWindowInnerTopLeftBorder
                , Html.Attributes.style "border-left-color" color.activeWindowInnerTopLeftBorder
                , Html.Attributes.style "border-bottom-color" color.activeWindowInnerBottomRightBorder
                , Html.Attributes.style "border-right-color" color.activeWindowInnerBottomRightBorder
                ]

               else
                [ Html.Attributes.style "border-color" "transparent" ]
             ]
                |> List.concat
            )
            [ viewTitleRow config
            , viewContent config.content
            , viewStatusBar config
            ]
        ]


viewTitleRow : Config msg -> Html msg
viewTitleRow config =
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "justify-content" "space-between"
        , Html.Attributes.style "align-items" "flex-start"
        ]
        [ viewTitle config
        , viewTitleButtons config
        ]


viewTitle : Config msg -> Html msg
viewTitle { isActive, title } =
    Html.div
        [ Html.Attributes.style "padding-left" "3px"
        , Html.Attributes.style "padding-bottom" "2px"
        , Html.Attributes.style "font-family" "Charcoal, sans-serif"
        , Html.Attributes.style "color"
            (if isActive then
                color.activeWindowTitleText

             else
                color.inactiveWindowTitleText
            )
        ]
        [ Html.text title ]


viewTitleButtons : Config msg -> Html msg
viewTitleButtons config =
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "gap" "4px"
        , Html.Attributes.style "margin-right" "-1px"
        , Html.Attributes.style "margin-top" "1px"
        ]
        [ config.onGraph |> Html.Extra.viewMaybe (\onClick -> UI.WindowButton.graph { onClick = onClick })
        , config.onClose |> Html.Extra.viewMaybe (\onClick -> UI.WindowButton.close { onClick = onClick })
        ]


viewContent : Html msg -> Html msg
viewContent content =
    Html.div
        [ Html.Attributes.style "background-color" color.windowContentBg
        , Html.Attributes.style "border" ("1px solid " ++ color.windowContentBorder)
        ]
        [ content ]


viewStatusBar : Config msg -> Html msg
viewStatusBar config =
    if List.isEmpty config.statusBar then
        Html.div [ Html.Attributes.style "height" "2px" ] []

    else
        Html.div
            [ Html.Attributes.style "display" "flex"
            , Html.Attributes.style "gap" "8px"
            , Html.Attributes.style "padding-left" "4px"
            , Html.Attributes.style "padding-bottom" "4px"
            , Html.Attributes.style "padding-top" "5px"
            ]
            (List.map (viewStatusBarItem config) config.statusBar
                |> List.intersperse UI.Divider.vertical
            )


viewStatusBarItem : { config | isActive : Bool } -> StatusBarItem msg -> Html msg
viewStatusBarItem { isActive } item =
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "color"
            (if isActive then
                color.activeStatusBarText

             else
                color.inactiveStatusBarText
            )
        ]
        [ Html.text item.label ]
