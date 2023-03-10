module Main exposing
    ( Flags
    , Msg
    , main
    )

import Browser
import Browser.Dom
import Browser.Events
import Components.Footer
import Components.Header
import Components.SideMenu
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html
import Html.Attributes
import Html.Events
import Pages.Car
import Pages.Home
import Pages.Info
import Pages.Physics2D
import Pages.Robot
import Pages.TurtleSquareSpiral
import Pages.TurtleTree
import Route
import Shared
import Style
import SyntaxHighlight
import Task
import Time
import Tutorials.Physics2D.Main
import Types.Model


main : Program Flags Types.Model.Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Flags =
    { env : Shared.Env
    , innerHeight : Int
    , innerWidth : Int
    , locationHref : String
    , millisAtStart : Int
    }


isSmallScreen : number -> Bool
isSmallScreen width =
    width < 740


init : Flags -> ( Types.Model.Model, Cmd Msg )
init flags =
    -- On small devices, the menu is closed at start. Otherwise
    -- it is open.
    let
        route : Route.Route
        route =
            Route.fromLocationHref flags.locationHref

        isSideMenuOpen : Bool
        isSideMenuOpen =
            not <| isSmallScreen flags.innerWidth

        posixAtStart : Time.Posix
        posixAtStart =
            Time.millisToPosix flags.millisAtStart
    in
    ( { animationPaused = False
      , env = flags.env
      , isSideMenuOpen = isSideMenuOpen
      , isSmallScreen = isSmallScreen flags.innerWidth
      , posixAtStart = posixAtStart
      , posix = posixAtStart
      , route = route
      , physics2dPoints = Tutorials.Physics2D.Main.pointsInit
      }
    , Cmd.batch [ updateHtmlTitle route ]
    )


subscriptions : Types.Model.Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Route.onUrlChange MsgUrlChanged
        , Browser.Events.onResize (\w _ -> MsgGotNewWidth w)
        , if (model.route == Route.RouteCar || model.route == Route.RouteRobot || model.route == Route.RoutePhysics2D) && not model.animationPaused then
            Browser.Events.onAnimationFrame MsgTick

          else if model.route == Route.RoutePhysics2D then
            Browser.Events.onAnimationFrame MsgTick

          else
            Sub.none
        ]


type Msg
    = MsgGotNewWidth Int
    | MsgNoOp
    | MsgOnPressHamburger
    | MsgPushUrl String
    | MsgTick Time.Posix
    | MsgUrlChanged String
    | MsgToggleAnimationPause


update : Msg -> Types.Model.Model -> ( Types.Model.Model, Cmd Msg )
update msg model =
    case msg of
        MsgGotNewWidth width ->
            ( { model
                | isSideMenuOpen =
                    if isSmallScreen width then
                        False

                    else
                        model.isSideMenuOpen
                , isSmallScreen = isSmallScreen width
              }
            , Cmd.none
            )

        MsgNoOp ->
            ( model, Cmd.none )

        MsgOnPressHamburger ->
            ( { model | isSideMenuOpen = not model.isSideMenuOpen }, Cmd.none )

        MsgPushUrl locationHref ->
            ( model, Route.pushUrl locationHref )

        MsgTick posix ->
            let
                newModel =
                    if model.route == Route.RoutePhysics2D then
                        if modBy 7 (Time.posixToMillis posix // 1000) == 0 then
                            { model | physics2dPoints = Tutorials.Physics2D.Main.pointsInit }

                        else
                            { model | physics2dPoints = Tutorials.Physics2D.Main.updatePoints model.physics2dPoints }

                    else
                        model
            in
            ( { newModel | posix = posix }, Cmd.none )

        MsgUrlChanged locationHref ->
            let
                route : Route.Route
                route =
                    Route.fromLocationHref locationHref
            in
            ( { model
                | isSideMenuOpen =
                    if model.isSmallScreen then
                        False

                    else
                        model.isSideMenuOpen
                , route = route
              }
            , Cmd.batch
                [ updateHtmlTitle route
                , Task.perform (\_ -> MsgNoOp) (Browser.Dom.setViewport 0 0)
                ]
            )

        MsgToggleAnimationPause ->
            ( { model | animationPaused = not model.animationPaused }, Cmd.none )


updateHtmlTitle : Route.Route -> Cmd msg
updateHtmlTitle route =
    Route.changeMeta
        { content = Route.toTitle route ++ " • Coding for Kids"
        , fieldName = "innerHTML"
        , querySelector = "title"
        }


view : Types.Model.Model -> Html.Html Msg
view model =
    let
        widthSideMenu : number
        widthSideMenu =
            Shared.widthSideMenu model

        paddingLeftBody : number
        paddingLeftBody =
            Shared.paddingLeftBody model
    in
    -- Main structure containing header, side menu, body (page), and footer.
    layoutWith
        { options = [ focusStyle { backgroundColor = Nothing, borderColor = Nothing, shadow = Nothing } ] }
        [ Font.family []
        , Background.color Style.color.backgroundTop
        , inFront <| html <| Html.node "style" [] [ Html.text Style.css ]
        , inFront <| html <| SyntaxHighlight.useTheme SyntaxHighlight.monokai
        , inFront <|
            Components.Header.view model
                { msgOnPress = MsgOnPressHamburger
                , msgPushUrl = MsgPushUrl
                }
        , if model.isSmallScreen && model.isSideMenuOpen then
            -- On small devices the menu is overlayed to the content (does
            -- not take own space) and a gray area is added on the right to
            -- cover the content underneath. If the gray area is clicked,
            -- the menu get closed.
            inFront <|
                el
                    [ -- , htmlAttribute <| Html.Attributes.style "height" <| "calc(100vh - " ++ String.fromInt Shared.headerHeight ++ "px)"
                      -- , moveDown Shared.headerHeight
                      htmlAttribute <| Html.Attributes.style "width" <| "calc(100vw - " ++ String.fromInt widthSideMenu ++ "px)"
                    , htmlAttribute <| Html.Attributes.style "height" "100vh"
                    , moveRight widthSideMenu
                    , Background.color Style.color.opaqueCover
                    , htmlAttribute <| Html.Events.onClick MsgOnPressHamburger
                    ]
                    (text "")

          else
            inFront none
        , inFront <|
            column
                [ width <| px widthSideMenu
                , htmlAttribute <| Html.Attributes.style "height" <| "calc(100vh - " ++ String.fromInt Shared.headerHeight ++ "px)"
                , moveDown Shared.headerHeight
                , scrollbars
                , Background.color Style.color.sideMenuBackground
                , Font.color Style.color.sideMenuFont
                ]
                (viewSideMenu model)
        ]
        (column
            -- [ paddingEach { bottom = 0, left = paddingLeftBody, right = 0, top = Shared.headerHeight }
            [ paddingEach { bottom = 0, left = paddingLeftBody, right = 0, top = Shared.headerHeight }
            , Background.color Style.color.backgroundBelow
            , width fill
            , height fill
            ]
            (viewBody model)
        )


viewSideMenu : Types.Model.Model -> List (Element Msg)
viewSideMenu model =
    if model.isSmallScreen && not model.isSideMenuOpen then
        -- Hiding the menu completely on small devices
        []

    else
        [ el
            -- ([ scrollbars
            -- , htmlAttribute <| Html.Attributes.style "height" <| "calc(100vh - " ++ String.fromInt Shared.headerHeight ++ "px)"
            ([ width fill
             ]
                ++ (if False then
                        -- On small devices the menu is overlayed to the content (does
                        -- not take own space) and a gray area is added on the right to
                        -- cover the content underneath. If the gray area is clicked,
                        -- the menu get closed.
                        [ htmlAttribute <| Html.Attributes.style "position" "fixed"
                        , htmlAttribute <| Html.Attributes.style "z-index" "1"
                        , htmlAttribute <| Html.Attributes.style "top" "63px"
                        , behindContent <|
                            el
                                [ Background.color Style.color.opaqueCover
                                , htmlAttribute <| Html.Attributes.style "position" "fixed"
                                , htmlAttribute <| Html.Attributes.style "top" "63px"
                                , htmlAttribute <| Html.Attributes.style "right" "0"
                                , htmlAttribute <| Html.Attributes.style "height" <| "calc(100vh - " ++ String.fromInt Shared.headerHeight ++ "px)"
                                , htmlAttribute <| Html.Attributes.style "width" "calc(100vw - 200px)"
                                , htmlAttribute <| Html.Events.onClick MsgOnPressHamburger
                                ]
                            <|
                                text ""
                        ]

                    else
                        []
                   )
            )
            (Components.SideMenu.view model { msgPushUrl = MsgPushUrl })
        ]


viewBody : Types.Model.Model -> List (Element Msg)
viewBody model =
    [ column
        [ -- , htmlAttribute <| Html.Attributes.style "height" <| "calc(100vh - " ++ String.fromInt Shared.headerHeight ++ "x)"
          padding 20
        , spacing 40
        , width fill
        , height fill
        , Font.size 16
        ]
        [ viewPage model
        , Components.Footer.view
        ]
    ]


viewPage : Types.Model.Model -> Element Msg
viewPage model =
    case model.route of
        Route.RouteTurtleSquareSpiral ->
            Pages.TurtleSquareSpiral.view

        Route.RouteTurtleTree ->
            Pages.TurtleTree.view

        Route.RouteCar ->
            Pages.Car.view model MsgToggleAnimationPause

        Route.RouteRobot ->
            Pages.Robot.view model MsgToggleAnimationPause

        Route.RoutePhysics2D ->
            Pages.Physics2D.view model.physics2dPoints

        Route.RouteDifferences maybeString ->
            text "Hi"

        Route.RouteEndpoints _ ->
            text "Hi"

        Route.RouteFlows maybeString ->
            text "Hi"

        Route.RouteHome ->
            Pages.Home.view model

        Route.RouteInfo ->
            Pages.Info.view

        Route.RouteLanguages maybeString ->
            text "Hi"

        Route.RouteMaintenance ->
            text "Hi"

        Route.RouteMeta ->
            text "Hi"

        Route.RouteReviews ->
            text "Hi"

        Route.RouteRoutes ->
            text "Hi"

        Route.RouteScreenshots ->
            text "Hi"

        Route.RouteTranslations maybeString ->
            text "Hi"

        Route.RouteTwins ->
            text "Hi"

        Route.RouteViews maybeString ->
            text "Hi"
