#!/usr/bin/env bash

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist." >&2
    exit 1
fi

find "$TARGET_DIR" -name "*.bas" -exec sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' {} + | awk '
BEGIN {
    in_proc = 0
    current_proc = ""
    procs_found = 0
}

# Match procedure start: e.g. "my_proc: procedure"
/^[ \t]*[a-z0-9_]+:[ \t]*procedure/ {
    split($0, parts, ":")
    gsub(/[ \t]/, "", parts[1])
    current_proc = parts[1]
    in_proc = 1
    procs_found++
    next
}

# Match procedure end: e.g. "end" or "end procedure"
/^[ \t]*end([ \t]+procedure)?([ \t]*$|[ \t]+.*)/ {
    in_proc = 0
    current_proc = ""
    next
}

in_proc {
    line = $0

    # Strip single-quote and REM comments
    sub(/\x27.*/, "", line)
    sub(/[ \t]*rem.*/, "", line)

    # Strip string literals
    gsub(/"[^"]*"/, "", line)

    # Split into words/identifiers
    n = split(line, words, /[^a-z0-9_]+/)
    for (i = 1; i <= n; i++) {
        w = words[i]

        if (w ~ /^[a-z_][a-z0-9_]*$/) {

            # Filter keywords and hardware registers
            if (w ~ /^(if|then|else|elseif|end|procedure|goto|gosub|return|for|to|step|next|while|wend|do|loop|exit|dim|as|integer|byte|bit|const|varptr|poke|peek|usr|call|asm|and|or|not|xor|mod|col[0-7]|#backtab|#mobshadow|cont[1-4]|sound|music|sprite|screen|border|cls|wait|print|data|include|select|case|signed|unsigned|option)$/) {
                continue
            }

            key = w "|||" current_proc
            seen[key] = 1
            var_list[w] = 1
        }
    }
}

END {
    if (procs_found == 0) {
        print "DEBUG: Found 0 PROCEDURE blocks. Please check your procedure header syntax."
        exit
    }

    printf "%-20s  %-20s\n", "VARIABLE NAME", "PROCEDURE"
    printf "%-20s  %-20s\n", "--------------------", "--------------------"

    for (v in var_list) {
        count = 0
        single_p = ""

        for (key in seen) {
            split(key, parts, "|||")
            if (parts[1] == v) {
                count++
                single_p = parts[2]
            }
        }

        if (count == 1) {
            printf "%-20s  %-20s\n", v, single_p
        }
    }
}
'
