# Primo New UI Customization Docker Development Environment

[![Build Status](https://travis-ci.org/thatbudakguy/primo-explore-devenv-docker.svg?branch=master)](https://travis-ci.org/thatbudakguy/primo-explore-devenv-docker) [![](https://images.microbadger.com/badges/version/watzek/primo-explore-devenv.svg)](http://microbadger.com/images/watzek/omeka "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/watzek/primo-explore-devenv.svg)](https://microbadger.com/images/watzek/omeka "Get your own image badge on microbadger.com")

## Downloading:

ensure the latest versions of `docker` and `docker-compose` are installed.

download the project with:
```sh
git clone https://github.com/thatbudakguy/primo-explore-devenv-docker.git
```
or download a zip file using the green download button above and unzip.

## Usage:

### Setup

you need a view code package to use the development environment. you can provide your own by downloading it from the "back office" and adding it to the `views` folder, or acquire a fresh one from [here](https://github.com/ExLibrisGroup/primo-explore-package).

to select a view, edit the `VIEW` property in `docker-compose.yml` to match the name of your view code folder.

to select a proxy server to view live primo results, edit the `PROXY_SERVER` property in `docker-compose.yml`.

from the project directory (`primo-explore-devenv-docker`), open a terminal and run:
```sh
docker-compose up
```

logs from gulp will be displayed in your terminal.

you can observe the view code using a browser at `localhost:8003/primo-explore/search?vid=YOUR_VIEW_NAME_HERE`.

### Changing views

you can edit the files in your package's folder and changes will be made in real-time.

to change views, add a new view code folder to the `views` folder, change the `VIEW` property in `docker-compose.yml`, open a terminal in the project directory, and run:
```sh
docker-compose restart
```

### Creating packages

to create a package, open a terminal in the project directory and run:
```sh
docker-compose run server gulp create-package
```
select a package when prompted. the zip file will appear in the `packages` folder.
