parse_git_branch() {
    branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/")
    n_modified=$(git diff 2> /dev/null --name-only | wc -l)
    prefix='~'
    # suffix=changes
    # if [ "${n_modified:-1}" == "1" ]; then
    #     suffix=change
    # fi

    if [ -z $branch ]; then
        echo ''
    else
        echo " $branch $prefix $n_modified "
    fi
}

scheme_colors=$(echo "(" $($HOME/colorful-prompt/get-scheme-colors.sh $1) ")")
eval "scheme_colors=$scheme_colors"
# echo $scheme_colors
BASE_COLOR=${scheme_colors[0]}

get_prompt_part() {
    echo "\[\e[1m\e[38;5;$(echo $3)m\]$1$2\[\e[m\]"
}

PS1_TIME=$(get_prompt_part '\t' ' ' $BASE_COLOR)

BASE_COLOR=${scheme_colors[1]}

PS1_CONDA=$(get_prompt_part "\$CONDA_DEFAULT_ENV" ' ' $BASE_COLOR)

BASE_COLOR=${scheme_colors[2]}

PS1_USER=$(get_prompt_part "\u@\h" ' ' $BASE_COLOR)

BASE_COLOR=${scheme_colors[3]}

PS1_DIR=$(get_prompt_part "\w" ' ' $BASE_COLOR)

BASE_COLOR=${scheme_colors[4]}

PS1_BRANCH=$(get_prompt_part "\$(parse_git_branch)" '' $BASE_COLOR)

BASE_COLOR=${scheme_colors[5]}

PS1_TIMER=$(get_prompt_part " \$timer_show" '' $BASE_COLOR)

preexec () {
  timer=${timer:-$(date +%s%N)}
}

precmd () {
  if [[ -z "$BUFFER" ]] && [[ "$timer_show" ]]; then
      unset timer_show
  fi
  
  if [ -z "$timer" ]; then
    return
  fi

  timer_show=$(($(date +%s%N) - $timer))
  timer_show=$(lua $HOME/colorful-prompt/stringify-time.lua $timer_show)
  if [ -z "$ZSH" ]; then
      timer_show=${timer_show::-1}
  else
      timer_show=${timer_show[1,-2]}
  fi
  unset timer
}

if [ -z "$ZSH" ]; then
    trap 'preexec' DEBUG
fi

if [ -z "$PROMPT_COMMAND" ]; then
  PROMPT_COMMAND="precmd"
else
  PROMPT_COMMAND="$PROMPT_COMMAND; precmd"
fi

# generate_ps1() {
#     echo $PS1_TIME$PS1_CONDA$PS1_USER$PS1_DIR$PS1_BRANCH$PS1_TIMER
# }
n_cols=$(tput cols)
if [ "$n_cols" -le "100" ]; then
    # echo small
    if [[ -z $CONDA_DEFAULT_ENV ]]; then
        export PS1="$PS1_TIME$PS1_USER$PS1_DIR: "
    else
        export PS1="$PS1_TIME$PS1_CONDA$PS1_USER$PS1_DIR: "
    fi
else
    if [[ -z $CONDA_DEFAULT_ENV ]]; then
        export PS1="$PS1_TIME$PS1_USER$PS1_DIR$PS1_BRANCH$PS1_TIMER: "
    else
        export PS1="$PS1_TIME$PS1_CONDA$PS1_USER$PS1_DIR$PS1_BRANCH$PS1_TIMER: "
    fi
fi

# %B%F{77}\$CONDA_DEFAULT_ENV%{$reset_color%} \
export PROMPT="\
%B%F{41}%D{%H:%M:%S}%f \
%F{113}\$CONDA_DEFAULT_ENV%f \
%F{149}%n@%m%f \
%F{185}%~%f \
%F{221}\$(parse_git_branch)%f\
%F{226}:%f%b "
export RPROMPT="%B%F{221}\$timer_show%f%b"
