export EDITOR=nvim

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

current_sem=/Users/julius/indocomsoft@gmail.com/\!NUS-CS/CurrentSem
change_to_cur_sem() {
  cd $current_sem
}

download_ivle() {
  pwd=$(pwd)
  change_to_cur_sem
  #./ivle-sync.py files
  #./CS3245/website/update
  cd /Users/julius/GitHub/fluminus_cli
  mix fluminus --download-to=$current_sem
  cd "$pwd"
}

alias sh="sh --noprofile --norc"

alias make="make -j8"

alias w=change_to_cur_sem
alias wf=download_ivle

alias v=nvim
alias s="ssh sunfire.comp.nus.edu.sg"
alias i="ssh root@new.indocomsoft.com"
alias 3="ssh 172.25.76.40"
alias c="ssh sadm@cp3108-8-i.comp.nus.edu.sg"
alias sa="ssh sadm@sourceacademy-i.comp.nus.edu.sg"
alias x="ssh -p8899 new.indocomsoft.com"
alias o="ssh odroid@192.168.1.105"
alias or="ssh -p9999 new.indocomsoft.com"

alias id="mix archive.install github jeremyjh/dialyxir"

alias sas="ssh bitnami@13.229.233.29"
alias sasf="echo 'sshuttle -r bitnami@ec2a 0.0.0.0/0' | pbcopy"
alias sap="ssh bitnami@13.229.136.151 -p1819"
alias sapf="echo 'sshuttle -r bitnami@ec2a 0/0:5432' | pbcopy"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias ls="ls -G"

export PROMPT_COMMAND="set_prompt"
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
export PATH="/usr/local/opt/mongodb@3.4/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/Library/Python/3.7/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/Users/julius/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

eval $(thefuck --alias)

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
