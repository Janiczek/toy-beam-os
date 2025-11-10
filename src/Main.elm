module Main exposing (main)

import Browser
import Html exposing (Html)
import UI.Window


type alias Flags =
    ()


type alias Model =
    {}


type Msg
    = TodoMsg


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    UI.Window.view
        { title = "Hello, World!"
        , content = Html.text "Hello, World!"
        , statusBar =
            [ { label = "PID: 21", onClick = Nothing }
            ]
        }
