import XMonad

import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.Place

import XMonad.Util.Run(spawnPipe)

import System.IO

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ myConfig
    { logHook = dynamicLogWithPP xmobarPP
      { ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor "green" "" . shorten 50
      }
    }

myConfig = defaultConfig
  { terminal = "terminator"
  , borderWidth = 1
  , modMask = mod4Mask
  , manageHook = placeHook myFloatingPlacement <+> manageDocks <+> myManageHook <+> manageHook defaultConfig
  , focusedBorderColor = "#2c3539"
  , normalBorderColor = "#0f0f0f"
  , layoutHook = myLayoutHook
  , handleEventHook = docksEventHook
  }

myManageHook = composeAll
  [ className =? "Qemu-system-x86_64" --> doFloat
  , className =? "qemu-system-x86_64" --> doFloat
--  , className =? "Gimp" --> doFloat
  , className =? "Gvncviewer" --> doFloat
  , className =? "rdesktop" --> doFloat
  ]

myLayoutHook = avoidStruts (tall ||| three ) ||| full
  where tall = Tall 1 (1/100) (1/2)
        three = ThreeCol 1 (1/100) (1/3)
        full =  noBorders (fullscreenFull Full)

myFloatingPlacement = withGaps (16, 0, 16, 0) (smart (0.5, 0.5))
