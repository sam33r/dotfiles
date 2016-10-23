-- XMonad Config

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Layout.Accordion
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    , title =? "VLC media player" --> doFloat
    , resource =? "stalonetray" --> doIgnore
    ]


myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.8

-- myStartupHook = do
--   spawnOnce "/usr/bin/redshift"

myLayout = avoidStruts (
    ThreeColMid 1 (3/100) (0.4) |||
    ThreeColMid 1 (3/100) (1/2) |||
    ThreeCol 1 (3/100) (0.4) |||
    Accordion |||
    Tall 1 (3/100) (1/3) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    noBorders (fullscreenFull Full) |||
    spiral (6/7))

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}


main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/sameer/.config/xmobar/xmobarrc"
    xmonad $ ewmh defaultConfig
        { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
                        <+> manageHook defaultConfig
        , layoutHook = myLayout -- avoidStruts  $  layoutHook defaultConfig $  myLayout
        , logHook = myLogHook <+> dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "#5dce3d" "" . shorten 100
                        }
                     >> updatePointer (0.5, 0.5) (1, 1)
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , borderWidth        = 5
        , normalBorderColor  = "#000000"
        , focusedBorderColor = "#b9e843"
        , handleEventHook = mconcat 
			  [ docksEventHook
                          , handleEventHook defaultConfig
                          , XMonad.Hooks.EwmhDesktops.fullscreenEventHook ]
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "gnome-screensaver-command -l &")
        -- Screenshot
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        -- Operate mouse with numpad
        , ((0, xK_KP_Begin), spawn "xdotool click 1")
	, ((0, xK_F8), spawn "xdotool click 1")
        , ((0, xK_KP_Left), spawn "xdotool mousemove_relative -- -10 0")
        , ((0, xK_KP_Down), spawn "xdotool mousemove_relative -- 0 10")
        , ((0, xK_KP_Up), spawn "xdotool mousemove_relative -- 0 -10")
        , ((0, xK_KP_Right), spawn "xdotool mousemove_relative -- 10 0")
        , ((mod4Mask, xK_KP_Left), spawn "xdotool mousemove_relative -- -100 0")
        , ((mod4Mask, xK_KP_Down), spawn "xdotool mousemove_relative -- 0 100")
        , ((mod4Mask, xK_KP_Up), spawn "xdotool mousemove_relative -- 0 -100")
        , ((mod4Mask, xK_KP_Right), spawn "xdotool mousemove_relative -- 100 0")
        , ((mod4Mask .|. controlMask, xK_KP_Up), spawn "xdotool click 4")
        , ((mod4Mask .|. controlMask, xK_KP_Down), spawn "xdotool click 5")
        -- Manage workspaces
        , ((mod1Mask .|. controlMask, xK_Left), moveTo Prev NonEmptyWS)       -- These are weird because of my Mac Keyboard.
        , ((mod1Mask .|. controlMask, xK_Right), moveTo Next NonEmptyWS)      -- mod1 and mod4 will swap for regular keyboards.
        , ((mod4Mask .|. controlMask .|. shiftMask, xK_Left), shiftToPrev)
        , ((mod4Mask .|. controlMask .|. shiftMask, xK_Right), shiftToNext)
        -- XMonad Prompt
        , ((mod4Mask, xK_bracketleft), windowPromptGoto defaultXPConfig)
        ]
