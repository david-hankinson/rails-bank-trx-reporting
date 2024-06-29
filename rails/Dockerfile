FROM ruby:3.3.0-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential \
        git \
        libvips \
        pkg-config \
        redis-tools \
        ruby-dev \
        g++ \
        curl \
        libsqlite3-0 \
        libvips \
        libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
