module ScreenManager exposing
    ( Config, Model, Msg(..), init, update, view, subscriptions
    , onProcessStopped, setProcessView
    , Dragging(..), Window
    )

{-|

@docs Config, Model, Msg, init, update, view, subscriptions
@docs onProcessStopped, setProcessView
@docs Dragging, Window

-}

import Browser.Events
import Cmd.Extra
import Dict exposing (Dict)
import Html exposing (Html)
import Json.Decode
import JsonUI exposing (JsonUI)
import PID exposing (PID)
import UI.Screen
import UI.Window
import XY exposing (XY)


type alias Config msg =
    { msg : Msg -> msg
    , onCloseWindow : PID -> msg
    }


type alias Model =
    { windows : Dict PID (Window Msg)
    , zOrder : List PID
    , dragging : Dragging
    }


type Msg
    = CloseWindow PID
    | WindowFocus PID
    | WindowDragStart PID XY
    | DragMove XY
    | DragEnd


type Dragging
    = NoDragging
    | DraggingWindow
        { windowPid : PID
        , startClientXY : XY
        , currentClientXY : XY
        }


type alias Window msg =
    { position : XY
    , pid : PID
    , title : String
    , jsonUi : JsonUI
    , statusBar : List (UI.Window.StatusBarItem msg)
    , closable : Bool
    , onGraph : Maybe msg
    }


init : Model
init =
    let
        win0 : Window Msg
        win0 =
            { position = ( 32, 64 )
            , pid = 0
            , title = "Hello, World!"
            , jsonUi =
                JsonUI.Text
                    { attributes = Dict.empty
                    , content = "Try to close this window."
                    }
            , statusBar =
                [ { label = "PID: 21", onClick = Nothing }
                ]
            , closable = True
            , onGraph = Nothing
            }

        win1 : Window Msg
        win1 =
            { position = ( 172, 78 )
            , pid = 1
            , title = "System Monitor"
            , jsonUi =
                JsonUI.Text
                    { attributes = Dict.empty
                    , content = "Bla bla bla..."
                    }
            , statusBar = []
            , closable = False
            , onGraph = Nothing
            }
    in
    { windows =
        Dict.fromList
            [ ( win0.pid, win0 )
            , ( win1.pid, win1 )
            ]
    , zOrder = [ win0.pid, win1.pid ]
    , dragging = NoDragging
    }


view : Model -> Html Msg
view model =
    UI.Screen.view
        { windows =
            model.zOrder
                |> List.filterMap
                    (\pid ->
                        Dict.get pid model.windows
                            |> Maybe.map
                                (\window ->
                                    ( window.position
                                    , { id = window.pid
                                      , title = window.title
                                      , content = JsonUI.view window.jsonUi
                                      , statusBar = window.statusBar
                                      , onClose =
                                            if window.closable then
                                                Just (CloseWindow window.pid)

                                            else
                                                Nothing
                                      , onGraph = window.onGraph
                                      }
                                    )
                                )
                    )
        , onWindowDragStart = WindowDragStart
        , onWindowFocus = WindowFocus
        , draggingWindow =
            case model.dragging of
                NoDragging ->
                    Nothing

                DraggingWindow draggingWindow ->
                    Just
                        ( draggingWindow.windowPid
                        , XY.sub
                            draggingWindow.currentClientXY
                            draggingWindow.startClientXY
                        )
        }


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


update : Config msg -> Msg -> Model -> ( Model, Cmd msg )
update config msg model =
    case msg of
        CloseWindow pid ->
            ( { model
                | windows = Dict.remove pid model.windows
                , zOrder = List.filter ((/=) pid) model.zOrder
              }
            , config.onCloseWindow pid
                |> Cmd.Extra.perform
            )

        WindowFocus pid ->
            ( model
                |> focusWindow pid
            , Cmd.none
            )

        WindowDragStart pid position ->
            if model.dragging == NoDragging then
                ( { model
                    | dragging =
                        DraggingWindow
                            { windowPid = pid
                            , startClientXY = position
                            , currentClientXY = position
                            }
                  }
                    |> focusWindow pid
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
            case model.dragging of
                NoDragging ->
                    ( model, Cmd.none )

                DraggingWindow draggingWindow ->
                    let
                        updatePosition window =
                            if window.pid == draggingWindow.windowPid then
                                { window
                                    | position =
                                        XY.add
                                            window.position
                                            (XY.sub
                                                draggingWindow.currentClientXY
                                                draggingWindow.startClientXY
                                            )
                                }

                            else
                                window
                    in
                    ( { model
                        | dragging = NoDragging
                        , windows =
                            Dict.update
                                draggingWindow.windowPid
                                (Maybe.map updatePosition)
                                model.windows
                      }
                    , Cmd.none
                    )


focusWindow : PID -> Model -> Model
focusWindow pid model =
    let
        withoutPid =
            List.filter ((/=) pid) model.zOrder
    in
    { model | zOrder = pid :: withoutPid }


onProcessStopped : PID -> Model -> Model
onProcessStopped pid model =
    { model
        | windows = Dict.remove pid model.windows
        , zOrder = List.filter ((/=) pid) model.zOrder
    }


setProcessView : PID -> JsonUI -> Model -> Model
setProcessView pid jsonUi model =
    case Dict.get pid model.windows of
        Nothing ->
            model
                |> addProcessView pid jsonUi

        Just window ->
            model
                |> replaceProcessView pid jsonUi window


addProcessView : PID -> JsonUI -> Model -> Model
addProcessView pid jsonUi model =
    { model
        | windows =
            model.windows
                |> Dict.insert pid (initWindow pid jsonUi)
        , zOrder = pid :: model.zOrder -- by the virtue of adding it from the front, we incidentally focused it
    }


replaceProcessView : PID -> JsonUI -> Window Msg -> Model -> Model
replaceProcessView pid jsonUi window model =
    { model
        | windows =
            model.windows
                |> Dict.insert pid { window | jsonUi = jsonUi }
    }
        |> focusWindow pid


initWindow : PID -> JsonUI -> Window Msg
initWindow pid jsonUi =
    { position = ( 24, 24 )
    , pid = pid
    , title = "TODO: make JsonUI provide a title"
    , jsonUi = jsonUi
    , statusBar =
        [ { label = "PID: " ++ String.fromInt pid, onClick = Nothing }
        , { label = "TODO provide with JsonUI", onClick = Nothing }
        ]
    , closable = True
    , onGraph = Nothing
    }
