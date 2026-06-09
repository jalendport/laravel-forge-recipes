#!/usr/bin/env bash

#######################################
########### INSTALL DOCKER ############
#######################################
#
# Installs Docker Engine, the CLI, containerd, and the Compose plugin on a
# Laravel Forge server (Ubuntu) using Docker's official apt repository.
#
# Run as: root
#
#######################################

set -euo pipefail

echo "Removing any conflicting / outdated Docker packages"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
	apt-get remove -y "$pkg" || true
done

echo "Installing prerequisites"
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ca-certificates curl gnupg

echo "Adding Docker's official GPG key"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "Setting up the Docker apt repository"
ARCH="$(dpkg --print-architecture)"
CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")"
echo \
	"deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${CODENAME} stable" \
	> /etc/apt/sources.list.d/docker.list

echo "Installing Docker Engine, CLI, containerd, and plugins"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Enabling and starting the Docker service"
systemctl enable --now docker

# CONFIG_DOCKER_USER: Forge's default deploy user. Adding it to the `docker`
# group lets deployment scripts run docker commands without sudo.
CONFIG_DOCKER_USER="forge"
if id "$CONFIG_DOCKER_USER" &>/dev/null; then
	echo "Adding \`$CONFIG_DOCKER_USER\` to the \`docker\` group"
	usermod -aG docker "$CONFIG_DOCKER_USER"
fi

echo "Verifying installation"
docker --version
docker compose version

echo "Done!"
