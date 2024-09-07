program gol_cli
    !
    !
    !
    implicit none

    integer :: i, j, max
    integer :: generation, rows, cols
    integer, allocatable, dimension(:,:) :: population, next_gen

    ! initialise
    call set_up(generation, rows, cols, population, next_gen)

    !
    max = 1000
    
    ! while true
    do while (generation.lt.max) 
        ! print board
        call display(generation, rows, cols, population)
        ! increment generation & calculate new population
        call generate(generation, rows, cols, population, next_gen)
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

    
    subroutine set_up(generation, rows, cols, population, next_gen)
        !
        implicit none
        integer :: i, j
        integer :: generation, rows, cols
        integer, allocatable, intent(out), dimension(:,:) :: population, next_gen
        real, allocatable, dimension(:,:) :: seed

        generation = 0

        ! the classical terminal viewport is (24, 80)
        rows = 12
        cols = 40

        allocate(population(rows,cols))
        allocate(seed(rows,cols))

        call random_number(seed)
        population = floor(2*seed)

        allocate(next_gen(rows,cols))

    end subroutine set_up

    subroutine generate(generation, rows, cols, population, next_gen)
        !
        implicit none
        integer, intent(inout) :: generation, rows, cols
        integer, intent(inout), dimension(rows, cols) :: population, next_gen
        integer :: noln, i, j
        real :: rmin, rmax, cmin, cmax, k

        ! initialise the whole next gen array to zeros, for starts
        next_gen = 0

        do i = 2, (rows-1)
            do j = 2, (cols-1)

         !        print *, max(8, 2)
        !        c_min = MAX(j, 2)
        !        cmax = min(cols,j+1)
        !        rmin = max(i,2)
        !        rmax = min(rows,i+1)
                noln = sum(population(i-1:i+1, j-1:j+1)) - population(i, j)

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
