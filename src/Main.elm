module Main exposing (main)

import Browser
import Html exposing (Html)
import UI.Screen


type alias Flags =
    ()


type alias Model =
    { windows : List (UI.Screen.ScreenWindow Msg) }


type Msg
    = CloseWindow Int


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init () =
    ( { windows =
            [ ( ( 32, 64 )
              , { id = 0
                , title = "Hello, World!"
                , content = Html.text "Try to close this window."
                , statusBar =
                    [ { label = "PID: 21", onClick = Nothing }
                    ]
                , onClose = Just (CloseWindow 0)
                , onGraph = Nothing
                }
              )
            ]
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CloseWindow id ->
            ( { model
                | windows =
                    model.windows
                        |> List.filter (\( _, window ) -> window.id /= id)
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    UI.Screen.view
        { windows = model.windows }
