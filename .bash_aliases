export PS1="\[\033[38;5;2m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;6m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;178m\]\w\[$(tput sgr0)\]\\$ "
alias ps1='export PS1="\[\033[38;5;2m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;6m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;178m\]\w\[$(tput sgr0)\]\\$ "'
alias ps2='export PS1="\[\033[38;5;2m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;6m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;178m\]\w\[$(tput sgr0)\]\\$ wp|$(tf_prompt_info) $(kube_ps1) (aws:$AWS_PROFILE) \n\\$ \[$(tput sgr0)\]"'

