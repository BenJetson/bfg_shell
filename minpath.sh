#!/bin/bash

bfg_minpath() {
    local min_path=""
    local abs_path=""
    local segments=()
    local s

    # Replace $HOME with ~ and then all / with newline (\n) for loop.
    local resolved_path
    resolved_path="$(sed "s,^$HOME,~,; s,/,\n,g" <<< "$PWD")"

    while IFS=$'\n' read -r segments; do
        for s in "${segments[@]}"; do
            bfg_minpath_status() {
                echo "__"
                echo "segment: $s"
                echo "min_path: $min_path"
                echo "abs_path: $abs_path"
            }


            if [ "$s" = "~" ]; then
                min_path+='~''/'
                abs_path+="$HOME/"
                bfg_minpath_status
                echo "home detect"
                echo "--"
                continue
            fi


            if [ -d "$abs_path$s/"'.git' ]; then
                abs_path+="$s/"
                min_path+=$''"$s"$'/'
                bfg_minpath_status
                echo "git detect"
                echo "--"
                continue
            fi

            set +x
            local i
            local min_segment=""
            echo "minimizing: $s"
            for ((i=0; i<${#s}; i++ )); do
                min_segment+="${s:$i:1}"
                echo "char: ${s:$i:1}"

                local matches
                # echo "find \"$abs_path\" -maxdepth 0 -name \"$min_segment*\" | wc -l | awk '{ print \$1 }'"
                matches=$(find -- "$abs_path"* -maxdepth 0 -name "$min_segment*" | wc -l | awk '{ print $1 }')
                if [ "$matches" -eq 1 ]; then
                    min_path+="$min_segment/"
                    break;
                fi

            done

            # min_path+="$s"'/'
            abs_path+="$s/"


            bfg_minpath_status
            echo "not special"
            echo "--"
        done
    done <<< "${resolved_path}"
}
