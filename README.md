# Primo New UI Customization Docker Development Environment

[![Build Status](https://travis-ci.org/thatbudakguy/primo-explore-devenv-docker.svg?branch=master)](https://travis-ci.org/thatbudakguy/primo-explore-devenv-docker) [![](https://images.microbadger.com/badges/version/watzek/primo-explore-devenv.svg)](http://microbadger.com/images/watzek/omeka "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/watzek/primo-explore-devenv.svg)](https://microbadger.com/images/watzek/omeka "Get your own image badge on microbadger.com")

## Downloading:

ensure the latest versions of `docker` and `docker-compose` are installed.

download the project with:
```sh
git clone https://github.com/thatbudakguy/primo-explore-devenv-docker.git
```
or download a zip file using the green download button above and unzip.

`docker-compose.example.yml` contains an example configuration for the development environment. you will need to rename it `docker-compose.yml` and make some changes (detailed below) to start working.

## Usage:

### Setup

you need a view code package to use the development environment. you can provide your own by downloading it from the "back office", or acquire a fresh one from [here](https://github.com/ExLibrisGroup/primo-explore-package).

to add a view to the development environment, ensure that the line:
```yml
volumes:
  - /path/to/my/view/code/:/home/node/primo-explore-devenv/custom/NAME_OF_VIEW
```
appears in your `docker-compose.yml`, where the path on the left is the absolute path to your view code folder.

- to select a view, edit the `VIEW` property in `docker-compose.yml` to match the name you provided in the `volumes` stanza, e.g. `NAME_OF_VIEW`.
- to select a proxy server to view live primo results, edit the `PROXY` property in `docker-compose.yml`.

to start developing, open a terminal in this directory and run:
```sh
docker-compose up
```

- logs will be displayed in your terminal.
- you can edit the files in your package's folder and changes will be made in real-time.
- you can observe the view using a browser at `localhost:8003/primo-explore/search?vid=NAME_OF_VIEW`.

### Changing views

first, ensure that the line:
```yml
volumes:
  - /path/to/my/other/view/:/home/node/primo-explore-devenv/custom/NAME_OF_OTHER_VIEW
```
appears in your `docker-compose.yml`, providing access to the new view.

to change the currently displayed view, edit the `VIEW` property in `docker-compose.yml`, open a terminal in the project directory, and run:
```sh
docker-compose restart
```

- making changes to `VIEW` or `PROXY` will require the above restart command to take effect.
- you can add as many views as you like to the `volumes` stanza.
- you can add a central package by mounting it in the above manner and naming it `CENTRAL_PACKAGE`.

### Creating packages

first, make sure that the line:
```yml
volumes:
  - ./:/home/node/primo-explore-devenv/packages
```
appears in your `docker-compose.yml` file, so that packages will appear outside the container.

to create a package, open a terminal in this directory and run:
```sh
docker-compose run server gulp create-package
```
select a package when prompted. the zip file will appear in this folder.
