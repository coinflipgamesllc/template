FROM golang:1.16-alpine

RUN apk --no-cache add --update \
    build-base git \
    ruby-full ruby-dev \
    cairo-dev cairo cairo-tools \
    gobject-introspection-dev gobject-introspection \
    gdk-pixbuf-dev gdk-pixbuf \
    pango-dev pango \
    librsvg-dev librsvg && \
    go get github.com/cespare/reflex && \
    gem install bundler

ENV TERM=dumb

WORKDIR /games
COPY Gemfile Gemfile.lock /games/

COPY ./shared/fonts/* /usr/share/fonts/
RUN fc-cache -fv

RUN bundle install
COPY . /games/
