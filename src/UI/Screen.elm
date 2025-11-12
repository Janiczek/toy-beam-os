module UI.Screen exposing (Config, ScreenWindow, view)

import Html exposing (Html)
import Html.Attributes
import UI.MenuBar
import UI.Wallpaper
import UI.Window


type alias ScreenWindow msg =
    ( ( Int, Int )
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
    }


view : Config msg -> Html msg
view config =
    Html.div
        [ Html.Attributes.style "width" "512px"
        , Html.Attributes.style "height" "384px"
        , Html.Attributes.style "background-image" ("url(" ++ UI.Wallpaper.erlang ++ ")")
        , Html.Attributes.style "background-size" "cover"
        , Html.Attributes.style "background-position" "center"
        , Html.Attributes.style "background-repeat" "no-repeat"
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

                                -- Right now, all windows are active. Let's figure out how we want the dimmed background windows to work.
                                , isActive = True
                                }
                            ]
                    )
            )
        ]
