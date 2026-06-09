# Install Docker Recipe for Laravel Forge

## Overview

This recipe installs Docker Engine, the Docker CLI, containerd, and the Docker Compose plugin on a Laravel Forge server. It uses Docker's official apt repository (rather than Ubuntu's bundled `docker.io` package) so you get the latest stable release and the modern `docker compose` plugin.

## Requirements

- **Laravel Forge**: This is run as a [Forge Recipe](https://forge.laravel.com/docs/servers/recipes)
- **Ubuntu**: Forge provisions Ubuntu servers, which this recipe targets
- **Run as `root`**: The recipe needs root to manage apt packages and system services

## Installation

1. Copy the [entire script](install-docker.sh)
2. In Laravel Forge, navigate to the "Recipes" section
3. Create a new recipe and paste in the script
4. Set the recipe **User** to `root`
5. Run the recipe against your desired server(s)

> [!NOTE]
> Recipes can be run on demand from the Forge dashboard, or automatically when a new server is provisioned.

## What It Does

1. Removes any conflicting or outdated Docker packages
2. Installs prerequisites (`ca-certificates`, `curl`, `gnupg`)
3. Adds Docker's official GPG key and apt repository
4. Installs Docker Engine, CLI, containerd, Buildx, and the Compose plugin
5. Enables and starts the Docker service
6. Adds the `forge` user to the `docker` group so deployment scripts can run Docker commands without `sudo`
7. Verifies the installation by printing the Docker and Compose versions

## Configuration Options

### `CONFIG_DOCKER_USER`

```bash
# CONFIG_DOCKER_USER: Forge's default deploy user. Adding it to the `docker`
# group lets deployment scripts run docker commands without sudo.
CONFIG_DOCKER_USER="forge"
```

The user added to the `docker` group. Defaults to Forge's `forge` deploy user. The script only adds the user if it exists on the server.

> [!IMPORTANT]
> Membership in the `docker` group grants root-equivalent privileges. Only add trusted users.
