module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, type_, style, href, checked)
import Html.Events exposing (onInput, onClick, onCheck)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Product =
    { name : String
    , price : Float
    , quantity : Int
    , bought : Bool
    }


updateProductName : Product -> String -> Product
updateProductName product name =
    { product | name = name }


updateProductPrice : Product -> Float -> Product
updateProductPrice product price =
    { product | price = price }


updateProductQuantity : Product -> Int -> Product
updateProductQuantity product quantity =
    { product | quantity = quantity }


updateProductBought : Product -> Bool -> Product
updateProductBought product bought =
    { product | bought = bought }

productTotal: Product -> Float
productTotal product =
    product.price * (toFloat product.quantity)


type alias Model =
    { showProductForm : Bool
    , showSearchForm : Bool
    , newProduct : Product
    }


model =
    Model False False (Product "" 0 0 False)



-- UPDATE


type Msg
    = ShowCreateProduct
    | HideCreateProduct
    | ShowSearch
    | HideSearch
    | ChangeNewProductName String
    | ChangeNewProductPrice String
    | ChangeNewProductQuantity String
    | ChangeNewProductBought Bool
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

        ChangeNewProductName name ->
            { model | newProduct = (updateProductName model.newProduct name) }

        ChangeNewProductPrice price ->
            { model | newProduct = (updateProductPrice model.newProduct (Result.withDefault 0.0 (String.toFloat price))) }

        ChangeNewProductQuantity quantity ->
            { model | newProduct = (updateProductQuantity model.newProduct (Result.withDefault 1 (String.toInt quantity))) }

        ChangeNewProductBought bought ->
            { model | newProduct = (updateProductBought model.newProduct bought) }

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
                    [ input [ type_ "text", (class "form-control"), onInput ChangeNewProductName ] []
                    ]
                ]
            , div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Precio" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "number", (class "form-control"), onInput ChangeNewProductPrice ] []
                    ]
                ]
            , div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Cantidad" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "number", (class "form-control"), onInput ChangeNewProductQuantity ] []
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
                    [ input [ type_ "checkbox", onCheck ChangeNewProductBought ] []
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
            [ a [ href "#", onClick Edit ] [ text model.newProduct.name ]
            , span [ (style [ ( "font-size", "0.8rem" ) ]) ]
                [ text " x "
                , text (toString model.newProduct.quantity)
                ]
            ]
        , td
            []
            [ span [ (style [ ( "font-size", "0.8rem" ) ]) ] [ text (toString model.newProduct.price) ]
            ]
        , td
            []
            [ text (toString (productTotal model.newProduct))
            ]
        , td
            []
            [ input [ type_ "checkbox", (checked model.newProduct.bought) ] []
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
