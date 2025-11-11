module UI.WindowButton exposing (close, graph)

import Html exposing (Html)
import Html.Attributes
import Html.Events

close : { onClick : msg } -> Html msg
close config =
    windowButton "imgs/close-buttons.svg" config

graph : { onClick : msg } -> Html msg
graph config =
    windowButton "imgs/graph-buttons.svg" config

windowButton : String -> { onClick : msg } -> Html msg
windowButton url { onClick } =
    Html.button
        [ -- see .window-button in style.css
          Html.Attributes.class "window-button"
        , Html.Attributes.style "background-image" ("url(" ++ url ++ ")")
        , Html.Attributes.style "cursor" "pointer"
        , Html.Attributes.style "width" "13px"
        , Html.Attributes.style "height" "13px"
        , Html.Attributes.style "border" "0"
        , Html.Events.onClick onClick
        ]
        []
