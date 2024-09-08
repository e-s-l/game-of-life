program gol_cli
    !
    !
    !
    implicit none

    integer :: i, j, end, k
    integer :: generation, rows, cols
    integer, allocatable, dimension(:,:) :: population, next_gen

    ! initialise
    call set_up(generation, k, rows, cols, population, next_gen)

    !
    end = 1000
    
    ! while true
    do while (generation.lt.end) 
        ! print board
        call display(generation, rows, cols, population)
        ! increment generation & calculate new population
        call generate(generation, k, rows, cols, population, next_gen)
        ! wait a sec
        call sleep(1)
    end do

    !!!!!!!!
    contains
    !!!!!!!!

    subroutine display(generation, rows, cols, population)
        ! can i learn n use ncurses ported to fortran for this?
        ! probs better just to redo it all in c then really...
        implicit none
        integer :: j
        integer :: generation, rows, cols
        integer, dimension(rows,cols) :: population
        character(len=cols) :: line

        ! row = 1: header 
        print *, "Generation: ", generation
        ! row > 1: the board 
        do i = 1, rows
            line = repeat(' ', cols)
            do j = 1,cols
                if (population(i,j) == 0) then
                    line(j:j) = "."
                else
                    line(j:j) = "+"
                end if
            end do
            print *, line
        end do
    end subroutine display

    
    subroutine set_up(generation, k, rows, cols, population, next_gen)
        !
        implicit none
        integer :: i, j, k
        integer :: generation, rows, cols
        integer, allocatable, intent(out), dimension(:,:) :: population, next_gen
        real, allocatable, dimension(:,:) :: seed

        generation = 0
        k = 0

        ! the classical terminal viewport is (24, 80)
        rows = 12
        cols = 40

        allocate(population(rows,cols))
        allocate(seed(rows,cols))

        call random_number(seed)
        population = floor(2*seed)

        allocate(next_gen(rows,cols))

    end subroutine set_up

    subroutine generate(generation, k, rows, cols, population, next_gen)
        !
        implicit none
        integer, intent(inout) :: generation, rows, cols
        integer, intent(inout), allocatable, dimension(:, :) :: population, next_gen
        integer :: noln, i, j, k
        real :: rmin, rmax, cmin, cmax

        ! initialise the whole next gen array to zeros, for starts
        next_gen = 0

        do i = 1, rows
            do j = 1, cols

     
                cmin = INT(MAX(j-1, 1))
                cmax = INT(MIN(cols,j+1))
                rmin = INT(MAX(i-1,1))
                rmax = INT(MIN(rows,i+1))
                noln = SUM(population(rmin:rmax, cmin:cmax)) - population(i, j)

                if (population(i,j) == 1) then
                    if (noln.lt.2 .or. noln.gt.3) then
                        next_gen(i,j) = 0
                    else 
                        next_gen(i,j) = 1
                    end if
                else
                    if (noln == 3) then 
                        next_gen(i,j) = 1
                   end if
                end if
            end do
        end do

        !!!   
        if (ALL(next_gen==population)) then
            k = k + 1;
            if (k.gt.5) then 
                print *, 'stable, restarting'
                call set_up(generation, rows, cols, population, next_gen)
            end if
        end if
        !!!
        population = next_gen
        generation = generation + 1

    end subroutine generate
    
end program gol_cli


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! TODO
! - dynamic board size depending on terminal viewport
!   look into ncurses and linking this to fortran
!   to implement this...
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
