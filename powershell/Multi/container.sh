CONTAINER_NAME="multi_pwsh"
ROOT_DIR="$( dirname "${BASH_SOURCE[0]}" )"
if [[ "$(podman image ls | grep "localhost/$CONTAINER_NAME")" == "" ]]; then
	if [[ -f "$ROOT_DIR/.container/build.sh" ]]; then
		. "$ROOT_DIR/.container/build.sh";
	fi
fi

podman run --rm -it -v "$(pwd)":/mount "$CONTAINER_NAME"
