; ModuleID = 'esc.c'
source_filename = "esc.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [12 x i8] c"/etc/passwd\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"/bin/sh\00", align 1

; Function Attrs: nounwind
define dso_local i64 @esc_open() local_unnamed_addr #0 {
  %1 = tail call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 2, i64 ptrtoint (ptr @.str to i64), i64 0, i64 0) #2, !srcloc !8
  ret i64 %1
}

; Function Attrs: nounwind
define dso_local i64 @esc_getpid() local_unnamed_addr #0 {
  %1 = tail call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 39, i64 0, i64 0, i64 0) #2, !srcloc !8
  ret i64 %1
}

; Function Attrs: nounwind
define dso_local i64 @esc_stdout() local_unnamed_addr #0 {
  %1 = tail call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 1, i64 1, i64 ptrtoint (ptr @.str.1 to i64), i64 1) #2, !srcloc !8
  ret i64 %1
}

; Function Attrs: nounwind
define dso_local i64 @esc_socket() local_unnamed_addr #0 {
  %1 = tail call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 41, i64 2, i64 1, i64 0) #2, !srcloc !8
  ret i64 %1
}

; Function Attrs: nounwind
define dso_local i64 @esc_fork() local_unnamed_addr #0 {
  %1 = tail call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 57, i64 0, i64 0, i64 0) #2, !srcloc !8
  ret i64 %1
}

; Function Attrs: nounwind
define dso_local i64 @esc_execve() local_unnamed_addr #0 {
  %1 = tail call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 59, i64 ptrtoint (ptr @.str.2 to i64), i64 0, i64 0) #2, !srcloc !8
  ret i64 %1
}

; Function Attrs: nounwind
define dso_local i64 @esc_clock() local_unnamed_addr #0 {
  %1 = alloca [2 x i64], align 16
  call void @llvm.lifetime.start.p0(ptr nonnull %1) #2
  %2 = ptrtoint ptr %1 to i64
  %3 = call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 228, i64 0, i64 %2, i64 0) #2, !srcloc !8
  call void @llvm.lifetime.end.p0(ptr nonnull %1) #2
  ret i64 %3
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

; Function Attrs: nounwind
define dso_local range(i64 0, 4294967296) i64 @esc_rdtsc() local_unnamed_addr #0 {
  %1 = tail call { i32, i32 } asm sideeffect "rdtsc", "={ax},={dx},~{dirflag},~{fpsr},~{flags}"() #2, !srcloc !9
  %2 = extractvalue { i32, i32 } %1, 0
  %3 = zext i32 %2 to i64
  ret i64 %3
}

; Function Attrs: nounwind
define dso_local i64 @esc_mmap_exec() local_unnamed_addr #0 {
  %1 = tail call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},{r10},{r8},{r9},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 9, i64 0, i64 4096, i64 7, i64 34, i64 -1, i64 0) #2, !srcloc !10
  ret i64 %1
}

; Function Attrs: nounwind
define dso_local i64 @esc_x32() local_unnamed_addr #0 {
  %1 = tail call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 1073741863, i64 0, i64 0, i64 0) #2, !srcloc !8
  ret i64 %1
}

; Function Attrs: nounwind
define dso_local i64 @esc_getrandom() local_unnamed_addr #0 {
  %1 = alloca [4 x i8], align 1
  call void @llvm.lifetime.start.p0(ptr nonnull %1) #2
  %2 = ptrtoint ptr %1 to i64
  %3 = call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 318, i64 %2, i64 4, i64 0) #2, !srcloc !8
  call void @llvm.lifetime.end.p0(ptr nonnull %1) #2
  ret i64 %3
}

; Function Attrs: nounwind
define dso_local i64 @esc_vdso_time() local_unnamed_addr #0 {
  %1 = tail call i64 inttoptr (i64 -10484736 to ptr)(ptr noundef null) #3
  ret i64 %1
}

; Function Attrs: nounwind
define dso_local range(i64 0, 2) i64 @ok_mmap() local_unnamed_addr #0 {
  %1 = tail call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},{r10},{r8},{r9},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 9, i64 0, i64 4096, i64 3, i64 34, i64 -1, i64 0) #2, !srcloc !10
  %2 = icmp sgt i64 %1, 0
  %3 = zext i1 %2 to i64
  ret i64 %3
}

; Function Attrs: nounwind
define dso_local range(i64 0, 2) i64 @esc_env() local_unnamed_addr #0 {
  %1 = alloca i8, align 1
  call void @llvm.lifetime.start.p0(ptr nonnull %1) #2
  br label %2

2:                                                ; preds = %0, %38
  %3 = phi i64 [ 0, %0 ], [ %39, %38 ]
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 %3
  %5 = ptrtoint ptr %4 to i64
  %6 = and i64 %5, -4096
  %7 = call i64 asm sideeffect "syscall", "={ax},{ax},{di},{si},{dx},~{rcx},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"(i64 10, i64 %6, i64 4096, i64 1) #2, !srcloc !8
  %8 = load i8, ptr %1, align 1, !tbaa !11
  %9 = icmp eq i8 %8, 83
  br i1 %9, label %10, label %38

10:                                               ; preds = %2
  %11 = getelementptr inbounds nuw i8, ptr %4, i64 1
  %12 = load i8, ptr %11, align 1, !tbaa !11
  %13 = icmp eq i8 %12, 69
  br i1 %13, label %14, label %38

14:                                               ; preds = %10
  %15 = getelementptr inbounds nuw i8, ptr %4, i64 2
  %16 = load i8, ptr %15, align 1, !tbaa !11
  %17 = icmp eq i8 %16, 67
  br i1 %17, label %18, label %38

18:                                               ; preds = %14
  %19 = getelementptr inbounds nuw i8, ptr %4, i64 3
  %20 = load i8, ptr %19, align 1, !tbaa !11
  %21 = icmp eq i8 %20, 82
  br i1 %21, label %22, label %38

22:                                               ; preds = %18
  %23 = getelementptr inbounds nuw i8, ptr %4, i64 4
  %24 = load i8, ptr %23, align 1, !tbaa !11
  %25 = icmp eq i8 %24, 69
  br i1 %25, label %26, label %38

26:                                               ; preds = %22
  %27 = getelementptr inbounds nuw i8, ptr %4, i64 5
  %28 = load i8, ptr %27, align 1, !tbaa !11
  %29 = icmp eq i8 %28, 84
  br i1 %29, label %30, label %38

30:                                               ; preds = %26
  %31 = getelementptr inbounds nuw i8, ptr %4, i64 6
  %32 = load i8, ptr %31, align 1, !tbaa !11
  %33 = icmp eq i8 %32, 95
  br i1 %33, label %34, label %38

34:                                               ; preds = %30
  %35 = getelementptr inbounds nuw i8, ptr %4, i64 7
  %36 = load i8, ptr %35, align 1, !tbaa !11
  %37 = icmp eq i8 %36, 77
  br i1 %37, label %41, label %38

38:                                               ; preds = %34, %30, %26, %22, %18, %14, %10, %2
  %39 = add nuw nsw i64 %3, 1
  %40 = icmp eq i64 %39, 65536
  br i1 %40, label %41, label %2, !llvm.loop !12

41:                                               ; preds = %34, %38
  %42 = phi i64 [ 1, %34 ], [ 0, %38 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %1) #2
  ret i64 %42
}

attributes #0 = { nounwind "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind }
attributes #3 = { nobuiltin nounwind "no-builtins" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}
!llvm.errno.tbaa = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{!"clang version 22.1.8"}
!4 = !{!5, !5, i64 0}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{i64 97}
!9 = !{i64 1010}
!10 = !{i64 399}
!11 = !{!6, !6, i64 0}
!12 = distinct !{!12, !13, !14}
!13 = !{!"llvm.loop.mustprogress"}
!14 = !{!"llvm.loop.unroll.disable"}
