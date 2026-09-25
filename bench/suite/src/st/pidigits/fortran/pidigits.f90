! pidigits (Benchmarks Game algorithm), single-threaded Fortran.
! Arbitrary precision arithmetic is GMP's mpz API, bound with iso_c_binding.
module gmp
  use iso_c_binding
  implicit none
  type, bind(C) :: mpz_t
    integer(c_int) :: alloc, size
    type(c_ptr) :: d
  end type
  interface
    subroutine mpz_init_set_ui(x, v) bind(C, name='__gmpz_init_set_ui')
      import :: mpz_t, c_long
      type(mpz_t), intent(inout) :: x
      integer(c_long), value :: v
    end subroutine
    subroutine mpz_init(x) bind(C, name='__gmpz_init')
      import :: mpz_t
      type(mpz_t), intent(inout) :: x
    end subroutine
    subroutine mpz_mul_ui(r, a, v) bind(C, name='__gmpz_mul_ui')
      import :: mpz_t, c_long
      type(mpz_t), intent(inout) :: r
      type(mpz_t), intent(in) :: a
      integer(c_long), value :: v
    end subroutine
    subroutine mpz_addmul_ui(r, a, v) bind(C, name='__gmpz_addmul_ui')
      import :: mpz_t, c_long
      type(mpz_t), intent(inout) :: r
      type(mpz_t), intent(in) :: a
      integer(c_long), value :: v
    end subroutine
    subroutine mpz_submul_ui(r, a, v) bind(C, name='__gmpz_submul_ui')
      import :: mpz_t, c_long
      type(mpz_t), intent(inout) :: r
      type(mpz_t), intent(in) :: a
      integer(c_long), value :: v
    end subroutine
    subroutine mpz_add(r, a, b) bind(C, name='__gmpz_add')
      import :: mpz_t
      type(mpz_t), intent(inout) :: r
      type(mpz_t), intent(in) :: a, b
    end subroutine
    subroutine mpz_tdiv_q(r, a, b) bind(C, name='__gmpz_tdiv_q')
      import :: mpz_t
      type(mpz_t), intent(inout) :: r
      type(mpz_t), intent(in) :: a, b
    end subroutine
    integer(c_long) function mpz_get_ui(a) bind(C, name='__gmpz_get_ui')
      import :: mpz_t, c_long
      type(mpz_t), intent(in) :: a
    end function
    integer(c_int) function mpz_cmp(a, b) bind(C, name='__gmpz_cmp')
      import :: mpz_t, c_int
      type(mpz_t), intent(in) :: a, b
    end function
  end interface
end module gmp

program pidigits
  use gmp
  implicit none
  type(mpz_t) :: acc, den, num, tmp1, tmp2
  integer :: n, i, k, d, col
  character(len=32) :: arg
  character(len=10) :: line

  n = 30
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    read (arg, *) n
  end if

  call mpz_init_set_ui(acc, 0_c_long)
  call mpz_init_set_ui(den, 1_c_long)
  call mpz_init_set_ui(num, 1_c_long)
  call mpz_init(tmp1)
  call mpz_init(tmp2)

  i = 0
  k = 0
  col = 0
  do while (i < n)
    k = k + 1
    call next_term(k)
    if (mpz_cmp(num, acc) > 0) cycle
    d = extract_digit(3)
    if (d /= extract_digit(4)) cycle
    col = col + 1
    line(col:col) = achar(iachar('0') + d)
    i = i + 1
    if (col == 10) then
      write (*, '(a,a,i0)') line, achar(9)//':', i
      col = 0
    end if
    call eliminate_digit(d)
  end do
  if (col /= 0) then
    line(col + 1:) = ' '
    write (*, '(a,a,i0)') line, achar(9)//':', i
  end if

contains

  subroutine next_term(k)
    integer, intent(in) :: k
    integer(c_long) :: k2
    k2 = 2 * k + 1
    call mpz_addmul_ui(acc, num, 2_c_long)
    call mpz_mul_ui(acc, acc, k2)
    call mpz_mul_ui(den, den, k2)
    call mpz_mul_ui(num, num, int(k, c_long))
  end subroutine

  integer function extract_digit(nth)
    integer, intent(in) :: nth
    call mpz_mul_ui(tmp1, num, int(nth, c_long))
    call mpz_add(tmp2, tmp1, acc)
    call mpz_tdiv_q(tmp1, tmp2, den)
    extract_digit = int(mpz_get_ui(tmp1))
  end function

  subroutine eliminate_digit(d)
    integer, intent(in) :: d
    call mpz_submul_ui(acc, den, int(d, c_long))
    call mpz_mul_ui(acc, acc, 10_c_long)
    call mpz_mul_ui(num, num, 10_c_long)
  end subroutine

end program pidigits
