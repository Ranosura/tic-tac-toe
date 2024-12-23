#!/bin/bash

# tic-tac-toe: primitive implementation of tic tac toe.

A1=" " A2=" " A3=" " B1=" " B2=" " B3=" " C1=" " C2=" " C3=" "
player="x"
loop=0

game_exit () {
	echo "$player won the game!"
	sleep 1
	exit 0
}

check_state () {
	[[ ($A1 == $player && $A2 == $player && $A3 == $player) ]] && game_exit
	[[ ($B1 == $player && $B2 == $player && $B3 == $player) ]] && game_exit
	[[ ($C1 == $player && $C2 == $player && $C3 == $player) ]] && game_exit
	[[ ($A1 == $player && $B1 == $player && $C1 == $player) ]] && game_exit
	[[ ($A2 == $player && $B2 == $player && $C3 == $player) ]] && game_exit
	[[ ($A3 == $player && $B3 == $player && $C3 == $player) ]] && game_exit
	[[ ($A1 == $player && $B2 == $player && $C3 == $player) ]] && game_exit
	[[ ($A3 == $player && $B2 == $player && $C1 == $player) ]] && game_exit
	return 0
}

print_field () {
	cat <<- _EOF_
	 === === ===
	| $A1 | $A2 | $A3 |
	 === === ===
	| $B1 | $B2 | $B3 |
	 === === ===
	| $C1 | $C2 | $C3 |
	 === === ===
	_EOF_
}

game () {
	while (( $loop < 9 )); do
		clear -x
		print_field
		read -p "Enter the coordinates in form of n,n: "
		
		if [[ "$REPLY" =~ ^([1-3],[1-3])$ ]]; then
			if [[ $REPLY == "1,1" && $A1 == " " ]]; then
				A1=$player
			elif [[ $REPLY == "1,2" && $A2 == " " ]]; then
				A2=$player
			elif [[ $REPLY == "1,3" && $A3 == " "  ]]; then
				A3=$player
			elif [[ $REPLY == "2,1" && $B1 == " " ]]; then
				B1=$player
			elif [[ $REPLY == "2,2" && $B2 == " " ]]; then
				B2=$player
			elif [[ $REPLY == "2,3" && $B3 == " " ]]; then
				B3=$player
			elif [[ $REPLY == "3,1" && $C1 == " " ]]; then
				C1=$player
			elif [[ $REPLY == "3,2" && $C2 == " " ]]; then
				C2=$player
			elif [[ $REPLY == "3,3" && $C3 == " " ]]; then
				C3=$player
			else 
				echo "The coordinate is already occupied."
				sleep 2
				continue
			fi
			
			# Checking the state before changing the player parameter is important to not double the amount of conditional expressions.
			check_state
			loop=$((loop+1))
			if [[ $player == "x" ]]; then
				player="o"
			else
				player="x"
			fi

		else
			echo "There are no such coordinates."
			sleep 2
			continue
		fi
	done
	echo "The game ended with tie"
	exit 0
}

while true; do
	clear -x
	echo -e "Tic Tac Toe
(1) Play
(0) Exit"
	read -p "Select menu entry: "
	if [[ $REPLY == 1 ]]; then
		game
		break
	elif [[ $REPLY == 0 ]]; then
		echo "The program terminated"
		break
	else 
		echo "There is no such selection."
		sleep 1
	fi
done
