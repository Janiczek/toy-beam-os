module UI.Color exposing (Color, color)


type alias Color =
    -- window border
    { activeWindowOuterBorder : String
    , activeWindowInnerBottomRightBorder : String
    , activeWindowInnerTopLeftBorder : String

    -- chrome
    , chromeBg : String

    -- window content
    , windowContentBorder : String
    , windowContentBg : String
    , windowContentCanvasBg : String

    -- text
    , statusBarText : String
    , windowTitleText : String

    -- divider
    , dividerBg : String
    , dividerShadow : String
    }


color : Color
color =
    -- window border
    { activeWindowOuterBorder = "#262626"
    , activeWindowInnerBottomRightBorder = "#8a8a8a"
    , activeWindowInnerTopLeftBorder = "#bbbbbb"

    -- chrome
    , chromeBg = "#cccccc"

    -- window content
    , windowContentBorder = "#a8a8a8"
    , windowContentBg = "#eeeeee"
    , windowContentCanvasBg = "#ffffff"

    -- text
    , statusBarText = "#000000"
    , windowTitleText = "#262626"

    -- divider
    , dividerBg = "#888888"
    , dividerShadow = "#ffffff"
    }
