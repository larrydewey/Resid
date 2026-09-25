! k-nucleotide, tuned Fortran (not a Benchmarks Game program: the only
! Fortran k-nucleotide entry there is an empty placeholder).  Same algorithm
! as the st cell; differences: tables are pre-sized from min(4**k, len), and
! the five counting frames run concurrently with OpenMP (largest first).
! Fortran has no standard or customary hash table library, so this program
! carries a small open-addressing hash table (linear probing, 2-bit packed
! nucleotide keys in a 64-bit integer).  Stdin is read with libc read(2).
module hashtab
  use iso_fortran_env, only: int64
  implicit none
  ! key and count live side by side so that a probe touches one cache line
  type entry
    integer(int64) :: key = -1_int64
    integer(int64) :: val = 0
  end type
  type table
    type(entry), allocatable :: e(:)
    integer :: mask = 0
    integer :: used = 0
  end type
contains
  subroutine tinit(t, cap)
    type(table), intent(inout) :: t
    integer, intent(in) :: cap
    allocate(t%e(0:cap - 1))
    t%mask = cap - 1
    t%used = 0
  end subroutine

  pure integer function slot(key, mask)
    integer(int64), intent(in) :: key
    integer, intent(in) :: mask
    integer(int64) :: h
    h = key * (-7046029254386353131_int64)
    h = ieor(h, ishft(h, -29))
    slot = int(iand(h, int(mask, int64)))
  end function

  subroutine grow(t)
    type(table), intent(inout) :: t
    type(entry), allocatable :: old(:)
    integer :: i, s
    call move_alloc(t%e, old)
    call tinit(t, 2 * size(old))
    do i = 0, size(old) - 1
      if (old(i)%key >= 0) then
        s = slot(old(i)%key, t%mask)
        do while (t%e(s)%key >= 0)
          s = iand(s + 1, t%mask)
        end do
        t%e(s) = old(i)
        t%used = t%used + 1
      end if
    end do
  end subroutine

  subroutine incr(t, key)
    type(table), intent(inout) :: t
    integer(int64), intent(in) :: key
    integer :: s
    s = slot(key, t%mask)
    do
      if (t%e(s)%key == key) then
        t%e(s)%val = t%e(s)%val + 1
        return
      else if (t%e(s)%key < 0) then
        t%e(s)%key = key
        t%e(s)%val = 1
        t%used = t%used + 1
        if (2 * t%used > t%mask) call grow(t)
        return
      end if
      s = iand(s + 1, t%mask)
    end do
  end subroutine

  integer function lookup(t, key)
    type(table), intent(in) :: t
    integer(int64), intent(in) :: key
    integer :: s
    s = slot(key, t%mask)
    do
      if (t%e(s)%key == key) then
        lookup = int(t%e(s)%val)
        return
      else if (t%e(s)%key < 0) then
        lookup = 0
        return
      end if
      s = iand(s + 1, t%mask)
    end do
  end function
end module hashtab

program knucleotide
  use iso_c_binding
  use iso_fortran_env, only: int64
  use hashtab
  implicit none
  interface
    function c_read(fd, buf, cnt) bind(C, name='read') result(r)
      import :: c_int, c_size_t, c_intptr_t, c_char
      integer(c_int), value :: fd
      character(kind=c_char) :: buf(*)
      integer(c_size_t), value :: cnt
      integer(c_intptr_t) :: r
    end function
  end interface
  character(kind=c_char), allocatable :: raw(:), tmp(:)
  integer, parameter :: int1 = selected_int_kind(2)
  integer(int1), allocatable :: seq(:)
  integer(c_intptr_t) :: got
  integer :: rlen, cap, i, p, slen, q
  character(len=18), parameter :: queries(5) = [character(len=18) :: &
    'GGT', 'GGTA', 'GGTATT', 'GGTATTTTAATT', 'GGTATTTTAATTTATAGT']
  integer :: cnts(5)

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

  ! find the line that starts with ">THREE"
  p = 1
  do
    if (p + 5 > rlen) stop 'no >THREE section'
    if (raw(p) == '>' .and. raw(p+1) == 'T' .and. raw(p+2) == 'H' .and. &
        raw(p+3) == 'R' .and. raw(p+4) == 'E' .and. raw(p+5) == 'E') exit
    do while (p <= rlen .and. raw(p) /= achar(10))
      p = p + 1
    end do
    p = p + 1
  end do
  do while (p <= rlen .and. raw(p) /= achar(10))
    p = p + 1
  end do
  p = p + 1

  allocate(seq(rlen - p + 1))
  slen = 0
  do i = p, rlen
    if (raw(i) == '>') exit
    select case (raw(i))
    case ('a', 'A'); slen = slen + 1; seq(slen) = 0
    case ('c', 'C'); slen = slen + 1; seq(slen) = 1
    case ('g', 'G'); slen = slen + 1; seq(slen) = 2
    case ('t', 'T'); slen = slen + 1; seq(slen) = 3
    end select
  end do
  deallocate(raw)

  call write_frequencies(1)
  call write_frequencies(2)
  !$omp parallel do schedule(dynamic, 1)
  do q = 5, 1, -1
    cnts(q) = count_of(trim(queries(q)))
  end do
  !$omp end parallel do
  do q = 1, 5
    write (*, '(i0,a)') cnts(q), achar(9)//trim(queries(q))
  end do

contains

  subroutine count_frame(t, k)
    type(table), intent(inout) :: t
    integer, intent(in) :: k
    integer(int64) :: key, kmask
    integer :: i, cap
    integer(int64) :: want
    want = min(ishft(1_int64, 2 * min(k, 30)), int(slen, int64))
    cap = 64
    do while (int(cap, int64) < 2 * want + 2)
      cap = 2 * cap
    end do
    call tinit(t, cap)
    kmask = ishft(1_int64, 2 * k) - 1
    key = 0
    do i = 1, k - 1
      key = ior(ishft(key, 2), int(seq(i), int64))
    end do
    do i = k, slen
      key = iand(ior(ishft(key, 2), int(seq(i), int64)), kmask)
      call incr(t, key)
    end do
  end subroutine

  function decode(key, k) result(s)
    integer(int64), intent(in) :: key
    integer, intent(in) :: k
    character(len=k) :: s
    character(len=4), parameter :: acgt = 'ACGT'
    integer :: i, c
    do i = k, 1, -1
      c = int(iand(ishft(key, -2 * (k - i)), 3_int64))
      s(i:i) = acgt(c + 1:c + 1)
    end do
  end function

  integer(int64) function encode(s)
    character(len=*), intent(in) :: s
    integer :: i
    encode = 0
    do i = 1, len(s)
      encode = ishft(encode, 2)
      select case (s(i:i))
      case ('C'); encode = ior(encode, 1_int64)
      case ('G'); encode = ior(encode, 2_int64)
      case ('T'); encode = ior(encode, 3_int64)
      end select
    end do
  end function

  subroutine write_frequencies(k)
    integer, intent(in) :: k
    type(table) :: t
    integer(int64), allocatable :: ks(:)
    integer, allocatable :: vs(:)
    integer :: i, j, m, total, tv
    integer(int64) :: tk
    character(len=32) :: buf
    call count_frame(t, k)
    allocate(ks(t%used), vs(t%used))
    m = 0
    do i = 0, t%mask
      if (t%e(i)%key >= 0) then
        m = m + 1
        ks(m) = t%e(i)%key
        vs(m) = int(t%e(i)%val)
      end if
    end do
    ! insertion sort: count descending, then key (alphabetical) ascending
    do i = 2, m
      tk = ks(i); tv = vs(i)
      j = i - 1
      do while (j >= 1)
        if (vs(j) > tv .or. (vs(j) == tv .and. ks(j) < tk)) exit
        ks(j + 1) = ks(j); vs(j + 1) = vs(j)
        j = j - 1
      end do
      ks(j + 1) = tk; vs(j + 1) = tv
    end do
    total = slen - k + 1
    do i = 1, m
      write (buf, '(f32.3)') 100.0d0 * real(vs(i), kind(1.0d0)) / real(total, kind(1.0d0))
      write (*, '(a)') decode(ks(i), k)//' '//trim(adjustl(buf))
    end do
    write (*, '(a)') ''
  end subroutine

  integer function count_of(s)
    character(len=*), intent(in) :: s
    type(table) :: t
    call count_frame(t, len(s))
    count_of = lookup(t, encode(s))
  end function

end program knucleotide
