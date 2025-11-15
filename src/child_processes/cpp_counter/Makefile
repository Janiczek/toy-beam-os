# C++ Emscripten Counter Makefile

# Compiler
CXX = em++

# Source and output
SRC = counter.cpp
OUT_DIR = ../../../dist/child_processes/cpp_counter
OUT_JS = $(OUT_DIR)/counter.js
OUT_WASM = $(OUT_DIR)/counter.wasm

# Compiler flags
CXXFLAGS = -std=c++17 \
           -O3 \
           -s WASM=1 \
           -s MODULARIZE=1 \
           -s EXPORT_ES6=1 \
           -s EXPORT_NAME=createCounterModule \
           -s ALLOW_MEMORY_GROWTH=1 \
           -s NO_EXIT_RUNTIME=1 \
           --bind

# Default target
all: $(OUT_JS)

# Create output directory if it doesn't exist
$(OUT_DIR):
	mkdir -p $(OUT_DIR)

# Build the WASM module
$(OUT_JS): $(SRC) | $(OUT_DIR)
	$(CXX) $(CXXFLAGS) $(SRC) -o $(OUT_JS)

# Clean build artifacts
clean:
	rm -rf $(OUT_DIR)

# Rebuild
rebuild: clean all

.PHONY: all clean rebuild

