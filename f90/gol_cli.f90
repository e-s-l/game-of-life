program gol_cli
    !
    !
    !
    implicit none

    integer :: i, j, max
    integer :: generation, rows, cols
    integer, allocatable, dimension(:,:) :: population

    ! initialise
    call set_up(generation, rows, cols, population)

    !
    max = 10
    
    ! while true
    do while (generation.lt.max) 
        ! print board
        call display(generation, rows, cols, population)
        ! increment generation & calculate new population
        call generate(generation, population)
        ! wait a sec
        call sleep(1)
    end do

    contains 

    subroutine display(generation, rows, cols, population)
        ! can i learn n use ncurses ported to fortran for this?
        implicit none
        integer :: j
        integer :: generation, rows, cols
        integer, dimension(rows,cols) :: population
        character(len=cols) :: line

        ! row = 1: header 
        print *, "Generation: ", generation
        ! row > 1: 
        do i = 1, rows
            line = ""
            do j = 1,cols
                if (population(i,j) == 0) then
                    line(j:j) = "+ "
                else
                    line(j:j) = ". "
                end if
            end do
            print *, line
        end do

    end subroutine display

    subroutine generate(generation, population)
        implicit none
        integer :: generation
        integer, intent(inout), dimension(rows,cols) :: population



        generation = generation + 1

    end subroutine generate
    
    subroutine set_up(generation, rows, cols, population)
        !
        implicit none
        integer :: i, j
        integer :: generation, rows, cols
        integer, allocatable, intent(out), dimension(:,:) :: population
        real, allocatable, dimension(:,:) :: seed

        generation = 0

        ! the classical terminal viewport
        !rows = 24
        !cols = 80
        rows = 12
        cols = 40

        allocate(population(rows,cols))
        allocate(seed(rows,cols))

        call random_number(seed)
        population = floor(2*seed)

    end subroutine set_up


end program gol_cli


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! TODO
! - dynamic board size depending on terminal viewport
!   look into ncurses and linking this to fortran
!   to implement this...
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
