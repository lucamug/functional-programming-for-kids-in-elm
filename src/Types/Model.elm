module Types.Model exposing (Model)

import Route
import Shared
import Time


type alias Model =
    { env : Shared.Env
    , isSideMenuOpen : Bool
    , isSmallScreen : Bool
    , posixAtStart : Time.Posix
    , route : Route.Route
    , posix : Time.Posix
    , animationPaused : Bool
    }
