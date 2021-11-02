### Requirements
- GNU/Linux (e.g. Debian, Ubuntu)
- GNU Make
- Git
- Docker

### Install 

1. `git clone https://github.com/Leshkens/docker-orchid-boilerplate.git && git remote rm origin`
2. `make init`
3. _(Optional)_ Configure `.env`
4. `make install`

### Usage

1. Run server `make serve` or `make serve-quiet`
2. For create admin user run `make app-cli` and execute `php artisan orchid:admin`