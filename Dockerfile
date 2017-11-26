FROM base/archlinux:latest

LABEL maintainer="https://gcamer.li"

# Add name to Docker image
ENV NAME=42arch

# Update Arch
ENV TERM=xterm
RUN pacman -Syu --noconfirm \
	wget \
	git \
	binutils \
	gcc \
	valgrind \
	make \
	patch \
	htop \
	mlocate \
	expac \
	automake \
	autoconf \
	fakeroot \
	libtool \
	pkg-config \
	xterm \
	unzip \
	autogen \
	yasm \
	openssh \
	xorg-server \
	python \
	python2 \
	python-pip \
	python-virtualenv \
	python2-virtualenv

# Set no password for docker user
RUN pacman --noconfirm -S sudo
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create a new user
RUN useradd -ms /bin/bash docker
USER docker
ENV HOME=/home/docker
WORKDIR $HOME

# Install package-query and yaourt
RUN git clone https://aur.archlinux.org/package-query.git
WORKDIR $HOME/package-query/
RUN makepkg --noconfirm -si
WORKDIR $HOME
RUN git clone https://aur.archlinux.org/yaourt.git
WORKDIR $HOME/yaourt/
RUN makepkg --noconfirm -si
WORKDIR $HOME
RUN rm -rf package-query/ yaourt/

# Install from AUR
RUN yaourt --noconfirm -S zsh
RUN yaourt --noconfirm -S vim

# Install pip package
RUN sudo pip install pika

# Clone and set kerberos
RUN git clone --progress --verbose https://github.com/gcamerli/42krb.git kerberos
WORKDIR $HOME/kerberos/script
RUN sh run.sh
WORKDIR $HOME

# Clone norminette
RUN git clone --progress --verbose https://github.com/gcamerli/42norme.git norminette

# Export variable for norminette
#ENV PATH=$PATH:$HOME/norminette

# Clone and set examshell
RUN git clone --progress --verbose https://github.com/gcamerli/42examshell.git examshell

# Set zsh as default shell
RUN sudo chsh -s /usr/bin/zsh docker

# Set oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
