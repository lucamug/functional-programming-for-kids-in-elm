port module Route exposing
    ( Route(..)
    , RouteData
    , changeMeta
    , fromLocationHref
    , fromTitle
    , onUrlChange
    , pushUrl
    , removePayload
    , requestDiff
    , routesData
    , toIcon
    , toLocationHref
    , toTitle
    )

import Material.Icons
import Material.Icons.Types
import Url
import Url.Parser exposing ((</>))


type Route
    = RouteTurtleSquareSpiral
    | RouteTurtleTree
    | RouteCar
    | RouteRobot
    | RoutePhysics2D
    | RouteDifferences (Maybe String)
    | RouteEndpoints (Maybe String)
    | RouteFlows (Maybe String)
    | RouteHome
    | RouteInfo
    | RouteLanguages (Maybe String)
    | RouteMaintenance
    | RouteMeta
    | RouteReviews
    | RouteRoutes
    | RouteScreenshots
    | RouteTranslations (Maybe String)
    | RouteTwins
    | RouteViews (Maybe String)



-- Icons are from https://fonts.google.com/icons?selected=Material+Icons


routesData : List (RouteData msg)
routesData =
    [ { icon = Material.Icons.widgets, route = RoutePhysics2D, title = "Physics 2D", url = "physics-2d" }
    , { icon = Material.Icons.code, route = RouteRobot, title = "Robot", url = "robot" }
    , { icon = Material.Icons.code, route = RouteCar, title = "Car", url = "car" }
    , { icon = Material.Icons.code, route = RouteTurtleSquareSpiral, title = "Square Spiral", url = "square-spiral" }
    , { icon = Material.Icons.code, route = RouteTurtleTree, title = "Tree", url = "tree" }
    , { icon = Material.Icons.info, route = RouteInfo, title = "Info", url = "info" }
    ]


extraForAdminPortal : List (Url.Parser.Parser (Route -> c) c)
extraForAdminPortal =
    [ urlParserHelperWithExtra RouteTranslations
    , urlParserHelperWithExtra RouteLanguages
    , urlParserHelperWithExtra RouteViews
    , urlParserHelperWithExtra RouteEndpoints
    , urlParserHelperWithExtra RouteFlows
    , urlParserHelperWithExtra RouteDifferences
    ]


extraForDevPortal : List (Url.Parser.Parser (Route -> c) c)
extraForDevPortal =
    [ urlParserHelperWithExtra RouteEndpoints ]


urlParser : Url.Parser.Parser (Route -> Route) Route
urlParser =
    -- Add manually a route here if it is the "extra" type
    Url.Parser.oneOf
        (extraForAdminPortal
            ++ extraForDevPortal
            ++ List.map (\routeData -> urlParserHelper routeData.route) routesData
        )


toStringForUrl : Route -> String
toStringForUrl route =
    -- Add manually a route here if it is the "extra" type
    let
        url : String
        url =
            .url (toRouteData route)
    in
    case route of
        RouteTurtleSquareSpiral ->
            url

        RouteTurtleTree ->
            url

        RouteCar ->
            url

        RouteRobot ->
            url

        RoutePhysics2D ->
            url

        RouteDifferences maybeString ->
            routeWithPayload url maybeString

        RouteEndpoints maybeString ->
            routeWithPayload url maybeString

        RouteFlows maybeString ->
            routeWithPayload url maybeString

        RouteHome ->
            url

        RouteInfo ->
            url

        RouteLanguages maybeString ->
            routeWithPayload url maybeString

        RouteMaintenance ->
            url

        RouteMeta ->
            url

        RouteReviews ->
            url

        RouteRoutes ->
            url

        RouteScreenshots ->
            url

        RouteTranslations maybeString ->
            routeWithPayload url maybeString

        RouteTwins ->
            url

        RouteViews maybeString ->
            routeWithPayload url maybeString


removePayload : Route -> Route
removePayload route =
    -- Add manually a route here if it is the "extra" type
    case route of
        RouteTurtleTree ->
            route

        RouteTurtleSquareSpiral ->
            route

        RouteCar ->
            route

        RouteRobot ->
            route

        RoutePhysics2D ->
            route

        RouteDifferences _ ->
            RouteDifferences Nothing

        RouteEndpoints _ ->
            RouteEndpoints Nothing

        RouteFlows _ ->
            RouteFlows Nothing

        RouteHome ->
            route

        RouteInfo ->
            route

        RouteLanguages _ ->
            RouteLanguages Nothing

        RouteMaintenance ->
            route

        RouteMeta ->
            route

        RouteReviews ->
            route

        RouteRoutes ->
            route

        RouteScreenshots ->
            route

        RouteTranslations _ ->
            RouteTranslations Nothing

        RouteTwins ->
            route

        RouteViews _ ->
            RouteViews Nothing



-- FROM HERE PROBABLY DON'T NEED TO BE UPDATED WHEN
-- ADDING OR REMOVING ROUTES


type alias RouteData msg =
    { icon : Material.Icons.Types.Icon msg
    , route : Route
    , title : String
    , url : String
    }


routeHomeData : RouteData msg
routeHomeData =
    { icon = Material.Icons.home
    , route = RouteHome
    , title = "Home"
    , url = "Dashboard"
    }


toRouteData : Route -> RouteData msg
toRouteData route =
    routesData
        |> List.filter (\r -> r.route == removePayload route)
        |> List.head
        |> Maybe.withDefault routeHomeData


fromTitle : String -> Maybe Route
fromTitle title =
    routesData
        |> List.filter (\r -> r.title == title)
        |> List.head
        |> Maybe.map .route


fromLocationHref : String -> Route
fromLocationHref locationHref =
    let
        urlModifier : Url.Url -> Url.Url
        urlModifier =
            \url -> { url | path = Maybe.withDefault "" url.fragment }
    in
    locationHref
        |> Url.fromString
        |> Maybe.map urlModifier
        |> Maybe.andThen (Url.Parser.parse urlParser)
        |> Maybe.withDefault RouteHome


urlParserHelperWithExtra : (Maybe String -> Route) -> Url.Parser.Parser (Route -> c) c
urlParserHelperWithExtra route =
    Url.Parser.map (\string -> route (Just string)) (Url.Parser.s (toStringForUrl (route Nothing)) </> Url.Parser.string)


urlParserHelper : Route -> Url.Parser.Parser (Route -> c) c
urlParserHelper route =
    Url.Parser.map route (Url.Parser.s (toStringForUrl route))


toLocationHref : Route -> String
toLocationHref route =
    "#/" ++ toStringForUrl route


toTitle : Route -> String
toTitle route =
    .title (toRouteData route)


toIcon : Route -> Material.Icons.Types.Icon msg
toIcon route =
    .icon (toRouteData route)


routeWithPayload : String -> Maybe String -> String
routeWithPayload root maybeString =
    root
        ++ (case maybeString of
                Just string ->
                    "/" ++ string

                Nothing ->
                    ""
           )


port onUrlChange : (String -> msg) -> Sub msg


port pushUrl : String -> Cmd msg


port changeMeta : { querySelector : String, fieldName : String, content : String } -> Cmd msg


port requestDiff : ( String, String, ( Int, Int ) ) -> Cmd msg
