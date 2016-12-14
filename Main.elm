module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    String


model =
    ""


type Msg
    = Name String
    | Edit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            name

        Edit ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div [ (class "container") ]
        [ button [ (classList [ ( "btn", True ), ( "btn-primary", True ) ]) ] [ text "Agregar" ]
        , button [ (classList [ ( "btn", True ), ( "btn-default", True ) ]) ] [ text "Buscar" ]
        , button [ (class "pull-right") ] [ totals model ]
        , searchForm model
        , addForm model
        , div [ (class "container") ]
            [ table [ (classList [ ( "table", True ), ( "table-condensed", True ) ]) ]
                [ thead []
                    [ tr []
                        [ th [] [ text "" ]
                        , th [] [ text "Nombre" ]
                        , th [] [ text "Precio" ]
                        , th [] [ text "Total" ]
                        , th [] [ text "Comprado" ]
                        ]
                    ]
                , tbody []
                    [ productRow model
                    , productRow model
                    , productRow model
                    , productRow model
                    , productRow model
                    , productRow model
                    ]
                ]
            ]
        ]


totals model =
    div []
        [ text "0/0"
        ]


searchForm model =
    div []
        [ div [ (class "form-group") ]
            [ input [ type_ "text", (class "form-control") ] []
            , button [] [ text "x" ]
            ]
        ]


addForm model =
    div []
        [ div [ (class "form-group") ]
            [ label [ (class "control-label") ]
                [ text "Nombre"
                ]
            , input [ type_ "text", (class "form-control") ] []
            ]
        , div [ (class "form-group") ]
            [ label [ (class "control-label") ]
                [ text "Precio"
                ]
            , input [ type_ "number", (class "form-control") ] []
            ]
        , div [ (class "form-group") ]
            [ label [ (class "control-label") ]
                [ text "Cantidad"
                ]
            , input [ type_ "number", (class "form-control") ] []
            , button [] [ text "+" ]
            , button [] [ text "-" ]
            ]
        , div [ (class "form-group") ]
            [ label [ (class "control-label") ]
                [ text "Comprado"
                ]
            , input [ type_ "checkbox" ] []
            ]
        , button [ (classList [ ( "btn", True ), ( "btn-primary", True ) ]) ] [ text "Crear" ]
        , button [ (classList [ ( "btn", True ), ( "btn-default", True ) ]) ] [ text "Cancelar" ]
        ]


productRow model =
    tr []
        [ td []
            [ button [ (classList [ ( "btn", True ), ( "btn-danger", True ) ]) ] [ text "-" ]
            ]
        , td
            []
            [ a [ href "#", onClick Edit ] [ text "cell 2" ]
            ]
        , td
            []
            [ text "100"
            ]
        , td
            []
            [ text "100"
            ]
        , td
            []
            [ text "-"
            ]
        ]
