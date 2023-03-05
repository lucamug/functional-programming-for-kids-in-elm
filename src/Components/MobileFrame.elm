module Components.MobileFrame exposing (view)

import Components.ViewDetails
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Iso8601
import Main.Routes
import R10.Language
import Route
import Types.FormFactor
import Types.LightDarkMode
import Types.UrlScreenshot
import Types.ViewId


view : Types.UrlScreenshot.DataTwoScreenshots -> Element msg
view dataTwoScreenshots =
    let
        screenshot1 : Types.UrlScreenshot.Metadata
        screenshot1 =
            Tuple.first dataTwoScreenshots

        screenshotUrl : String
        screenshotUrl =
            Types.UrlScreenshot.metaDataToScreenshotUrl screenshot1
    in
    column [ spacing 20 ]
        [ link []
            { label =
                el
                    [ Border.rounded 25
                    , Background.color <| rgba 0 0 0 0.9
                    , padding 5
                    , height <| px 340
                    , Border.shadow { blur = 3, color = rgba 0 0 0 0.15, offset = ( 6, 6 ), size = 0 }
                    , mouseOver
                        [ Border.shadow { blur = 20, color = rgba 0 0 0 0.15, offset = ( 130, 50 ), size = -30 }
                        , Border.color <| rgba 0 0 0 0.3
                        , moveUp 70
                        , scale 1.85
                        ]
                    , htmlAttribute <| Html.Attributes.class "mouseOverZIndex"
                    , htmlAttribute <| Html.Attributes.style "transition" "all 250ms ease-out"

                    -- , htmlAttribute <| Html.Attributes.style "cursor" "crosshair"
                    ]
                    (image
                        [ Border.rounded 20
                        , clip
                        , scrollbarY

                        -- , htmlAttribute <| Html.Attributes.style "width" "50%"
                        , width <| px 150
                        ]
                        { description = ""
                        , src = screenshotUrl
                        }
                    )
            , url =
                Route.toLocationHref
                    (Route.RouteDifferences
                        (Just
                            (Types.UrlScreenshot.dataTwoScreenshotsToString dataTwoScreenshots)
                        )
                    )
            }
        , Components.ViewDetails.view screenshot1
        ]
