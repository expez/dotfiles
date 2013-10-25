import XMonad
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Paste
import XMonad.Layout.NoBorders
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Tabbed
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.ToggleLayouts
import XMonad.Hooks.SetWMName

main = do
  xmonad $ defaultConfig
    { terminal    = "urxvtc"
    , modMask     = mod4Mask
    , borderWidth = 1
    , layoutHook = myLayoutHooks
    , manageHook = myManageHooks
    , startupHook = setWMName "LG3D"
    } `additionalKeysP` myKeys

myHandleEventHooks = fullscreenEventHook

myLayoutHooks = toggleLayouts (noBorders Full) $
                smartBorders $ tiled ||| Mirror tiled ||| tabbed shrinkText defaultTheme

  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100


myManageHooks = composeAll
-- Allows focusing other monitors without killing the fullscreen
    [ isFullscreen --> (doF W.focusDown <+> doFullFloat)

-- Single monitor setups, or if the previous hook doesn't work
    --[ isFullscreen --> doFullFloat

    ]

myKeys =
    [
    --(("M-p"), spawn "gmrun")
        -- other additional keys
      (("M-f"), sendMessage (Toggle "Full"))
    , (("M-v"), pasteSelection )
    , (("M-s"), spawn "select-screenshot" )
    , (("M-S"), spawn "screenshot" )
    ]
    ++
    [ (mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
         | (key, scr)  <- zip "wer" [2,0,1] -- was [0..] *** change to match your screen order ***
         , (action, mask) <- [ (W.view, "") , (W.shift, "S-")]
    ]
