CC=clang++
CFLAGS_ALL=-Os -Wfatal-errors -Wunreachable-code -Wextra -Wall -std=c++17 -fdiagnostics-color=never

LIB_DIRS= \
	/usr/local/lib

INCLUDE_DIRS= \
	/usr/local/include

BUILD_DEPENDENCIES=

PRODUCTION_DEPENDENCIES= \
	content

PRODUCTION_EXCLUDE= \
	*.psd \
	*.rar \
	*.7z \
	Thumbs.db \
	.DS_Store

PRODUCTION_FOLDER=build