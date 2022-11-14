ifeq ($(OS),Windows_NT)
	LIBEXT=dll
	PROGEXT=.exe
	LIBS=-lgdi32
else
	UNAME:=$(shell uname -s)
	PROGEXT=
	ifeq ($(UNAME),Darwin)
		LIBEXT=dylib
		LIBS=-framework Cocoa
	else ifeq ($(UNAME),Linux)
		LIBEXT=so
		LIBS=-lX11
	else
		$(error OS not supported by this Makefile)
	endif
endif
SOURCES=$(wildcard src/*.c)
SOURCE=pp.c
CC=clang

default: library

$(SOURCE): $(SOURCES)
	ruby tools/generate.rb

library: $(SOURCE)
	$(CC) -shared -fpic $(LIBS) -Ilib/bitmap $^ -o build/libpp.$(LIBEXT)

.PHONY: default library
