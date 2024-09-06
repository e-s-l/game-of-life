#

Compilation over-kill
```
gfortran -O3 -march=native -mtune=native -funroll-loops -floop-block -fopenmp --free-form -o gol.out gol_cli.f90
```
