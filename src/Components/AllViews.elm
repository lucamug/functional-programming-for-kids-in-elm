module Components.AllViews exposing (view)

import Element exposing (..)
import Element.Font as Font
import Html.Attributes
import Route
import Shared
import Types.ViewData
import Types.ViewId


view : List Types.ViewId.ViewId -> Element msg
view viewIds =
    column [ centerX ]
        (List.indexedMap
            (\index viewId ->
                let
                    viewIdAsString : String
                    viewIdAsString =
                        Types.ViewId.toString viewId

                    viewData : Types.ViewData.ViewData
                    viewData =
                        Types.ViewData.fromViewId viewId
                in
                link (Shared.linkAttrsInline ++ [ width fill, padding 10 ])
                    { label =
                        tableRow []
                            (String.fromInt (index + 1))
                            viewIdAsString
                            viewData.description
                    , url = Route.toLocationHref (Route.RouteViews (Just viewIdAsString))
                    }
            )
            viewIds
        )


tableRow : List (Attribute msg) -> String -> String -> String -> Element msg
tableRow attrs col1 col2 col3 =
    row ([ spacing 30, width fill ] ++ attrs)
        [ el
            [ width <| px 30
            , Font.alignRight
            , Shared.monospace
            , alignTop
            ]
          <|
            text col1
        , el
            [ width <| px 30
            , Font.alignRight
            , Shared.monospace
            , alignTop
            ]
          <|
            text col2
        , paragraph
            [ width fill
            , htmlAttribute (Html.Attributes.style "overflow-wrap" "anywhere")
            ]
            [ text col3 ]
        ]
