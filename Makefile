CC=gcc
export HOME=/home/oc
export PREFIX=/opt/tools
export CFLAGS=-I$(PREFIX)/include

LIBDIR=$(PREFIX)/lib

export LDFLAGS=-Wl,-rpath,$(LIBDIR) -L$(LIBDIR)
export PATH=$(BINDIR):/usr/bin:/bin:/usr/sbin:/sbin

PROCS=$(shell nproc)
VPATH = targets

all: build

build: build-vim

setup:
	mkdir -p targets
	mkdir -p $(HOME)/{unpacked,sources}
	sudo mkdir -p $(PREFIX)
	sudo chown $$USER $(PREFIX)
	touch targets/$@

retrieve-ncurses: setup
	cd $(HOME)/sources && wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz
	touch targets/$@

unpack-ncurses: retrieve-ncurses
	cd $(HOME)/unpacked && tar -xf $(HOME)/sources/ncurses-5.9.tar.gz
	touch targets/$@

build-ncurses: unpack-ncurses
	cd $(HOME)/unpacked/ncurses-5.9 && \
		./configure --prefix=$(PREFIX) && \
		make -j$(PROCS) && make install
	touch targets/$@

retrieve-vim: build-ncurses
	cd $(HOME)/sources && wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
	touch targets/$@

unpack-vim: retrieve-vim
	cd $(HOME)/unpacked && tar -xf $(HOME)/sources/vim-7.4.tar.bz2
	touch targets/$@

build-vim: unpack-vim
	cd $(HOME)/unpacked/vim74 && \
		./configure \
		--prefix=$(PREFIX) \
		LDFLAGS="-L$(LIBDIR) -lncurses" CFLAGS="$(CFLAGS)" && \
		make -j$(PROCS) COPY="cp -p" Q= && make install
	touch targets/$@

clean:
	rm -rf $(HOME)/unpacked/* $(HOME)/targets/unpack-* $(HOME)/targets/build-*

clobber: clean
	rm -rf $(HOME)/sources $(HOME)/targets $(HOME)/unpacked $(PREFIX)/*
