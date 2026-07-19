# podman image ls --format json

# podman container ls --all --format json

# podman volume ls --format json
JQ_SELECT="[.Image, .Status, .CreatedAt, .Id]"

REFRESH_PROCESSES="podman ps --format json | jq -r \".[] | $JQ_SELECT | @tsv\" "

# INFO: Running processes
# podman ps --format json \
# 	| jq -r ".[] | $JQ_SELECT | @tsv" \
	# | fzf \
	# fzf \
	# 	-d \\t \
	# 	--bind "start:reload:$REFRESH_PROCESSES" \
	# 	--bind "change:reload:$REFRESH_PROCESSES || :" \
	# 	--bind "Ctrl-r:reload:$REFRESH_PROCESSES" \
	# 	--bind 'Ctrl-a:become:(podman attach {4})' \
	# 	--bind 'Ctrl-d:execute:(podman kill {4})' \
	# 	--preview "podman ps --format json | jq -r '.[] | select(.Id == \"{4}\")'" \
	# 	--header '<Ctrl-a> Attach  <Ctrl-d> Kill  <Ctrl-r> Reload'

		# --nth 1.. \

PODMAN_IMAGES='podman images --format json'
fzf \
	--bind "start:reload:$PODMAN_IMAGES | jq '.[].Id'" \
	--bind "Ctrl-r:reload:$PODMAN_IMAGES | jq '.[].Id'" \
	--preview "$PODMAN_IMAGES | jq '.[] | select(.Id == \"{}\")'" \
	--bind "Ctrl-d:execute(podman image rm {})"
