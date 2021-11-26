### Requirements
- GNU/Linux (e.g. Debian, Ubuntu)
- GNU Make
- Git
- Docker

### Install 

1. `git clone https://github.com/Leshkens/docker-orchid-boilerplate.git <project_name>`
2. `cd <project_name> && rm -rf .git`
3. `make init`
4. _(Optional)_ Configure `.env`
5. `make install`

### Usage

1. Run server `make serve` or `make serve-quiet`
2. For create admin user run `make app-cli` and execute `php artisan orchid:admin`
3. Open `localhost` _(default)_ in browser
4. For up containers run `make up`, for down run `make down`