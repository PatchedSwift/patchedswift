#!/bin/bash

DRIVE="/run/media/deck/c081ba96-afa6-405d-834d-7c5c4d95ff66"

echo "Scanning for games..."

while true; do

    GAME_FILES=($(find "$DRIVE" -name "game.txt" 2>/dev/null))

    if [ ${#GAME_FILES[@]} -eq 0 ]; then
        echo "No games found."
        sleep 5
        continue
    fi

    echo
    echo "==== Steam Game Menu ===="
    echo

    INDEX=1

    declare -a IDS
    declare -a NAMES

    for FILE in "${GAME_FILES[@]}"; do

        NAME=$(grep "^name=" "$FILE" | cut -d= -f2-)
        ID=$(grep "^id=" "$FILE" | cut -d= -f2-)

        if [ -n "$ID" ]; then

            if [ -z "$NAME" ]; then
                NAME="Unknown Game"
            fi

            echo "$INDEX) $NAME ($ID)"

            IDS[$INDEX]="$ID"
            NAMES[$INDEX]="$NAME"

            ((INDEX++))
        fi
    done

    echo
    read -p "Select a game number (or q to quit): " CHOICE

    if [ "$CHOICE" = "q" ]; then
        exit
    fi

    GAME_ID="${IDS[$CHOICE]}"

    if [ -n "$GAME_ID" ]; then

        echo "Launching ${NAMES[$CHOICE]}..."

        steam "steam://rungameid/$GAME_ID" &
    else
        echo "Invalid selection."
    fi

    echo
    read -p "Press Enter to refresh menu..."
    clear

done
