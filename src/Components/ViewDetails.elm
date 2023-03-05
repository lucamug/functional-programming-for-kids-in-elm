module Components.ViewDetails exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Iso8601
import Main.Routes
import R10.Language
import Types.FormFactor
import Types.LightDarkMode
import Types.Route
import Types.UrlScreenshot
import Types.ViewId


view : Types.UrlScreenshot.Metadata -> Element msg
view screenshot =
    let
        key string =
            el [ alpha 0.3 ] <| text string

        value string =
            el [ Font.bold, htmlAttribute (Html.Attributes.style "overflow-wrap" "anywhere") ] <| text string
    in
    column [ spacing 5 ]
        [ paragraph []
            [ key "Created "
            , value
                (screenshot.folderMetadata.posix
                    |> Iso8601.fromTime
                    -- "1970-01-01T00:00:00.000Z"
                    |> String.split "T"
                    |> List.head
                    |> Maybe.withDefault "ERROR"
                )
            ]
        , paragraph []
            [ key "Time "
            , value
                (screenshot.folderMetadata.posix
                    |> Iso8601.fromTime
                    -- "1970-01-01T00:00:00.000Z"
                    |> String.split "T"
                    |> List.tail
                    |> Maybe.withDefault []
                    |> List.head
                    |> Maybe.withDefault "ERROR"
                    |> String.split "."
                    |> List.head
                    |> Maybe.withDefault "ERROR"
                )
            ]
        , paragraph [] [ key "Version ", value <| screenshot.folderMetadata.version ]
        , paragraph [] [ key "Commit ", value <| screenshot.folderMetadata.commit ]
        , paragraph [] [ key "Form ", value <| Types.FormFactor.toString screenshot.fileMetadata.formFactor ]
        , paragraph [] [ key "Width ", value <| String.fromInt <| Types.FormFactor.toWidth screenshot.fileMetadata.formFactor ]
        , paragraph [] [ key "Language ", value <| R10.Language.toString screenshot.fileMetadata.language ]
        , paragraph [] [ key "Mode ", value <| Types.LightDarkMode.toString screenshot.fileMetadata.mode ]
        , paragraph [] [ key "View ID ", value <| Types.ViewId.toString screenshot.fileMetadata.viewId ]
        , paragraph [] [ key "Route ", value <| Maybe.withDefault "N/A" <| Maybe.map Types.Route.toString (Types.ViewId.toRoute screenshot.fileMetadata.viewId) ]
        ]
