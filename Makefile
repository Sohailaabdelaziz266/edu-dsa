# ==========================================
# USERS
# ==========================================
USER_NAME := $(notdir $(patsubst %/,%,$(CURDIR)))

# ==========================================
# Directories
# ==========================================
# THIS VARIABLE SHOULD BE SET TO THE DIRECTORY OF THE MAIN DIR DEFAULT IS THE CURRENT DIRECTORY
MAIN_DIR  ?= $(CURDIR)
SRC_DIR   := $(MAIN_DIR)/src
INC_DIR   := $(MAIN_DIR)/inc
TEST_DIR  := tests
BUILD_DIR := $(MAIN_DIR)/build
OBJ_DIR   := $(BUILD_DIR)/obj
BIN_DIR   := $(BUILD_DIR)/bin

# ==========================================
# Compiler and Flags
# ==========================================
CXX      := g++
# -pthread is required for Google Test
CXXFLAGS := -Wall -Wextra -std=c++17 -O2 -g -pthread
INCLUDES := -I$(INC_DIR)

# Google Test Linker Flags
TEST_LDFLAGS := -lgtest -lgtest_main -pthread

# ==========================================
# Files
# ==========================================
# Main application sources and objects
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRCS))

# Separate the main.o file so we don't link it into the tests
# (Assumes your main function is in src/main.cpp)
MAIN_OBJ := $(OBJ_DIR)/main.o
LIB_OBJS := $(filter-out $(MAIN_OBJ), $(OBJS))

# Test sources and objects
TEST_SRCS := $(wildcard $(TEST_DIR)/*.cpp)
TEST_OBJS := $(patsubst $(TEST_DIR)/%.cpp, $(OBJ_DIR)/tests/%.o, $(TEST_SRCS))

# Output binaries
APP_BIN  := $(BIN_DIR)/app
TEST_BIN := $(BIN_DIR)/run_tests

# ==========================================
# Targets
# ==========================================
.PHONY: all clean test dirs

# Default target builds the main app
all: dirs $(APP_BIN) test

# Ensure build directories exist
dirs:
	@mkdir -p $(OBJ_DIR)/tests $(BIN_DIR)

# Link the main application
$(APP_BIN): $(OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $@

# Link the test binary WITH Google Test flags
$(TEST_BIN): $(LIB_OBJS) $(TEST_OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(TEST_LDFLAGS)

# Compile source files to object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Compile test source files to object files
$(OBJ_DIR)/tests/%.o: $(TEST_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

debug:
	@echo "Building $(USER_NAME) ..."
	@echo "MAIN_DIR: $(MAIN_DIR)"
	@echo "SRC_DIR: $(SRC_DIR)"
	@echo "INC_DIR: $(INC_DIR)"
	@echo "TEST_DIR: $(TEST_DIR)"
	@echo "BUILD_DIR: $(BUILD_DIR)"
	@echo "OBJ_DIR: $(OBJ_DIR)"
	@echo "BIN_DIR: $(BIN_DIR)"
	@echo "USER_NAME: $(USER_NAME)"
	@echo "CXX: $(CXX)"
	@echo "CXXFLAGS: $(CXXFLAGS)"
	@echo "INCLUDES: $(INCLUDES)"
	@echo "TEST_LDFLAGS: $(TEST_LDFLAGS)"
	@echo "LIB_OBJS: $(LIB_OBJS)"
	@echo "TEST_OBJS: $(TEST_OBJS)"
	@echo "APP_BIN: $(APP_BIN)"
	@echo "TEST_BIN: $(TEST_BIN)"
	@echo "SRCS: $(SRCS)"
	@echo "OBJS: $(OBJS)"
	@echo "MAIN_OBJ: $(MAIN_OBJ)"
	@echo "LIB_OBJS: $(LIB_OBJS)"
	@echo "TEST_OBJS: $(TEST_OBJS)"
	@echo "APP_BIN: $(APP_BIN)"
	@echo "TEST_BIN: $(TEST_BIN)"
# Build and run tests
test: dirs $(TEST_BIN)
	@echo "Building Tests for $(USER_NAME) ..."

run_tests: $(TEST_BIN)
	@echo "Running Tests for $(USER_NAME) ..."
	@./$(TEST_BIN)

# Clean up build artifacts
clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR)

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  all        Build the main application and tests"
	@echo "  test       Build the tests for $(USER_NAME)"
	@echo "  run_tests  Run the tests for $(USER_NAME)"
	@echo "  clean      Clean up build artifacts"
	@echo "  help       Show this help message"
	@echo "  MAIN_DIR   Improtant: The directory of the main directory. You have to set this variable to the directory of the main directory. Default is the current directory."
