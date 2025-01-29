#!/bin/bash

# tic-tac-toe: implementation of tic tac toe.

# For some reason I didn't thought of emulating 2d array using associative array.
# Credit for inspiration: https://github.com/AshutoshNirkhe/tic-tac-toe/blob/master/tic-tac-toe.sh
declare -A field
PROGNAME="${0#*/}" player="x" loop=0 log=0

# Initialize array.
for ((r=1; r<=3; r++)); do
	for ((c=1; c<=3; c++)); do 
		field[$r,$c]=" "
	done
done

usage () {
	cat <<- EOF
	$PROGNAME - tic-tac-toe implementation in bash
	
	$PROGNAME [-h|-l FILE] 
	    -h display this message
	    -l log the game in visual form to file FILE
	
	EOF
	exit 0
}

game_exit () {
	echo "$player won the game!"
	sleep 1
	exit 0
}

check_state () {
	local winstr="$player$player$player"
	
	# Check horizontal lines.
	for ((r=1; r<=3; r++)); do
		[[ "$winstr" == "$(for ((c=1; c<=3; c++)); do echo -n "${field[$r,$c]}"; done)" ]] && game_exit
	done
	
	# Check vertical lines.
	for ((c=1; c<=3; c++)); do
		[[ "$winstr" == "$(for ((r=1; r<=3; r++)); do echo -n "${field[$r,$c]}"; done)" ]] && game_exit
	done
	
	# At last check diagonal lines.
	[[ "$winstr" == "${field[1,1]}${field[2,2]}${field[3,3]}" ]] && game_exit
	[[ "$winstr" == "${field[1,3]}${field[2,2]}${field[3,1]}" ]] && game_exit
	return 0
}

print_field () {
	for ((r=1; r<=3; r++)); do
		printf "	 ===========\n"
		printf "	| %s | %s | %s |\n" "${field[$r,1]}" "${field[$r,2]}" "${field[$r,3]}"
	done
	printf "	 ===========\n"
}

game () {
	while (( $loop < 9 )); do
		clear -x
		print_field
		read -p "Position form nth row nth column: " r c
		
		# Validation of input.
		if [[ ${field[$r,$c]} == " " ]]; then
			field[$r,$c]=$player
		elif [[ ! ( -v field[$r,$c] ) ]]; then
			echo "This position doesn't exist."
			sleep 2
			continue
		else
			echo "This position is already occupied."
			sleep 2
			continue
		fi
		
		[[ $log == 1 ]] && print_field | tr -d "\t" >> "$file" 

		check_state
		((loop+1))

		if [[ $player == "x" ]]; then
			player="o"
		else
			player="x"
		fi
	done
	echo "The game ended with tie"
	exit 0
}

log () {
	file="$1"
	if [[ -n $file ]]; then
		if [[ -e "$file" ]]; then
			read -p "Filename $file already exist. Do you want to rewrite it? [Y|y] [N|n]: "
			case $REPLY in 
				Y|y) : > "$file" 
				     log=1
				     game 
				     ;;
				N|n) exit 0 
					;;
				*) echo "No such choice. Abort." && exit 1
					;;
			esac
		else
			log=1
			game
		fi
	else
		echo "Filename wasn't set."
		exit 1
	fi
}

[[ -n "$1" ]] && case "$1" in 
	-h)	usage ;;
	-l)	log "$2"
		game ;;
	 *)	usage ;;
esac

game