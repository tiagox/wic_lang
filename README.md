Where is Cocucha?
=================

Where is Cocucha? Language

Dependencias:

* make
* gcc
* lex
* yacc

En GNU/Linux Debian y derivados se pueden instalar:

```shell
sudo apt-get install make flex bison build-essential
```

Para compilar el compilador se debe correr:

```shell
make
```

Para compilar un programa usando nuestro compilador:

```shell
./wic ejemplo.wic
```

o bien:

```shell
cat ejemplo.wic | ./wic
```

o bien:

```shell
./wic < ejemplo.wic
```

o bien, puede ser usado como un editor:

```shell
./wic
```

Cuando termine de escribir su programa presione `Ctrl` + `D`.
