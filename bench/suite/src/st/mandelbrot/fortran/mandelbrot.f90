! mandelbrot (Benchmarks Game algorithm), single-threaded, plain Fortran.
! Binary PBM goes to stdout through libc write(2) (iso_c_binding).
program mandelbrot
  use iso_c_binding
  implicit none
  interface
    function c_write(fd, buf, cnt) bind(C, name='write') result(r)
      import :: c_int, c_size_t, c_intptr_t, c_char
      integer(c_int), value :: fd
      character(kind=c_char), intent(in) :: buf(*)
      integer(c_size_t), value :: cnt
      integer(c_intptr_t) :: r
    end function
  end interface
  integer, parameter :: dp = kind(1.0d0)
  integer, parameter :: iter = 50
  real(dp), parameter :: limit2 = 4.0d0
  integer :: w, h, x, y, i, bitnum, bytes_per_row, pos, byteacc
  real(dp) :: zr, zi, tr, ti, cr, ci
  character(len=32) :: arg
  character(len=64) :: header
  character(kind=c_char), allocatable :: pix(:)
  integer(c_intptr_t) :: rc

  w = 200
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    read (arg, *) w
  end if
  h = w
  bytes_per_row = (w + 7) / 8
  allocate(pix(bytes_per_row * h))
  pos = 0
  do y = 0, h - 1
    ci = 2.0d0 * real(y, dp) / real(h, dp) - 1.0d0
    byteacc = 0
    bitnum = 0
    do x = 0, w - 1
      cr = 2.0d0 * real(x, dp) / real(w, dp) - 1.5d0
      zr = 0.0d0; zi = 0.0d0; tr = 0.0d0; ti = 0.0d0
      i = 0
      do while (i < iter .and. tr + ti <= limit2)
        zi = 2.0d0 * zr * zi + ci
        zr = tr - ti + cr
        tr = zr * zr
        ti = zi * zi
        i = i + 1
      end do
      byteacc = ishft(byteacc, 1)
      if (tr + ti <= limit2) byteacc = ior(byteacc, 1)
      bitnum = bitnum + 1
      if (bitnum == 8) then
        pos = pos + 1
        pix(pos) = achar(byteacc)
        byteacc = 0
        bitnum = 0
      end if
    end do
    if (bitnum /= 0) then
      byteacc = ishft(byteacc, 8 - bitnum)
      pos = pos + 1
      pix(pos) = achar(byteacc)
    end if
  end do

  write (header, '(a,i0,a,i0)') 'P4'//achar(10), w, ' ', h
  header = trim(header)//achar(10)
  rc = c_write(1_c_int, header, int(len_trim(header), c_size_t))
  rc = c_write(1_c_int, pix, int(pos, c_size_t))
end program mandelbrot
