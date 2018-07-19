parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

alias v=nvim
alias s="ssh sunfire.comp.nus.edu.sg"
alias i="ssh root@new.indocomsoft.com"
alias 3="ssh 172.25.76.40"
alias c="ssh sadm@cp3108-8-i.comp.nus.edu.sg"
alias sa="ssh sadm@sourceacademy-i.comp.nus.edu.sg"
alias x="ssh -p8888 new.indocomsoft.com"
alias o="ssh odroid@172.27.211.120"
alias or="ssh -p9999 odroid@new.indocomsoft.com"

alias id="mix archive.install github jeremyjh/dialyxir"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PROMPT_COMMAND="set_prompt; $PROMPT_COMMAND"
set_prompt() {
  local exit=$?

  local red='\e[1;31m'
  local yellow='\e[1;33m'
  local green='\e[1;32m'
  local cyan='\e[1;36m'
  local reset='\e[m'

  if [ "$exit" == 0 ]; then
    local errorcode=0
  else
    local errorcode="\[$red\]$exit"
  fi

  PS1="$errorcode \[$cyan\]\t \[$green\]\u@\h\[$reset\]:\[$yellow\]\w\n\[$reset\]\!$(parse_git_branch) "'\$ '
}

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export GPG_TTY=$(tty)
