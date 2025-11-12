module UI.Window exposing (Config, StatusBarItem, view)

import Dict
import Html exposing (Html)
import Html.Attributes
import Html.Attributes.Extra
import Html.Events
import Html.Extra
import Json.Decode
import UI.Color exposing (color)
import UI.Divider
import UI.WindowButton
import XY exposing (XY)


type alias Config msg =
    { id : Int
    , title : String
    , content : Html msg
    , statusBar : List (StatusBarItem msg)
    , isActive : Bool
    , onClose : Maybe msg
    , onGraph : Maybe msg
    , onDragStart : Maybe (XY -> msg)
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


titleRowId : Int -> String
titleRowId windowId =
    "title-row-" ++ String.fromInt windowId


viewTitleRow : Config msg -> Html msg
viewTitleRow config =
    let
        id =
            titleRowId config.id
    in
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "justify-content" "space-between"
        , Html.Attributes.style "align-items" "flex-start"
        , Html.Attributes.style "gap" "8px"
        , Html.Attributes.style "user-select" "none"
        , Html.Attributes.style "cursor" "move"
        , Html.Attributes.id id
        , config.onDragStart
            |> Html.Attributes.Extra.attributeMaybe
                (\onDragStart ->
                    onMouseDownIfNotPreventDefault { parentId = id }
                        (clientXYDecoder
                            |> Json.Decode.map onDragStart
                        )
                )
        ]
        [ viewTitleText config
        , viewTitleButtons config
        ]


viewTitleText : Config msg -> Html msg
viewTitleText config =
    Html.div
        [ Html.Attributes.style "padding-left" "3px"
        , Html.Attributes.style "padding-bottom" "2px"
        , Html.Attributes.style "padding-top" "1px"
        , Html.Attributes.style "font-family" "Charcoal, sans-serif"
        , Html.Attributes.style "color"
            (if config.isActive then
                color.activeWindowTitleText

             else
                color.inactiveWindowTitleText
            )
        ]
        [ Html.text config.title ]


clientXYDecoder : Json.Decode.Decoder XY
clientXYDecoder =
    Json.Decode.map2 XY.fromInts
        (Json.Decode.field "clientX" Json.Decode.int)
        (Json.Decode.field "clientY" Json.Decode.int)


viewTitleButtons : Config msg -> Html msg
viewTitleButtons windowConfig =
    let
        isWindowDimmed =
            not windowConfig.isActive
    in
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "gap" "4px"
        , Html.Attributes.style "margin-right" "-1px"
        , Html.Attributes.style "margin-top" "1px"
        , Html.Attributes.attribute "data-prevent-default" ""
        ]
        [ windowConfig.onGraph |> Html.Extra.viewMaybe (\onClick -> UI.WindowButton.graph { onClick = onClick, isDimmed = isWindowDimmed })
        , windowConfig.onClose |> Html.Extra.viewMaybe (\onClick -> UI.WindowButton.close { onClick = onClick, isDimmed = isWindowDimmed })
        ]


{-| If mousedown happened on an element with `data-prevent-default`, the Msg will be emitted.
-}
onMouseDownIfNotPreventDefault : { parentId : String } -> Json.Decode.Decoder msg -> Html.Attribute msg
onMouseDownIfNotPreventDefault { parentId } decoder =
    let
        verifyDescendant : Json.Decode.Value -> Json.Decode.Decoder msg
        verifyDescendant originalContext =
            Json.Decode.field "id" Json.Decode.string
                |> Json.Decode.andThen
                    (\currentId ->
                        if currentId == parentId then
                            case Json.Decode.decodeValue decoder originalContext of
                                Ok msg ->
                                    Json.Decode.succeed msg

                                Err _ ->
                                    Json.Decode.fail "didn't decode child decoder"

                        else
                            Json.Decode.field "dataset" (Json.Decode.dict Json.Decode.string)
                                |> Json.Decode.andThen
                                    (\dataset ->
                                        if Dict.member "preventDefault" dataset then
                                            Json.Decode.fail "prevent default"

                                        else
                                            Json.Decode.field "parentNode" (verifyDescendant originalContext)
                                    )
                    )
    in
    Html.Events.on "mousedown"
        (Json.Decode.value
            |> Json.Decode.andThen
                (\originalContext ->
                    Json.Decode.field "target" (verifyDescendant originalContext)
                )
        )


viewContent : Html msg -> Html msg
viewContent content =
    Html.div
        [ Html.Attributes.style "background-color" color.windowContentBg
        , Html.Attributes.style "border" ("1px solid " ++ color.windowContentBorder)
        , Html.Attributes.style "min-width" "128px"
        , Html.Attributes.style "min-height" "64px"
        , Html.Attributes.style "padding" "4px 6px"
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
