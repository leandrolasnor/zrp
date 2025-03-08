ARG ALPINE_VERSION=3.18
ARG RUBY_VERSION=3.2.2
ARG DOCKER_BUILDKIT=1

FROM ruby:$RUBY_VERSION-alpine$ALPINE_VERSION AS base
WORKDIR /workspaces/zrp
RUN gem install bundler --version '2.4.19'
# ENV BUNDLE_DEPLOYMENT false
# ENV BUNDLE_PATH /usr/local/bundle
# ENV BUNDLE_DISABLE_LOCAL_REVISION_CHECK true
# ENV BUNDLE_DISABLE_LOCAL_BRANCH_CHECK true
RUN bundle config --global jobs $(nproc)
RUN apk update && apk add \
    build-base tzdata bash postgresql-client postgresql-dev \
    nano curl font-meslo-nerd shadow zsh-vcs redis yarn \
    git sqlite sqlite-dev zsh wget libc6-compat gcompat tmux
RUN wget -O - https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
    cd jemalloc-5.2.1 && ./configure && make && make install
RUN rm -rf jemalloc*
ENV LD_PRELOAD /usr/local/lib/libjemalloc.so.2

FROM base AS build
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
COPY Gemfile Gemfile.lock ./
COPY react/package.json react/yarn.lock ./react/
COPY socket.io/server/package.json socket.io/server/yarn.lock ./socket.io/server/
COPY socket.io/client/package.json socket.io/client/yarn.lock ./socket.io/client/
COPY .devcontainer/.p10k.zsh /root/.p10k.zsh

FROM build AS devcontainer
# ENV RAILS_ENV development
# ENV NODE_ENV development
# ENV BUNDLE_WITHOUT production
RUN yarn --cwd ./react install
RUN yarn --cwd ./socket.io/server install
RUN yarn --cwd ./socket.io/client install
RUN bundle
COPY . .
