FROM ruby:3.2.2-alpine3.18
RUN apk update && apk add \
    build-base tzdata git sqlite sqlite-dev zsh bash wget \
    nano curl font-meslo-nerd shadow zsh-vcs redis dos2unix yarn \
    postgresql-dev postgresql-client libc6-compat gcompact
RUN wget -O - https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 | tar -xj && \
    cd jemalloc-5.2.1 && \
    ./configure && \
    make && \
    make install

ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so.2
ENV APP_HOME /workspaces/zrp
WORKDIR $APP_HOME
RUN gem install bundler --version '2.4.19'
COPY . $APP_HOME

RUN bundle
RUN yarn --cwd ./reacting install
RUN yarn --cwd ./socket.io/server install
RUN yarn --cwd ./socket.io/client install

RUN dos2unix ./.devcontainer/boot.sh
RUN chmod +x ./.devcontainer/boot.sh
RUN dos2unix ./.devcontainer/start.sh
RUN chmod +x ./.devcontainer/start.sh

RUN rm -rf /root/.oh-my-zsh
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
RUN usermod --shell /bin/zsh root
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
RUN sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=powerlevel10k\/powerlevel10k/g' ~/.zshrc
RUN sed -i -e '$aPOWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' ~/.zshrc
RUN sed -i -e '$a[[ ! -f /workspaces/zrp/.p10k.zsh ]] || source /workspaces/zrp/.p10k.zsh' ~/.zshrc
