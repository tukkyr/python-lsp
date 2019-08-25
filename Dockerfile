FROM python:3-buster

COPY .vimrc /root
COPY .tmux.conf /root
COPY .config /root/.config

RUN apt-get update && apt-get install -y vim jq ssh-client tmux && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O ${HOME}/.git-prompt.sh \
 # && echo 'test -r ~/.bashrc && . ~/.bashrc' >> ${HOME}/.bash_profile \
 && HISTSIZE=50000 \
 && HISTFILESIZE=50000 \
 && HISTCONTROL=ignoreboth \
 && HISTTIMEFORMAT='%FT%T%z ' \
 && HISTIGNORE='ls*:exit*:history*:cd\ -:cd:cd\ \.\.' \
 && echo 'export TZ="Asia/Tokyo"' >> ${HOME}/.bashrc \
 && echo 'stty stop undef' >> ${HOME}/.bashrc \
 && echo 'alias vi="vim"' >> ${HOME}/.bashrc \
 && echo 'alias tmux="tmux -2"' >> ${HOME}/.bashrc \
 && echo . ${HOME}/.git-prompt.sh >> ${HOME}/.bashrc \
 && echo GIT_PS1_SHOWDIRTYSTATE=1 >> ${HOME}/.bashrc \
 && echo GIT_PS1_SHOWUPSTREAM=1 >> ${HOME}/.bashrc \
 && echo GIT_PS1_SHOWUNTRACKEDFILES=1 >> ${HOME}/.bashrc \
 && echo GIT_PS1_SHOWSTASHSTATE=1  >> ${HOME}/.bashrc \
 && echo "PS1='\[\e[33m\]\D{%H:%M:%S}\[\e[m\] \[\e[36m\]\h:\W\[\e[m\] \[\e[1;32m\]\$(__git_ps1 \"< %s > \")\[\e[m\]\$ '" >> ${HOME}/.bashrc

RUN curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
 && vim -c PlugInstall -c q -c q

# RUN pip --no-cache-dir install python-language-server pytest flake8 flake8-mypy mypy

WORKDIR /app

COPY dev-requirements.txt /root

CMD ["sleep", "infinity"]
