export AWS_PROFILE=staging

# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git asdf)

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias dc="docker-compose"
alias rebuild="dc down && dc build && dc run app python manage.py migrate && dc run app ./manage.py seed_data && dc up"

# remove the need for 'cd' for change directory
setopt autocd

# Autocompletion
autoload -U colors && colors
setopt prompt_subst

# Theme
autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr ' %F{green}●'
zstyle ':vcs_info:*' unstagedstr ' %F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:svn:*' branchformat '%b'
zstyle ':vcs_info:svn:*' formats ' [%b%F{1}:%F{11}%i%c%u%B%F{green}]'
zstyle ':vcs_info:*' enable git svn

theme_precmd () {
  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    zstyle ':vcs_info:git:*' formats ' %b%c%u%F{green}'
  else
    zstyle ':vcs_info:git:*' formats ' %b%c%u%F{red}'
  fi

  vcs_info
}

# Rewrite current working directory to mimic Fish
_collapsed_wd() {
  echo $(pwd | perl -pe "
   BEGIN {
      binmode STDIN,  ':encoding(UTF-8)';
      binmode STDOUT, ':encoding(UTF-8)';
    }; s|^$HOME|~|g; s|/([^/])[^/]*(?=/)|/\$1|g
  ")
}

setopt prompt_subst
PROMPT='%F{blue}$(_collapsed_wd)%F{green}${vcs_info_msg_0_}%F{magenta} %F{white}$ %{$reset_color%}% '

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd

test -d "$HOME/.tea" && source <("$HOME/.tea/tea.xyz/v*/bin/tea" --magic=zsh --silent)
