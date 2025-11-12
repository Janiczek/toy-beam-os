module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (Html)
import Json.Decode
import UI.Screen
import UI.Window
import XY exposing (XY)


type alias Flags =
    ()


type Dragging
    = NoDragging
    | DraggingWindow { windowId : Int, startClientXY : XY, currentClientXY : XY }


type alias Window msg =
    ( XY
    , { id : Int
      , title : String
      , content : Html msg
      , statusBar : List (UI.Window.StatusBarItem msg)
      , closable : Bool
      , onGraph : Maybe msg
      }
    )


type alias Model =
    { windows : List (Window Msg)
    , dragging : Dragging
    }


type Msg
    = CloseWindow Int
    | WindowDragStart Int XY
    | DragMove XY
    | DragEnd


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
            , ( ( 172, 78 )
              , { id = 1
                , title = "System Monitor"
                , content = Html.text "Bla bla bla..."
                , statusBar = []
                , closable = False
                , onGraph = Nothing
                }
              )
            ]
      , dragging = NoDragging
      }
    , Cmd.none
    )

focusWindow : Int -> Model -> Model
focusWindow id model =
             { model
                | windows =
                    model.windows
                        |> List.sortBy
                            (\( _, window ) ->
                                if window.id == id then
                                    0

                                else
                                    1
                            )
              }

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

        WindowDragStart id position ->
            if model.dragging == NoDragging then
                ( { model
                    | dragging =
                        DraggingWindow
                            { windowId = id
                            , startClientXY = position
                            , currentClientXY = position
                            }
                  }
                  |> focusWindow id
                , Cmd.none
                )

            else
                ( model, Cmd.none )

        DragMove newClientXY ->
            ( { model
                | dragging =
                    case model.dragging of
                        NoDragging ->
                            NoDragging

                        DraggingWindow draggingWindow ->
                            DraggingWindow { draggingWindow | currentClientXY = newClientXY }
              }
            , Cmd.none
            )

        DragEnd ->
            ( case model.dragging of
                NoDragging ->
                    model

                DraggingWindow draggingWindow ->
                    { model
                        | dragging = NoDragging
                        , windows =
                            model.windows
                                |> List.map
                                    (\( position, window ) ->
                                        if window.id == draggingWindow.windowId then
                                            ( XY.add
                                                position
                                                (XY.sub
                                                    draggingWindow.currentClientXY
                                                    draggingWindow.startClientXY
                                                )
                                            , window
                                            )

                                        else
                                            ( position, window )
                                    )
                    }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.dragging /= NoDragging then
        Sub.batch
            [ Browser.Events.onMouseMove
                (Json.Decode.map2 (\x y -> DragMove ( x, y ))
                    (Json.Decode.field "clientX" Json.Decode.int)
                    (Json.Decode.field "clientY" Json.Decode.int)
                )
            , Browser.Events.onMouseUp (Json.Decode.succeed DragEnd)
            ]

    else
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
        , onWindowDragStart = WindowDragStart
        }
