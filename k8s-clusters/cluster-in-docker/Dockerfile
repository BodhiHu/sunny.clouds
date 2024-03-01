FROM ubuntu:20.04 
 
WORKDIR /app
 
RUN printf "\
# tencent mirrors\
deb http://mirrors.cloud.tencent.com/ubuntu/ focal main restricted universe multiverse\
deb http://mirrors.cloud.tencent.com/ubuntu/ focal-updates main restricted universe multiverse\
deb http://mirrors.cloud.tencent.com/ubuntu/ focal-backports main restricted universe multiverse\
deb http://mirrors.cloud.tencent.com/ubuntu/ focal-security main restricted universe multiverse\
\
deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main\
deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/ kubernetes-xenial main\
\
$(cat /etc/apt/sources.list)\
" > /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y vim-tiny net-tools iputils-ping curl bash-completion

# Install Docker CE
RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common
# RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | apt-key add -
#RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
RUN add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y docker-ce

# Setup OpenSSH
RUN apt-get -y install openssh-server openssh-client

RUN chsh -s /bin/bash
RUN printf "\
$(cat ~/.bashrc)\
\n\
\n\
export PS1=\"🌻\[\033[01;32m\] \W\[\033[00m\] \"\
export PATH=$PATH:/app/clouds-native/.bin\
\n\
" > ~/.bashrc

CMD tail -f /dev/null
