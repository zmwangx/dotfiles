##################################### META #####################################
alias path='echo $PATH | tr -s ":" "\n"'
alias reload='exec zsh -l'
alias sudo='sudo '

################################## FILESYSTEM ##################################
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias tree='tree -Nv'
alias empty_trash='rm -rf ~/.Trash && mkdir -m 700 ~/.Trash'

################################### SHORTCUT ###################################
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias dev='cd ~/dev/src'
alias tmp='cd ${TMPDIR:-/tmp}'

alias finance='hdiutil attach -stdinpass ~/confidential/finance.sparsebundle'
alias identity='hdiutil attach -stdinpass ~/confidential/identity.sparsebundle'

################################## MULTIMEDIA ##################################
alias ffmpeg='ffmpeg -hide_banner'
alias ffplay='ffplay -hide_banner'
alias ffprobe='ffprobe -hide_banner'
alias m='mpv-launcher-fill-screen'
alias mm='mpv-launcher'
alias mf='mpv-launcher-full-screen'
alias yf='youtube-dl -F'
alias you-get='you-get --debug'
alias youku-dl='youku-dl --debug'
alias yt='youtube-dl'
# "ytp" for "YouTube-dl Portable" (limit to DASH MP4/H.264 and M4A/AAC if at all possible)
alias ytp='youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best/best"'

#################################### PYTHON ####################################
alias p='pmodload python'
alias ip='ipython'
alias ip2='ipython2'
alias ip3='ipython3'
alias syspip3='/usr/local/bin/pip3'

##################################### MISC #####################################
alias acdcli='acdcli --check=none --color=auto'
alias emacs='emacs -nw'
alias emacs-restart='pkill -u $USER "[Ee]macs"; emacs --daemon'
alias ga='git add'
alias goo='googler --noprompt'
alias googler='googler --colors bjdxxy'
alias grip='grip --browser'
alias hb='hub browse'
alias muttd='mutt && rm -f ${TMPDIR:-/tmp}/.new_mail_notification_sent'
alias notify='terminal-notifier -message'
[[ $OSTYPE == darwin* ]] && {
    # Ignore case on OS X (some OS X process names are capitalized, e.g., Python)
    alias pgrep='pgrep -i'
    alias pkill='pkill -i'
}
alias pl='parallel'
alias pld='parallel --dry-run --keep-order'
alias pldx='parallel --dry-run --xapply --keep-order'
alias plk='parallel --keep-order'
alias plx='parallel --xapply'
alias plxk='parallel --xapply --keep-order'
alias spellcheck='aspell check'
alias ss='date +%Y%m%d%H%M%S'
alias tn='tmux new-window'
alias visudo='VISUAL=vi sudo visudo'
# Alias wget with redirected HSTS database only if the --hsts-file option is available
(( $+commands[wget] )) \
    && command wget --help | grep -q -e --hsts-file \
    && alias wget='wget --hsts-file=${XDG_DATA_HOME:-$HOME/.local/share}/wget/wget-hsts'
alias zap='zap-DS_Store'

################################### SUFFIXES ###################################
alias -s markdown='grip'
alias -s md='grip'
alias -s rst='restview'
alias -s text='grip'

################################### UNALIAS ####################################
(( $+aliases[gdm] )) && unalias gdm
