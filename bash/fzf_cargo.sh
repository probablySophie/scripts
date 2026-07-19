INPUTS="cargo install --list";
REMOVE_QUOTES="BEGIN{ gsub(/'\''/, \"\", pat) }";
RELOAD="reload:$INPUTS | awk '!/^\s/ {print \$1}'"

fzf \
	--bind "start:$RELOAD" \
	--bind "Ctrl-r:$RELOAD" \
	--preview "$INPUTS | awk -v pat=\"{}\" '$REMOVE_QUOTES index(\$0,pat) { found=1; print; next } found { if (/^[ \t]/) print; else exit }'" \
	--preview-window '+{2}+4/3,<80(up)'

