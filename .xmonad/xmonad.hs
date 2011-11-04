import XMonad
import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS

import XMonad.Config.Gnome
import XMonad.Config.Desktop (desktopLayoutModifiers)

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Layout.Gaps
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Tabbed

import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad


main :: IO ()
main = xmonad $ gnomeConfig
      { terminal = myTerminal
      , modMask = mod4Mask
      , layoutHook = myLayouts
      , manageHook = myManageHook <+> manageHook gnomeConfig
      }
      `additionalKeysP` myKeys

myTerminal = "gnome-terminal"


myManageHook = composeAll
  [ scratchpadManageHookDefault
  , isFullscreen                       --> doFullFloat
  , isDialog                           --> doCenterFloat
  , resource  =? "unity-2d-launcher"   --> doIgnore
  , resource  =? "unity-2d-panel"      --> doIgnore
  , resource  =? "synapse"             --> doIgnore
  , className =? "Pidgin"              --> doF (W.shift "3")
  , className =? "Empathy"             --> doF (W.shift "3")
  , className =? "Chromium-browser"    --> doF (W.shift "2")
  , className =? "Google-chrome"       --> doF (W.shift "2")
  , className =? "Firefox"             --> doF (W.shift "2")
  , resource  =? "firefox"             --> doF (W.shift "2")
  ]


myLayouts = desktopLayoutModifiers $ smartBorders
  $ onWorkspace "3" im
  $ onWorkspace "2" (tabs ||| tiled)
  $ (tiled ||| mirror ||| tabs)
  where
    im = reflectHoriz $ withIM (1/8) imRoster $ reflectHoriz imLayouts
    imRoster = Or (Title "Buddy List") (Title "Contact List")
    imLayouts = mirror ||| tabs
    tiled = Tall 1 (3/100) (1/2)
    mirror = Mirror tiled
    tabs = simpleTabbedBottom

myKeys =
    [ ("M-<Return>",   spawn myTerminal)
    , ("M-S-<Return>", windows W.shiftMaster)
    , ("M-c", kill)
    , ("M-<Tab>",      toggleWS)

    , ("M-p",          spawn "gmrun")
    -- , ("M-p",          spawn "dbus-send --dest=com.canonical.Unity2d.Dash --type=method_call /Dash com.canonical.Unity2d.Dash.activateHome")


    , ("M-d",          scratchpadSpawnActionTerminal myTerminal)
    , ("M-s",          scratchpadSpawnActionCustom "gnome-terminal --disable-factory --name scratchpad")

    , ("M-|",          sendMessage $ ToggleStrut L)
    , ("M-n",          spawn "xrandr --output VGA1 --off --output LVDS1 --auto --primary")
    , ("M-m",          spawn "xrandr --output LVDS1 --off --output VGA1 --auto --primary")
    ]
