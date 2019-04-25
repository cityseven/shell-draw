#!/bin/bash

function draw() {
  set_min_max
  statusbar
  tput cup ${line} ${column}
  echo "*"
}

function set_min_max() {
  min_line=0
  max_line=$(expr ${window_lines} - 2)
  if (( line < min_line )); then line=${min_line}; fi;
  if (( line > max_line )); then line=${max_line}; fi;
  min_column=0
  max_column=$(expr ${window_columns} - 2)
  if (( column < min_column )); then column=${min_column}; fi;
  if (( column > max_column )); then column=${max_column}; fi;
}

function set_window() {
  previous_window_lines=${window_lines}
  previous_window_columns=${window_columns}
  window_lines=$(tput lines)
  window_columns=$(tput cols)
  if [[ "$previous_window_lines" != "$window_lines" ]] | [[ "$previous_window_columns" != "$window_columns" ]]; then
    tput clear
  fi
}

function statusbar() {
  tput cup 0 0
  tput rev
  echo "  DRAW  ${line} x ${column}  "
  tput sgr0
}

tput clear
tput civis # Hide cursor

set_window
set_min_max
line=$((max_line/2))
column=$((max_column/2))
draw

while read -r -sn1 key
do
  set_window
  case "$key" in
    A) line=$((line - 1)); draw;;     # UP
    B) line=$((line + 1)); draw;;     # DOWN
    C) column=$((column + 1)); draw;; # RIGHT
    D) column=$((column - 1)); draw;; # LEFT
  esac
done
