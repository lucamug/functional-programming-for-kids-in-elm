module Pages.Home exposing (view)

import Element exposing (..)
import Playground
import Types.Model


view : Types.Model.Model -> Element msg
view model =
    el
        [ centerX
        , height fill
        , padding 100
        ]
    <|
        text "A collection of resources for teaching and learning Functional Programming to begineers."
