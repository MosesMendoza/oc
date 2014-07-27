CC=gcc
export HOME=/home/oc
export PREFIX=/opt/tools
export CFLAGS=-I$(PREFIX)/include
export LIBDIR=$(PREFIX)/lib
export LDFLAGS=-Wl,-z,relro,-rpath,$(LIBDIR)
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

retrieve-vim: setup
	cd $(HOME)/sources && wget ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
	touch targets/$@

unpack-vim: retrieve-vim
	cd $(HOME)/unpacked && tar -xf $(HOME)/sources/vim-7.4.tar.bz2
	touch targets/$@

build-vim: unpack-vim
	cd $(HOME)/unpacked/vim74 && \
		./configure && \
		make -j$(PROCS) COPY="cp -p" Q= && make install
	touch targets/$@
