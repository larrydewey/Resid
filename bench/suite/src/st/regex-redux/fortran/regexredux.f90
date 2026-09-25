! regex-redux (Benchmarks Game algorithm), single-threaded Fortran.
! Fortran has no regex library of its own; this binds the PCRE2 8-bit C API
! (the library the C programs use) with iso_c_binding.  Patterns are
! JIT-compiled (pcre2_jit_compile), as in the C PCRE2 programs.
module pcre2
  use iso_c_binding
  implicit none
  integer(c_int32_t), parameter :: PCRE2_JIT_COMPLETE = int(z'00000001', c_int32_t)
  integer(c_int32_t), parameter :: PCRE2_SUBSTITUTE_GLOBAL = int(z'00000100', c_int32_t)
  interface
    type(c_ptr) function pcre2_compile(pat, plen, opts, errcode, erroff, ctx) &
        bind(C, name='pcre2_compile_8')
      import :: c_ptr, c_char, c_size_t, c_int32_t, c_int
      character(kind=c_char), intent(in) :: pat(*)
      integer(c_size_t), value :: plen
      integer(c_int32_t), value :: opts
      integer(c_int), intent(out) :: errcode
      integer(c_size_t), intent(out) :: erroff
      type(c_ptr), value :: ctx
    end function
    integer(c_int) function pcre2_jit_compile(code, opts) bind(C, name='pcre2_jit_compile_8')
      import :: c_ptr, c_int, c_int32_t
      type(c_ptr), value :: code
      integer(c_int32_t), value :: opts
    end function
    type(c_ptr) function pcre2_match_data_create_from_pattern(code, ctx) &
        bind(C, name='pcre2_match_data_create_from_pattern_8')
      import :: c_ptr
      type(c_ptr), value :: code, ctx
    end function
    integer(c_int) function pcre2_match(code, subj, slen, start, opts, md, ctx) &
        bind(C, name='pcre2_match_8')
      import :: c_ptr, c_char, c_size_t, c_int32_t, c_int
      type(c_ptr), value :: code
      character(kind=c_char), intent(in) :: subj(*)
      integer(c_size_t), value :: slen, start
      integer(c_int32_t), value :: opts
      type(c_ptr), value :: md, ctx
    end function
    type(c_ptr) function pcre2_get_ovector_pointer(md) bind(C, name='pcre2_get_ovector_pointer_8')
      import :: c_ptr
      type(c_ptr), value :: md
    end function
    integer(c_int) function pcre2_substitute(code, subj, slen, start, opts, md, ctx, &
        rep, rlen, obuf, olen) bind(C, name='pcre2_substitute_8')
      import :: c_ptr, c_char, c_size_t, c_int32_t, c_int
      type(c_ptr), value :: code
      character(kind=c_char), intent(in) :: subj(*)
      integer(c_size_t), value :: slen, start
      integer(c_int32_t), value :: opts
      type(c_ptr), value :: md, ctx
      character(kind=c_char), intent(in) :: rep(*)
      integer(c_size_t), value :: rlen
      character(kind=c_char) :: obuf(*)
      integer(c_size_t), intent(inout) :: olen
    end function
    subroutine pcre2_code_free(code) bind(C, name='pcre2_code_free_8')
      import :: c_ptr
      type(c_ptr), value :: code
    end subroutine
    subroutine pcre2_match_data_free(md) bind(C, name='pcre2_match_data_free_8')
      import :: c_ptr
      type(c_ptr), value :: md
    end subroutine
  end interface
contains
  type(c_ptr) function compile(pat)
    character(len=*), intent(in) :: pat
    integer(c_int) :: ec, rc
    integer(c_size_t) :: eo
    compile = pcre2_compile(pat, int(len(pat), c_size_t), 0_c_int32_t, ec, eo, c_null_ptr)
    if (.not. c_associated(compile)) error stop 'pcre2_compile failed'
    rc = pcre2_jit_compile(compile, PCRE2_JIT_COMPLETE)
  end function

  ! Replace every match of pat in s(1:n) by rep; result in s, new length in n.
  subroutine replace_all(pat, rep, s, n)
    character(len=*), intent(in) :: pat, rep
    character(kind=c_char), allocatable, intent(inout) :: s(:)
    integer, intent(inout) :: n
    character(kind=c_char), allocatable :: o(:)
    type(c_ptr) :: code
    integer(c_size_t) :: olen
    integer(c_int) :: rc
    code = compile(pat)
    allocate(o(2 * n + 64))
    olen = size(o, kind=c_size_t)
    rc = pcre2_substitute(code, s, int(n, c_size_t), 0_c_size_t, PCRE2_SUBSTITUTE_GLOBAL, &
      c_null_ptr, c_null_ptr, rep, int(len(rep), c_size_t), o, olen)
    if (rc < 0) error stop 'pcre2_substitute failed'
    n = int(olen)
    call move_alloc(o, s)
    call pcre2_code_free(code)
  end subroutine

  integer function count_matches(pat, s, n)
    character(len=*), intent(in) :: pat
    character(kind=c_char), intent(in) :: s(:)
    integer, intent(in) :: n
    type(c_ptr) :: code, md
    integer(c_size_t), pointer :: ov(:)
    integer(c_size_t) :: pos
    code = compile(pat)
    md = pcre2_match_data_create_from_pattern(code, c_null_ptr)
    call c_f_pointer(pcre2_get_ovector_pointer(md), ov, [2])
    count_matches = 0
    pos = 0
    do while (pcre2_match(code, s, int(n, c_size_t), pos, 0_c_int32_t, md, c_null_ptr) >= 0)
      count_matches = count_matches + 1
      pos = ov(2)
    end do
    call pcre2_match_data_free(md)
    call pcre2_code_free(code)
  end function
end module pcre2

program regexredux
  use iso_c_binding
  use pcre2
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
  character(len=27), parameter :: variants(9) = [character(len=27) :: &
    'agggtaaa|tttaccct', &
    '[cgt]gggtaaa|tttaccc[acg]', &
    'a[act]ggtaaa|tttacc[agt]t', &
    'ag[act]gtaaa|tttac[agt]ct', &
    'agg[act]taaa|ttta[agt]cct', &
    'aggg[acg]aaa|ttt[cgt]ccct', &
    'agggt[cgt]aa|tt[acg]accct', &
    'agggta[cgt]a|t[acg]taccct', &
    'agggtaa[cgt]|[acg]ttaccct']
  character(len=24), parameter :: pats(5) = [character(len=24) :: &
    'tHa[Nt]', 'aND|caN|Ha[DS]|WaS', 'a[NSt]|BY', '<[^>]*>', '\|[^|][^|]*\|']
  character(len=3), parameter :: reps(5) = [character(len=3) :: '<4>', '<3>', '<2>', '|', '-']
  character(kind=c_char), allocatable :: s(:), tmp(:)
  integer(c_intptr_t) :: got
  integer :: rlen, cap, ilen, clen, i

  cap = 1 * 1024 * 1024
  allocate(s(cap))
  rlen = 0
  do
    if (rlen == cap) then
      allocate(tmp(2 * cap))
      tmp(1:rlen) = s(1:rlen)
      call move_alloc(tmp, s)
      cap = 2 * cap
    end if
    got = c_read(0_c_int, s(rlen + 1:), int(cap - rlen, c_size_t))
    if (got <= 0) exit
    rlen = rlen + int(got)
  end do
  ilen = rlen

  clen = ilen
  call replace_all('>.*\n|\n', '', s, clen)

  do i = 1, 9
    write (*, '(a,1x,i0)') trim(variants(i)), count_matches(trim(variants(i)), s, clen)
  end do

  rlen = clen
  do i = 1, 5
    call replace_all(trim(pats(i)), trim(reps(i)), s, rlen)
  end do

  write (*, '(a)') ''
  write (*, '(i0)') ilen
  write (*, '(i0)') clen
  write (*, '(i0)') rlen
end program regexredux
