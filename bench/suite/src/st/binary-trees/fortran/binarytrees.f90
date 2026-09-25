! binary-trees (Benchmarks Game algorithm), single-threaded, plain Fortran.
! Every node is individually allocated and deallocated (no pool).
module trees
  implicit none
  type node
    type(node), pointer :: left => null()
    type(node), pointer :: right => null()
  end type
contains
  recursive function make(depth) result(t)
    integer, intent(in) :: depth
    type(node), pointer :: t
    allocate(t)
    if (depth > 0) then
      t%left => make(depth - 1)
      t%right => make(depth - 1)
    end if
  end function

  recursive integer function check(t) result(c)
    type(node), pointer :: t
    if (associated(t%left)) then
      c = 1 + check(t%left) + check(t%right)
    else
      c = 1
    end if
  end function

  recursive subroutine free(t)
    type(node), pointer :: t
    if (associated(t%left)) then
      call free(t%left)
      call free(t%right)
    end if
    deallocate(t)
  end subroutine
end module trees

program binarytrees
  use trees
  implicit none
  integer, parameter :: min_depth = 4
  character, parameter :: tab = achar(9)
  integer :: n, max_depth, stretch_depth, depth, iterations, i, c
  type(node), pointer :: t, long_lived
  character(len=32) :: arg

  n = 10
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    read (arg, *) n
  end if
  max_depth = max(min_depth + 2, n)
  stretch_depth = max_depth + 1

  t => make(stretch_depth)
  write (*, '(2(a,i0))') 'stretch tree of depth ', stretch_depth, tab//' check: ', check(t)
  call free(t)

  long_lived => make(max_depth)

  do depth = min_depth, max_depth, 2
    iterations = ishft(1, max_depth - depth + min_depth)
    c = 0
    do i = 1, iterations
      t => make(depth)
      c = c + check(t)
      call free(t)
    end do
    write (*, '(2(i0,a),i0)') iterations, tab//' trees of depth ', depth, tab//' check: ', c
  end do

  write (*, '(2(a,i0))') 'long lived tree of depth ', max_depth, tab//' check: ', check(long_lived)
  call free(long_lived)
end program binarytrees
