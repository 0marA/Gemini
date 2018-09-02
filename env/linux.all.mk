CC=g++
CFLAGS_ALL=-Os -Wfatal-errors -Wunreachable-code -Wextra -Wall -std=c++17 -fdiagnostics-color=never

LIB_DIRS= \
	/usr/local/lib \
	~/SFML-2.5.0/lib

INCLUDE_DIRS= \
	/usr/local/include \
	~/SFML-2.5.0/include

BUILD_DEPENDENCIES=

PRODUCTION_DEPENDENCIES= \
	content

PRODUCTION_EXCLUDE= \
	*.psd \
	*.rar \
	*.7z \
	Thumbs.db

PRODUCTION_FOLDER=build