{-# LANGUAGE OverloadedStrings #-}
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

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8


main :: IO ()
main = do
    dbus <- D.connectSession
    getWellKnownName dbus
    xmonad $ gnomeConfig
      { terminal = myTerminal
      , modMask = mod4Mask
      , layoutHook = myLayouts
      , manageHook = myManageHook <+> manageHook gnomeConfig
      , logHook = dynamicLogWithPP (prettyPrinter dbus)
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
    , ("M-S-q",        spawn "gnome-session-quit")
    ]


prettyPrinter :: D.Client -> PP
prettyPrinter dbus = defaultPP
    { ppOutput   = dbusOutput dbus
    , ppTitle    = pangoSanitize
    , ppCurrent  = pangoColor "green" . wrap "[" "]" . pangoSanitize
    , ppVisible  = pangoColor "yellow" . wrap "(" ")" . pangoSanitize
    , ppHidden   = const ""
    , ppUrgent   = pangoColor "red"
    , ppLayout   = const ""
    , ppSep      = " "
    }

getWellKnownName :: D.Client -> IO ()
getWellKnownName dbus = do
  D.requestName dbus (D.busName_ "org.xmonad.Log")
                [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  return ()

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal "/org/xmonad/Log" "org.xmonad.Log" "Update") {
            D.signalBody = [D.toVariant ("<b>" ++ (UTF8.decodeString str) ++ "</b>")]
        }
    D.emit dbus signal

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
  where
    left  = "<span foreground=\"" ++ fg ++ "\">"
    right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
  where
    sanitize '>'  xs = "&gt;" ++ xs
    sanitize '<'  xs = "&lt;" ++ xs
    sanitize '\"' xs = "&quot;" ++ xs
    sanitize '&'  xs = "&amp;" ++ xs
    sanitize x    xs = x:xs
