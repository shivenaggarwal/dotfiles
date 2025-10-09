# ALIASES
alias ls='ls --color'
alias la='ls -A'
alias pog='vim $(fzf-tmux)'
alias lsa='exa --long'
alias con="tmux attach-session -t"

PROMPT='%F{167}∂%f %B%F{240}%1~ %f%b'

export EDITOR="nvim"

gsl(){ git log --pretty=oneline --abbrev-commit | fzf --preview-window down:70% --preview 'echo {} | cut -f 1 -d " " | xargs git show --color=always'; }
# export PATH="$HOME/miniconda3/bin:$PATH"  # commented out by conda initialize

# >>> conda initialize >>>
__conda_setup="$('/Users/s/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/s/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/s/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/s/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

