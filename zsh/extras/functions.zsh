# This function serves to undo a mv in an easy-to-type way (navigate to earlier
# mv command and prepend "un").
function unmv
{
    [[ $# == 2 ]] || { echo "${RED}error: unmv takes exactly two arguments and moves $2 to $1${RESET}" >&2; return 1; }
    mv "$2" "$1"
}
