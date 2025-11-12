module UI.Screen exposing (Config, ScreenWindow, view)

import Html exposing (Html)
import Html.Attributes
import Html.Attributes.Extra
import UI.MenuBar
import UI.Wallpaper
import UI.Window
import XY exposing (XY)


type alias ScreenWindow msg =
    ( XY
    , { id : Int
      , title : String
      , content : Html msg
      , statusBar : List (UI.Window.StatusBarItem msg)
      , onClose : Maybe msg
      , onGraph : Maybe msg
      }
    )


type alias Config msg =
    -- The first window is active, the rest are in the background (dimmed)
    -- The window order determines the z-index of the windows.
    { windows : List (ScreenWindow msg)
    , onWindowDragStart : Int -> XY -> msg
    , onWindowFocus : Int -> msg
    , isDragging : Bool
    }


view : Config msg -> Html msg
view config =
    let
        maxZ =
            List.length config.windows - 1
    in
    Html.div
        [ Html.Attributes.style "width" "512px"
        , Html.Attributes.style "height" "384px"
        , Html.Attributes.style "background-image" ("url(" ++ UI.Wallpaper.erlang ++ ")")
        , Html.Attributes.style "background-size" "cover"
        , Html.Attributes.style "background-position" "center"
        , Html.Attributes.style "background-repeat" "no-repeat"
        , Html.Attributes.style "border" "8px solid #000000"
        , Html.Attributes.Extra.attributeIf config.isDragging (Html.Attributes.class "is-dragging")
        ]
        [ UI.MenuBar.view
        , Html.div [ Html.Attributes.style "position" "relative" ]
            (config.windows
                |> List.reverse
                |> List.indexedMap
                    (\z ( ( x, y ), window ) ->
                        Html.div
                            [ Html.Attributes.style "transform"
                                ("translate("
                                    ++ String.fromInt x
                                    ++ "px, "
                                    ++ String.fromInt y
                                    ++ "px)"
                                )
                            , Html.Attributes.style "z-index" (String.fromInt z)
                            , Html.Attributes.style "position" "absolute"
                            ]
                            [ UI.Window.view
                                { id = window.id
                                , title = window.title
                                , content = window.content
                                , statusBar = window.statusBar
                                , onClose = window.onClose
                                , onGraph = window.onGraph
                                , onDragStart = Just (config.onWindowDragStart window.id)
                                , onFocus =
                                    if z == maxZ || config.isDragging then
                                        Nothing

                                    else
                                        Just (config.onWindowFocus window.id)
                                , isActive = z == maxZ
                                }
                            ]
                    )
            )
        ]
