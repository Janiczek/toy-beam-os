module UI.Screen exposing (Config, view)

import Html exposing (Html)
import Html.Attributes
import UI.MenuBar
import UI.Wallpaper
import UI.Window


type alias Config msg =
    { windows : List ( ( Int, Int ), UI.Window.Config msg ) }


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
                            [ UI.Window.view window ]
                    )
            )
        ]
