#!/bin/bash

bfg_splash() {
    (
        GRADIENT=("" "" "" "" "" "" "" "" "")
        GRADIENT=(
            $'\033[38;5;135m' # B - Purple
            $'\033[38;5;27m'  # F - Blue
            $'\033[38;5;44m'  # G - Turquoise

            $'\033[38;5;34m'  # S - Green
            $'\033[38;5;226m' # H - Yellow
            $'\033[38;5;208m' # E - Orange
            $'\033[38;5;196m' # L - Red
            $'\033[38;5;201m' # L - Pink

            $'\033[00m'       # Reset
        )

        echo
        echo
        printf "      %s██████╗ %s███████╗%s ██████╗     %s███████╗%s██╗  ██╗%s███████╗%s██╗     %s██╗     %s\n" $GRADIENT
        printf "      %s██╔══██╗%s██╔════╝%s██╔════╝     %s██╔════╝%s██║  ██║%s██╔════╝%s██║     %s██║     %s\n" $GRADIENT
        printf "      %s██████╔╝%s█████╗  %s██║  ███╗    %s███████╗%s███████║%s█████╗  %s██║     %s██║     %s\n" $GRADIENT
        printf "      %s██╔══██╗%s██╔══╝  %s██║   ██║    %s╚════██║%s██╔══██║%s██╔══╝  %s██║     %s██║     %s\n" $GRADIENT
        printf "      %s██████╔╝%s██║     %s╚██████╔╝    %s███████║%s██║  ██║%s███████╗%s███████╗%s███████╗%s\n" $GRADIENT
        printf "      %s╚═════╝ %s╚═╝     %s ╚═════╝     %s╚══════╝%s╚═╝  ╚═╝%s╚══════╝%s╚══════╝%s╚══════╝%s\n" $GRADIENT
        echo
        echo
    )
}
