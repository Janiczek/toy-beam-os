module Main exposing (main, Flags, Model, Msg)

import Browser
import Html exposing (Html)
import ScreenManager


type alias Flags =
    ()


type alias Model =
    { screenManager : ScreenManager.Model
    }


type Msg
    = ScreenManagerMsg ScreenManager.Msg


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
    ( { screenManager = ScreenManager.init }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ScreenManagerMsg subMsg ->
            ( { model
                | screenManager =
                    model.screenManager
                        |> ScreenManager.update subMsg
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    ScreenManager.subscriptions model.screenManager
        |> Sub.map ScreenManagerMsg


view : Model -> Html Msg
view model =
    ScreenManager.view model.screenManager
        |> Html.map ScreenManagerMsg
