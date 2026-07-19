# FLATPAKS="$(flatpak list --json --columns=name,description)"

LIST_FLATPAKS='flatpak list --json --columns=name,description,version,branch,application';
MATCH_NAMED='jq -r ".[] | select(.name == \"$(echo {+})\")"'

UPDATE_CMD="xargs -I '{}' flatpak update -y --non-interactive '{}'"
HEADER='<Ctrl-u> Update'

flatpak list --json --columns=name,description \
	| jq -r '.[].name' \
	| sort --unique --reverse \
	| fzf \
		--preview "$LIST_FLATPAKS | $MATCH_NAMED" \
		--preview-window '+{2}+4/3,<80(up)' \
		--header "$HEADER"


# We're not updating or anything because that's all sudo stuff :(
		# --bind "ctrl-u:execute-silent( $LIST_FLATPAKS | $MATCH_NAMED | jq -r '.application_id' | $UPDATE_CMD )"
