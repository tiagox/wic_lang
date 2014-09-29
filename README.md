Where is Cocucha?
=================

Where is Cocucha? Language

Para compilar el compilador se deben correr los siguientes comandos.

```shell
$ flex lexico.l
$ yacc -d sintaxis.y
$ cc -o wic lex.yy.c y.tab.c -ly -ll -lm
$ ./wic
```

