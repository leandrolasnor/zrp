ARG RUBY_VERSION=3.4.2
ARG DOCKER_BUILDKIT=1

FROM ruby:$RUBY_VERSION-slim AS base
WORKDIR /workspaces/zrp
ENV TZ=America/Sao_Paulo
ENV PATH=$PATH:/workspaces/zrp/bin
ENV XDG_CONFIG_HOME=/workspaces/zrp
ENV BUNDLE_DEPLOYMENT=false
ENV BUNDLE_PATH=/usr/local/bundle
ENV BUNDLE_DISABLE_LOCAL_REVISION_CHECK=true
ENV BUNDLE_DISABLE_LOCAL_BRANCH_CHECK=true
RUN bundle config --global jobs $(nproc)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential libjemalloc2 git wget curl \
    cmake pkg-config libpq-dev openssh-client \
    shared-mime-info zsh libyaml-dev tmux lsb-release
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y nodejs yarn && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

FROM base AS build
COPY Gemfile Gemfile.lock ./
COPY package.json package.json
COPY yarn.lock yarn.lock
COPY react/package.json ./react/package.json
COPY socket.io/server/package.json ./socket.io/server/package.json
COPY socket.io/client/package.json ./socket.io/client/package.json
COPY .devcontainer/.p10k.zsh /root/.p10k.zsh
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
ENV RAILS_ENV=development
ENV NODE_ENV=development
ENV BUNDLE_WITHOUT=production
RUN yarn
RUN bundle
COPY . .
CMD ["tail", "-f", "/dev/null"]
