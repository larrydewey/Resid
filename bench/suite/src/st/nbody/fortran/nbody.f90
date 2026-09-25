! n-body (Benchmarks Game algorithm), single-threaded, plain Fortran.
program nbody
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  integer, parameter :: nb = 5
  real(dp), parameter :: pi = 3.141592653589793d0
  real(dp), parameter :: solar_mass = 4.0d0 * pi * pi
  real(dp), parameter :: days_per_year = 365.24d0
  real(dp) :: x(3, nb), v(3, nb), mass(nb)
  character(len=32) :: arg
  integer :: n, i

  x(:, 1) = [0.0d0, 0.0d0, 0.0d0]
  v(:, 1) = [0.0d0, 0.0d0, 0.0d0]
  mass(1) = solar_mass
  ! jupiter
  x(:, 2) = [4.84143144246472090d+00, -1.16032004402742839d+00, -1.03622044471123109d-01]
  v(:, 2) = [1.66007664274403694d-03, 7.69901118419740425d-03, -6.90460016972063023d-05] * days_per_year
  mass(2) = 9.54791938424326609d-04 * solar_mass
  ! saturn
  x(:, 3) = [8.34336671824457987d+00, 4.12479856412430479d+00, -4.03523417114321381d-01]
  v(:, 3) = [-2.76742510726862411d-03, 4.99852801234917238d-03, 2.30417297573763929d-05] * days_per_year
  mass(3) = 2.85885980666130812d-04 * solar_mass
  ! uranus
  x(:, 4) = [1.28943695621391310d+01, -1.51111514016986312d+01, -2.23307578892655734d-01]
  v(:, 4) = [2.96460137564761618d-03, 2.37847173959480950d-03, -2.96589568540237556d-05] * days_per_year
  mass(4) = 4.36624404335156298d-05 * solar_mass
  ! neptune
  x(:, 5) = [1.53796971148509165d+01, -2.59193146099879641d+01, 1.79258772950371181d-01]
  v(:, 5) = [2.68067772490389322d-03, 1.62824170038242295d-03, -9.51592254519715870d-05] * days_per_year
  mass(5) = 5.15138902046611451d-05 * solar_mass

  n = 1000
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    read (arg, *) n
  end if

  call offset_momentum()
  call show(energy())
  do i = 1, n
    call advance(0.01d0)
  end do
  call show(energy())

contains

  subroutine show(e)
    real(dp), intent(in) :: e
    character(len=40) :: buf
    write (buf, '(f40.9)') e
    write (*, '(a)') trim(adjustl(buf))
  end subroutine

  subroutine offset_momentum()
    real(dp) :: p(3)
    integer :: k
    p = 0.0d0
    do k = 1, nb
      p = p + v(:, k) * mass(k)
    end do
    v(:, 1) = -p / solar_mass
  end subroutine

  real(dp) function energy()
    integer :: k, j
    real(dp) :: d(3)
    energy = 0.0d0
    do k = 1, nb
      energy = energy + 0.5d0 * mass(k) * (v(1,k)**2 + v(2,k)**2 + v(3,k)**2)
      do j = k + 1, nb
        d = x(:, k) - x(:, j)
        energy = energy - mass(k) * mass(j) / sqrt(d(1)**2 + d(2)**2 + d(3)**2)
      end do
    end do
  end function

  subroutine advance(dt)
    real(dp), intent(in) :: dt
    integer :: k, j
    real(dp) :: dx, dy, dz, d2, mag
    do k = 1, nb
      do j = k + 1, nb
        dx = x(1, k) - x(1, j)
        dy = x(2, k) - x(2, j)
        dz = x(3, k) - x(3, j)
        d2 = dx*dx + dy*dy + dz*dz
        mag = dt / (d2 * sqrt(d2))
        v(1, k) = v(1, k) - dx * mass(j) * mag
        v(2, k) = v(2, k) - dy * mass(j) * mag
        v(3, k) = v(3, k) - dz * mass(j) * mag
        v(1, j) = v(1, j) + dx * mass(k) * mag
        v(2, j) = v(2, j) + dy * mass(k) * mag
        v(3, j) = v(3, j) + dz * mass(k) * mag
      end do
    end do
    do k = 1, nb
      x(:, k) = x(:, k) + dt * v(:, k)
    end do
  end subroutine

end program nbody
