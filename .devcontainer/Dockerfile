ARG RUBY_VERSION=3.4.2
ARG DOCKER_BUILDKIT=1

FROM ruby:$RUBY_VERSION-slim AS devcontainer
WORKDIR /workspaces/zrp
ENV RAILS_ENV=development \
    NODE_ENV=development \
    YARN_ENABLE_TELEMETRY=0 \
    GEM_HOME=/workspaces/zrp/.gem \
    BUNDLE_WITHOUT=production \
    BUNDLE_DEPLOYMENT=false \
    BUNDLE_RETRY=false \
    BUNDLE_JOBS=$(nproc) \
    BUNDLE_RETRY=5 \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_DISABLE_POSTIT=1 \
    BUNDLE_DISABLE_LOCAL_REVISION_CHECK=true \
    BUNDLE_DISABLE_LOCAL_BRANCH_CHECK=true \
    XDG_CONFIG_HOME=/workspaces/zrp \
    TZ=America/Sao_Paulo
ENV PATH=/workspaces/zrp/bin:$PATH
ENV PATH=$GEM_HOME/bin:$PATH
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential libjemalloc2 git wget curl ca-certificates \
    cmake pkg-config libpq-dev openssh-client nodejs npm \
    shared-mime-info zsh libyaml-dev tmux lsb-release && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
RUN npm install -g corepack && \
    corepack prepare yarn@stable --activate

RUN rm -rf /root/.oh-my-zsh
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN usermod --shell /bin/zsh root
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
RUN sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=powerlevel10k\/powerlevel10k/g' ~/.zshrc
RUN sed -i -e '$aPOWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' ~/.zshrc
RUN sed -i -e '$a[[ ! -f .devcontainer/.p10k.zsh ]] || source .devcontainer/.p10k.zsh' ~/.zshrc
RUN curl -fsSL https://opencode.ai/install | bash
COPY . .
RUN bundle install
RUN corepack yarn install --no-immutable
