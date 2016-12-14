module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, type_, style, href)
import Html.Events exposing (onInput, onClick)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { showProductForm : Bool
    , showSearchForm : Bool
    }


model =
    Model False False



-- UPDATE


type Msg
    = ShowCreateProduct
    | HideCreateProduct
    | ShowSearch
    | HideSearch
    | Edit


update : Msg -> Model -> Model
update msg model =
    case msg of
        ShowCreateProduct ->
            { model | showProductForm = True }

        HideCreateProduct ->
            { model | showProductForm = False }

        ShowSearch ->
            { model | showSearchForm = True }

        HideSearch ->
            { model | showSearchForm = False }

        Edit ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div [ (class "container") ]
        [ button [ (classList [ ( "btn", True ), ( "btn-primary", True ) ]), onClick ShowCreateProduct ] [ text "Agregar" ]
        , button [ (classList [ ( "btn", True ), ( "btn-default", True ) ]), onClick ShowSearch ] [ text "Buscar" ]
        , button [ (classList [ ( "btn", True ), ( "btn-default", True ), ( "navbar-btn", True ), ( "pull-right", True ) ]) ] [ totals model ]
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
        , footerLinks
        ]


totals model =
    div []
        [ text "0/0"
        ]


searchForm model =
    div [ (classList [ ( "hidden", not model.showSearchForm ) ]) ]
        [ div [ (class "form-group") ]
            [ input [ type_ "text", (class "form-control") ] []
            , button [ onClick HideSearch ] [ text "x" ]
            ]
        ]


addForm model =
    div [ (classList [ ( "hidden", not model.showProductForm ) ]) ]
        [ form [ (class "form-inline") ]
            [ div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Nombre" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "text", (class "form-control") ] []
                    ]
                ]
            , div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Precio" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "number", (class "form-control") ] []
                    ]
                ]
            , div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Cantidad" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "number", (class "form-control") ] []
                    , button [] [ text "+" ]
                    , button [] [ text "-" ]
                    ]
                ]
            , div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Comprado" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "checkbox" ] []
                    ]
                ]
            , button [ (classList [ ( "btn", True ), ( "btn-primary", True ) ]) ] [ text "Crear" ]
            , button [ (classList [ ( "btn", True ), ( "btn-default", True ) ]), onClick HideCreateProduct ] [ text "Cancelar" ]
            ]
        ]


productRow model =
    tr [ (classList [ ( "comprado", True ) ]) ]
        [ td []
            [ button [ (classList [ ( "btn", True ), ( "btn-danger", True ) ]) ] [ text "-" ]
            ]
        , td
            []
            [ a [ href "#", onClick Edit ] [ text "cell 2" ]
            , span [ (style [ ( "font-size", "0.8rem" ) ]) ]
                [ text " x "
                , text "1"
                ]
            ]
        , td
            []
            [ span [ (style [ ( "font-size", "0.8rem" ) ]) ] [ text "100" ]
            ]
        , td
            []
            [ text "100"
            ]
        , td
            []
            [ input [ type_ "checkbox" ] []
            ]
        ]


footerLinks =
    ul [ (class "list-inline") ]
        [ li [] [ a [] [ text "Limpiar Lista" ] ]
        , li [] [ text "|" ]
        , li [] [ a [] [ text "Exportar Lista" ] ]
        , li [] [ text "|" ]
        , li [] [ a [] [ text "Importar Lista" ] ]
        ]
