ARG DOCKER_BUILDKIT=1

FROM ruby:$RUBY_VERSION-alpine$ALPINE_VERSION AS base
RUN apk update && apk add \
    build-base git sqlite zsh wget \
    nano curl font-meslo-nerd shadow zsh-vcs redis yarn \
    postgresql-client libc6-compat gcompat tmux

RUN wget -O - https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
    cd jemalloc-5.2.1 && configure && make && make install
ENV LD_PRELOAD /usr/local/lib/libjemalloc.so.2

COPY .devcontainer/.p10k.zsh ~/.p10k.zsh
RUN rm -rf /root/.oh-my-zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
RUN usermod --shell /bin/zsh root
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
RUN sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=powerlevel10k\/powerlevel10k/g' ~/.zshrc
RUN sed -i -e '$aPOWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' ~/.zshrc
RUN sed -i -e '$a[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' ~/.zshrc

FROM build AS devcontainer
WORKDIR /workspaces/zrp
COPY Gemfile Gemfile
COPY react/package.json react/package.json
COPY socket.io/server/package.json socket.io/server/package.json
COPY socket.io/client/package.json socket.io/client/package.json
RUN bundle
RUN yarn --cwd ./react install
RUN yarn --cwd ./socket.io/server install
RUN yarn --cwd ./socket.io/client install
COPY . .
