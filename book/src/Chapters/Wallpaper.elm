module Chapters.Wallpaper exposing (chapter)

import ElmBook.Chapter
import Html
import Html.Attributes
import UI.Wallpaper


wallpapers : List ( String, String )
wallpapers =
    [ ( "erlang", UI.Wallpaper.erlang )
    ]


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Wallpaper"
        |> ElmBook.Chapter.renderComponentList
            (wallpapers
                |> List.map
                    (\( name, url ) ->
                        ( name
                        , Html.div
                            [ Html.Attributes.style "background-image" ("url(" ++ url ++ ")")
                            , Html.Attributes.style "width" "512px"
                            , Html.Attributes.style "height" "384px"
                            , Html.Attributes.style "background-size" "contain"
                            , Html.Attributes.style "background-position" "center"
                            , Html.Attributes.style "background-repeat" "no-repeat"
                            ]
                            []
                        )
                    )
            )
