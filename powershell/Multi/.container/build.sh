CONTAINER_NAME="multi_pwsh"
DOCKERFILE="dockerfile"

ROOT_DIR="$( dirname "${BASH_SOURCE[0]}" )";

podman build . -f $ROOT_DIR/$DOCKERFILE -t ${CONTAINER_NAME};
