#!/bin/bash

default_scheme_name=autumn
scheme_name=${1:-$default_scheme_name}

generate_periodic_scheme() {
    base=$1
    increment=$2
    color_codes=($base $((base + increment)) $((base + 2 * increment)) $((base + 3 * increment)) $((base + 4 * increment)) $((base + 5 * increment)))
    echo ${color_codes[@]}
}


# get_scheme_colors() {
#     if [ "$scheme_name" = "autumn" ]; then
#         scheme=$(generate_periodic_scheme 41 36)
#     elif [ "$scheme_name" = "sunrise" ]; then
#         scheme=$(generate_periodic_scheme 16 36)
#     elif [ "$scheme_name" = "sunset" ]; then
#         scheme=$(generate_periodic_scheme 196 -36)
#     fi
# }

get_scheme_colors() {
    if [ "$1" = "autumn" ]; then
        echo $(generate_periodic_scheme 41 36)
    elif [ "$1" = "sunrise" ]; then
        echo $(generate_periodic_scheme 17 36)
    elif [ "$1" = "sunset" ]; then
        echo $(generate_periodic_scheme 197 -36)
    fi
}

# echo ${scheme[@]}
scheme=$(get_scheme_colors $scheme_name) 
if [ -z "$scheme" ]; then
    scheme=$(get_scheme_colors $default_scheme_name)
fi

echo ${scheme[@]}
