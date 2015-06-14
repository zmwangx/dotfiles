# A simple restview wrapper, so that when restview is invoked without
# arguments, automatically restview the project README.rst.
function restview
{
    local dir
    local readme
    (( $+commands[restview] )) || { echo "${BOLD}${RED}error: restview command not found${RESET}" >&2; return 1; }
    if [[ $# == 0 ]]; then
        # search parent directories for README.rst
        dir=$PWD
        while [[ -n $dir ]]; do
            [[ -e $dir/README.rst ]] && { readme="$dir/README.rst"; break; }
            dir="${dir%/*}"
        done
        if [[ -n $readme ]]; then
            echo "${BOLD}${GREEN}previewing '$readme'${RESET}" >&2
            command restview "$readme"
        else
            echo "${BOLD}${RED}error: README.rst not found${RESET}" >&2
        fi
    else
        command restview "$@"
    fi
}

# This function serves to undo a mv in an easy-to-type way (navigate to earlier
# mv command and prepend "un").
function unmv
{
    [[ $# == 2 ]] || { echo "${RED}error: unmv takes exactly two arguments and moves $2 to $1${RESET}" >&2; return 1; }
    mv "$2" "$1"
}
