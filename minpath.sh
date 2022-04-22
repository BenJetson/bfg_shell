#!/bin/bash

bfg_minpath() {
    local min_path=""
    local abs_path=""
    local segments=()
    local s

    # Replace $HOME with ~ and then all / with newline (\n) for loop.
    local resolved_path
    resolved_path="$(sed "s,^$HOME,~,; s,/,\n,g" <<< "$PWD")"

    # Read path segments into an array for easy manipulation.
    while IFS=$'\n' read -r s; do
        segments+=( "$s" )
    done <<< "${resolved_path}"

    # Build the minimum path from segments.
    local s_idx
    for (( s_idx=1; s_idx<=$#segments; s_idx++ )); do
        s="${segments[$s_idx]}"

        if [ -z "$s" ]; then
            # When segment is empty, this indicates a leading slash.
            min_path+="/"
            abs_path+="/"
            continue
        elif [ "$s_idx" -eq "${#segments[@]}" ]; then
            # Always spell the last segment out in full, and no trailing slash.
            min_path+="$s"
            abs_path+="$s"
            continue
        elif [ "$s" = "~" ]; then
            # Special case for tilde to modify absolute path.
            min_path+='~''/'
            abs_path+="$HOME/"
            continue
        elif [ -d "$abs_path$s/"'.git' ]; then
        # elif [ "$s_idx" -eq 2 ] || [ -d "$abs_path$s/"'.git' ]; then
            # Always show the full name of git repo roots.
            abs_path+="$s/"
            min_path+=$''"$s"$'/'
            continue
        fi

        # This segment can be minimized. We will use the following algorithm:
        # Go through the segment string, adding one character from the segment
        # to min_segment at a time. Check if that min_segment is shared by any
        # other files/directories in that directory. If not, this is the minimum
        # path, otherwise continue.

        local i=0
        local min_segment=""
        for ((i=0; i<${#s}; i++ )); do
            min_segment+="${s:$i:1}"

            local matches=""
            matches="$(
                find -- "$abs_path"* \
                    -maxdepth 0 \
                    -name "$min_segment*" \
                | wc -l \
                | awk '{ print $1 }'
            )"

            if [ "$matches" -eq 1 ] || [ "$i" -eq $((${#s}-1)) ]; then
                min_path+="$min_segment/"
                break;
            fi
        done

        abs_path+="$s/"
    done

    PROMPT+="$min_path"
}
