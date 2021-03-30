## PROJECT SETTINGS ##
# Path to bin folder (to hold executables and such), relative to Makefile
BIN_PATH=./bin
# Path to root of build folder (debug and release directories), relative to Makefile
BUILD_PATH=./build
# Target executable (relative to bin)
TARGET=boilerplate.exe
# C compiler
CC=gcc
# Path to source files, relative to Makefile
SRC_PATH=./src
# Extension of source files (i.e .c .cpp)
SRC_EXT=c
# Compilation flags
CFLAGS=-std=c99 -Wall -Wextra -g
# General linker settings
LINK_FLAGS=
# Space-separated pkg-config libraries used by this project
LIBS=
# Path to header files, relative to Makefile
INCLUDE_PATH= ./include

## BUILD SETTINGS ##

# Find all source files in the source directory, sorted by most
SRCS = $(shell find $(SRC_PATH) -name '*.$(SRC_EXT)' | sort -k 1nr | cut -f2-)

# Set the object file names, with the source directory stripped
# from the path, and the build path prepended in its place
OBJS = $(SRCS:$(SRC_PATH)/%.$(SRC_EXT)=$(BUILD_PATH)/%.o)
# Set the dependency files that will be used to add header dependencies
DEPS = $(OBJS:.o=.d)

# Append pkg-config specific libraries if need be
ifneq ($(LIBS),)
	COMPILE_FLAGS += $(shell pkg-config --cflags $(LIBS))
	LINK_FLAGS += $(shell pkg-config --libs $(LIBS))
endif

$(BIN_PATH)/$(TARGET): $(OBJS)
	@echo "Linking: $@"
	$(CC) $(CFLAGS) $^ -o $@

# add dependency files if they exist
-include $(DEPS)

$(BUILD_PATH)/%.o: $(SRC_PATH)/%.$(SRC_EXT)
	@echo "Compiling: $^ -> $@"
	$(CC) -I$(INCLUDE_PATH) $(LIBS) -c $< -o $@

## CLEAN ##
clean:
	rm -f ./bin/*.exe ./build/*.o ./build/*.d
