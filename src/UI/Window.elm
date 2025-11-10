module UI.Window exposing (view)

import Html exposing (Html)


type alias Config msg =
    { title : String
    , content : Html msg
    }


view : Config msg -> Html msg
view config =
    Html.div []
        [ Html.div [] [ Html.text config.title ]
        , config.content
        ]
