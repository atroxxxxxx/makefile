SHELL:=/bin/bash
# меняем shell на bash

CC=g++
# компилятор 
SRC_DIR=src/
# папка с исходниками
SRC=$(shell find $(SRC_DIR) -iname "*.cpp")
# все .cpp файлы

DEP_DIR=dep/
# папка с зависимостями от заголовочных файлов

OBJ_DIR=obj/
# папка с объектными файлами (уже есть машинные коды, но все зависимости (функции, реализованные в др файлах) описаны, как "должно быть потом подключено" )
OBJ=$(SRC:%.cpp=$(OBJ_DIR)%.o)
# перевод из .cpp в .o с доабвлением в папку obj_dir
BIN_DIR=bin/
# исполняемые файлы
RELEASE_EXE=release
# релиз 
DEBUG_EXE=debug
# дебаг

YELLOW=\e[1;33m
# цвет вывода всего текста после этого
DEFAULT_COLOR=\e[0m
# убирание всего форматирования 

DEP_FLAGS=-MT $@ -MMD -MP -MF $(DEP_DIR)$*.d

run-debug: build-debug
	@./test.sh $(BIN_DIR)$(DEBUG_EXE) "$(ARGS)"
# запуск сценария с отладкой

# название:зависимости сборки
build-debug: $(OBJ) $(BIN_DIR)$(DEBUG_EXE)

# debug_exe в папке bin_dir	
$(OBJ_DIR)%.o: %.cpp $(DEP_DIR)%.d | $(DEP_DIR)
	@# цель сборки. компиляция в .о; все что справа от | это зависимости, обновление которых не влечет пересборку
	@echo -e "$(YELLOW)[SOURCE] $<$(DEFAULT_COLOR)"
	@# отладочная информация, что мы сейчас компилируем в obj
	@mkdir -p $(@D)
	@# создаем папку, если ее нет
	@mkdir -p $(dir $(DEP_DIR)$*)
	@# создает папку, если ее нет (получение директории пути (без самого файла))
	@$(CC) $(DEP_FLAGS) $(C_FLAGS) -c $< -o $@
	@# компиляция
$(BIN_DIR)$(DEBUG_EXE): $(OBJ)
	@# цель сборки — линковка в исп файл debug_exe
	@echo -e "$(YELLOW)[LINK]:$(addprefix \n\t,$(OBJ))$(DEFAULT_COLOR)"
	@mkdir -p $(BIN_DIR)
	@$(CC) $(OBJ) -o "$(BIN_DIR)$(DEBUG_EXE)"
	@# линковка
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

