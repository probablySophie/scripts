# https://junegunn.github.io/fzf/tips/ripgrep-integration/

(RELOAD='reload:rg --column --color=always --no-heading --smart-case {q} || :';
if command -v bat &> /dev/null; then PREVIEW='bat --style=numbers --color=always --highlight-line {2} {1}'; else PREVIEW='cat {1}'; fi
fzf \
	--disabled \
	--ansi \
	--bind "start:$RELOAD" \
	--bind "change:$RELOAD" \
	--delimiter : \
	--preview "$PREVIEW" \
	--preview-window '+{2}+4/3,<80(up)'
)
	# --preview-window '~4,+{2}+4/3,<80(up)'

	# --bind "enter:become:$EDITOR {1} +{2}" \
