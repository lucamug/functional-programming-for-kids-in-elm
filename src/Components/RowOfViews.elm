module Components.RowOfViews exposing (view)

import Components.MobileFrame
import Element exposing (..)
import Pages.Screenshots
import Types.LightDarkMode
import Types.Pattern
import Types.UrlScreenshot
import Types.ViewId


view :
    { folderMetadata : Types.UrlScreenshot.FolderMetadata, maybeScreenshot2 : Maybe Types.UrlScreenshot.Metadata, pattern : Types.Pattern.Pattern, viewId : Types.ViewId.ViewId }
    -> List (Element msg)
view { folderMetadata, maybeScreenshot2, pattern, viewId } =
    --
    -- Visualize a list of screenshots.
    --
    -- If pattern == Pages.Screenshots.Standard
    --    4 screenshots or what the Standard is
    --
    -- If pattern == Pages.Screenshots.Last
    --    1 screenshot
    --
    let
        lists : Pages.Screenshots.Model
        lists =
            Pages.Screenshots.patternToLists pattern

        allFileMetadata : List Types.UrlScreenshot.FileMetadata
        allFileMetadata =
            Pages.Screenshots.generateCombinations
                { checkedFormFactors = lists.checkedFormFactors
                , checkedLanguages = lists.checkedLanguagesForDarkMode
                , checkedModes = [ Types.LightDarkMode.Dark ]
                , checkedViews = [ viewId ]
                }
                ++ Pages.Screenshots.generateCombinations
                    { checkedFormFactors = lists.checkedFormFactors
                    , checkedLanguages = lists.checkedLanguagesForLightMode
                    , checkedModes = [ Types.LightDarkMode.Light ]
                    , checkedViews = [ viewId ]
                    }
    in
    List.map
        (\fileMetadata ->
            let
                screenshotData1 : Types.UrlScreenshot.Metadata
                screenshotData1 =
                    { fileMetadata = fileMetadata
                    , folderMetadata = folderMetadata
                    }
            in
            Components.MobileFrame.view
                ( screenshotData1, maybeScreenshot2 )
        )
        allFileMetadata
