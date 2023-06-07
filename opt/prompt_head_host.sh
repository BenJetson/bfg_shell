#!/bin/bash

ICON_PALM_TREE="$(bfg_get_icon "f1055")"
ICON_CPU="$(bfg_get_icon "f4bc")"
ICON_UPLOAD="$(bfg_get_icon "f093")"
ICON_ATLASSIAN="$(bfg_get_icon "f0804")"
ICON_PAW="$(bfg_get_icon "f03e9")"
ICON_TEST_TUBE="$(bfg_get_icon "f0668")"
ICON_BOOK="$(bfg_get_icon "f02d")"
ICON_CROWN="$(bfg_get_icon "f01a5")"

FG_COLOR_PURPLE=$(bfg_escape $'\033[38;5;54m')
FG_COLOR_PACIFIC_BLUE=$(bfg_escape $'\033[38;5;27m')

BG_COLOR_PURPLE=$(bfg_escape $'\033[48;5;54m')
BG_COLOR_PACIFIC_BLUE=$(bfg_escape $'\033[48;5;27m')


if [[ "$(hostname)" == *".palmetto."* ]]; then
    case "$(hostname)" in
        node*)
            HEAD_FG_COLOR="$FG_COLOR_ORANGE";
            HEAD_BG_COLOR="$BG_COLOR_BRIGHT_BLACK";
            HEAD_END_COLOR="$FG_COLOR_BRIGHT_BLACK";
            HEAD_ICON="$ICON_CPU";
            SHOW_SSH_SEGMENT=1;
            ;;
        master*)
            HEAD_FG_COLOR="$FG_COLOR_PURPLE";
            HEAD_BG_COLOR="$BG_COLOR_ORANGE";
            HEAD_END_COLOR="$FG_COLOR_ORANGE";
            HEAD_ICON="$ICON_CROWN";
            ;;
        hpcdtn*)
            HEAD_FG_COLOR="$FG_COLOR_BRIGHT_BLACK";
            HEAD_BG_COLOR="$BG_COLOR_GREEN";
            HEAD_END_COLOR="$FG_COLOR_GREEN";
            HEAD_ICON="$ICON_UPLOAD";
            ;;
        *)
            HEAD_FG_COLOR="$FG_COLOR_WHITE";
            HEAD_BG_COLOR="$BG_COLOR_PURPLE";
            HEAD_END_COLOR="$FG_COLOR_PURPLE";
            HEAD_ICON="$ICON_PALM_TREE";
            ;;
    esac
elif [[ "$(hostname)" == *".rcd."* ]]; then
    case "$(hostname)" in
        docs*)
            HEAD_FG_COLOR="$FG_COLOR_WHITE";
            HEAD_BG_COLOR="$BG_COLOR_PURPLE";
            HEAD_END_COLOR="$FG_COLOR_PURPLE";
            HEAD_ICON="$ICON_BOOK";
            ;;
        *)
            HEAD_FG_COLOR="$FG_COLOR_BRIGHT_BLACK";
            HEAD_BG_COLOR="$BG_COLOR_GREEN";
            HEAD_END_COLOR="$FG_COLOR_GREEN";
            HEAD_ICON="$ICON_TEST_TUBE"
            ;;
    esac
elif [[ "$(hostname)" == *".server."* ]]; then
    case "$(hostname)" in
        *atl*)
            HEAD_FG_COLOR="$FG_COLOR_WHITE";
            HEAD_BG_COLOR="$BG_COLOR_PACIFIC_BLUE";
            HEAD_END_COLOR="$FG_COLOR_PACIFIC_BLUE";
            HEAD_ICON="$ICON_ATLASSIAN";
            ;;
        *)
            HEAD_FG_COLOR="$FG_COLOR_PURPLE";
            HEAD_BG_COLOR="$BG_COLOR_ORANGE";
            HEAD_END_COLOR="$FG_COLOR_ORANGE";
            HEAD_ICON="$ICON_PAW";
            ;;
    esac
fi


