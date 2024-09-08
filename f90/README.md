#

Compilation over-kill
```
gfortran -O3 -march=native -mtune=native -funroll-loops -floop-block -fopenmp --free-form -o gol.out gol_cli.f90
```

## TODO:

- wait interval less than a second

- ncurses for adaptable environment based on viewport
