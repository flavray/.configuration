export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="flazz"
CASE_SENSITIVE="true"

plugins=(git osx)

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source $ZSH/oh-my-zsh.sh

alias ae=". env/bin/activate"
alias b="bundle exec"
alias macdown="open -a /Applications/MacDown.app"
alias pyg="pygmentize"
alias sl="ls -1 | sort -f"
alias tree="tree -C"
alias v="mvim --remote-silent"

export GOPATH=$HOME/CS/go
export PATH=$PATH:$GOPATH/bin

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
