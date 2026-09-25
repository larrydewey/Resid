! fasta (Benchmarks Game algorithm), single-threaded, plain Fortran.
! Output is collected in a byte buffer and flushed with libc write(2).
module outbuf
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
  integer, parameter :: bufsize = 65536
  character(kind=c_char) :: buf(bufsize)
  integer :: blen = 0
contains
  subroutine flush_out()
    integer(c_intptr_t) :: r
    if (blen > 0) r = c_write(1_c_int, buf, int(blen, c_size_t))
    blen = 0
  end subroutine

  subroutine put(c)
    character, intent(in) :: c
    if (blen == bufsize) call flush_out()
    blen = blen + 1
    buf(blen) = c
  end subroutine

  subroutine puts(s)
    character(len=*), intent(in) :: s
    integer :: i
    do i = 1, len(s)
      call put(s(i:i))
    end do
  end subroutine
end module outbuf

program fasta
  use outbuf
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  integer, parameter :: im = 139968, ia = 3877, ic = 29573, width = 60
  character(len=*), parameter :: alu = &
    'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG' // &
    'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA' // &
    'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT' // &
    'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA' // &
    'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG' // &
    'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC' // &
    'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA'
  character(len=15), parameter :: iub_c = 'acgtBDHKMNRSVWY'
  real(dp), parameter :: iub_p(15) = [0.27d0, 0.12d0, 0.12d0, 0.27d0, &
    0.02d0, 0.02d0, 0.02d0, 0.02d0, 0.02d0, 0.02d0, 0.02d0, 0.02d0, 0.02d0, 0.02d0, 0.02d0]
  character(len=4), parameter :: hs_c = 'acgt'
  real(dp), parameter :: hs_p(4) = [0.3029549426680d0, 0.1979883004921d0, &
    0.1975473066391d0, 0.3015094502008d0]
  integer :: n, last
  character(len=32) :: arg

  n = 1000
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    read (arg, *) n
  end if
  last = 42

  call puts('>ONE Homo sapiens alu'//achar(10))
  call repeat_fasta(2 * n)
  call puts('>TWO IUB ambiguity codes'//achar(10))
  call random_fasta(iub_c, iub_p, 3 * n)
  call puts('>THREE Homo sapiens frequency'//achar(10))
  call random_fasta(hs_c, hs_p, 5 * n)
  call flush_out()

contains

  subroutine repeat_fasta(cnt)
    integer, intent(in) :: cnt
    integer :: i, k, col
    k = 1
    col = 0
    do i = 1, cnt
      call put(alu(k:k))
      k = k + 1
      if (k > len(alu)) k = 1
      col = col + 1
      if (col == width) then
        call put(achar(10))
        col = 0
      end if
    end do
    if (col /= 0) call put(achar(10))
  end subroutine

  subroutine random_fasta(chars, probs, cnt)
    character(len=*), intent(in) :: chars
    real(dp), intent(in) :: probs(:)
    integer, intent(in) :: cnt
    real(dp) :: cum(size(probs)), acc, r
    integer :: i, j, col, m
    m = size(probs)
    acc = 0.0d0
    do j = 1, m
      acc = acc + probs(j)
      cum(j) = acc
    end do
    col = 0
    do i = 1, cnt
      last = mod(last * ia + ic, im)
      r = 1.0d0 * real(last, dp) / real(im, dp)
      do j = 1, m - 1
        if (r < cum(j)) exit
      end do
      call put(chars(j:j))
      col = col + 1
      if (col == width) then
        call put(achar(10))
        col = 0
      end if
    end do
    if (col /= 0) call put(achar(10))
  end subroutine

end program fasta
