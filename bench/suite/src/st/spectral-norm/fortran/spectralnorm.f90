! spectral-norm (Benchmarks Game algorithm), single-threaded, plain Fortran.
program spectralnorm
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  integer :: n, i
  real(dp), allocatable :: u(:), v(:), tmp(:)
  real(dp) :: vbv, vv
  character(len=32) :: arg
  character(len=40) :: buf

  n = 100
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    read (arg, *) n
  end if
  allocate(u(0:n-1), v(0:n-1), tmp(0:n-1))
  u = 1.0d0
  do i = 1, 10
    call mul_atav(u, v)
    call mul_atav(v, u)
  end do
  vbv = 0.0d0
  vv = 0.0d0
  do i = 0, n - 1
    vbv = vbv + u(i) * v(i)
    vv = vv + v(i) * v(i)
  end do
  write (buf, '(f40.9)') sqrt(vbv / vv)
  write (*, '(a)') trim(adjustl(buf))

contains

  pure real(dp) function a(i, j)
    integer, intent(in) :: i, j
    a = 1.0d0 / real((i + j) * (i + j + 1) / 2 + i + 1, dp)
  end function

  subroutine mul_av(x, y)
    real(dp), intent(in) :: x(0:)
    real(dp), intent(out) :: y(0:)
    integer :: i, j
    real(dp) :: s
    do i = 0, n - 1
      s = 0.0d0
      do j = 0, n - 1
        s = s + a(i, j) * x(j)
      end do
      y(i) = s
    end do
  end subroutine

  subroutine mul_atv(x, y)
    real(dp), intent(in) :: x(0:)
    real(dp), intent(out) :: y(0:)
    integer :: i, j
    real(dp) :: s
    do i = 0, n - 1
      s = 0.0d0
      do j = 0, n - 1
        s = s + a(j, i) * x(j)
      end do
      y(i) = s
    end do
  end subroutine

  subroutine mul_atav(x, y)
    real(dp), intent(in) :: x(0:)
    real(dp), intent(out) :: y(0:)
    call mul_av(x, tmp)
    call mul_atv(tmp, y)
  end subroutine

end program spectralnorm
