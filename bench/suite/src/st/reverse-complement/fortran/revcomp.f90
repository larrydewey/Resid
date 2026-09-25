! reverse-complement (Benchmarks Game algorithm), single-threaded, plain Fortran.
! Stdin is read whole with libc read(2); output goes through libc write(2).
program revcomp
  use iso_c_binding
  implicit none
  interface
    function c_read(fd, buf, cnt) bind(C, name='read') result(r)
      import :: c_int, c_size_t, c_intptr_t, c_char
      integer(c_int), value :: fd
      character(kind=c_char) :: buf(*)
      integer(c_size_t), value :: cnt
      integer(c_intptr_t) :: r
    end function
    function c_write(fd, buf, cnt) bind(C, name='write') result(r)
      import :: c_int, c_size_t, c_intptr_t, c_char
      integer(c_int), value :: fd
      character(kind=c_char), intent(in) :: buf(*)
      integer(c_size_t), value :: cnt
      integer(c_intptr_t) :: r
    end function
  end interface
  integer, parameter :: width = 60
  character(kind=c_char), allocatable :: raw(:), tmp(:), obuf(:)
  character :: comp(0:255)
  integer(c_intptr_t) :: got
  integer :: rlen, cap, i, p, hs, he, ss, se, m, j, olen, col
  character(len=*), parameter :: from = 'ACGTUMRWSYKVHDBNacgtumrwsykvhdbn'
  character(len=*), parameter :: to   = 'TGCAAKYWSRMBDHVNTGCAAKYWSRMBDHVN'

  do i = 0, 255
    comp(i) = achar(i)
  end do
  do i = 1, len(from)
    comp(iachar(from(i:i))) = to(i:i)
  end do

  cap = 1 * 1024 * 1024
  allocate(raw(cap))
  rlen = 0
  do
    if (rlen == cap) then
      allocate(tmp(2 * cap))
      tmp(1:rlen) = raw(1:rlen)
      call move_alloc(tmp, raw)
      cap = 2 * cap
    end if
    got = c_read(0_c_int, raw(rlen + 1:), int(cap - rlen, c_size_t))
    if (got <= 0) exit
    rlen = rlen + int(got)
  end do

  allocate(obuf(rlen + rlen / width + 16))
  olen = 0
  p = 1
  do while (p <= rlen)
    ! header line [hs, he] including its newline
    hs = p
    do while (p <= rlen .and. raw(p) /= achar(10))
      p = p + 1
    end do
    he = min(p, rlen)
    p = p + 1
    ! sequence: compact bytes up to the next '>' into raw(ss:se)
    ss = p
    m = ss - 1
    do while (p <= rlen)
      if (raw(p) == '>') exit
      if (raw(p) /= achar(10)) then
        m = m + 1
        raw(m) = raw(p)
      end if
      p = p + 1
    end do
    se = m
    ! emit header
    do i = hs, he
      olen = olen + 1
      obuf(olen) = raw(i)
    end do
    if (raw(he) /= achar(10)) then
      olen = olen + 1
      obuf(olen) = achar(10)
    end if
    ! emit reverse complement, wrapped
    col = 0
    do j = se, ss, -1
      olen = olen + 1
      obuf(olen) = comp(iachar(raw(j)))
      col = col + 1
      if (col == width) then
        olen = olen + 1
        obuf(olen) = achar(10)
        col = 0
      end if
    end do
    if (col /= 0) then
      olen = olen + 1
      obuf(olen) = achar(10)
    end if
  end do
  call write_all(obuf, olen)

contains

  subroutine write_all(b, n)
    character(kind=c_char), intent(in), target :: b(:)
    integer, intent(in) :: n
    integer :: off
    integer(c_intptr_t) :: r
    off = 0
    do while (off < n)
      r = c_write(1_c_int, b(off + 1:), int(n - off, c_size_t))
      if (r <= 0) exit
      off = off + int(r)
    end do
  end subroutine

end program revcomp
