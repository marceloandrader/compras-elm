module Main exposing (..)

import Task
import Date exposing (Date)
import Date.Format exposing (format)
import Html exposing (..)
import Html.Attributes exposing (class, classList, type_, style, href, checked, value)
import Html.Events exposing (onInput, onClick, onCheck, onSubmit)


main =
    Html.program
        { init = model
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Product =
    { id : Int
    , name : String
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


updateProductId : Product -> Int -> Product
updateProductId product id =
    { product | id = id }


productTotal : Product -> Float
productTotal product =
    product.price * (toFloat product.quantity)


otherProduct : Product -> Product -> Bool
otherProduct product1 product2 =
    product1.id /= product2.id


type alias Model =
    { showProductForm : Bool
    , showSearchForm : Bool
    , newProduct : Product
    , latestId : Int
    , productList : List Product
    }


model =
    (Model False False (Product 0 "" 0 0 False) 1 [], Cmd.none)



-- UPDATE


type Msg
    = ShowCreateProduct
    | ShowCreateProductAfter Date
    | HideCreateProduct
    | ShowSearch
    | HideSearch
    | ChangeNewProductName String
    | ChangeNewProductPrice String
    | ChangeNewProductQuantity String
    | ChangeNewProductBought Bool
    | SaveNewProduct
    | RemoveProduct Product
    | Edit


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ShowCreateProduct ->
            ({ model | showProductForm = True }, Task.perform ShowCreateProductAfter Date.now)

        ShowCreateProductAfter date ->
            ({ model | newProduct = (Product 0 (Date.Format.format "%m/%d " date) 0 1 False) }, Cmd.none)

        HideCreateProduct ->
            ({ model | showProductForm = False }, Cmd.none)

        ShowSearch ->
            ({ model | showSearchForm = True }, Cmd.none)

        HideSearch ->
            ({ model | showSearchForm = False }, Cmd.none)

        ChangeNewProductName name ->
            ({ model | newProduct = (updateProductName model.newProduct name) }, Cmd.none)

        ChangeNewProductPrice price ->
            ({ model | newProduct = (updateProductPrice model.newProduct (Result.withDefault 0.0 (String.toFloat price))) }, Cmd.none)

        ChangeNewProductQuantity quantity ->
            ({ model | newProduct = (updateProductQuantity model.newProduct (Result.withDefault 1 (String.toInt quantity))) }, Cmd.none)

        ChangeNewProductBought bought ->
            ({ model | newProduct = (updateProductBought model.newProduct bought) }, Cmd.none)

        SaveNewProduct ->
            ({ model
                | latestId = (model.latestId + 1)
                , newProduct = (updateProductId model.newProduct model.latestId)
                , productList = model.newProduct :: model.productList
            }, Cmd.none)

        RemoveProduct product ->
            ({ model | productList = List.filter (otherProduct product) model.productList }, Cmd.none)

        Edit ->
            (model, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
      Sub.none

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
                    (List.map productRow model.productList)
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


addForm : Model -> Html Msg
addForm model =
    div [ (classList [ ( "hidden", not model.showProductForm ) ]) ]
        [ form [ (class "form-inline"), onSubmit SaveNewProduct ]
            [ div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Nombre" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "text", (class "form-control"), onInput ChangeNewProductName, (value model.newProduct.name) ] []
                    ]
                ]
            , div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Precio" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "number", (class "form-control"), onInput ChangeNewProductPrice, (value (toString model.newProduct.price)) ] []
                    ]
                ]
            , div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Cantidad" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "number", (class "form-control"), onInput ChangeNewProductQuantity, (value (toString model.newProduct.quantity)) ] []
                    , button [ type_ "button" ] [ text "+" ]
                    , button [ type_ "button" ] [ text "-" ]
                    ]
                ]
            , div
                [ (class "row") ]
                [ div [ (class "col-xs-3") ]
                    [ label [ (class "control-label") ]
                        [ text "Comprado" ]
                    ]
                , div [ (class "col-xs-9") ]
                    [ input [ type_ "checkbox", onCheck ChangeNewProductBought, (checked model.newProduct.bought) ] []
                    ]
                ]
            , button [ type_ "submit", (classList [ ( "btn", True ), ( "btn-primary", True ) ]) ] [ text "Crear" ]
            , button [ (classList [ ( "btn", True ), ( "btn-default", True ) ]), onClick HideCreateProduct ] [ text "Cancelar" ]
            ]
        ]


productRow : Product -> Html Msg
productRow product =
    tr [ (classList [ ( "comprado", True ) ]) ]
        [ td []
            [ button [ (classList [ ( "btn", True ), ( "btn-danger", True ) ]), onClick (RemoveProduct product) ] [ text "-" ]
            ]
        , td
            []
            [ a [ href "#", onClick Edit ] [ text product.name ]
            , span [ (style [ ( "font-size", "0.8rem" ) ]) ]
                [ text " x "
                , text (toString product.quantity)
                ]
            ]
        , td
            []
            [ span [ (style [ ( "font-size", "0.8rem" ) ]) ] [ text (toString product.price) ]
            ]
        , td
            []
            [ text (toString (productTotal product))
            ]
        , td
            []
            [ input [ type_ "checkbox", (checked product.bought) ] []
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
