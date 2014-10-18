#!/usr/bin/env bash

echo -e Compilando lexico.
flex lexico.l

echo -e Compilando sintaxis.
yacc -d sintaxis.y

echo -e Compilando compilador.
cc -o wic lex.yy.c y.tab.c -ly -ll -lm

echo -e Eliminado archivos temporales.
rm lex.yy.c
rm y.tab.c
rm y.tab.h
