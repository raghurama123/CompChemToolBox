! compile  gfortran CheckConnGO.f90 -o CheckConnGO.x
program conngo

  implicit none

  integer                         :: i, tmpi
  integer                         :: Nat, Nconn, igeo, nlong1, nlong2
  integer                         :: iat, iconn
  integer, allocatable            :: conn(:,:)

  character(len=500)              :: arg, cmd
  character(len=500)              :: title1, title2, title, title3, gaussinp
  character(len=500)              :: file1, file2, file3

  character(len=2), allocatable   :: sy(:)
  character(len=200), allocatable :: tit1(:), tit2(:)

  double precision                :: RR1(1:3), RR2(1:3), R12, dR(1:3), MSD, MPAD, MaxAD, long1, long2
  double precision, allocatable   :: R1(:,:), R2(:,:), dist1(:), dist2(:), distsort1(:), distsort2(:)

  character(len=10)               :: ls1, ls2

  double precision, parameter     :: rthresh = 1.68d0 ! Threshold to detect ultralong bonds 

  call getarg(1, arg)
  file1=trim(arg)

  call getarg(2, arg)
  file2=trim(arg)

  call getarg(3, arg)
  file3=trim(arg)

  !=== Read SDF (file-1)
  open(unit=101, file=trim(file1))
  read(101,*)title1
  read(101,*)title2
  read(101,*)
  read(101,'(2i3,a)')Nat, Nconn, title3
  allocate( R1(1:Nat,1:3), R2(1:Nat,1:3), sy(1:Nat), tit1(1:Nat), tit2(1:Nconn), conn(1:Nconn,1:3) )
  allocate( dist1(1:Nconn), dist2(1:Nconn) )
  allocate( distsort1(1:Nconn), distsort2(1:Nconn) )
  !=== read xyz
  do iat = 1, Nat
    read(101,'(3f10.4,a)') R1(iat,1:3), tit1(iat)
  enddo
  !=== read connectivities
  do iconn = 1, Nconn
    read(101,'(3i3,a)') conn(iconn,1:3), tit2(iconn)
    RR1 = R1( conn(iconn,1), 1:3 )
    RR2 = R1( conn(iconn,2), 1:3 )
    dR = RR1 - RR2
    R12 = dsqrt(dot_product(dR,dR))
    !=== dist1 has distances corresponding to connectivities from file-1
    dist1(iconn) = R12
  enddo
  close(101)

  !=== Read XYZ file (file-2)
  open(unit=101, file=trim(file2))
  read(101,*) Nat
  read(101,*) title1
  do iat = 1, Nat
    read(101,*) sy(iat), R2(iat,1:3)
  enddo
  close(101)

  do iconn = 1, Nconn
    RR1 = R2( conn(iconn,1), 1:3 )
    RR2 = R2( conn(iconn,2), 1:3 )
    dR = RR1 - RR2
    R12 = dsqrt(dot_product(dR,dR))
    !=== dist2 has distances corresponding to connectivities from file-2
    dist2(iconn) = R12
  enddo

  !=== third file, make new sdf
  open(unit=101, file=trim(file3))
  write(101,'(a)')trim(title1)
  write(101,'(x,a)')trim(title2)
  write(101,*)
  write(101,'(2i3,a)')Nat, Nconn, trim(title3)
  !=== write coordinates from file-2
  do iat = 1, Nat
    write(101,'(3f10.4,x,a)') R2(iat,1:3), trim(tit1(iat))
  enddo
  !=== write connectivities from file-1
  do iconn = 1, Nconn
    write(101,'(3i3,a)') conn(iconn,1:3), trim(tit2(iconn))
  enddo
  write(101,'(a)')"M  END"
  write(101,'(a)')"$$$$"
  close(101)

  MSD = 0d0

  write(*,*)
  write(*,'(a)')"== connectivities"

  nlong1 = 0
  nlong2 = 0

  write(*,'(a)')"                     File-1                  File-2                Deviation"
  do iconn = 1, Nconn

    ls1 = '         '
    ls2 = '         '

    if ( dist1(iconn) > rthresh ) then
      ls1 = 'ultralong'
      nlong1 = nlong1 + 1
    endif
    if ( dist2(iconn) > rthresh ) then
      ls2 = 'ultralong'
      nlong2 = nlong2 + 1
    endif

    if ( conn(iconn,3) .eq. 1) then
      write(*,'(3i3,2x,3a,f10.4,2x,a,2x,f10.4,2x,a,2x,f10.4)') conn(iconn,1:3), sy(conn(iconn,1)), "- ", sy(conn(iconn,2)), &
      dist1(iconn), ls1, dist2(iconn), ls2, dist1(iconn)-dist2(iconn)
    elseif ( conn(iconn,3) .eq. 2) then
      write(*,'(3i3,2x,3a,f10.4,2x,a,2x,f10.4,2x,a,2x,f10.4)') conn(iconn,1:3), sy(conn(iconn,1)), "= ", sy(conn(iconn,2)), &
      dist1(iconn), ls1, dist2(iconn), ls2, dist1(iconn)-dist2(iconn)
    elseif ( conn(iconn,3) .eq. 3) then
      write(*,'(3i3,2x,3a,f10.4,2x,a,2x,f10.4,2x,a,2x,f10.4)') conn(iconn,1:3), sy(conn(iconn,1)), "# ", sy(conn(iconn,2)), &
      dist1(iconn), ls1, dist2(iconn), ls2, dist1(iconn)-dist2(iconn)
    endif
    MSD = MSD + (dist1(iconn)-dist2(iconn))**2
  enddo

  open(unit=101, file='scr')
  do iconn = 1, Nconn
    write(101,*) dist1(iconn)
  enddo
  close(101)

  write(cmd, '(a)') "sort -n -r scr > scr1; mv scr1 scr"
  call system(trim(cmd))

  open(unit=101, file='scr')
  do iconn = 1, Nconn
    read(101,*) distsort1(iconn)
  enddo
  close(101)

  write(*,*)
  write(*,'(a,i4)')"== bond lengths in file-1 in descending order, # ultralong bonds = ", nlong1
  do iconn = 1, Nconn
    write(*,'(f10.4)',advance='no') distsort1(iconn)
  enddo
  write(*,*)

  open(unit=101, file='scr')
  do iconn = 1, Nconn
    write(101,*) dist2(iconn)
  enddo
  close(101)
  write(*,*)

  write(cmd, '(a)') "sort -n -r scr > scr1; mv scr1 scr"
  call system(trim(cmd))

  open(unit=101, file='scr')
  do iconn = 1, Nconn
    read(101,*) distsort2(iconn)
  enddo
  close(101)

  write(*,'(a,i4)')"== bond lengths in file-2 in descending order, # ultralong bonds = ", nlong2
  do iconn = 1, Nconn
    write(*,'(f10.4)',advance='no') distsort2(iconn)
  enddo
  write(*,*)

  long1 = maxval(dist1)
  long2 = maxval(dist2)

  write(*,*)
  if ( (long1 .gt. 1.75d0) .and. (long2 .gt. 1.75d0) ) then
    write(*,'(a)') "** BAD order or BROKEN structure in both file-1 and file-2 **"
  elseif ( (long1 .gt. 1.75d0) .and. (long2 .le. 1.75d0) ) then
    write(*,'(a)') "** BAD order or BROKEN structure in file-1 **"
  elseif ( (long2 .gt. 1.75d0) .and. (long1 .le. 1.75d0) ) then
    write(*,'(a)') "** BAD order or BROKEN structure in file-2 **"
  elseif ( (long2 .le. 1.75d0) .and. (long1 .le. 1.75d0) ) then
    write(*,'(a)') "** Geometries in file-1 and file-2 seem alright, no broken structures detected **"
  endif

  MSD = sqrt(MSD/dfloat(Nconn))
  !=== Mean Percentage Absolute Deviation, w.r.t. the dist1 from file-1
  MPAD = sum(abs( (dist1-dist2)/dist1 ) * 100d0 )/ dfloat(Nconn)  
  !=== MaxAD from dist1 and dist2 stored above
  MaxAD = maxval(abs( dist1-dist2))

  write(*,*)
  write(*,'(a)')"== Mean square deviation of bond lengths from file-1 and file-2"
  write(*,'(x,a,f10.4,a)')"MSD  = ", MSD, " Ang"
  write(*,*)
  write(*,'(a)')"== Maximum absolute deviation in bond lengths from file-1 and file-2"
  write(*,'(x,a,f10.4,a)')"MaxAD= ", MaxAD, " Ang"
  write(*,*)
  write(*,'(a)')"== Mean percentage absolute deviation in bond lengths from file-1 and file-2"
  write(*,'(x,a,f10.4)')"MPAD = ", MPAD
  write(*,*)

  write(*,'(a)')"== Outcome of the Connectivity preserving Geometry Optimization"
  if ( (MPAD .lt. 5d0) .and. (MaxAD .lt. 0.2d0) )  then
    write(*,'(a)')"** ConnGO PASS [MPAD < 5, MaxAD < 0.2 Angstrom] **"
  else
    write(*,'(a)')"** ConnGO FAIL **"
  endif
  write(*,*)

  write(cmd, '(a)') "rm -f scr"
  call system(trim(cmd))

  deallocate(R1, R2, sy, tit1, tit2, conn, dist1, dist2, distsort1, distsort2)

end program conngo
