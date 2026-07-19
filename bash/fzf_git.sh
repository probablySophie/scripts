git status --porcelain=v1 \
	| cut -c 4- \
	| fzf \
		--preview 'bat "$(git rev-parse --show-toplevel)/{}" '
