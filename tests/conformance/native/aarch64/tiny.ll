; ModuleID = 'tiny.c'
source_filename = "tiny.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "aarch64-unknown-linux-gnu"

@counter = internal unnamed_addr global i32 0, align 4

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local range(i64 -9223372036854775807, -9223372036854775808) i64 @tiny_add(i64 noundef %0, i64 noundef %1) local_unnamed_addr #0 {
  %3 = add i64 %0, 1
  %4 = add i64 %3, %1
  ret i64 %4
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local noundef double @tiny_half(double noundef %0) local_unnamed_addr #0 {
  %2 = fmul double %0, 5.000000e-01
  ret double %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local noundef i1 @tiny_neg(i1 noundef %0) local_unnamed_addr #0 {
  %2 = xor i1 %0, true
  ret i1 %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local noundef range(i8 0, -1) i8 @tiny_i8(i8 noundef %0) local_unnamed_addr #0 {
  %2 = shl i8 %0, 1
  ret i8 %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local noundef i16 @tiny_u16(i16 noundef %0) local_unnamed_addr #0 {
  %2 = add i16 %0, 1
  ret i16 %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local noundef float @tiny_f32(float noundef %0) local_unnamed_addr #0 {
  %2 = fmul float %0, 3.000000e+00
  ret float %2
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @tiny_upper(ptr noundef readonly captures(none) %0, i64 noundef %1, ptr noundef writeonly captures(none) %2, i64 noundef %3) local_unnamed_addr #1 {
  %5 = tail call i64 @llvm.smin.i64(i64 %1, i64 %3)
  %6 = icmp sgt i64 %5, 0
  br i1 %6, label %7, label %12

7:                                                ; preds = %4, %13
  %8 = phi i64 [ %19, %13 ], [ 0, %4 ]
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 %8
  %10 = load i8, ptr %9, align 1, !tbaa !9
  %11 = icmp eq i8 %10, 0
  br i1 %11, label %12, label %13

12:                                               ; preds = %7, %13, %4
  ret void

13:                                               ; preds = %7
  %14 = add i8 %10, -97
  %15 = icmp ult i8 %14, 26
  %16 = add nsw i8 %10, -32
  %17 = select i1 %15, i8 %16, i8 %10
  %18 = getelementptr inbounds nuw i8, ptr %2, i64 %8
  store i8 %17, ptr %18, align 1, !tbaa !9
  %19 = add nuw nsw i64 %8, 1
  %20 = icmp eq i64 %19, %5
  br i1 %20, label %12, label %7, !llvm.loop !10
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #2

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @tiny_rev(ptr noundef readonly captures(none) %0, i64 noundef %1, ptr noundef writeonly captures(none) %2, i64 noundef %3) local_unnamed_addr #1 {
  %5 = icmp sgt i64 %1, 0
  br i1 %5, label %6, label %8

6:                                                ; preds = %4
  %7 = getelementptr i8, ptr %0, i64 %1
  br label %9

8:                                                ; preds = %9, %4
  ret void

9:                                                ; preds = %6, %9
  %10 = phi i64 [ 0, %6 ], [ %15, %9 ]
  %11 = xor i64 %10, -1
  %12 = getelementptr i8, ptr %7, i64 %11
  %13 = load i8, ptr %12, align 1, !tbaa !9
  %14 = getelementptr inbounds nuw i8, ptr %2, i64 %10
  store i8 %13, ptr %14, align 1, !tbaa !9
  %15 = add nuw nsw i64 %10, 1
  %16 = icmp eq i64 %15, %1
  br i1 %16, label %8, label %9, !llvm.loop !13
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local range(i64 -2147483647, 2147483648) i64 @tiny_count() local_unnamed_addr #3 {
  %1 = load i32, ptr @counter, align 4, !tbaa !5
  %2 = add nsw i32 %1, 1
  store i32 %2, ptr @counter, align 4, !tbaa !5
  %3 = sext i32 %2 to i64
  ret i64 %3
}

; Function Attrs: nounwind
define dso_local noundef i1 @tiny_forged_bool() local_unnamed_addr #4 {
  %1 = alloca i64, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %1) #8
  store i64 2, ptr %1, align 8, !tbaa !14
  %2 = ptrtoint ptr %1 to i64
  %3 = call i64 asm sideeffect "svc #0", "={x0},{x8},{x1},{x2},{x0},~{memory}"(i64 64, i64 %2, i64 8, i64 3) #8, !srcloc !16
  %4 = call i64 asm sideeffect "svc #0", "={x0},{x8},{x1},{x2},{x0},~{memory}"(i64 94, i64 0, i64 0, i64 0) #8, !srcloc !16
  call void @llvm.lifetime.end.p0(ptr nonnull %1) #8
  ret i1 false
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @tiny_bad_text(ptr noundef writeonly captures(none) initializes((0, 2)) %0, i64 noundef %1) local_unnamed_addr #5 {
  store i8 -1, ptr %0, align 1, !tbaa !9
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 1
  store i8 97, ptr %3, align 1, !tbaa !9
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(readwrite, target_mem0: none, target_mem1: none)
define dso_local i64 @tiny_crash(i64 noundef %0) local_unnamed_addr #6 {
  %2 = load volatile i64, ptr null, align 4294967296, !tbaa !14
  %3 = add nsw i64 %2, %0
  ret i64 %3
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smin.i64(i64, i64) #7

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "frame-pointer"="non-leaf-no-reserve" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+v8a,-fmv" }
attributes #1 = { nofree norecurse nosync nounwind memory(argmem: readwrite) "frame-pointer"="non-leaf-no-reserve" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+v8a,-fmv" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none) "frame-pointer"="non-leaf-no-reserve" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+v8a,-fmv" }
attributes #4 = { nounwind "frame-pointer"="non-leaf-no-reserve" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+v8a,-fmv" }
attributes #5 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) "frame-pointer"="non-leaf-no-reserve" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+v8a,-fmv" }
attributes #6 = { mustprogress nofree norecurse nounwind willreturn memory(readwrite, target_mem0: none, target_mem1: none) "frame-pointer"="non-leaf-no-reserve" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+v8a,-fmv" }
attributes #7 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #8 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}
!llvm.errno.tbaa = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"frame-pointer", i32 4}
!4 = !{!"clang version 22.1.8"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!7, !7, i64 0}
!10 = distinct !{!10, !11, !12}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.unroll.disable"}
!13 = distinct !{!13, !11, !12}
!14 = !{!15, !15, i64 0}
!15 = !{!"long", !7, i64 0}
!16 = !{i64 1118}
