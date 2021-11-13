ARG PHP_VERSION

FROM php:${PHP_VERSION}

ARG NODE_VERSION
ARG NVM_VERSION
ARG LARAVEL_VERSION
ARG ORCHID_VERSION
ARG HOST_FILES_OWNER_UID
ARG HOST_FILES_OWNER_NAME

MAINTAINER Alexey Chugunov <web@achugunov.ru>

RUN apt-get update \
    && apt-get install -y \
        git \
        unzip \
    && docker-php-ext-install -j$(nproc) bcmath pdo_mysql opcache \
    && pecl install apcu  \
    && pecl install xdebug \
    && docker-php-ext-enable apcu xdebug \
    && pear install PHP_CodeSniffer

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
    && rm -f /tmp/composer-setup.*

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && . ~/.bashrc \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /var/www/app

WORKDIR /var/www/app

RUN adduser --uid ${HOST_FILES_OWNER_UID} ${HOST_FILES_OWNER_NAME} \
    && usermod -a -G root ${HOST_FILES_OWNER_NAME}

USER ${HOST_FILES_OWNER_NAME}
