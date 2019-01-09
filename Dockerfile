FROM ubuntu:18.04

RUN mkdir /json_playground
WORKDIR /json_playground

# Basics
RUN apt-get update && apt upgrade -qqy && \
    DEBIAN_FRONTEND=noninteractive apt-get -qqy --no-install-recommends install build-essential libpq-dev libxml2 libxml2-dev libxslt1-dev locales locate man netcat-openbsd nodejs ruby2.5 ruby2.5-dev ruby-bundler silversearcher-ag ssh vim zlib1g zlib1g-dev zlibc && \
    mkdir -p /usr/local/etc && \
    { \
      echo 'install: --no-document'; \
      echo 'update: --no-document'; \
    } >> /usr/local/etc/gemrc

# Locale and Timezone
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_NUMERIC=en_US.UTF-8 \
    LC_TIME=en_US.UTF-8 \
    LC_COLLATE=en_US.UTF-8 \
    LC_MONETARY=en_US.UTF-8 \
    LC_MESSAGES=en_US.UTF-8 \
    LC_PAPER=en_US.UTF-8 \
    LC_NAME=en_US.UTF-8 \
    LC_ADDRESS=en_US.UTF-8 \
    LC_TELEPHONE=en_US.UTF-8 \
    LC_MEASUREMENT=en_US.UTF-8 \
    LC_IDENTIFICATION=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN echo "en_US UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    sed -i -E 's/# (set convert-meta off)/\1/' /etc/inputrc && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install tzdata && \
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

COPY ./Gemfile* /json_playground/
RUN bundle install -j4

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]

CMD ["puma", "-C", "config/puma.rb", "-e", "development", "-p", "3000"]
