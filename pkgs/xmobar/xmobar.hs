{-# LANGUAGE ViewPatterns #-}

import Data.List (intercalate)
import System.Environment (getArgs)
import Xmobar

main :: IO ()
main = do
  [read -> screenId] <- getArgs
  xmobar (xmobarConfig screenId)

xmobarConfig :: Int -> Config
xmobarConfig screenId =
  defaultConfig
    { font = "xft:" ++ intercalate "," fonts,
      additionalFonts = ["xft:Font Awesome 6 Free Solid:style=Solid:size=18"],
      bgColor = "#282828",
      fgColor = "#ebdbb2",
      alpha = 230,
      position = OnScreen screenId (TopH 50),
      commands =
        [ Run $
            Cpu
              [ "-t",
	        "<fn=1>\xf2db</fn> <total>%",
                "<total>%"
              ]
              10,
	  Run $
	    Memory
	      [ "-t",
	        "<fn=1>\xf538</fn> <usedratio>%",
		"-L",
		"30",
		"-H",
		"80"
	      ]
	      10,
	  Run $
	    DynNetwork
	      [ "-t",
	        "<fn=1>\xf0ab</fn> <rx>KB <fn=1>\xf0aa</fn> <tx>KB",
		"-L",
		"1000",
		"-H",
		"500000"
		]
		10,
          Run $ Date "<fn=1>\xf133</fn> <fc=#d3869b>%a %b %d</fc> <fn=1>\xf017</fn> <fc=#83a598>%H:%M</fc>" "date" 10,
          Run $
            NamedXPropertyLog
              ("_XMONAD_LOG_" ++ show (fromEnum screenId))
              "XMonadLog"
        ],
      sepChar = "%",
      alignSep = "}{",
      template = " %XMonadLog%}%date%{%cpu% <fc=#83a598>|</fc> %memory% <fc=#83a598>|</fc> %dynnetwork%  "
    }
  where
    -- Check with fc-match "<string>" family size
    -- See all fonts with fc-list
    -- Lower has higher precedence
    fonts =
      [ -- Emoji, though DejaVu also has some :/
        "JetBrainsMono-18",
        -- Nerdfonts symbols
        "NerdFontsSymbolsOnly-18"
      ]
