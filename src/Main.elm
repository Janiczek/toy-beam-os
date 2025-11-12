module Main exposing (main)

import Browser
import Html exposing (Html)
import UI.Screen
import UI.Window


type alias Flags =
    ()


type alias Window msg =
    ( ( Int, Int )
    , { id : Int
      , title : String
      , content : Html msg
      , statusBar : List (UI.Window.StatusBarItem msg)
      , closable : Bool
      , onGraph : Maybe msg
      }
    )


type alias Model =
    { windows : List (Window Msg) }


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
                , closable = True
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
        { windows =
            model.windows
                |> List.map
                    (\( position, window ) ->
                        ( position
                        , { id = window.id
                          , title = window.title
                          , content = window.content
                          , statusBar = window.statusBar
                          , onClose =
                                if window.closable then
                                    Just (CloseWindow window.id)

                                else
                                    Nothing
                          , onGraph = window.onGraph
                          }
                        )
                    )
        }
