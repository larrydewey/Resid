! fannkuch-redux (Benchmarks Game algorithm), single-threaded, plain Fortran.
program fannkuchredux
  implicit none
  integer :: n, i, j, k, t, flips, maxflips, checksum, permcount, r
  integer, allocatable :: perm(:), perm1(:), cnt(:)
  character(len=32) :: arg

  n = 7
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    read (arg, *) n
  end if

  allocate(perm(0:n-1), perm1(0:n-1), cnt(0:n-1))
  do i = 0, n - 1
    perm1(i) = i
  end do
  maxflips = 0
  checksum = 0
  permcount = 0
  r = n

  outer: do
    do while (r /= 1)
      cnt(r - 1) = r
      r = r - 1
    end do

    perm = perm1
    flips = 0
    k = perm(0)
    do while (k /= 0)
      i = 0
      j = k
      do while (i < j)
        t = perm(i); perm(i) = perm(j); perm(j) = t
        i = i + 1
        j = j - 1
      end do
      flips = flips + 1
      k = perm(0)
    end do
    if (flips > maxflips) maxflips = flips
    if (iand(permcount, 1) == 0) then
      checksum = checksum + flips
    else
      checksum = checksum - flips
    end if

    ! next permutation
    do
      if (r == n) exit outer
      t = perm1(0)
      do i = 0, r - 1
        perm1(i) = perm1(i + 1)
      end do
      perm1(r) = t
      cnt(r) = cnt(r) - 1
      if (cnt(r) > 0) exit
      r = r + 1
    end do
    permcount = permcount + 1
  end do outer

  write (*, '(i0)') checksum
  write (*, '(a,i0,a,i0)') 'Pfannkuchen(', n, ') = ', maxflips
end program fannkuchredux
