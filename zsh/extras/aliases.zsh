##################################### META #####################################
alias path='echo $PATH | tr -s ":" "\n"'
alias reload='exec zsh -l'
alias sudo='sudo '

################################## FILESYSTEM ##################################
alias rm='safe-rm'
alias empty_trash='rm -rf ~/.Trash'

################################### SHORTCUT ###################################
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias dev='cd ~/dev/src'
alias scpt='cd ~/dev/scripts'
alias tmp='cd /tmp'

alias finance='hdiutil attach -stdinpass ~/confidential/finance.sparsebundle'
alias identity='hdiutil attach -stdinpass ~/confidential/identity.sparsebundle'

################################## MULTIMEDIA ##################################
alias ffmpeg='ffmpeg -hide_banner'
alias ffplay='ffplay -hide_banner'
alias ffprobe='ffprobe -hide_banner'
alias probe='ffprobe'
alias m='mpv-launcher'
alias yd="youtube-dl -o '%(upload_date)s-%(title)s__yt-%(id)s.%(ext)s' --write-sub"
alias yf='youtube-dl -F'
alias yt='youtube-dash-dl'

#################################### PYTHON ####################################
alias ip='ipython'
alias ip2='ipython2'
alias ip3='ipython3'
alias syspip3='/usr/local/bin/pip3'

##################################### MISC #####################################
alias ga='git add'
alias git.io='git-hub-shorten-url'
alias muttd='mutt && rm -f /tmp/.new_mail_notification_sent'
alias notify='terminal-notifier -message'
alias onedrive-cli='onedrive-cli --config ${XDG_CONFIG_HOME:-$HOME/.config}/onedrive/python-onedrive.yml'
alias pl='parallel'
alias pld='parallel --dry-run --keep-order'
alias pldx='parallel --dry-run --xapply --keep-order'
alias plk='parallel --keep-order'
alias plx='parallel --xapply'
alias plxk='parallel --xapply --keep-order'
alias spellcheck='aspell check'
alias spider='wget --spider'
alias wget='wget --no-check-certificate --continue --header="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"'
alias zap='zap-DS_Store'
