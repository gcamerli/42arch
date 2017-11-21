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
	xorg-server

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

# Set environment variables
#ENV PATH=$PATH:$HOME/norminette

# Install from AUR
RUN	yaourt --noconfirm -S zsh
RUN	yaourt --noconfirm -S vim
RUN	sudo pacman --noconfirm -S python
RUN	sudo pacman --noconfirm -S python2
RUN	sudo pacman --noconfirm -S python-pip
RUN	sudo pacman --noconfirm -S python-virtualenv
RUN	sudo pacman --noconfirm -S python2-virtualenv
RUN	sudo pacman --noconfirm -S python-pip

# Install pip package
RUN sudo pip install pika

# Clone and set examshell
RUN git clone --progress --verbose https://github.com/lefta/examshell42.git examshell
WORKDIR $HOME/examshell
RUN sudo ./install.sh
WORKDIR $HOME

# Clone norminette
RUN git clone --progress --verbose https://github.com/lefta/Norminette42.git norminette
WORKDIR $HOME

# Set zsh as default shell
RUN sudo chsh -s /usr/bin/zsh docker

# Set oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
