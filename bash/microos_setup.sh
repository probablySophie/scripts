# Super basic setting up OpenSUSE's MicroOS for container hosting :)

# She's not actually going to install until we restart
transactional-update pkg in tmux

# Portainer!
podman volume create portainer_data # make a volume
sudo systemctl enable --now podman.socket # Enable the podman socket
podman run \
	-d -p 9443:9443 \
	--privileged --restart=always \
	-v /run/podman/podman.sock:/var/run/docker.sock:Z \
	-v portainer_data:/data \
	docker.io/portainer/portainer-ce:latest # run portainer!

# Create a symlink to the podman sock, because then some docker things will behave
ln -s /run/podman/podman.sock /var/run/docker.sock

# Ask systemd to start our podman --restart=always containers on boot
systemctl enable podman-restart.service

