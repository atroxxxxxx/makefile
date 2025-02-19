SHELL:=/bin/bash

CC=g++
SRC_DIR=src/
SRC=$(shell find $(SRC_DIR) -iname "*.cpp")

DEP_DIR=dep/

OBJ_DIR=obj/
OBJ=$(SRC:%.cpp=$(OBJ_DIR)%.o)
BIN_DIR=bin/
RELEASE_EXE=release
DEBUG_EXE=debug

YELLOW=\e[1;33m
DEFAULT_COLOR=\e[0m

DEP_FLAGS=-MT $@ -MMD -MP -MF $(DEP_DIR)$*.d

run-debug: build-debug
	@./test.sh $(BIN_DIR)$(DEBUG_EXE) "$(ARGS)"

build-debug: $(OBJ) $(BIN_DIR)$(DEBUG_EXE)

$(OBJ_DIR)%.o: %.cpp $(DEP_DIR)%.d | $(DEP_DIR)
	@echo -e "$(YELLOW)[SOURCE] $<$(DEFAULT_COLOR)"
	@mkdir -p $(@D)
	@mkdir -p $(dir $(DEP_DIR)$*)
	@$(CC) $(DEP_FLAGS) $(C_FLAGS) -c $< -o $@
$(BIN_DIR)$(DEBUG_EXE): $(OBJ)
	@echo -e "$(YELLOW)[LINK]:$(addprefix \n\t,$(OBJ))$(DEFAULT_COLOR)"
	@mkdir -p $(BIN_DIR)
	@$(CC) $(OBJ) -o "$(BIN_DIR)$(DEBUG_EXE)"
$(DEP_DIR)%.d:

DEP:=$(SRC:%.cpp=$(DEP_DIR)%.d)
$(DEP_DIR): 
	@mkdir -p $@
$(DEP):
include $(wildcard $(DEP))

.PHONY: clear
clear:
	@if [ -e $(OBJ_DIR) ]; then rm -rf $(OBJ_DIR); fi
	@if [ -e $(BIN_DIR) ]; then rm -rf $(BIN_DIR); fi
	@if [ -e $(DEP_DIR) ]; then rm -rf $(DEP_DIR); fi

