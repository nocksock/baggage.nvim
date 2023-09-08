FROM alpine:latest AS setup

RUN apk --no-cache add zsh git build-base cmake coreutils curl unzip gettext-tiny-dev
RUN git clone https://github.com/neovim/neovim /neovim
WORKDIR /neovim
RUN make CMAKE_BUILD_TYPE=Release && make install
