parse_git_branch() {
    branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/")
    n_modified=$(git diff 2> /dev/null --name-only | wc -l)
    suffix=changes
    if [ "${n_modified:-1}" == "1" ]; then
        suffix=change
    fi
    echo $branch \($n_modified $suffix\)
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

PS1_BRANCH=$(get_prompt_part "\$(parse_git_branch)" ' ' $BASE_COLOR)

BASE_COLOR=${scheme_colors[5]}

PS1_TIMER=$(get_prompt_part "\$timer_show" ' ' $BASE_COLOR)

function timer_start {
  timer=${timer:-$(date +%s%N)}
}

function timer_stop {
  timer_show=$(($(date +%s%N) - $timer))
  timer_show=$(lua $HOME/stringify-time.lua $timer_show)
  timer_show=${timer_show::-1}
  unset timer
}

trap 'timer_start' DEBUG

if [ "$PROMPT_COMMAND" == "" ]; then
  PROMPT_COMMAND="timer_stop"
else
  PROMPT_COMMAND="$PROMPT_COMMAND; timer_stop"
fi

# generate_ps1() {
#     echo $PS1_TIME$PS1_CONDA$PS1_USER$PS1_DIR$PS1_BRANCH$PS1_TIMER
# }
n_cols=$(tput cols)
if [ "$n_cols" -le "100" ]; then
    # echo small
    export PS1="$PS1_TIME$PS1_CONDA$PS1_USER$PS1_DIR: "
else
    export PS1="$PS1_TIME$PS1_CONDA$PS1_USER$PS1_DIR$PS1_BRANCH$PS1_TIMER: "
fi
