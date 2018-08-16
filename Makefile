#==============================================================================
# Build platform
PLATFORM?=linux
# Build description (Primarily uses Debug/Release)
BUILD?=Release
_BUILDL:=$(shell echo $(BUILD) | tr A-Z a-z)

# Platform specific environment variables
include env.mk
-include env/.$(_BUILDL).mk
-include env/$(PLATFORM).all.mk
-include env/$(PLATFORM).$(_BUILDL).mk

#==============================================================================
# File/Folder dependencies for the production build recipe (makeproduction)
PRODUCTION_DEPENDENCIES?=
# Extensions to exclude from production builds
PRODUCTION_EXCLUDE?=
# Folder location (relative or absolute) to place the production build into
PRODUCTION_FOLDER?=build

#==============================================================================
# Project .cpp or .rc files (relative to src directory)
SOURCE_FILES?=Main.cpp
# Project subdirectories within src/ that contain source files
PROJECT_DIRS?=
# Library directories (separated by spaces)
LIB_DIRS?=
INCLUDE_DIRS?=
# Link libraries (separated by spaces)
LINK_LIBRARIES?=

# Build-specific preprocessor macros
BUILD_MACROS?=
# Build-specific compiler flags to be appended to the final build step (with prefix)
BUILD_FLAGS?=

# Build dependencies to copy into the bin/(build) folder - example: openal32.dll
BUILD_DEPENDENCIES?=

# NAME should always be passed as an argument from tasks.json as the root folder name, but uses a fallback of "game.exe"
# This is used for the output filename (game.exe)
NAME?=game.exe

#==============================================================================
# Add prefixes to the above variables
_LIB_DIRS:=$(patsubst %,-L%,$(LIB_DIRS))
_INCLUDE_DIRS:=$(patsubst %,-I%,$(INCLUDE_DIRS))

_BUILD_MACROS:=$(patsubst %,-D%,$(BUILD_MACROS))
_LINK_LIBRARIES:=$(patsubst %,-l%,$(LINK_LIBRARIES))

#==============================================================================
# Directories & Dependencies
ODIR:=src/obj/$(BUILD)
_RESS:=$(SOURCE_FILES:.rc=.res)
_OBJS:=$(_RESS:.cpp=.o)
OBJS:=$(patsubst %,$(ODIR)/%,$(_OBJS))
SUBDIRS:=$(patsubst %,$(ODIR)/%,$(PROJECT_DIRS))

DEPDIR:=src/dep/$(BUILD)
DEPSUBDIRS:=$(patsubst %,$(DEPDIR)/%,$(PROJECT_DIRS))
_DEPS:=$(SOURCE_FILES:.cpp=.d)
DEPS:=$(patsubst %,$(DEPDIR)/%,$(_DEPS))
$(shell mkdir -p $(DEPDIR) >/dev/null)

_BUILD_DEPENDENCIES:=$(patsubst %,bin/$(BUILD)/%,$(notdir $(BUILD_DEPENDENCIES)))

#==============================================================================
# Compiler & flags
CC?=g++
RC?=windres.exe
CFLAGS_ALL?=-Wfatal-errors -Wextra -Wall -fdiagnostics-color=never
CFLAGS?=-g $(CFLAGS_ALL)
CFLAGS_DEPS=-MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td

POST_COMPILE=@mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d && touch $@

#==============================================================================
# Build Scripts
all: makebuild

rebuild: clean makebuild

buildprod: makebuild makeproduction

#==============================================================================
# Build Recipes
$(ODIR)/%.o: src/%.cpp
$(ODIR)/%.o: src/%.cpp $(DEPDIR)/%.d | $(ODIR) $(SUBDIRS) $(DEPDIR) $(DEPSUBDIRS)
	$(CC) $(CFLAGS_DEPS) $(_BUILD_MACROS) $(CFLAGS) $(_INCLUDE_DIRS) -o $@ -c $<
	$(POST_COMPILE)

$(ODIR)/%.o: src/%.c
$(ODIR)/%.o: src/%.c $(DEPDIR)/%.d | $(ODIR) $(SUBDIRS) $(DEPDIR) $(DEPSUBDIRS)
	$(CC) $(CFLAGS_DEPS) $(_BUILD_MACROS) $(CFLAGS) $(_INCLUDE_DIRS) -o $@ -c $<
	$(POST_COMPILE)

$(ODIR)/%.res: src/%.rc
$(ODIR)/%.res: src/%.rc src/%.h | $(ODIR) $(SUBDIRS) $(DEPDIR) $(DEPSUBDIRS)
	$(RC) -J rc -O coff -i $< -o $@

bin/$(BUILD)/%.dll:
	$(foreach dep,$(BUILD_DEPENDENCIES),$(shell cp -r $(dep) bin/$(BUILD)))

bin/$(BUILD)/%.so:
	$(foreach dep,$(BUILD_DEPENDENCIES),$(shell cp -r $(dep) bin/$(BUILD)))

bin/$(BUILD)/$(NAME): $(OBJS) bin/$(BUILD) $(_BUILD_DEPENDENCIES)
	$(CC) $(_LIB_DIRS) -o $@ $(OBJS) $(_LINK_LIBRARIES) $(BUILD_FLAGS)

makebuild: bin/$(BUILD)/$(NAME)
	@echo '$(BUILD) build target is up to date.'


$(ODIR) $(SUBDIRS) $(DEPDIR) $(DEPSUBDIRS):
	mkdir -p $@

bin:
	mkdir -p $@

bin/$(BUILD): bin
	mkdir -p $@

.PHONY: clean
clean:
	$(RM) bin/$(BUILD)/$(NAME)
	$(RM) $(DEPS)
	$(RM) $(OBJS)

#==============================================================================
# Production recipes
rmbuild:
	- rm -r $(PRODUCTION_FOLDER)

mkdirbuild:
	mkdir -p $(PRODUCTION_FOLDER)

releasetobuild: bin/Release
	cp $</* $(PRODUCTION_FOLDER)

makeproduction: rmbuild mkdirbuild releasetobuild
	$(foreach dir,$(PRODUCTION_DEPENDENCIES),$(shell cp -r $(dir) $(PRODUCTION_FOLDER)))
	$(foreach excl,$(PRODUCTION_EXCLUDE),$(shell find $(PRODUCTION_FOLDER) -name '$(excl)' -delete))

#==============================================================================
# Dependency recipes
$(DEPDIR)/%.d: ;
.PRECIOUS: $(DEPDIR)/%.d

include $(wildcard $(DEPS))