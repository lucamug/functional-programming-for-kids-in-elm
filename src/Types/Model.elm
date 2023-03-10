module Types.Model exposing (Model)

import Route
import Shared
import Time
import Tutorials.Physics2D.Main


type alias Model =
    { env : Shared.Env
    , isSideMenuOpen : Bool
    , isSmallScreen : Bool
    , posixAtStart : Time.Posix
    , route : Route.Route
    , posix : Time.Posix
    , animationPaused : Bool
    , physics2dPoints : List Tutorials.Physics2D.Main.Point
    }
