!
! Solving deadlock issue with using MPI_Isend
!
program deadlock_nb
  use mpi_f08
  implicit none
  integer :: myRank, ierror, i
  integer :: a(5), b(5)
  TYPE(MPI_Status) :: status
  TYPE(MPI_Request) :: request

  call MPI_Init(ierror)
  call MPI_Comm_rank(MPI_COMM_WORLD,myRank,ierror)

  if (myRank .eq. 0) then
    a=(/2345,654,96574,-12,7676/)
    call MPI_Isend(a, 5, MPI_INTEGER, 1, 100, MPI_COMM_WORLD, request, ierror)
    call MPI_Recv(b, 5, MPI_INTEGER, 1, 101, MPI_COMM_WORLD, status, ierror)
    call MPI_Wait(request, status)
    do i=1, 5
      write(*,*) 'b(', i, ')=', b(i)
    end do
  else if (myRank .eq. 1) then
    b=(/-2345,-654,-96574,12,-7676/)
    call MPI_Recv(a, 5, MPI_INTEGER, 0, 100, MPI_COMM_WORLD, status, ierror)
    call MPI_Send(b, 5, MPI_INTEGER, 0, 101, MPI_COMM_WORLD, ierror)
    do i=1, 5
      write(*,*) 'a(', i, ')=', a(i)
    end do
  endif

  call MPI_Finalize(ierror)
end program deadlock_nb
