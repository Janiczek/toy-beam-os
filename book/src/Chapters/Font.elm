module Chapters.Font exposing (chapter)

import ElmBook.Chapter
import Html
import Html.Attributes


fonts : List String
fonts =
    [ "Charcoal"
    , "ChiKareGo2"
    , "Geneva9.2"
    ]


chapter : ElmBook.Chapter.Chapter x
chapter =
    ElmBook.Chapter.chapter "Font"
        |> ElmBook.Chapter.renderComponentList
            (fonts
                |> List.map
                    (\font ->
                        ( font
                        , Html.div
                            [ Html.Attributes.style "font-family" font
                            , Html.Attributes.style "display" "flex"
                            , Html.Attributes.style "flex-direction" "column"
                            , Html.Attributes.style "gap" "4px"
                            ]
                            [ Html.div [] [ Html.text font ]
                            , Html.div [] [ Html.text "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ]
                            , Html.div [] [ Html.text "abcdefghijklmnopqrstuvwxyz" ]
                            , Html.div [] [ Html.text "0123456789" ]
                            , Html.div [] [ Html.text "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" ]
                            , Html.div [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit." ]
                            ]
                        )
                    )
            )
