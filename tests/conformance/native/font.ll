; ModuleID = 'native/font/font.c'
source_filename = "native/font/font.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.FontResult = type { i32, i32, i32, [256 x i32], [256 x i32], [256 x i32], [256 x i32], [256 x i32], [256 x i32], i32, [128 x i32], [128 x i32], [128 x i32], [4194304 x i8] }
%struct.stbtt__csctx = type { i32, i32, float, float, float, float, i32, i32, i32, i32, ptr, i32 }
%struct.stbtt_vertex = type { i16, i16, i16, i16, i16, i16, i8, i8 }
%struct.stbtt_kerningentry = type { i32, i32, i32 }
%struct.stbtt_bakedchar = type { i16, i16, i16, i16, float, float, float }
%struct.stbtt_pack_range = type { float, i32, ptr, i32, ptr, i8, i8 }
%struct.stbrp_rect = type { i32, i32, i32, i32, i32, i32 }
%struct.stbtt_packedchar = type { i16, i16, i16, i16, float, float, float, float, float }
%struct.stbtt__buf = type { ptr, i32, i32 }
%struct.stbtt_fontinfo = type { ptr, ptr, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.stbtt__buf, %struct.stbtt__buf, %struct.stbtt__buf, %struct.stbtt__buf, %struct.stbtt__buf, %struct.stbtt__buf }
%struct.anon = type { i32, i32, i32, i32, i32, i32, i32, i32, i32 }

@alloc_offset = internal unnamed_addr global i64 0, align 8
@alloc_buffer = internal global [1048576 x i8] zeroinitializer, align 16
@font_atlas.result = internal unnamed_addr global %struct.FontResult zeroinitializer, align 4

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local i32 @stbtt_FindGlyphIndex(ptr noundef readonly captures(none) %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load ptr, ptr %3, align 8, !tbaa !8
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 56
  %6 = load i32, ptr %5, align 8, !tbaa !13
  %7 = zext i32 %6 to i64
  %8 = getelementptr inbounds nuw i8, ptr %4, i64 %7
  %9 = load i8, ptr %8, align 1, !tbaa !14
  %10 = zext i8 %9 to i16
  %11 = shl nuw i16 %10, 8
  %12 = getelementptr inbounds nuw i8, ptr %8, i64 1
  %13 = load i8, ptr %12, align 1, !tbaa !14
  %14 = zext i8 %13 to i16
  %15 = or disjoint i16 %11, %14
  switch i16 %15, label %225 [
    i16 0, label %16
    i16 6, label %33
    i16 2, label %328
    i16 4, label %67
  ]

16:                                               ; preds = %2
  %17 = getelementptr inbounds nuw i8, ptr %8, i64 2
  %18 = load i8, ptr %17, align 1, !tbaa !14
  %19 = zext i8 %18 to i32
  %20 = shl nuw nsw i32 %19, 8
  %21 = getelementptr inbounds nuw i8, ptr %8, i64 3
  %22 = load i8, ptr %21, align 1, !tbaa !14
  %23 = zext i8 %22 to i32
  %24 = or disjoint i32 %20, %23
  %25 = add nsw i32 %24, -6
  %26 = icmp slt i32 %1, %25
  br i1 %26, label %27, label %328

27:                                               ; preds = %16
  %28 = getelementptr inbounds nuw i8, ptr %8, i64 6
  %29 = sext i32 %1 to i64
  %30 = getelementptr inbounds i8, ptr %28, i64 %29
  %31 = load i8, ptr %30, align 1, !tbaa !14
  %32 = zext i8 %31 to i32
  br label %328

33:                                               ; preds = %2
  %34 = getelementptr inbounds nuw i8, ptr %8, i64 6
  %35 = load i8, ptr %34, align 1, !tbaa !14
  %36 = zext i8 %35 to i32
  %37 = shl nuw nsw i32 %36, 8
  %38 = getelementptr inbounds nuw i8, ptr %8, i64 7
  %39 = load i8, ptr %38, align 1, !tbaa !14
  %40 = zext i8 %39 to i32
  %41 = or disjoint i32 %37, %40
  %42 = icmp ult i32 %1, %41
  br i1 %42, label %328, label %43

43:                                               ; preds = %33
  %44 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %45 = load i8, ptr %44, align 1, !tbaa !14
  %46 = zext i8 %45 to i32
  %47 = shl nuw nsw i32 %46, 8
  %48 = getelementptr inbounds nuw i8, ptr %8, i64 9
  %49 = load i8, ptr %48, align 1, !tbaa !14
  %50 = zext i8 %49 to i32
  %51 = or disjoint i32 %47, %50
  %52 = add nuw nsw i32 %51, %41
  %53 = icmp ult i32 %1, %52
  br i1 %53, label %54, label %328

54:                                               ; preds = %43
  %55 = getelementptr inbounds nuw i8, ptr %8, i64 10
  %56 = sub nsw i32 %1, %41
  %57 = shl nsw i32 %56, 1
  %58 = zext i32 %57 to i64
  %59 = getelementptr inbounds nuw i8, ptr %55, i64 %58
  %60 = load i8, ptr %59, align 1, !tbaa !14
  %61 = zext i8 %60 to i32
  %62 = shl nuw nsw i32 %61, 8
  %63 = getelementptr inbounds nuw i8, ptr %59, i64 1
  %64 = load i8, ptr %63, align 1, !tbaa !14
  %65 = zext i8 %64 to i32
  %66 = or disjoint i32 %62, %65
  br label %328

67:                                               ; preds = %2
  %68 = getelementptr inbounds nuw i8, ptr %8, i64 6
  %69 = load i8, ptr %68, align 1, !tbaa !14
  %70 = zext i8 %69 to i32
  %71 = shl nuw nsw i32 %70, 8
  %72 = getelementptr inbounds nuw i8, ptr %8, i64 7
  %73 = load i8, ptr %72, align 1, !tbaa !14
  %74 = zext i8 %73 to i32
  %75 = or disjoint i32 %71, %74
  %76 = lshr i32 %75, 1
  %77 = icmp sgt i32 %1, 65535
  br i1 %77, label %328, label %78

78:                                               ; preds = %67
  %79 = add i32 %6, 14
  %80 = getelementptr inbounds nuw i8, ptr %8, i64 12
  %81 = load i8, ptr %80, align 1, !tbaa !14
  %82 = zext i8 %81 to i16
  %83 = shl nuw i16 %82, 8
  %84 = getelementptr inbounds nuw i8, ptr %8, i64 13
  %85 = load i8, ptr %84, align 1, !tbaa !14
  %86 = getelementptr inbounds nuw i8, ptr %8, i64 10
  %87 = load i8, ptr %86, align 1, !tbaa !14
  %88 = zext i8 %87 to i16
  %89 = shl nuw i16 %88, 8
  %90 = getelementptr inbounds nuw i8, ptr %8, i64 11
  %91 = load i8, ptr %90, align 1, !tbaa !14
  %92 = zext i8 %91 to i16
  %93 = or disjoint i16 %89, %92
  %94 = and i8 %85, -2
  %95 = zext i8 %94 to i16
  %96 = or disjoint i16 %83, %95
  %97 = zext i32 %79 to i64
  %98 = getelementptr inbounds nuw i8, ptr %4, i64 %97
  %99 = zext i16 %96 to i64
  %100 = getelementptr inbounds nuw i8, ptr %98, i64 %99
  %101 = load i8, ptr %100, align 1, !tbaa !14
  %102 = zext i8 %101 to i32
  %103 = shl nuw nsw i32 %102, 8
  %104 = getelementptr inbounds nuw i8, ptr %100, i64 1
  %105 = load i8, ptr %104, align 1, !tbaa !14
  %106 = zext i8 %105 to i32
  %107 = or disjoint i32 %103, %106
  %108 = icmp slt i32 %1, %107
  %109 = zext i16 %96 to i32
  %110 = select i1 %108, i32 0, i32 %109
  %111 = add i32 %6, 12
  %112 = add i32 %111, %110
  %113 = icmp eq i16 %93, 0
  br i1 %113, label %146, label %114

114:                                              ; preds = %78
  %115 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %116 = load i8, ptr %115, align 1, !tbaa !14
  %117 = zext i8 %116 to i16
  %118 = shl nuw i16 %117, 8
  %119 = getelementptr inbounds nuw i8, ptr %8, i64 9
  %120 = load i8, ptr %119, align 1, !tbaa !14
  %121 = zext i8 %120 to i16
  %122 = or disjoint i16 %118, %121
  br label %123

123:                                              ; preds = %114, %123
  %124 = phi i16 [ %127, %123 ], [ %122, %114 ]
  %125 = phi i16 [ %144, %123 ], [ %93, %114 ]
  %126 = phi i32 [ %143, %123 ], [ %112, %114 ]
  %127 = lshr i16 %124, 1
  %128 = zext i32 %126 to i64
  %129 = getelementptr inbounds nuw i8, ptr %4, i64 %128
  %130 = and i16 %127, 32766
  %131 = zext nneg i16 %130 to i64
  %132 = getelementptr inbounds nuw i8, ptr %129, i64 %131
  %133 = load i8, ptr %132, align 1, !tbaa !14
  %134 = zext i8 %133 to i32
  %135 = shl nuw nsw i32 %134, 8
  %136 = getelementptr inbounds nuw i8, ptr %132, i64 1
  %137 = load i8, ptr %136, align 1, !tbaa !14
  %138 = zext i8 %137 to i32
  %139 = or disjoint i32 %135, %138
  %140 = icmp sgt i32 %1, %139
  %141 = zext nneg i16 %130 to i32
  %142 = select i1 %140, i32 %141, i32 0
  %143 = add i32 %142, %126
  %144 = add i16 %125, -1
  %145 = icmp eq i16 %144, 0
  br i1 %145, label %146, label %123, !llvm.loop !15

146:                                              ; preds = %123, %78
  %147 = phi i32 [ %112, %78 ], [ %143, %123 ]
  %148 = sub i32 %147, %6
  %149 = add i32 %148, 131060
  %150 = getelementptr inbounds nuw i8, ptr %8, i64 14
  %151 = and i32 %75, 65534
  %152 = zext nneg i32 %151 to i64
  %153 = getelementptr inbounds nuw i8, ptr %150, i64 %152
  %154 = getelementptr inbounds nuw i8, ptr %153, i64 2
  %155 = and i32 %149, 131070
  %156 = zext nneg i32 %155 to i64
  %157 = getelementptr inbounds nuw i8, ptr %154, i64 %156
  %158 = load i8, ptr %157, align 1, !tbaa !14
  %159 = zext i8 %158 to i32
  %160 = shl nuw nsw i32 %159, 8
  %161 = getelementptr inbounds nuw i8, ptr %157, i64 1
  %162 = load i8, ptr %161, align 1, !tbaa !14
  %163 = zext i8 %162 to i32
  %164 = or disjoint i32 %160, %163
  %165 = getelementptr inbounds nuw i8, ptr %98, i64 %156
  %166 = load i8, ptr %165, align 1, !tbaa !14
  %167 = zext i8 %166 to i32
  %168 = shl nuw nsw i32 %167, 8
  %169 = getelementptr inbounds nuw i8, ptr %165, i64 1
  %170 = load i8, ptr %169, align 1, !tbaa !14
  %171 = zext i8 %170 to i32
  %172 = or disjoint i32 %168, %171
  %173 = icmp slt i32 %1, %164
  %174 = icmp sgt i32 %1, %172
  %175 = select i1 %173, i1 true, i1 %174
  br i1 %175, label %222, label %176

176:                                              ; preds = %146
  %177 = mul nuw nsw i32 %76, 6
  %178 = zext nneg i32 %177 to i64
  %179 = getelementptr inbounds nuw i8, ptr %150, i64 %178
  %180 = getelementptr inbounds nuw i8, ptr %179, i64 2
  %181 = getelementptr inbounds nuw i8, ptr %180, i64 %156
  %182 = load i8, ptr %181, align 1, !tbaa !14
  %183 = zext i8 %182 to i16
  %184 = shl nuw i16 %183, 8
  %185 = getelementptr inbounds nuw i8, ptr %181, i64 1
  %186 = load i8, ptr %185, align 1, !tbaa !14
  %187 = zext i8 %186 to i16
  %188 = or disjoint i16 %184, %187
  %189 = icmp eq i16 %188, 0
  br i1 %189, label %190, label %204

190:                                              ; preds = %176
  %191 = shl nuw nsw i32 %76, 2
  %192 = zext nneg i32 %191 to i64
  %193 = getelementptr inbounds nuw i8, ptr %150, i64 %192
  %194 = getelementptr inbounds nuw i8, ptr %193, i64 2
  %195 = getelementptr inbounds nuw i8, ptr %194, i64 %156
  %196 = load i8, ptr %195, align 1, !tbaa !14
  %197 = zext i8 %196 to i32
  %198 = shl nuw nsw i32 %197, 8
  %199 = getelementptr inbounds nuw i8, ptr %195, i64 1
  %200 = load i8, ptr %199, align 1, !tbaa !14
  %201 = zext i8 %200 to i32
  %202 = or disjoint i32 %198, %201
  %203 = add nuw nsw i32 %202, %1
  br label %222

204:                                              ; preds = %176
  %205 = zext i16 %188 to i64
  %206 = getelementptr inbounds nuw i8, ptr %4, i64 %205
  %207 = sub nsw i32 %1, %164
  %208 = shl nsw i32 %207, 1
  %209 = sext i32 %208 to i64
  %210 = getelementptr inbounds i8, ptr %206, i64 %209
  %211 = getelementptr inbounds nuw i8, ptr %210, i64 %7
  %212 = getelementptr inbounds nuw i8, ptr %211, i64 %178
  %213 = getelementptr inbounds nuw i8, ptr %212, i64 16
  %214 = getelementptr inbounds nuw i8, ptr %213, i64 %156
  %215 = load i8, ptr %214, align 1, !tbaa !14
  %216 = zext i8 %215 to i32
  %217 = shl nuw nsw i32 %216, 8
  %218 = getelementptr inbounds nuw i8, ptr %214, i64 1
  %219 = load i8, ptr %218, align 1, !tbaa !14
  %220 = zext i8 %219 to i32
  %221 = or disjoint i32 %217, %220
  br label %222

222:                                              ; preds = %146, %204, %190
  %223 = phi i32 [ %221, %204 ], [ %203, %190 ], [ 0, %146 ]
  %224 = and i32 %223, 65535
  br label %328

225:                                              ; preds = %2
  %226 = icmp eq i16 %15, 12
  %227 = and i16 %15, -2
  %228 = icmp eq i16 %227, 12
  br i1 %228, label %229, label %328

229:                                              ; preds = %225
  %230 = getelementptr inbounds nuw i8, ptr %8, i64 12
  %231 = load i8, ptr %230, align 1, !tbaa !14
  %232 = zext i8 %231 to i32
  %233 = shl nuw i32 %232, 24
  %234 = getelementptr inbounds nuw i8, ptr %8, i64 13
  %235 = load i8, ptr %234, align 1, !tbaa !14
  %236 = zext i8 %235 to i32
  %237 = shl nuw nsw i32 %236, 16
  %238 = or disjoint i32 %237, %233
  %239 = getelementptr inbounds nuw i8, ptr %8, i64 14
  %240 = load i8, ptr %239, align 1, !tbaa !14
  %241 = zext i8 %240 to i32
  %242 = shl nuw nsw i32 %241, 8
  %243 = or disjoint i32 %238, %242
  %244 = getelementptr inbounds nuw i8, ptr %8, i64 15
  %245 = load i8, ptr %244, align 1, !tbaa !14
  %246 = zext i8 %245 to i32
  %247 = or disjoint i32 %243, %246
  %248 = getelementptr inbounds nuw i8, ptr %8, i64 16
  br label %249

249:                                              ; preds = %323, %229
  %250 = phi i32 [ 0, %229 ], [ %324, %323 ]
  %251 = phi i32 [ %247, %229 ], [ %325, %323 ]
  %252 = phi i32 [ undef, %229 ], [ %327, %323 ]
  %253 = icmp slt i32 %250, %251
  br i1 %253, label %254, label %328

254:                                              ; preds = %249
  %255 = sub nsw i32 %251, %250
  %256 = lshr i32 %255, 1
  %257 = add nuw nsw i32 %256, %250
  %258 = mul nsw i32 %257, 12
  %259 = zext nneg i32 %258 to i64
  %260 = getelementptr inbounds nuw i8, ptr %248, i64 %259
  %261 = load i8, ptr %260, align 1, !tbaa !14
  %262 = zext i8 %261 to i32
  %263 = shl nuw i32 %262, 24
  %264 = getelementptr inbounds nuw i8, ptr %260, i64 1
  %265 = load i8, ptr %264, align 1, !tbaa !14
  %266 = zext i8 %265 to i32
  %267 = shl nuw nsw i32 %266, 16
  %268 = or disjoint i32 %267, %263
  %269 = getelementptr inbounds nuw i8, ptr %260, i64 2
  %270 = load i8, ptr %269, align 1, !tbaa !14
  %271 = zext i8 %270 to i32
  %272 = shl nuw nsw i32 %271, 8
  %273 = or disjoint i32 %268, %272
  %274 = getelementptr inbounds nuw i8, ptr %260, i64 3
  %275 = load i8, ptr %274, align 1, !tbaa !14
  %276 = zext i8 %275 to i32
  %277 = or disjoint i32 %273, %276
  %278 = icmp ult i32 %1, %277
  br i1 %278, label %323, label %279

279:                                              ; preds = %254
  %280 = getelementptr inbounds nuw i8, ptr %260, i64 5
  %281 = load i8, ptr %280, align 1, !tbaa !14
  %282 = zext i8 %281 to i32
  %283 = shl nuw nsw i32 %282, 16
  %284 = getelementptr inbounds nuw i8, ptr %260, i64 4
  %285 = load i8, ptr %284, align 1, !tbaa !14
  %286 = zext i8 %285 to i32
  %287 = shl nuw i32 %286, 24
  %288 = or disjoint i32 %287, %283
  %289 = getelementptr inbounds nuw i8, ptr %260, i64 6
  %290 = load i8, ptr %289, align 1, !tbaa !14
  %291 = zext i8 %290 to i32
  %292 = shl nuw nsw i32 %291, 8
  %293 = or disjoint i32 %288, %292
  %294 = getelementptr inbounds nuw i8, ptr %260, i64 7
  %295 = load i8, ptr %294, align 1, !tbaa !14
  %296 = zext i8 %295 to i32
  %297 = or disjoint i32 %293, %296
  %298 = icmp ugt i32 %1, %297
  br i1 %298, label %299, label %301

299:                                              ; preds = %279
  %300 = add nuw nsw i32 %257, 1
  br label %323

301:                                              ; preds = %279
  %302 = getelementptr inbounds nuw i8, ptr %260, i64 8
  %303 = load i8, ptr %302, align 1, !tbaa !14
  %304 = zext i8 %303 to i32
  %305 = shl nuw i32 %304, 24
  %306 = getelementptr inbounds nuw i8, ptr %260, i64 9
  %307 = load i8, ptr %306, align 1, !tbaa !14
  %308 = zext i8 %307 to i32
  %309 = shl nuw nsw i32 %308, 16
  %310 = or disjoint i32 %309, %305
  %311 = getelementptr inbounds nuw i8, ptr %260, i64 10
  %312 = load i8, ptr %311, align 1, !tbaa !14
  %313 = zext i8 %312 to i32
  %314 = shl nuw nsw i32 %313, 8
  %315 = or disjoint i32 %310, %314
  %316 = getelementptr inbounds nuw i8, ptr %260, i64 11
  %317 = load i8, ptr %316, align 1, !tbaa !14
  %318 = zext i8 %317 to i32
  %319 = or disjoint i32 %315, %318
  %320 = sub i32 %1, %277
  %321 = select i1 %226, i32 %320, i32 0
  %322 = add i32 %319, %321
  br label %323

323:                                              ; preds = %299, %254, %301
  %324 = phi i32 [ %250, %301 ], [ %300, %299 ], [ %250, %254 ]
  %325 = phi i32 [ %251, %301 ], [ %251, %299 ], [ %257, %254 ]
  %326 = phi i1 [ false, %301 ], [ true, %299 ], [ true, %254 ]
  %327 = phi i32 [ %322, %301 ], [ %252, %299 ], [ %252, %254 ]
  br i1 %326, label %249, label %328, !llvm.loop !18

328:                                              ; preds = %323, %249, %225, %222, %67, %2, %54, %43, %33, %27, %16
  %329 = phi i32 [ 0, %225 ], [ 0, %16 ], [ 0, %33 ], [ 0, %2 ], [ 0, %67 ], [ %32, %27 ], [ %66, %54 ], [ 0, %43 ], [ %224, %222 ], [ 0, %249 ], [ %327, %323 ]
  ret i32 %329
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

; Function Attrs: nounwind
define dso_local i32 @stbtt_GetCodepointShape(ptr noundef readonly captures(none) %0, i32 noundef %1, ptr noundef writeonly captures(none) initializes((0, 8)) %2) local_unnamed_addr #2 {
  %4 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %1) #25
  %5 = tail call i32 @stbtt_GetGlyphShape(ptr noundef %0, i32 noundef %4, ptr noundef %2) #25
  ret i32 %5
}

; Function Attrs: nounwind
define dso_local i32 @stbtt_GetGlyphShape(ptr noundef readonly captures(none) %0, i32 noundef %1, ptr noundef writeonly captures(none) initializes((0, 8)) %2) local_unnamed_addr #2 {
  %4 = alloca %struct.stbtt__csctx, align 8
  %5 = alloca %struct.stbtt__csctx, align 8
  %6 = alloca ptr, align 8
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 76
  %8 = load i32, ptr %7, align 4, !tbaa !19
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %10, label %219

10:                                               ; preds = %3
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %12 = load ptr, ptr %11, align 8, !tbaa !8
  %13 = tail call fastcc i32 @stbtt__GetGlyfOffset(ptr noundef %0, i32 noundef %1) #25
  store ptr null, ptr %2, align 8, !tbaa !20
  %14 = icmp slt i32 %13, 0
  br i1 %14, label %232, label %15

15:                                               ; preds = %10
  %16 = zext nneg i32 %13 to i64
  %17 = getelementptr inbounds nuw i8, ptr %12, i64 %16
  %18 = load i8, ptr %17, align 1, !tbaa !14
  %19 = zext i8 %18 to i16
  %20 = shl nuw i16 %19, 8
  %21 = getelementptr inbounds nuw i8, ptr %17, i64 1
  %22 = load i8, ptr %21, align 1, !tbaa !14
  %23 = zext i8 %22 to i16
  %24 = or disjoint i16 %20, %23
  %25 = icmp sgt i16 %24, 0
  br i1 %25, label %232, label %26

26:                                               ; preds = %15
  %27 = icmp slt i16 %20, 0
  br i1 %27, label %28, label %218

28:                                               ; preds = %26
  %29 = getelementptr inbounds nuw i8, ptr %17, i64 10
  br label %30

30:                                               ; preds = %216, %28
  %31 = phi i32 [ 1, %28 ], [ %217, %216 ]
  %32 = phi ptr [ %29, %28 ], [ %162, %216 ]
  %33 = icmp eq i32 %31, 0
  br i1 %33, label %218, label %34

34:                                               ; preds = %30
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #26
  store ptr null, ptr %6, align 8, !tbaa !20
  %35 = getelementptr inbounds nuw i8, ptr %32, i64 1
  %36 = load i8, ptr %35, align 1, !tbaa !14
  %37 = zext i8 %36 to i32
  %38 = getelementptr inbounds nuw i8, ptr %32, i64 2
  %39 = load i8, ptr %38, align 1, !tbaa !14
  %40 = zext i8 %39 to i32
  %41 = shl nuw nsw i32 %40, 8
  %42 = getelementptr inbounds nuw i8, ptr %32, i64 3
  %43 = load i8, ptr %42, align 1, !tbaa !14
  %44 = zext i8 %43 to i32
  %45 = or disjoint i32 %41, %44
  %46 = getelementptr inbounds nuw i8, ptr %32, i64 4
  %47 = and i32 %37, 2
  %48 = icmp eq i32 %47, 0
  br i1 %48, label %77, label %49

49:                                               ; preds = %34
  %50 = and i32 %37, 1
  %51 = icmp eq i32 %50, 0
  %52 = load i8, ptr %46, align 1, !tbaa !14
  br i1 %51, label %71, label %53

53:                                               ; preds = %49
  %54 = zext i8 %52 to i16
  %55 = shl nuw i16 %54, 8
  %56 = getelementptr inbounds nuw i8, ptr %32, i64 5
  %57 = load i8, ptr %56, align 1, !tbaa !14
  %58 = zext i8 %57 to i16
  %59 = or disjoint i16 %55, %58
  %60 = sitofp i16 %59 to float
  %61 = getelementptr inbounds nuw i8, ptr %32, i64 6
  %62 = load i8, ptr %61, align 1, !tbaa !14
  %63 = zext i8 %62 to i16
  %64 = shl nuw i16 %63, 8
  %65 = getelementptr inbounds nuw i8, ptr %32, i64 7
  %66 = load i8, ptr %65, align 1, !tbaa !14
  %67 = zext i8 %66 to i16
  %68 = or disjoint i16 %64, %67
  %69 = sitofp i16 %68 to float
  %70 = getelementptr inbounds nuw i8, ptr %32, i64 8
  br label %77

71:                                               ; preds = %49
  %72 = sitofp i8 %52 to float
  %73 = getelementptr inbounds nuw i8, ptr %32, i64 5
  %74 = load i8, ptr %73, align 1, !tbaa !14
  %75 = sitofp i8 %74 to float
  %76 = getelementptr inbounds nuw i8, ptr %32, i64 6
  br label %77

77:                                               ; preds = %71, %53, %34
  %78 = phi ptr [ %70, %53 ], [ %76, %71 ], [ %46, %34 ]
  %79 = phi float [ %69, %53 ], [ %75, %71 ], [ 0.000000e+00, %34 ]
  %80 = phi float [ %60, %53 ], [ %72, %71 ], [ 0.000000e+00, %34 ]
  %81 = and i32 %37, 8
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %94, label %83

83:                                               ; preds = %77
  %84 = load i8, ptr %78, align 1, !tbaa !14
  %85 = zext i8 %84 to i16
  %86 = shl nuw i16 %85, 8
  %87 = getelementptr inbounds nuw i8, ptr %78, i64 1
  %88 = load i8, ptr %87, align 1, !tbaa !14
  %89 = zext i8 %88 to i16
  %90 = or disjoint i16 %86, %89
  %91 = sitofp i16 %90 to float
  %92 = fmul float %91, 0x3F10000000000000
  %93 = getelementptr inbounds nuw i8, ptr %78, i64 2
  br label %161

94:                                               ; preds = %77
  %95 = and i32 %37, 64
  %96 = icmp eq i32 %95, 0
  br i1 %96, label %118, label %97

97:                                               ; preds = %94
  %98 = load i8, ptr %78, align 1, !tbaa !14
  %99 = zext i8 %98 to i16
  %100 = shl nuw i16 %99, 8
  %101 = getelementptr inbounds nuw i8, ptr %78, i64 1
  %102 = load i8, ptr %101, align 1, !tbaa !14
  %103 = zext i8 %102 to i16
  %104 = or disjoint i16 %100, %103
  %105 = sitofp i16 %104 to float
  %106 = fmul float %105, 0x3F10000000000000
  %107 = getelementptr inbounds nuw i8, ptr %78, i64 2
  %108 = load i8, ptr %107, align 1, !tbaa !14
  %109 = zext i8 %108 to i16
  %110 = shl nuw i16 %109, 8
  %111 = getelementptr inbounds nuw i8, ptr %78, i64 3
  %112 = load i8, ptr %111, align 1, !tbaa !14
  %113 = zext i8 %112 to i16
  %114 = or disjoint i16 %110, %113
  %115 = sitofp i16 %114 to float
  %116 = fmul float %115, 0x3F10000000000000
  %117 = getelementptr inbounds nuw i8, ptr %78, i64 4
  br label %161

118:                                              ; preds = %94
  %119 = icmp sgt i8 %36, -1
  br i1 %119, label %161, label %120

120:                                              ; preds = %118
  %121 = load i8, ptr %78, align 1, !tbaa !14
  %122 = zext i8 %121 to i16
  %123 = shl nuw i16 %122, 8
  %124 = getelementptr inbounds nuw i8, ptr %78, i64 1
  %125 = load i8, ptr %124, align 1, !tbaa !14
  %126 = zext i8 %125 to i16
  %127 = or disjoint i16 %123, %126
  %128 = sitofp i16 %127 to float
  %129 = fmul float %128, 0x3F10000000000000
  %130 = getelementptr inbounds nuw i8, ptr %78, i64 2
  %131 = load i8, ptr %130, align 1, !tbaa !14
  %132 = zext i8 %131 to i16
  %133 = shl nuw i16 %132, 8
  %134 = getelementptr inbounds nuw i8, ptr %78, i64 3
  %135 = load i8, ptr %134, align 1, !tbaa !14
  %136 = zext i8 %135 to i16
  %137 = or disjoint i16 %133, %136
  %138 = sitofp i16 %137 to float
  %139 = fmul float %138, 0x3F10000000000000
  %140 = getelementptr inbounds nuw i8, ptr %78, i64 4
  %141 = load i8, ptr %140, align 1, !tbaa !14
  %142 = zext i8 %141 to i16
  %143 = shl nuw i16 %142, 8
  %144 = getelementptr inbounds nuw i8, ptr %78, i64 5
  %145 = load i8, ptr %144, align 1, !tbaa !14
  %146 = zext i8 %145 to i16
  %147 = or disjoint i16 %143, %146
  %148 = sitofp i16 %147 to float
  %149 = fmul float %148, 0x3F10000000000000
  %150 = getelementptr inbounds nuw i8, ptr %78, i64 6
  %151 = load i8, ptr %150, align 1, !tbaa !14
  %152 = zext i8 %151 to i16
  %153 = shl nuw i16 %152, 8
  %154 = getelementptr inbounds nuw i8, ptr %78, i64 7
  %155 = load i8, ptr %154, align 1, !tbaa !14
  %156 = zext i8 %155 to i16
  %157 = or disjoint i16 %153, %156
  %158 = sitofp i16 %157 to float
  %159 = fmul float %158, 0x3F10000000000000
  %160 = getelementptr inbounds nuw i8, ptr %78, i64 8
  br label %161

161:                                              ; preds = %120, %118, %97, %83
  %162 = phi ptr [ %93, %83 ], [ %117, %97 ], [ %160, %120 ], [ %78, %118 ]
  %163 = phi float [ %92, %83 ], [ %116, %97 ], [ %159, %120 ], [ 1.000000e+00, %118 ]
  %164 = phi float [ 0.000000e+00, %83 ], [ 0.000000e+00, %97 ], [ %149, %120 ], [ 0.000000e+00, %118 ]
  %165 = phi float [ 0.000000e+00, %83 ], [ 0.000000e+00, %97 ], [ %139, %120 ], [ 0.000000e+00, %118 ]
  %166 = phi float [ %92, %83 ], [ %106, %97 ], [ %129, %120 ], [ 1.000000e+00, %118 ]
  %167 = fmul float %165, %165
  %168 = tail call float @llvm.fmuladd.f32(float %166, float %166, float %167)
  %169 = tail call float @sqrtf(float noundef %168) #27
  %170 = fmul float %163, %163
  %171 = tail call float @llvm.fmuladd.f32(float %164, float %164, float %170)
  %172 = tail call float @sqrtf(float noundef %171) #27
  %173 = call i32 @stbtt_GetGlyphShape(ptr noundef %0, i32 noundef %45, ptr noundef nonnull %6) #25
  %174 = icmp slt i32 %173, 1
  br i1 %174, label %214, label %175

175:                                              ; preds = %161
  %176 = load ptr, ptr %6, align 8, !tbaa !20
  %177 = zext nneg i32 %173 to i64
  br label %178

178:                                              ; preds = %175, %178
  %179 = phi i64 [ 0, %175 ], [ %212, %178 ]
  %180 = getelementptr inbounds nuw %struct.stbtt_vertex, ptr %176, i64 %179
  %181 = load i16, ptr %180, align 2, !tbaa !21
  %182 = getelementptr inbounds nuw i8, ptr %180, i64 2
  %183 = load i16, ptr %182, align 2, !tbaa !24
  %184 = sitofp i16 %181 to float
  %185 = sitofp i16 %183 to float
  %186 = fmul float %164, %185
  %187 = tail call float @llvm.fmuladd.f32(float %166, float %184, float %186)
  %188 = fadd float %80, %187
  %189 = fmul float %169, %188
  %190 = fptosi float %189 to i16
  store i16 %190, ptr %180, align 2, !tbaa !21
  %191 = fmul float %163, %185
  %192 = tail call float @llvm.fmuladd.f32(float %165, float %184, float %191)
  %193 = fadd float %79, %192
  %194 = fmul float %172, %193
  %195 = fptosi float %194 to i16
  store i16 %195, ptr %182, align 2, !tbaa !24
  %196 = getelementptr inbounds nuw i8, ptr %180, i64 4
  %197 = load i16, ptr %196, align 2, !tbaa !25
  %198 = getelementptr inbounds nuw i8, ptr %180, i64 6
  %199 = load i16, ptr %198, align 2, !tbaa !26
  %200 = sitofp i16 %197 to float
  %201 = sitofp i16 %199 to float
  %202 = fmul float %164, %201
  %203 = tail call float @llvm.fmuladd.f32(float %166, float %200, float %202)
  %204 = fadd float %80, %203
  %205 = fmul float %169, %204
  %206 = fptosi float %205 to i16
  store i16 %206, ptr %196, align 2, !tbaa !25
  %207 = fmul float %163, %201
  %208 = tail call float @llvm.fmuladd.f32(float %165, float %200, float %207)
  %209 = fadd float %79, %208
  %210 = fmul float %172, %209
  %211 = fptosi float %210 to i16
  store i16 %211, ptr %198, align 2, !tbaa !26
  %212 = add nuw nsw i64 %179, 1
  %213 = icmp eq i64 %212, %177
  br i1 %213, label %216, label %178, !llvm.loop !27

214:                                              ; preds = %161
  %215 = and i32 %37, 32
  br label %216

216:                                              ; preds = %178, %214
  %217 = phi i32 [ %215, %214 ], [ %31, %178 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  br i1 %174, label %30, label %232, !llvm.loop !28

218:                                              ; preds = %30, %26
  store ptr null, ptr %2, align 8, !tbaa !20
  br label %232

219:                                              ; preds = %3
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #26
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %4, i8 0, i64 56, i1 false)
  store i32 1, ptr %4, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %5) #26
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %5, i8 0, i64 56, i1 false)
  %220 = call fastcc i32 @stbtt__run_charstring(ptr noundef readonly %0, i32 noundef %1, ptr noundef %4) #25
  %221 = icmp eq i32 %220, 0
  br i1 %221, label %229, label %222

222:                                              ; preds = %219
  store ptr null, ptr %2, align 8, !tbaa !20
  %223 = getelementptr inbounds nuw i8, ptr %5, i64 40
  store ptr null, ptr %223, align 8, !tbaa !29
  %224 = call fastcc i32 @stbtt__run_charstring(ptr noundef readonly %0, i32 noundef %1, ptr noundef %5) #25
  %225 = icmp eq i32 %224, 0
  br i1 %225, label %229, label %226

226:                                              ; preds = %222
  %227 = getelementptr inbounds nuw i8, ptr %5, i64 48
  %228 = load i32, ptr %227, align 8, !tbaa !32
  br label %230

229:                                              ; preds = %222, %219
  store ptr null, ptr %2, align 8, !tbaa !20
  br label %230

230:                                              ; preds = %226, %229
  %231 = phi i32 [ %228, %226 ], [ 0, %229 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #26
  br label %232

232:                                              ; preds = %216, %15, %218, %10, %230
  %233 = phi i32 [ %231, %230 ], [ 0, %15 ], [ 0, %10 ], [ 0, %218 ], [ 0, %216 ]
  ret i32 %233
}

; Function Attrs: nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local range(i32 0, 2) i32 @stbtt_GetGlyphBox(ptr noundef readonly captures(none) %0, i32 noundef %1, ptr noundef writeonly captures(address_is_null) %2, ptr noundef writeonly captures(address_is_null) %3, ptr noundef writeonly captures(address_is_null) %4, ptr noundef writeonly captures(address_is_null) %5) local_unnamed_addr #3 {
  %7 = alloca %struct.stbtt__csctx, align 8
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 76
  %9 = load i32, ptr %8, align 4, !tbaa !19
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %41, label %11

11:                                               ; preds = %6
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #26
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %7, i8 0, i64 56, i1 false)
  store i32 1, ptr %7, align 8
  %12 = call fastcc i32 @stbtt__run_charstring(ptr noundef readonly %0, i32 noundef %1, ptr noundef %7) #25
  %13 = icmp eq ptr %2, null
  br i1 %13, label %19, label %14

14:                                               ; preds = %11
  %15 = icmp eq i32 %12, 0
  %16 = getelementptr inbounds nuw i8, ptr %7, i64 24
  %17 = load i32, ptr %16, align 8
  %18 = select i1 %15, i32 0, i32 %17
  store i32 %18, ptr %2, align 4, !tbaa !4
  br label %19

19:                                               ; preds = %14, %11
  %20 = icmp eq ptr %3, null
  br i1 %20, label %26, label %21

21:                                               ; preds = %19
  %22 = icmp eq i32 %12, 0
  %23 = getelementptr inbounds nuw i8, ptr %7, i64 32
  %24 = load i32, ptr %23, align 8
  %25 = select i1 %22, i32 0, i32 %24
  store i32 %25, ptr %3, align 4, !tbaa !4
  br label %26

26:                                               ; preds = %21, %19
  %27 = icmp eq ptr %4, null
  br i1 %27, label %33, label %28

28:                                               ; preds = %26
  %29 = icmp eq i32 %12, 0
  %30 = getelementptr inbounds nuw i8, ptr %7, i64 28
  %31 = load i32, ptr %30, align 4
  %32 = select i1 %29, i32 0, i32 %31
  store i32 %32, ptr %4, align 4, !tbaa !4
  br label %33

33:                                               ; preds = %28, %26
  %34 = icmp eq ptr %5, null
  br i1 %34, label %40, label %35

35:                                               ; preds = %33
  %36 = icmp eq i32 %12, 0
  %37 = getelementptr inbounds nuw i8, ptr %7, i64 36
  %38 = load i32, ptr %37, align 4
  %39 = select i1 %36, i32 0, i32 %38
  store i32 %39, ptr %5, align 4, !tbaa !4
  br label %40

40:                                               ; preds = %33, %35
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #26
  br label %108

41:                                               ; preds = %6
  %42 = tail call fastcc i32 @stbtt__GetGlyfOffset(ptr noundef %0, i32 noundef %1) #25
  %43 = icmp sgt i32 %42, -1
  br i1 %43, label %44, label %108

44:                                               ; preds = %41
  %45 = icmp eq ptr %2, null
  br i1 %45, label %60, label %46

46:                                               ; preds = %44
  %47 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %48 = load ptr, ptr %47, align 8, !tbaa !8
  %49 = zext nneg i32 %42 to i64
  %50 = getelementptr inbounds nuw i8, ptr %48, i64 %49
  %51 = getelementptr inbounds nuw i8, ptr %50, i64 2
  %52 = load i8, ptr %51, align 1, !tbaa !14
  %53 = zext i8 %52 to i16
  %54 = shl nuw i16 %53, 8
  %55 = getelementptr inbounds nuw i8, ptr %50, i64 3
  %56 = load i8, ptr %55, align 1, !tbaa !14
  %57 = zext i8 %56 to i16
  %58 = or disjoint i16 %54, %57
  %59 = sext i16 %58 to i32
  store i32 %59, ptr %2, align 4, !tbaa !4
  br label %60

60:                                               ; preds = %46, %44
  %61 = icmp eq ptr %3, null
  br i1 %61, label %76, label %62

62:                                               ; preds = %60
  %63 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %64 = load ptr, ptr %63, align 8, !tbaa !8
  %65 = zext nneg i32 %42 to i64
  %66 = getelementptr inbounds nuw i8, ptr %64, i64 %65
  %67 = getelementptr inbounds nuw i8, ptr %66, i64 4
  %68 = load i8, ptr %67, align 1, !tbaa !14
  %69 = zext i8 %68 to i16
  %70 = shl nuw i16 %69, 8
  %71 = getelementptr inbounds nuw i8, ptr %66, i64 5
  %72 = load i8, ptr %71, align 1, !tbaa !14
  %73 = zext i8 %72 to i16
  %74 = or disjoint i16 %70, %73
  %75 = sext i16 %74 to i32
  store i32 %75, ptr %3, align 4, !tbaa !4
  br label %76

76:                                               ; preds = %62, %60
  %77 = icmp eq ptr %4, null
  br i1 %77, label %92, label %78

78:                                               ; preds = %76
  %79 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %80 = load ptr, ptr %79, align 8, !tbaa !8
  %81 = zext nneg i32 %42 to i64
  %82 = getelementptr inbounds nuw i8, ptr %80, i64 %81
  %83 = getelementptr inbounds nuw i8, ptr %82, i64 6
  %84 = load i8, ptr %83, align 1, !tbaa !14
  %85 = zext i8 %84 to i16
  %86 = shl nuw i16 %85, 8
  %87 = getelementptr inbounds nuw i8, ptr %82, i64 7
  %88 = load i8, ptr %87, align 1, !tbaa !14
  %89 = zext i8 %88 to i16
  %90 = or disjoint i16 %86, %89
  %91 = sext i16 %90 to i32
  store i32 %91, ptr %4, align 4, !tbaa !4
  br label %92

92:                                               ; preds = %78, %76
  %93 = icmp eq ptr %5, null
  br i1 %93, label %108, label %94

94:                                               ; preds = %92
  %95 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %96 = load ptr, ptr %95, align 8, !tbaa !8
  %97 = zext nneg i32 %42 to i64
  %98 = getelementptr inbounds nuw i8, ptr %96, i64 %97
  %99 = getelementptr inbounds nuw i8, ptr %98, i64 8
  %100 = load i8, ptr %99, align 1, !tbaa !14
  %101 = zext i8 %100 to i16
  %102 = shl nuw i16 %101, 8
  %103 = getelementptr inbounds nuw i8, ptr %98, i64 9
  %104 = load i8, ptr %103, align 1, !tbaa !14
  %105 = zext i8 %104 to i16
  %106 = or disjoint i16 %102, %105
  %107 = sext i16 %106 to i32
  store i32 %107, ptr %5, align 4, !tbaa !4
  br label %108

108:                                              ; preds = %40, %92, %94, %41
  %109 = phi i32 [ 0, %41 ], [ 1, %94 ], [ 1, %92 ], [ 1, %40 ]
  ret i32 %109
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define internal fastcc i32 @stbtt__GetGlyfOffset(ptr noundef readonly captures(none) %0, i32 noundef %1) unnamed_addr #4 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 20
  %4 = load i32, ptr %3, align 4, !tbaa !33
  %5 = icmp slt i32 %1, %4
  br i1 %5, label %6, label %86

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 60
  %8 = load i32, ptr %7, align 4, !tbaa !34
  %9 = icmp sgt i32 %8, 1
  br i1 %9, label %86, label %10

10:                                               ; preds = %6
  %11 = icmp eq i32 %8, 0
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %13 = load i32, ptr %12, align 8, !tbaa !35
  %14 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %15 = load ptr, ptr %14, align 8, !tbaa !8
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %17 = load i32, ptr %16, align 8, !tbaa !36
  %18 = sext i32 %17 to i64
  %19 = getelementptr inbounds i8, ptr %15, i64 %18
  br i1 %11, label %20, label %41

20:                                               ; preds = %10
  %21 = shl nsw i32 %1, 1
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds i8, ptr %19, i64 %22
  %24 = load i8, ptr %23, align 1, !tbaa !14
  %25 = zext i8 %24 to i32
  %26 = getelementptr inbounds nuw i8, ptr %23, i64 1
  %27 = load i8, ptr %26, align 1, !tbaa !14
  %28 = zext i8 %27 to i32
  %29 = shl nuw nsw i32 %25, 9
  %30 = shl nuw nsw i32 %28, 1
  %31 = or disjoint i32 %30, %29
  %32 = getelementptr inbounds nuw i8, ptr %23, i64 2
  %33 = load i8, ptr %32, align 1, !tbaa !14
  %34 = zext i8 %33 to i32
  %35 = getelementptr inbounds nuw i8, ptr %23, i64 3
  %36 = load i8, ptr %35, align 1, !tbaa !14
  %37 = zext i8 %36 to i32
  %38 = shl nuw nsw i32 %34, 9
  %39 = shl nuw nsw i32 %37, 1
  %40 = or disjoint i32 %39, %38
  br label %80

41:                                               ; preds = %10
  %42 = shl nsw i32 %1, 2
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds i8, ptr %19, i64 %43
  %45 = load i8, ptr %44, align 1, !tbaa !14
  %46 = zext i8 %45 to i32
  %47 = shl nuw i32 %46, 24
  %48 = getelementptr inbounds nuw i8, ptr %44, i64 1
  %49 = load i8, ptr %48, align 1, !tbaa !14
  %50 = zext i8 %49 to i32
  %51 = shl nuw nsw i32 %50, 16
  %52 = or disjoint i32 %51, %47
  %53 = getelementptr inbounds nuw i8, ptr %44, i64 2
  %54 = load i8, ptr %53, align 1, !tbaa !14
  %55 = zext i8 %54 to i32
  %56 = shl nuw nsw i32 %55, 8
  %57 = or disjoint i32 %52, %56
  %58 = getelementptr inbounds nuw i8, ptr %44, i64 3
  %59 = load i8, ptr %58, align 1, !tbaa !14
  %60 = zext i8 %59 to i32
  %61 = or disjoint i32 %57, %60
  %62 = getelementptr inbounds nuw i8, ptr %44, i64 4
  %63 = load i8, ptr %62, align 1, !tbaa !14
  %64 = zext i8 %63 to i32
  %65 = shl nuw i32 %64, 24
  %66 = getelementptr inbounds nuw i8, ptr %44, i64 5
  %67 = load i8, ptr %66, align 1, !tbaa !14
  %68 = zext i8 %67 to i32
  %69 = shl nuw nsw i32 %68, 16
  %70 = or disjoint i32 %69, %65
  %71 = getelementptr inbounds nuw i8, ptr %44, i64 6
  %72 = load i8, ptr %71, align 1, !tbaa !14
  %73 = zext i8 %72 to i32
  %74 = shl nuw nsw i32 %73, 8
  %75 = or disjoint i32 %70, %74
  %76 = getelementptr inbounds nuw i8, ptr %44, i64 7
  %77 = load i8, ptr %76, align 1, !tbaa !14
  %78 = zext i8 %77 to i32
  %79 = or disjoint i32 %75, %78
  br label %80

80:                                               ; preds = %41, %20
  %81 = phi i32 [ %79, %41 ], [ %40, %20 ]
  %82 = phi i32 [ %61, %41 ], [ %31, %20 ]
  %83 = add i32 %82, %13
  %84 = icmp eq i32 %82, %81
  %85 = select i1 %84, i32 -1, i32 %83
  br label %86

86:                                               ; preds = %6, %2, %80
  %87 = phi i32 [ %85, %80 ], [ -1, %2 ], [ -1, %6 ]
  ret i32 %87
}

; Function Attrs: nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local range(i32 0, 2) i32 @stbtt_GetCodepointBox(ptr noundef readonly captures(none) %0, i32 noundef %1, ptr noundef writeonly captures(address_is_null) %2, ptr noundef writeonly captures(address_is_null) %3, ptr noundef writeonly captures(address_is_null) %4, ptr noundef writeonly captures(address_is_null) %5) local_unnamed_addr #3 {
  %7 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %1) #25
  %8 = tail call i32 @stbtt_GetGlyphBox(ptr noundef %0, i32 noundef %7, ptr noundef %2, ptr noundef %3, ptr noundef %4, ptr noundef %5) #25
  ret i32 %8
}

; Function Attrs: nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local range(i32 0, 2) i32 @stbtt_IsGlyphEmpty(ptr noundef readonly captures(none) %0, i32 noundef %1) local_unnamed_addr #3 {
  %3 = alloca %struct.stbtt__csctx, align 8
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 76
  %5 = load i32, ptr %4, align 4, !tbaa !19
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %14, label %7

7:                                                ; preds = %2
  call void @llvm.lifetime.start.p0(ptr nonnull %3) #26
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(56) %3, i8 0, i64 56, i1 false)
  store i32 1, ptr %3, align 8
  %8 = call fastcc i32 @stbtt__run_charstring(ptr noundef readonly %0, i32 noundef %1, ptr noundef %3) #25
  %9 = icmp eq i32 %8, 0
  %10 = getelementptr inbounds nuw i8, ptr %3, i64 48
  %11 = load i32, ptr %10, align 8
  call void @llvm.lifetime.end.p0(ptr nonnull %3) #26
  %12 = icmp eq i32 %11, 0
  %13 = select i1 %9, i1 true, i1 %12
  br label %30

14:                                               ; preds = %2
  %15 = tail call fastcc i32 @stbtt__GetGlyfOffset(ptr noundef %0, i32 noundef %1) #25
  %16 = icmp slt i32 %15, 0
  br i1 %16, label %30, label %17

17:                                               ; preds = %14
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %19 = load ptr, ptr %18, align 8, !tbaa !8
  %20 = zext nneg i32 %15 to i64
  %21 = getelementptr inbounds nuw i8, ptr %19, i64 %20
  %22 = load i8, ptr %21, align 1, !tbaa !14
  %23 = zext i8 %22 to i16
  %24 = shl nuw i16 %23, 8
  %25 = getelementptr inbounds nuw i8, ptr %21, i64 1
  %26 = load i8, ptr %25, align 1, !tbaa !14
  %27 = zext i8 %26 to i16
  %28 = or disjoint i16 %24, %27
  %29 = icmp eq i16 %28, 0
  br label %30

30:                                               ; preds = %14, %17, %7
  %31 = phi i1 [ %13, %7 ], [ %29, %17 ], [ true, %14 ]
  %32 = zext i1 %31 to i32
  ret i32 %32
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_GetGlyphHMetrics(ptr noundef readonly captures(none) %0, i32 noundef %1, ptr noundef writeonly captures(address_is_null) %2, ptr noundef writeonly captures(address_is_null) %3) local_unnamed_addr #5 {
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %6 = load ptr, ptr %5, align 8, !tbaa !8
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %8 = load i32, ptr %7, align 4, !tbaa !37
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds i8, ptr %6, i64 %9
  %11 = getelementptr inbounds nuw i8, ptr %10, i64 34
  %12 = load i8, ptr %11, align 1, !tbaa !14
  %13 = zext i8 %12 to i32
  %14 = shl nuw nsw i32 %13, 8
  %15 = getelementptr inbounds nuw i8, ptr %10, i64 35
  %16 = load i8, ptr %15, align 1, !tbaa !14
  %17 = zext i8 %16 to i32
  %18 = or disjoint i32 %14, %17
  %19 = icmp slt i32 %1, %18
  %20 = icmp eq ptr %2, null
  br i1 %19, label %21, label %50

21:                                               ; preds = %4
  br i1 %20, label %38, label %22

22:                                               ; preds = %21
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %24 = load i32, ptr %23, align 8, !tbaa !38
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds i8, ptr %6, i64 %25
  %27 = shl nsw i32 %1, 2
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds i8, ptr %26, i64 %28
  %30 = load i8, ptr %29, align 1, !tbaa !14
  %31 = zext i8 %30 to i16
  %32 = shl nuw i16 %31, 8
  %33 = getelementptr inbounds nuw i8, ptr %29, i64 1
  %34 = load i8, ptr %33, align 1, !tbaa !14
  %35 = zext i8 %34 to i16
  %36 = or disjoint i16 %32, %35
  %37 = sext i16 %36 to i32
  store i32 %37, ptr %2, align 4, !tbaa !4
  br label %38

38:                                               ; preds = %22, %21
  %39 = icmp eq ptr %3, null
  br i1 %39, label %93, label %40

40:                                               ; preds = %38
  %41 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %42 = load i32, ptr %41, align 8, !tbaa !38
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds i8, ptr %6, i64 %43
  %45 = shl nsw i32 %1, 2
  %46 = sext i32 %45 to i64
  %47 = getelementptr inbounds i8, ptr %44, i64 %46
  %48 = getelementptr inbounds nuw i8, ptr %47, i64 2
  %49 = getelementptr inbounds nuw i8, ptr %47, i64 3
  br label %83

50:                                               ; preds = %4
  br i1 %20, label %68, label %51

51:                                               ; preds = %50
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %53 = load i32, ptr %52, align 8, !tbaa !38
  %54 = sext i32 %53 to i64
  %55 = getelementptr inbounds i8, ptr %6, i64 %54
  %56 = shl nuw nsw i32 %18, 2
  %57 = zext nneg i32 %56 to i64
  %58 = getelementptr i8, ptr %55, i64 %57
  %59 = getelementptr i8, ptr %58, i64 -4
  %60 = load i8, ptr %59, align 1, !tbaa !14
  %61 = zext i8 %60 to i16
  %62 = shl nuw i16 %61, 8
  %63 = getelementptr i8, ptr %58, i64 -3
  %64 = load i8, ptr %63, align 1, !tbaa !14
  %65 = zext i8 %64 to i16
  %66 = or disjoint i16 %62, %65
  %67 = sext i16 %66 to i32
  store i32 %67, ptr %2, align 4, !tbaa !4
  br label %68

68:                                               ; preds = %51, %50
  %69 = icmp eq ptr %3, null
  br i1 %69, label %93, label %70

70:                                               ; preds = %68
  %71 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %72 = load i32, ptr %71, align 8, !tbaa !38
  %73 = sext i32 %72 to i64
  %74 = getelementptr inbounds i8, ptr %6, i64 %73
  %75 = shl nuw nsw i32 %18, 2
  %76 = zext nneg i32 %75 to i64
  %77 = getelementptr inbounds nuw i8, ptr %74, i64 %76
  %78 = sub nsw i32 %1, %18
  %79 = shl nsw i32 %78, 1
  %80 = sext i32 %79 to i64
  %81 = getelementptr inbounds i8, ptr %77, i64 %80
  %82 = getelementptr inbounds nuw i8, ptr %81, i64 1
  br label %83

83:                                               ; preds = %40, %70
  %84 = phi ptr [ %82, %70 ], [ %49, %40 ]
  %85 = phi ptr [ %81, %70 ], [ %48, %40 ]
  %86 = load i8, ptr %85, align 1, !tbaa !14
  %87 = zext i8 %86 to i16
  %88 = shl nuw i16 %87, 8
  %89 = load i8, ptr %84, align 1, !tbaa !14
  %90 = zext i8 %89 to i16
  %91 = or disjoint i16 %88, %90
  %92 = sext i16 %91 to i32
  store i32 %92, ptr %3, align 4, !tbaa !4
  br label %93

93:                                               ; preds = %83, %68, %38
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local range(i32 0, 65536) i32 @stbtt_GetKerningTableLength(ptr noundef readonly captures(none) %0) local_unnamed_addr #4 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load ptr, ptr %2, align 8, !tbaa !8
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 44
  %5 = load i32, ptr %4, align 4, !tbaa !39
  %6 = sext i32 %5 to i64
  %7 = getelementptr inbounds i8, ptr %3, i64 %6
  %8 = icmp eq i32 %5, 0
  br i1 %8, label %38, label %9

9:                                                ; preds = %1
  %10 = getelementptr inbounds nuw i8, ptr %7, i64 2
  %11 = load i8, ptr %10, align 1, !tbaa !14
  %12 = zext i8 %11 to i16
  %13 = shl nuw i16 %12, 8
  %14 = getelementptr inbounds nuw i8, ptr %7, i64 3
  %15 = load i8, ptr %14, align 1, !tbaa !14
  %16 = zext i8 %15 to i16
  %17 = or disjoint i16 %13, %16
  %18 = icmp eq i16 %17, 0
  br i1 %18, label %38, label %19

19:                                               ; preds = %9
  %20 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %21 = load i8, ptr %20, align 1, !tbaa !14
  %22 = zext i8 %21 to i16
  %23 = shl nuw i16 %22, 8
  %24 = getelementptr inbounds nuw i8, ptr %7, i64 9
  %25 = load i8, ptr %24, align 1, !tbaa !14
  %26 = zext i8 %25 to i16
  %27 = or disjoint i16 %23, %26
  %28 = icmp eq i16 %27, 1
  br i1 %28, label %29, label %38

29:                                               ; preds = %19
  %30 = getelementptr inbounds nuw i8, ptr %7, i64 10
  %31 = load i8, ptr %30, align 1, !tbaa !14
  %32 = zext i8 %31 to i32
  %33 = shl nuw nsw i32 %32, 8
  %34 = getelementptr inbounds nuw i8, ptr %7, i64 11
  %35 = load i8, ptr %34, align 1, !tbaa !14
  %36 = zext i8 %35 to i32
  %37 = or disjoint i32 %33, %36
  br label %38

38:                                               ; preds = %19, %9, %1, %29
  %39 = phi i32 [ 0, %1 ], [ 0, %9 ], [ %37, %29 ], [ 0, %19 ]
  ret i32 %39
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local range(i32 -2147483648, 65536) i32 @stbtt_GetKerningTable(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(none) %1, i32 noundef %2) local_unnamed_addr #6 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %5 = load ptr, ptr %4, align 8, !tbaa !8
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 44
  %7 = load i32, ptr %6, align 4, !tbaa !39
  %8 = sext i32 %7 to i64
  %9 = getelementptr inbounds i8, ptr %5, i64 %8
  %10 = icmp eq i32 %7, 0
  br i1 %10, label %80, label %11

11:                                               ; preds = %3
  %12 = getelementptr inbounds nuw i8, ptr %9, i64 2
  %13 = load i8, ptr %12, align 1, !tbaa !14
  %14 = zext i8 %13 to i16
  %15 = shl nuw i16 %14, 8
  %16 = getelementptr inbounds nuw i8, ptr %9, i64 3
  %17 = load i8, ptr %16, align 1, !tbaa !14
  %18 = zext i8 %17 to i16
  %19 = or disjoint i16 %15, %18
  %20 = icmp eq i16 %19, 0
  br i1 %20, label %80, label %21

21:                                               ; preds = %11
  %22 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %23 = load i8, ptr %22, align 1, !tbaa !14
  %24 = zext i8 %23 to i16
  %25 = shl nuw i16 %24, 8
  %26 = getelementptr inbounds nuw i8, ptr %9, i64 9
  %27 = load i8, ptr %26, align 1, !tbaa !14
  %28 = zext i8 %27 to i16
  %29 = or disjoint i16 %25, %28
  %30 = icmp eq i16 %29, 1
  br i1 %30, label %31, label %80

31:                                               ; preds = %21
  %32 = getelementptr inbounds nuw i8, ptr %9, i64 10
  %33 = load i8, ptr %32, align 1, !tbaa !14
  %34 = zext i8 %33 to i32
  %35 = shl nuw nsw i32 %34, 8
  %36 = getelementptr inbounds nuw i8, ptr %9, i64 11
  %37 = load i8, ptr %36, align 1, !tbaa !14
  %38 = zext i8 %37 to i32
  %39 = or disjoint i32 %35, %38
  %40 = tail call i32 @llvm.smin.i32(i32 %2, i32 %39)
  %41 = icmp sgt i32 %40, 0
  br i1 %41, label %42, label %80

42:                                               ; preds = %31
  %43 = getelementptr inbounds nuw i8, ptr %9, i64 18
  %44 = getelementptr inbounds nuw i8, ptr %9, i64 20
  %45 = getelementptr inbounds nuw i8, ptr %9, i64 22
  %46 = zext nneg i32 %40 to i64
  br label %47

47:                                               ; preds = %42, %47
  %48 = phi i64 [ 0, %42 ], [ %78, %47 ]
  %49 = mul nuw nsw i64 %48, 6
  %50 = getelementptr inbounds nuw i8, ptr %43, i64 %49
  %51 = load i8, ptr %50, align 1, !tbaa !14
  %52 = zext i8 %51 to i32
  %53 = shl nuw nsw i32 %52, 8
  %54 = getelementptr inbounds nuw i8, ptr %50, i64 1
  %55 = load i8, ptr %54, align 1, !tbaa !14
  %56 = zext i8 %55 to i32
  %57 = or disjoint i32 %53, %56
  %58 = getelementptr inbounds nuw %struct.stbtt_kerningentry, ptr %1, i64 %48
  store i32 %57, ptr %58, align 4, !tbaa !40
  %59 = getelementptr inbounds nuw i8, ptr %44, i64 %49
  %60 = load i8, ptr %59, align 1, !tbaa !14
  %61 = zext i8 %60 to i32
  %62 = shl nuw nsw i32 %61, 8
  %63 = getelementptr inbounds nuw i8, ptr %59, i64 1
  %64 = load i8, ptr %63, align 1, !tbaa !14
  %65 = zext i8 %64 to i32
  %66 = or disjoint i32 %62, %65
  %67 = getelementptr inbounds nuw i8, ptr %58, i64 4
  store i32 %66, ptr %67, align 4, !tbaa !42
  %68 = getelementptr inbounds nuw i8, ptr %45, i64 %49
  %69 = load i8, ptr %68, align 1, !tbaa !14
  %70 = zext i8 %69 to i16
  %71 = shl nuw i16 %70, 8
  %72 = getelementptr inbounds nuw i8, ptr %68, i64 1
  %73 = load i8, ptr %72, align 1, !tbaa !14
  %74 = zext i8 %73 to i16
  %75 = or disjoint i16 %71, %74
  %76 = sext i16 %75 to i32
  %77 = getelementptr inbounds nuw i8, ptr %58, i64 8
  store i32 %76, ptr %77, align 4, !tbaa !43
  %78 = add nuw nsw i64 %48, 1
  %79 = icmp eq i64 %78, %46
  br i1 %79, label %80, label %47, !llvm.loop !44

80:                                               ; preds = %47, %31, %21, %11, %3
  %81 = phi i32 [ 0, %3 ], [ 0, %11 ], [ 0, %21 ], [ %40, %31 ], [ %40, %47 ]
  ret i32 %81
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local i32 @stbtt_GetGlyphKernAdvance(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %5 = load i32, ptr %4, align 8, !tbaa !45
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %416, label %7

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %9 = load ptr, ptr %8, align 8, !tbaa !8
  %10 = sext i32 %5 to i64
  %11 = getelementptr inbounds i8, ptr %9, i64 %10
  %12 = load i8, ptr %11, align 1, !tbaa !14
  %13 = zext i8 %12 to i16
  %14 = shl nuw i16 %13, 8
  %15 = getelementptr inbounds nuw i8, ptr %11, i64 1
  %16 = load i8, ptr %15, align 1, !tbaa !14
  %17 = zext i8 %16 to i16
  %18 = or disjoint i16 %14, %17
  %19 = icmp eq i16 %18, 1
  br i1 %19, label %20, label %506

20:                                               ; preds = %7
  %21 = getelementptr inbounds nuw i8, ptr %11, i64 2
  %22 = load i8, ptr %21, align 1, !tbaa !14
  %23 = zext i8 %22 to i16
  %24 = shl nuw i16 %23, 8
  %25 = getelementptr inbounds nuw i8, ptr %11, i64 3
  %26 = load i8, ptr %25, align 1, !tbaa !14
  %27 = zext i8 %26 to i16
  %28 = or disjoint i16 %24, %27
  %29 = icmp eq i16 %28, 0
  br i1 %29, label %30, label %506

30:                                               ; preds = %20
  %31 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %32 = load i8, ptr %31, align 1, !tbaa !14
  %33 = zext i8 %32 to i64
  %34 = shl nuw nsw i64 %33, 8
  %35 = getelementptr inbounds nuw i8, ptr %11, i64 9
  %36 = load i8, ptr %35, align 1, !tbaa !14
  %37 = zext i8 %36 to i64
  %38 = getelementptr inbounds nuw i8, ptr %11, i64 %34
  %39 = getelementptr inbounds nuw i8, ptr %38, i64 %37
  %40 = load i8, ptr %39, align 1, !tbaa !14
  %41 = zext i8 %40 to i32
  %42 = shl nuw nsw i32 %41, 8
  %43 = getelementptr inbounds nuw i8, ptr %39, i64 1
  %44 = load i8, ptr %43, align 1, !tbaa !14
  %45 = zext i8 %44 to i32
  %46 = or disjoint i32 %42, %45
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %506, label %48

48:                                               ; preds = %30
  %49 = getelementptr inbounds nuw i8, ptr %39, i64 2
  %50 = zext nneg i32 %46 to i64
  br label %51

51:                                               ; preds = %413, %48
  %52 = phi i64 [ 0, %48 ], [ %414, %413 ]
  %53 = phi i32 [ undef, %48 ], [ %412, %413 ]
  %54 = shl nuw nsw i64 %52, 1
  %55 = getelementptr inbounds nuw i8, ptr %49, i64 %54
  %56 = load i8, ptr %55, align 1, !tbaa !14
  %57 = zext i8 %56 to i64
  %58 = shl nuw nsw i64 %57, 8
  %59 = getelementptr inbounds nuw i8, ptr %55, i64 1
  %60 = load i8, ptr %59, align 1, !tbaa !14
  %61 = zext i8 %60 to i64
  %62 = getelementptr inbounds nuw i8, ptr %39, i64 %58
  %63 = getelementptr inbounds nuw i8, ptr %62, i64 %61
  %64 = load i8, ptr %63, align 1, !tbaa !14
  %65 = zext i8 %64 to i16
  %66 = shl nuw i16 %65, 8
  %67 = getelementptr inbounds nuw i8, ptr %63, i64 1
  %68 = load i8, ptr %67, align 1, !tbaa !14
  %69 = zext i8 %68 to i16
  %70 = or disjoint i16 %66, %69
  %71 = getelementptr inbounds nuw i8, ptr %63, i64 6
  %72 = icmp eq i16 %70, 2
  br i1 %72, label %73, label %410

73:                                               ; preds = %51
  %74 = getelementptr inbounds nuw i8, ptr %63, i64 5
  %75 = load i8, ptr %74, align 1, !tbaa !14
  %76 = zext i8 %75 to i32
  %77 = getelementptr inbounds nuw i8, ptr %63, i64 4
  %78 = load i8, ptr %77, align 1, !tbaa !14
  %79 = zext i8 %78 to i32
  %80 = shl nuw nsw i32 %79, 8
  %81 = or disjoint i32 %80, %76
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %410, label %83

83:                                               ; preds = %73
  %84 = zext nneg i32 %81 to i64
  br label %85

85:                                               ; preds = %407, %83
  %86 = phi i64 [ 0, %83 ], [ %408, %407 ]
  %87 = phi i32 [ %53, %83 ], [ %406, %407 ]
  %88 = shl nuw nsw i64 %86, 1
  %89 = getelementptr inbounds nuw i8, ptr %71, i64 %88
  %90 = load i8, ptr %89, align 1, !tbaa !14
  %91 = zext i8 %90 to i64
  %92 = shl nuw nsw i64 %91, 8
  %93 = getelementptr inbounds nuw i8, ptr %89, i64 1
  %94 = load i8, ptr %93, align 1, !tbaa !14
  %95 = zext i8 %94 to i64
  %96 = getelementptr inbounds nuw i8, ptr %63, i64 %92
  %97 = getelementptr inbounds nuw i8, ptr %96, i64 %95
  %98 = load i8, ptr %97, align 1, !tbaa !14
  %99 = zext i8 %98 to i16
  %100 = shl nuw i16 %99, 8
  %101 = getelementptr inbounds nuw i8, ptr %97, i64 1
  %102 = load i8, ptr %101, align 1, !tbaa !14
  %103 = zext i8 %102 to i16
  %104 = or disjoint i16 %100, %103
  %105 = getelementptr inbounds nuw i8, ptr %97, i64 2
  %106 = load i8, ptr %105, align 1, !tbaa !14
  %107 = zext i8 %106 to i64
  %108 = shl nuw nsw i64 %107, 8
  %109 = getelementptr inbounds nuw i8, ptr %97, i64 3
  %110 = load i8, ptr %109, align 1, !tbaa !14
  %111 = zext i8 %110 to i64
  %112 = getelementptr inbounds nuw i8, ptr %97, i64 %108
  %113 = getelementptr inbounds nuw i8, ptr %112, i64 %111
  %114 = load i8, ptr %113, align 1, !tbaa !14
  %115 = zext i8 %114 to i16
  %116 = shl nuw i16 %115, 8
  %117 = getelementptr inbounds nuw i8, ptr %113, i64 1
  %118 = load i8, ptr %117, align 1, !tbaa !14
  %119 = zext i8 %118 to i16
  %120 = or disjoint i16 %116, %119
  switch i16 %120, label %227 [
    i16 1, label %121
    i16 2, label %164
  ]

121:                                              ; preds = %85
  %122 = getelementptr inbounds nuw i8, ptr %113, i64 2
  %123 = load i8, ptr %122, align 1, !tbaa !14
  %124 = zext i8 %123 to i32
  %125 = shl nuw nsw i32 %124, 8
  %126 = getelementptr inbounds nuw i8, ptr %113, i64 3
  %127 = load i8, ptr %126, align 1, !tbaa !14
  %128 = zext i8 %127 to i32
  %129 = or disjoint i32 %125, %128
  %130 = add nsw i32 %129, -1
  %131 = getelementptr inbounds nuw i8, ptr %113, i64 4
  br label %132

132:                                              ; preds = %157, %121
  %133 = phi i32 [ %130, %121 ], [ %159, %157 ]
  %134 = phi i32 [ 0, %121 ], [ %160, %157 ]
  %135 = phi i32 [ undef, %121 ], [ %161, %157 ]
  %136 = icmp sgt i32 %134, %133
  br i1 %136, label %162, label %137

137:                                              ; preds = %132
  %138 = add nsw i32 %134, %133
  %139 = ashr i32 %138, 1
  %140 = and i32 %138, -2
  %141 = sext i32 %140 to i64
  %142 = getelementptr inbounds i8, ptr %131, i64 %141
  %143 = load i8, ptr %142, align 1, !tbaa !14
  %144 = zext i8 %143 to i32
  %145 = shl nuw nsw i32 %144, 8
  %146 = getelementptr inbounds nuw i8, ptr %142, i64 1
  %147 = load i8, ptr %146, align 1, !tbaa !14
  %148 = zext i8 %147 to i32
  %149 = or disjoint i32 %145, %148
  %150 = icmp slt i32 %1, %149
  br i1 %150, label %151, label %153

151:                                              ; preds = %137
  %152 = add nsw i32 %139, -1
  br label %157

153:                                              ; preds = %137
  %154 = icmp sgt i32 %1, %149
  br i1 %154, label %155, label %157

155:                                              ; preds = %153
  %156 = add nsw i32 %139, 1
  br label %157

157:                                              ; preds = %155, %153, %151
  %158 = phi i1 [ false, %153 ], [ true, %155 ], [ true, %151 ]
  %159 = phi i32 [ %133, %153 ], [ %133, %155 ], [ %152, %151 ]
  %160 = phi i32 [ %134, %153 ], [ %156, %155 ], [ %134, %151 ]
  %161 = phi i32 [ %139, %153 ], [ %135, %155 ], [ %135, %151 ]
  br i1 %158, label %132, label %162, !llvm.loop !46

162:                                              ; preds = %157, %132
  %163 = phi i32 [ %161, %157 ], [ %135, %132 ]
  br i1 %136, label %226, label %227

164:                                              ; preds = %85
  %165 = getelementptr inbounds nuw i8, ptr %113, i64 2
  %166 = load i8, ptr %165, align 1, !tbaa !14
  %167 = zext i8 %166 to i32
  %168 = shl nuw nsw i32 %167, 8
  %169 = getelementptr inbounds nuw i8, ptr %113, i64 3
  %170 = load i8, ptr %169, align 1, !tbaa !14
  %171 = zext i8 %170 to i32
  %172 = or disjoint i32 %168, %171
  %173 = getelementptr inbounds nuw i8, ptr %113, i64 4
  %174 = add nsw i32 %172, -1
  br label %175

175:                                              ; preds = %219, %164
  %176 = phi i32 [ %174, %164 ], [ %220, %219 ]
  %177 = phi i32 [ 0, %164 ], [ %221, %219 ]
  %178 = phi i32 [ undef, %164 ], [ %223, %219 ]
  %179 = icmp sgt i32 %177, %176
  br i1 %179, label %224, label %180

180:                                              ; preds = %175
  %181 = add nsw i32 %177, %176
  %182 = ashr i32 %181, 1
  %183 = mul nsw i32 %182, 6
  %184 = sext i32 %183 to i64
  %185 = getelementptr inbounds i8, ptr %173, i64 %184
  %186 = load i8, ptr %185, align 1, !tbaa !14
  %187 = zext i8 %186 to i32
  %188 = shl nuw nsw i32 %187, 8
  %189 = getelementptr inbounds nuw i8, ptr %185, i64 1
  %190 = load i8, ptr %189, align 1, !tbaa !14
  %191 = zext i8 %190 to i32
  %192 = or disjoint i32 %188, %191
  %193 = icmp slt i32 %1, %192
  br i1 %193, label %194, label %196

194:                                              ; preds = %180
  %195 = add nsw i32 %182, -1
  br label %219

196:                                              ; preds = %180
  %197 = getelementptr inbounds nuw i8, ptr %185, i64 2
  %198 = load i8, ptr %197, align 1, !tbaa !14
  %199 = zext i8 %198 to i32
  %200 = shl nuw nsw i32 %199, 8
  %201 = getelementptr inbounds nuw i8, ptr %185, i64 3
  %202 = load i8, ptr %201, align 1, !tbaa !14
  %203 = zext i8 %202 to i32
  %204 = or disjoint i32 %200, %203
  %205 = icmp sgt i32 %1, %204
  br i1 %205, label %206, label %208

206:                                              ; preds = %196
  %207 = add nsw i32 %182, 1
  br label %219

208:                                              ; preds = %196
  %209 = getelementptr inbounds nuw i8, ptr %185, i64 4
  %210 = load i8, ptr %209, align 1, !tbaa !14
  %211 = zext i8 %210 to i32
  %212 = shl nuw nsw i32 %211, 8
  %213 = getelementptr inbounds nuw i8, ptr %185, i64 5
  %214 = load i8, ptr %213, align 1, !tbaa !14
  %215 = zext i8 %214 to i32
  %216 = or disjoint i32 %212, %215
  %217 = sub nsw i32 %1, %192
  %218 = add nsw i32 %217, %216
  br label %219

219:                                              ; preds = %208, %206, %194
  %220 = phi i32 [ %176, %208 ], [ %195, %194 ], [ %176, %206 ]
  %221 = phi i32 [ %177, %208 ], [ %177, %194 ], [ %207, %206 ]
  %222 = phi i1 [ false, %208 ], [ true, %194 ], [ true, %206 ]
  %223 = phi i32 [ %218, %208 ], [ %178, %194 ], [ %178, %206 ]
  br i1 %222, label %175, label %224, !llvm.loop !47

224:                                              ; preds = %219, %175
  %225 = phi i32 [ %223, %219 ], [ %178, %175 ]
  br i1 %179, label %226, label %227

226:                                              ; preds = %224, %162
  br label %227

227:                                              ; preds = %226, %224, %162, %85
  %228 = phi i32 [ %225, %224 ], [ -1, %226 ], [ %163, %162 ], [ -1, %85 ]
  %229 = icmp eq i32 %228, -1
  br i1 %229, label %404, label %230

230:                                              ; preds = %227
  switch i16 %104, label %404 [
    i16 1, label %231
    i16 2, label %323
  ]

231:                                              ; preds = %230
  %232 = getelementptr inbounds nuw i8, ptr %97, i64 4
  %233 = load i8, ptr %232, align 1, !tbaa !14
  %234 = zext i8 %233 to i16
  %235 = shl nuw i16 %234, 8
  %236 = getelementptr inbounds nuw i8, ptr %97, i64 5
  %237 = load i8, ptr %236, align 1, !tbaa !14
  %238 = zext i8 %237 to i16
  %239 = or disjoint i16 %235, %238
  %240 = getelementptr inbounds nuw i8, ptr %97, i64 6
  %241 = load i8, ptr %240, align 1, !tbaa !14
  %242 = zext i8 %241 to i16
  %243 = shl nuw i16 %242, 8
  %244 = getelementptr inbounds nuw i8, ptr %97, i64 7
  %245 = load i8, ptr %244, align 1, !tbaa !14
  %246 = zext i8 %245 to i16
  %247 = or disjoint i16 %243, %246
  %248 = icmp eq i16 %239, 4
  %249 = icmp eq i16 %247, 0
  %250 = select i1 %248, i1 %249, i1 false
  br i1 %250, label %251, label %404

251:                                              ; preds = %231
  %252 = getelementptr inbounds nuw i8, ptr %97, i64 8
  %253 = load i8, ptr %252, align 1, !tbaa !14
  %254 = zext i8 %253 to i32
  %255 = shl nuw nsw i32 %254, 8
  %256 = getelementptr inbounds nuw i8, ptr %97, i64 9
  %257 = load i8, ptr %256, align 1, !tbaa !14
  %258 = zext i8 %257 to i32
  %259 = or disjoint i32 %255, %258
  %260 = getelementptr inbounds nuw i8, ptr %97, i64 10
  %261 = shl nsw i32 %228, 1
  %262 = sext i32 %261 to i64
  %263 = getelementptr inbounds i8, ptr %260, i64 %262
  %264 = load i8, ptr %263, align 1, !tbaa !14
  %265 = zext i8 %264 to i64
  %266 = shl nuw nsw i64 %265, 8
  %267 = getelementptr inbounds nuw i8, ptr %263, i64 1
  %268 = load i8, ptr %267, align 1, !tbaa !14
  %269 = zext i8 %268 to i64
  %270 = getelementptr inbounds nuw i8, ptr %97, i64 %266
  %271 = getelementptr inbounds nuw i8, ptr %270, i64 %269
  %272 = getelementptr inbounds nuw i8, ptr %271, i64 2
  %273 = icmp slt i32 %228, %259
  br i1 %273, label %274, label %404

274:                                              ; preds = %251
  %275 = load i8, ptr %271, align 1, !tbaa !14
  %276 = zext i8 %275 to i32
  %277 = shl nuw nsw i32 %276, 8
  %278 = getelementptr inbounds nuw i8, ptr %271, i64 1
  %279 = load i8, ptr %278, align 1, !tbaa !14
  %280 = zext i8 %279 to i32
  %281 = or disjoint i32 %277, %280
  %282 = add nsw i32 %281, -1
  br label %283

283:                                              ; preds = %318, %274
  %284 = phi i32 [ %282, %274 ], [ %319, %318 ]
  %285 = phi i32 [ 0, %274 ], [ %320, %318 ]
  %286 = phi i32 [ %87, %274 ], [ %322, %318 ]
  %287 = icmp sgt i32 %285, %284
  br i1 %287, label %404, label %288

288:                                              ; preds = %283
  %289 = add nsw i32 %285, %284
  %290 = ashr i32 %289, 1
  %291 = shl nsw i32 %290, 2
  %292 = sext i32 %291 to i64
  %293 = getelementptr inbounds i8, ptr %272, i64 %292
  %294 = load i8, ptr %293, align 1, !tbaa !14
  %295 = zext i8 %294 to i32
  %296 = shl nuw nsw i32 %295, 8
  %297 = getelementptr inbounds nuw i8, ptr %293, i64 1
  %298 = load i8, ptr %297, align 1, !tbaa !14
  %299 = zext i8 %298 to i32
  %300 = or disjoint i32 %296, %299
  %301 = icmp slt i32 %2, %300
  br i1 %301, label %302, label %304

302:                                              ; preds = %288
  %303 = add nsw i32 %290, -1
  br label %318

304:                                              ; preds = %288
  %305 = icmp sgt i32 %2, %300
  br i1 %305, label %306, label %308

306:                                              ; preds = %304
  %307 = add nsw i32 %290, 1
  br label %318

308:                                              ; preds = %304
  %309 = getelementptr inbounds nuw i8, ptr %293, i64 2
  %310 = load i8, ptr %309, align 1, !tbaa !14
  %311 = zext i8 %310 to i16
  %312 = shl nuw i16 %311, 8
  %313 = getelementptr inbounds nuw i8, ptr %293, i64 3
  %314 = load i8, ptr %313, align 1, !tbaa !14
  %315 = zext i8 %314 to i16
  %316 = or disjoint i16 %312, %315
  %317 = sext i16 %316 to i32
  br label %318

318:                                              ; preds = %308, %306, %302
  %319 = phi i32 [ %284, %308 ], [ %303, %302 ], [ %284, %306 ]
  %320 = phi i32 [ %285, %308 ], [ %285, %302 ], [ %307, %306 ]
  %321 = phi i1 [ false, %308 ], [ true, %302 ], [ true, %306 ]
  %322 = phi i32 [ %317, %308 ], [ %286, %302 ], [ %286, %306 ]
  br i1 %321, label %283, label %404, !llvm.loop !48

323:                                              ; preds = %230
  %324 = getelementptr inbounds nuw i8, ptr %97, i64 4
  %325 = load i8, ptr %324, align 1, !tbaa !14
  %326 = zext i8 %325 to i16
  %327 = shl nuw i16 %326, 8
  %328 = getelementptr inbounds nuw i8, ptr %97, i64 5
  %329 = load i8, ptr %328, align 1, !tbaa !14
  %330 = zext i8 %329 to i16
  %331 = or disjoint i16 %327, %330
  %332 = getelementptr inbounds nuw i8, ptr %97, i64 6
  %333 = load i8, ptr %332, align 1, !tbaa !14
  %334 = zext i8 %333 to i16
  %335 = shl nuw i16 %334, 8
  %336 = getelementptr inbounds nuw i8, ptr %97, i64 7
  %337 = load i8, ptr %336, align 1, !tbaa !14
  %338 = zext i8 %337 to i16
  %339 = or disjoint i16 %335, %338
  %340 = icmp eq i16 %331, 4
  %341 = icmp eq i16 %339, 0
  %342 = select i1 %340, i1 %341, i1 false
  br i1 %342, label %343, label %404

343:                                              ; preds = %323
  %344 = getelementptr inbounds nuw i8, ptr %97, i64 8
  %345 = load i8, ptr %344, align 1, !tbaa !14
  %346 = zext i8 %345 to i64
  %347 = shl nuw nsw i64 %346, 8
  %348 = getelementptr inbounds nuw i8, ptr %97, i64 9
  %349 = load i8, ptr %348, align 1, !tbaa !14
  %350 = zext i8 %349 to i64
  %351 = getelementptr inbounds nuw i8, ptr %97, i64 10
  %352 = load i8, ptr %351, align 1, !tbaa !14
  %353 = zext i8 %352 to i64
  %354 = shl nuw nsw i64 %353, 8
  %355 = getelementptr inbounds nuw i8, ptr %97, i64 11
  %356 = load i8, ptr %355, align 1, !tbaa !14
  %357 = zext i8 %356 to i64
  %358 = getelementptr inbounds nuw i8, ptr %97, i64 %347
  %359 = getelementptr inbounds nuw i8, ptr %358, i64 %350
  %360 = tail call fastcc i32 @stbtt__GetGlyphClass(ptr noundef nonnull %359, i32 noundef %1) #25
  %361 = getelementptr inbounds nuw i8, ptr %97, i64 %354
  %362 = getelementptr inbounds nuw i8, ptr %361, i64 %357
  %363 = tail call fastcc i32 @stbtt__GetGlyphClass(ptr noundef nonnull %362, i32 noundef %2) #25
  %364 = getelementptr inbounds nuw i8, ptr %97, i64 12
  %365 = load i8, ptr %364, align 1, !tbaa !14
  %366 = zext i8 %365 to i32
  %367 = shl nuw nsw i32 %366, 8
  %368 = getelementptr inbounds nuw i8, ptr %97, i64 13
  %369 = load i8, ptr %368, align 1, !tbaa !14
  %370 = zext i8 %369 to i32
  %371 = or disjoint i32 %367, %370
  %372 = icmp slt i32 %360, 0
  %373 = icmp sge i32 %360, %371
  %374 = select i1 %372, i1 true, i1 %373
  %375 = icmp slt i32 %363, 0
  %376 = select i1 %374, i1 true, i1 %375
  br i1 %376, label %404, label %377

377:                                              ; preds = %343
  %378 = getelementptr inbounds nuw i8, ptr %97, i64 14
  %379 = load i8, ptr %378, align 1, !tbaa !14
  %380 = zext i8 %379 to i32
  %381 = shl nuw nsw i32 %380, 8
  %382 = getelementptr inbounds nuw i8, ptr %97, i64 15
  %383 = load i8, ptr %382, align 1, !tbaa !14
  %384 = zext i8 %383 to i32
  %385 = or disjoint i32 %381, %384
  %386 = icmp slt i32 %363, %385
  br i1 %386, label %387, label %404

387:                                              ; preds = %377
  %388 = getelementptr inbounds nuw i8, ptr %97, i64 16
  %389 = shl nuw nsw i32 %360, 1
  %390 = mul i32 %389, %385
  %391 = zext nneg i32 %390 to i64
  %392 = getelementptr inbounds nuw i8, ptr %388, i64 %391
  %393 = shl nuw nsw i32 %363, 1
  %394 = zext nneg i32 %393 to i64
  %395 = getelementptr inbounds nuw i8, ptr %392, i64 %394
  %396 = load i8, ptr %395, align 1, !tbaa !14
  %397 = zext i8 %396 to i16
  %398 = shl nuw i16 %397, 8
  %399 = getelementptr inbounds nuw i8, ptr %395, i64 1
  %400 = load i8, ptr %399, align 1, !tbaa !14
  %401 = zext i8 %400 to i16
  %402 = or disjoint i16 %398, %401
  %403 = sext i16 %402 to i32
  br label %404

404:                                              ; preds = %318, %283, %387, %377, %343, %323, %251, %231, %230, %227
  %405 = phi i32 [ 7, %227 ], [ 1, %230 ], [ 1, %377 ], [ 1, %323 ], [ 1, %387 ], [ 1, %343 ], [ 1, %231 ], [ 1, %251 ], [ 0, %283 ], [ 1, %318 ]
  %406 = phi i32 [ %87, %227 ], [ 0, %230 ], [ 0, %377 ], [ 0, %323 ], [ %403, %387 ], [ 0, %343 ], [ 0, %231 ], [ 0, %251 ], [ %286, %283 ], [ %322, %318 ]
  switch i32 %405, label %410 [
    i32 0, label %407
    i32 7, label %407
  ]

407:                                              ; preds = %404, %404
  %408 = add nuw nsw i64 %86, 1
  %409 = icmp eq i64 %408, %84
  br i1 %409, label %410, label %85, !llvm.loop !49

410:                                              ; preds = %407, %404, %73, %51
  %411 = phi i32 [ 4, %51 ], [ 0, %73 ], [ 0, %407 ], [ %405, %404 ]
  %412 = phi i32 [ %53, %51 ], [ %53, %73 ], [ %406, %404 ], [ %406, %407 ]
  switch i32 %411, label %506 [
    i32 0, label %413
    i32 4, label %413
  ]

413:                                              ; preds = %410, %410
  %414 = add nuw nsw i64 %52, 1
  %415 = icmp eq i64 %414, %50
  br i1 %415, label %506, label %51, !llvm.loop !50

416:                                              ; preds = %3
  %417 = getelementptr inbounds nuw i8, ptr %0, i64 44
  %418 = load i32, ptr %417, align 4, !tbaa !39
  %419 = icmp eq i32 %418, 0
  br i1 %419, label %506, label %420

420:                                              ; preds = %416
  %421 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %422 = load ptr, ptr %421, align 8, !tbaa !8
  %423 = sext i32 %418 to i64
  %424 = getelementptr inbounds i8, ptr %422, i64 %423
  %425 = getelementptr inbounds nuw i8, ptr %424, i64 2
  %426 = load i8, ptr %425, align 1, !tbaa !14
  %427 = zext i8 %426 to i16
  %428 = shl nuw i16 %427, 8
  %429 = getelementptr inbounds nuw i8, ptr %424, i64 3
  %430 = load i8, ptr %429, align 1, !tbaa !14
  %431 = zext i8 %430 to i16
  %432 = or disjoint i16 %428, %431
  %433 = icmp eq i16 %432, 0
  br i1 %433, label %506, label %434

434:                                              ; preds = %420
  %435 = getelementptr inbounds nuw i8, ptr %424, i64 8
  %436 = load i8, ptr %435, align 1, !tbaa !14
  %437 = zext i8 %436 to i16
  %438 = shl nuw i16 %437, 8
  %439 = getelementptr inbounds nuw i8, ptr %424, i64 9
  %440 = load i8, ptr %439, align 1, !tbaa !14
  %441 = zext i8 %440 to i16
  %442 = or disjoint i16 %438, %441
  %443 = icmp eq i16 %442, 1
  br i1 %443, label %444, label %506

444:                                              ; preds = %434
  %445 = getelementptr inbounds nuw i8, ptr %424, i64 10
  %446 = load i8, ptr %445, align 1, !tbaa !14
  %447 = zext i8 %446 to i32
  %448 = shl nuw nsw i32 %447, 8
  %449 = getelementptr inbounds nuw i8, ptr %424, i64 11
  %450 = load i8, ptr %449, align 1, !tbaa !14
  %451 = zext i8 %450 to i32
  %452 = or disjoint i32 %448, %451
  %453 = shl i32 %1, 16
  %454 = or i32 %453, %2
  %455 = icmp eq i32 %452, 0
  br i1 %455, label %506, label %456

456:                                              ; preds = %444
  %457 = add nsw i32 %452, -1
  %458 = getelementptr inbounds nuw i8, ptr %424, i64 18
  br label %459

459:                                              ; preds = %502, %456
  %460 = phi i32 [ %457, %456 ], [ %504, %502 ]
  %461 = phi i32 [ 0, %456 ], [ %503, %502 ]
  %462 = add nsw i32 %461, %460
  %463 = ashr i32 %462, 1
  %464 = mul nsw i32 %463, 6
  %465 = sext i32 %464 to i64
  %466 = getelementptr inbounds i8, ptr %458, i64 %465
  %467 = load i8, ptr %466, align 1, !tbaa !14
  %468 = zext i8 %467 to i32
  %469 = shl nuw i32 %468, 24
  %470 = getelementptr inbounds nuw i8, ptr %466, i64 1
  %471 = load i8, ptr %470, align 1, !tbaa !14
  %472 = zext i8 %471 to i32
  %473 = shl nuw nsw i32 %472, 16
  %474 = or disjoint i32 %473, %469
  %475 = getelementptr inbounds nuw i8, ptr %466, i64 2
  %476 = load i8, ptr %475, align 1, !tbaa !14
  %477 = zext i8 %476 to i32
  %478 = shl nuw nsw i32 %477, 8
  %479 = or disjoint i32 %474, %478
  %480 = getelementptr inbounds nuw i8, ptr %466, i64 3
  %481 = load i8, ptr %480, align 1, !tbaa !14
  %482 = zext i8 %481 to i32
  %483 = or disjoint i32 %479, %482
  %484 = icmp ult i32 %454, %483
  br i1 %484, label %485, label %487

485:                                              ; preds = %459
  %486 = add nsw i32 %463, -1
  br label %502

487:                                              ; preds = %459
  %488 = icmp ugt i32 %454, %483
  br i1 %488, label %489, label %491

489:                                              ; preds = %487
  %490 = add nsw i32 %463, 1
  br label %502

491:                                              ; preds = %487
  %492 = getelementptr inbounds nuw i8, ptr %424, i64 22
  %493 = getelementptr inbounds i8, ptr %492, i64 %465
  %494 = load i8, ptr %493, align 1, !tbaa !14
  %495 = zext i8 %494 to i16
  %496 = shl nuw i16 %495, 8
  %497 = getelementptr inbounds nuw i8, ptr %493, i64 1
  %498 = load i8, ptr %497, align 1, !tbaa !14
  %499 = zext i8 %498 to i16
  %500 = or disjoint i16 %496, %499
  %501 = sext i16 %500 to i32
  br label %506

502:                                              ; preds = %489, %485
  %503 = phi i32 [ %461, %485 ], [ %490, %489 ]
  %504 = phi i32 [ %486, %485 ], [ %460, %489 ]
  %505 = icmp sgt i32 %503, %504
  br i1 %505, label %506, label %459, !llvm.loop !51

506:                                              ; preds = %413, %410, %502, %491, %444, %434, %420, %30, %20, %7, %416
  %507 = phi i32 [ 0, %416 ], [ 0, %434 ], [ 0, %502 ], [ 0, %7 ], [ 0, %20 ], [ 0, %30 ], [ 0, %444 ], [ 0, %420 ], [ %501, %491 ], [ %412, %410 ], [ 0, %413 ]
  ret i32 %507
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local i32 @stbtt_GetCodepointKernAdvance(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 44
  %5 = load i32, ptr %4, align 4, !tbaa !39
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %11

7:                                                ; preds = %3
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %9 = load i32, ptr %8, align 8, !tbaa !45
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %15, label %11

11:                                               ; preds = %7, %3
  %12 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %1) #25
  %13 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %2) #25
  %14 = tail call i32 @stbtt_GetGlyphKernAdvance(ptr noundef %0, i32 noundef %12, i32 noundef %13) #25
  br label %15

15:                                               ; preds = %7, %11
  %16 = phi i32 [ %14, %11 ], [ 0, %7 ]
  ret i32 %16
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_GetCodepointHMetrics(ptr noundef readonly captures(none) %0, i32 noundef %1, ptr noundef writeonly captures(address_is_null) %2, ptr noundef writeonly captures(address_is_null) %3) local_unnamed_addr #6 {
  %5 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %1) #25
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %7 = load ptr, ptr %6, align 8, !tbaa !8
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %9 = load i32, ptr %8, align 4, !tbaa !37
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds i8, ptr %7, i64 %10
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 34
  %13 = load i8, ptr %12, align 1, !tbaa !14
  %14 = zext i8 %13 to i32
  %15 = shl nuw nsw i32 %14, 8
  %16 = getelementptr inbounds nuw i8, ptr %11, i64 35
  %17 = load i8, ptr %16, align 1, !tbaa !14
  %18 = zext i8 %17 to i32
  %19 = or disjoint i32 %15, %18
  %20 = icmp slt i32 %5, %19
  %21 = icmp eq ptr %2, null
  br i1 %20, label %22, label %51

22:                                               ; preds = %4
  br i1 %21, label %39, label %23

23:                                               ; preds = %22
  %24 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %25 = load i32, ptr %24, align 8, !tbaa !38
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds i8, ptr %7, i64 %26
  %28 = shl nsw i32 %5, 2
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds i8, ptr %27, i64 %29
  %31 = load i8, ptr %30, align 1, !tbaa !14
  %32 = zext i8 %31 to i16
  %33 = shl nuw i16 %32, 8
  %34 = getelementptr inbounds nuw i8, ptr %30, i64 1
  %35 = load i8, ptr %34, align 1, !tbaa !14
  %36 = zext i8 %35 to i16
  %37 = or disjoint i16 %33, %36
  %38 = sext i16 %37 to i32
  store i32 %38, ptr %2, align 4, !tbaa !4
  br label %39

39:                                               ; preds = %23, %22
  %40 = icmp eq ptr %3, null
  br i1 %40, label %94, label %41

41:                                               ; preds = %39
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %43 = load i32, ptr %42, align 8, !tbaa !38
  %44 = sext i32 %43 to i64
  %45 = getelementptr inbounds i8, ptr %7, i64 %44
  %46 = shl nsw i32 %5, 2
  %47 = sext i32 %46 to i64
  %48 = getelementptr inbounds i8, ptr %45, i64 %47
  %49 = getelementptr inbounds nuw i8, ptr %48, i64 2
  %50 = getelementptr inbounds nuw i8, ptr %48, i64 3
  br label %84

51:                                               ; preds = %4
  br i1 %21, label %69, label %52

52:                                               ; preds = %51
  %53 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %54 = load i32, ptr %53, align 8, !tbaa !38
  %55 = sext i32 %54 to i64
  %56 = getelementptr inbounds i8, ptr %7, i64 %55
  %57 = shl nuw nsw i32 %19, 2
  %58 = zext nneg i32 %57 to i64
  %59 = getelementptr i8, ptr %56, i64 %58
  %60 = getelementptr i8, ptr %59, i64 -4
  %61 = load i8, ptr %60, align 1, !tbaa !14
  %62 = zext i8 %61 to i16
  %63 = shl nuw i16 %62, 8
  %64 = getelementptr i8, ptr %59, i64 -3
  %65 = load i8, ptr %64, align 1, !tbaa !14
  %66 = zext i8 %65 to i16
  %67 = or disjoint i16 %63, %66
  %68 = sext i16 %67 to i32
  store i32 %68, ptr %2, align 4, !tbaa !4
  br label %69

69:                                               ; preds = %52, %51
  %70 = icmp eq ptr %3, null
  br i1 %70, label %94, label %71

71:                                               ; preds = %69
  %72 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %73 = load i32, ptr %72, align 8, !tbaa !38
  %74 = sext i32 %73 to i64
  %75 = getelementptr inbounds i8, ptr %7, i64 %74
  %76 = shl nuw nsw i32 %19, 2
  %77 = zext nneg i32 %76 to i64
  %78 = getelementptr inbounds nuw i8, ptr %75, i64 %77
  %79 = sub nsw i32 %5, %19
  %80 = shl nsw i32 %79, 1
  %81 = sext i32 %80 to i64
  %82 = getelementptr inbounds i8, ptr %78, i64 %81
  %83 = getelementptr inbounds nuw i8, ptr %82, i64 1
  br label %84

84:                                               ; preds = %71, %41
  %85 = phi ptr [ %50, %41 ], [ %83, %71 ]
  %86 = phi ptr [ %49, %41 ], [ %82, %71 ]
  %87 = load i8, ptr %86, align 1, !tbaa !14
  %88 = zext i8 %87 to i16
  %89 = shl nuw i16 %88, 8
  %90 = load i8, ptr %85, align 1, !tbaa !14
  %91 = zext i8 %90 to i16
  %92 = or disjoint i16 %89, %91
  %93 = sext i16 %92 to i32
  store i32 %93, ptr %3, align 4, !tbaa !4
  br label %94

94:                                               ; preds = %84, %39, %69
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_GetFontVMetrics(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(address_is_null) %1, ptr noundef writeonly captures(address_is_null) %2, ptr noundef writeonly captures(address_is_null) %3) local_unnamed_addr #5 {
  %5 = icmp eq ptr %1, null
  br i1 %5, label %22, label %6

6:                                                ; preds = %4
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %8 = load ptr, ptr %7, align 8, !tbaa !8
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %10 = load i32, ptr %9, align 4, !tbaa !37
  %11 = sext i32 %10 to i64
  %12 = getelementptr inbounds i8, ptr %8, i64 %11
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 4
  %14 = load i8, ptr %13, align 1, !tbaa !14
  %15 = zext i8 %14 to i16
  %16 = shl nuw i16 %15, 8
  %17 = getelementptr inbounds nuw i8, ptr %12, i64 5
  %18 = load i8, ptr %17, align 1, !tbaa !14
  %19 = zext i8 %18 to i16
  %20 = or disjoint i16 %16, %19
  %21 = sext i16 %20 to i32
  store i32 %21, ptr %1, align 4, !tbaa !4
  br label %22

22:                                               ; preds = %6, %4
  %23 = icmp eq ptr %2, null
  br i1 %23, label %40, label %24

24:                                               ; preds = %22
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %26 = load ptr, ptr %25, align 8, !tbaa !8
  %27 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %28 = load i32, ptr %27, align 4, !tbaa !37
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds i8, ptr %26, i64 %29
  %31 = getelementptr inbounds nuw i8, ptr %30, i64 6
  %32 = load i8, ptr %31, align 1, !tbaa !14
  %33 = zext i8 %32 to i16
  %34 = shl nuw i16 %33, 8
  %35 = getelementptr inbounds nuw i8, ptr %30, i64 7
  %36 = load i8, ptr %35, align 1, !tbaa !14
  %37 = zext i8 %36 to i16
  %38 = or disjoint i16 %34, %37
  %39 = sext i16 %38 to i32
  store i32 %39, ptr %2, align 4, !tbaa !4
  br label %40

40:                                               ; preds = %24, %22
  %41 = icmp eq ptr %3, null
  br i1 %41, label %58, label %42

42:                                               ; preds = %40
  %43 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %44 = load ptr, ptr %43, align 8, !tbaa !8
  %45 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %46 = load i32, ptr %45, align 4, !tbaa !37
  %47 = sext i32 %46 to i64
  %48 = getelementptr inbounds i8, ptr %44, i64 %47
  %49 = getelementptr inbounds nuw i8, ptr %48, i64 8
  %50 = load i8, ptr %49, align 1, !tbaa !14
  %51 = zext i8 %50 to i16
  %52 = shl nuw i16 %51, 8
  %53 = getelementptr inbounds nuw i8, ptr %48, i64 9
  %54 = load i8, ptr %53, align 1, !tbaa !14
  %55 = zext i8 %54 to i16
  %56 = or disjoint i16 %52, %55
  %57 = sext i16 %56 to i32
  store i32 %57, ptr %3, align 4, !tbaa !4
  br label %58

58:                                               ; preds = %42, %40
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local range(i32 0, 2) i32 @stbtt_GetFontVMetricsOS2(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(address_is_null) %1, ptr noundef writeonly captures(address_is_null) %2, ptr noundef writeonly captures(address_is_null) %3) local_unnamed_addr #6 {
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %6 = load ptr, ptr %5, align 8, !tbaa !8
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %8 = load i32, ptr %7, align 8, !tbaa !52
  %9 = zext i32 %8 to i64
  %10 = getelementptr inbounds nuw i8, ptr %6, i64 %9
  %11 = getelementptr inbounds nuw i8, ptr %10, i64 4
  %12 = load i8, ptr %11, align 1, !tbaa !14
  %13 = zext i8 %12 to i32
  %14 = shl nuw nsw i32 %13, 8
  %15 = getelementptr inbounds nuw i8, ptr %10, i64 5
  %16 = load i8, ptr %15, align 1, !tbaa !14
  %17 = zext i8 %16 to i32
  %18 = or disjoint i32 %14, %17
  %19 = add i32 %8, 12
  %20 = icmp eq i32 %18, 0
  br i1 %20, label %70, label %21

21:                                               ; preds = %4
  %22 = zext nneg i32 %18 to i64
  br label %26

23:                                               ; preds = %67
  %24 = add nuw nsw i64 %27, 1
  %25 = icmp eq i64 %24, %22
  br i1 %25, label %70, label %26, !llvm.loop !53

26:                                               ; preds = %23, %21
  %27 = phi i64 [ 0, %21 ], [ %24, %23 ]
  %28 = phi i32 [ undef, %21 ], [ %68, %23 ]
  %29 = trunc i64 %27 to i32
  %30 = shl i32 %29, 4
  %31 = add i32 %19, %30
  %32 = zext i32 %31 to i64
  %33 = getelementptr inbounds nuw i8, ptr %6, i64 %32
  %34 = load i8, ptr %33, align 1, !tbaa !14
  %35 = icmp eq i8 %34, 79
  br i1 %35, label %36, label %67

36:                                               ; preds = %26
  %37 = getelementptr inbounds nuw i8, ptr %33, i64 1
  %38 = load i8, ptr %37, align 1, !tbaa !14
  %39 = icmp eq i8 %38, 83
  br i1 %39, label %40, label %67

40:                                               ; preds = %36
  %41 = getelementptr inbounds nuw i8, ptr %33, i64 2
  %42 = load i8, ptr %41, align 1, !tbaa !14
  %43 = icmp eq i8 %42, 47
  br i1 %43, label %44, label %67

44:                                               ; preds = %40
  %45 = getelementptr inbounds nuw i8, ptr %33, i64 3
  %46 = load i8, ptr %45, align 1, !tbaa !14
  %47 = icmp eq i8 %46, 50
  br i1 %47, label %48, label %67

48:                                               ; preds = %44
  %49 = getelementptr inbounds nuw i8, ptr %33, i64 8
  %50 = load i8, ptr %49, align 1, !tbaa !14
  %51 = zext i8 %50 to i32
  %52 = shl nuw i32 %51, 24
  %53 = getelementptr inbounds nuw i8, ptr %33, i64 9
  %54 = load i8, ptr %53, align 1, !tbaa !14
  %55 = zext i8 %54 to i32
  %56 = shl nuw nsw i32 %55, 16
  %57 = or disjoint i32 %56, %52
  %58 = getelementptr inbounds nuw i8, ptr %33, i64 10
  %59 = load i8, ptr %58, align 1, !tbaa !14
  %60 = zext i8 %59 to i32
  %61 = shl nuw nsw i32 %60, 8
  %62 = or disjoint i32 %57, %61
  %63 = getelementptr inbounds nuw i8, ptr %33, i64 11
  %64 = load i8, ptr %63, align 1, !tbaa !14
  %65 = zext i8 %64 to i32
  %66 = or disjoint i32 %62, %65
  br label %67

67:                                               ; preds = %48, %44, %40, %36, %26
  %68 = phi i32 [ %66, %48 ], [ %28, %44 ], [ %28, %40 ], [ %28, %36 ], [ %28, %26 ]
  %69 = phi i1 [ false, %48 ], [ true, %44 ], [ true, %40 ], [ true, %36 ], [ true, %26 ]
  br i1 %69, label %23, label %70

70:                                               ; preds = %23, %67, %4
  %71 = phi i32 [ 0, %4 ], [ %68, %67 ], [ 0, %23 ]
  %72 = icmp eq i32 %71, 0
  br i1 %72, label %115, label %73

73:                                               ; preds = %70
  %74 = icmp eq ptr %1, null
  br i1 %74, label %87, label %75

75:                                               ; preds = %73
  %76 = sext i32 %71 to i64
  %77 = getelementptr inbounds i8, ptr %6, i64 %76
  %78 = getelementptr inbounds nuw i8, ptr %77, i64 68
  %79 = load i8, ptr %78, align 1, !tbaa !14
  %80 = zext i8 %79 to i16
  %81 = shl nuw i16 %80, 8
  %82 = getelementptr inbounds nuw i8, ptr %77, i64 69
  %83 = load i8, ptr %82, align 1, !tbaa !14
  %84 = zext i8 %83 to i16
  %85 = or disjoint i16 %81, %84
  %86 = sext i16 %85 to i32
  store i32 %86, ptr %1, align 4, !tbaa !4
  br label %87

87:                                               ; preds = %75, %73
  %88 = icmp eq ptr %2, null
  br i1 %88, label %101, label %89

89:                                               ; preds = %87
  %90 = sext i32 %71 to i64
  %91 = getelementptr inbounds i8, ptr %6, i64 %90
  %92 = getelementptr inbounds nuw i8, ptr %91, i64 70
  %93 = load i8, ptr %92, align 1, !tbaa !14
  %94 = zext i8 %93 to i16
  %95 = shl nuw i16 %94, 8
  %96 = getelementptr inbounds nuw i8, ptr %91, i64 71
  %97 = load i8, ptr %96, align 1, !tbaa !14
  %98 = zext i8 %97 to i16
  %99 = or disjoint i16 %95, %98
  %100 = sext i16 %99 to i32
  store i32 %100, ptr %2, align 4, !tbaa !4
  br label %101

101:                                              ; preds = %89, %87
  %102 = icmp eq ptr %3, null
  br i1 %102, label %115, label %103

103:                                              ; preds = %101
  %104 = sext i32 %71 to i64
  %105 = getelementptr inbounds i8, ptr %6, i64 %104
  %106 = getelementptr inbounds nuw i8, ptr %105, i64 72
  %107 = load i8, ptr %106, align 1, !tbaa !14
  %108 = zext i8 %107 to i16
  %109 = shl nuw i16 %108, 8
  %110 = getelementptr inbounds nuw i8, ptr %105, i64 73
  %111 = load i8, ptr %110, align 1, !tbaa !14
  %112 = zext i8 %111 to i16
  %113 = or disjoint i16 %109, %112
  %114 = sext i16 %113 to i32
  store i32 %114, ptr %3, align 4, !tbaa !4
  br label %115

115:                                              ; preds = %101, %103, %70
  %116 = phi i32 [ 0, %70 ], [ 1, %103 ], [ 1, %101 ]
  ret i32 %116
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_GetFontBoundingBox(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(none) initializes((0, 4)) %1, ptr noundef writeonly captures(none) initializes((0, 4)) %2, ptr noundef writeonly captures(none) initializes((0, 4)) %3, ptr noundef writeonly captures(none) initializes((0, 4)) %4) local_unnamed_addr #5 {
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %7 = load ptr, ptr %6, align 8, !tbaa !8
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %9 = load i32, ptr %8, align 4, !tbaa !54
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds i8, ptr %7, i64 %10
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 36
  %13 = load i8, ptr %12, align 1, !tbaa !14
  %14 = zext i8 %13 to i16
  %15 = shl nuw i16 %14, 8
  %16 = getelementptr inbounds nuw i8, ptr %11, i64 37
  %17 = load i8, ptr %16, align 1, !tbaa !14
  %18 = zext i8 %17 to i16
  %19 = or disjoint i16 %15, %18
  %20 = sext i16 %19 to i32
  store i32 %20, ptr %1, align 4, !tbaa !4
  %21 = load i32, ptr %8, align 4, !tbaa !54
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds i8, ptr %7, i64 %22
  %24 = getelementptr inbounds nuw i8, ptr %23, i64 38
  %25 = load i8, ptr %24, align 1, !tbaa !14
  %26 = zext i8 %25 to i16
  %27 = shl nuw i16 %26, 8
  %28 = getelementptr inbounds nuw i8, ptr %23, i64 39
  %29 = load i8, ptr %28, align 1, !tbaa !14
  %30 = zext i8 %29 to i16
  %31 = or disjoint i16 %27, %30
  %32 = sext i16 %31 to i32
  store i32 %32, ptr %2, align 4, !tbaa !4
  %33 = load i32, ptr %8, align 4, !tbaa !54
  %34 = sext i32 %33 to i64
  %35 = getelementptr inbounds i8, ptr %7, i64 %34
  %36 = getelementptr inbounds nuw i8, ptr %35, i64 40
  %37 = load i8, ptr %36, align 1, !tbaa !14
  %38 = zext i8 %37 to i16
  %39 = shl nuw i16 %38, 8
  %40 = getelementptr inbounds nuw i8, ptr %35, i64 41
  %41 = load i8, ptr %40, align 1, !tbaa !14
  %42 = zext i8 %41 to i16
  %43 = or disjoint i16 %39, %42
  %44 = sext i16 %43 to i32
  store i32 %44, ptr %3, align 4, !tbaa !4
  %45 = load i32, ptr %8, align 4, !tbaa !54
  %46 = sext i32 %45 to i64
  %47 = getelementptr inbounds i8, ptr %7, i64 %46
  %48 = getelementptr inbounds nuw i8, ptr %47, i64 42
  %49 = load i8, ptr %48, align 1, !tbaa !14
  %50 = zext i8 %49 to i16
  %51 = shl nuw i16 %50, 8
  %52 = getelementptr inbounds nuw i8, ptr %47, i64 43
  %53 = load i8, ptr %52, align 1, !tbaa !14
  %54 = zext i8 %53 to i16
  %55 = or disjoint i16 %51, %54
  %56 = sext i16 %55 to i32
  store i32 %56, ptr %4, align 4, !tbaa !4
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local float @stbtt_ScaleForPixelHeight(ptr noundef readonly captures(none) %0, float noundef %1) local_unnamed_addr #4 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load ptr, ptr %3, align 8, !tbaa !8
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %6 = load i32, ptr %5, align 4, !tbaa !37
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, ptr %4, i64 %7
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 4
  %10 = load i8, ptr %9, align 1, !tbaa !14
  %11 = zext i8 %10 to i16
  %12 = shl nuw i16 %11, 8
  %13 = getelementptr inbounds nuw i8, ptr %8, i64 5
  %14 = load i8, ptr %13, align 1, !tbaa !14
  %15 = zext i8 %14 to i16
  %16 = or disjoint i16 %12, %15
  %17 = sext i16 %16 to i32
  %18 = getelementptr inbounds nuw i8, ptr %8, i64 6
  %19 = load i8, ptr %18, align 1, !tbaa !14
  %20 = zext i8 %19 to i16
  %21 = shl nuw i16 %20, 8
  %22 = getelementptr inbounds nuw i8, ptr %8, i64 7
  %23 = load i8, ptr %22, align 1, !tbaa !14
  %24 = zext i8 %23 to i16
  %25 = or disjoint i16 %21, %24
  %26 = sext i16 %25 to i32
  %27 = sub nsw i32 %17, %26
  %28 = sitofp i32 %27 to float
  %29 = fdiv float %1, %28
  ret float %29
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local float @stbtt_ScaleForMappingEmToPixels(ptr noundef readonly captures(none) %0, float noundef %1) local_unnamed_addr #4 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load ptr, ptr %3, align 8, !tbaa !8
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %6 = load i32, ptr %5, align 4, !tbaa !54
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, ptr %4, i64 %7
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 18
  %10 = load i8, ptr %9, align 1, !tbaa !14
  %11 = zext i8 %10 to i16
  %12 = shl nuw i16 %11, 8
  %13 = getelementptr inbounds nuw i8, ptr %8, i64 19
  %14 = load i8, ptr %13, align 1, !tbaa !14
  %15 = zext i8 %14 to i16
  %16 = or disjoint i16 %12, %15
  %17 = uitofp i16 %16 to float
  %18 = fdiv float %1, %17
  ret float %18
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local void @stbtt_FreeShape(ptr noundef readnone captures(none) %0, ptr noundef readnone captures(none) %1) local_unnamed_addr #7 {
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local ptr @stbtt_FindSVGDoc(ptr noundef captures(none) %0, i32 noundef %1) local_unnamed_addr #6 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %4 = load ptr, ptr %3, align 8, !tbaa !8
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 52
  %6 = load i32, ptr %5, align 4, !tbaa !55
  %7 = icmp slt i32 %6, 0
  br i1 %7, label %8, label %99

8:                                                ; preds = %2
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %10 = load i32, ptr %9, align 8, !tbaa !52
  %11 = zext i32 %10 to i64
  %12 = getelementptr inbounds nuw i8, ptr %4, i64 %11
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 4
  %14 = load i8, ptr %13, align 1, !tbaa !14
  %15 = zext i8 %14 to i32
  %16 = shl nuw nsw i32 %15, 8
  %17 = getelementptr inbounds nuw i8, ptr %12, i64 5
  %18 = load i8, ptr %17, align 1, !tbaa !14
  %19 = zext i8 %18 to i32
  %20 = or disjoint i32 %16, %19
  %21 = add i32 %10, 12
  %22 = icmp eq i32 %20, 0
  br i1 %22, label %72, label %23

23:                                               ; preds = %8
  %24 = zext nneg i32 %20 to i64
  br label %28

25:                                               ; preds = %69
  %26 = add nuw nsw i64 %29, 1
  %27 = icmp eq i64 %26, %24
  br i1 %27, label %72, label %28, !llvm.loop !53

28:                                               ; preds = %25, %23
  %29 = phi i64 [ 0, %23 ], [ %26, %25 ]
  %30 = phi i32 [ undef, %23 ], [ %70, %25 ]
  %31 = trunc i64 %29 to i32
  %32 = shl i32 %31, 4
  %33 = add i32 %21, %32
  %34 = zext i32 %33 to i64
  %35 = getelementptr inbounds nuw i8, ptr %4, i64 %34
  %36 = load i8, ptr %35, align 1, !tbaa !14
  %37 = icmp eq i8 %36, 83
  br i1 %37, label %38, label %69

38:                                               ; preds = %28
  %39 = getelementptr inbounds nuw i8, ptr %35, i64 1
  %40 = load i8, ptr %39, align 1, !tbaa !14
  %41 = icmp eq i8 %40, 86
  br i1 %41, label %42, label %69

42:                                               ; preds = %38
  %43 = getelementptr inbounds nuw i8, ptr %35, i64 2
  %44 = load i8, ptr %43, align 1, !tbaa !14
  %45 = icmp eq i8 %44, 71
  br i1 %45, label %46, label %69

46:                                               ; preds = %42
  %47 = getelementptr inbounds nuw i8, ptr %35, i64 3
  %48 = load i8, ptr %47, align 1, !tbaa !14
  %49 = icmp eq i8 %48, 32
  br i1 %49, label %50, label %69

50:                                               ; preds = %46
  %51 = getelementptr inbounds nuw i8, ptr %35, i64 8
  %52 = load i8, ptr %51, align 1, !tbaa !14
  %53 = zext i8 %52 to i32
  %54 = shl nuw i32 %53, 24
  %55 = getelementptr inbounds nuw i8, ptr %35, i64 9
  %56 = load i8, ptr %55, align 1, !tbaa !14
  %57 = zext i8 %56 to i32
  %58 = shl nuw nsw i32 %57, 16
  %59 = or disjoint i32 %58, %54
  %60 = getelementptr inbounds nuw i8, ptr %35, i64 10
  %61 = load i8, ptr %60, align 1, !tbaa !14
  %62 = zext i8 %61 to i32
  %63 = shl nuw nsw i32 %62, 8
  %64 = or disjoint i32 %59, %63
  %65 = getelementptr inbounds nuw i8, ptr %35, i64 11
  %66 = load i8, ptr %65, align 1, !tbaa !14
  %67 = zext i8 %66 to i32
  %68 = or disjoint i32 %64, %67
  br label %69

69:                                               ; preds = %50, %46, %42, %38, %28
  %70 = phi i32 [ %68, %50 ], [ %30, %46 ], [ %30, %42 ], [ %30, %38 ], [ %30, %28 ]
  %71 = phi i1 [ false, %50 ], [ true, %46 ], [ true, %42 ], [ true, %38 ], [ true, %28 ]
  br i1 %71, label %25, label %72

72:                                               ; preds = %69, %25, %8
  %73 = phi i32 [ 0, %8 ], [ %70, %69 ], [ 0, %25 ]
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %97, label %75

75:                                               ; preds = %72
  %76 = zext i32 %73 to i64
  %77 = getelementptr inbounds nuw i8, ptr %4, i64 %76
  %78 = getelementptr inbounds nuw i8, ptr %77, i64 2
  %79 = load i8, ptr %78, align 1, !tbaa !14
  %80 = zext i8 %79 to i32
  %81 = shl nuw i32 %80, 24
  %82 = getelementptr inbounds nuw i8, ptr %77, i64 3
  %83 = load i8, ptr %82, align 1, !tbaa !14
  %84 = zext i8 %83 to i32
  %85 = shl nuw nsw i32 %84, 16
  %86 = or disjoint i32 %85, %81
  %87 = getelementptr inbounds nuw i8, ptr %77, i64 4
  %88 = load i8, ptr %87, align 1, !tbaa !14
  %89 = zext i8 %88 to i32
  %90 = shl nuw nsw i32 %89, 8
  %91 = or disjoint i32 %86, %90
  %92 = getelementptr inbounds nuw i8, ptr %77, i64 5
  %93 = load i8, ptr %92, align 1, !tbaa !14
  %94 = zext i8 %93 to i32
  %95 = or disjoint i32 %91, %94
  %96 = add i32 %95, %73
  br label %97

97:                                               ; preds = %72, %75
  %98 = phi i32 [ %96, %75 ], [ 0, %72 ]
  store i32 %98, ptr %5, align 4, !tbaa !55
  br label %99

99:                                               ; preds = %97, %2
  %100 = load i32, ptr %5, align 4, !tbaa !55
  %101 = sext i32 %100 to i64
  %102 = getelementptr inbounds i8, ptr %4, i64 %101
  %103 = load i8, ptr %102, align 1, !tbaa !14
  %104 = zext i8 %103 to i32
  %105 = shl nuw nsw i32 %104, 8
  %106 = getelementptr inbounds nuw i8, ptr %102, i64 1
  %107 = load i8, ptr %106, align 1, !tbaa !14
  %108 = zext i8 %107 to i32
  %109 = or disjoint i32 %105, %108
  %110 = getelementptr inbounds nuw i8, ptr %102, i64 2
  %111 = icmp eq i32 %109, 0
  br i1 %111, label %144, label %112

112:                                              ; preds = %99
  %113 = zext nneg i32 %109 to i64
  br label %117

114:                                              ; preds = %141
  %115 = add nuw nsw i64 %118, 1
  %116 = icmp eq i64 %115, %113
  br i1 %116, label %144, label %117, !llvm.loop !56

117:                                              ; preds = %112, %114
  %118 = phi i64 [ 0, %112 ], [ %115, %114 ]
  %119 = phi ptr [ undef, %112 ], [ %142, %114 ]
  %120 = mul nuw nsw i64 %118, 12
  %121 = getelementptr inbounds nuw i8, ptr %110, i64 %120
  %122 = load i8, ptr %121, align 1, !tbaa !14
  %123 = zext i8 %122 to i32
  %124 = shl nuw nsw i32 %123, 8
  %125 = getelementptr inbounds nuw i8, ptr %121, i64 1
  %126 = load i8, ptr %125, align 1, !tbaa !14
  %127 = zext i8 %126 to i32
  %128 = or disjoint i32 %124, %127
  %129 = icmp slt i32 %1, %128
  br i1 %129, label %140, label %130

130:                                              ; preds = %117
  %131 = getelementptr inbounds nuw i8, ptr %121, i64 2
  %132 = load i8, ptr %131, align 1, !tbaa !14
  %133 = zext i8 %132 to i32
  %134 = shl nuw nsw i32 %133, 8
  %135 = getelementptr inbounds nuw i8, ptr %121, i64 3
  %136 = load i8, ptr %135, align 1, !tbaa !14
  %137 = zext i8 %136 to i32
  %138 = or disjoint i32 %134, %137
  %139 = icmp sgt i32 %1, %138
  br i1 %139, label %140, label %141

140:                                              ; preds = %130, %117
  br label %141

141:                                              ; preds = %130, %140
  %142 = phi ptr [ %119, %140 ], [ %121, %130 ]
  %143 = phi i1 [ true, %140 ], [ false, %130 ]
  br i1 %143, label %114, label %144

144:                                              ; preds = %141, %114, %99
  %145 = phi ptr [ null, %99 ], [ %142, %141 ], [ null, %114 ]
  ret ptr %145
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local i32 @stbtt_GetGlyphSVG(ptr noundef captures(none) %0, i32 noundef %1, ptr noundef writeonly captures(none) %2) local_unnamed_addr #6 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %5 = load ptr, ptr %4, align 8, !tbaa !8
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 52
  %7 = load i32, ptr %6, align 4, !tbaa !55
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %53, label %9

9:                                                ; preds = %3
  %10 = tail call ptr @stbtt_FindSVGDoc(ptr noundef %0, i32 noundef %1) #25
  %11 = icmp eq ptr %10, null
  br i1 %11, label %53, label %12

12:                                               ; preds = %9
  %13 = load i32, ptr %6, align 4, !tbaa !55
  %14 = sext i32 %13 to i64
  %15 = getelementptr inbounds i8, ptr %5, i64 %14
  %16 = getelementptr inbounds nuw i8, ptr %10, i64 4
  %17 = load i8, ptr %16, align 1, !tbaa !14
  %18 = zext i8 %17 to i64
  %19 = shl nuw nsw i64 %18, 24
  %20 = getelementptr inbounds nuw i8, ptr %10, i64 5
  %21 = load i8, ptr %20, align 1, !tbaa !14
  %22 = zext i8 %21 to i64
  %23 = shl nuw nsw i64 %22, 16
  %24 = getelementptr inbounds nuw i8, ptr %10, i64 6
  %25 = load i8, ptr %24, align 1, !tbaa !14
  %26 = zext i8 %25 to i64
  %27 = shl nuw nsw i64 %26, 8
  %28 = getelementptr inbounds nuw i8, ptr %10, i64 7
  %29 = load i8, ptr %28, align 1, !tbaa !14
  %30 = zext i8 %29 to i64
  %31 = getelementptr inbounds nuw i8, ptr %15, i64 %23
  %32 = getelementptr inbounds nuw i8, ptr %31, i64 %19
  %33 = getelementptr inbounds nuw i8, ptr %32, i64 %27
  %34 = getelementptr inbounds nuw i8, ptr %33, i64 %30
  store ptr %34, ptr %2, align 8, !tbaa !57
  %35 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %36 = load i8, ptr %35, align 1, !tbaa !14
  %37 = zext i8 %36 to i32
  %38 = shl nuw i32 %37, 24
  %39 = getelementptr inbounds nuw i8, ptr %10, i64 9
  %40 = load i8, ptr %39, align 1, !tbaa !14
  %41 = zext i8 %40 to i32
  %42 = shl nuw nsw i32 %41, 16
  %43 = or disjoint i32 %42, %38
  %44 = getelementptr inbounds nuw i8, ptr %10, i64 10
  %45 = load i8, ptr %44, align 1, !tbaa !14
  %46 = zext i8 %45 to i32
  %47 = shl nuw nsw i32 %46, 8
  %48 = or disjoint i32 %43, %47
  %49 = getelementptr inbounds nuw i8, ptr %10, i64 11
  %50 = load i8, ptr %49, align 1, !tbaa !14
  %51 = zext i8 %50 to i32
  %52 = or disjoint i32 %48, %51
  br label %53

53:                                               ; preds = %9, %3, %12
  %54 = phi i32 [ 0, %3 ], [ %52, %12 ], [ 0, %9 ]
  ret i32 %54
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local i32 @stbtt_GetCodepointSVG(ptr noundef captures(none) %0, i32 noundef %1, ptr noundef writeonly captures(none) %2) local_unnamed_addr #6 {
  %4 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %1) #25
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %6 = load ptr, ptr %5, align 8, !tbaa !8
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 52
  %8 = load i32, ptr %7, align 4, !tbaa !55
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %54, label %10

10:                                               ; preds = %3
  %11 = tail call ptr @stbtt_FindSVGDoc(ptr noundef %0, i32 noundef %4) #25
  %12 = icmp eq ptr %11, null
  br i1 %12, label %54, label %13

13:                                               ; preds = %10
  %14 = load i32, ptr %7, align 4, !tbaa !55
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds i8, ptr %6, i64 %15
  %17 = getelementptr inbounds nuw i8, ptr %11, i64 4
  %18 = load i8, ptr %17, align 1, !tbaa !14
  %19 = zext i8 %18 to i64
  %20 = shl nuw nsw i64 %19, 24
  %21 = getelementptr inbounds nuw i8, ptr %11, i64 5
  %22 = load i8, ptr %21, align 1, !tbaa !14
  %23 = zext i8 %22 to i64
  %24 = shl nuw nsw i64 %23, 16
  %25 = getelementptr inbounds nuw i8, ptr %11, i64 6
  %26 = load i8, ptr %25, align 1, !tbaa !14
  %27 = zext i8 %26 to i64
  %28 = shl nuw nsw i64 %27, 8
  %29 = getelementptr inbounds nuw i8, ptr %11, i64 7
  %30 = load i8, ptr %29, align 1, !tbaa !14
  %31 = zext i8 %30 to i64
  %32 = getelementptr inbounds nuw i8, ptr %16, i64 %24
  %33 = getelementptr inbounds nuw i8, ptr %32, i64 %20
  %34 = getelementptr inbounds nuw i8, ptr %33, i64 %28
  %35 = getelementptr inbounds nuw i8, ptr %34, i64 %31
  store ptr %35, ptr %2, align 8, !tbaa !57
  %36 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %37 = load i8, ptr %36, align 1, !tbaa !14
  %38 = zext i8 %37 to i32
  %39 = shl nuw i32 %38, 24
  %40 = getelementptr inbounds nuw i8, ptr %11, i64 9
  %41 = load i8, ptr %40, align 1, !tbaa !14
  %42 = zext i8 %41 to i32
  %43 = shl nuw nsw i32 %42, 16
  %44 = or disjoint i32 %43, %39
  %45 = getelementptr inbounds nuw i8, ptr %11, i64 10
  %46 = load i8, ptr %45, align 1, !tbaa !14
  %47 = zext i8 %46 to i32
  %48 = shl nuw nsw i32 %47, 8
  %49 = or disjoint i32 %44, %48
  %50 = getelementptr inbounds nuw i8, ptr %11, i64 11
  %51 = load i8, ptr %50, align 1, !tbaa !14
  %52 = zext i8 %51 to i32
  %53 = or disjoint i32 %49, %52
  br label %54

54:                                               ; preds = %3, %10, %13
  %55 = phi i32 [ 0, %3 ], [ %53, %13 ], [ 0, %10 ]
  ret i32 %55
}

; Function Attrs: nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_GetGlyphBitmapBoxSubpixel(ptr noundef readonly captures(none) %0, i32 noundef %1, float noundef %2, float noundef %3, float noundef %4, float noundef %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7, ptr noundef writeonly captures(address_is_null) %8, ptr noundef writeonly captures(address_is_null) %9) local_unnamed_addr #3 {
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  store i32 0, ptr %11, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  store i32 0, ptr %12, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %14) #26
  %15 = call i32 @stbtt_GetGlyphBox(ptr noundef %0, i32 noundef %1, ptr noundef nonnull %11, ptr noundef nonnull %12, ptr noundef nonnull %13, ptr noundef nonnull %14) #25
  %16 = icmp eq i32 %15, 0
  %17 = icmp eq ptr %6, null
  br i1 %16, label %18, label %28

18:                                               ; preds = %10
  br i1 %17, label %20, label %19

19:                                               ; preds = %18
  store i32 0, ptr %6, align 4, !tbaa !4
  br label %20

20:                                               ; preds = %19, %18
  %21 = icmp eq ptr %7, null
  br i1 %21, label %23, label %22

22:                                               ; preds = %20
  store i32 0, ptr %7, align 4, !tbaa !4
  br label %23

23:                                               ; preds = %22, %20
  %24 = icmp eq ptr %8, null
  br i1 %24, label %26, label %25

25:                                               ; preds = %23
  store i32 0, ptr %8, align 4, !tbaa !4
  br label %26

26:                                               ; preds = %25, %23
  %27 = icmp eq ptr %9, null
  br i1 %27, label %63, label %61

28:                                               ; preds = %10
  br i1 %17, label %35, label %29

29:                                               ; preds = %28
  %30 = load i32, ptr %11, align 4, !tbaa !4
  %31 = sitofp i32 %30 to float
  %32 = call float @llvm.fmuladd.f32(float %31, float %2, float %4)
  %33 = call float @floorf(float noundef %32) #28
  %34 = fptosi float %33 to i32
  store i32 %34, ptr %6, align 4, !tbaa !4
  br label %35

35:                                               ; preds = %29, %28
  %36 = icmp eq ptr %7, null
  br i1 %36, label %44, label %37

37:                                               ; preds = %35
  %38 = load i32, ptr %14, align 4, !tbaa !4
  %39 = sub nsw i32 0, %38
  %40 = sitofp i32 %39 to float
  %41 = call float @llvm.fmuladd.f32(float %40, float %3, float %5)
  %42 = call float @floorf(float noundef %41) #28
  %43 = fptosi float %42 to i32
  store i32 %43, ptr %7, align 4, !tbaa !4
  br label %44

44:                                               ; preds = %37, %35
  %45 = icmp eq ptr %8, null
  br i1 %45, label %52, label %46

46:                                               ; preds = %44
  %47 = load i32, ptr %13, align 4, !tbaa !4
  %48 = sitofp i32 %47 to float
  %49 = call float @llvm.fmuladd.f32(float %48, float %2, float %4)
  %50 = call float @ceilf(float noundef %49) #28
  %51 = fptosi float %50 to i32
  store i32 %51, ptr %8, align 4, !tbaa !4
  br label %52

52:                                               ; preds = %46, %44
  %53 = icmp eq ptr %9, null
  br i1 %53, label %63, label %54

54:                                               ; preds = %52
  %55 = load i32, ptr %12, align 4, !tbaa !4
  %56 = sub nsw i32 0, %55
  %57 = sitofp i32 %56 to float
  %58 = call float @llvm.fmuladd.f32(float %57, float %3, float %5)
  %59 = call float @ceilf(float noundef %58) #28
  %60 = fptosi float %59 to i32
  br label %61

61:                                               ; preds = %26, %54
  %62 = phi i32 [ %60, %54 ], [ 0, %26 ]
  store i32 %62, ptr %9, align 4, !tbaa !4
  br label %63

63:                                               ; preds = %61, %52, %26
  call void @llvm.lifetime.end.p0(ptr nonnull %14) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  ret void
}

; Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
declare float @floorf(float noundef) local_unnamed_addr #8

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #9

; Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
declare float @ceilf(float noundef) local_unnamed_addr #8

; Function Attrs: nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_GetGlyphBitmapBox(ptr noundef readonly captures(none) %0, i32 noundef %1, float noundef %2, float noundef %3, ptr noundef writeonly captures(address_is_null) %4, ptr noundef writeonly captures(address_is_null) %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7) local_unnamed_addr #3 {
  tail call void @stbtt_GetGlyphBitmapBoxSubpixel(ptr noundef %0, i32 noundef %1, float noundef %2, float noundef %3, float noundef 0.000000e+00, float noundef 0.000000e+00, ptr noundef %4, ptr noundef %5, ptr noundef %6, ptr noundef %7) #25
  ret void
}

; Function Attrs: nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_GetCodepointBitmapBoxSubpixel(ptr noundef readonly captures(none) %0, i32 noundef %1, float noundef %2, float noundef %3, float noundef %4, float noundef %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7, ptr noundef writeonly captures(address_is_null) %8, ptr noundef writeonly captures(address_is_null) %9) local_unnamed_addr #3 {
  %11 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %1) #25
  tail call void @stbtt_GetGlyphBitmapBoxSubpixel(ptr noundef %0, i32 noundef %11, float noundef %2, float noundef %3, float noundef %4, float noundef %5, ptr noundef %6, ptr noundef %7, ptr noundef %8, ptr noundef %9) #25
  ret void
}

; Function Attrs: nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_GetCodepointBitmapBox(ptr noundef readonly captures(none) %0, i32 noundef %1, float noundef %2, float noundef %3, ptr noundef writeonly captures(address_is_null) %4, ptr noundef writeonly captures(address_is_null) %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7) local_unnamed_addr #3 {
  %9 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef readonly %0, i32 noundef %1) #25
  tail call void @stbtt_GetGlyphBitmapBoxSubpixel(ptr noundef readonly %0, i32 noundef %9, float noundef %2, float noundef %3, float noundef 0.000000e+00, float noundef 0.000000e+00, ptr noundef %4, ptr noundef %5, ptr noundef %6, ptr noundef %7) #25
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local void @stbtt_Rasterize(ptr noundef readnone captures(none) %0, float noundef %1, ptr noundef readonly captures(none) %2, i32 noundef %3, float noundef %4, float noundef %5, float noundef %6, float noundef %7, i32 noundef %8, i32 noundef %9, i32 noundef %10, ptr noundef readnone captures(none) %11) local_unnamed_addr #7 {
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local void @stbtt_FreeBitmap(ptr noundef readnone captures(none) %0, ptr noundef readnone captures(none) %1) local_unnamed_addr #7 {
  ret void
}

; Function Attrs: nounwind
define dso_local noalias noundef ptr @stbtt_GetGlyphBitmapSubpixel(ptr noundef readonly captures(none) %0, float noundef %1, float noundef %2, float noundef %3, float noundef %4, i32 noundef %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7, ptr noundef writeonly captures(address_is_null) %8, ptr noundef writeonly captures(address_is_null) %9) local_unnamed_addr #2 {
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %15) #26
  %16 = call i32 @stbtt_GetGlyphShape(ptr noundef %0, i32 noundef %5, ptr noundef nonnull %15) #25
  %17 = fcmp une float %1, 0.000000e+00
  %18 = select i1 %17, float %1, float %2
  %19 = fcmp une float %2, 0.000000e+00
  %20 = or i1 %17, %19
  %21 = select i1 %19, float %2, float %18
  br i1 %20, label %22, label %66

22:                                               ; preds = %10
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  store i32 0, ptr %11, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  store i32 0, ptr %12, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %14) #26
  %23 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %0, i32 noundef %5, ptr noundef nonnull %11, ptr noundef nonnull %12, ptr noundef nonnull %13, ptr noundef nonnull %14) #25
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %48, label %25

25:                                               ; preds = %22
  %26 = load i32, ptr %11, align 4, !tbaa !4
  %27 = sitofp i32 %26 to float
  %28 = call float @llvm.fmuladd.f32(float %27, float %18, float %3)
  %29 = call float @floorf(float noundef %28) #28
  %30 = fptosi float %29 to i32
  %31 = load i32, ptr %14, align 4, !tbaa !4
  %32 = sub nsw i32 0, %31
  %33 = sitofp i32 %32 to float
  %34 = call float @llvm.fmuladd.f32(float %33, float %21, float %4)
  %35 = call float @floorf(float noundef %34) #28
  %36 = fptosi float %35 to i32
  %37 = load i32, ptr %13, align 4, !tbaa !4
  %38 = sitofp i32 %37 to float
  %39 = call float @llvm.fmuladd.f32(float %38, float %18, float %3)
  %40 = call float @ceilf(float noundef %39) #28
  %41 = fptosi float %40 to i32
  %42 = load i32, ptr %12, align 4, !tbaa !4
  %43 = sub nsw i32 0, %42
  %44 = sitofp i32 %43 to float
  %45 = call float @llvm.fmuladd.f32(float %44, float %21, float %4)
  %46 = call float @ceilf(float noundef %45) #28
  %47 = fptosi float %46 to i32
  br label %48

48:                                               ; preds = %22, %25
  %49 = phi i32 [ %47, %25 ], [ 0, %22 ]
  %50 = phi i32 [ %41, %25 ], [ 0, %22 ]
  %51 = phi i32 [ %36, %25 ], [ 0, %22 ]
  %52 = phi i32 [ %30, %25 ], [ 0, %22 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %14) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  %53 = sub nsw i32 %49, %51
  %54 = icmp eq ptr %6, null
  br i1 %54, label %57, label %55

55:                                               ; preds = %48
  %56 = sub nsw i32 %50, %52
  store i32 %56, ptr %6, align 4, !tbaa !4
  br label %57

57:                                               ; preds = %55, %48
  %58 = icmp eq ptr %7, null
  br i1 %58, label %60, label %59

59:                                               ; preds = %57
  store i32 %53, ptr %7, align 4, !tbaa !4
  br label %60

60:                                               ; preds = %59, %57
  %61 = icmp eq ptr %8, null
  br i1 %61, label %63, label %62

62:                                               ; preds = %60
  store i32 %52, ptr %8, align 4, !tbaa !4
  br label %63

63:                                               ; preds = %62, %60
  %64 = icmp eq ptr %9, null
  br i1 %64, label %66, label %65

65:                                               ; preds = %63
  store i32 %51, ptr %9, align 4, !tbaa !4
  br label %66

66:                                               ; preds = %63, %65, %10
  call void @llvm.lifetime.end.p0(ptr nonnull %15) #26
  ret ptr null
}

; Function Attrs: nounwind
define dso_local noalias noundef ptr @stbtt_GetGlyphBitmap(ptr noundef readonly captures(none) %0, float noundef %1, float noundef %2, i32 noundef %3, ptr noundef writeonly captures(address_is_null) %4, ptr noundef writeonly captures(address_is_null) %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7) local_unnamed_addr #2 {
  %9 = tail call ptr @stbtt_GetGlyphBitmapSubpixel(ptr noundef %0, float noundef %1, float noundef %2, float noundef 0.000000e+00, float noundef 0.000000e+00, i32 noundef %3, ptr noundef %4, ptr noundef %5, ptr noundef %6, ptr noundef %7) #25
  ret ptr %9
}

; Function Attrs: nounwind
define dso_local void @stbtt_MakeGlyphBitmapSubpixel(ptr noundef readonly captures(none) %0, ptr noundef readnone captures(none) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, float noundef %5, float noundef %6, float noundef %7, float noundef %8, i32 noundef %9) local_unnamed_addr #2 {
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %15) #26
  %16 = call i32 @stbtt_GetGlyphShape(ptr noundef %0, i32 noundef %9, ptr noundef nonnull %15) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  store i32 0, ptr %11, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  store i32 0, ptr %12, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %14) #26
  %17 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %0, i32 noundef %9, ptr noundef nonnull %11, ptr noundef nonnull %12, ptr noundef nonnull %13, ptr noundef nonnull %14) #25
  call void @llvm.lifetime.end.p0(ptr nonnull %14) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %15) #26
  ret void
}

; Function Attrs: nounwind
define dso_local void @stbtt_MakeGlyphBitmap(ptr noundef readonly captures(none) %0, ptr noundef readnone captures(none) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, float noundef %5, float noundef %6, i32 noundef %7) local_unnamed_addr #2 {
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  %14 = call i32 @stbtt_GetGlyphShape(ptr noundef readonly %0, i32 noundef %7, ptr noundef nonnull %13) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %9) #26
  store i32 0, ptr %9, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %10) #26
  store i32 0, ptr %10, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  %15 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %0, i32 noundef %7, ptr noundef nonnull %9, ptr noundef nonnull %10, ptr noundef nonnull %11, ptr noundef nonnull %12) #25
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %10) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %9) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  ret void
}

; Function Attrs: nounwind
define dso_local noalias noundef ptr @stbtt_GetCodepointBitmapSubpixel(ptr noundef readonly captures(none) %0, float noundef %1, float noundef %2, float noundef %3, float noundef %4, i32 noundef %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7, ptr noundef writeonly captures(address_is_null) %8, ptr noundef writeonly captures(address_is_null) %9) local_unnamed_addr #2 {
  %11 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %5) #25
  %12 = tail call ptr @stbtt_GetGlyphBitmapSubpixel(ptr noundef %0, float noundef %1, float noundef %2, float noundef %3, float noundef %4, i32 noundef %11, ptr noundef %6, ptr noundef %7, ptr noundef %8, ptr noundef %9) #25
  ret ptr %12
}

; Function Attrs: nounwind
define dso_local void @stbtt_MakeCodepointBitmapSubpixelPrefilter(ptr noundef readonly captures(none) %0, ptr noundef captures(none) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, float noundef %5, float noundef %6, float noundef %7, float noundef %8, i32 noundef %9, i32 noundef %10, ptr noundef writeonly captures(none) initializes((0, 4)) %11, ptr noundef writeonly captures(none) initializes((0, 4)) %12, i32 noundef %13) local_unnamed_addr #2 {
  %15 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %13) #25
  tail call void @stbtt_MakeGlyphBitmapSubpixelPrefilter(ptr noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, float poison, float poison, float poison, float poison, i32 noundef %9, i32 noundef %10, ptr noundef %11, ptr noundef %12, i32 noundef %15) #25
  ret void
}

; Function Attrs: nounwind
define dso_local void @stbtt_MakeGlyphBitmapSubpixelPrefilter(ptr noundef readonly captures(none) %0, ptr noundef captures(none) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, float %5, float %6, float %7, float %8, i32 noundef %9, i32 noundef %10, ptr noundef writeonly captures(none) initializes((0, 4)) %11, ptr noundef writeonly captures(none) initializes((0, 4)) %12, i32 noundef %13) local_unnamed_addr #2 {
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %19) #26
  %20 = call i32 @stbtt_GetGlyphShape(ptr noundef readonly %0, i32 noundef %13, ptr noundef nonnull %19) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %15) #26
  store i32 0, ptr %15, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %16) #26
  store i32 0, ptr %16, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %17) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %18) #26
  %21 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %0, i32 noundef %13, ptr noundef nonnull %15, ptr noundef nonnull %16, ptr noundef nonnull %17, ptr noundef nonnull %18) #25
  call void @llvm.lifetime.end.p0(ptr nonnull %18) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %17) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %16) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %15) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %19) #26
  %22 = icmp sgt i32 %9, 1
  br i1 %22, label %23, label %24

23:                                               ; preds = %14
  call fastcc void @stbtt__h_prefilter(ptr noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, i32 noundef %9) #25
  br label %24

24:                                               ; preds = %23, %14
  %25 = icmp sgt i32 %10, 1
  br i1 %25, label %26, label %27

26:                                               ; preds = %24
  call fastcc void @stbtt__v_prefilter(ptr noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, i32 noundef %10) #25
  br label %27

27:                                               ; preds = %26, %24
  %28 = icmp eq i32 %9, 0
  br i1 %28, label %35, label %29

29:                                               ; preds = %27
  %30 = sub nsw i32 1, %9
  %31 = sitofp i32 %30 to float
  %32 = sitofp i32 %9 to float
  %33 = fmul float %32, 2.000000e+00
  %34 = fdiv float %31, %33
  br label %35

35:                                               ; preds = %27, %29
  %36 = phi float [ %34, %29 ], [ 0.000000e+00, %27 ]
  store float %36, ptr %11, align 4, !tbaa !58
  %37 = icmp eq i32 %10, 0
  br i1 %37, label %44, label %38

38:                                               ; preds = %35
  %39 = sub nsw i32 1, %10
  %40 = sitofp i32 %39 to float
  %41 = sitofp i32 %10 to float
  %42 = fmul float %41, 2.000000e+00
  %43 = fdiv float %40, %42
  br label %44

44:                                               ; preds = %35, %38
  %45 = phi float [ %43, %38 ], [ 0.000000e+00, %35 ]
  store float %45, ptr %12, align 4, !tbaa !58
  ret void
}

; Function Attrs: nounwind
define dso_local void @stbtt_MakeCodepointBitmapSubpixel(ptr noundef readonly captures(none) %0, ptr noundef readnone captures(none) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, float noundef %5, float noundef %6, float noundef %7, float noundef %8, i32 noundef %9) local_unnamed_addr #2 {
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca ptr, align 8
  %16 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %9) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %15) #26
  %17 = call i32 @stbtt_GetGlyphShape(ptr noundef readonly %0, i32 noundef %16, ptr noundef nonnull %15) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  store i32 0, ptr %11, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  store i32 0, ptr %12, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %14) #26
  %18 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %0, i32 noundef %16, ptr noundef nonnull %11, ptr noundef nonnull %12, ptr noundef nonnull %13, ptr noundef nonnull %14) #25
  call void @llvm.lifetime.end.p0(ptr nonnull %14) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %15) #26
  ret void
}

; Function Attrs: nounwind
define dso_local noalias noundef ptr @stbtt_GetCodepointBitmap(ptr noundef readonly captures(none) %0, float noundef %1, float noundef %2, i32 noundef %3, ptr noundef writeonly captures(address_is_null) %4, ptr noundef writeonly captures(address_is_null) %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7) local_unnamed_addr #2 {
  %9 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef readonly %0, i32 noundef %3) #25
  %10 = tail call noalias noundef ptr @stbtt_GetGlyphBitmapSubpixel(ptr noundef readonly %0, float noundef %1, float noundef %2, float noundef 0.000000e+00, float noundef 0.000000e+00, i32 noundef %9, ptr noundef %4, ptr noundef %5, ptr noundef %6, ptr noundef %7) #25
  ret ptr %10
}

; Function Attrs: nounwind
define dso_local void @stbtt_MakeCodepointBitmap(ptr noundef readonly captures(none) %0, ptr noundef readnone captures(none) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, float noundef %5, float noundef %6, i32 noundef %7) local_unnamed_addr #2 {
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca ptr, align 8
  %14 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef readonly %0, i32 noundef %7) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  %15 = call i32 @stbtt_GetGlyphShape(ptr noundef readonly %0, i32 noundef %14, ptr noundef nonnull %13) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %9) #26
  store i32 0, ptr %9, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %10) #26
  store i32 0, ptr %10, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  %16 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %0, i32 noundef %14, ptr noundef nonnull %9, ptr noundef nonnull %10, ptr noundef nonnull %11, ptr noundef nonnull %12) #25
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %10) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %9) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  ret void
}

; Function Attrs: mustprogress nofree nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @stbtt_GetBakedQuad(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, ptr noundef captures(none) %4, ptr noundef readonly captures(none) %5, ptr noundef writeonly captures(none) initializes((0, 32)) %6, i32 noundef %7) local_unnamed_addr #10 {
  %9 = icmp eq i32 %7, 0
  %10 = select i1 %9, float -5.000000e-01, float 0.000000e+00
  %11 = sitofp i32 %1 to float
  %12 = fdiv float 1.000000e+00, %11
  %13 = sitofp i32 %2 to float
  %14 = fdiv float 1.000000e+00, %13
  %15 = sext i32 %3 to i64
  %16 = getelementptr inbounds %struct.stbtt_bakedchar, ptr %0, i64 %15
  %17 = load float, ptr %4, align 4, !tbaa !58
  %18 = getelementptr inbounds nuw i8, ptr %16, i64 8
  %19 = load float, ptr %18, align 4, !tbaa !59
  %20 = fadd float %17, %19
  %21 = fadd float %20, 5.000000e-01
  %22 = tail call float @floorf(float noundef %21) #28
  %23 = fptosi float %22 to i32
  %24 = load float, ptr %5, align 4, !tbaa !58
  %25 = getelementptr inbounds nuw i8, ptr %16, i64 12
  %26 = load float, ptr %25, align 4, !tbaa !61
  %27 = fadd float %24, %26
  %28 = fadd float %27, 5.000000e-01
  %29 = tail call float @floorf(float noundef %28) #28
  %30 = fptosi float %29 to i32
  %31 = sitofp i32 %23 to float
  %32 = fadd float %10, %31
  store float %32, ptr %6, align 4, !tbaa !62
  %33 = sitofp i32 %30 to float
  %34 = fadd float %10, %33
  %35 = getelementptr inbounds nuw i8, ptr %6, i64 4
  store float %34, ptr %35, align 4, !tbaa !64
  %36 = getelementptr inbounds nuw i8, ptr %16, i64 4
  %37 = load i16, ptr %36, align 4, !tbaa !65
  %38 = zext i16 %37 to i32
  %39 = add nsw i32 %38, %23
  %40 = load i16, ptr %16, align 4, !tbaa !66
  %41 = zext i16 %40 to i32
  %42 = sub i32 %39, %41
  %43 = sitofp i32 %42 to float
  %44 = fadd float %10, %43
  %45 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store float %44, ptr %45, align 4, !tbaa !67
  %46 = getelementptr inbounds nuw i8, ptr %16, i64 6
  %47 = load i16, ptr %46, align 2, !tbaa !68
  %48 = zext i16 %47 to i32
  %49 = add nsw i32 %48, %30
  %50 = getelementptr inbounds nuw i8, ptr %16, i64 2
  %51 = load i16, ptr %50, align 2, !tbaa !69
  %52 = zext i16 %51 to i32
  %53 = sub i32 %49, %52
  %54 = sitofp i32 %53 to float
  %55 = fadd float %10, %54
  %56 = getelementptr inbounds nuw i8, ptr %6, i64 20
  store float %55, ptr %56, align 4, !tbaa !70
  %57 = uitofp i16 %40 to float
  %58 = fmul float %12, %57
  %59 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store float %58, ptr %59, align 4, !tbaa !71
  %60 = uitofp i16 %51 to float
  %61 = fmul float %14, %60
  %62 = getelementptr inbounds nuw i8, ptr %6, i64 12
  store float %61, ptr %62, align 4, !tbaa !72
  %63 = uitofp i16 %37 to float
  %64 = fmul float %12, %63
  %65 = getelementptr inbounds nuw i8, ptr %6, i64 24
  store float %64, ptr %65, align 4, !tbaa !73
  %66 = uitofp i16 %47 to float
  %67 = fmul float %14, %66
  %68 = getelementptr inbounds nuw i8, ptr %6, i64 28
  store float %67, ptr %68, align 4, !tbaa !74
  %69 = getelementptr inbounds nuw i8, ptr %16, i64 16
  %70 = load float, ptr %69, align 4, !tbaa !75
  %71 = load float, ptr %4, align 4, !tbaa !58
  %72 = fadd float %70, %71
  store float %72, ptr %4, align 4, !tbaa !58
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local noundef i32 @stbtt_PackBegin(ptr noundef readnone captures(none) %0, ptr noundef readnone captures(none) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, i32 noundef %5, ptr noundef readnone captures(none) %6) local_unnamed_addr #7 {
  ret i32 0
}

; Function Attrs: nounwind
declare ptr @memset(ptr noundef, i32 noundef, i64 noundef) local_unnamed_addr #11

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local void @stbtt_PackEnd(ptr noundef readnone captures(none) %0) local_unnamed_addr #7 {
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @stbtt_PackSetOversampling(ptr noundef writeonly captures(none) %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #12 {
  %4 = icmp ult i32 %1, 9
  br i1 %4, label %5, label %7

5:                                                ; preds = %3
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 36
  store i32 %1, ptr %6, align 4, !tbaa !76
  br label %7

7:                                                ; preds = %5, %3
  %8 = icmp ult i32 %2, 9
  br i1 %8, label %9, label %11

9:                                                ; preds = %7
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 40
  store i32 %2, ptr %10, align 8, !tbaa !78
  br label %11

11:                                               ; preds = %9, %7
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define dso_local void @stbtt_PackSetSkipMissingCodepoints(ptr noundef writeonly captures(none) initializes((32, 36)) %0, i32 noundef %1) local_unnamed_addr #12 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store i32 %1, ptr %3, align 8, !tbaa !79
  ret void
}

; Function Attrs: nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local i32 @stbtt_PackFontRangesGatherRects(ptr noundef readonly captures(none) %0, ptr noundef readonly captures(none) %1, ptr noundef captures(none) %2, i32 noundef %3, ptr noundef writeonly captures(none) %4) local_unnamed_addr #3 {
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = icmp sgt i32 %3, 0
  br i1 %10, label %11, label %175

11:                                               ; preds = %5
  %12 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %13 = getelementptr inbounds nuw i8, ptr %1, i64 28
  %14 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %15 = getelementptr inbounds nuw i8, ptr %1, i64 36
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %20 = zext nneg i32 %3 to i64
  br label %21

21:                                               ; preds = %11, %170
  %22 = phi i64 [ 0, %11 ], [ %173, %170 ]
  %23 = phi i32 [ 0, %11 ], [ %172, %170 ]
  %24 = phi i32 [ 0, %11 ], [ %171, %170 ]
  %25 = getelementptr inbounds nuw %struct.stbtt_pack_range, ptr %2, i64 %22
  %26 = load float, ptr %25, align 8, !tbaa !80
  %27 = fcmp ogt float %26, 0.000000e+00
  br i1 %27, label %28, label %54

28:                                               ; preds = %21
  %29 = load ptr, ptr %14, align 8, !tbaa !8
  %30 = load i32, ptr %15, align 4, !tbaa !37
  %31 = sext i32 %30 to i64
  %32 = getelementptr inbounds i8, ptr %29, i64 %31
  %33 = getelementptr inbounds nuw i8, ptr %32, i64 4
  %34 = load i8, ptr %33, align 1, !tbaa !14
  %35 = zext i8 %34 to i16
  %36 = shl nuw i16 %35, 8
  %37 = getelementptr inbounds nuw i8, ptr %32, i64 5
  %38 = load i8, ptr %37, align 1, !tbaa !14
  %39 = zext i8 %38 to i16
  %40 = or disjoint i16 %36, %39
  %41 = sext i16 %40 to i32
  %42 = getelementptr inbounds nuw i8, ptr %32, i64 6
  %43 = load i8, ptr %42, align 1, !tbaa !14
  %44 = zext i8 %43 to i16
  %45 = shl nuw i16 %44, 8
  %46 = getelementptr inbounds nuw i8, ptr %32, i64 7
  %47 = load i8, ptr %46, align 1, !tbaa !14
  %48 = zext i8 %47 to i16
  %49 = or disjoint i16 %45, %48
  %50 = sext i16 %49 to i32
  %51 = sub nsw i32 %41, %50
  %52 = sitofp i32 %51 to float
  %53 = fdiv float %26, %52
  br label %70

54:                                               ; preds = %21
  %55 = fneg float %26
  %56 = load ptr, ptr %12, align 8, !tbaa !8
  %57 = load i32, ptr %13, align 4, !tbaa !54
  %58 = sext i32 %57 to i64
  %59 = getelementptr inbounds i8, ptr %56, i64 %58
  %60 = getelementptr inbounds nuw i8, ptr %59, i64 18
  %61 = load i8, ptr %60, align 1, !tbaa !14
  %62 = zext i8 %61 to i16
  %63 = shl nuw i16 %62, 8
  %64 = getelementptr inbounds nuw i8, ptr %59, i64 19
  %65 = load i8, ptr %64, align 1, !tbaa !14
  %66 = zext i8 %65 to i16
  %67 = or disjoint i16 %63, %66
  %68 = uitofp i16 %67 to float
  %69 = fdiv float %55, %68
  br label %70

70:                                               ; preds = %54, %28
  %71 = phi float [ %53, %28 ], [ %69, %54 ]
  %72 = load i32, ptr %16, align 4, !tbaa !76
  %73 = trunc i32 %72 to i8
  %74 = getelementptr inbounds nuw i8, ptr %25, i64 32
  store i8 %73, ptr %74, align 8, !tbaa !83
  %75 = load i32, ptr %17, align 8, !tbaa !78
  %76 = trunc i32 %75 to i8
  %77 = getelementptr inbounds nuw i8, ptr %25, i64 33
  store i8 %76, ptr %77, align 1, !tbaa !84
  %78 = getelementptr inbounds nuw i8, ptr %25, i64 16
  %79 = load i32, ptr %78, align 8, !tbaa !85
  %80 = icmp sgt i32 %79, 0
  br i1 %80, label %81, label %170

81:                                               ; preds = %70
  %82 = getelementptr inbounds nuw i8, ptr %25, i64 8
  %83 = getelementptr inbounds nuw i8, ptr %25, i64 4
  %84 = sext i32 %23 to i64
  br label %85

85:                                               ; preds = %81, %161
  %86 = phi i64 [ %84, %81 ], [ %163, %161 ]
  %87 = phi i64 [ 0, %81 ], [ %164, %161 ]
  %88 = phi i32 [ %24, %81 ], [ %162, %161 ]
  %89 = load ptr, ptr %82, align 8, !tbaa !86
  %90 = icmp eq ptr %89, null
  br i1 %90, label %91, label %95

91:                                               ; preds = %85
  %92 = load i32, ptr %83, align 4, !tbaa !87
  %93 = trunc nuw nsw i64 %87 to i32
  %94 = add nsw i32 %92, %93
  br label %98

95:                                               ; preds = %85
  %96 = getelementptr inbounds nuw i32, ptr %89, i64 %87
  %97 = load i32, ptr %96, align 4, !tbaa !4
  br label %98

98:                                               ; preds = %95, %91
  %99 = phi i32 [ %94, %91 ], [ %97, %95 ]
  %100 = call i32 @stbtt_FindGlyphIndex(ptr noundef %1, i32 noundef %99) #25
  %101 = icmp eq i32 %100, 0
  br i1 %101, label %102, label %111

102:                                              ; preds = %98
  %103 = load i32, ptr %18, align 8, !tbaa !79
  %104 = icmp ne i32 %103, 0
  %105 = icmp ne i32 %88, 0
  %106 = select i1 %104, i1 true, i1 %105
  br i1 %106, label %107, label %111

107:                                              ; preds = %102
  %108 = getelementptr inbounds %struct.stbrp_rect, ptr %4, i64 %86
  %109 = getelementptr inbounds nuw i8, ptr %108, i64 16
  store i32 0, ptr %109, align 4, !tbaa !88
  %110 = getelementptr inbounds nuw i8, ptr %108, i64 12
  store i32 0, ptr %110, align 4, !tbaa !90
  br label %161

111:                                              ; preds = %102, %98
  %112 = load i32, ptr %16, align 4, !tbaa !76
  %113 = load i32, ptr %17, align 8, !tbaa !78
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #26
  store i32 0, ptr %6, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #26
  store i32 0, ptr %7, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %8) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %9) #26
  %114 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %1, i32 noundef %100, ptr noundef nonnull %6, ptr noundef nonnull %7, ptr noundef nonnull %8, ptr noundef nonnull %9) #25
  %115 = icmp eq i32 %114, 0
  br i1 %115, label %145, label %116

116:                                              ; preds = %111
  %117 = uitofp i32 %113 to float
  %118 = fmul float %71, %117
  %119 = uitofp i32 %112 to float
  %120 = fmul float %71, %119
  %121 = load i32, ptr %6, align 4, !tbaa !4
  %122 = sitofp i32 %121 to float
  %123 = call float @llvm.fmuladd.f32(float %122, float %120, float 0.000000e+00)
  %124 = call float @floorf(float noundef %123) #28
  %125 = fptosi float %124 to i32
  %126 = load i32, ptr %9, align 4, !tbaa !4
  %127 = sub nsw i32 0, %126
  %128 = sitofp i32 %127 to float
  %129 = call float @llvm.fmuladd.f32(float %128, float %118, float 0.000000e+00)
  %130 = call float @floorf(float noundef %129) #28
  %131 = fptosi float %130 to i32
  %132 = load i32, ptr %8, align 4, !tbaa !4
  %133 = sitofp i32 %132 to float
  %134 = call float @llvm.fmuladd.f32(float %133, float %120, float 0.000000e+00)
  %135 = call float @ceilf(float noundef %134) #28
  %136 = fptosi float %135 to i32
  %137 = load i32, ptr %7, align 4, !tbaa !4
  %138 = sub nsw i32 0, %137
  %139 = sitofp i32 %138 to float
  %140 = call float @llvm.fmuladd.f32(float %139, float %118, float 0.000000e+00)
  %141 = call float @ceilf(float noundef %140) #28
  %142 = fptosi float %141 to i32
  %143 = sub nsw i32 %136, %125
  %144 = sub nsw i32 %142, %131
  br label %145

145:                                              ; preds = %111, %116
  %146 = phi i32 [ %143, %116 ], [ 0, %111 ]
  %147 = phi i32 [ %144, %116 ], [ 0, %111 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %9) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %8) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  %148 = load i32, ptr %19, align 4, !tbaa !91
  %149 = load i32, ptr %16, align 4, !tbaa !76
  %150 = add i32 %148, -1
  %151 = add i32 %150, %146
  %152 = add i32 %151, %149
  %153 = getelementptr inbounds %struct.stbrp_rect, ptr %4, i64 %86
  %154 = getelementptr inbounds nuw i8, ptr %153, i64 12
  store i32 %152, ptr %154, align 4, !tbaa !90
  %155 = load i32, ptr %17, align 8, !tbaa !78
  %156 = add i32 %148, -1
  %157 = add i32 %156, %147
  %158 = add i32 %157, %155
  %159 = getelementptr inbounds nuw i8, ptr %153, i64 16
  store i32 %158, ptr %159, align 4, !tbaa !88
  %160 = select i1 %101, i32 1, i32 %88
  br label %161

161:                                              ; preds = %145, %107
  %162 = phi i32 [ %88, %107 ], [ %160, %145 ]
  %163 = add nsw i64 %86, 1
  %164 = add nuw nsw i64 %87, 1
  %165 = load i32, ptr %78, align 8, !tbaa !85
  %166 = sext i32 %165 to i64
  %167 = icmp slt i64 %164, %166
  br i1 %167, label %85, label %168, !llvm.loop !92

168:                                              ; preds = %161
  %169 = trunc nsw i64 %163 to i32
  br label %170

170:                                              ; preds = %168, %70
  %171 = phi i32 [ %24, %70 ], [ %162, %168 ]
  %172 = phi i32 [ %23, %70 ], [ %169, %168 ]
  %173 = add nuw nsw i64 %22, 1
  %174 = icmp eq i64 %173, %20
  br i1 %174, label %175, label %21, !llvm.loop !93

175:                                              ; preds = %170, %5
  %176 = phi i32 [ 0, %5 ], [ %172, %170 ]
  ret i32 %176
}

; Function Attrs: nounwind
define internal fastcc void @stbtt__h_prefilter(ptr noundef captures(none) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef range(i32 2, 0) %4) unnamed_addr #2 {
  %6 = alloca [8 x i8], align 1
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #26
  %7 = call ptr @memset(ptr noundef nonnull %6, i32 noundef 0, i64 noundef 8) #27
  %8 = icmp sgt i32 %2, 0
  br i1 %8, label %9, label %165

9:                                                ; preds = %5
  %10 = sub i32 %1, %4
  %11 = zext i32 %4 to i64
  %12 = icmp slt i32 %10, 0
  %13 = icmp slt i32 %10, 0
  %14 = icmp slt i32 %10, 0
  %15 = icmp slt i32 %10, 0
  %16 = icmp slt i32 %10, 0
  %17 = sext i32 %3 to i64
  %18 = add i32 %1, 1
  %19 = sub i32 %18, %4
  %20 = zext i32 %19 to i64
  %21 = zext i32 %19 to i64
  %22 = zext i32 %19 to i64
  %23 = zext i32 %19 to i64
  %24 = zext i32 %19 to i64
  br label %25

25:                                               ; preds = %9, %161
  %26 = phi i32 [ 0, %9 ], [ %163, %161 ]
  %27 = phi ptr [ %0, %9 ], [ %162, %161 ]
  %28 = call ptr @memset(ptr noundef nonnull %6, i32 noundef 0, i64 noundef %11) #27
  switch i32 %4, label %33 [
    i32 2, label %32
    i32 3, label %31
    i32 4, label %30
    i32 5, label %29
  ]

29:                                               ; preds = %25
  br i1 %12, label %141, label %91

30:                                               ; preds = %25
  br i1 %13, label %141, label %72

31:                                               ; preds = %25
  br i1 %14, label %141, label %53

32:                                               ; preds = %25
  br i1 %15, label %141, label %34

33:                                               ; preds = %25
  br i1 %16, label %141, label %110

34:                                               ; preds = %32, %34
  %35 = phi i64 [ %51, %34 ], [ 0, %32 ]
  %36 = phi i32 [ %45, %34 ], [ 0, %32 ]
  %37 = getelementptr inbounds nuw i8, ptr %27, i64 %35
  %38 = load i8, ptr %37, align 1, !tbaa !14
  %39 = zext i8 %38 to i32
  %40 = and i64 %35, 7
  %41 = getelementptr inbounds nuw i8, ptr %6, i64 %40
  %42 = load i8, ptr %41, align 1, !tbaa !14
  %43 = zext i8 %42 to i32
  %44 = sub nsw i32 %39, %43
  %45 = add i32 %44, %36
  %46 = add nuw i64 %35, 2
  %47 = and i64 %46, 7
  %48 = getelementptr inbounds nuw i8, ptr %6, i64 %47
  store i8 %38, ptr %48, align 1, !tbaa !14
  %49 = lshr i32 %45, 1
  %50 = trunc i32 %49 to i8
  store i8 %50, ptr %37, align 1, !tbaa !14
  %51 = add nuw nsw i64 %35, 1
  %52 = icmp eq i64 %51, %23
  br i1 %52, label %133, label %34, !llvm.loop !94

53:                                               ; preds = %31, %53
  %54 = phi i64 [ %70, %53 ], [ 0, %31 ]
  %55 = phi i32 [ %64, %53 ], [ 0, %31 ]
  %56 = getelementptr inbounds nuw i8, ptr %27, i64 %54
  %57 = load i8, ptr %56, align 1, !tbaa !14
  %58 = zext i8 %57 to i32
  %59 = and i64 %54, 7
  %60 = getelementptr inbounds nuw i8, ptr %6, i64 %59
  %61 = load i8, ptr %60, align 1, !tbaa !14
  %62 = zext i8 %61 to i32
  %63 = sub nsw i32 %58, %62
  %64 = add i32 %63, %55
  %65 = add nuw i64 %54, 3
  %66 = and i64 %65, 7
  %67 = getelementptr inbounds nuw i8, ptr %6, i64 %66
  store i8 %57, ptr %67, align 1, !tbaa !14
  %68 = udiv i32 %64, 3
  %69 = trunc i32 %68 to i8
  store i8 %69, ptr %56, align 1, !tbaa !14
  %70 = add nuw nsw i64 %54, 1
  %71 = icmp eq i64 %70, %22
  br i1 %71, label %135, label %53, !llvm.loop !95

72:                                               ; preds = %30, %72
  %73 = phi i64 [ %89, %72 ], [ 0, %30 ]
  %74 = phi i32 [ %84, %72 ], [ 0, %30 ]
  %75 = getelementptr inbounds nuw i8, ptr %27, i64 %73
  %76 = load i8, ptr %75, align 1, !tbaa !14
  %77 = zext i8 %76 to i32
  %78 = and i64 %73, 7
  %79 = and i64 %73, 7
  %80 = getelementptr inbounds nuw i8, ptr %6, i64 %79
  %81 = load i8, ptr %80, align 1, !tbaa !14
  %82 = zext i8 %81 to i32
  %83 = sub nsw i32 %77, %82
  %84 = add i32 %83, %74
  %85 = xor i64 %78, 4
  %86 = getelementptr inbounds nuw i8, ptr %6, i64 %85
  store i8 %76, ptr %86, align 1, !tbaa !14
  %87 = lshr i32 %84, 2
  %88 = trunc i32 %87 to i8
  store i8 %88, ptr %75, align 1, !tbaa !14
  %89 = add nuw nsw i64 %73, 1
  %90 = icmp eq i64 %89, %21
  br i1 %90, label %137, label %72, !llvm.loop !96

91:                                               ; preds = %29, %91
  %92 = phi i64 [ %108, %91 ], [ 0, %29 ]
  %93 = phi i32 [ %102, %91 ], [ 0, %29 ]
  %94 = getelementptr inbounds nuw i8, ptr %27, i64 %92
  %95 = load i8, ptr %94, align 1, !tbaa !14
  %96 = zext i8 %95 to i32
  %97 = and i64 %92, 7
  %98 = getelementptr inbounds nuw i8, ptr %6, i64 %97
  %99 = load i8, ptr %98, align 1, !tbaa !14
  %100 = zext i8 %99 to i32
  %101 = sub nsw i32 %96, %100
  %102 = add i32 %101, %93
  %103 = add nuw i64 %92, 5
  %104 = and i64 %103, 7
  %105 = getelementptr inbounds nuw i8, ptr %6, i64 %104
  store i8 %95, ptr %105, align 1, !tbaa !14
  %106 = udiv i32 %102, 5
  %107 = trunc i32 %106 to i8
  store i8 %107, ptr %94, align 1, !tbaa !14
  %108 = add nuw nsw i64 %92, 1
  %109 = icmp eq i64 %108, %20
  br i1 %109, label %139, label %91, !llvm.loop !97

110:                                              ; preds = %33, %110
  %111 = phi i64 [ %129, %110 ], [ 0, %33 ]
  %112 = phi i32 [ %121, %110 ], [ 0, %33 ]
  %113 = getelementptr inbounds nuw i8, ptr %27, i64 %111
  %114 = load i8, ptr %113, align 1, !tbaa !14
  %115 = zext i8 %114 to i32
  %116 = and i64 %111, 7
  %117 = getelementptr inbounds nuw i8, ptr %6, i64 %116
  %118 = load i8, ptr %117, align 1, !tbaa !14
  %119 = zext i8 %118 to i32
  %120 = sub nsw i32 %115, %119
  %121 = add i32 %120, %112
  %122 = trunc nuw nsw i64 %111 to i32
  %123 = add i32 %4, %122
  %124 = and i32 %123, 7
  %125 = zext nneg i32 %124 to i64
  %126 = getelementptr inbounds nuw i8, ptr %6, i64 %125
  store i8 %114, ptr %126, align 1, !tbaa !14
  %127 = udiv i32 %121, %4
  %128 = trunc i32 %127 to i8
  store i8 %128, ptr %113, align 1, !tbaa !14
  %129 = add nuw nsw i64 %111, 1
  %130 = icmp eq i64 %129, %24
  br i1 %130, label %131, label %110, !llvm.loop !98

131:                                              ; preds = %110
  %132 = trunc nuw i64 %129 to i32
  br label %141

133:                                              ; preds = %34
  %134 = trunc nuw i64 %51 to i32
  br label %141

135:                                              ; preds = %53
  %136 = trunc nuw i64 %70 to i32
  br label %141

137:                                              ; preds = %72
  %138 = trunc nuw i64 %89 to i32
  br label %141

139:                                              ; preds = %91
  %140 = trunc nuw i64 %108 to i32
  br label %141

141:                                              ; preds = %139, %137, %135, %133, %131, %29, %30, %31, %32, %33
  %142 = phi i32 [ %134, %133 ], [ %136, %135 ], [ %138, %137 ], [ %132, %131 ], [ 0, %33 ], [ 0, %32 ], [ 0, %31 ], [ 0, %30 ], [ 0, %29 ], [ %140, %139 ]
  %143 = phi i32 [ %45, %133 ], [ %64, %135 ], [ %84, %137 ], [ %121, %131 ], [ 0, %33 ], [ 0, %32 ], [ 0, %31 ], [ 0, %30 ], [ 0, %29 ], [ %102, %139 ]
  %144 = icmp slt i32 %142, %1
  br i1 %144, label %145, label %161

145:                                              ; preds = %141
  %146 = zext i32 %142 to i64
  br label %147

147:                                              ; preds = %145, %147
  %148 = phi i64 [ %146, %145 ], [ %158, %147 ]
  %149 = phi i32 [ %143, %145 ], [ %154, %147 ]
  %150 = and i64 %148, 7
  %151 = getelementptr inbounds nuw i8, ptr %6, i64 %150
  %152 = load i8, ptr %151, align 1, !tbaa !14
  %153 = zext i8 %152 to i32
  %154 = sub i32 %149, %153
  %155 = udiv i32 %154, %4
  %156 = trunc i32 %155 to i8
  %157 = getelementptr inbounds nuw i8, ptr %27, i64 %148
  store i8 %156, ptr %157, align 1, !tbaa !14
  %158 = add nuw nsw i64 %148, 1
  %159 = trunc nuw i64 %158 to i32
  %160 = icmp sgt i32 %1, %159
  br i1 %160, label %147, label %161, !llvm.loop !99

161:                                              ; preds = %147, %141
  %162 = getelementptr inbounds i8, ptr %27, i64 %17
  %163 = add nuw nsw i32 %26, 1
  %164 = icmp eq i32 %163, %2
  br i1 %164, label %165, label %25, !llvm.loop !100

165:                                              ; preds = %161, %5
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  ret void
}

; Function Attrs: nounwind
define internal fastcc void @stbtt__v_prefilter(ptr noundef captures(none) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef range(i32 2, 0) %4) unnamed_addr #2 {
  %6 = alloca [8 x i8], align 1
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #26
  %7 = call ptr @memset(ptr noundef nonnull %6, i32 noundef 0, i64 noundef 8) #27
  %8 = icmp sgt i32 %1, 0
  br i1 %8, label %9, label %178

9:                                                ; preds = %5
  %10 = sub i32 %2, %4
  %11 = zext i32 %4 to i64
  %12 = icmp slt i32 %10, 0
  %13 = icmp slt i32 %10, 0
  %14 = icmp slt i32 %10, 0
  %15 = icmp slt i32 %10, 0
  %16 = icmp slt i32 %10, 0
  %17 = sext i32 %3 to i64
  %18 = add i32 %2, 1
  %19 = sub i32 %18, %4
  %20 = sext i32 %3 to i64
  %21 = sext i32 %3 to i64
  %22 = sext i32 %3 to i64
  %23 = sext i32 %3 to i64
  %24 = add i32 %2, 1
  %25 = sub i32 %24, %4
  %26 = sext i32 %3 to i64
  %27 = zext i32 %19 to i64
  %28 = zext i32 %19 to i64
  %29 = zext i32 %19 to i64
  %30 = zext i32 %19 to i64
  %31 = zext i32 %25 to i64
  %32 = sext i32 %2 to i64
  br label %33

33:                                               ; preds = %9, %174
  %34 = phi i32 [ 0, %9 ], [ %176, %174 ]
  %35 = phi ptr [ %0, %9 ], [ %175, %174 ]
  %36 = call ptr @memset(ptr noundef nonnull %6, i32 noundef 0, i64 noundef %11) #27
  switch i32 %4, label %41 [
    i32 2, label %40
    i32 3, label %39
    i32 4, label %38
    i32 5, label %37
  ]

37:                                               ; preds = %33
  br i1 %12, label %154, label %102

38:                                               ; preds = %33
  br i1 %13, label %154, label %82

39:                                               ; preds = %33
  br i1 %14, label %154, label %62

40:                                               ; preds = %33
  br i1 %15, label %154, label %42

41:                                               ; preds = %33
  br i1 %16, label %154, label %122

42:                                               ; preds = %40, %42
  %43 = phi i64 [ %60, %42 ], [ 0, %40 ]
  %44 = phi i32 [ %54, %42 ], [ 0, %40 ]
  %45 = mul nsw i64 %43, %22
  %46 = getelementptr inbounds i8, ptr %35, i64 %45
  %47 = load i8, ptr %46, align 1, !tbaa !14
  %48 = zext i8 %47 to i32
  %49 = and i64 %43, 7
  %50 = getelementptr inbounds nuw i8, ptr %6, i64 %49
  %51 = load i8, ptr %50, align 1, !tbaa !14
  %52 = zext i8 %51 to i32
  %53 = sub nsw i32 %48, %52
  %54 = add i32 %53, %44
  %55 = add nuw i64 %43, 2
  %56 = and i64 %55, 7
  %57 = getelementptr inbounds nuw i8, ptr %6, i64 %56
  store i8 %47, ptr %57, align 1, !tbaa !14
  %58 = lshr i32 %54, 1
  %59 = trunc i32 %58 to i8
  store i8 %59, ptr %46, align 1, !tbaa !14
  %60 = add nuw nsw i64 %43, 1
  %61 = icmp eq i64 %60, %30
  br i1 %61, label %146, label %42, !llvm.loop !101

62:                                               ; preds = %39, %62
  %63 = phi i64 [ %80, %62 ], [ 0, %39 ]
  %64 = phi i32 [ %74, %62 ], [ 0, %39 ]
  %65 = mul nsw i64 %63, %21
  %66 = getelementptr inbounds i8, ptr %35, i64 %65
  %67 = load i8, ptr %66, align 1, !tbaa !14
  %68 = zext i8 %67 to i32
  %69 = and i64 %63, 7
  %70 = getelementptr inbounds nuw i8, ptr %6, i64 %69
  %71 = load i8, ptr %70, align 1, !tbaa !14
  %72 = zext i8 %71 to i32
  %73 = sub nsw i32 %68, %72
  %74 = add i32 %73, %64
  %75 = add nuw i64 %63, 3
  %76 = and i64 %75, 7
  %77 = getelementptr inbounds nuw i8, ptr %6, i64 %76
  store i8 %67, ptr %77, align 1, !tbaa !14
  %78 = udiv i32 %74, 3
  %79 = trunc i32 %78 to i8
  store i8 %79, ptr %66, align 1, !tbaa !14
  %80 = add nuw nsw i64 %63, 1
  %81 = icmp eq i64 %80, %29
  br i1 %81, label %148, label %62, !llvm.loop !102

82:                                               ; preds = %38, %82
  %83 = phi i64 [ %100, %82 ], [ 0, %38 ]
  %84 = phi i32 [ %95, %82 ], [ 0, %38 ]
  %85 = mul nsw i64 %83, %20
  %86 = getelementptr inbounds i8, ptr %35, i64 %85
  %87 = load i8, ptr %86, align 1, !tbaa !14
  %88 = zext i8 %87 to i32
  %89 = and i64 %83, 7
  %90 = and i64 %83, 7
  %91 = getelementptr inbounds nuw i8, ptr %6, i64 %90
  %92 = load i8, ptr %91, align 1, !tbaa !14
  %93 = zext i8 %92 to i32
  %94 = sub nsw i32 %88, %93
  %95 = add i32 %94, %84
  %96 = xor i64 %89, 4
  %97 = getelementptr inbounds nuw i8, ptr %6, i64 %96
  store i8 %87, ptr %97, align 1, !tbaa !14
  %98 = lshr i32 %95, 2
  %99 = trunc i32 %98 to i8
  store i8 %99, ptr %86, align 1, !tbaa !14
  %100 = add nuw nsw i64 %83, 1
  %101 = icmp eq i64 %100, %28
  br i1 %101, label %150, label %82, !llvm.loop !103

102:                                              ; preds = %37, %102
  %103 = phi i64 [ %120, %102 ], [ 0, %37 ]
  %104 = phi i32 [ %114, %102 ], [ 0, %37 ]
  %105 = mul nsw i64 %103, %17
  %106 = getelementptr inbounds i8, ptr %35, i64 %105
  %107 = load i8, ptr %106, align 1, !tbaa !14
  %108 = zext i8 %107 to i32
  %109 = and i64 %103, 7
  %110 = getelementptr inbounds nuw i8, ptr %6, i64 %109
  %111 = load i8, ptr %110, align 1, !tbaa !14
  %112 = zext i8 %111 to i32
  %113 = sub nsw i32 %108, %112
  %114 = add i32 %113, %104
  %115 = add nuw i64 %103, 5
  %116 = and i64 %115, 7
  %117 = getelementptr inbounds nuw i8, ptr %6, i64 %116
  store i8 %107, ptr %117, align 1, !tbaa !14
  %118 = udiv i32 %114, 5
  %119 = trunc i32 %118 to i8
  store i8 %119, ptr %106, align 1, !tbaa !14
  %120 = add nuw nsw i64 %103, 1
  %121 = icmp eq i64 %120, %27
  br i1 %121, label %152, label %102, !llvm.loop !104

122:                                              ; preds = %41, %122
  %123 = phi i64 [ %142, %122 ], [ 0, %41 ]
  %124 = phi i32 [ %134, %122 ], [ 0, %41 ]
  %125 = mul nsw i64 %123, %23
  %126 = getelementptr inbounds i8, ptr %35, i64 %125
  %127 = load i8, ptr %126, align 1, !tbaa !14
  %128 = zext i8 %127 to i32
  %129 = and i64 %123, 7
  %130 = getelementptr inbounds nuw i8, ptr %6, i64 %129
  %131 = load i8, ptr %130, align 1, !tbaa !14
  %132 = zext i8 %131 to i32
  %133 = sub nsw i32 %128, %132
  %134 = add i32 %133, %124
  %135 = trunc nuw nsw i64 %123 to i32
  %136 = add i32 %4, %135
  %137 = and i32 %136, 7
  %138 = zext nneg i32 %137 to i64
  %139 = getelementptr inbounds nuw i8, ptr %6, i64 %138
  store i8 %127, ptr %139, align 1, !tbaa !14
  %140 = udiv i32 %134, %4
  %141 = trunc i32 %140 to i8
  store i8 %141, ptr %126, align 1, !tbaa !14
  %142 = add nuw nsw i64 %123, 1
  %143 = icmp eq i64 %142, %31
  br i1 %143, label %144, label %122, !llvm.loop !105

144:                                              ; preds = %122
  %145 = trunc nsw i64 %142 to i32
  br label %154

146:                                              ; preds = %42
  %147 = trunc nsw i64 %60 to i32
  br label %154

148:                                              ; preds = %62
  %149 = trunc nsw i64 %80 to i32
  br label %154

150:                                              ; preds = %82
  %151 = trunc nsw i64 %100 to i32
  br label %154

152:                                              ; preds = %102
  %153 = trunc nsw i64 %120 to i32
  br label %154

154:                                              ; preds = %152, %150, %148, %146, %144, %37, %38, %39, %40, %41
  %155 = phi i32 [ %147, %146 ], [ %149, %148 ], [ %151, %150 ], [ %145, %144 ], [ 0, %41 ], [ 0, %40 ], [ 0, %39 ], [ 0, %38 ], [ 0, %37 ], [ %153, %152 ]
  %156 = phi i32 [ %54, %146 ], [ %74, %148 ], [ %95, %150 ], [ %134, %144 ], [ 0, %41 ], [ 0, %40 ], [ 0, %39 ], [ 0, %38 ], [ 0, %37 ], [ %114, %152 ]
  %157 = icmp slt i32 %155, %2
  br i1 %157, label %158, label %174

158:                                              ; preds = %154
  %159 = sext i32 %155 to i64
  br label %160

160:                                              ; preds = %158, %160
  %161 = phi i64 [ %159, %158 ], [ %172, %160 ]
  %162 = phi i32 [ %156, %158 ], [ %167, %160 ]
  %163 = and i64 %161, 7
  %164 = getelementptr inbounds nuw i8, ptr %6, i64 %163
  %165 = load i8, ptr %164, align 1, !tbaa !14
  %166 = zext i8 %165 to i32
  %167 = sub i32 %162, %166
  %168 = udiv i32 %167, %4
  %169 = trunc i32 %168 to i8
  %170 = mul nsw i64 %161, %26
  %171 = getelementptr inbounds i8, ptr %35, i64 %170
  store i8 %169, ptr %171, align 1, !tbaa !14
  %172 = add nsw i64 %161, 1
  %173 = icmp eq i64 %172, %32
  br i1 %173, label %174, label %160, !llvm.loop !106

174:                                              ; preds = %160, %154
  %175 = getelementptr inbounds nuw i8, ptr %35, i64 1
  %176 = add nuw nsw i32 %34, 1
  %177 = icmp eq i32 %176, %1
  br i1 %177, label %178, label %33, !llvm.loop !107

178:                                              ; preds = %174, %5
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  ret void
}

; Function Attrs: nounwind
define dso_local range(i32 0, 2) i32 @stbtt_PackFontRangesRenderIntoRects(ptr noundef captures(none) %0, ptr noundef readonly captures(none) %1, ptr noundef readonly captures(none) %2, i32 noundef %3, ptr noundef captures(none) %4) local_unnamed_addr #2 {
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca ptr, align 8
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %16 = load i32, ptr %15, align 4, !tbaa !76
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %18 = load i32, ptr %17, align 8, !tbaa !78
  %19 = icmp sgt i32 %3, 0
  br i1 %19, label %20, label %325

20:                                               ; preds = %5
  %21 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %22 = getelementptr inbounds nuw i8, ptr %1, i64 28
  %23 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %24 = getelementptr inbounds nuw i8, ptr %1, i64 36
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %26 = getelementptr inbounds nuw i8, ptr %1, i64 8
  %27 = getelementptr inbounds nuw i8, ptr %1, i64 36
  %28 = getelementptr inbounds nuw i8, ptr %1, i64 40
  %29 = getelementptr inbounds nuw i8, ptr %1, i64 40
  %30 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %31 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %32 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %33 = zext nneg i32 %3 to i64
  br label %34

34:                                               ; preds = %20, %319
  %35 = phi i64 [ 0, %20 ], [ %323, %319 ]
  %36 = phi i32 [ 0, %20 ], [ %322, %319 ]
  %37 = phi i32 [ -1, %20 ], [ %321, %319 ]
  %38 = phi i32 [ 1, %20 ], [ %320, %319 ]
  %39 = getelementptr inbounds nuw %struct.stbtt_pack_range, ptr %2, i64 %35
  %40 = load float, ptr %39, align 8, !tbaa !80
  %41 = fcmp ogt float %40, 0.000000e+00
  br i1 %41, label %42, label %68

42:                                               ; preds = %34
  %43 = load ptr, ptr %23, align 8, !tbaa !8
  %44 = load i32, ptr %24, align 4, !tbaa !37
  %45 = sext i32 %44 to i64
  %46 = getelementptr inbounds i8, ptr %43, i64 %45
  %47 = getelementptr inbounds nuw i8, ptr %46, i64 4
  %48 = load i8, ptr %47, align 1, !tbaa !14
  %49 = zext i8 %48 to i16
  %50 = shl nuw i16 %49, 8
  %51 = getelementptr inbounds nuw i8, ptr %46, i64 5
  %52 = load i8, ptr %51, align 1, !tbaa !14
  %53 = zext i8 %52 to i16
  %54 = or disjoint i16 %50, %53
  %55 = sext i16 %54 to i32
  %56 = getelementptr inbounds nuw i8, ptr %46, i64 6
  %57 = load i8, ptr %56, align 1, !tbaa !14
  %58 = zext i8 %57 to i16
  %59 = shl nuw i16 %58, 8
  %60 = getelementptr inbounds nuw i8, ptr %46, i64 7
  %61 = load i8, ptr %60, align 1, !tbaa !14
  %62 = zext i8 %61 to i16
  %63 = or disjoint i16 %59, %62
  %64 = sext i16 %63 to i32
  %65 = sub nsw i32 %55, %64
  %66 = sitofp i32 %65 to float
  %67 = fdiv float %40, %66
  br label %84

68:                                               ; preds = %34
  %69 = fneg float %40
  %70 = load ptr, ptr %21, align 8, !tbaa !8
  %71 = load i32, ptr %22, align 4, !tbaa !54
  %72 = sext i32 %71 to i64
  %73 = getelementptr inbounds i8, ptr %70, i64 %72
  %74 = getelementptr inbounds nuw i8, ptr %73, i64 18
  %75 = load i8, ptr %74, align 1, !tbaa !14
  %76 = zext i8 %75 to i16
  %77 = shl nuw i16 %76, 8
  %78 = getelementptr inbounds nuw i8, ptr %73, i64 19
  %79 = load i8, ptr %78, align 1, !tbaa !14
  %80 = zext i8 %79 to i16
  %81 = or disjoint i16 %77, %80
  %82 = uitofp i16 %81 to float
  %83 = fdiv float %69, %82
  br label %84

84:                                               ; preds = %68, %42
  %85 = phi float [ %67, %42 ], [ %83, %68 ]
  %86 = getelementptr inbounds nuw i8, ptr %39, i64 32
  %87 = load i8, ptr %86, align 8, !tbaa !83
  %88 = zext i8 %87 to i32
  store i32 %88, ptr %15, align 4, !tbaa !76
  %89 = getelementptr inbounds nuw i8, ptr %39, i64 33
  %90 = load i8, ptr %89, align 1, !tbaa !84
  %91 = zext i8 %90 to i32
  store i32 %91, ptr %17, align 8, !tbaa !78
  %92 = uitofp i8 %87 to float
  %93 = fdiv float 1.000000e+00, %92
  %94 = uitofp i8 %90 to float
  %95 = fdiv float 1.000000e+00, %94
  %96 = icmp eq i8 %87, 0
  br i1 %96, label %103, label %97

97:                                               ; preds = %84
  %98 = sub nsw i32 1, %88
  %99 = sitofp i32 %98 to float
  %100 = uitofp i8 %87 to float
  %101 = fmul float %100, 2.000000e+00
  %102 = fdiv float %99, %101
  br label %103

103:                                              ; preds = %84, %97
  %104 = phi float [ %102, %97 ], [ 0.000000e+00, %84 ]
  %105 = icmp eq i8 %90, 0
  br i1 %105, label %112, label %106

106:                                              ; preds = %103
  %107 = sub nsw i32 1, %91
  %108 = sitofp i32 %107 to float
  %109 = uitofp i8 %90 to float
  %110 = fmul float %109, 2.000000e+00
  %111 = fdiv float %108, %110
  br label %112

112:                                              ; preds = %103, %106
  %113 = phi float [ %111, %106 ], [ 0.000000e+00, %103 ]
  %114 = getelementptr inbounds nuw i8, ptr %39, i64 16
  %115 = load i32, ptr %114, align 8, !tbaa !85
  %116 = icmp sgt i32 %115, 0
  br i1 %116, label %117, label %319

117:                                              ; preds = %112
  %118 = getelementptr inbounds nuw i8, ptr %39, i64 24
  %119 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %120 = getelementptr inbounds nuw i8, ptr %39, i64 4
  %121 = getelementptr inbounds nuw i8, ptr %39, i64 24
  %122 = sext i32 %36 to i64
  br label %123

123:                                              ; preds = %117, %309
  %124 = phi i64 [ %122, %117 ], [ %312, %309 ]
  %125 = phi i64 [ 0, %117 ], [ %313, %309 ]
  %126 = phi i32 [ %37, %117 ], [ %311, %309 ]
  %127 = phi i32 [ %38, %117 ], [ %310, %309 ]
  %128 = getelementptr inbounds %struct.stbrp_rect, ptr %4, i64 %124
  %129 = getelementptr inbounds nuw i8, ptr %128, i64 20
  %130 = load i32, ptr %129, align 4, !tbaa !108
  %131 = icmp eq i32 %130, 0
  br i1 %131, label %290, label %132

132:                                              ; preds = %123
  %133 = getelementptr inbounds nuw i8, ptr %128, i64 12
  %134 = load i32, ptr %133, align 4, !tbaa !90
  %135 = icmp eq i32 %134, 0
  br i1 %135, label %290, label %136

136:                                              ; preds = %132
  %137 = getelementptr inbounds nuw i8, ptr %128, i64 16
  %138 = load i32, ptr %137, align 4, !tbaa !88
  %139 = icmp eq i32 %138, 0
  br i1 %139, label %290, label %140

140:                                              ; preds = %136
  %141 = load ptr, ptr %118, align 8, !tbaa !109
  %142 = getelementptr inbounds nuw %struct.stbtt_packedchar, ptr %141, i64 %125
  %143 = load ptr, ptr %119, align 8, !tbaa !86
  %144 = icmp eq ptr %143, null
  br i1 %144, label %145, label %149

145:                                              ; preds = %140
  %146 = load i32, ptr %120, align 4, !tbaa !87
  %147 = trunc nuw nsw i64 %125 to i32
  %148 = add nsw i32 %146, %147
  br label %152

149:                                              ; preds = %140
  %150 = getelementptr inbounds nuw i32, ptr %143, i64 %125
  %151 = load i32, ptr %150, align 4, !tbaa !4
  br label %152

152:                                              ; preds = %149, %145
  %153 = phi i32 [ %148, %145 ], [ %151, %149 ]
  %154 = call i32 @stbtt_FindGlyphIndex(ptr noundef %1, i32 noundef %153) #25
  %155 = load i32, ptr %25, align 4, !tbaa !91
  %156 = load i32, ptr %128, align 4, !tbaa !110
  %157 = add nsw i32 %156, %155
  store i32 %157, ptr %128, align 4, !tbaa !110
  %158 = getelementptr inbounds nuw i8, ptr %128, i64 4
  %159 = load i32, ptr %158, align 4, !tbaa !111
  %160 = add nsw i32 %159, %155
  store i32 %160, ptr %158, align 4, !tbaa !111
  %161 = sub nsw i32 %134, %155
  store i32 %161, ptr %133, align 4, !tbaa !90
  %162 = sub nsw i32 %138, %155
  store i32 %162, ptr %137, align 4, !tbaa !88
  %163 = load ptr, ptr %26, align 8, !tbaa !8
  %164 = load i32, ptr %27, align 4, !tbaa !37
  %165 = sext i32 %164 to i64
  %166 = getelementptr inbounds i8, ptr %163, i64 %165
  %167 = getelementptr inbounds nuw i8, ptr %166, i64 34
  %168 = load i8, ptr %167, align 1, !tbaa !14
  %169 = zext i8 %168 to i32
  %170 = shl nuw nsw i32 %169, 8
  %171 = getelementptr inbounds nuw i8, ptr %166, i64 35
  %172 = load i8, ptr %171, align 1, !tbaa !14
  %173 = zext i8 %172 to i32
  %174 = or disjoint i32 %170, %173
  %175 = icmp slt i32 %154, %174
  br i1 %175, label %176, label %184

176:                                              ; preds = %152
  %177 = load i32, ptr %29, align 8, !tbaa !38
  %178 = sext i32 %177 to i64
  %179 = getelementptr inbounds i8, ptr %163, i64 %178
  %180 = shl nsw i32 %154, 2
  %181 = sext i32 %180 to i64
  %182 = getelementptr inbounds i8, ptr %179, i64 %181
  %183 = getelementptr inbounds nuw i8, ptr %182, i64 1
  br label %193

184:                                              ; preds = %152
  %185 = load i32, ptr %28, align 8, !tbaa !38
  %186 = sext i32 %185 to i64
  %187 = getelementptr inbounds i8, ptr %163, i64 %186
  %188 = shl nuw nsw i32 %174, 2
  %189 = zext nneg i32 %188 to i64
  %190 = getelementptr i8, ptr %187, i64 %189
  %191 = getelementptr i8, ptr %190, i64 -4
  %192 = getelementptr i8, ptr %190, i64 -3
  br label %193

193:                                              ; preds = %176, %184
  %194 = phi ptr [ %183, %176 ], [ %192, %184 ]
  %195 = phi ptr [ %182, %176 ], [ %191, %184 ]
  %196 = load i8, ptr %195, align 1, !tbaa !14
  %197 = zext i8 %196 to i16
  %198 = shl nuw i16 %197, 8
  %199 = load i8, ptr %194, align 1, !tbaa !14
  %200 = zext i8 %199 to i16
  %201 = or disjoint i16 %198, %200
  %202 = load i32, ptr %15, align 4, !tbaa !76
  %203 = load i32, ptr %17, align 8, !tbaa !78
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #26
  store i32 0, ptr %6, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #26
  store i32 0, ptr %7, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %8) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %9) #26
  %204 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %1, i32 noundef %154, ptr noundef nonnull %6, ptr noundef nonnull %7, ptr noundef nonnull %8, ptr noundef nonnull %9) #25
  %205 = icmp eq i32 %204, 0
  br i1 %205, label %222, label %206

206:                                              ; preds = %193
  %207 = uitofp i32 %203 to float
  %208 = fmul float %85, %207
  %209 = uitofp i32 %202 to float
  %210 = fmul float %85, %209
  %211 = load i32, ptr %6, align 4, !tbaa !4
  %212 = sitofp i32 %211 to float
  %213 = call float @llvm.fmuladd.f32(float %212, float %210, float 0.000000e+00)
  %214 = call float @floorf(float noundef %213) #28
  %215 = fptosi float %214 to i32
  %216 = load i32, ptr %9, align 4, !tbaa !4
  %217 = sub nsw i32 0, %216
  %218 = sitofp i32 %217 to float
  %219 = call float @llvm.fmuladd.f32(float %218, float %208, float 0.000000e+00)
  %220 = call float @floorf(float noundef %219) #28
  %221 = fptosi float %220 to i32
  br label %222

222:                                              ; preds = %193, %206
  %223 = phi i32 [ %215, %206 ], [ 0, %193 ]
  %224 = phi i32 [ %221, %206 ], [ 0, %193 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %9) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %8) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %14) #26
  %225 = call i32 @stbtt_GetGlyphShape(ptr noundef readonly %1, i32 noundef %154, ptr noundef nonnull %14) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %10) #26
  store i32 0, ptr %10, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  store i32 0, ptr %11, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  %226 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %1, i32 noundef %154, ptr noundef nonnull %10, ptr noundef nonnull %11, ptr noundef nonnull %12, ptr noundef nonnull %13) #25
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %10) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %14) #26
  %227 = load i32, ptr %15, align 4, !tbaa !76
  %228 = icmp ugt i32 %227, 1
  br i1 %228, label %229, label %241

229:                                              ; preds = %222
  %230 = load ptr, ptr %30, align 8, !tbaa !112
  %231 = load i32, ptr %128, align 4, !tbaa !110
  %232 = sext i32 %231 to i64
  %233 = getelementptr inbounds i8, ptr %230, i64 %232
  %234 = load i32, ptr %158, align 4, !tbaa !111
  %235 = load i32, ptr %31, align 8, !tbaa !113
  %236 = mul nsw i32 %235, %234
  %237 = sext i32 %236 to i64
  %238 = getelementptr inbounds i8, ptr %233, i64 %237
  %239 = load i32, ptr %133, align 4, !tbaa !90
  %240 = load i32, ptr %137, align 4, !tbaa !88
  call fastcc void @stbtt__h_prefilter(ptr noundef %238, i32 noundef %239, i32 noundef %240, i32 noundef %235, i32 noundef %227) #25
  br label %241

241:                                              ; preds = %229, %222
  %242 = load i32, ptr %17, align 8, !tbaa !78
  %243 = icmp ugt i32 %242, 1
  br i1 %243, label %244, label %256

244:                                              ; preds = %241
  %245 = load ptr, ptr %30, align 8, !tbaa !112
  %246 = load i32, ptr %128, align 4, !tbaa !110
  %247 = sext i32 %246 to i64
  %248 = getelementptr inbounds i8, ptr %245, i64 %247
  %249 = load i32, ptr %158, align 4, !tbaa !111
  %250 = load i32, ptr %31, align 8, !tbaa !113
  %251 = mul nsw i32 %250, %249
  %252 = sext i32 %251 to i64
  %253 = getelementptr inbounds i8, ptr %248, i64 %252
  %254 = load i32, ptr %133, align 4, !tbaa !90
  %255 = load i32, ptr %137, align 4, !tbaa !88
  call fastcc void @stbtt__v_prefilter(ptr noundef %253, i32 noundef %254, i32 noundef %255, i32 noundef %250, i32 noundef %242) #25
  br label %256

256:                                              ; preds = %244, %241
  %257 = load i32, ptr %128, align 4, !tbaa !110
  %258 = trunc i32 %257 to i16
  store i16 %258, ptr %142, align 4, !tbaa !114
  %259 = load i32, ptr %158, align 4, !tbaa !111
  %260 = trunc i32 %259 to i16
  %261 = getelementptr inbounds nuw i8, ptr %142, i64 2
  store i16 %260, ptr %261, align 2, !tbaa !116
  %262 = load i32, ptr %133, align 4, !tbaa !90
  %263 = add nsw i32 %262, %257
  %264 = trunc i32 %263 to i16
  %265 = getelementptr inbounds nuw i8, ptr %142, i64 4
  store i16 %264, ptr %265, align 4, !tbaa !117
  %266 = load i32, ptr %137, align 4, !tbaa !88
  %267 = add nsw i32 %266, %259
  %268 = trunc i32 %267 to i16
  %269 = getelementptr inbounds nuw i8, ptr %142, i64 6
  store i16 %268, ptr %269, align 2, !tbaa !118
  %270 = sitofp i16 %201 to float
  %271 = fmul float %85, %270
  %272 = getelementptr inbounds nuw i8, ptr %142, i64 16
  store float %271, ptr %272, align 4, !tbaa !119
  %273 = sitofp i32 %223 to float
  %274 = call float @llvm.fmuladd.f32(float %273, float %93, float %104)
  %275 = getelementptr inbounds nuw i8, ptr %142, i64 8
  store float %274, ptr %275, align 4, !tbaa !120
  %276 = sitofp i32 %224 to float
  %277 = call float @llvm.fmuladd.f32(float %276, float %95, float %113)
  %278 = getelementptr inbounds nuw i8, ptr %142, i64 12
  store float %277, ptr %278, align 4, !tbaa !121
  %279 = add nsw i32 %262, %223
  %280 = sitofp i32 %279 to float
  %281 = call float @llvm.fmuladd.f32(float %280, float %93, float %104)
  %282 = getelementptr inbounds nuw i8, ptr %142, i64 20
  store float %281, ptr %282, align 4, !tbaa !122
  %283 = add nsw i32 %266, %224
  %284 = sitofp i32 %283 to float
  %285 = call float @llvm.fmuladd.f32(float %284, float %95, float %113)
  %286 = getelementptr inbounds nuw i8, ptr %142, i64 24
  store float %285, ptr %286, align 4, !tbaa !123
  %287 = icmp eq i32 %154, 0
  %288 = trunc nuw nsw i64 %125 to i32
  %289 = select i1 %287, i32 %288, i32 %126
  br label %309

290:                                              ; preds = %136, %132, %123
  %291 = load i32, ptr %32, align 8, !tbaa !79
  %292 = icmp ne i32 %291, 0
  %293 = or i1 %131, %292
  br i1 %293, label %309, label %294

294:                                              ; preds = %290
  %295 = getelementptr inbounds nuw i8, ptr %128, i64 12
  %296 = load i32, ptr %295, align 4, !tbaa !90
  %297 = icmp eq i32 %296, 0
  br i1 %297, label %298, label %309

298:                                              ; preds = %294
  %299 = getelementptr inbounds nuw i8, ptr %128, i64 16
  %300 = load i32, ptr %299, align 4, !tbaa !88
  %301 = icmp eq i32 %300, 0
  %302 = icmp sgt i32 %126, -1
  %303 = select i1 %301, i1 %302, i1 false
  br i1 %303, label %304, label %309

304:                                              ; preds = %298
  %305 = load ptr, ptr %121, align 8, !tbaa !109
  %306 = getelementptr inbounds nuw %struct.stbtt_packedchar, ptr %305, i64 %125
  %307 = zext nneg i32 %126 to i64
  %308 = getelementptr inbounds nuw %struct.stbtt_packedchar, ptr %305, i64 %307
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(28) %306, ptr noundef nonnull align 4 dereferenceable(28) %308, i64 28, i1 false), !tbaa.struct !124
  br label %309

309:                                              ; preds = %290, %294, %298, %304, %256
  %310 = phi i32 [ %127, %256 ], [ 0, %290 ], [ %127, %304 ], [ 0, %298 ], [ 0, %294 ]
  %311 = phi i32 [ %289, %256 ], [ %126, %290 ], [ %126, %304 ], [ %126, %298 ], [ %126, %294 ]
  %312 = add nsw i64 %124, 1
  %313 = add nuw nsw i64 %125, 1
  %314 = load i32, ptr %114, align 8, !tbaa !85
  %315 = sext i32 %314 to i64
  %316 = icmp slt i64 %313, %315
  br i1 %316, label %123, label %317, !llvm.loop !126

317:                                              ; preds = %309
  %318 = trunc nsw i64 %312 to i32
  br label %319

319:                                              ; preds = %317, %112
  %320 = phi i32 [ %38, %112 ], [ %310, %317 ]
  %321 = phi i32 [ %37, %112 ], [ %311, %317 ]
  %322 = phi i32 [ %36, %112 ], [ %318, %317 ]
  %323 = add nuw nsw i64 %35, 1
  %324 = icmp eq i64 %323, %33
  br i1 %324, label %325, label %34, !llvm.loop !127

325:                                              ; preds = %319, %5
  %326 = phi i32 [ 1, %5 ], [ %320, %319 ]
  store i32 %16, ptr %15, align 4, !tbaa !76
  store i32 %18, ptr %17, align 8, !tbaa !78
  ret i32 %326
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #13

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_PackFontRangesPackRects(ptr noundef readonly captures(none) %0, ptr noundef captures(none) %1, i32 noundef %2) local_unnamed_addr #14 {
  %4 = icmp sgt i32 %2, 0
  br i1 %4, label %5, label %47

5:                                                ; preds = %3
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %7 = load ptr, ptr %6, align 8, !tbaa !128
  %8 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %9 = load i32, ptr %7, align 4, !tbaa !129
  %10 = getelementptr inbounds nuw i8, ptr %7, i64 16
  %11 = getelementptr inbounds nuw i8, ptr %7, i64 12
  %12 = getelementptr inbounds nuw i8, ptr %7, i64 4
  %13 = load i32, ptr %12, align 4, !tbaa !131
  %14 = load i32, ptr %8, align 4, !tbaa !132
  %15 = load i32, ptr %11, align 4, !tbaa !133
  %16 = zext nneg i32 %2 to i64
  br label %17

17:                                               ; preds = %42, %5
  %18 = phi i64 [ 0, %5 ], [ %43, %42 ]
  %19 = phi i32 [ %15, %5 ], [ %29, %42 ]
  %20 = phi i32 [ %14, %5 ], [ %38, %42 ]
  %21 = getelementptr inbounds nuw %struct.stbrp_rect, ptr %1, i64 %18
  %22 = getelementptr inbounds nuw i8, ptr %21, i64 12
  %23 = load i32, ptr %22, align 4, !tbaa !90
  %24 = add nsw i32 %23, %20
  %25 = icmp sgt i32 %24, %9
  br i1 %25, label %26, label %28

26:                                               ; preds = %17
  store i32 0, ptr %8, align 4, !tbaa !132
  %27 = load i32, ptr %10, align 4, !tbaa !134
  store i32 %27, ptr %11, align 4, !tbaa !133
  br label %28

28:                                               ; preds = %26, %17
  %29 = phi i32 [ %27, %26 ], [ %19, %17 ]
  %30 = phi i32 [ 0, %26 ], [ %20, %17 ]
  %31 = getelementptr inbounds nuw i8, ptr %21, i64 16
  %32 = load i32, ptr %31, align 4, !tbaa !88
  %33 = add nsw i32 %32, %29
  %34 = icmp sgt i32 %33, %13
  br i1 %34, label %45, label %35

35:                                               ; preds = %28
  store i32 %30, ptr %21, align 4, !tbaa !110
  %36 = getelementptr inbounds nuw i8, ptr %21, i64 4
  store i32 %29, ptr %36, align 4, !tbaa !111
  %37 = getelementptr inbounds nuw i8, ptr %21, i64 20
  store i32 1, ptr %37, align 4, !tbaa !108
  %38 = add nsw i32 %30, %23
  store i32 %38, ptr %8, align 4, !tbaa !132
  %39 = load i32, ptr %10, align 4, !tbaa !134
  %40 = icmp sgt i32 %33, %39
  br i1 %40, label %41, label %42

41:                                               ; preds = %35
  store i32 %33, ptr %10, align 4, !tbaa !134
  br label %42

42:                                               ; preds = %41, %35
  %43 = add nuw nsw i64 %18, 1
  %44 = icmp eq i64 %43, %16
  br i1 %44, label %47, label %17, !llvm.loop !135

45:                                               ; preds = %28
  %46 = trunc nuw nsw i64 %18 to i32
  br label %47

47:                                               ; preds = %42, %45, %3
  %48 = phi i32 [ 0, %3 ], [ %46, %45 ], [ %2, %42 ]
  %49 = icmp slt i32 %48, %2
  br i1 %49, label %50, label %59

50:                                               ; preds = %47
  %51 = zext i32 %48 to i64
  br label %52

52:                                               ; preds = %52, %50
  %53 = phi i64 [ %51, %50 ], [ %56, %52 ]
  %54 = getelementptr inbounds nuw %struct.stbrp_rect, ptr %1, i64 %53
  %55 = getelementptr inbounds nuw i8, ptr %54, i64 20
  store i32 0, ptr %55, align 4, !tbaa !108
  %56 = add nuw nsw i64 %53, 1
  %57 = trunc nuw i64 %56 to i32
  %58 = icmp sgt i32 %2, %57
  br i1 %58, label %52, label %59, !llvm.loop !136

59:                                               ; preds = %52, %47
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(write, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local noundef i32 @stbtt_PackFontRanges(ptr noundef readnone captures(none) %0, ptr noundef readnone captures(none) %1, i32 noundef %2, ptr noundef readonly captures(none) %3, i32 noundef %4) local_unnamed_addr #15 {
  %6 = icmp sgt i32 %4, 0
  br i1 %6, label %7, label %30

7:                                                ; preds = %5
  %8 = zext nneg i32 %4 to i64
  br label %9

9:                                                ; preds = %7, %27
  %10 = phi i64 [ 0, %7 ], [ %28, %27 ]
  %11 = getelementptr inbounds nuw %struct.stbtt_pack_range, ptr %3, i64 %10
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 16
  %13 = load i32, ptr %12, align 8, !tbaa !85
  %14 = icmp sgt i32 %13, 0
  br i1 %14, label %15, label %27

15:                                               ; preds = %9
  %16 = getelementptr inbounds nuw i8, ptr %11, i64 24
  %17 = load ptr, ptr %16, align 8, !tbaa !109
  %18 = zext nneg i32 %13 to i64
  br label %19

19:                                               ; preds = %15, %19
  %20 = phi i64 [ 0, %15 ], [ %25, %19 ]
  %21 = getelementptr inbounds nuw %struct.stbtt_packedchar, ptr %17, i64 %20
  %22 = getelementptr inbounds nuw i8, ptr %21, i64 6
  store i16 0, ptr %22, align 2, !tbaa !118
  %23 = getelementptr inbounds nuw i8, ptr %21, i64 4
  store i16 0, ptr %23, align 4, !tbaa !117
  %24 = getelementptr inbounds nuw i8, ptr %21, i64 2
  store i16 0, ptr %24, align 2, !tbaa !116
  store i16 0, ptr %21, align 4, !tbaa !114
  %25 = add nuw nsw i64 %20, 1
  %26 = icmp eq i64 %25, %18
  br i1 %26, label %27, label %19, !llvm.loop !137

27:                                               ; preds = %19, %9
  %28 = add nuw nsw i64 %10, 1
  %29 = icmp eq i64 %28, %8
  br i1 %29, label %30, label %9, !llvm.loop !138

30:                                               ; preds = %27, %5
  ret i32 0
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local range(i32 0, 2) i32 @stbtt_InitFont(ptr noundef captures(none) initializes((8, 20), (64, 80)) %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #6 {
  %4 = alloca %struct.stbtt__buf, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store ptr %1, ptr %9, align 8, !tbaa !8
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i32 %2, ptr %10, align 8, !tbaa !52
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 64
  store ptr null, ptr %11, align 8, !tbaa !57
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 72
  store i64 0, ptr %12, align 8
  %13 = zext i32 %2 to i64
  %14 = getelementptr inbounds nuw i8, ptr %1, i64 %13
  %15 = getelementptr inbounds nuw i8, ptr %14, i64 4
  %16 = load i8, ptr %15, align 1, !tbaa !14
  %17 = zext i8 %16 to i32
  %18 = shl nuw nsw i32 %17, 8
  %19 = getelementptr inbounds nuw i8, ptr %14, i64 5
  %20 = load i8, ptr %19, align 1, !tbaa !14
  %21 = zext i8 %20 to i32
  %22 = or disjoint i32 %18, %21
  %23 = add i32 %2, 12
  %24 = icmp eq i32 %22, 0
  br i1 %24, label %74, label %25

25:                                               ; preds = %3
  %26 = zext nneg i32 %22 to i64
  br label %30

27:                                               ; preds = %71
  %28 = add nuw nsw i64 %31, 1
  %29 = icmp eq i64 %28, %26
  br i1 %29, label %74, label %30, !llvm.loop !53

30:                                               ; preds = %27, %25
  %31 = phi i64 [ 0, %25 ], [ %28, %27 ]
  %32 = phi i32 [ undef, %25 ], [ %72, %27 ]
  %33 = trunc i64 %31 to i32
  %34 = shl i32 %33, 4
  %35 = add i32 %34, %23
  %36 = zext i32 %35 to i64
  %37 = getelementptr inbounds nuw i8, ptr %1, i64 %36
  %38 = load i8, ptr %37, align 1, !tbaa !14
  %39 = icmp eq i8 %38, 99
  br i1 %39, label %40, label %71

40:                                               ; preds = %30
  %41 = getelementptr inbounds nuw i8, ptr %37, i64 1
  %42 = load i8, ptr %41, align 1, !tbaa !14
  %43 = icmp eq i8 %42, 109
  br i1 %43, label %44, label %71

44:                                               ; preds = %40
  %45 = getelementptr inbounds nuw i8, ptr %37, i64 2
  %46 = load i8, ptr %45, align 1, !tbaa !14
  %47 = icmp eq i8 %46, 97
  br i1 %47, label %48, label %71

48:                                               ; preds = %44
  %49 = getelementptr inbounds nuw i8, ptr %37, i64 3
  %50 = load i8, ptr %49, align 1, !tbaa !14
  %51 = icmp eq i8 %50, 112
  br i1 %51, label %52, label %71

52:                                               ; preds = %48
  %53 = getelementptr inbounds nuw i8, ptr %37, i64 8
  %54 = load i8, ptr %53, align 1, !tbaa !14
  %55 = zext i8 %54 to i32
  %56 = shl nuw i32 %55, 24
  %57 = getelementptr inbounds nuw i8, ptr %37, i64 9
  %58 = load i8, ptr %57, align 1, !tbaa !14
  %59 = zext i8 %58 to i32
  %60 = shl nuw nsw i32 %59, 16
  %61 = or disjoint i32 %60, %56
  %62 = getelementptr inbounds nuw i8, ptr %37, i64 10
  %63 = load i8, ptr %62, align 1, !tbaa !14
  %64 = zext i8 %63 to i32
  %65 = shl nuw nsw i32 %64, 8
  %66 = or disjoint i32 %61, %65
  %67 = getelementptr inbounds nuw i8, ptr %37, i64 11
  %68 = load i8, ptr %67, align 1, !tbaa !14
  %69 = zext i8 %68 to i32
  %70 = or disjoint i32 %66, %69
  br label %71

71:                                               ; preds = %52, %48, %44, %40, %30
  %72 = phi i32 [ %70, %52 ], [ %32, %48 ], [ %32, %44 ], [ %32, %40 ], [ %32, %30 ]
  %73 = phi i1 [ false, %52 ], [ true, %48 ], [ true, %44 ], [ true, %40 ], [ true, %30 ]
  br i1 %73, label %27, label %74

74:                                               ; preds = %71, %27, %3
  %75 = phi i32 [ 0, %3 ], [ %72, %71 ], [ 0, %27 ]
  br i1 %24, label %125, label %76

76:                                               ; preds = %74
  %77 = zext nneg i32 %22 to i64
  br label %81

78:                                               ; preds = %122
  %79 = add nuw nsw i64 %82, 1
  %80 = icmp eq i64 %79, %77
  br i1 %80, label %125, label %81, !llvm.loop !53

81:                                               ; preds = %78, %76
  %82 = phi i64 [ 0, %76 ], [ %79, %78 ]
  %83 = phi i32 [ undef, %76 ], [ %123, %78 ]
  %84 = trunc i64 %82 to i32
  %85 = shl i32 %84, 4
  %86 = add i32 %85, %23
  %87 = zext i32 %86 to i64
  %88 = getelementptr inbounds nuw i8, ptr %1, i64 %87
  %89 = load i8, ptr %88, align 1, !tbaa !14
  %90 = icmp eq i8 %89, 108
  br i1 %90, label %91, label %122

91:                                               ; preds = %81
  %92 = getelementptr inbounds nuw i8, ptr %88, i64 1
  %93 = load i8, ptr %92, align 1, !tbaa !14
  %94 = icmp eq i8 %93, 111
  br i1 %94, label %95, label %122

95:                                               ; preds = %91
  %96 = getelementptr inbounds nuw i8, ptr %88, i64 2
  %97 = load i8, ptr %96, align 1, !tbaa !14
  %98 = icmp eq i8 %97, 99
  br i1 %98, label %99, label %122

99:                                               ; preds = %95
  %100 = getelementptr inbounds nuw i8, ptr %88, i64 3
  %101 = load i8, ptr %100, align 1, !tbaa !14
  %102 = icmp eq i8 %101, 97
  br i1 %102, label %103, label %122

103:                                              ; preds = %99
  %104 = getelementptr inbounds nuw i8, ptr %88, i64 8
  %105 = load i8, ptr %104, align 1, !tbaa !14
  %106 = zext i8 %105 to i32
  %107 = shl nuw i32 %106, 24
  %108 = getelementptr inbounds nuw i8, ptr %88, i64 9
  %109 = load i8, ptr %108, align 1, !tbaa !14
  %110 = zext i8 %109 to i32
  %111 = shl nuw nsw i32 %110, 16
  %112 = or disjoint i32 %111, %107
  %113 = getelementptr inbounds nuw i8, ptr %88, i64 10
  %114 = load i8, ptr %113, align 1, !tbaa !14
  %115 = zext i8 %114 to i32
  %116 = shl nuw nsw i32 %115, 8
  %117 = or disjoint i32 %112, %116
  %118 = getelementptr inbounds nuw i8, ptr %88, i64 11
  %119 = load i8, ptr %118, align 1, !tbaa !14
  %120 = zext i8 %119 to i32
  %121 = or disjoint i32 %117, %120
  br label %122

122:                                              ; preds = %103, %99, %95, %91, %81
  %123 = phi i32 [ %121, %103 ], [ %83, %99 ], [ %83, %95 ], [ %83, %91 ], [ %83, %81 ]
  %124 = phi i1 [ false, %103 ], [ true, %99 ], [ true, %95 ], [ true, %91 ], [ true, %81 ]
  br i1 %124, label %78, label %125

125:                                              ; preds = %122, %78, %74
  %126 = phi i32 [ 0, %74 ], [ %123, %122 ], [ 0, %78 ]
  %127 = getelementptr inbounds nuw i8, ptr %0, i64 24
  store i32 %126, ptr %127, align 8, !tbaa !36
  %128 = load i8, ptr %15, align 1, !tbaa !14
  %129 = zext i8 %128 to i32
  %130 = shl nuw nsw i32 %129, 8
  %131 = load i8, ptr %19, align 1, !tbaa !14
  %132 = zext i8 %131 to i32
  %133 = or disjoint i32 %130, %132
  %134 = icmp eq i32 %133, 0
  br i1 %134, label %184, label %135

135:                                              ; preds = %125
  %136 = zext nneg i32 %133 to i64
  br label %140

137:                                              ; preds = %181
  %138 = add nuw nsw i64 %141, 1
  %139 = icmp eq i64 %138, %136
  br i1 %139, label %184, label %140, !llvm.loop !53

140:                                              ; preds = %137, %135
  %141 = phi i64 [ 0, %135 ], [ %138, %137 ]
  %142 = phi i32 [ undef, %135 ], [ %182, %137 ]
  %143 = trunc i64 %141 to i32
  %144 = shl i32 %143, 4
  %145 = add i32 %144, %23
  %146 = zext i32 %145 to i64
  %147 = getelementptr inbounds nuw i8, ptr %1, i64 %146
  %148 = load i8, ptr %147, align 1, !tbaa !14
  %149 = icmp eq i8 %148, 104
  br i1 %149, label %150, label %181

150:                                              ; preds = %140
  %151 = getelementptr inbounds nuw i8, ptr %147, i64 1
  %152 = load i8, ptr %151, align 1, !tbaa !14
  %153 = icmp eq i8 %152, 101
  br i1 %153, label %154, label %181

154:                                              ; preds = %150
  %155 = getelementptr inbounds nuw i8, ptr %147, i64 2
  %156 = load i8, ptr %155, align 1, !tbaa !14
  %157 = icmp eq i8 %156, 97
  br i1 %157, label %158, label %181

158:                                              ; preds = %154
  %159 = getelementptr inbounds nuw i8, ptr %147, i64 3
  %160 = load i8, ptr %159, align 1, !tbaa !14
  %161 = icmp eq i8 %160, 100
  br i1 %161, label %162, label %181

162:                                              ; preds = %158
  %163 = getelementptr inbounds nuw i8, ptr %147, i64 8
  %164 = load i8, ptr %163, align 1, !tbaa !14
  %165 = zext i8 %164 to i32
  %166 = shl nuw i32 %165, 24
  %167 = getelementptr inbounds nuw i8, ptr %147, i64 9
  %168 = load i8, ptr %167, align 1, !tbaa !14
  %169 = zext i8 %168 to i32
  %170 = shl nuw nsw i32 %169, 16
  %171 = or disjoint i32 %170, %166
  %172 = getelementptr inbounds nuw i8, ptr %147, i64 10
  %173 = load i8, ptr %172, align 1, !tbaa !14
  %174 = zext i8 %173 to i32
  %175 = shl nuw nsw i32 %174, 8
  %176 = or disjoint i32 %171, %175
  %177 = getelementptr inbounds nuw i8, ptr %147, i64 11
  %178 = load i8, ptr %177, align 1, !tbaa !14
  %179 = zext i8 %178 to i32
  %180 = or disjoint i32 %176, %179
  br label %181

181:                                              ; preds = %162, %158, %154, %150, %140
  %182 = phi i32 [ %180, %162 ], [ %142, %158 ], [ %142, %154 ], [ %142, %150 ], [ %142, %140 ]
  %183 = phi i1 [ false, %162 ], [ true, %158 ], [ true, %154 ], [ true, %150 ], [ true, %140 ]
  br i1 %183, label %137, label %184

184:                                              ; preds = %181, %137, %125
  %185 = phi i32 [ 0, %125 ], [ %182, %181 ], [ 0, %137 ]
  %186 = getelementptr inbounds nuw i8, ptr %0, i64 28
  store i32 %185, ptr %186, align 4, !tbaa !54
  %187 = load i8, ptr %15, align 1, !tbaa !14
  %188 = zext i8 %187 to i32
  %189 = shl nuw nsw i32 %188, 8
  %190 = load i8, ptr %19, align 1, !tbaa !14
  %191 = zext i8 %190 to i32
  %192 = or disjoint i32 %189, %191
  %193 = icmp eq i32 %192, 0
  br i1 %193, label %243, label %194

194:                                              ; preds = %184
  %195 = zext nneg i32 %192 to i64
  br label %199

196:                                              ; preds = %240
  %197 = add nuw nsw i64 %200, 1
  %198 = icmp eq i64 %197, %195
  br i1 %198, label %243, label %199, !llvm.loop !53

199:                                              ; preds = %196, %194
  %200 = phi i64 [ 0, %194 ], [ %197, %196 ]
  %201 = phi i32 [ undef, %194 ], [ %241, %196 ]
  %202 = trunc i64 %200 to i32
  %203 = shl i32 %202, 4
  %204 = add i32 %203, %23
  %205 = zext i32 %204 to i64
  %206 = getelementptr inbounds nuw i8, ptr %1, i64 %205
  %207 = load i8, ptr %206, align 1, !tbaa !14
  %208 = icmp eq i8 %207, 103
  br i1 %208, label %209, label %240

209:                                              ; preds = %199
  %210 = getelementptr inbounds nuw i8, ptr %206, i64 1
  %211 = load i8, ptr %210, align 1, !tbaa !14
  %212 = icmp eq i8 %211, 108
  br i1 %212, label %213, label %240

213:                                              ; preds = %209
  %214 = getelementptr inbounds nuw i8, ptr %206, i64 2
  %215 = load i8, ptr %214, align 1, !tbaa !14
  %216 = icmp eq i8 %215, 121
  br i1 %216, label %217, label %240

217:                                              ; preds = %213
  %218 = getelementptr inbounds nuw i8, ptr %206, i64 3
  %219 = load i8, ptr %218, align 1, !tbaa !14
  %220 = icmp eq i8 %219, 102
  br i1 %220, label %221, label %240

221:                                              ; preds = %217
  %222 = getelementptr inbounds nuw i8, ptr %206, i64 8
  %223 = load i8, ptr %222, align 1, !tbaa !14
  %224 = zext i8 %223 to i32
  %225 = shl nuw i32 %224, 24
  %226 = getelementptr inbounds nuw i8, ptr %206, i64 9
  %227 = load i8, ptr %226, align 1, !tbaa !14
  %228 = zext i8 %227 to i32
  %229 = shl nuw nsw i32 %228, 16
  %230 = or disjoint i32 %229, %225
  %231 = getelementptr inbounds nuw i8, ptr %206, i64 10
  %232 = load i8, ptr %231, align 1, !tbaa !14
  %233 = zext i8 %232 to i32
  %234 = shl nuw nsw i32 %233, 8
  %235 = or disjoint i32 %230, %234
  %236 = getelementptr inbounds nuw i8, ptr %206, i64 11
  %237 = load i8, ptr %236, align 1, !tbaa !14
  %238 = zext i8 %237 to i32
  %239 = or disjoint i32 %235, %238
  br label %240

240:                                              ; preds = %221, %217, %213, %209, %199
  %241 = phi i32 [ %239, %221 ], [ %201, %217 ], [ %201, %213 ], [ %201, %209 ], [ %201, %199 ]
  %242 = phi i1 [ false, %221 ], [ true, %217 ], [ true, %213 ], [ true, %209 ], [ true, %199 ]
  br i1 %242, label %196, label %243

243:                                              ; preds = %240, %196, %184
  %244 = phi i32 [ 0, %184 ], [ %241, %240 ], [ 0, %196 ]
  %245 = getelementptr inbounds nuw i8, ptr %0, i64 32
  store i32 %244, ptr %245, align 8, !tbaa !35
  %246 = load i8, ptr %15, align 1, !tbaa !14
  %247 = zext i8 %246 to i32
  %248 = shl nuw nsw i32 %247, 8
  %249 = load i8, ptr %19, align 1, !tbaa !14
  %250 = zext i8 %249 to i32
  %251 = or disjoint i32 %248, %250
  %252 = icmp eq i32 %251, 0
  br i1 %252, label %302, label %253

253:                                              ; preds = %243
  %254 = zext nneg i32 %251 to i64
  br label %258

255:                                              ; preds = %299
  %256 = add nuw nsw i64 %259, 1
  %257 = icmp eq i64 %256, %254
  br i1 %257, label %302, label %258, !llvm.loop !53

258:                                              ; preds = %255, %253
  %259 = phi i64 [ 0, %253 ], [ %256, %255 ]
  %260 = phi i32 [ undef, %253 ], [ %300, %255 ]
  %261 = trunc i64 %259 to i32
  %262 = shl i32 %261, 4
  %263 = add i32 %262, %23
  %264 = zext i32 %263 to i64
  %265 = getelementptr inbounds nuw i8, ptr %1, i64 %264
  %266 = load i8, ptr %265, align 1, !tbaa !14
  %267 = icmp eq i8 %266, 104
  br i1 %267, label %268, label %299

268:                                              ; preds = %258
  %269 = getelementptr inbounds nuw i8, ptr %265, i64 1
  %270 = load i8, ptr %269, align 1, !tbaa !14
  %271 = icmp eq i8 %270, 104
  br i1 %271, label %272, label %299

272:                                              ; preds = %268
  %273 = getelementptr inbounds nuw i8, ptr %265, i64 2
  %274 = load i8, ptr %273, align 1, !tbaa !14
  %275 = icmp eq i8 %274, 101
  br i1 %275, label %276, label %299

276:                                              ; preds = %272
  %277 = getelementptr inbounds nuw i8, ptr %265, i64 3
  %278 = load i8, ptr %277, align 1, !tbaa !14
  %279 = icmp eq i8 %278, 97
  br i1 %279, label %280, label %299

280:                                              ; preds = %276
  %281 = getelementptr inbounds nuw i8, ptr %265, i64 8
  %282 = load i8, ptr %281, align 1, !tbaa !14
  %283 = zext i8 %282 to i32
  %284 = shl nuw i32 %283, 24
  %285 = getelementptr inbounds nuw i8, ptr %265, i64 9
  %286 = load i8, ptr %285, align 1, !tbaa !14
  %287 = zext i8 %286 to i32
  %288 = shl nuw nsw i32 %287, 16
  %289 = or disjoint i32 %288, %284
  %290 = getelementptr inbounds nuw i8, ptr %265, i64 10
  %291 = load i8, ptr %290, align 1, !tbaa !14
  %292 = zext i8 %291 to i32
  %293 = shl nuw nsw i32 %292, 8
  %294 = or disjoint i32 %289, %293
  %295 = getelementptr inbounds nuw i8, ptr %265, i64 11
  %296 = load i8, ptr %295, align 1, !tbaa !14
  %297 = zext i8 %296 to i32
  %298 = or disjoint i32 %294, %297
  br label %299

299:                                              ; preds = %280, %276, %272, %268, %258
  %300 = phi i32 [ %298, %280 ], [ %260, %276 ], [ %260, %272 ], [ %260, %268 ], [ %260, %258 ]
  %301 = phi i1 [ false, %280 ], [ true, %276 ], [ true, %272 ], [ true, %268 ], [ true, %258 ]
  br i1 %301, label %255, label %302

302:                                              ; preds = %299, %255, %243
  %303 = phi i32 [ 0, %243 ], [ %300, %299 ], [ 0, %255 ]
  %304 = getelementptr inbounds nuw i8, ptr %0, i64 36
  store i32 %303, ptr %304, align 4, !tbaa !37
  %305 = load i8, ptr %15, align 1, !tbaa !14
  %306 = zext i8 %305 to i32
  %307 = shl nuw nsw i32 %306, 8
  %308 = load i8, ptr %19, align 1, !tbaa !14
  %309 = zext i8 %308 to i32
  %310 = or disjoint i32 %307, %309
  %311 = icmp eq i32 %310, 0
  br i1 %311, label %361, label %312

312:                                              ; preds = %302
  %313 = zext nneg i32 %310 to i64
  br label %317

314:                                              ; preds = %358
  %315 = add nuw nsw i64 %318, 1
  %316 = icmp eq i64 %315, %313
  br i1 %316, label %361, label %317, !llvm.loop !53

317:                                              ; preds = %314, %312
  %318 = phi i64 [ 0, %312 ], [ %315, %314 ]
  %319 = phi i32 [ undef, %312 ], [ %359, %314 ]
  %320 = trunc i64 %318 to i32
  %321 = shl i32 %320, 4
  %322 = add i32 %321, %23
  %323 = zext i32 %322 to i64
  %324 = getelementptr inbounds nuw i8, ptr %1, i64 %323
  %325 = load i8, ptr %324, align 1, !tbaa !14
  %326 = icmp eq i8 %325, 104
  br i1 %326, label %327, label %358

327:                                              ; preds = %317
  %328 = getelementptr inbounds nuw i8, ptr %324, i64 1
  %329 = load i8, ptr %328, align 1, !tbaa !14
  %330 = icmp eq i8 %329, 109
  br i1 %330, label %331, label %358

331:                                              ; preds = %327
  %332 = getelementptr inbounds nuw i8, ptr %324, i64 2
  %333 = load i8, ptr %332, align 1, !tbaa !14
  %334 = icmp eq i8 %333, 116
  br i1 %334, label %335, label %358

335:                                              ; preds = %331
  %336 = getelementptr inbounds nuw i8, ptr %324, i64 3
  %337 = load i8, ptr %336, align 1, !tbaa !14
  %338 = icmp eq i8 %337, 120
  br i1 %338, label %339, label %358

339:                                              ; preds = %335
  %340 = getelementptr inbounds nuw i8, ptr %324, i64 8
  %341 = load i8, ptr %340, align 1, !tbaa !14
  %342 = zext i8 %341 to i32
  %343 = shl nuw i32 %342, 24
  %344 = getelementptr inbounds nuw i8, ptr %324, i64 9
  %345 = load i8, ptr %344, align 1, !tbaa !14
  %346 = zext i8 %345 to i32
  %347 = shl nuw nsw i32 %346, 16
  %348 = or disjoint i32 %347, %343
  %349 = getelementptr inbounds nuw i8, ptr %324, i64 10
  %350 = load i8, ptr %349, align 1, !tbaa !14
  %351 = zext i8 %350 to i32
  %352 = shl nuw nsw i32 %351, 8
  %353 = or disjoint i32 %348, %352
  %354 = getelementptr inbounds nuw i8, ptr %324, i64 11
  %355 = load i8, ptr %354, align 1, !tbaa !14
  %356 = zext i8 %355 to i32
  %357 = or disjoint i32 %353, %356
  br label %358

358:                                              ; preds = %339, %335, %331, %327, %317
  %359 = phi i32 [ %357, %339 ], [ %319, %335 ], [ %319, %331 ], [ %319, %327 ], [ %319, %317 ]
  %360 = phi i1 [ false, %339 ], [ true, %335 ], [ true, %331 ], [ true, %327 ], [ true, %317 ]
  br i1 %360, label %314, label %361

361:                                              ; preds = %358, %314, %302
  %362 = phi i32 [ 0, %302 ], [ %359, %358 ], [ 0, %314 ]
  %363 = getelementptr inbounds nuw i8, ptr %0, i64 40
  store i32 %362, ptr %363, align 8, !tbaa !38
  %364 = load i8, ptr %15, align 1, !tbaa !14
  %365 = zext i8 %364 to i32
  %366 = shl nuw nsw i32 %365, 8
  %367 = load i8, ptr %19, align 1, !tbaa !14
  %368 = zext i8 %367 to i32
  %369 = or disjoint i32 %366, %368
  %370 = icmp eq i32 %369, 0
  br i1 %370, label %420, label %371

371:                                              ; preds = %361
  %372 = zext nneg i32 %369 to i64
  br label %376

373:                                              ; preds = %417
  %374 = add nuw nsw i64 %377, 1
  %375 = icmp eq i64 %374, %372
  br i1 %375, label %420, label %376, !llvm.loop !53

376:                                              ; preds = %373, %371
  %377 = phi i64 [ 0, %371 ], [ %374, %373 ]
  %378 = phi i32 [ undef, %371 ], [ %418, %373 ]
  %379 = trunc i64 %377 to i32
  %380 = shl i32 %379, 4
  %381 = add i32 %380, %23
  %382 = zext i32 %381 to i64
  %383 = getelementptr inbounds nuw i8, ptr %1, i64 %382
  %384 = load i8, ptr %383, align 1, !tbaa !14
  %385 = icmp eq i8 %384, 107
  br i1 %385, label %386, label %417

386:                                              ; preds = %376
  %387 = getelementptr inbounds nuw i8, ptr %383, i64 1
  %388 = load i8, ptr %387, align 1, !tbaa !14
  %389 = icmp eq i8 %388, 101
  br i1 %389, label %390, label %417

390:                                              ; preds = %386
  %391 = getelementptr inbounds nuw i8, ptr %383, i64 2
  %392 = load i8, ptr %391, align 1, !tbaa !14
  %393 = icmp eq i8 %392, 114
  br i1 %393, label %394, label %417

394:                                              ; preds = %390
  %395 = getelementptr inbounds nuw i8, ptr %383, i64 3
  %396 = load i8, ptr %395, align 1, !tbaa !14
  %397 = icmp eq i8 %396, 110
  br i1 %397, label %398, label %417

398:                                              ; preds = %394
  %399 = getelementptr inbounds nuw i8, ptr %383, i64 8
  %400 = load i8, ptr %399, align 1, !tbaa !14
  %401 = zext i8 %400 to i32
  %402 = shl nuw i32 %401, 24
  %403 = getelementptr inbounds nuw i8, ptr %383, i64 9
  %404 = load i8, ptr %403, align 1, !tbaa !14
  %405 = zext i8 %404 to i32
  %406 = shl nuw nsw i32 %405, 16
  %407 = or disjoint i32 %406, %402
  %408 = getelementptr inbounds nuw i8, ptr %383, i64 10
  %409 = load i8, ptr %408, align 1, !tbaa !14
  %410 = zext i8 %409 to i32
  %411 = shl nuw nsw i32 %410, 8
  %412 = or disjoint i32 %407, %411
  %413 = getelementptr inbounds nuw i8, ptr %383, i64 11
  %414 = load i8, ptr %413, align 1, !tbaa !14
  %415 = zext i8 %414 to i32
  %416 = or disjoint i32 %412, %415
  br label %417

417:                                              ; preds = %398, %394, %390, %386, %376
  %418 = phi i32 [ %416, %398 ], [ %378, %394 ], [ %378, %390 ], [ %378, %386 ], [ %378, %376 ]
  %419 = phi i1 [ false, %398 ], [ true, %394 ], [ true, %390 ], [ true, %386 ], [ true, %376 ]
  br i1 %419, label %373, label %420

420:                                              ; preds = %417, %373, %361
  %421 = phi i32 [ 0, %361 ], [ %418, %417 ], [ 0, %373 ]
  %422 = getelementptr inbounds nuw i8, ptr %0, i64 44
  store i32 %421, ptr %422, align 4, !tbaa !39
  %423 = load i8, ptr %15, align 1, !tbaa !14
  %424 = zext i8 %423 to i32
  %425 = shl nuw nsw i32 %424, 8
  %426 = load i8, ptr %19, align 1, !tbaa !14
  %427 = zext i8 %426 to i32
  %428 = or disjoint i32 %425, %427
  %429 = icmp eq i32 %428, 0
  br i1 %429, label %479, label %430

430:                                              ; preds = %420
  %431 = zext nneg i32 %428 to i64
  br label %435

432:                                              ; preds = %476
  %433 = add nuw nsw i64 %436, 1
  %434 = icmp eq i64 %433, %431
  br i1 %434, label %479, label %435, !llvm.loop !53

435:                                              ; preds = %432, %430
  %436 = phi i64 [ 0, %430 ], [ %433, %432 ]
  %437 = phi i32 [ undef, %430 ], [ %477, %432 ]
  %438 = trunc i64 %436 to i32
  %439 = shl i32 %438, 4
  %440 = add i32 %439, %23
  %441 = zext i32 %440 to i64
  %442 = getelementptr inbounds nuw i8, ptr %1, i64 %441
  %443 = load i8, ptr %442, align 1, !tbaa !14
  %444 = icmp eq i8 %443, 71
  br i1 %444, label %445, label %476

445:                                              ; preds = %435
  %446 = getelementptr inbounds nuw i8, ptr %442, i64 1
  %447 = load i8, ptr %446, align 1, !tbaa !14
  %448 = icmp eq i8 %447, 80
  br i1 %448, label %449, label %476

449:                                              ; preds = %445
  %450 = getelementptr inbounds nuw i8, ptr %442, i64 2
  %451 = load i8, ptr %450, align 1, !tbaa !14
  %452 = icmp eq i8 %451, 79
  br i1 %452, label %453, label %476

453:                                              ; preds = %449
  %454 = getelementptr inbounds nuw i8, ptr %442, i64 3
  %455 = load i8, ptr %454, align 1, !tbaa !14
  %456 = icmp eq i8 %455, 83
  br i1 %456, label %457, label %476

457:                                              ; preds = %453
  %458 = getelementptr inbounds nuw i8, ptr %442, i64 8
  %459 = load i8, ptr %458, align 1, !tbaa !14
  %460 = zext i8 %459 to i32
  %461 = shl nuw i32 %460, 24
  %462 = getelementptr inbounds nuw i8, ptr %442, i64 9
  %463 = load i8, ptr %462, align 1, !tbaa !14
  %464 = zext i8 %463 to i32
  %465 = shl nuw nsw i32 %464, 16
  %466 = or disjoint i32 %465, %461
  %467 = getelementptr inbounds nuw i8, ptr %442, i64 10
  %468 = load i8, ptr %467, align 1, !tbaa !14
  %469 = zext i8 %468 to i32
  %470 = shl nuw nsw i32 %469, 8
  %471 = or disjoint i32 %466, %470
  %472 = getelementptr inbounds nuw i8, ptr %442, i64 11
  %473 = load i8, ptr %472, align 1, !tbaa !14
  %474 = zext i8 %473 to i32
  %475 = or disjoint i32 %471, %474
  br label %476

476:                                              ; preds = %457, %453, %449, %445, %435
  %477 = phi i32 [ %475, %457 ], [ %437, %453 ], [ %437, %449 ], [ %437, %445 ], [ %437, %435 ]
  %478 = phi i1 [ false, %457 ], [ true, %453 ], [ true, %449 ], [ true, %445 ], [ true, %435 ]
  br i1 %478, label %432, label %479

479:                                              ; preds = %476, %432, %420
  %480 = phi i32 [ 0, %420 ], [ %477, %476 ], [ 0, %432 ]
  %481 = getelementptr inbounds nuw i8, ptr %0, i64 48
  store i32 %480, ptr %481, align 8, !tbaa !45
  %482 = icmp eq i32 %75, 0
  %483 = icmp eq i32 %185, 0
  %484 = select i1 %482, i1 true, i1 %483
  %485 = icmp eq i32 %303, 0
  %486 = select i1 %484, i1 true, i1 %485
  %487 = icmp eq i32 %362, 0
  %488 = select i1 %486, i1 true, i1 %487
  br i1 %488, label %1278, label %489

489:                                              ; preds = %479
  %490 = icmp eq i32 %244, 0
  br i1 %490, label %493, label %491

491:                                              ; preds = %489
  %492 = icmp eq i32 %126, 0
  br i1 %492, label %1278, label %1126

493:                                              ; preds = %489
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %5) #26
  store i32 2, ptr %5, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #26
  store i32 0, ptr %6, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #26
  store i32 0, ptr %7, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %8) #26
  store i32 0, ptr %8, align 4, !tbaa !4
  %494 = load i8, ptr %15, align 1, !tbaa !14
  %495 = zext i8 %494 to i32
  %496 = shl nuw nsw i32 %495, 8
  %497 = load i8, ptr %19, align 1, !tbaa !14
  %498 = zext i8 %497 to i32
  %499 = or disjoint i32 %496, %498
  %500 = icmp eq i32 %499, 0
  br i1 %500, label %550, label %501

501:                                              ; preds = %493
  %502 = zext nneg i32 %499 to i64
  br label %506

503:                                              ; preds = %547
  %504 = add nuw nsw i64 %507, 1
  %505 = icmp eq i64 %504, %502
  br i1 %505, label %550, label %506, !llvm.loop !53

506:                                              ; preds = %503, %501
  %507 = phi i64 [ 0, %501 ], [ %504, %503 ]
  %508 = phi i32 [ undef, %501 ], [ %548, %503 ]
  %509 = trunc i64 %507 to i32
  %510 = shl i32 %509, 4
  %511 = add i32 %510, %23
  %512 = zext i32 %511 to i64
  %513 = getelementptr inbounds nuw i8, ptr %1, i64 %512
  %514 = load i8, ptr %513, align 1, !tbaa !14
  %515 = icmp eq i8 %514, 67
  br i1 %515, label %516, label %547

516:                                              ; preds = %506
  %517 = getelementptr inbounds nuw i8, ptr %513, i64 1
  %518 = load i8, ptr %517, align 1, !tbaa !14
  %519 = icmp eq i8 %518, 70
  br i1 %519, label %520, label %547

520:                                              ; preds = %516
  %521 = getelementptr inbounds nuw i8, ptr %513, i64 2
  %522 = load i8, ptr %521, align 1, !tbaa !14
  %523 = icmp eq i8 %522, 70
  br i1 %523, label %524, label %547

524:                                              ; preds = %520
  %525 = getelementptr inbounds nuw i8, ptr %513, i64 3
  %526 = load i8, ptr %525, align 1, !tbaa !14
  %527 = icmp eq i8 %526, 32
  br i1 %527, label %528, label %547

528:                                              ; preds = %524
  %529 = getelementptr inbounds nuw i8, ptr %513, i64 8
  %530 = load i8, ptr %529, align 1, !tbaa !14
  %531 = zext i8 %530 to i32
  %532 = shl nuw i32 %531, 24
  %533 = getelementptr inbounds nuw i8, ptr %513, i64 9
  %534 = load i8, ptr %533, align 1, !tbaa !14
  %535 = zext i8 %534 to i32
  %536 = shl nuw nsw i32 %535, 16
  %537 = or disjoint i32 %536, %532
  %538 = getelementptr inbounds nuw i8, ptr %513, i64 10
  %539 = load i8, ptr %538, align 1, !tbaa !14
  %540 = zext i8 %539 to i32
  %541 = shl nuw nsw i32 %540, 8
  %542 = or disjoint i32 %537, %541
  %543 = getelementptr inbounds nuw i8, ptr %513, i64 11
  %544 = load i8, ptr %543, align 1, !tbaa !14
  %545 = zext i8 %544 to i32
  %546 = or disjoint i32 %542, %545
  br label %547

547:                                              ; preds = %528, %524, %520, %516, %506
  %548 = phi i32 [ %546, %528 ], [ %508, %524 ], [ %508, %520 ], [ %508, %516 ], [ %508, %506 ]
  %549 = phi i1 [ false, %528 ], [ true, %524 ], [ true, %520 ], [ true, %516 ], [ true, %506 ]
  br i1 %549, label %503, label %550

550:                                              ; preds = %547, %503, %493
  %551 = phi i32 [ 0, %493 ], [ %548, %547 ], [ 0, %503 ]
  %552 = icmp eq i32 %551, 0
  br i1 %552, label %1277, label %553

553:                                              ; preds = %550
  %554 = getelementptr inbounds nuw i8, ptr %0, i64 128
  store ptr null, ptr %554, align 8, !tbaa !57
  %555 = getelementptr inbounds nuw i8, ptr %0, i64 136
  store i64 0, ptr %555, align 8
  %556 = getelementptr inbounds nuw i8, ptr %0, i64 144
  store ptr null, ptr %556, align 8, !tbaa !57
  %557 = getelementptr inbounds nuw i8, ptr %0, i64 152
  store i64 0, ptr %557, align 8
  %558 = zext i32 %551 to i64
  %559 = getelementptr inbounds nuw i8, ptr %1, i64 %558
  store ptr %559, ptr %11, align 8, !tbaa !57
  store i64 2305843009213693952, ptr %12, align 8
  %560 = getelementptr inbounds nuw i8, ptr %559, i64 2
  %561 = load i8, ptr %560, align 1, !tbaa !14
  %562 = zext i8 %561 to i32
  br label %563

563:                                              ; preds = %577, %553
  %564 = phi i32 [ %562, %553 ], [ %578, %577 ]
  %565 = phi i32 [ %562, %553 ], [ %579, %577 ]
  %566 = phi i1 [ false, %553 ], [ true, %577 ]
  %567 = phi i32 [ 0, %553 ], [ %580, %577 ]
  %568 = shl i32 %567, 8
  %569 = icmp slt i32 %565, 536870912
  br i1 %569, label %570, label %577

570:                                              ; preds = %563
  %571 = add nsw i32 %565, 1
  %572 = sext i32 %565 to i64
  %573 = getelementptr inbounds i8, ptr %559, i64 %572
  %574 = load i8, ptr %573, align 1, !tbaa !14
  %575 = zext i8 %574 to i32
  %576 = or disjoint i32 %568, %575
  br label %577

577:                                              ; preds = %570, %563
  %578 = phi i32 [ %571, %570 ], [ %564, %563 ]
  %579 = phi i32 [ %571, %570 ], [ %565, %563 ]
  %580 = phi i32 [ %576, %570 ], [ %568, %563 ]
  br i1 %566, label %581, label %563, !llvm.loop !139

581:                                              ; preds = %577
  %582 = zext i32 %578 to i64
  %583 = icmp eq i32 %580, 0
  br i1 %583, label %632, label %584

584:                                              ; preds = %581
  %585 = icmp slt i32 %578, 536870912
  br i1 %585, label %586, label %592

586:                                              ; preds = %584
  %587 = add nsw i32 %578, 1
  %588 = sext i32 %578 to i64
  %589 = getelementptr inbounds i8, ptr %559, i64 %588
  %590 = load i8, ptr %589, align 1, !tbaa !14
  %591 = zext i8 %590 to i32
  br label %592

592:                                              ; preds = %586, %584
  %593 = phi i32 [ %587, %586 ], [ %578, %584 ]
  %594 = phi i32 [ %591, %586 ], [ 0, %584 ]
  %595 = mul nsw i32 %594, %580
  %596 = add nsw i32 %595, %593
  %597 = icmp slt i32 %596, 0
  %598 = tail call i32 @llvm.smin.i32(i32 %596, i32 536870912)
  %599 = select i1 %597, i32 536870912, i32 %598
  %600 = icmp eq i32 %594, 0
  br i1 %600, label %623, label %601

601:                                              ; preds = %592, %615
  %602 = phi i32 [ %616, %615 ], [ %599, %592 ]
  %603 = phi i32 [ %617, %615 ], [ %599, %592 ]
  %604 = phi i32 [ %619, %615 ], [ 0, %592 ]
  %605 = phi i32 [ %618, %615 ], [ 0, %592 ]
  %606 = shl i32 %605, 8
  %607 = icmp slt i32 %603, 536870912
  br i1 %607, label %608, label %615

608:                                              ; preds = %601
  %609 = add nsw i32 %603, 1
  %610 = sext i32 %603 to i64
  %611 = getelementptr inbounds i8, ptr %559, i64 %610
  %612 = load i8, ptr %611, align 1, !tbaa !14
  %613 = zext i8 %612 to i32
  %614 = or disjoint i32 %606, %613
  br label %615

615:                                              ; preds = %608, %601
  %616 = phi i32 [ %609, %608 ], [ %602, %601 ]
  %617 = phi i32 [ %609, %608 ], [ 536870912, %601 ]
  %618 = phi i32 [ %614, %608 ], [ %606, %601 ]
  %619 = add nuw nsw i32 %604, 1
  %620 = icmp eq i32 %619, %594
  br i1 %620, label %621, label %601, !llvm.loop !139

621:                                              ; preds = %615
  %622 = add i32 %618, -1
  br label %623

623:                                              ; preds = %621, %592
  %624 = phi i32 [ %599, %592 ], [ %616, %621 ]
  %625 = phi i32 [ -1, %592 ], [ %622, %621 ]
  %626 = add nsw i32 %625, %624
  %627 = icmp slt i32 %626, 0
  %628 = tail call i32 @llvm.smin.i32(i32 %626, i32 536870912)
  %629 = select i1 %627, i32 536870912, i32 %628
  %630 = zext i32 %629 to i64
  %631 = or disjoint i64 %630, 2305843009213693952
  br label %632

632:                                              ; preds = %623, %581
  %633 = phi i64 [ %582, %581 ], [ %631, %623 ]
  %634 = trunc i64 %633 to i32
  br label %635

635:                                              ; preds = %649, %632
  %636 = phi i32 [ %634, %632 ], [ %650, %649 ]
  %637 = phi i32 [ %634, %632 ], [ %651, %649 ]
  %638 = phi i1 [ false, %632 ], [ true, %649 ]
  %639 = phi i32 [ 0, %632 ], [ %652, %649 ]
  %640 = shl i32 %639, 8
  %641 = icmp slt i32 %637, 536870912
  br i1 %641, label %642, label %649

642:                                              ; preds = %635
  %643 = add nsw i32 %637, 1
  %644 = sext i32 %637 to i64
  %645 = getelementptr inbounds i8, ptr %559, i64 %644
  %646 = load i8, ptr %645, align 1, !tbaa !14
  %647 = zext i8 %646 to i32
  %648 = or disjoint i32 %640, %647
  br label %649

649:                                              ; preds = %642, %635
  %650 = phi i32 [ %643, %642 ], [ %636, %635 ]
  %651 = phi i32 [ %643, %642 ], [ %637, %635 ]
  %652 = phi i32 [ %648, %642 ], [ %640, %635 ]
  br i1 %638, label %653, label %635, !llvm.loop !139

653:                                              ; preds = %649
  %654 = zext i32 %650 to i64
  %655 = or disjoint i64 %654, 2305843009213693952
  %656 = icmp eq i32 %652, 0
  br i1 %656, label %708, label %657

657:                                              ; preds = %653
  %658 = icmp slt i32 %650, 536870912
  br i1 %658, label %659, label %667

659:                                              ; preds = %657
  %660 = add nsw i32 %650, 1
  %661 = zext i32 %660 to i64
  %662 = or disjoint i64 %661, 2305843009213693952
  %663 = sext i32 %650 to i64
  %664 = getelementptr inbounds i8, ptr %559, i64 %663
  %665 = load i8, ptr %664, align 1, !tbaa !14
  %666 = zext i8 %665 to i32
  br label %667

667:                                              ; preds = %659, %657
  %668 = phi i64 [ %662, %659 ], [ %655, %657 ]
  %669 = phi i32 [ %666, %659 ], [ 0, %657 ]
  %670 = mul nsw i32 %669, %652
  %671 = trunc i64 %668 to i32
  %672 = add nsw i32 %670, %671
  %673 = icmp slt i32 %672, 0
  %674 = tail call i32 @llvm.smin.i32(i32 %672, i32 536870912)
  %675 = select i1 %673, i32 536870912, i32 %674
  %676 = icmp eq i32 %669, 0
  br i1 %676, label %699, label %677

677:                                              ; preds = %667, %691
  %678 = phi i32 [ %692, %691 ], [ %675, %667 ]
  %679 = phi i32 [ %693, %691 ], [ %675, %667 ]
  %680 = phi i32 [ %695, %691 ], [ 0, %667 ]
  %681 = phi i32 [ %694, %691 ], [ 0, %667 ]
  %682 = shl i32 %681, 8
  %683 = icmp slt i32 %679, 536870912
  br i1 %683, label %684, label %691

684:                                              ; preds = %677
  %685 = add nsw i32 %679, 1
  %686 = sext i32 %679 to i64
  %687 = getelementptr inbounds i8, ptr %559, i64 %686
  %688 = load i8, ptr %687, align 1, !tbaa !14
  %689 = zext i8 %688 to i32
  %690 = or disjoint i32 %682, %689
  br label %691

691:                                              ; preds = %684, %677
  %692 = phi i32 [ %685, %684 ], [ %678, %677 ]
  %693 = phi i32 [ %685, %684 ], [ 536870912, %677 ]
  %694 = phi i32 [ %690, %684 ], [ %682, %677 ]
  %695 = add nuw nsw i32 %680, 1
  %696 = icmp eq i32 %695, %669
  br i1 %696, label %697, label %677, !llvm.loop !139

697:                                              ; preds = %691
  %698 = add i32 %694, -1
  br label %699

699:                                              ; preds = %697, %667
  %700 = phi i32 [ %675, %667 ], [ %692, %697 ]
  %701 = phi i32 [ -1, %667 ], [ %698, %697 ]
  %702 = add nsw i32 %701, %700
  %703 = icmp slt i32 %702, 0
  %704 = tail call i32 @llvm.smin.i32(i32 %702, i32 536870912)
  %705 = select i1 %703, i32 536870912, i32 %704
  %706 = zext i32 %705 to i64
  %707 = or disjoint i64 %706, 2305843009213693952
  br label %708

708:                                              ; preds = %699, %653
  %709 = phi i64 [ %655, %653 ], [ %707, %699 ]
  %710 = trunc i64 %709 to i32
  %711 = sub nsw i32 %710, %634
  %712 = or i32 %711, %634
  %713 = icmp sgt i32 %712, -1
  br i1 %713, label %714, label %723

714:                                              ; preds = %708
  %715 = icmp sgt i32 %634, 536870912
  %716 = icmp sgt i32 %710, 536870912
  %717 = or i1 %715, %716
  br i1 %717, label %723, label %718

718:                                              ; preds = %714
  %719 = and i64 %633, 4294967295
  %720 = getelementptr inbounds nuw i8, ptr %559, i64 %719
  %721 = zext nneg i32 %711 to i64
  %722 = shl nuw nsw i64 %721, 32
  br label %723

723:                                              ; preds = %718, %714, %708
  %724 = phi ptr [ null, %708 ], [ null, %714 ], [ %720, %718 ]
  %725 = phi i64 [ 0, %708 ], [ 0, %714 ], [ %722, %718 ]
  %726 = tail call fastcc { ptr, i64 } @stbtt__cff_index_get(ptr %724, i64 %725, i32 noundef 0) #25
  %727 = extractvalue { ptr, i64 } %726, 0
  %728 = extractvalue { ptr, i64 } %726, 1
  store ptr %727, ptr %4, align 8, !tbaa !57
  %729 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store i64 %728, ptr %729, align 8
  br label %730

730:                                              ; preds = %744, %723
  %731 = phi i32 [ %710, %723 ], [ %745, %744 ]
  %732 = phi i32 [ %710, %723 ], [ %746, %744 ]
  %733 = phi i1 [ false, %723 ], [ true, %744 ]
  %734 = phi i32 [ 0, %723 ], [ %747, %744 ]
  %735 = shl i32 %734, 8
  %736 = icmp slt i32 %732, 536870912
  br i1 %736, label %737, label %744

737:                                              ; preds = %730
  %738 = add nsw i32 %732, 1
  %739 = sext i32 %732 to i64
  %740 = getelementptr inbounds i8, ptr %559, i64 %739
  %741 = load i8, ptr %740, align 1, !tbaa !14
  %742 = zext i8 %741 to i32
  %743 = or disjoint i32 %735, %742
  br label %744

744:                                              ; preds = %737, %730
  %745 = phi i32 [ %738, %737 ], [ %731, %730 ]
  %746 = phi i32 [ %738, %737 ], [ %732, %730 ]
  %747 = phi i32 [ %743, %737 ], [ %735, %730 ]
  br i1 %733, label %748, label %730, !llvm.loop !139

748:                                              ; preds = %744
  %749 = zext i32 %745 to i64
  %750 = or disjoint i64 %749, 2305843009213693952
  %751 = icmp eq i32 %747, 0
  br i1 %751, label %803, label %752

752:                                              ; preds = %748
  %753 = icmp slt i32 %745, 536870912
  br i1 %753, label %754, label %762

754:                                              ; preds = %752
  %755 = add nsw i32 %745, 1
  %756 = zext i32 %755 to i64
  %757 = or disjoint i64 %756, 2305843009213693952
  %758 = sext i32 %745 to i64
  %759 = getelementptr inbounds i8, ptr %559, i64 %758
  %760 = load i8, ptr %759, align 1, !tbaa !14
  %761 = zext i8 %760 to i32
  br label %762

762:                                              ; preds = %754, %752
  %763 = phi i64 [ %757, %754 ], [ %750, %752 ]
  %764 = phi i32 [ %761, %754 ], [ 0, %752 ]
  %765 = mul nsw i32 %764, %747
  %766 = trunc i64 %763 to i32
  %767 = add nsw i32 %765, %766
  %768 = icmp slt i32 %767, 0
  %769 = tail call i32 @llvm.smin.i32(i32 %767, i32 536870912)
  %770 = select i1 %768, i32 536870912, i32 %769
  %771 = icmp eq i32 %764, 0
  br i1 %771, label %794, label %772

772:                                              ; preds = %762, %786
  %773 = phi i32 [ %787, %786 ], [ %770, %762 ]
  %774 = phi i32 [ %788, %786 ], [ %770, %762 ]
  %775 = phi i32 [ %790, %786 ], [ 0, %762 ]
  %776 = phi i32 [ %789, %786 ], [ 0, %762 ]
  %777 = shl i32 %776, 8
  %778 = icmp slt i32 %774, 536870912
  br i1 %778, label %779, label %786

779:                                              ; preds = %772
  %780 = add nsw i32 %774, 1
  %781 = sext i32 %774 to i64
  %782 = getelementptr inbounds i8, ptr %559, i64 %781
  %783 = load i8, ptr %782, align 1, !tbaa !14
  %784 = zext i8 %783 to i32
  %785 = or disjoint i32 %777, %784
  br label %786

786:                                              ; preds = %779, %772
  %787 = phi i32 [ %780, %779 ], [ %773, %772 ]
  %788 = phi i32 [ %780, %779 ], [ 536870912, %772 ]
  %789 = phi i32 [ %785, %779 ], [ %777, %772 ]
  %790 = add nuw nsw i32 %775, 1
  %791 = icmp eq i32 %790, %764
  br i1 %791, label %792, label %772, !llvm.loop !139

792:                                              ; preds = %786
  %793 = add i32 %789, -1
  br label %794

794:                                              ; preds = %792, %762
  %795 = phi i32 [ %770, %762 ], [ %787, %792 ]
  %796 = phi i32 [ -1, %762 ], [ %793, %792 ]
  %797 = add nsw i32 %796, %795
  %798 = icmp slt i32 %797, 0
  %799 = tail call i32 @llvm.smin.i32(i32 %797, i32 536870912)
  %800 = select i1 %798, i32 536870912, i32 %799
  %801 = zext i32 %800 to i64
  %802 = or disjoint i64 %801, 2305843009213693952
  br label %803

803:                                              ; preds = %794, %748
  %804 = phi i64 [ %750, %748 ], [ %802, %794 ]
  %805 = trunc i64 %804 to i32
  br label %806

806:                                              ; preds = %820, %803
  %807 = phi i32 [ %805, %803 ], [ %821, %820 ]
  %808 = phi i32 [ %805, %803 ], [ %822, %820 ]
  %809 = phi i1 [ false, %803 ], [ true, %820 ]
  %810 = phi i32 [ 0, %803 ], [ %823, %820 ]
  %811 = shl i32 %810, 8
  %812 = icmp slt i32 %808, 536870912
  br i1 %812, label %813, label %820

813:                                              ; preds = %806
  %814 = add nsw i32 %808, 1
  %815 = sext i32 %808 to i64
  %816 = getelementptr inbounds i8, ptr %559, i64 %815
  %817 = load i8, ptr %816, align 1, !tbaa !14
  %818 = zext i8 %817 to i32
  %819 = or disjoint i32 %811, %818
  br label %820

820:                                              ; preds = %813, %806
  %821 = phi i32 [ %814, %813 ], [ %807, %806 ]
  %822 = phi i32 [ %814, %813 ], [ %808, %806 ]
  %823 = phi i32 [ %819, %813 ], [ %811, %806 ]
  br i1 %809, label %824, label %806, !llvm.loop !139

824:                                              ; preds = %820
  %825 = getelementptr inbounds nuw i8, ptr %0, i64 96
  %826 = zext i32 %821 to i64
  %827 = or disjoint i64 %826, 2305843009213693952
  %828 = icmp eq i32 %823, 0
  br i1 %828, label %880, label %829

829:                                              ; preds = %824
  %830 = icmp slt i32 %821, 536870912
  br i1 %830, label %831, label %839

831:                                              ; preds = %829
  %832 = add nsw i32 %821, 1
  %833 = zext i32 %832 to i64
  %834 = or disjoint i64 %833, 2305843009213693952
  %835 = sext i32 %821 to i64
  %836 = getelementptr inbounds i8, ptr %559, i64 %835
  %837 = load i8, ptr %836, align 1, !tbaa !14
  %838 = zext i8 %837 to i32
  br label %839

839:                                              ; preds = %831, %829
  %840 = phi i64 [ %834, %831 ], [ %827, %829 ]
  %841 = phi i32 [ %838, %831 ], [ 0, %829 ]
  %842 = mul nsw i32 %841, %823
  %843 = trunc i64 %840 to i32
  %844 = add nsw i32 %842, %843
  %845 = icmp slt i32 %844, 0
  %846 = tail call i32 @llvm.smin.i32(i32 %844, i32 536870912)
  %847 = select i1 %845, i32 536870912, i32 %846
  %848 = icmp eq i32 %841, 0
  br i1 %848, label %871, label %849

849:                                              ; preds = %839, %863
  %850 = phi i32 [ %864, %863 ], [ %847, %839 ]
  %851 = phi i32 [ %865, %863 ], [ %847, %839 ]
  %852 = phi i32 [ %867, %863 ], [ 0, %839 ]
  %853 = phi i32 [ %866, %863 ], [ 0, %839 ]
  %854 = shl i32 %853, 8
  %855 = icmp slt i32 %851, 536870912
  br i1 %855, label %856, label %863

856:                                              ; preds = %849
  %857 = add nsw i32 %851, 1
  %858 = sext i32 %851 to i64
  %859 = getelementptr inbounds i8, ptr %559, i64 %858
  %860 = load i8, ptr %859, align 1, !tbaa !14
  %861 = zext i8 %860 to i32
  %862 = or disjoint i32 %854, %861
  br label %863

863:                                              ; preds = %856, %849
  %864 = phi i32 [ %857, %856 ], [ %850, %849 ]
  %865 = phi i32 [ %857, %856 ], [ 536870912, %849 ]
  %866 = phi i32 [ %862, %856 ], [ %854, %849 ]
  %867 = add nuw nsw i32 %852, 1
  %868 = icmp eq i32 %867, %841
  br i1 %868, label %869, label %849, !llvm.loop !139

869:                                              ; preds = %863
  %870 = add i32 %866, -1
  br label %871

871:                                              ; preds = %869, %839
  %872 = phi i32 [ %847, %839 ], [ %864, %869 ]
  %873 = phi i32 [ -1, %839 ], [ %870, %869 ]
  %874 = add nsw i32 %873, %872
  %875 = icmp slt i32 %874, 0
  %876 = tail call i32 @llvm.smin.i32(i32 %874, i32 536870912)
  %877 = select i1 %875, i32 536870912, i32 %876
  %878 = zext i32 %877 to i64
  %879 = or disjoint i64 %878, 2305843009213693952
  br label %880

880:                                              ; preds = %871, %824
  %881 = phi i64 [ %827, %824 ], [ %879, %871 ]
  %882 = trunc i64 %881 to i32
  %883 = sub nsw i32 %882, %805
  %884 = or i32 %883, %805
  %885 = icmp sgt i32 %884, -1
  br i1 %885, label %886, label %895

886:                                              ; preds = %880
  %887 = icmp sgt i32 %805, 536870912
  %888 = icmp sgt i32 %882, 536870912
  %889 = or i1 %887, %888
  br i1 %889, label %895, label %890

890:                                              ; preds = %886
  %891 = and i64 %804, 4294967295
  %892 = getelementptr inbounds nuw i8, ptr %559, i64 %891
  %893 = zext nneg i32 %883 to i64
  %894 = shl nuw nsw i64 %893, 32
  br label %895

895:                                              ; preds = %890, %886, %880
  %896 = phi ptr [ null, %880 ], [ null, %886 ], [ %892, %890 ]
  %897 = phi i64 [ 0, %880 ], [ 0, %886 ], [ %894, %890 ]
  store ptr %896, ptr %825, align 8, !tbaa !57
  %898 = getelementptr inbounds nuw i8, ptr %0, i64 104
  store i64 %897, ptr %898, align 8
  call fastcc void @stbtt__dict_get_ints(ptr noundef %4, i32 noundef 17, i32 noundef 1, ptr noundef %6) #25
  call fastcc void @stbtt__dict_get_ints(ptr noundef %4, i32 noundef 262, i32 noundef 1, ptr noundef %5) #25
  call fastcc void @stbtt__dict_get_ints(ptr noundef %4, i32 noundef 292, i32 noundef 1, ptr noundef %7) #25
  call fastcc void @stbtt__dict_get_ints(ptr noundef %4, i32 noundef 293, i32 noundef 1, ptr noundef %8) #25
  %899 = getelementptr inbounds nuw i8, ptr %0, i64 112
  %900 = load ptr, ptr %4, align 8
  %901 = load i64, ptr %729, align 8
  %902 = tail call fastcc { ptr, i64 } @stbtt__get_subrs(ptr nonnull %559, i64 %881, ptr %900, i64 %901) #25
  %903 = extractvalue { ptr, i64 } %902, 0
  %904 = extractvalue { ptr, i64 } %902, 1
  store ptr %903, ptr %899, align 8, !tbaa !57
  %905 = getelementptr inbounds nuw i8, ptr %0, i64 120
  store i64 %904, ptr %905, align 8
  %906 = load i32, ptr %5, align 4, !tbaa !4
  %907 = icmp ne i32 %906, 2
  %908 = load i32, ptr %6, align 4
  %909 = icmp eq i32 %908, 0
  %910 = select i1 %907, i1 true, i1 %909
  br i1 %910, label %1277, label %911

911:                                              ; preds = %895
  %912 = load i32, ptr %7, align 4, !tbaa !4
  %913 = icmp eq i32 %912, 0
  br i1 %913, label %1026, label %914

914:                                              ; preds = %911
  %915 = load i32, ptr %8, align 4, !tbaa !4
  %916 = icmp eq i32 %915, 0
  br i1 %916, label %1277, label %917

917:                                              ; preds = %914
  %918 = icmp slt i32 %912, 0
  %919 = tail call i32 @llvm.smin.i32(i32 %912, i32 536870912)
  %920 = select i1 %918, i32 536870912, i32 %919
  %921 = zext i32 %920 to i64
  %922 = or disjoint i64 %921, 2305843009213693952
  br label %923

923:                                              ; preds = %939, %917
  %924 = phi i64 [ %922, %917 ], [ %940, %939 ]
  %925 = phi i32 [ %920, %917 ], [ %941, %939 ]
  %926 = phi i1 [ false, %917 ], [ true, %939 ]
  %927 = phi i32 [ 0, %917 ], [ %942, %939 ]
  %928 = shl i32 %927, 8
  %929 = icmp slt i32 %925, 536870912
  br i1 %929, label %930, label %939

930:                                              ; preds = %923
  %931 = add nsw i32 %925, 1
  %932 = zext i32 %931 to i64
  %933 = or disjoint i64 %932, 2305843009213693952
  %934 = sext i32 %925 to i64
  %935 = getelementptr inbounds i8, ptr %559, i64 %934
  %936 = load i8, ptr %935, align 1, !tbaa !14
  %937 = zext i8 %936 to i32
  %938 = or disjoint i32 %928, %937
  br label %939

939:                                              ; preds = %930, %923
  %940 = phi i64 [ %933, %930 ], [ %924, %923 ]
  %941 = phi i32 [ %931, %930 ], [ 536870912, %923 ]
  %942 = phi i32 [ %938, %930 ], [ %928, %923 ]
  br i1 %926, label %943, label %923, !llvm.loop !139

943:                                              ; preds = %939
  %944 = icmp eq i32 %942, 0
  br i1 %944, label %1001, label %945

945:                                              ; preds = %943
  %946 = trunc i64 %940 to i32
  %947 = icmp slt i32 %946, 536870912
  br i1 %947, label %948, label %955

948:                                              ; preds = %945
  %949 = add nuw nsw i64 %940, 1
  %950 = shl i64 %940, 32
  %951 = ashr exact i64 %950, 32
  %952 = getelementptr inbounds i8, ptr %559, i64 %951
  %953 = load i8, ptr %952, align 1, !tbaa !14
  %954 = zext i8 %953 to i32
  br label %955

955:                                              ; preds = %948, %945
  %956 = phi i64 [ %949, %948 ], [ %940, %945 ]
  %957 = phi i32 [ %954, %948 ], [ 0, %945 ]
  %958 = mul nsw i32 %957, %942
  %959 = trunc i64 %956 to i32
  %960 = add nsw i32 %958, %959
  %961 = icmp slt i32 %960, 0
  %962 = tail call i32 @llvm.smin.i32(i32 %960, i32 536870912)
  %963 = select i1 %961, i32 536870912, i32 %962
  %964 = zext i32 %963 to i64
  %965 = or disjoint i64 %964, 2305843009213693952
  %966 = icmp eq i32 %957, 0
  br i1 %966, label %991, label %967

967:                                              ; preds = %955, %983
  %968 = phi i64 [ %984, %983 ], [ %965, %955 ]
  %969 = phi i32 [ %985, %983 ], [ %963, %955 ]
  %970 = phi i32 [ %987, %983 ], [ 0, %955 ]
  %971 = phi i32 [ %986, %983 ], [ 0, %955 ]
  %972 = shl i32 %971, 8
  %973 = icmp slt i32 %969, 536870912
  br i1 %973, label %974, label %983

974:                                              ; preds = %967
  %975 = add nsw i32 %969, 1
  %976 = zext i32 %975 to i64
  %977 = or disjoint i64 %976, 2305843009213693952
  %978 = sext i32 %969 to i64
  %979 = getelementptr inbounds i8, ptr %559, i64 %978
  %980 = load i8, ptr %979, align 1, !tbaa !14
  %981 = zext i8 %980 to i32
  %982 = or disjoint i32 %972, %981
  br label %983

983:                                              ; preds = %974, %967
  %984 = phi i64 [ %977, %974 ], [ %968, %967 ]
  %985 = phi i32 [ %975, %974 ], [ 536870912, %967 ]
  %986 = phi i32 [ %982, %974 ], [ %972, %967 ]
  %987 = add nuw nsw i32 %970, 1
  %988 = icmp eq i32 %987, %957
  br i1 %988, label %989, label %967, !llvm.loop !139

989:                                              ; preds = %983
  %990 = add i32 %986, -1
  br label %991

991:                                              ; preds = %989, %955
  %992 = phi i64 [ %965, %955 ], [ %984, %989 ]
  %993 = phi i32 [ -1, %955 ], [ %990, %989 ]
  %994 = trunc i64 %992 to i32
  %995 = add nsw i32 %993, %994
  %996 = icmp slt i32 %995, 0
  %997 = tail call i32 @llvm.smin.i32(i32 %995, i32 536870912)
  %998 = select i1 %996, i32 536870912, i32 %997
  %999 = zext i32 %998 to i64
  %1000 = or disjoint i64 %999, 2305843009213693952
  br label %1001

1001:                                             ; preds = %991, %943
  %1002 = phi i64 [ %940, %943 ], [ %1000, %991 ]
  %1003 = trunc i64 %1002 to i32
  %1004 = sub nsw i32 %1003, %920
  %1005 = or i32 %1004, %920
  %1006 = icmp slt i32 %1005, 0
  %1007 = icmp sgt i32 %1003, 536870912
  %1008 = or i1 %1006, %1007
  %1009 = zext nneg i32 %920 to i64
  %1010 = getelementptr inbounds nuw i8, ptr %559, i64 %1009
  %1011 = zext nneg i32 %1004 to i64
  %1012 = shl nuw nsw i64 %1011, 32
  %1013 = select i1 %1008, ptr null, ptr %1010
  %1014 = select i1 %1008, i64 0, i64 %1012
  store ptr %1013, ptr %554, align 8, !tbaa !57
  store i64 %1014, ptr %555, align 8
  %1015 = sub i32 536870912, %915
  %1016 = or i32 %1015, %915
  %1017 = icmp slt i32 %1016, 0
  %1018 = icmp sgt i32 %915, 536870912
  %1019 = or i1 %1018, %1017
  %1020 = zext nneg i32 %915 to i64
  %1021 = getelementptr inbounds nuw i8, ptr %559, i64 %1020
  %1022 = zext nneg i32 %1015 to i64
  %1023 = shl nuw nsw i64 %1022, 32
  %1024 = select i1 %1019, ptr null, ptr %1021
  %1025 = select i1 %1019, i64 0, i64 %1023
  store ptr %1024, ptr %556, align 8, !tbaa !57
  store i64 %1025, ptr %557, align 8
  br label %1026

1026:                                             ; preds = %1001, %911
  %1027 = icmp slt i32 %908, 0
  %1028 = tail call i32 @llvm.smin.i32(i32 %908, i32 536870912)
  %1029 = select i1 %1027, i32 536870912, i32 %1028
  %1030 = zext i32 %1029 to i64
  %1031 = or disjoint i64 %1030, 2305843009213693952
  br label %1032

1032:                                             ; preds = %1048, %1026
  %1033 = phi i64 [ %1031, %1026 ], [ %1049, %1048 ]
  %1034 = phi i32 [ %1029, %1026 ], [ %1050, %1048 ]
  %1035 = phi i1 [ false, %1026 ], [ true, %1048 ]
  %1036 = phi i32 [ 0, %1026 ], [ %1051, %1048 ]
  %1037 = shl i32 %1036, 8
  %1038 = icmp slt i32 %1034, 536870912
  br i1 %1038, label %1039, label %1048

1039:                                             ; preds = %1032
  %1040 = add nsw i32 %1034, 1
  %1041 = zext i32 %1040 to i64
  %1042 = or disjoint i64 %1041, 2305843009213693952
  %1043 = sext i32 %1034 to i64
  %1044 = getelementptr inbounds i8, ptr %559, i64 %1043
  %1045 = load i8, ptr %1044, align 1, !tbaa !14
  %1046 = zext i8 %1045 to i32
  %1047 = or disjoint i32 %1037, %1046
  br label %1048

1048:                                             ; preds = %1039, %1032
  %1049 = phi i64 [ %1042, %1039 ], [ %1033, %1032 ]
  %1050 = phi i32 [ %1040, %1039 ], [ 536870912, %1032 ]
  %1051 = phi i32 [ %1047, %1039 ], [ %1037, %1032 ]
  br i1 %1035, label %1052, label %1032, !llvm.loop !139

1052:                                             ; preds = %1048
  %1053 = getelementptr inbounds nuw i8, ptr %0, i64 80
  %1054 = icmp eq i32 %1051, 0
  br i1 %1054, label %1111, label %1055

1055:                                             ; preds = %1052
  %1056 = trunc i64 %1049 to i32
  %1057 = icmp slt i32 %1056, 536870912
  br i1 %1057, label %1058, label %1065

1058:                                             ; preds = %1055
  %1059 = add nuw nsw i64 %1049, 1
  %1060 = shl i64 %1049, 32
  %1061 = ashr exact i64 %1060, 32
  %1062 = getelementptr inbounds i8, ptr %559, i64 %1061
  %1063 = load i8, ptr %1062, align 1, !tbaa !14
  %1064 = zext i8 %1063 to i32
  br label %1065

1065:                                             ; preds = %1058, %1055
  %1066 = phi i64 [ %1059, %1058 ], [ %1049, %1055 ]
  %1067 = phi i32 [ %1064, %1058 ], [ 0, %1055 ]
  %1068 = mul nsw i32 %1067, %1051
  %1069 = trunc i64 %1066 to i32
  %1070 = add nsw i32 %1068, %1069
  %1071 = icmp slt i32 %1070, 0
  %1072 = tail call i32 @llvm.smin.i32(i32 %1070, i32 536870912)
  %1073 = select i1 %1071, i32 536870912, i32 %1072
  %1074 = zext i32 %1073 to i64
  %1075 = or disjoint i64 %1074, 2305843009213693952
  %1076 = icmp eq i32 %1067, 0
  br i1 %1076, label %1101, label %1077

1077:                                             ; preds = %1065, %1093
  %1078 = phi i64 [ %1094, %1093 ], [ %1075, %1065 ]
  %1079 = phi i32 [ %1095, %1093 ], [ %1073, %1065 ]
  %1080 = phi i32 [ %1097, %1093 ], [ 0, %1065 ]
  %1081 = phi i32 [ %1096, %1093 ], [ 0, %1065 ]
  %1082 = shl i32 %1081, 8
  %1083 = icmp slt i32 %1079, 536870912
  br i1 %1083, label %1084, label %1093

1084:                                             ; preds = %1077
  %1085 = add nsw i32 %1079, 1
  %1086 = zext i32 %1085 to i64
  %1087 = or disjoint i64 %1086, 2305843009213693952
  %1088 = sext i32 %1079 to i64
  %1089 = getelementptr inbounds i8, ptr %559, i64 %1088
  %1090 = load i8, ptr %1089, align 1, !tbaa !14
  %1091 = zext i8 %1090 to i32
  %1092 = or disjoint i32 %1082, %1091
  br label %1093

1093:                                             ; preds = %1084, %1077
  %1094 = phi i64 [ %1087, %1084 ], [ %1078, %1077 ]
  %1095 = phi i32 [ %1085, %1084 ], [ 536870912, %1077 ]
  %1096 = phi i32 [ %1092, %1084 ], [ %1082, %1077 ]
  %1097 = add nuw nsw i32 %1080, 1
  %1098 = icmp eq i32 %1097, %1067
  br i1 %1098, label %1099, label %1077, !llvm.loop !139

1099:                                             ; preds = %1093
  %1100 = add i32 %1096, -1
  br label %1101

1101:                                             ; preds = %1099, %1065
  %1102 = phi i64 [ %1075, %1065 ], [ %1094, %1099 ]
  %1103 = phi i32 [ -1, %1065 ], [ %1100, %1099 ]
  %1104 = trunc i64 %1102 to i32
  %1105 = add nsw i32 %1103, %1104
  %1106 = icmp slt i32 %1105, 0
  %1107 = tail call i32 @llvm.smin.i32(i32 %1105, i32 536870912)
  %1108 = select i1 %1106, i32 536870912, i32 %1107
  %1109 = zext i32 %1108 to i64
  %1110 = or disjoint i64 %1109, 2305843009213693952
  br label %1111

1111:                                             ; preds = %1101, %1052
  %1112 = phi i64 [ %1049, %1052 ], [ %1110, %1101 ]
  %1113 = trunc i64 %1112 to i32
  %1114 = sub nsw i32 %1113, %1029
  %1115 = or i32 %1114, %1029
  %1116 = icmp slt i32 %1115, 0
  %1117 = icmp sgt i32 %1113, 536870912
  %1118 = or i1 %1116, %1117
  %1119 = zext nneg i32 %1029 to i64
  %1120 = getelementptr inbounds nuw i8, ptr %559, i64 %1119
  %1121 = zext nneg i32 %1114 to i64
  %1122 = shl nuw nsw i64 %1121, 32
  %1123 = select i1 %1118, ptr null, ptr %1120
  %1124 = select i1 %1118, i64 0, i64 %1122
  store ptr %1123, ptr %1053, align 8, !tbaa !57
  %1125 = getelementptr inbounds nuw i8, ptr %0, i64 88
  store i64 %1124, ptr %1125, align 8
  call void @llvm.lifetime.end.p0(ptr nonnull %8) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #26
  br label %1126

1126:                                             ; preds = %1111, %491
  %1127 = load i8, ptr %15, align 1, !tbaa !14
  %1128 = zext i8 %1127 to i32
  %1129 = shl nuw nsw i32 %1128, 8
  %1130 = load i8, ptr %19, align 1, !tbaa !14
  %1131 = zext i8 %1130 to i32
  %1132 = or disjoint i32 %1129, %1131
  %1133 = icmp eq i32 %1132, 0
  br i1 %1133, label %1183, label %1134

1134:                                             ; preds = %1126
  %1135 = zext nneg i32 %1132 to i64
  br label %1139

1136:                                             ; preds = %1180
  %1137 = add nuw nsw i64 %1140, 1
  %1138 = icmp eq i64 %1137, %1135
  br i1 %1138, label %1183, label %1139, !llvm.loop !53

1139:                                             ; preds = %1136, %1134
  %1140 = phi i64 [ 0, %1134 ], [ %1137, %1136 ]
  %1141 = phi i32 [ undef, %1134 ], [ %1181, %1136 ]
  %1142 = trunc i64 %1140 to i32
  %1143 = shl i32 %1142, 4
  %1144 = add i32 %1143, %23
  %1145 = zext i32 %1144 to i64
  %1146 = getelementptr inbounds nuw i8, ptr %1, i64 %1145
  %1147 = load i8, ptr %1146, align 1, !tbaa !14
  %1148 = icmp eq i8 %1147, 109
  br i1 %1148, label %1149, label %1180

1149:                                             ; preds = %1139
  %1150 = getelementptr inbounds nuw i8, ptr %1146, i64 1
  %1151 = load i8, ptr %1150, align 1, !tbaa !14
  %1152 = icmp eq i8 %1151, 97
  br i1 %1152, label %1153, label %1180

1153:                                             ; preds = %1149
  %1154 = getelementptr inbounds nuw i8, ptr %1146, i64 2
  %1155 = load i8, ptr %1154, align 1, !tbaa !14
  %1156 = icmp eq i8 %1155, 120
  br i1 %1156, label %1157, label %1180

1157:                                             ; preds = %1153
  %1158 = getelementptr inbounds nuw i8, ptr %1146, i64 3
  %1159 = load i8, ptr %1158, align 1, !tbaa !14
  %1160 = icmp eq i8 %1159, 112
  br i1 %1160, label %1161, label %1180

1161:                                             ; preds = %1157
  %1162 = getelementptr inbounds nuw i8, ptr %1146, i64 8
  %1163 = load i8, ptr %1162, align 1, !tbaa !14
  %1164 = zext i8 %1163 to i32
  %1165 = shl nuw i32 %1164, 24
  %1166 = getelementptr inbounds nuw i8, ptr %1146, i64 9
  %1167 = load i8, ptr %1166, align 1, !tbaa !14
  %1168 = zext i8 %1167 to i32
  %1169 = shl nuw nsw i32 %1168, 16
  %1170 = or disjoint i32 %1169, %1165
  %1171 = getelementptr inbounds nuw i8, ptr %1146, i64 10
  %1172 = load i8, ptr %1171, align 1, !tbaa !14
  %1173 = zext i8 %1172 to i32
  %1174 = shl nuw nsw i32 %1173, 8
  %1175 = or disjoint i32 %1170, %1174
  %1176 = getelementptr inbounds nuw i8, ptr %1146, i64 11
  %1177 = load i8, ptr %1176, align 1, !tbaa !14
  %1178 = zext i8 %1177 to i32
  %1179 = or disjoint i32 %1175, %1178
  br label %1180

1180:                                             ; preds = %1161, %1157, %1153, %1149, %1139
  %1181 = phi i32 [ %1179, %1161 ], [ %1141, %1157 ], [ %1141, %1153 ], [ %1141, %1149 ], [ %1141, %1139 ]
  %1182 = phi i1 [ false, %1161 ], [ true, %1157 ], [ true, %1153 ], [ true, %1149 ], [ true, %1139 ]
  br i1 %1182, label %1136, label %1183

1183:                                             ; preds = %1180, %1136, %1126
  %1184 = phi i32 [ 0, %1126 ], [ %1181, %1180 ], [ 0, %1136 ]
  %1185 = icmp eq i32 %1184, 0
  br i1 %1185, label %1197, label %1186

1186:                                             ; preds = %1183
  %1187 = zext i32 %1184 to i64
  %1188 = getelementptr inbounds nuw i8, ptr %1, i64 %1187
  %1189 = getelementptr inbounds nuw i8, ptr %1188, i64 4
  %1190 = load i8, ptr %1189, align 1, !tbaa !14
  %1191 = zext i8 %1190 to i32
  %1192 = shl nuw nsw i32 %1191, 8
  %1193 = getelementptr inbounds nuw i8, ptr %1188, i64 5
  %1194 = load i8, ptr %1193, align 1, !tbaa !14
  %1195 = zext i8 %1194 to i32
  %1196 = or disjoint i32 %1192, %1195
  br label %1197

1197:                                             ; preds = %1183, %1186
  %1198 = phi i32 [ %1196, %1186 ], [ 65535, %1183 ]
  %1199 = getelementptr inbounds nuw i8, ptr %0, i64 20
  store i32 %1198, ptr %1199, align 4, !tbaa !33
  %1200 = getelementptr inbounds nuw i8, ptr %0, i64 52
  store i32 -1, ptr %1200, align 4, !tbaa !55
  %1201 = zext i32 %75 to i64
  %1202 = getelementptr inbounds nuw i8, ptr %1, i64 %1201
  %1203 = getelementptr inbounds nuw i8, ptr %1202, i64 2
  %1204 = load i8, ptr %1203, align 1, !tbaa !14
  %1205 = zext i8 %1204 to i32
  %1206 = shl nuw nsw i32 %1205, 8
  %1207 = getelementptr inbounds nuw i8, ptr %1202, i64 3
  %1208 = load i8, ptr %1207, align 1, !tbaa !14
  %1209 = zext i8 %1208 to i32
  %1210 = or disjoint i32 %1206, %1209
  %1211 = getelementptr inbounds nuw i8, ptr %0, i64 56
  store i32 0, ptr %1211, align 8, !tbaa !13
  %1212 = icmp eq i32 %1210, 0
  br i1 %1212, label %1262, label %1213

1213:                                             ; preds = %1197
  %1214 = add i32 %75, 4
  %1215 = zext nneg i32 %1210 to i64
  br label %1216

1216:                                             ; preds = %1259, %1213
  %1217 = phi i64 [ 0, %1213 ], [ %1260, %1259 ]
  %1218 = trunc i64 %1217 to i32
  %1219 = shl i32 %1218, 3
  %1220 = add i32 %1214, %1219
  %1221 = zext i32 %1220 to i64
  %1222 = getelementptr inbounds nuw i8, ptr %1, i64 %1221
  %1223 = load i8, ptr %1222, align 1, !tbaa !14
  %1224 = zext i8 %1223 to i16
  %1225 = shl nuw i16 %1224, 8
  %1226 = getelementptr inbounds nuw i8, ptr %1222, i64 1
  %1227 = load i8, ptr %1226, align 1, !tbaa !14
  %1228 = zext i8 %1227 to i16
  %1229 = or disjoint i16 %1225, %1228
  switch i16 %1229, label %1259 [
    i16 3, label %1230
    i16 0, label %1239
  ]

1230:                                             ; preds = %1216
  %1231 = getelementptr inbounds nuw i8, ptr %1222, i64 2
  %1232 = load i8, ptr %1231, align 1, !tbaa !14
  %1233 = zext i8 %1232 to i16
  %1234 = shl nuw i16 %1233, 8
  %1235 = getelementptr inbounds nuw i8, ptr %1222, i64 3
  %1236 = load i8, ptr %1235, align 1, !tbaa !14
  %1237 = zext i8 %1236 to i16
  %1238 = or disjoint i16 %1234, %1237
  switch i16 %1238, label %1259 [
    i16 1, label %1239
    i16 10, label %1239
  ]

1239:                                             ; preds = %1216, %1230, %1230
  %1240 = getelementptr inbounds nuw i8, ptr %1222, i64 4
  %1241 = load i8, ptr %1240, align 1, !tbaa !14
  %1242 = zext i8 %1241 to i32
  %1243 = shl nuw i32 %1242, 24
  %1244 = getelementptr inbounds nuw i8, ptr %1222, i64 5
  %1245 = load i8, ptr %1244, align 1, !tbaa !14
  %1246 = zext i8 %1245 to i32
  %1247 = shl nuw nsw i32 %1246, 16
  %1248 = or disjoint i32 %1247, %1243
  %1249 = getelementptr inbounds nuw i8, ptr %1222, i64 6
  %1250 = load i8, ptr %1249, align 1, !tbaa !14
  %1251 = zext i8 %1250 to i32
  %1252 = shl nuw nsw i32 %1251, 8
  %1253 = or disjoint i32 %1248, %1252
  %1254 = getelementptr inbounds nuw i8, ptr %1222, i64 7
  %1255 = load i8, ptr %1254, align 1, !tbaa !14
  %1256 = zext i8 %1255 to i32
  %1257 = or disjoint i32 %1253, %1256
  %1258 = add i32 %1257, %75
  store i32 %1258, ptr %1211, align 8, !tbaa !13
  br label %1259

1259:                                             ; preds = %1239, %1230, %1216
  %1260 = add nuw nsw i64 %1217, 1
  %1261 = icmp eq i64 %1260, %1215
  br i1 %1261, label %1262, label %1216, !llvm.loop !140

1262:                                             ; preds = %1259, %1197
  %1263 = load i32, ptr %1211, align 8, !tbaa !13
  %1264 = icmp eq i32 %1263, 0
  br i1 %1264, label %1278, label %1265

1265:                                             ; preds = %1262
  %1266 = sext i32 %185 to i64
  %1267 = getelementptr inbounds i8, ptr %1, i64 %1266
  %1268 = getelementptr inbounds nuw i8, ptr %1267, i64 50
  %1269 = load i8, ptr %1268, align 1, !tbaa !14
  %1270 = zext i8 %1269 to i32
  %1271 = shl nuw nsw i32 %1270, 8
  %1272 = getelementptr inbounds nuw i8, ptr %1267, i64 51
  %1273 = load i8, ptr %1272, align 1, !tbaa !14
  %1274 = zext i8 %1273 to i32
  %1275 = or disjoint i32 %1271, %1274
  %1276 = getelementptr inbounds nuw i8, ptr %0, i64 60
  store i32 %1275, ptr %1276, align 4, !tbaa !34
  br label %1278

1277:                                             ; preds = %914, %895, %550
  call void @llvm.lifetime.end.p0(ptr nonnull %8) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #26
  br label %1278

1278:                                             ; preds = %479, %491, %1262, %1265, %1277
  %1279 = phi i32 [ 0, %491 ], [ 1, %1265 ], [ 0, %479 ], [ 0, %1277 ], [ 0, %1262 ]
  ret i32 %1279
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define dso_local i32 @stbtt_GetFontOffsetForIndex(ptr noundef readonly captures(none) %0, i32 noundef %1) local_unnamed_addr #16 {
  %3 = tail call fastcc i32 @stbtt__isfont(ptr noundef readonly %0) #25
  %4 = icmp eq i32 %3, 0
  br i1 %4, label %8, label %5

5:                                                ; preds = %2
  %6 = icmp ne i32 %1, 0
  %7 = sext i1 %6 to i32
  br label %84

8:                                                ; preds = %2
  %9 = load i8, ptr %0, align 1, !tbaa !14
  %10 = icmp eq i8 %9, 116
  br i1 %10, label %11, label %84

11:                                               ; preds = %8
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 1
  %13 = load i8, ptr %12, align 1, !tbaa !14
  %14 = icmp eq i8 %13, 116
  br i1 %14, label %15, label %84

15:                                               ; preds = %11
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %17 = load i8, ptr %16, align 1, !tbaa !14
  %18 = icmp eq i8 %17, 99
  br i1 %18, label %19, label %84

19:                                               ; preds = %15
  %20 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %21 = load i8, ptr %20, align 1, !tbaa !14
  %22 = icmp eq i8 %21, 102
  br i1 %22, label %23, label %84

23:                                               ; preds = %19
  %24 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %25 = load i8, ptr %24, align 1, !tbaa !14
  %26 = zext i8 %25 to i32
  %27 = shl nuw i32 %26, 24
  %28 = getelementptr inbounds nuw i8, ptr %0, i64 5
  %29 = load i8, ptr %28, align 1, !tbaa !14
  %30 = zext i8 %29 to i32
  %31 = shl nuw nsw i32 %30, 16
  %32 = or disjoint i32 %31, %27
  %33 = getelementptr inbounds nuw i8, ptr %0, i64 6
  %34 = load i8, ptr %33, align 1, !tbaa !14
  %35 = zext i8 %34 to i32
  %36 = shl nuw nsw i32 %35, 8
  %37 = or disjoint i32 %32, %36
  %38 = getelementptr inbounds nuw i8, ptr %0, i64 7
  %39 = load i8, ptr %38, align 1, !tbaa !14
  %40 = zext i8 %39 to i32
  %41 = or disjoint i32 %37, %40
  switch i32 %41, label %84 [
    i32 65536, label %42
    i32 131072, label %42
  ]

42:                                               ; preds = %23, %23
  %43 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %44 = load i8, ptr %43, align 1, !tbaa !14
  %45 = zext i8 %44 to i32
  %46 = shl nuw i32 %45, 24
  %47 = getelementptr inbounds nuw i8, ptr %0, i64 9
  %48 = load i8, ptr %47, align 1, !tbaa !14
  %49 = zext i8 %48 to i32
  %50 = shl nuw nsw i32 %49, 16
  %51 = or disjoint i32 %50, %46
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 10
  %53 = load i8, ptr %52, align 1, !tbaa !14
  %54 = zext i8 %53 to i32
  %55 = shl nuw nsw i32 %54, 8
  %56 = or disjoint i32 %51, %55
  %57 = getelementptr inbounds nuw i8, ptr %0, i64 11
  %58 = load i8, ptr %57, align 1, !tbaa !14
  %59 = zext i8 %58 to i32
  %60 = or disjoint i32 %56, %59
  %61 = icmp slt i32 %1, %60
  br i1 %61, label %62, label %84

62:                                               ; preds = %42
  %63 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %64 = shl nsw i32 %1, 2
  %65 = sext i32 %64 to i64
  %66 = getelementptr inbounds i8, ptr %63, i64 %65
  %67 = load i8, ptr %66, align 1, !tbaa !14
  %68 = zext i8 %67 to i32
  %69 = shl nuw i32 %68, 24
  %70 = getelementptr inbounds nuw i8, ptr %66, i64 1
  %71 = load i8, ptr %70, align 1, !tbaa !14
  %72 = zext i8 %71 to i32
  %73 = shl nuw nsw i32 %72, 16
  %74 = or disjoint i32 %73, %69
  %75 = getelementptr inbounds nuw i8, ptr %66, i64 2
  %76 = load i8, ptr %75, align 1, !tbaa !14
  %77 = zext i8 %76 to i32
  %78 = shl nuw nsw i32 %77, 8
  %79 = or disjoint i32 %74, %78
  %80 = getelementptr inbounds nuw i8, ptr %66, i64 3
  %81 = load i8, ptr %80, align 1, !tbaa !14
  %82 = zext i8 %81 to i32
  %83 = or disjoint i32 %79, %82
  br label %84

84:                                               ; preds = %5, %8, %11, %15, %19, %23, %42, %62
  %85 = phi i32 [ %7, %5 ], [ -1, %42 ], [ %83, %62 ], [ -1, %23 ], [ -1, %19 ], [ -1, %15 ], [ -1, %11 ], [ -1, %8 ]
  ret i32 %85
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: write)
define dso_local noundef i32 @stbtt_PackFontRange(ptr noundef readnone captures(none) %0, ptr noundef readnone captures(none) %1, i32 noundef %2, float noundef %3, i32 noundef %4, i32 noundef %5, ptr noundef writeonly captures(none) %6) local_unnamed_addr #17 {
  %8 = icmp sgt i32 %5, 0
  br i1 %8, label %9, label %19

9:                                                ; preds = %7
  %10 = zext nneg i32 %5 to i64
  br label %11

11:                                               ; preds = %11, %9
  %12 = phi i64 [ 0, %9 ], [ %17, %11 ]
  %13 = getelementptr inbounds nuw %struct.stbtt_packedchar, ptr %6, i64 %12
  %14 = getelementptr inbounds nuw i8, ptr %13, i64 6
  store i16 0, ptr %14, align 2, !tbaa !118
  %15 = getelementptr inbounds nuw i8, ptr %13, i64 4
  store i16 0, ptr %15, align 4, !tbaa !117
  %16 = getelementptr inbounds nuw i8, ptr %13, i64 2
  store i16 0, ptr %16, align 2, !tbaa !116
  store i16 0, ptr %13, align 4, !tbaa !114
  %17 = add nuw nsw i64 %12, 1
  %18 = icmp eq i64 %17, %10
  br i1 %18, label %19, label %11, !llvm.loop !137

19:                                               ; preds = %11, %7
  ret i32 0
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local void @stbtt_GetScaledFontVMetrics(ptr noundef %0, i32 noundef %1, float noundef %2, ptr noundef writeonly captures(none) initializes((0, 4)) %3, ptr noundef writeonly captures(none) initializes((0, 4)) %4, ptr noundef writeonly captures(none) initializes((0, 4)) %5) local_unnamed_addr #6 {
  %7 = alloca %struct.stbtt_fontinfo, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #26
  %8 = tail call i32 @stbtt_GetFontOffsetForIndex(ptr noundef %0, i32 noundef %1) #25
  %9 = call i32 @stbtt_InitFont(ptr noundef nonnull %7, ptr noundef %0, i32 noundef %8) #25
  %10 = fcmp ogt float %2, 0.000000e+00
  br i1 %10, label %11, label %39

11:                                               ; preds = %6
  %12 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %13 = load ptr, ptr %12, align 8, !tbaa !8
  %14 = getelementptr inbounds nuw i8, ptr %7, i64 36
  %15 = load i32, ptr %14, align 4, !tbaa !37
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds i8, ptr %13, i64 %16
  %18 = getelementptr inbounds nuw i8, ptr %17, i64 4
  %19 = load i8, ptr %18, align 1, !tbaa !14
  %20 = zext i8 %19 to i16
  %21 = shl nuw i16 %20, 8
  %22 = getelementptr inbounds nuw i8, ptr %17, i64 5
  %23 = load i8, ptr %22, align 1, !tbaa !14
  %24 = zext i8 %23 to i16
  %25 = or disjoint i16 %21, %24
  %26 = sext i16 %25 to i32
  %27 = getelementptr inbounds nuw i8, ptr %17, i64 6
  %28 = load i8, ptr %27, align 1, !tbaa !14
  %29 = zext i8 %28 to i16
  %30 = shl nuw i16 %29, 8
  %31 = getelementptr inbounds nuw i8, ptr %17, i64 7
  %32 = load i8, ptr %31, align 1, !tbaa !14
  %33 = zext i8 %32 to i16
  %34 = or disjoint i16 %30, %33
  %35 = sext i16 %34 to i32
  %36 = sub nsw i32 %26, %35
  %37 = sitofp i32 %36 to float
  %38 = fdiv float %2, %37
  br label %57

39:                                               ; preds = %6
  %40 = fneg float %2
  %41 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %42 = load ptr, ptr %41, align 8, !tbaa !8
  %43 = getelementptr inbounds nuw i8, ptr %7, i64 28
  %44 = load i32, ptr %43, align 4, !tbaa !54
  %45 = sext i32 %44 to i64
  %46 = getelementptr inbounds i8, ptr %42, i64 %45
  %47 = getelementptr inbounds nuw i8, ptr %46, i64 18
  %48 = load i8, ptr %47, align 1, !tbaa !14
  %49 = zext i8 %48 to i16
  %50 = shl nuw i16 %49, 8
  %51 = getelementptr inbounds nuw i8, ptr %46, i64 19
  %52 = load i8, ptr %51, align 1, !tbaa !14
  %53 = zext i8 %52 to i16
  %54 = or disjoint i16 %50, %53
  %55 = uitofp i16 %54 to float
  %56 = fdiv float %40, %55
  br label %57

57:                                               ; preds = %39, %11
  %58 = phi float [ %38, %11 ], [ %56, %39 ]
  %59 = getelementptr inbounds nuw i8, ptr %7, i64 8
  %60 = load ptr, ptr %59, align 8, !tbaa !8
  %61 = getelementptr inbounds nuw i8, ptr %7, i64 36
  %62 = load i32, ptr %61, align 4, !tbaa !37
  %63 = sext i32 %62 to i64
  %64 = getelementptr inbounds i8, ptr %60, i64 %63
  %65 = getelementptr inbounds nuw i8, ptr %64, i64 4
  %66 = load i8, ptr %65, align 1, !tbaa !14
  %67 = zext i8 %66 to i16
  %68 = shl nuw i16 %67, 8
  %69 = getelementptr inbounds nuw i8, ptr %64, i64 5
  %70 = load i8, ptr %69, align 1, !tbaa !14
  %71 = zext i8 %70 to i16
  %72 = or disjoint i16 %68, %71
  %73 = getelementptr inbounds nuw i8, ptr %64, i64 6
  %74 = load i8, ptr %73, align 1, !tbaa !14
  %75 = zext i8 %74 to i16
  %76 = shl nuw i16 %75, 8
  %77 = getelementptr inbounds nuw i8, ptr %64, i64 7
  %78 = load i8, ptr %77, align 1, !tbaa !14
  %79 = zext i8 %78 to i16
  %80 = or disjoint i16 %76, %79
  %81 = getelementptr inbounds nuw i8, ptr %64, i64 8
  %82 = load i8, ptr %81, align 1, !tbaa !14
  %83 = zext i8 %82 to i16
  %84 = shl nuw i16 %83, 8
  %85 = getelementptr inbounds nuw i8, ptr %64, i64 9
  %86 = load i8, ptr %85, align 1, !tbaa !14
  %87 = zext i8 %86 to i16
  %88 = or disjoint i16 %84, %87
  %89 = sitofp i16 %72 to float
  %90 = fmul float %58, %89
  store float %90, ptr %3, align 4, !tbaa !58
  %91 = sitofp i16 %80 to float
  %92 = fmul float %58, %91
  store float %92, ptr %4, align 4, !tbaa !58
  %93 = sitofp i16 %88 to float
  %94 = fmul float %58, %93
  store float %94, ptr %5, align 4, !tbaa !58
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #26
  ret void
}

; Function Attrs: mustprogress nofree nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @stbtt_GetPackedQuad(ptr noundef readonly captures(none) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, ptr noundef captures(none) %4, ptr noundef readonly captures(none) %5, ptr noundef writeonly captures(none) initializes((0, 32)) %6, i32 noundef %7) local_unnamed_addr #10 {
  %9 = sext i32 %3 to i64
  %10 = getelementptr inbounds %struct.stbtt_packedchar, ptr %0, i64 %9
  %11 = icmp eq i32 %7, 0
  %12 = load float, ptr %4, align 4, !tbaa !58
  %13 = getelementptr inbounds nuw i8, ptr %10, i64 8
  %14 = load float, ptr %13, align 4, !tbaa !120
  %15 = fadd float %12, %14
  br i1 %11, label %39, label %16

16:                                               ; preds = %8
  %17 = fadd float %15, 5.000000e-01
  %18 = tail call float @floorf(float noundef %17) #28
  %19 = fptosi float %18 to i32
  %20 = sitofp i32 %19 to float
  %21 = load float, ptr %5, align 4, !tbaa !58
  %22 = getelementptr inbounds nuw i8, ptr %10, i64 12
  %23 = load float, ptr %22, align 4, !tbaa !121
  %24 = fadd float %21, %23
  %25 = fadd float %24, 5.000000e-01
  %26 = tail call float @floorf(float noundef %25) #28
  %27 = fptosi float %26 to i32
  %28 = sitofp i32 %27 to float
  store float %20, ptr %6, align 4, !tbaa !62
  %29 = getelementptr inbounds nuw i8, ptr %6, i64 4
  store float %28, ptr %29, align 4, !tbaa !64
  %30 = getelementptr inbounds nuw i8, ptr %10, i64 20
  %31 = load float, ptr %30, align 4, !tbaa !122
  %32 = fadd float %31, %20
  %33 = fsub float %32, %14
  %34 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store float %33, ptr %34, align 4, !tbaa !67
  %35 = getelementptr inbounds nuw i8, ptr %10, i64 24
  %36 = load float, ptr %35, align 4, !tbaa !123
  %37 = fadd float %36, %28
  %38 = fsub float %37, %23
  br label %54

39:                                               ; preds = %8
  store float %15, ptr %6, align 4, !tbaa !62
  %40 = load float, ptr %5, align 4, !tbaa !58
  %41 = getelementptr inbounds nuw i8, ptr %10, i64 12
  %42 = load float, ptr %41, align 4, !tbaa !121
  %43 = fadd float %40, %42
  %44 = getelementptr inbounds nuw i8, ptr %6, i64 4
  store float %43, ptr %44, align 4, !tbaa !64
  %45 = load float, ptr %4, align 4, !tbaa !58
  %46 = getelementptr inbounds nuw i8, ptr %10, i64 20
  %47 = load float, ptr %46, align 4, !tbaa !122
  %48 = fadd float %45, %47
  %49 = getelementptr inbounds nuw i8, ptr %6, i64 16
  store float %48, ptr %49, align 4, !tbaa !67
  %50 = load float, ptr %5, align 4, !tbaa !58
  %51 = getelementptr inbounds nuw i8, ptr %10, i64 24
  %52 = load float, ptr %51, align 4, !tbaa !123
  %53 = fadd float %50, %52
  br label %54

54:                                               ; preds = %39, %16
  %55 = phi float [ %53, %39 ], [ %38, %16 ]
  %56 = getelementptr inbounds nuw i8, ptr %6, i64 20
  store float %55, ptr %56, align 4, !tbaa !70
  %57 = sitofp i32 %2 to float
  %58 = fdiv float 1.000000e+00, %57
  %59 = sitofp i32 %1 to float
  %60 = fdiv float 1.000000e+00, %59
  %61 = load i16, ptr %10, align 4, !tbaa !114
  %62 = uitofp i16 %61 to float
  %63 = fmul float %60, %62
  %64 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store float %63, ptr %64, align 4, !tbaa !71
  %65 = getelementptr inbounds nuw i8, ptr %10, i64 2
  %66 = load i16, ptr %65, align 2, !tbaa !116
  %67 = uitofp i16 %66 to float
  %68 = fmul float %58, %67
  %69 = getelementptr inbounds nuw i8, ptr %6, i64 12
  store float %68, ptr %69, align 4, !tbaa !72
  %70 = getelementptr inbounds nuw i8, ptr %10, i64 4
  %71 = load i16, ptr %70, align 4, !tbaa !117
  %72 = uitofp i16 %71 to float
  %73 = fmul float %60, %72
  %74 = getelementptr inbounds nuw i8, ptr %6, i64 24
  store float %73, ptr %74, align 4, !tbaa !73
  %75 = getelementptr inbounds nuw i8, ptr %10, i64 6
  %76 = load i16, ptr %75, align 2, !tbaa !118
  %77 = uitofp i16 %76 to float
  %78 = fmul float %58, %77
  %79 = getelementptr inbounds nuw i8, ptr %6, i64 28
  store float %78, ptr %79, align 4, !tbaa !74
  %80 = getelementptr inbounds nuw i8, ptr %10, i64 16
  %81 = load float, ptr %80, align 4, !tbaa !119
  %82 = load float, ptr %4, align 4, !tbaa !58
  %83 = fadd float %81, %82
  store float %83, ptr %4, align 4, !tbaa !58
  ret void
}

; Function Attrs: nounwind
define dso_local noalias noundef ptr @stbtt_GetGlyphSDF(ptr noundef readonly captures(none) %0, float noundef %1, i32 noundef %2, i32 noundef %3, i8 zeroext %4, float %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7, ptr noundef writeonly captures(address_is_null) %8, ptr noundef writeonly captures(address_is_null) %9) local_unnamed_addr #2 {
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca ptr, align 8
  %16 = fcmp oeq float %1, 0.000000e+00
  br i1 %16, label %229, label %17

17:                                               ; preds = %10
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  store i32 0, ptr %11, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  store i32 0, ptr %12, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %14) #26
  %18 = call i32 @stbtt_GetGlyphBox(ptr noundef readonly %0, i32 noundef %2, ptr noundef nonnull %11, ptr noundef nonnull %12, ptr noundef nonnull %13, ptr noundef nonnull %14) #25
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %43, label %20

20:                                               ; preds = %17
  %21 = load i32, ptr %11, align 4, !tbaa !4
  %22 = sitofp i32 %21 to float
  %23 = call float @llvm.fmuladd.f32(float %22, float %1, float 0.000000e+00)
  %24 = call float @floorf(float noundef %23) #28
  %25 = fptosi float %24 to i32
  %26 = load i32, ptr %14, align 4, !tbaa !4
  %27 = sub nsw i32 0, %26
  %28 = sitofp i32 %27 to float
  %29 = call float @llvm.fmuladd.f32(float %28, float %1, float 0.000000e+00)
  %30 = call float @floorf(float noundef %29) #28
  %31 = fptosi float %30 to i32
  %32 = load i32, ptr %13, align 4, !tbaa !4
  %33 = sitofp i32 %32 to float
  %34 = call float @llvm.fmuladd.f32(float %33, float %1, float 0.000000e+00)
  %35 = call float @ceilf(float noundef %34) #28
  %36 = fptosi float %35 to i32
  %37 = load i32, ptr %12, align 4, !tbaa !4
  %38 = sub nsw i32 0, %37
  %39 = sitofp i32 %38 to float
  %40 = call float @llvm.fmuladd.f32(float %39, float %1, float 0.000000e+00)
  %41 = call float @ceilf(float noundef %40) #28
  %42 = fptosi float %41 to i32
  br label %43

43:                                               ; preds = %17, %20
  %44 = phi i32 [ %25, %20 ], [ 0, %17 ]
  %45 = phi i32 [ %31, %20 ], [ 0, %17 ]
  %46 = phi i32 [ %36, %20 ], [ 0, %17 ]
  %47 = phi i32 [ %42, %20 ], [ 0, %17 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %14) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  %48 = icmp eq i32 %44, %46
  %49 = icmp eq i32 %45, %47
  %50 = select i1 %48, i1 true, i1 %49
  br i1 %50, label %229, label %51

51:                                               ; preds = %43
  %52 = sub i32 %44, %3
  %53 = sub nsw i32 %45, %3
  %54 = add nsw i32 %46, %3
  %55 = add nsw i32 %47, %3
  %56 = sub nsw i32 %54, %52
  %57 = sub nsw i32 %55, %53
  %58 = icmp eq ptr %6, null
  br i1 %58, label %60, label %59

59:                                               ; preds = %51
  store i32 %56, ptr %6, align 4, !tbaa !4
  br label %60

60:                                               ; preds = %59, %51
  %61 = icmp eq ptr %7, null
  br i1 %61, label %63, label %62

62:                                               ; preds = %60
  store i32 %57, ptr %7, align 4, !tbaa !4
  br label %63

63:                                               ; preds = %62, %60
  %64 = icmp eq ptr %8, null
  br i1 %64, label %66, label %65

65:                                               ; preds = %63
  store i32 %52, ptr %8, align 4, !tbaa !4
  br label %66

66:                                               ; preds = %65, %63
  %67 = icmp eq ptr %9, null
  br i1 %67, label %69, label %68

68:                                               ; preds = %66
  store i32 %53, ptr %9, align 4, !tbaa !4
  br label %69

69:                                               ; preds = %68, %66
  %70 = fneg float %1
  call void @llvm.lifetime.start.p0(ptr nonnull %15) #26
  %71 = call i32 @stbtt_GetGlyphShape(ptr noundef %0, i32 noundef %2, ptr noundef nonnull %15) #25
  %72 = icmp sgt i32 %71, 0
  br i1 %72, label %73, label %77

73:                                               ; preds = %69
  %74 = add nsw i32 %71, -1
  %75 = load ptr, ptr %15, align 8, !tbaa !20
  %76 = zext nneg i32 %71 to i64
  br label %86

77:                                               ; preds = %115, %69
  %78 = icmp slt i32 %53, %55
  br i1 %78, label %79, label %228

79:                                               ; preds = %77
  %80 = icmp slt i32 %52, %54
  %81 = load ptr, ptr %15, align 8
  %82 = icmp sgt i32 %71, 0
  %83 = zext nneg i32 %71 to i64
  %84 = sext i32 %52 to i64
  %85 = sext i32 %54 to i64
  br label %120

86:                                               ; preds = %73, %115
  %87 = phi i64 [ 0, %73 ], [ %117, %115 ]
  %88 = phi i32 [ %74, %73 ], [ %118, %115 ]
  %89 = getelementptr inbounds nuw %struct.stbtt_vertex, ptr %75, i64 %87
  %90 = getelementptr inbounds nuw i8, ptr %89, i64 12
  %91 = load i8, ptr %90, align 2, !tbaa !141
  %92 = icmp eq i8 %91, 2
  br i1 %92, label %93, label %115

93:                                               ; preds = %86
  %94 = load i16, ptr %89, align 2, !tbaa !21
  %95 = sitofp i16 %94 to float
  %96 = fmul float %1, %95
  %97 = getelementptr inbounds nuw i8, ptr %89, i64 2
  %98 = load i16, ptr %97, align 2, !tbaa !24
  %99 = sitofp i16 %98 to float
  %100 = sext i32 %88 to i64
  %101 = getelementptr inbounds %struct.stbtt_vertex, ptr %75, i64 %100
  %102 = load i16, ptr %101, align 2, !tbaa !21
  %103 = sitofp i16 %102 to float
  %104 = fmul float %1, %103
  %105 = getelementptr inbounds nuw i8, ptr %101, i64 2
  %106 = load i16, ptr %105, align 2, !tbaa !24
  %107 = sitofp i16 %106 to float
  %108 = fsub float %104, %96
  %109 = fmul float %1, %99
  %110 = fmul float %1, %107
  %111 = fsub float %109, %110
  %112 = fmul float %111, %111
  %113 = call float @llvm.fmuladd.f32(float %108, float %108, float %112)
  %114 = call float @sqrtf(float noundef %113) #27
  br label %115

115:                                              ; preds = %86, %93
  %116 = getelementptr inbounds nuw float, ptr null, i64 %87
  store float poison, ptr %116, align 4, !tbaa !58
  %117 = add nuw nsw i64 %87, 1
  %118 = trunc nuw nsw i64 %87 to i32
  %119 = icmp eq i64 %117, %76
  br i1 %119, label %77, label %86, !llvm.loop !142

120:                                              ; preds = %79, %225
  %121 = phi i32 [ %53, %79 ], [ %226, %225 ]
  br i1 %80, label %122, label %225

122:                                              ; preds = %120
  %123 = sitofp i32 %121 to float
  %124 = fadd float %123, 5.000000e-01
  %125 = fdiv float %124, %70
  %126 = fadd float %125, 0xBF847AE140000000
  %127 = fadd float %125, 0x3F847AE140000000
  %128 = sub nsw i32 %121, %53
  %129 = mul nsw i32 %128, %56
  %130 = sub i32 %129, %52
  br label %131

131:                                              ; preds = %122, %218
  %132 = phi i64 [ %84, %122 ], [ %223, %218 ]
  %133 = trunc nsw i64 %132 to i32
  %134 = sitofp i32 %133 to float
  %135 = fadd float %134, 5.000000e-01
  %136 = fdiv float %135, %1
  %137 = call float @fmodf(float noundef %125, float noundef 1.000000e+00) #27
  %138 = fcmp olt float %137, 0x3F847AE140000000
  br i1 %138, label %142, label %139

139:                                              ; preds = %131
  %140 = fcmp ogt float %137, 0x3FEFAE1480000000
  br i1 %140, label %141, label %142

141:                                              ; preds = %139
  br label %142

142:                                              ; preds = %131, %141, %139
  %143 = phi float [ %125, %139 ], [ %126, %141 ], [ %127, %131 ]
  br i1 %82, label %144, label %218

144:                                              ; preds = %142
  %145 = fmul float %136, 0.000000e+00
  %146 = fsub float %145, %143
  br label %147

147:                                              ; preds = %215, %144
  %148 = phi i64 [ 0, %144 ], [ %216, %215 ]
  %149 = getelementptr inbounds nuw %struct.stbtt_vertex, ptr %81, i64 %148
  %150 = getelementptr inbounds nuw i8, ptr %149, i64 12
  %151 = load i8, ptr %150, align 2, !tbaa !141
  %152 = icmp eq i8 %151, 3
  br i1 %152, label %153, label %215

153:                                              ; preds = %147
  %154 = getelementptr i8, ptr %149, i64 -14
  %155 = load i16, ptr %154, align 2, !tbaa !21
  %156 = getelementptr i8, ptr %149, i64 -12
  %157 = load i16, ptr %156, align 2, !tbaa !24
  %158 = getelementptr inbounds nuw i8, ptr %149, i64 4
  %159 = load i16, ptr %158, align 2, !tbaa !25
  %160 = getelementptr inbounds nuw i8, ptr %149, i64 6
  %161 = load i16, ptr %160, align 2, !tbaa !26
  %162 = load i16, ptr %149, align 2, !tbaa !21
  %163 = getelementptr inbounds nuw i8, ptr %149, i64 2
  %164 = load i16, ptr %163, align 2, !tbaa !24
  %165 = call i16 @llvm.smin.i16(i16 %159, i16 %162)
  %166 = call i16 @llvm.smin.i16(i16 %165, i16 %155)
  %167 = call i16 @llvm.smin.i16(i16 %161, i16 %164)
  %168 = call i16 @llvm.smin.i16(i16 %157, i16 %167)
  %169 = call i16 @llvm.smax.i16(i16 %161, i16 %164)
  %170 = call i16 @llvm.smax.i16(i16 %157, i16 %169)
  %171 = sitofp i16 %168 to float
  %172 = fcmp ogt float %143, %171
  %173 = sitofp i16 %170 to float
  %174 = fcmp olt float %143, %173
  %175 = and i1 %172, %174
  %176 = sitofp i16 %166 to float
  %177 = fcmp ogt float %136, %176
  %178 = select i1 %175, i1 %177, i1 false
  br i1 %178, label %179, label %215

179:                                              ; preds = %153
  %180 = sitofp i16 %155 to float
  %181 = sitofp i16 %157 to float
  %182 = sitofp i16 %159 to float
  %183 = sitofp i16 %161 to float
  %184 = sitofp i16 %162 to float
  %185 = sitofp i16 %164 to float
  %186 = fcmp une float %180, %182
  %187 = fcmp une float %181, %183
  %188 = or i1 %186, %187
  br i1 %188, label %189, label %215

189:                                              ; preds = %179
  %190 = fcmp une float %182, %184
  %191 = fcmp une float %183, %185
  %192 = or i1 %190, %191
  br i1 %192, label %193, label %215

193:                                              ; preds = %189
  %194 = fneg float %180
  %195 = call float @llvm.copysign.f32(float 0.000000e+00, float %194)
  %196 = fadd float %195, %181
  %197 = fneg float %182
  %198 = call float @llvm.copysign.f32(float 0.000000e+00, float %197)
  %199 = fadd float %198, %183
  %200 = fneg float %184
  %201 = call float @llvm.copysign.f32(float 0.000000e+00, float %200)
  %202 = fadd float %201, %185
  %203 = call float @llvm.fmuladd.f32(float %199, float -2.000000e+00, float %196)
  %204 = fadd float %203, %202
  %205 = fcmp une float %204, 0.000000e+00
  br i1 %205, label %206, label %215

206:                                              ; preds = %193
  %207 = fadd float %146, %196
  %208 = fsub float %199, %196
  %209 = fneg float %207
  %210 = fmul float %204, %209
  %211 = call float @llvm.fmuladd.f32(float %208, float %208, float %210)
  %212 = fcmp ogt float %211, 0.000000e+00
  br i1 %212, label %213, label %215

213:                                              ; preds = %206
  %214 = call float @sqrtf(float noundef %211) #27
  br label %215

215:                                              ; preds = %193, %213, %206, %179, %189, %153, %147
  %216 = add nuw nsw i64 %148, 1
  %217 = icmp eq i64 %216, %83
  br i1 %217, label %218, label %147, !llvm.loop !143

218:                                              ; preds = %215, %142
  %219 = trunc nsw i64 %132 to i32
  %220 = add i32 %130, %219
  %221 = sext i32 %220 to i64
  %222 = getelementptr inbounds i8, ptr null, i64 %221
  store i8 poison, ptr %222, align 1, !tbaa !14
  %223 = add nsw i64 %132, 1
  %224 = icmp slt i64 %223, %85
  br i1 %224, label %131, label %225, !llvm.loop !144

225:                                              ; preds = %218, %120
  %226 = add nsw i32 %121, 1
  %227 = icmp slt i32 %226, %55
  br i1 %227, label %120, label %228, !llvm.loop !145

228:                                              ; preds = %225, %77
  call void @llvm.lifetime.end.p0(ptr nonnull %15) #26
  br label %229

229:                                              ; preds = %43, %10, %228
  ret ptr null
}

; Function Attrs: nounwind
declare float @sqrtf(float noundef) local_unnamed_addr #11

; Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
declare double @fabs(double noundef) local_unnamed_addr #8

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #18

; Function Attrs: nounwind
define dso_local noalias noundef ptr @stbtt_GetCodepointSDF(ptr noundef readonly captures(none) %0, float noundef %1, i32 noundef %2, i32 noundef %3, i8 noundef zeroext %4, float noundef %5, ptr noundef writeonly captures(address_is_null) %6, ptr noundef writeonly captures(address_is_null) %7, ptr noundef writeonly captures(address_is_null) %8, ptr noundef writeonly captures(address_is_null) %9) local_unnamed_addr #2 {
  %11 = tail call i32 @stbtt_FindGlyphIndex(ptr noundef %0, i32 noundef %2) #25
  %12 = tail call ptr @stbtt_GetGlyphSDF(ptr noundef %0, float noundef %1, i32 noundef %11, i32 noundef %3, i8 zeroext poison, float poison, ptr noundef %6, ptr noundef %7, ptr noundef %8, ptr noundef %9) #25
  ret ptr null
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local void @stbtt_FreeSDF(ptr noundef readnone captures(none) %0, ptr noundef readnone captures(none) %1) local_unnamed_addr #7 {
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local ptr @stbtt_GetFontNameString(ptr noundef readonly captures(none) %0, ptr noundef writeonly captures(none) %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, i32 noundef %5) local_unnamed_addr #6 {
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %8 = load ptr, ptr %7, align 8, !tbaa !8
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %10 = load i32, ptr %9, align 8, !tbaa !52
  %11 = zext i32 %10 to i64
  %12 = getelementptr inbounds nuw i8, ptr %8, i64 %11
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 4
  %14 = load i8, ptr %13, align 1, !tbaa !14
  %15 = zext i8 %14 to i32
  %16 = shl nuw nsw i32 %15, 8
  %17 = getelementptr inbounds nuw i8, ptr %12, i64 5
  %18 = load i8, ptr %17, align 1, !tbaa !14
  %19 = zext i8 %18 to i32
  %20 = or disjoint i32 %16, %19
  %21 = add i32 %10, 12
  %22 = icmp eq i32 %20, 0
  br i1 %22, label %72, label %23

23:                                               ; preds = %6
  %24 = zext nneg i32 %20 to i64
  br label %28

25:                                               ; preds = %69
  %26 = add nuw nsw i64 %29, 1
  %27 = icmp eq i64 %26, %24
  br i1 %27, label %72, label %28, !llvm.loop !53

28:                                               ; preds = %25, %23
  %29 = phi i64 [ 0, %23 ], [ %26, %25 ]
  %30 = phi i32 [ undef, %23 ], [ %70, %25 ]
  %31 = trunc i64 %29 to i32
  %32 = shl i32 %31, 4
  %33 = add i32 %21, %32
  %34 = zext i32 %33 to i64
  %35 = getelementptr inbounds nuw i8, ptr %8, i64 %34
  %36 = load i8, ptr %35, align 1, !tbaa !14
  %37 = icmp eq i8 %36, 110
  br i1 %37, label %38, label %69

38:                                               ; preds = %28
  %39 = getelementptr inbounds nuw i8, ptr %35, i64 1
  %40 = load i8, ptr %39, align 1, !tbaa !14
  %41 = icmp eq i8 %40, 97
  br i1 %41, label %42, label %69

42:                                               ; preds = %38
  %43 = getelementptr inbounds nuw i8, ptr %35, i64 2
  %44 = load i8, ptr %43, align 1, !tbaa !14
  %45 = icmp eq i8 %44, 109
  br i1 %45, label %46, label %69

46:                                               ; preds = %42
  %47 = getelementptr inbounds nuw i8, ptr %35, i64 3
  %48 = load i8, ptr %47, align 1, !tbaa !14
  %49 = icmp eq i8 %48, 101
  br i1 %49, label %50, label %69

50:                                               ; preds = %46
  %51 = getelementptr inbounds nuw i8, ptr %35, i64 8
  %52 = load i8, ptr %51, align 1, !tbaa !14
  %53 = zext i8 %52 to i32
  %54 = shl nuw i32 %53, 24
  %55 = getelementptr inbounds nuw i8, ptr %35, i64 9
  %56 = load i8, ptr %55, align 1, !tbaa !14
  %57 = zext i8 %56 to i32
  %58 = shl nuw nsw i32 %57, 16
  %59 = or disjoint i32 %58, %54
  %60 = getelementptr inbounds nuw i8, ptr %35, i64 10
  %61 = load i8, ptr %60, align 1, !tbaa !14
  %62 = zext i8 %61 to i32
  %63 = shl nuw nsw i32 %62, 8
  %64 = or disjoint i32 %59, %63
  %65 = getelementptr inbounds nuw i8, ptr %35, i64 11
  %66 = load i8, ptr %65, align 1, !tbaa !14
  %67 = zext i8 %66 to i32
  %68 = or disjoint i32 %64, %67
  br label %69

69:                                               ; preds = %50, %46, %42, %38, %28
  %70 = phi i32 [ %68, %50 ], [ %30, %46 ], [ %30, %42 ], [ %30, %38 ], [ %30, %28 ]
  %71 = phi i1 [ false, %50 ], [ true, %46 ], [ true, %42 ], [ true, %38 ], [ true, %28 ]
  br i1 %71, label %25, label %72

72:                                               ; preds = %25, %69, %6
  %73 = phi i32 [ 0, %6 ], [ %70, %69 ], [ 0, %25 ]
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %171, label %75

75:                                               ; preds = %72
  %76 = zext i32 %73 to i64
  %77 = getelementptr inbounds nuw i8, ptr %8, i64 %76
  %78 = getelementptr inbounds nuw i8, ptr %77, i64 2
  %79 = load i8, ptr %78, align 1, !tbaa !14
  %80 = zext i8 %79 to i32
  %81 = shl nuw nsw i32 %80, 8
  %82 = getelementptr inbounds nuw i8, ptr %77, i64 3
  %83 = load i8, ptr %82, align 1, !tbaa !14
  %84 = zext i8 %83 to i32
  %85 = or disjoint i32 %81, %84
  %86 = icmp eq i32 %85, 0
  br i1 %86, label %171, label %87

87:                                               ; preds = %75
  %88 = getelementptr inbounds nuw i8, ptr %77, i64 4
  %89 = load i8, ptr %88, align 1, !tbaa !14
  %90 = zext i8 %89 to i32
  %91 = shl nuw nsw i32 %90, 8
  %92 = getelementptr inbounds nuw i8, ptr %77, i64 5
  %93 = load i8, ptr %92, align 1, !tbaa !14
  %94 = zext i8 %93 to i32
  %95 = or disjoint i32 %91, %94
  %96 = add i32 %95, %73
  %97 = add i32 %73, 6
  %98 = sext i32 %96 to i64
  %99 = getelementptr inbounds i8, ptr %8, i64 %98
  %100 = zext nneg i32 %85 to i64
  br label %104

101:                                              ; preds = %168
  %102 = add nuw nsw i64 %105, 1
  %103 = icmp eq i64 %102, %100
  br i1 %103, label %171, label %104, !llvm.loop !146

104:                                              ; preds = %87, %101
  %105 = phi i64 [ 0, %87 ], [ %102, %101 ]
  %106 = phi ptr [ undef, %87 ], [ %170, %101 ]
  %107 = trunc i64 %105 to i32
  %108 = mul i32 %107, 12
  %109 = add i32 %97, %108
  %110 = zext i32 %109 to i64
  %111 = getelementptr inbounds nuw i8, ptr %8, i64 %110
  %112 = load i8, ptr %111, align 1, !tbaa !14
  %113 = zext i8 %112 to i32
  %114 = shl nuw nsw i32 %113, 8
  %115 = getelementptr inbounds nuw i8, ptr %111, i64 1
  %116 = load i8, ptr %115, align 1, !tbaa !14
  %117 = zext i8 %116 to i32
  %118 = or disjoint i32 %114, %117
  %119 = icmp eq i32 %2, %118
  br i1 %119, label %120, label %168

120:                                              ; preds = %104
  %121 = getelementptr inbounds nuw i8, ptr %111, i64 2
  %122 = load i8, ptr %121, align 1, !tbaa !14
  %123 = zext i8 %122 to i32
  %124 = shl nuw nsw i32 %123, 8
  %125 = getelementptr inbounds nuw i8, ptr %111, i64 3
  %126 = load i8, ptr %125, align 1, !tbaa !14
  %127 = zext i8 %126 to i32
  %128 = or disjoint i32 %124, %127
  %129 = icmp eq i32 %3, %128
  br i1 %129, label %130, label %168

130:                                              ; preds = %120
  %131 = getelementptr inbounds nuw i8, ptr %111, i64 4
  %132 = load i8, ptr %131, align 1, !tbaa !14
  %133 = zext i8 %132 to i32
  %134 = shl nuw nsw i32 %133, 8
  %135 = getelementptr inbounds nuw i8, ptr %111, i64 5
  %136 = load i8, ptr %135, align 1, !tbaa !14
  %137 = zext i8 %136 to i32
  %138 = or disjoint i32 %134, %137
  %139 = icmp eq i32 %4, %138
  br i1 %139, label %140, label %168

140:                                              ; preds = %130
  %141 = getelementptr inbounds nuw i8, ptr %111, i64 6
  %142 = load i8, ptr %141, align 1, !tbaa !14
  %143 = zext i8 %142 to i32
  %144 = shl nuw nsw i32 %143, 8
  %145 = getelementptr inbounds nuw i8, ptr %111, i64 7
  %146 = load i8, ptr %145, align 1, !tbaa !14
  %147 = zext i8 %146 to i32
  %148 = or disjoint i32 %144, %147
  %149 = icmp eq i32 %5, %148
  br i1 %149, label %150, label %168

150:                                              ; preds = %140
  %151 = getelementptr inbounds nuw i8, ptr %111, i64 8
  %152 = load i8, ptr %151, align 1, !tbaa !14
  %153 = zext i8 %152 to i32
  %154 = shl nuw nsw i32 %153, 8
  %155 = getelementptr inbounds nuw i8, ptr %111, i64 9
  %156 = load i8, ptr %155, align 1, !tbaa !14
  %157 = zext i8 %156 to i32
  %158 = or disjoint i32 %154, %157
  store i32 %158, ptr %1, align 4, !tbaa !4
  %159 = getelementptr inbounds nuw i8, ptr %111, i64 10
  %160 = load i8, ptr %159, align 1, !tbaa !14
  %161 = zext i8 %160 to i64
  %162 = shl nuw nsw i64 %161, 8
  %163 = getelementptr inbounds nuw i8, ptr %111, i64 11
  %164 = load i8, ptr %163, align 1, !tbaa !14
  %165 = zext i8 %164 to i64
  %166 = getelementptr inbounds nuw i8, ptr %99, i64 %162
  %167 = getelementptr inbounds nuw i8, ptr %166, i64 %165
  br label %168

168:                                              ; preds = %104, %120, %130, %140, %150
  %169 = phi i1 [ false, %150 ], [ true, %140 ], [ true, %130 ], [ true, %120 ], [ true, %104 ]
  %170 = phi ptr [ %167, %150 ], [ %106, %140 ], [ %106, %130 ], [ %106, %120 ], [ %106, %104 ]
  br i1 %169, label %101, label %171

171:                                              ; preds = %168, %101, %75, %72
  %172 = phi ptr [ null, %72 ], [ null, %75 ], [ null, %101 ], [ %170, %168 ]
  ret ptr %172
}

; Function Attrs: nounwind
define dso_local i32 @stbtt_BakeFontBitmap(ptr noundef %0, i32 noundef %1, float noundef %2, ptr noundef %3, i32 noundef %4, i32 noundef %5, i32 noundef %6, i32 noundef %7, ptr noundef writeonly captures(none) %8) local_unnamed_addr #2 {
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca ptr, align 8
  %19 = alloca %struct.stbtt_fontinfo, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %19) #26
  store ptr null, ptr %19, align 8, !tbaa !147
  %20 = call i32 @stbtt_InitFont(ptr noundef nonnull %19, ptr noundef %0, i32 noundef %1) #25
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %165, label %22

22:                                               ; preds = %9
  %23 = mul nsw i32 %5, %4
  %24 = sext i32 %23 to i64
  %25 = tail call ptr @memset(ptr noundef %3, i32 noundef 0, i64 noundef %24) #27
  %26 = getelementptr inbounds nuw i8, ptr %19, i64 8
  %27 = load ptr, ptr %26, align 8, !tbaa !8
  %28 = getelementptr inbounds nuw i8, ptr %19, i64 36
  %29 = load i32, ptr %28, align 4, !tbaa !37
  %30 = sext i32 %29 to i64
  %31 = getelementptr inbounds i8, ptr %27, i64 %30
  %32 = getelementptr inbounds nuw i8, ptr %31, i64 4
  %33 = load i8, ptr %32, align 1, !tbaa !14
  %34 = zext i8 %33 to i16
  %35 = shl nuw i16 %34, 8
  %36 = getelementptr inbounds nuw i8, ptr %31, i64 5
  %37 = load i8, ptr %36, align 1, !tbaa !14
  %38 = zext i8 %37 to i16
  %39 = or disjoint i16 %35, %38
  %40 = sext i16 %39 to i32
  %41 = getelementptr inbounds nuw i8, ptr %31, i64 6
  %42 = load i8, ptr %41, align 1, !tbaa !14
  %43 = zext i8 %42 to i16
  %44 = shl nuw i16 %43, 8
  %45 = getelementptr inbounds nuw i8, ptr %31, i64 7
  %46 = load i8, ptr %45, align 1, !tbaa !14
  %47 = zext i8 %46 to i16
  %48 = or disjoint i16 %44, %47
  %49 = sext i16 %48 to i32
  %50 = sub nsw i32 %40, %49
  %51 = sitofp i32 %50 to float
  %52 = fdiv float %2, %51
  %53 = icmp sgt i32 %7, 0
  br i1 %53, label %54, label %165

54:                                               ; preds = %22
  %55 = getelementptr inbounds nuw i8, ptr %31, i64 34
  %56 = getelementptr inbounds nuw i8, ptr %31, i64 35
  %57 = getelementptr inbounds nuw i8, ptr %19, i64 40
  %58 = load i32, ptr %57, align 8
  %59 = sext i32 %58 to i64
  %60 = getelementptr inbounds i8, ptr %27, i64 %59
  %61 = zext nneg i32 %7 to i64
  br label %65

62:                                               ; preds = %161
  %63 = add nuw nsw i64 %66, 1
  %64 = icmp eq i64 %63, %61
  br i1 %64, label %165, label %65, !llvm.loop !148

65:                                               ; preds = %62, %54
  %66 = phi i64 [ 0, %54 ], [ %63, %62 ]
  %67 = phi i32 [ undef, %54 ], [ %164, %62 ]
  %68 = phi i32 [ 1, %54 ], [ %163, %62 ]
  %69 = phi i32 [ 1, %54 ], [ %133, %62 ]
  %70 = phi i32 [ 1, %54 ], [ %162, %62 ]
  %71 = trunc i64 %66 to i32
  %72 = add i32 %6, %71
  %73 = call i32 @stbtt_FindGlyphIndex(ptr noundef nonnull %19, i32 noundef %72) #25
  %74 = load i8, ptr %55, align 1, !tbaa !14
  %75 = zext i8 %74 to i32
  %76 = shl nuw nsw i32 %75, 8
  %77 = load i8, ptr %56, align 1, !tbaa !14
  %78 = zext i8 %77 to i32
  %79 = or disjoint i32 %76, %78
  %80 = icmp slt i32 %73, %79
  %81 = shl nuw nsw i32 %79, 2
  %82 = zext nneg i32 %81 to i64
  %83 = getelementptr i8, ptr %60, i64 %82
  %84 = getelementptr i8, ptr %83, i64 -4
  %85 = getelementptr i8, ptr %83, i64 -3
  %86 = shl nsw i32 %73, 2
  %87 = sext i32 %86 to i64
  %88 = getelementptr inbounds i8, ptr %60, i64 %87
  %89 = getelementptr inbounds nuw i8, ptr %88, i64 1
  %90 = select i1 %80, ptr %89, ptr %85
  %91 = select i1 %80, ptr %88, ptr %84
  %92 = load i8, ptr %91, align 1, !tbaa !14
  %93 = zext i8 %92 to i16
  %94 = shl nuw i16 %93, 8
  %95 = load i8, ptr %90, align 1, !tbaa !14
  %96 = zext i8 %95 to i16
  %97 = or disjoint i16 %94, %96
  call void @llvm.lifetime.start.p0(ptr nonnull %10) #26
  store i32 0, ptr %10, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  store i32 0, ptr %11, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  %98 = call i32 @stbtt_GetGlyphBox(ptr noundef nonnull readonly %19, i32 noundef %73, ptr noundef nonnull %10, ptr noundef nonnull %11, ptr noundef nonnull %12, ptr noundef nonnull %13) #25
  %99 = icmp eq i32 %98, 0
  br i1 %99, label %123, label %100

100:                                              ; preds = %65
  %101 = load i32, ptr %10, align 4, !tbaa !4
  %102 = sitofp i32 %101 to float
  %103 = call float @llvm.fmuladd.f32(float %102, float %52, float 0.000000e+00)
  %104 = call float @floorf(float noundef %103) #28
  %105 = fptosi float %104 to i32
  %106 = load i32, ptr %13, align 4, !tbaa !4
  %107 = sub nsw i32 0, %106
  %108 = sitofp i32 %107 to float
  %109 = call float @llvm.fmuladd.f32(float %108, float %52, float 0.000000e+00)
  %110 = call float @floorf(float noundef %109) #28
  %111 = fptosi float %110 to i32
  %112 = load i32, ptr %12, align 4, !tbaa !4
  %113 = sitofp i32 %112 to float
  %114 = call float @llvm.fmuladd.f32(float %113, float %52, float 0.000000e+00)
  %115 = call float @ceilf(float noundef %114) #28
  %116 = fptosi float %115 to i32
  %117 = load i32, ptr %11, align 4, !tbaa !4
  %118 = sub nsw i32 0, %117
  %119 = sitofp i32 %118 to float
  %120 = call float @llvm.fmuladd.f32(float %119, float %52, float 0.000000e+00)
  %121 = call float @ceilf(float noundef %120) #28
  %122 = fptosi float %121 to i32
  br label %123

123:                                              ; preds = %100, %65
  %124 = phi i32 [ %105, %100 ], [ 0, %65 ]
  %125 = phi i32 [ %111, %100 ], [ 0, %65 ]
  %126 = phi i32 [ %116, %100 ], [ 0, %65 ]
  %127 = phi i32 [ %122, %100 ], [ 0, %65 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %10) #26
  %128 = sub nsw i32 %126, %124
  %129 = sub nsw i32 %127, %125
  %130 = add i32 %68, 1
  %131 = add i32 %130, %128
  %132 = icmp slt i32 %131, %4
  %133 = select i1 %132, i32 %69, i32 %70
  %134 = select i1 %132, i32 %68, i32 1
  %135 = add nsw i32 %133, %129
  %136 = add nsw i32 %135, 1
  %137 = icmp slt i32 %136, %5
  br i1 %137, label %140, label %138

138:                                              ; preds = %123
  %139 = sub i32 0, %71
  br label %161

140:                                              ; preds = %123
  call void @llvm.lifetime.start.p0(ptr nonnull %18) #26
  %141 = call i32 @stbtt_GetGlyphShape(ptr noundef nonnull readonly %19, i32 noundef %73, ptr noundef nonnull %18) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %14) #26
  store i32 0, ptr %14, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %15) #26
  store i32 0, ptr %15, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %16) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %17) #26
  %142 = call i32 @stbtt_GetGlyphBox(ptr noundef nonnull readonly %19, i32 noundef %73, ptr noundef nonnull %14, ptr noundef nonnull %15, ptr noundef nonnull %16, ptr noundef nonnull %17) #25
  call void @llvm.lifetime.end.p0(ptr nonnull %17) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %16) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %15) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %14) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %18) #26
  %143 = trunc i32 %134 to i16
  %144 = getelementptr inbounds nuw %struct.stbtt_bakedchar, ptr %8, i64 %66
  store i16 %143, ptr %144, align 4, !tbaa !66
  %145 = trunc i32 %133 to i16
  %146 = getelementptr inbounds nuw i8, ptr %144, i64 2
  store i16 %145, ptr %146, align 2, !tbaa !69
  %147 = add nsw i32 %134, %128
  %148 = trunc i32 %147 to i16
  %149 = getelementptr inbounds nuw i8, ptr %144, i64 4
  store i16 %148, ptr %149, align 4, !tbaa !65
  %150 = trunc i32 %135 to i16
  %151 = getelementptr inbounds nuw i8, ptr %144, i64 6
  store i16 %150, ptr %151, align 2, !tbaa !68
  %152 = sitofp i16 %97 to float
  %153 = fmul float %52, %152
  %154 = getelementptr inbounds nuw i8, ptr %144, i64 16
  store float %153, ptr %154, align 4, !tbaa !75
  %155 = sitofp i32 %124 to float
  %156 = getelementptr inbounds nuw i8, ptr %144, i64 8
  store float %155, ptr %156, align 4, !tbaa !59
  %157 = sitofp i32 %125 to float
  %158 = getelementptr inbounds nuw i8, ptr %144, i64 12
  store float %157, ptr %158, align 4, !tbaa !61
  %159 = add nsw i32 %147, 1
  %160 = call i32 @llvm.smax.i32(i32 %70, i32 %136)
  br label %161

161:                                              ; preds = %140, %138
  %162 = phi i32 [ %70, %138 ], [ %160, %140 ]
  %163 = phi i32 [ %134, %138 ], [ %159, %140 ]
  %164 = phi i32 [ %139, %138 ], [ %67, %140 ]
  br i1 %137, label %62, label %165

165:                                              ; preds = %62, %161, %9, %22
  %166 = phi i32 [ -1, %9 ], [ 1, %22 ], [ %162, %62 ], [ %164, %161 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %19) #26
  ret i32 %166
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define dso_local i32 @stbtt_GetNumberOfFonts(ptr noundef readonly captures(none) %0) local_unnamed_addr #16 {
  %2 = tail call fastcc i32 @stbtt__isfont(ptr noundef readonly %0) #25
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %57

4:                                                ; preds = %1
  %5 = load i8, ptr %0, align 1, !tbaa !14
  %6 = icmp eq i8 %5, 116
  br i1 %6, label %7, label %57

7:                                                ; preds = %4
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 1
  %9 = load i8, ptr %8, align 1, !tbaa !14
  %10 = icmp eq i8 %9, 116
  br i1 %10, label %11, label %57

11:                                               ; preds = %7
  %12 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %13 = load i8, ptr %12, align 1, !tbaa !14
  %14 = icmp eq i8 %13, 99
  br i1 %14, label %15, label %57

15:                                               ; preds = %11
  %16 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %17 = load i8, ptr %16, align 1, !tbaa !14
  %18 = icmp eq i8 %17, 102
  br i1 %18, label %19, label %57

19:                                               ; preds = %15
  %20 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %21 = load i8, ptr %20, align 1, !tbaa !14
  %22 = zext i8 %21 to i32
  %23 = shl nuw i32 %22, 24
  %24 = getelementptr inbounds nuw i8, ptr %0, i64 5
  %25 = load i8, ptr %24, align 1, !tbaa !14
  %26 = zext i8 %25 to i32
  %27 = shl nuw nsw i32 %26, 16
  %28 = or disjoint i32 %27, %23
  %29 = getelementptr inbounds nuw i8, ptr %0, i64 6
  %30 = load i8, ptr %29, align 1, !tbaa !14
  %31 = zext i8 %30 to i32
  %32 = shl nuw nsw i32 %31, 8
  %33 = or disjoint i32 %28, %32
  %34 = getelementptr inbounds nuw i8, ptr %0, i64 7
  %35 = load i8, ptr %34, align 1, !tbaa !14
  %36 = zext i8 %35 to i32
  %37 = or disjoint i32 %33, %36
  switch i32 %37, label %57 [
    i32 65536, label %38
    i32 131072, label %38
  ]

38:                                               ; preds = %19, %19
  %39 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %40 = load i8, ptr %39, align 1, !tbaa !14
  %41 = zext i8 %40 to i32
  %42 = shl nuw i32 %41, 24
  %43 = getelementptr inbounds nuw i8, ptr %0, i64 9
  %44 = load i8, ptr %43, align 1, !tbaa !14
  %45 = zext i8 %44 to i32
  %46 = shl nuw nsw i32 %45, 16
  %47 = or disjoint i32 %46, %42
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 10
  %49 = load i8, ptr %48, align 1, !tbaa !14
  %50 = zext i8 %49 to i32
  %51 = shl nuw nsw i32 %50, 8
  %52 = or disjoint i32 %47, %51
  %53 = getelementptr inbounds nuw i8, ptr %0, i64 11
  %54 = load i8, ptr %53, align 1, !tbaa !14
  %55 = zext i8 %54 to i32
  %56 = or disjoint i32 %52, %55
  br label %57

57:                                               ; preds = %1, %4, %7, %11, %15, %19, %38
  %58 = phi i32 [ 1, %1 ], [ %56, %38 ], [ 0, %19 ], [ 0, %15 ], [ 0, %11 ], [ 0, %7 ], [ 0, %4 ]
  ret i32 %58
}

; Function Attrs: nofree nounwind memory(read)
define dso_local i32 @stbtt_FindMatchingFont(ptr noundef readonly captures(none) %0, ptr noundef %1, i32 noundef %2) local_unnamed_addr #19 {
  %4 = icmp eq i32 %2, 0
  %5 = and i32 %2, 7
  br label %6

6:                                                ; preds = %176, %3
  %7 = phi i32 [ 0, %3 ], [ %179, %176 ]
  %8 = phi i32 [ undef, %3 ], [ %177, %176 ]
  %9 = tail call i32 @stbtt_GetFontOffsetForIndex(ptr noundef readonly %0, i32 noundef %7) #25
  %10 = icmp slt i32 %9, 0
  br i1 %10, label %176, label %11

11:                                               ; preds = %6
  %12 = tail call i64 @strlen(ptr noundef %1) #29
  %13 = trunc i64 %12 to i32
  %14 = zext nneg i32 %9 to i64
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 %14
  %16 = tail call fastcc i32 @stbtt__isfont(ptr noundef readonly %15) #25
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %173, label %18

18:                                               ; preds = %11
  br i1 %4, label %90, label %19

19:                                               ; preds = %18
  %20 = getelementptr inbounds nuw i8, ptr %15, i64 4
  %21 = load i8, ptr %20, align 1, !tbaa !14
  %22 = zext i8 %21 to i32
  %23 = shl nuw nsw i32 %22, 8
  %24 = getelementptr inbounds nuw i8, ptr %15, i64 5
  %25 = load i8, ptr %24, align 1, !tbaa !14
  %26 = zext i8 %25 to i32
  %27 = or disjoint i32 %23, %26
  %28 = add nuw i32 %9, 12
  %29 = icmp eq i32 %27, 0
  br i1 %29, label %82, label %30

30:                                               ; preds = %19
  %31 = zext nneg i32 %27 to i64
  br label %35

32:                                               ; preds = %76
  %33 = add nuw nsw i64 %36, 1
  %34 = icmp eq i64 %33, %31
  br i1 %34, label %79, label %35, !llvm.loop !53

35:                                               ; preds = %32, %30
  %36 = phi i64 [ 0, %30 ], [ %33, %32 ]
  %37 = phi i32 [ undef, %30 ], [ %77, %32 ]
  %38 = trunc i64 %36 to i32
  %39 = shl i32 %38, 4
  %40 = add i32 %28, %39
  %41 = zext i32 %40 to i64
  %42 = getelementptr inbounds nuw i8, ptr %0, i64 %41
  %43 = load i8, ptr %42, align 1, !tbaa !14
  %44 = icmp eq i8 %43, 104
  br i1 %44, label %45, label %76

45:                                               ; preds = %35
  %46 = getelementptr inbounds nuw i8, ptr %42, i64 1
  %47 = load i8, ptr %46, align 1, !tbaa !14
  %48 = icmp eq i8 %47, 101
  br i1 %48, label %49, label %76

49:                                               ; preds = %45
  %50 = getelementptr inbounds nuw i8, ptr %42, i64 2
  %51 = load i8, ptr %50, align 1, !tbaa !14
  %52 = icmp eq i8 %51, 97
  br i1 %52, label %53, label %76

53:                                               ; preds = %49
  %54 = getelementptr inbounds nuw i8, ptr %42, i64 3
  %55 = load i8, ptr %54, align 1, !tbaa !14
  %56 = icmp eq i8 %55, 100
  br i1 %56, label %57, label %76

57:                                               ; preds = %53
  %58 = getelementptr inbounds nuw i8, ptr %42, i64 8
  %59 = load i8, ptr %58, align 1, !tbaa !14
  %60 = zext i8 %59 to i32
  %61 = shl nuw i32 %60, 24
  %62 = getelementptr inbounds nuw i8, ptr %42, i64 9
  %63 = load i8, ptr %62, align 1, !tbaa !14
  %64 = zext i8 %63 to i32
  %65 = shl nuw nsw i32 %64, 16
  %66 = or disjoint i32 %65, %61
  %67 = getelementptr inbounds nuw i8, ptr %42, i64 10
  %68 = load i8, ptr %67, align 1, !tbaa !14
  %69 = zext i8 %68 to i32
  %70 = shl nuw nsw i32 %69, 8
  %71 = or disjoint i32 %66, %70
  %72 = getelementptr inbounds nuw i8, ptr %42, i64 11
  %73 = load i8, ptr %72, align 1, !tbaa !14
  %74 = zext i8 %73 to i32
  %75 = or disjoint i32 %71, %74
  br label %76

76:                                               ; preds = %57, %53, %49, %45, %35
  %77 = phi i32 [ %75, %57 ], [ %37, %53 ], [ %37, %49 ], [ %37, %45 ], [ %37, %35 ]
  %78 = phi i1 [ false, %57 ], [ true, %53 ], [ true, %49 ], [ true, %45 ], [ true, %35 ]
  br i1 %78, label %32, label %79

79:                                               ; preds = %76, %32
  %80 = phi i32 [ %77, %76 ], [ 0, %32 ]
  %81 = zext i32 %80 to i64
  br label %82

82:                                               ; preds = %79, %19
  %83 = phi i64 [ 0, %19 ], [ %81, %79 ]
  %84 = getelementptr inbounds nuw i8, ptr %0, i64 %83
  %85 = getelementptr inbounds nuw i8, ptr %84, i64 45
  %86 = load i8, ptr %85, align 1, !tbaa !14
  %87 = and i8 %86, 7
  %88 = zext nneg i8 %87 to i32
  %89 = icmp eq i32 %5, %88
  br i1 %89, label %90, label %173

90:                                               ; preds = %82, %18
  %91 = getelementptr inbounds nuw i8, ptr %15, i64 4
  %92 = load i8, ptr %91, align 1, !tbaa !14
  %93 = zext i8 %92 to i32
  %94 = shl nuw nsw i32 %93, 8
  %95 = getelementptr inbounds nuw i8, ptr %15, i64 5
  %96 = load i8, ptr %95, align 1, !tbaa !14
  %97 = zext i8 %96 to i32
  %98 = or disjoint i32 %94, %97
  %99 = add nuw i32 %9, 12
  %100 = icmp eq i32 %98, 0
  br i1 %100, label %150, label %101

101:                                              ; preds = %90
  %102 = zext nneg i32 %98 to i64
  br label %106

103:                                              ; preds = %147
  %104 = add nuw nsw i64 %107, 1
  %105 = icmp eq i64 %104, %102
  br i1 %105, label %150, label %106, !llvm.loop !53

106:                                              ; preds = %103, %101
  %107 = phi i64 [ 0, %101 ], [ %104, %103 ]
  %108 = phi i32 [ undef, %101 ], [ %148, %103 ]
  %109 = trunc i64 %107 to i32
  %110 = shl i32 %109, 4
  %111 = add i32 %99, %110
  %112 = zext i32 %111 to i64
  %113 = getelementptr inbounds nuw i8, ptr %0, i64 %112
  %114 = load i8, ptr %113, align 1, !tbaa !14
  %115 = icmp eq i8 %114, 110
  br i1 %115, label %116, label %147

116:                                              ; preds = %106
  %117 = getelementptr inbounds nuw i8, ptr %113, i64 1
  %118 = load i8, ptr %117, align 1, !tbaa !14
  %119 = icmp eq i8 %118, 97
  br i1 %119, label %120, label %147

120:                                              ; preds = %116
  %121 = getelementptr inbounds nuw i8, ptr %113, i64 2
  %122 = load i8, ptr %121, align 1, !tbaa !14
  %123 = icmp eq i8 %122, 109
  br i1 %123, label %124, label %147

124:                                              ; preds = %120
  %125 = getelementptr inbounds nuw i8, ptr %113, i64 3
  %126 = load i8, ptr %125, align 1, !tbaa !14
  %127 = icmp eq i8 %126, 101
  br i1 %127, label %128, label %147

128:                                              ; preds = %124
  %129 = getelementptr inbounds nuw i8, ptr %113, i64 8
  %130 = load i8, ptr %129, align 1, !tbaa !14
  %131 = zext i8 %130 to i32
  %132 = shl nuw i32 %131, 24
  %133 = getelementptr inbounds nuw i8, ptr %113, i64 9
  %134 = load i8, ptr %133, align 1, !tbaa !14
  %135 = zext i8 %134 to i32
  %136 = shl nuw nsw i32 %135, 16
  %137 = or disjoint i32 %136, %132
  %138 = getelementptr inbounds nuw i8, ptr %113, i64 10
  %139 = load i8, ptr %138, align 1, !tbaa !14
  %140 = zext i8 %139 to i32
  %141 = shl nuw nsw i32 %140, 8
  %142 = or disjoint i32 %137, %141
  %143 = getelementptr inbounds nuw i8, ptr %113, i64 11
  %144 = load i8, ptr %143, align 1, !tbaa !14
  %145 = zext i8 %144 to i32
  %146 = or disjoint i32 %142, %145
  br label %147

147:                                              ; preds = %128, %124, %120, %116, %106
  %148 = phi i32 [ %146, %128 ], [ %108, %124 ], [ %108, %120 ], [ %108, %116 ], [ %108, %106 ]
  %149 = phi i1 [ false, %128 ], [ true, %124 ], [ true, %120 ], [ true, %116 ], [ true, %106 ]
  br i1 %149, label %103, label %150

150:                                              ; preds = %147, %103, %90
  %151 = phi i32 [ 0, %90 ], [ %148, %147 ], [ 0, %103 ]
  %152 = icmp eq i32 %151, 0
  br i1 %152, label %173, label %153

153:                                              ; preds = %150
  br i1 %4, label %163, label %154

154:                                              ; preds = %153
  %155 = tail call fastcc i32 @stbtt__matchpair(ptr noundef readonly %0, i32 noundef %151, ptr noundef %1, i32 noundef %13, i32 noundef 16, i32 noundef -1) #25
  %156 = icmp eq i32 %155, 0
  br i1 %156, label %157, label %173

157:                                              ; preds = %154
  %158 = tail call fastcc i32 @stbtt__matchpair(ptr noundef readonly %0, i32 noundef %151, ptr noundef %1, i32 noundef %13, i32 noundef 1, i32 noundef -1) #25
  %159 = icmp eq i32 %158, 0
  br i1 %159, label %160, label %173

160:                                              ; preds = %157
  %161 = tail call fastcc i32 @stbtt__matchpair(ptr noundef readonly %0, i32 noundef %151, ptr noundef %1, i32 noundef %13, i32 noundef 3, i32 noundef -1) #25
  %162 = icmp eq i32 %161, 0
  br i1 %162, label %172, label %173

163:                                              ; preds = %153
  %164 = tail call fastcc i32 @stbtt__matchpair(ptr noundef readonly %0, i32 noundef %151, ptr noundef %1, i32 noundef %13, i32 noundef 16, i32 noundef 17) #25
  %165 = icmp eq i32 %164, 0
  br i1 %165, label %166, label %173

166:                                              ; preds = %163
  %167 = tail call fastcc i32 @stbtt__matchpair(ptr noundef readonly %0, i32 noundef %151, ptr noundef %1, i32 noundef %13, i32 noundef 1, i32 noundef 2) #25
  %168 = icmp eq i32 %167, 0
  br i1 %168, label %169, label %173

169:                                              ; preds = %166
  %170 = tail call fastcc i32 @stbtt__matchpair(ptr noundef readonly %0, i32 noundef %151, ptr noundef %1, i32 noundef %13, i32 noundef 3, i32 noundef -1) #25
  %171 = icmp eq i32 %170, 0
  br i1 %171, label %172, label %173

172:                                              ; preds = %169, %160
  br label %173

173:                                              ; preds = %172, %169, %166, %163, %160, %157, %154, %150, %82, %11
  %174 = phi i1 [ true, %11 ], [ true, %150 ], [ false, %154 ], [ false, %157 ], [ true, %172 ], [ false, %160 ], [ false, %163 ], [ false, %166 ], [ true, %82 ], [ false, %169 ]
  %175 = select i1 %174, i32 %8, i32 %9
  br label %176

176:                                              ; preds = %173, %6
  %177 = phi i32 [ %9, %6 ], [ %175, %173 ]
  %178 = phi i1 [ false, %6 ], [ %174, %173 ]
  %179 = add nuw nsw i32 %7, 1
  br i1 %178, label %6, label %180, !llvm.loop !149

180:                                              ; preds = %176
  ret i32 %177
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local range(i32 0, 2) i32 @stbtt_CompareUTF8toUTF16_bigendian(ptr noundef readonly captures(none) %0, i32 noundef %1, ptr noundef readonly captures(none) %2, i32 noundef %3) local_unnamed_addr #20 {
  %5 = tail call fastcc i32 @stbtt__CompareUTF8toUTF16_bigendian_prefix(ptr noundef readonly %0, i32 noundef %1, ptr noundef readonly %2, i32 noundef %3) #25
  %6 = icmp eq i32 %1, %5
  %7 = zext i1 %6 to i32
  ret i32 %7
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define dso_local ptr @stbtt_malloc(ptr noundef readnone captures(none) %0, i64 noundef %1) local_unnamed_addr #21 {
  %3 = load i64, ptr @alloc_offset, align 8, !tbaa !150
  %4 = add i64 %3, %1
  %5 = icmp ugt i64 %4, 1048576
  br i1 %5, label %8, label %6

6:                                                ; preds = %2
  %7 = getelementptr inbounds nuw i8, ptr @alloc_buffer, i64 %3
  store i64 %4, ptr @alloc_offset, align 8, !tbaa !150
  br label %8

8:                                                ; preds = %2, %6
  %9 = phi ptr [ %7, %6 ], [ null, %2 ]
  ret ptr %9
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define dso_local void @stbtt_free(ptr noundef readnone captures(none) %0, ptr noundef readnone captures(none) %1) local_unnamed_addr #7 {
  ret void
}

; Function Attrs: nounwind
define dso_local void @font_atlas_impl(ptr dead_on_unwind noalias writable writeonly sret(%struct.FontResult) align 4 captures(none) initializes((0, 4202000)) %0, ptr noundef %1, i32 %2, ptr noundef %3, i32 noundef %4) local_unnamed_addr #2 {
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca ptr, align 8
  %15 = alloca %struct.stbtt_fontinfo, align 8
  %16 = alloca [128 x i32], align 16
  %17 = alloca [256 x %struct.anon], align 16
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(4202000) %0, i8 0, i64 4202000, i1 false)
  store i32 2048, ptr %0, align 4, !tbaa !152
  %18 = getelementptr inbounds nuw i8, ptr %0, i64 4
  store i32 2048, ptr %18, align 4, !tbaa !154
  call void @llvm.lifetime.start.p0(ptr nonnull %15) #26
  %19 = tail call i32 @stbtt_GetFontOffsetForIndex(ptr noundef %1, i32 noundef 0) #25
  %20 = call i32 @stbtt_InitFont(ptr noundef nonnull %15, ptr noundef %1, i32 noundef %19) #25
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %293, label %22

22:                                               ; preds = %5
  %23 = sitofp i32 %4 to float
  %24 = getelementptr inbounds nuw i8, ptr %15, i64 8
  %25 = load ptr, ptr %24, align 8, !tbaa !8
  %26 = getelementptr inbounds nuw i8, ptr %15, i64 36
  %27 = load i32, ptr %26, align 4, !tbaa !37
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds i8, ptr %25, i64 %28
  %30 = getelementptr inbounds nuw i8, ptr %29, i64 4
  %31 = load i8, ptr %30, align 1, !tbaa !14
  %32 = zext i8 %31 to i16
  %33 = shl nuw i16 %32, 8
  %34 = getelementptr inbounds nuw i8, ptr %29, i64 5
  %35 = load i8, ptr %34, align 1, !tbaa !14
  %36 = zext i8 %35 to i16
  %37 = or disjoint i16 %33, %36
  %38 = sext i16 %37 to i32
  %39 = getelementptr inbounds nuw i8, ptr %29, i64 6
  %40 = load i8, ptr %39, align 1, !tbaa !14
  %41 = zext i8 %40 to i16
  %42 = shl nuw i16 %41, 8
  %43 = getelementptr inbounds nuw i8, ptr %29, i64 7
  %44 = load i8, ptr %43, align 1, !tbaa !14
  %45 = zext i8 %44 to i16
  %46 = or disjoint i16 %42, %45
  %47 = sext i16 %46 to i32
  %48 = sub nsw i32 %38, %47
  %49 = sitofp i32 %48 to float
  %50 = fdiv float %23, %49
  %51 = tail call i64 @strlen(ptr noundef %3) #29
  %52 = trunc i64 %51 to i32
  call void @llvm.lifetime.start.p0(ptr nonnull %16) #26
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(512) %16, i8 0, i64 512, i1 false)
  call void @llvm.lifetime.start.p0(ptr nonnull %17) #26
  %53 = icmp sgt i32 %52, 0
  br i1 %53, label %54, label %64

54:                                               ; preds = %22
  %55 = getelementptr inbounds nuw i8, ptr %29, i64 34
  %56 = getelementptr inbounds nuw i8, ptr %29, i64 35
  %57 = getelementptr inbounds nuw i8, ptr %15, i64 40
  %58 = load i32, ptr %57, align 8
  %59 = sext i32 %58 to i64
  %60 = getelementptr inbounds i8, ptr %25, i64 %59
  %61 = sext i32 %58 to i64
  %62 = getelementptr inbounds i8, ptr %25, i64 %61
  %63 = and i64 %51, 2147483647
  br label %75

64:                                               ; preds = %190, %22
  %65 = phi i32 [ 0, %22 ], [ %191, %190 ]
  %66 = icmp sgt i32 %65, 0
  br i1 %66, label %67, label %235

67:                                               ; preds = %64
  %68 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %69 = getelementptr inbounds nuw i8, ptr %0, i64 1036
  %70 = getelementptr inbounds nuw i8, ptr %0, i64 2060
  %71 = getelementptr inbounds nuw i8, ptr %0, i64 3084
  %72 = getelementptr inbounds nuw i8, ptr %0, i64 4108
  %73 = getelementptr inbounds nuw i8, ptr %0, i64 5132
  %74 = zext nneg i32 %65 to i64
  br label %196

75:                                               ; preds = %54, %190
  %76 = phi i64 [ 0, %54 ], [ %192, %190 ]
  %77 = phi i32 [ 0, %54 ], [ %191, %190 ]
  %78 = getelementptr inbounds nuw i8, ptr %3, i64 %76
  %79 = load i8, ptr %78, align 1, !tbaa !14
  %80 = zext i8 %79 to i32
  %81 = add i8 %79, -127
  %82 = icmp ult i8 %81, -95
  br i1 %82, label %190, label %83

83:                                               ; preds = %75
  %84 = zext nneg i8 %79 to i64
  %85 = getelementptr inbounds nuw i32, ptr %16, i64 %84
  %86 = load i32, ptr %85, align 4, !tbaa !4
  %87 = icmp eq i32 %86, 0
  br i1 %87, label %88, label %190

88:                                               ; preds = %83
  %89 = call i32 @stbtt_FindGlyphIndex(ptr noundef nonnull readonly %15, i32 noundef %80) #25
  %90 = load i8, ptr %55, align 1, !tbaa !14
  %91 = zext i8 %90 to i32
  %92 = shl nuw nsw i32 %91, 8
  %93 = load i8, ptr %56, align 1, !tbaa !14
  %94 = zext i8 %93 to i32
  %95 = or disjoint i32 %92, %94
  %96 = icmp slt i32 %89, %95
  br i1 %96, label %97, label %110

97:                                               ; preds = %88
  %98 = shl nsw i32 %89, 2
  %99 = sext i32 %98 to i64
  %100 = getelementptr inbounds i8, ptr %62, i64 %99
  %101 = load i8, ptr %100, align 1, !tbaa !14
  %102 = zext i8 %101 to i16
  %103 = shl nuw i16 %102, 8
  %104 = getelementptr inbounds nuw i8, ptr %100, i64 1
  %105 = load i8, ptr %104, align 1, !tbaa !14
  %106 = zext i8 %105 to i16
  %107 = or disjoint i16 %103, %106
  %108 = getelementptr inbounds nuw i8, ptr %100, i64 2
  %109 = getelementptr inbounds nuw i8, ptr %100, i64 3
  br label %127

110:                                              ; preds = %88
  %111 = shl nuw nsw i32 %95, 2
  %112 = zext nneg i32 %111 to i64
  %113 = getelementptr i8, ptr %60, i64 %112
  %114 = getelementptr i8, ptr %113, i64 -4
  %115 = load i8, ptr %114, align 1, !tbaa !14
  %116 = zext i8 %115 to i16
  %117 = shl nuw i16 %116, 8
  %118 = getelementptr i8, ptr %113, i64 -3
  %119 = load i8, ptr %118, align 1, !tbaa !14
  %120 = zext i8 %119 to i16
  %121 = or disjoint i16 %117, %120
  %122 = sub nsw i32 %89, %95
  %123 = shl nuw nsw i32 %122, 1
  %124 = zext nneg i32 %123 to i64
  %125 = getelementptr inbounds nuw i8, ptr %113, i64 %124
  %126 = getelementptr inbounds nuw i8, ptr %125, i64 1
  br label %127

127:                                              ; preds = %97, %110
  %128 = phi ptr [ %109, %97 ], [ %126, %110 ]
  %129 = phi ptr [ %108, %97 ], [ %125, %110 ]
  %130 = phi i16 [ %107, %97 ], [ %121, %110 ]
  %131 = load i8, ptr %129, align 1, !tbaa !14
  %132 = zext i8 %131 to i16
  %133 = shl nuw i16 %132, 8
  %134 = load i8, ptr %128, align 1, !tbaa !14
  %135 = zext i8 %134 to i16
  %136 = or disjoint i16 %133, %135
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #26
  store i32 0, ptr %6, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #26
  store i32 0, ptr %7, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %8) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %9) #26
  %137 = call i32 @stbtt_GetGlyphBox(ptr noundef nonnull readonly %15, i32 noundef %89, ptr noundef nonnull %6, ptr noundef nonnull %7, ptr noundef nonnull %8, ptr noundef nonnull %9) #25
  %138 = icmp eq i32 %137, 0
  br i1 %138, label %162, label %139

139:                                              ; preds = %127
  %140 = load i32, ptr %6, align 4, !tbaa !4
  %141 = sitofp i32 %140 to float
  %142 = call float @llvm.fmuladd.f32(float %141, float %50, float 0.000000e+00)
  %143 = call float @floorf(float noundef %142) #28
  %144 = fptosi float %143 to i32
  %145 = load i32, ptr %9, align 4, !tbaa !4
  %146 = sub nsw i32 0, %145
  %147 = sitofp i32 %146 to float
  %148 = call float @llvm.fmuladd.f32(float %147, float %50, float 0.000000e+00)
  %149 = call float @floorf(float noundef %148) #28
  %150 = fptosi float %149 to i32
  %151 = load i32, ptr %8, align 4, !tbaa !4
  %152 = sitofp i32 %151 to float
  %153 = call float @llvm.fmuladd.f32(float %152, float %50, float 0.000000e+00)
  %154 = call float @ceilf(float noundef %153) #28
  %155 = fptosi float %154 to i32
  %156 = load i32, ptr %7, align 4, !tbaa !4
  %157 = sub nsw i32 0, %156
  %158 = sitofp i32 %157 to float
  %159 = call float @llvm.fmuladd.f32(float %158, float %50, float 0.000000e+00)
  %160 = call float @ceilf(float noundef %159) #28
  %161 = fptosi float %160 to i32
  br label %162

162:                                              ; preds = %127, %139
  %163 = phi i32 [ %144, %139 ], [ 0, %127 ]
  %164 = phi i32 [ %150, %139 ], [ 0, %127 ]
  %165 = phi i32 [ %155, %139 ], [ 0, %127 ]
  %166 = phi i32 [ %161, %139 ], [ 0, %127 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %9) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %8) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  %167 = sub nsw i32 %165, %163
  %168 = sub nsw i32 %166, %164
  %169 = icmp sgt i32 %167, 0
  %170 = icmp sgt i32 %168, 0
  %171 = select i1 %169, i1 %170, i1 false
  br i1 %171, label %172, label %190

172:                                              ; preds = %162
  %173 = sext i32 %77 to i64
  %174 = getelementptr inbounds %struct.anon, ptr %17, i64 %173
  %175 = getelementptr inbounds nuw i8, ptr %174, i64 32
  store i32 %80, ptr %175, align 4, !tbaa !155
  %176 = sitofp i16 %130 to float
  %177 = fmul float %50, %176
  %178 = fptosi float %177 to i32
  %179 = getelementptr inbounds nuw i8, ptr %174, i64 8
  store i32 %178, ptr %179, align 4, !tbaa !157
  %180 = sitofp i16 %136 to float
  %181 = fmul float %50, %180
  %182 = fptosi float %181 to i32
  %183 = getelementptr inbounds nuw i8, ptr %174, i64 12
  store i32 %182, ptr %183, align 4, !tbaa !158
  %184 = getelementptr inbounds nuw i8, ptr %174, i64 16
  store i32 %163, ptr %184, align 4, !tbaa !159
  %185 = getelementptr inbounds nuw i8, ptr %174, i64 20
  store i32 %164, ptr %185, align 4, !tbaa !160
  %186 = getelementptr inbounds nuw i8, ptr %174, i64 24
  store i32 %165, ptr %186, align 4, !tbaa !161
  %187 = getelementptr inbounds nuw i8, ptr %174, i64 28
  store i32 %166, ptr %187, align 4, !tbaa !162
  store i32 %167, ptr %174, align 4, !tbaa !163
  %188 = getelementptr inbounds nuw i8, ptr %174, i64 4
  store i32 %168, ptr %188, align 4, !tbaa !164
  %189 = add nsw i32 %77, 1
  store i32 %189, ptr %85, align 4, !tbaa !4
  br label %190

190:                                              ; preds = %162, %172, %83, %75
  %191 = phi i32 [ %77, %83 ], [ %77, %75 ], [ %189, %172 ], [ %77, %162 ]
  %192 = add nuw nsw i64 %76, 1
  %193 = icmp samesign ult i64 %192, %63
  %194 = icmp slt i32 %191, 256
  %195 = select i1 %193, i1 %194, i1 false
  br i1 %195, label %75, label %64, !llvm.loop !165

196:                                              ; preds = %67, %211
  %197 = phi i64 [ 0, %67 ], [ %233, %211 ]
  %198 = phi i32 [ 0, %67 ], [ %231, %211 ]
  %199 = phi i32 [ 0, %67 ], [ %206, %211 ]
  %200 = phi i32 [ 0, %67 ], [ %232, %211 ]
  %201 = getelementptr inbounds nuw %struct.anon, ptr %17, i64 %197
  %202 = load i32, ptr %201, align 4, !tbaa !163
  %203 = add nsw i32 %202, %198
  %204 = icmp sgt i32 %203, 2047
  %205 = select i1 %204, i32 %200, i32 0
  %206 = add nuw nsw i32 %205, %199
  %207 = getelementptr inbounds nuw i8, ptr %201, i64 4
  %208 = load i32, ptr %207, align 4, !tbaa !164
  %209 = add nsw i32 %206, %208
  %210 = icmp sgt i32 %209, 2047
  br i1 %210, label %235, label %211

211:                                              ; preds = %196
  %212 = select i1 %204, i32 0, i32 %198
  %213 = select i1 %204, i32 0, i32 %200
  %214 = getelementptr inbounds nuw i8, ptr %201, i64 32
  %215 = load i32, ptr %214, align 4, !tbaa !155
  %216 = call i32 @stbtt_FindGlyphIndex(ptr noundef nonnull readonly %15, i32 noundef %215) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %14) #26
  %217 = call i32 @stbtt_GetGlyphShape(ptr noundef nonnull readonly %15, i32 noundef %216, ptr noundef nonnull %14) #25
  call void @llvm.lifetime.start.p0(ptr nonnull %10) #26
  store i32 0, ptr %10, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %11) #26
  store i32 0, ptr %11, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %13) #26
  %218 = call i32 @stbtt_GetGlyphBox(ptr noundef nonnull readonly %15, i32 noundef %216, ptr noundef nonnull %10, ptr noundef nonnull %11, ptr noundef nonnull %12, ptr noundef nonnull %13) #25
  call void @llvm.lifetime.end.p0(ptr nonnull %13) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %12) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %11) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %10) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %14) #26
  %219 = getelementptr inbounds nuw i8, ptr %201, i64 8
  %220 = load i32, ptr %219, align 4, !tbaa !157
  %221 = getelementptr inbounds nuw i32, ptr %68, i64 %197
  store i32 %220, ptr %221, align 4, !tbaa !4
  %222 = getelementptr inbounds nuw i8, ptr %201, i64 12
  %223 = load i32, ptr %222, align 4, !tbaa !158
  %224 = getelementptr inbounds nuw i32, ptr %69, i64 %197
  store i32 %223, ptr %224, align 4, !tbaa !4
  %225 = getelementptr inbounds nuw i32, ptr %70, i64 %197
  store i32 %212, ptr %225, align 4, !tbaa !4
  %226 = getelementptr inbounds nuw i32, ptr %71, i64 %197
  store i32 %206, ptr %226, align 4, !tbaa !4
  %227 = add nsw i32 %212, %202
  %228 = getelementptr inbounds nuw i32, ptr %72, i64 %197
  store i32 %227, ptr %228, align 4, !tbaa !4
  %229 = getelementptr inbounds nuw i32, ptr %73, i64 %197
  store i32 %209, ptr %229, align 4, !tbaa !4
  %230 = add nsw i32 %202, 1
  %231 = add nsw i32 %230, %212
  %232 = call i32 @llvm.smax.i32(i32 %208, i32 %213)
  %233 = add nuw nsw i64 %197, 1
  %234 = icmp eq i64 %233, %74
  br i1 %234, label %235, label %196, !llvm.loop !166

235:                                              ; preds = %211, %196, %64
  %236 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i32 %65, ptr %236, align 4, !tbaa !167
  %237 = icmp sgt i32 %65, 0
  br i1 %237, label %238, label %257

238:                                              ; preds = %235
  %239 = getelementptr inbounds nuw i8, ptr %15, i64 44
  %240 = load i32, ptr %239, align 4
  %241 = icmp eq i32 %240, 0
  %242 = getelementptr inbounds nuw i8, ptr %15, i64 48
  %243 = load i32, ptr %242, align 8
  %244 = icmp eq i32 %243, 0
  %245 = select i1 %241, i1 %244, i1 false
  %246 = getelementptr inbounds nuw i8, ptr %0, i64 6160
  %247 = getelementptr inbounds nuw i8, ptr %0, i64 6672
  %248 = getelementptr inbounds nuw i8, ptr %0, i64 7184
  %249 = zext nneg i32 %65 to i64
  %250 = zext nneg i32 %65 to i64
  br label %251

251:                                              ; preds = %238, %260
  %252 = phi i64 [ 0, %238 ], [ %261, %260 ]
  %253 = phi i32 [ 0, %238 ], [ %288, %260 ]
  %254 = getelementptr inbounds nuw %struct.anon, ptr %17, i64 %252
  %255 = getelementptr inbounds nuw i8, ptr %254, i64 32
  %256 = load i32, ptr %255, align 4, !tbaa !155
  br label %265

257:                                              ; preds = %260, %235
  %258 = phi i32 [ 0, %235 ], [ %288, %260 ]
  %259 = getelementptr inbounds nuw i8, ptr %0, i64 6156
  store i32 %258, ptr %259, align 4, !tbaa !168
  call void @llvm.lifetime.end.p0(ptr nonnull %17) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %16) #26
  br label %293

260:                                              ; preds = %287
  %261 = add nuw nsw i64 %252, 1
  %262 = icmp samesign ult i64 %261, %250
  %263 = icmp slt i32 %288, 128
  %264 = select i1 %262, i1 %263, i1 false
  br i1 %264, label %251, label %257, !llvm.loop !169

265:                                              ; preds = %251, %287
  %266 = phi i64 [ 0, %251 ], [ %289, %287 ]
  %267 = phi i32 [ %253, %251 ], [ %288, %287 ]
  %268 = getelementptr inbounds nuw %struct.anon, ptr %17, i64 %266
  %269 = getelementptr inbounds nuw i8, ptr %268, i64 32
  %270 = load i32, ptr %269, align 4, !tbaa !155
  br i1 %245, label %275, label %271

271:                                              ; preds = %265
  %272 = call i32 @stbtt_FindGlyphIndex(ptr noundef nonnull readonly %15, i32 noundef %256) #25
  %273 = call i32 @stbtt_FindGlyphIndex(ptr noundef nonnull readonly %15, i32 noundef %270) #25
  %274 = call i32 @stbtt_GetGlyphKernAdvance(ptr noundef nonnull readonly %15, i32 noundef %272, i32 noundef %273) #25
  br label %275

275:                                              ; preds = %265, %271
  %276 = phi i32 [ %274, %271 ], [ 0, %265 ]
  %277 = icmp eq i32 %276, 0
  br i1 %277, label %287, label %278

278:                                              ; preds = %275
  %279 = sext i32 %267 to i64
  %280 = getelementptr inbounds i32, ptr %246, i64 %279
  store i32 %256, ptr %280, align 4, !tbaa !4
  %281 = getelementptr inbounds i32, ptr %247, i64 %279
  store i32 %270, ptr %281, align 4, !tbaa !4
  %282 = sitofp i32 %276 to float
  %283 = fmul float %50, %282
  %284 = fptosi float %283 to i32
  %285 = getelementptr inbounds i32, ptr %248, i64 %279
  store i32 %284, ptr %285, align 4, !tbaa !4
  %286 = add nsw i32 %267, 1
  br label %287

287:                                              ; preds = %278, %275
  %288 = phi i32 [ %286, %278 ], [ %267, %275 ]
  %289 = add nuw nsw i64 %266, 1
  %290 = icmp samesign ult i64 %289, %249
  %291 = icmp slt i32 %288, 128
  %292 = select i1 %290, i1 %291, i1 false
  br i1 %292, label %265, label %260, !llvm.loop !170

293:                                              ; preds = %5, %257
  call void @llvm.lifetime.end.p0(ptr nonnull %15) #26
  ret void
}

; Function Attrs: mustprogress nofree nounwind willreturn memory(read)
declare i64 @strlen(ptr noundef) local_unnamed_addr #22

; Function Attrs: nounwind
define dso_local noundef ptr @font_atlas(ptr noundef %0, i32 noundef %1, ptr noundef %2, i32 noundef %3, ptr noundef returned writeonly captures(ret: address, provenance) initializes((0, 12)) %4, ptr noundef writeonly captures(none) %5) local_unnamed_addr #2 {
  %7 = alloca %struct.FontResult, align 4
  %8 = alloca [5 x i32], align 16
  %9 = alloca [3 x i32], align 4
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #26
  call void @font_atlas_impl(ptr dead_on_unwind nonnull writable sret(%struct.FontResult) align 4 %7, ptr noundef %0, i32 poison, ptr noundef %2, i32 noundef %3) #25
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(4202000) @font_atlas.result, ptr noundef nonnull align 4 dereferenceable(4202000) %7, i64 4202000, i1 false), !tbaa.struct !171
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #26
  %10 = load i32, ptr @font_atlas.result, align 4, !tbaa !152
  %11 = trunc i32 %10 to i8
  store i8 %11, ptr %4, align 1, !tbaa !14
  %12 = lshr i32 %10, 8
  %13 = trunc i32 %12 to i8
  %14 = getelementptr inbounds nuw i8, ptr %4, i64 1
  store i8 %13, ptr %14, align 1, !tbaa !14
  %15 = lshr i32 %10, 16
  %16 = trunc i32 %15 to i8
  %17 = getelementptr inbounds nuw i8, ptr %4, i64 2
  store i8 %16, ptr %17, align 1, !tbaa !14
  %18 = lshr i32 %10, 24
  %19 = trunc nuw i32 %18 to i8
  %20 = getelementptr inbounds nuw i8, ptr %4, i64 3
  store i8 %19, ptr %20, align 1, !tbaa !14
  %21 = load i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 4), align 4, !tbaa !154
  %22 = trunc i32 %21 to i8
  %23 = getelementptr inbounds nuw i8, ptr %4, i64 4
  store i8 %22, ptr %23, align 1, !tbaa !14
  %24 = lshr i32 %21, 8
  %25 = trunc i32 %24 to i8
  %26 = getelementptr inbounds nuw i8, ptr %4, i64 5
  store i8 %25, ptr %26, align 1, !tbaa !14
  %27 = lshr i32 %21, 16
  %28 = trunc i32 %27 to i8
  %29 = getelementptr inbounds nuw i8, ptr %4, i64 6
  store i8 %28, ptr %29, align 1, !tbaa !14
  %30 = lshr i32 %21, 24
  %31 = trunc nuw i32 %30 to i8
  %32 = getelementptr inbounds nuw i8, ptr %4, i64 7
  store i8 %31, ptr %32, align 1, !tbaa !14
  %33 = load i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 8), align 4, !tbaa !167
  %34 = trunc i32 %33 to i8
  %35 = getelementptr inbounds nuw i8, ptr %4, i64 8
  store i8 %34, ptr %35, align 1, !tbaa !14
  %36 = lshr i32 %33, 8
  %37 = trunc i32 %36 to i8
  %38 = getelementptr inbounds nuw i8, ptr %4, i64 9
  store i8 %37, ptr %38, align 1, !tbaa !14
  %39 = lshr i32 %33, 16
  %40 = trunc i32 %39 to i8
  %41 = getelementptr inbounds nuw i8, ptr %4, i64 10
  store i8 %40, ptr %41, align 1, !tbaa !14
  %42 = lshr i32 %33, 24
  %43 = trunc nuw i32 %42 to i8
  %44 = getelementptr inbounds nuw i8, ptr %4, i64 11
  store i8 %43, ptr %44, align 1, !tbaa !14
  %45 = icmp sgt i32 %33, 0
  br i1 %45, label %46, label %54

46:                                               ; preds = %6
  %47 = getelementptr inbounds nuw i8, ptr %8, i64 4
  %48 = getelementptr inbounds nuw i8, ptr %8, i64 8
  %49 = getelementptr inbounds nuw i8, ptr %8, i64 12
  %50 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %51 = zext nneg i32 %33 to i64
  br label %75

52:                                               ; preds = %90
  %53 = trunc nsw i64 %108 to i32
  br label %54

54:                                               ; preds = %52, %6
  %55 = phi i32 [ 12, %6 ], [ %53, %52 ]
  %56 = load i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 6156), align 4, !tbaa !168
  %57 = trunc i32 %56 to i8
  %58 = sext i32 %55 to i64
  %59 = getelementptr inbounds i8, ptr %4, i64 %58
  store i8 %57, ptr %59, align 1, !tbaa !14
  %60 = lshr i32 %56, 8
  %61 = trunc i32 %60 to i8
  %62 = getelementptr i8, ptr %59, i64 1
  store i8 %61, ptr %62, align 1, !tbaa !14
  %63 = lshr i32 %56, 16
  %64 = trunc i32 %63 to i8
  %65 = getelementptr i8, ptr %59, i64 2
  store i8 %64, ptr %65, align 1, !tbaa !14
  %66 = lshr i32 %56, 24
  %67 = trunc nuw i32 %66 to i8
  %68 = add nsw i32 %55, 4
  %69 = getelementptr i8, ptr %59, i64 3
  store i8 %67, ptr %69, align 1, !tbaa !14
  %70 = icmp sgt i32 %56, 0
  br i1 %70, label %71, label %112

71:                                               ; preds = %54
  %72 = getelementptr inbounds nuw i8, ptr %9, i64 4
  %73 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %74 = zext nneg i32 %56 to i64
  br label %119

75:                                               ; preds = %46, %90
  %76 = phi i64 [ 0, %46 ], [ %91, %90 ]
  %77 = phi i64 [ 12, %46 ], [ %108, %90 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %8) #26
  %78 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 12), i64 %76
  %79 = load i32, ptr %78, align 4, !tbaa !4
  store i32 %79, ptr %8, align 16, !tbaa !4
  %80 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 1036), i64 %76
  %81 = load i32, ptr %80, align 4, !tbaa !4
  store i32 %81, ptr %47, align 4, !tbaa !4
  %82 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 2060), i64 %76
  %83 = load i32, ptr %82, align 4, !tbaa !4
  store i32 %83, ptr %48, align 8, !tbaa !4
  %84 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 3084), i64 %76
  %85 = load i32, ptr %84, align 4, !tbaa !4
  store i32 %85, ptr %49, align 4, !tbaa !4
  %86 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 4108), i64 %76
  %87 = load i32, ptr %86, align 4, !tbaa !4
  store i32 %87, ptr %50, align 16, !tbaa !4
  %88 = shl i64 %77, 32
  %89 = ashr exact i64 %88, 32
  br label %93

90:                                               ; preds = %93
  call void @llvm.lifetime.end.p0(ptr nonnull %8) #26
  %91 = add nuw nsw i64 %76, 1
  %92 = icmp eq i64 %91, %51
  br i1 %92, label %52, label %75, !llvm.loop !172

93:                                               ; preds = %75, %93
  %94 = phi i64 [ 0, %75 ], [ %110, %93 ]
  %95 = phi i64 [ %89, %75 ], [ %108, %93 ]
  %96 = getelementptr inbounds nuw i32, ptr %8, i64 %94
  %97 = load i32, ptr %96, align 4, !tbaa !4
  %98 = trunc i32 %97 to i8
  %99 = getelementptr inbounds i8, ptr %4, i64 %95
  store i8 %98, ptr %99, align 1, !tbaa !14
  %100 = lshr i32 %97, 8
  %101 = trunc i32 %100 to i8
  %102 = getelementptr i8, ptr %99, i64 1
  store i8 %101, ptr %102, align 1, !tbaa !14
  %103 = lshr i32 %97, 16
  %104 = trunc i32 %103 to i8
  %105 = getelementptr i8, ptr %99, i64 2
  store i8 %104, ptr %105, align 1, !tbaa !14
  %106 = lshr i32 %97, 24
  %107 = trunc nuw i32 %106 to i8
  %108 = add nsw i64 %95, 4
  %109 = getelementptr i8, ptr %99, i64 3
  store i8 %107, ptr %109, align 1, !tbaa !14
  %110 = add nuw nsw i64 %94, 1
  %111 = icmp eq i64 %110, 5
  br i1 %111, label %90, label %93, !llvm.loop !173

112:                                              ; preds = %129, %54
  %113 = phi i32 [ %68, %54 ], [ %130, %129 ]
  %114 = mul nsw i32 %21, %10
  %115 = icmp sgt i32 %114, 0
  br i1 %115, label %116, label %154

116:                                              ; preds = %112
  %117 = sext i32 %113 to i64
  %118 = zext nneg i32 %114 to i64
  br label %156

119:                                              ; preds = %71, %129
  %120 = phi i64 [ 0, %71 ], [ %131, %129 ]
  %121 = phi i32 [ %68, %71 ], [ %130, %129 ]
  call void @llvm.lifetime.start.p0(ptr nonnull %9) #26
  %122 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 6160), i64 %120
  %123 = load i32, ptr %122, align 4, !tbaa !4
  store i32 %123, ptr %9, align 4, !tbaa !4
  %124 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 6672), i64 %120
  %125 = load i32, ptr %124, align 4, !tbaa !4
  store i32 %125, ptr %72, align 4, !tbaa !4
  %126 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 7184), i64 %120
  %127 = load i32, ptr %126, align 4, !tbaa !4
  store i32 %127, ptr %73, align 4, !tbaa !4
  %128 = sext i32 %121 to i64
  br label %133

129:                                              ; preds = %133
  %130 = trunc nsw i64 %148 to i32
  call void @llvm.lifetime.end.p0(ptr nonnull %9) #26
  %131 = add nuw nsw i64 %120, 1
  %132 = icmp eq i64 %131, %74
  br i1 %132, label %112, label %119, !llvm.loop !174

133:                                              ; preds = %119, %133
  %134 = phi i64 [ 0, %119 ], [ %150, %133 ]
  %135 = phi i64 [ %128, %119 ], [ %148, %133 ]
  %136 = getelementptr inbounds nuw i32, ptr %9, i64 %134
  %137 = load i32, ptr %136, align 4, !tbaa !4
  %138 = trunc i32 %137 to i8
  %139 = getelementptr inbounds i8, ptr %4, i64 %135
  store i8 %138, ptr %139, align 1, !tbaa !14
  %140 = lshr i32 %137, 8
  %141 = trunc i32 %140 to i8
  %142 = getelementptr i8, ptr %139, i64 1
  store i8 %141, ptr %142, align 1, !tbaa !14
  %143 = lshr i32 %137, 16
  %144 = trunc i32 %143 to i8
  %145 = getelementptr i8, ptr %139, i64 2
  store i8 %144, ptr %145, align 1, !tbaa !14
  %146 = lshr i32 %137, 24
  %147 = trunc nuw i32 %146 to i8
  %148 = add nsw i64 %135, 4
  %149 = getelementptr i8, ptr %139, i64 3
  store i8 %147, ptr %149, align 1, !tbaa !14
  %150 = add nuw nsw i64 %134, 1
  %151 = icmp eq i64 %150, 3
  br i1 %151, label %129, label %133, !llvm.loop !175

152:                                              ; preds = %156
  %153 = trunc nsw i64 %161 to i32
  br label %154

154:                                              ; preds = %152, %112
  %155 = phi i32 [ %113, %112 ], [ %153, %152 ]
  store i32 %155, ptr %5, align 4, !tbaa !4
  ret ptr %4

156:                                              ; preds = %116, %156
  %157 = phi i64 [ %117, %116 ], [ %161, %156 ]
  %158 = phi i64 [ 0, %116 ], [ %163, %156 ]
  %159 = getelementptr inbounds nuw i8, ptr getelementptr inbounds nuw (i8, ptr @font_atlas.result, i64 7696), i64 %158
  %160 = load i8, ptr %159, align 1, !tbaa !14
  %161 = add nsw i64 %157, 1
  %162 = getelementptr inbounds i8, ptr %4, i64 %157
  store i8 %160, ptr %162, align 1, !tbaa !14
  %163 = add nuw nsw i64 %158, 1
  %164 = icmp eq i64 %163, %118
  br i1 %164, label %152, label %156, !llvm.loop !176
}

; Function Attrs: nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define internal fastcc range(i32 0, 2) i32 @stbtt__run_charstring(ptr noundef readonly captures(none) %0, i32 noundef %1, ptr noundef nonnull %2) unnamed_addr #3 {
  %4 = alloca [48 x float], align 16
  %5 = alloca [10 x %struct.stbtt__buf], align 16
  %6 = alloca %struct.stbtt__buf, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %4) #26
  call void @llvm.lifetime.start.p0(ptr nonnull %5) #26
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 112
  %8 = load ptr, ptr %7, align 8, !tbaa !57
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 120
  %10 = load i64, ptr %9, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #26
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 80
  %12 = load ptr, ptr %11, align 8
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 88
  %14 = load i64, ptr %13, align 8
  %15 = tail call fastcc { ptr, i64 } @stbtt__cff_index_get(ptr %12, i64 %14, i32 noundef %1) #25
  %16 = extractvalue { ptr, i64 } %15, 0
  %17 = extractvalue { ptr, i64 } %15, 1
  store ptr %16, ptr %6, align 8, !tbaa !57
  %18 = getelementptr inbounds nuw i8, ptr %6, i64 8
  store i64 %17, ptr %18, align 8
  %19 = getelementptr inbounds nuw i8, ptr %6, i64 12
  %20 = load i32, ptr %18, align 8, !tbaa !177
  %21 = load i32, ptr %19, align 4, !tbaa !178
  %22 = icmp slt i32 %20, %21
  br i1 %22, label %23, label %1000

23:                                               ; preds = %3
  %24 = getelementptr inbounds nuw i8, ptr %4, i64 4
  %25 = getelementptr inbounds nuw i8, ptr %4, i64 8
  %26 = getelementptr inbounds nuw i8, ptr %4, i64 12
  %27 = getelementptr inbounds nuw i8, ptr %4, i64 16
  %28 = getelementptr inbounds nuw i8, ptr %4, i64 20
  %29 = getelementptr inbounds nuw i8, ptr %4, i64 24
  %30 = getelementptr inbounds nuw i8, ptr %4, i64 28
  %31 = getelementptr inbounds nuw i8, ptr %4, i64 32
  %32 = getelementptr inbounds nuw i8, ptr %4, i64 36
  %33 = getelementptr inbounds nuw i8, ptr %4, i64 40
  %34 = getelementptr inbounds nuw i8, ptr %4, i64 4
  %35 = getelementptr inbounds nuw i8, ptr %4, i64 8
  %36 = getelementptr inbounds nuw i8, ptr %4, i64 12
  %37 = getelementptr inbounds nuw i8, ptr %4, i64 16
  %38 = getelementptr inbounds nuw i8, ptr %4, i64 20
  %39 = getelementptr inbounds nuw i8, ptr %4, i64 24
  %40 = getelementptr inbounds nuw i8, ptr %4, i64 28
  %41 = getelementptr inbounds nuw i8, ptr %4, i64 32
  %42 = getelementptr inbounds nuw i8, ptr %4, i64 4
  %43 = getelementptr inbounds nuw i8, ptr %4, i64 8
  %44 = getelementptr inbounds nuw i8, ptr %4, i64 12
  %45 = getelementptr inbounds nuw i8, ptr %4, i64 16
  %46 = getelementptr inbounds nuw i8, ptr %4, i64 20
  %47 = getelementptr inbounds nuw i8, ptr %4, i64 24
  %48 = getelementptr inbounds nuw i8, ptr %4, i64 28
  %49 = getelementptr inbounds nuw i8, ptr %4, i64 32
  %50 = getelementptr inbounds nuw i8, ptr %4, i64 36
  %51 = getelementptr inbounds nuw i8, ptr %4, i64 40
  %52 = getelementptr inbounds nuw i8, ptr %4, i64 44
  %53 = getelementptr inbounds nuw i8, ptr %4, i64 4
  %54 = getelementptr inbounds nuw i8, ptr %4, i64 8
  %55 = getelementptr inbounds nuw i8, ptr %4, i64 12
  %56 = getelementptr inbounds nuw i8, ptr %4, i64 16
  %57 = getelementptr inbounds nuw i8, ptr %4, i64 20
  %58 = getelementptr inbounds nuw i8, ptr %4, i64 24
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 156
  %60 = getelementptr inbounds nuw i8, ptr %0, i64 144
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 64
  %62 = getelementptr inbounds nuw i8, ptr %0, i64 128
  %63 = getelementptr inbounds nuw i8, ptr %0, i64 136
  %64 = getelementptr inbounds nuw i8, ptr %0, i64 72
  %65 = getelementptr inbounds nuw i8, ptr %0, i64 96
  %66 = getelementptr inbounds nuw i8, ptr %0, i64 104
  %67 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %68 = getelementptr inbounds nuw i8, ptr %2, i64 20
  %69 = getelementptr inbounds nuw i8, ptr %2, i64 28
  %70 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %71 = getelementptr inbounds nuw i8, ptr %2, i64 36
  %72 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %73 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %74 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %75 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %76 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %77 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %78 = getelementptr inbounds nuw i8, ptr %2, i64 40
  %79 = getelementptr inbounds nuw i8, ptr %2, i64 48
  %80 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %81 = getelementptr inbounds nuw i8, ptr %2, i64 20
  %82 = getelementptr inbounds nuw i8, ptr %2, i64 28
  %83 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %84 = getelementptr inbounds nuw i8, ptr %2, i64 36
  %85 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %86 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %87 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %88 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %89 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %90 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %91 = getelementptr inbounds nuw i8, ptr %2, i64 40
  %92 = getelementptr inbounds nuw i8, ptr %2, i64 48
  %93 = getelementptr inbounds nuw i8, ptr %2, i64 48
  %94 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %95 = getelementptr inbounds nuw i8, ptr %2, i64 20
  %96 = getelementptr inbounds nuw i8, ptr %2, i64 28
  %97 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %98 = getelementptr inbounds nuw i8, ptr %2, i64 36
  %99 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %100 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %101 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %102 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %103 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %104 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %105 = getelementptr inbounds nuw i8, ptr %2, i64 40
  %106 = getelementptr inbounds nuw i8, ptr %2, i64 48
  %107 = getelementptr inbounds nuw i8, ptr %2, i64 48
  %108 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %109 = getelementptr inbounds nuw i8, ptr %2, i64 20
  %110 = getelementptr inbounds nuw i8, ptr %2, i64 28
  %111 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %112 = getelementptr inbounds nuw i8, ptr %2, i64 36
  %113 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %114 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %115 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %116 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %117 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %118 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %119 = getelementptr inbounds nuw i8, ptr %2, i64 40
  %120 = getelementptr inbounds nuw i8, ptr %2, i64 48
  %121 = getelementptr inbounds nuw i8, ptr %2, i64 48
  %122 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %123 = getelementptr inbounds nuw i8, ptr %2, i64 20
  %124 = getelementptr inbounds nuw i8, ptr %2, i64 28
  %125 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %126 = getelementptr inbounds nuw i8, ptr %2, i64 36
  %127 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %128 = getelementptr inbounds nuw i8, ptr %2, i64 24
  %129 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %130 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %131 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %132 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %133 = getelementptr inbounds nuw i8, ptr %2, i64 40
  %134 = getelementptr inbounds nuw i8, ptr %2, i64 48
  br label %135

135:                                              ; preds = %23, %989
  %136 = phi i32 [ %21, %23 ], [ %998, %989 ]
  %137 = phi i32 [ %20, %23 ], [ %997, %989 ]
  %138 = phi i32 [ 1, %23 ], [ %996, %989 ]
  %139 = phi i32 [ 0, %23 ], [ %995, %989 ]
  %140 = phi i32 [ 0, %23 ], [ %994, %989 ]
  %141 = phi i32 [ 0, %23 ], [ %992, %989 ]
  %142 = phi i32 [ 0, %23 ], [ %993, %989 ]
  %143 = phi i64 [ %10, %23 ], [ %991, %989 ]
  %144 = phi ptr [ %8, %23 ], [ %990, %989 ]
  %145 = load ptr, ptr %6, align 8, !tbaa !179
  %146 = add nsw i32 %137, 1
  store i32 %146, ptr %18, align 8, !tbaa !177
  %147 = sext i32 %137 to i64
  %148 = getelementptr inbounds i8, ptr %145, i64 %147
  %149 = load i8, ptr %148, align 1, !tbaa !14
  switch i8 %149, label %940 [
    i8 19, label %150
    i8 20, label %150
    i8 1, label %164
    i8 3, label %164
    i8 18, label %164
    i8 23, label %164
    i8 21, label %167
    i8 4, label %176
    i8 22, label %183
    i8 5, label %190
    i8 7, label %259
    i8 6, label %261
    i8 31, label %385
    i8 30, label %387
    i8 8, label %435
    i8 24, label %457
    i8 25, label %544
    i8 26, label %635
    i8 27, label %635
    i8 10, label %669
    i8 29, label %785
    i8 11, label %850
    i8 14, label %856
    i8 12, label %857
  ]

150:                                              ; preds = %135, %135
  %151 = icmp eq i32 %138, 0
  br i1 %151, label %155, label %152

152:                                              ; preds = %150
  %153 = sdiv i32 %141, 2
  %154 = add nsw i32 %139, %153
  br label %155

155:                                              ; preds = %152, %150
  %156 = phi i32 [ %154, %152 ], [ %139, %150 ]
  %157 = add nsw i32 %156, 7
  %158 = sdiv i32 %157, 8
  %159 = load i32, ptr %18, align 8, !tbaa !177
  %160 = add nsw i32 %158, %159
  %161 = icmp slt i32 %160, 0
  %162 = tail call i32 @llvm.smin.i32(i32 %160, i32 %136)
  %163 = select i1 %161, i32 %136, i32 %162
  store i32 %163, ptr %18, align 8, !tbaa !177
  br label %989

164:                                              ; preds = %135, %135, %135, %135
  %165 = sdiv i32 %141, 2
  %166 = add nsw i32 %139, %165
  br label %989

167:                                              ; preds = %135
  %168 = icmp slt i32 %141, 2
  br i1 %168, label %1000, label %169

169:                                              ; preds = %167
  %170 = zext nneg i32 %141 to i64
  %171 = getelementptr float, ptr %4, i64 %170
  %172 = getelementptr i8, ptr %171, i64 -8
  %173 = load float, ptr %172, align 4, !tbaa !58
  %174 = getelementptr i8, ptr %171, i64 -4
  %175 = load float, ptr %174, align 4, !tbaa !58
  tail call fastcc void @stbtt__csctx_rmove_to(ptr noundef %2, float noundef %173, float noundef %175) #25
  br label %989

176:                                              ; preds = %135
  %177 = icmp slt i32 %141, 1
  br i1 %177, label %1000, label %178

178:                                              ; preds = %176
  %179 = zext nneg i32 %141 to i64
  %180 = getelementptr float, ptr %4, i64 %179
  %181 = getelementptr i8, ptr %180, i64 -4
  %182 = load float, ptr %181, align 4, !tbaa !58
  tail call fastcc void @stbtt__csctx_rmove_to(ptr noundef %2, float noundef 0.000000e+00, float noundef %182) #25
  br label %989

183:                                              ; preds = %135
  %184 = icmp slt i32 %141, 1
  br i1 %184, label %1000, label %185

185:                                              ; preds = %183
  %186 = zext nneg i32 %141 to i64
  %187 = getelementptr float, ptr %4, i64 %186
  %188 = getelementptr i8, ptr %187, i64 -4
  %189 = load float, ptr %188, align 4, !tbaa !58
  tail call fastcc void @stbtt__csctx_rmove_to(ptr noundef %2, float noundef %189, float noundef 0.000000e+00) #25
  br label %989

190:                                              ; preds = %135
  %191 = icmp slt i32 %141, 2
  br i1 %191, label %1000, label %192

192:                                              ; preds = %190
  %193 = load i32, ptr %2, align 8, !tbaa !180
  %194 = icmp eq i32 %193, 0
  %195 = load float, ptr %122, align 8, !tbaa !181
  %196 = load float, ptr %123, align 4, !tbaa !182
  %197 = load i32, ptr %134, align 8, !tbaa !32
  %198 = sext i32 %197 to i64
  %199 = zext nneg i32 %141 to i64
  br label %200

200:                                              ; preds = %192, %254
  %201 = phi i64 [ 0, %192 ], [ %256, %254 ]
  %202 = phi i64 [ %198, %192 ], [ %255, %254 ]
  %203 = phi float [ %196, %192 ], [ %211, %254 ]
  %204 = phi float [ %195, %192 ], [ %210, %254 ]
  %205 = getelementptr inbounds nuw float, ptr %4, i64 %201
  %206 = load float, ptr %205, align 8, !tbaa !58
  %207 = getelementptr inbounds nuw float, ptr %4, i64 %201
  %208 = getelementptr inbounds nuw i8, ptr %207, i64 4
  %209 = load float, ptr %208, align 4, !tbaa !58
  %210 = fadd float %206, %204
  %211 = fadd float %209, %203
  %212 = fptosi float %210 to i32
  %213 = fptosi float %211 to i32
  br i1 %194, label %243, label %214

214:                                              ; preds = %200
  %215 = load i32, ptr %124, align 4, !tbaa !183
  %216 = icmp slt i32 %215, %212
  br i1 %216, label %220, label %217

217:                                              ; preds = %214
  %218 = load i32, ptr %125, align 4, !tbaa !184
  %219 = icmp eq i32 %218, 0
  br i1 %219, label %220, label %221

220:                                              ; preds = %217, %214
  store i32 %212, ptr %124, align 4, !tbaa !183
  br label %221

221:                                              ; preds = %220, %217
  %222 = load i32, ptr %126, align 4, !tbaa !185
  %223 = icmp slt i32 %222, %213
  br i1 %223, label %227, label %224

224:                                              ; preds = %221
  %225 = load i32, ptr %127, align 4, !tbaa !184
  %226 = icmp eq i32 %225, 0
  br i1 %226, label %227, label %228

227:                                              ; preds = %224, %221
  store i32 %213, ptr %126, align 4, !tbaa !185
  br label %228

228:                                              ; preds = %227, %224
  %229 = load i32, ptr %128, align 8, !tbaa !186
  %230 = icmp sgt i32 %229, %212
  br i1 %230, label %234, label %231

231:                                              ; preds = %228
  %232 = load i32, ptr %129, align 4, !tbaa !184
  %233 = icmp eq i32 %232, 0
  br i1 %233, label %234, label %235

234:                                              ; preds = %231, %228
  store i32 %212, ptr %128, align 8, !tbaa !186
  br label %235

235:                                              ; preds = %234, %231
  %236 = load i32, ptr %130, align 8, !tbaa !187
  %237 = icmp sgt i32 %236, %213
  br i1 %237, label %241, label %238

238:                                              ; preds = %235
  %239 = load i32, ptr %131, align 4, !tbaa !184
  %240 = icmp eq i32 %239, 0
  br i1 %240, label %241, label %242

241:                                              ; preds = %238, %235
  store i32 %213, ptr %130, align 8, !tbaa !187
  br label %242

242:                                              ; preds = %241, %238
  store i32 1, ptr %132, align 4, !tbaa !184
  br label %254

243:                                              ; preds = %200
  %244 = load ptr, ptr %133, align 8, !tbaa !29
  %245 = getelementptr inbounds %struct.stbtt_vertex, ptr %244, i64 %202
  %246 = getelementptr inbounds nuw i8, ptr %245, i64 12
  store i8 2, ptr %246, align 2, !tbaa !141
  %247 = trunc i32 %212 to i16
  store i16 %247, ptr %245, align 2, !tbaa !21
  %248 = trunc i32 %213 to i16
  %249 = getelementptr inbounds nuw i8, ptr %245, i64 2
  store i16 %248, ptr %249, align 2, !tbaa !24
  %250 = getelementptr inbounds nuw i8, ptr %245, i64 4
  store i16 0, ptr %250, align 2, !tbaa !25
  %251 = getelementptr inbounds nuw i8, ptr %245, i64 6
  store i16 0, ptr %251, align 2, !tbaa !26
  %252 = getelementptr inbounds nuw i8, ptr %245, i64 8
  store i16 0, ptr %252, align 2, !tbaa !188
  %253 = getelementptr inbounds nuw i8, ptr %245, i64 10
  store i16 0, ptr %253, align 2, !tbaa !189
  br label %254

254:                                              ; preds = %242, %243
  %255 = add nsw i64 %202, 1
  %256 = add nuw nsw i64 %201, 2
  %257 = or disjoint i64 %256, 1
  %258 = icmp samesign ult i64 %257, %199
  br i1 %258, label %200, label %987, !llvm.loop !190

259:                                              ; preds = %135
  %260 = icmp slt i32 %141, 1
  br i1 %260, label %1000, label %324

261:                                              ; preds = %135
  %262 = icmp slt i32 %141, 1
  br i1 %262, label %1000, label %263

263:                                              ; preds = %261, %381
  %264 = phi i32 [ %384, %381 ], [ 0, %261 ]
  %265 = icmp slt i32 %264, %141
  br i1 %265, label %266, label %989

266:                                              ; preds = %263
  %267 = sext i32 %264 to i64
  %268 = getelementptr inbounds float, ptr %4, i64 %267
  %269 = load float, ptr %268, align 4, !tbaa !58
  %270 = load float, ptr %108, align 8, !tbaa !181
  %271 = fadd float %269, %270
  store float %271, ptr %108, align 8, !tbaa !181
  %272 = load float, ptr %109, align 4, !tbaa !182
  %273 = fadd float %272, 0.000000e+00
  store float %273, ptr %109, align 4, !tbaa !182
  %274 = fptosi float %271 to i32
  %275 = fptosi float %273 to i32
  %276 = load i32, ptr %2, align 8, !tbaa !180
  %277 = icmp eq i32 %276, 0
  br i1 %277, label %307, label %278

278:                                              ; preds = %266
  %279 = load i32, ptr %110, align 4, !tbaa !183
  %280 = icmp slt i32 %279, %274
  br i1 %280, label %284, label %281

281:                                              ; preds = %278
  %282 = load i32, ptr %111, align 4, !tbaa !184
  %283 = icmp eq i32 %282, 0
  br i1 %283, label %284, label %285

284:                                              ; preds = %281, %278
  store i32 %274, ptr %110, align 4, !tbaa !183
  br label %285

285:                                              ; preds = %284, %281
  %286 = load i32, ptr %112, align 4, !tbaa !185
  %287 = icmp slt i32 %286, %275
  br i1 %287, label %291, label %288

288:                                              ; preds = %285
  %289 = load i32, ptr %113, align 4, !tbaa !184
  %290 = icmp eq i32 %289, 0
  br i1 %290, label %291, label %292

291:                                              ; preds = %288, %285
  store i32 %275, ptr %112, align 4, !tbaa !185
  br label %292

292:                                              ; preds = %291, %288
  %293 = load i32, ptr %114, align 8, !tbaa !186
  %294 = icmp sgt i32 %293, %274
  br i1 %294, label %298, label %295

295:                                              ; preds = %292
  %296 = load i32, ptr %115, align 4, !tbaa !184
  %297 = icmp eq i32 %296, 0
  br i1 %297, label %298, label %299

298:                                              ; preds = %295, %292
  store i32 %274, ptr %114, align 8, !tbaa !186
  br label %299

299:                                              ; preds = %298, %295
  %300 = load i32, ptr %116, align 8, !tbaa !187
  %301 = icmp sgt i32 %300, %275
  br i1 %301, label %305, label %302

302:                                              ; preds = %299
  %303 = load i32, ptr %117, align 4, !tbaa !184
  %304 = icmp eq i32 %303, 0
  br i1 %304, label %305, label %306

305:                                              ; preds = %302, %299
  store i32 %275, ptr %116, align 8, !tbaa !187
  br label %306

306:                                              ; preds = %305, %302
  store i32 1, ptr %118, align 4, !tbaa !184
  br label %320

307:                                              ; preds = %266
  %308 = load ptr, ptr %119, align 8, !tbaa !29
  %309 = load i32, ptr %120, align 8, !tbaa !32
  %310 = sext i32 %309 to i64
  %311 = getelementptr inbounds %struct.stbtt_vertex, ptr %308, i64 %310
  %312 = getelementptr inbounds nuw i8, ptr %311, i64 12
  store i8 2, ptr %312, align 2, !tbaa !141
  %313 = trunc i32 %274 to i16
  store i16 %313, ptr %311, align 2, !tbaa !21
  %314 = trunc i32 %275 to i16
  %315 = getelementptr inbounds nuw i8, ptr %311, i64 2
  store i16 %314, ptr %315, align 2, !tbaa !24
  %316 = getelementptr inbounds nuw i8, ptr %311, i64 4
  store i16 0, ptr %316, align 2, !tbaa !25
  %317 = getelementptr inbounds nuw i8, ptr %311, i64 6
  store i16 0, ptr %317, align 2, !tbaa !26
  %318 = getelementptr inbounds nuw i8, ptr %311, i64 8
  store i16 0, ptr %318, align 2, !tbaa !188
  %319 = getelementptr inbounds nuw i8, ptr %311, i64 10
  store i16 0, ptr %319, align 2, !tbaa !189
  br label %320

320:                                              ; preds = %306, %307
  %321 = load i32, ptr %121, align 8, !tbaa !32
  %322 = add nsw i32 %321, 1
  store i32 %322, ptr %121, align 8, !tbaa !32
  %323 = add nsw i32 %264, 1
  br label %324

324:                                              ; preds = %259, %320
  %325 = phi i32 [ 0, %259 ], [ %323, %320 ]
  %326 = icmp slt i32 %325, %141
  br i1 %326, label %327, label %989

327:                                              ; preds = %324
  %328 = sext i32 %325 to i64
  %329 = getelementptr inbounds float, ptr %4, i64 %328
  %330 = load float, ptr %329, align 4, !tbaa !58
  %331 = load float, ptr %94, align 8, !tbaa !181
  %332 = fadd float %331, 0.000000e+00
  store float %332, ptr %94, align 8, !tbaa !181
  %333 = load float, ptr %95, align 4, !tbaa !182
  %334 = fadd float %330, %333
  store float %334, ptr %95, align 4, !tbaa !182
  %335 = fptosi float %332 to i32
  %336 = fptosi float %334 to i32
  %337 = load i32, ptr %2, align 8, !tbaa !180
  %338 = icmp eq i32 %337, 0
  br i1 %338, label %368, label %339

339:                                              ; preds = %327
  %340 = load i32, ptr %96, align 4, !tbaa !183
  %341 = icmp slt i32 %340, %335
  br i1 %341, label %345, label %342

342:                                              ; preds = %339
  %343 = load i32, ptr %97, align 4, !tbaa !184
  %344 = icmp eq i32 %343, 0
  br i1 %344, label %345, label %346

345:                                              ; preds = %342, %339
  store i32 %335, ptr %96, align 4, !tbaa !183
  br label %346

346:                                              ; preds = %345, %342
  %347 = load i32, ptr %98, align 4, !tbaa !185
  %348 = icmp slt i32 %347, %336
  br i1 %348, label %352, label %349

349:                                              ; preds = %346
  %350 = load i32, ptr %99, align 4, !tbaa !184
  %351 = icmp eq i32 %350, 0
  br i1 %351, label %352, label %353

352:                                              ; preds = %349, %346
  store i32 %336, ptr %98, align 4, !tbaa !185
  br label %353

353:                                              ; preds = %352, %349
  %354 = load i32, ptr %100, align 8, !tbaa !186
  %355 = icmp sgt i32 %354, %335
  br i1 %355, label %359, label %356

356:                                              ; preds = %353
  %357 = load i32, ptr %101, align 4, !tbaa !184
  %358 = icmp eq i32 %357, 0
  br i1 %358, label %359, label %360

359:                                              ; preds = %356, %353
  store i32 %335, ptr %100, align 8, !tbaa !186
  br label %360

360:                                              ; preds = %359, %356
  %361 = load i32, ptr %102, align 8, !tbaa !187
  %362 = icmp sgt i32 %361, %336
  br i1 %362, label %366, label %363

363:                                              ; preds = %360
  %364 = load i32, ptr %103, align 4, !tbaa !184
  %365 = icmp eq i32 %364, 0
  br i1 %365, label %366, label %367

366:                                              ; preds = %363, %360
  store i32 %336, ptr %102, align 8, !tbaa !187
  br label %367

367:                                              ; preds = %366, %363
  store i32 1, ptr %104, align 4, !tbaa !184
  br label %381

368:                                              ; preds = %327
  %369 = load ptr, ptr %105, align 8, !tbaa !29
  %370 = load i32, ptr %106, align 8, !tbaa !32
  %371 = sext i32 %370 to i64
  %372 = getelementptr inbounds %struct.stbtt_vertex, ptr %369, i64 %371
  %373 = getelementptr inbounds nuw i8, ptr %372, i64 12
  store i8 2, ptr %373, align 2, !tbaa !141
  %374 = trunc i32 %335 to i16
  store i16 %374, ptr %372, align 2, !tbaa !21
  %375 = trunc i32 %336 to i16
  %376 = getelementptr inbounds nuw i8, ptr %372, i64 2
  store i16 %375, ptr %376, align 2, !tbaa !24
  %377 = getelementptr inbounds nuw i8, ptr %372, i64 4
  store i16 0, ptr %377, align 2, !tbaa !25
  %378 = getelementptr inbounds nuw i8, ptr %372, i64 6
  store i16 0, ptr %378, align 2, !tbaa !26
  %379 = getelementptr inbounds nuw i8, ptr %372, i64 8
  store i16 0, ptr %379, align 2, !tbaa !188
  %380 = getelementptr inbounds nuw i8, ptr %372, i64 10
  store i16 0, ptr %380, align 2, !tbaa !189
  br label %381

381:                                              ; preds = %367, %368
  %382 = load i32, ptr %107, align 8, !tbaa !32
  %383 = add nsw i32 %382, 1
  store i32 %383, ptr %107, align 8, !tbaa !32
  %384 = add nsw i32 %325, 1
  br label %263, !llvm.loop !191

385:                                              ; preds = %135
  %386 = icmp slt i32 %141, 4
  br i1 %386, label %1000, label %412

387:                                              ; preds = %135
  %388 = icmp slt i32 %141, 4
  br i1 %388, label %1000, label %389

389:                                              ; preds = %387, %429
  %390 = phi i32 [ %434, %429 ], [ 0, %387 ]
  %391 = add nsw i32 %390, 3
  %392 = icmp slt i32 %391, %141
  br i1 %392, label %393, label %989

393:                                              ; preds = %389
  %394 = sext i32 %390 to i64
  %395 = getelementptr inbounds float, ptr %4, i64 %394
  %396 = load float, ptr %395, align 4, !tbaa !58
  %397 = getelementptr i8, ptr %395, i64 4
  %398 = load float, ptr %397, align 4, !tbaa !58
  %399 = getelementptr i8, ptr %395, i64 8
  %400 = load float, ptr %399, align 4, !tbaa !58
  %401 = sext i32 %391 to i64
  %402 = getelementptr inbounds float, ptr %4, i64 %401
  %403 = load float, ptr %402, align 4, !tbaa !58
  %404 = sub nsw i32 %141, %390
  %405 = icmp eq i32 %404, 5
  br i1 %405, label %406, label %409

406:                                              ; preds = %393
  %407 = getelementptr i8, ptr %395, i64 16
  %408 = load float, ptr %407, align 4, !tbaa !58
  br label %409

409:                                              ; preds = %393, %406
  %410 = phi float [ %408, %406 ], [ 0.000000e+00, %393 ]
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef 0.000000e+00, float noundef %396, float noundef %398, float noundef %400, float noundef %403, float noundef %410) #25
  %411 = add nsw i32 %390, 4
  br label %412

412:                                              ; preds = %385, %409
  %413 = phi i32 [ 0, %385 ], [ %411, %409 ]
  %414 = add nsw i32 %413, 3
  %415 = icmp slt i32 %414, %141
  br i1 %415, label %416, label %989

416:                                              ; preds = %412
  %417 = sext i32 %413 to i64
  %418 = getelementptr inbounds float, ptr %4, i64 %417
  %419 = load float, ptr %418, align 4, !tbaa !58
  %420 = getelementptr i8, ptr %418, i64 4
  %421 = load float, ptr %420, align 4, !tbaa !58
  %422 = getelementptr i8, ptr %418, i64 8
  %423 = load float, ptr %422, align 4, !tbaa !58
  %424 = sub nsw i32 %141, %413
  %425 = icmp eq i32 %424, 5
  br i1 %425, label %426, label %429

426:                                              ; preds = %416
  %427 = getelementptr i8, ptr %418, i64 16
  %428 = load float, ptr %427, align 4, !tbaa !58
  br label %429

429:                                              ; preds = %416, %426
  %430 = phi float [ %428, %426 ], [ 0.000000e+00, %416 ]
  %431 = sext i32 %414 to i64
  %432 = getelementptr inbounds float, ptr %4, i64 %431
  %433 = load float, ptr %432, align 4, !tbaa !58
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %419, float noundef 0.000000e+00, float noundef %421, float noundef %423, float noundef %430, float noundef %433) #25
  %434 = add nsw i32 %413, 4
  br label %389, !llvm.loop !192

435:                                              ; preds = %135
  %436 = icmp slt i32 %141, 6
  br i1 %436, label %1000, label %437

437:                                              ; preds = %435
  %438 = zext nneg i32 %141 to i64
  br label %439

439:                                              ; preds = %437, %439
  %440 = phi i64 [ 0, %437 ], [ %454, %439 ]
  %441 = getelementptr inbounds nuw float, ptr %4, i64 %440
  %442 = load float, ptr %441, align 8, !tbaa !58
  %443 = getelementptr inbounds nuw i8, ptr %441, i64 4
  %444 = load float, ptr %443, align 4, !tbaa !58
  %445 = getelementptr inbounds nuw i8, ptr %441, i64 8
  %446 = load float, ptr %445, align 8, !tbaa !58
  %447 = getelementptr inbounds nuw i8, ptr %441, i64 12
  %448 = load float, ptr %447, align 4, !tbaa !58
  %449 = getelementptr inbounds nuw i8, ptr %441, i64 16
  %450 = load float, ptr %449, align 8, !tbaa !58
  %451 = getelementptr inbounds nuw float, ptr %4, i64 %440
  %452 = getelementptr inbounds nuw i8, ptr %451, i64 20
  %453 = load float, ptr %452, align 4, !tbaa !58
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %442, float noundef %444, float noundef %446, float noundef %448, float noundef %450, float noundef %453) #25
  %454 = add nuw nsw i64 %440, 6
  %455 = add nuw nsw i64 %440, 11
  %456 = icmp samesign ult i64 %455, %438
  br i1 %456, label %439, label %989, !llvm.loop !193

457:                                              ; preds = %135
  %458 = icmp slt i32 %141, 8
  br i1 %458, label %1000, label %459

459:                                              ; preds = %457
  %460 = add nsw i32 %141, -2
  %461 = zext nneg i32 %460 to i64
  br label %462

462:                                              ; preds = %459, %462
  %463 = phi i64 [ 0, %459 ], [ %477, %462 ]
  %464 = getelementptr inbounds nuw float, ptr %4, i64 %463
  %465 = load float, ptr %464, align 8, !tbaa !58
  %466 = getelementptr inbounds nuw i8, ptr %464, i64 4
  %467 = load float, ptr %466, align 4, !tbaa !58
  %468 = getelementptr inbounds nuw i8, ptr %464, i64 8
  %469 = load float, ptr %468, align 8, !tbaa !58
  %470 = getelementptr inbounds nuw i8, ptr %464, i64 12
  %471 = load float, ptr %470, align 4, !tbaa !58
  %472 = getelementptr inbounds nuw i8, ptr %464, i64 16
  %473 = load float, ptr %472, align 8, !tbaa !58
  %474 = getelementptr inbounds nuw float, ptr %4, i64 %463
  %475 = getelementptr inbounds nuw i8, ptr %474, i64 20
  %476 = load float, ptr %475, align 4, !tbaa !58
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %465, float noundef %467, float noundef %469, float noundef %471, float noundef %473, float noundef %476) #25
  %477 = add nuw nsw i64 %463, 6
  %478 = add nuw nsw i64 %463, 11
  %479 = icmp samesign ult i64 %478, %461
  br i1 %479, label %462, label %480, !llvm.loop !194

480:                                              ; preds = %462
  %481 = trunc nuw nsw i64 %477 to i32
  %482 = or disjoint i32 %481, 1
  %483 = icmp slt i32 %482, %141
  br i1 %483, label %484, label %1000

484:                                              ; preds = %480
  %485 = and i64 %477, 4294967294
  %486 = getelementptr inbounds nuw float, ptr %4, i64 %485
  %487 = load float, ptr %486, align 8, !tbaa !58
  %488 = zext nneg i32 %482 to i64
  %489 = getelementptr inbounds nuw float, ptr %4, i64 %488
  %490 = load float, ptr %489, align 4, !tbaa !58
  %491 = load float, ptr %80, align 8, !tbaa !181
  %492 = fadd float %487, %491
  store float %492, ptr %80, align 8, !tbaa !181
  %493 = load float, ptr %81, align 4, !tbaa !182
  %494 = fadd float %490, %493
  store float %494, ptr %81, align 4, !tbaa !182
  %495 = fptosi float %492 to i32
  %496 = fptosi float %494 to i32
  %497 = load i32, ptr %2, align 8, !tbaa !180
  %498 = icmp eq i32 %497, 0
  br i1 %498, label %528, label %499

499:                                              ; preds = %484
  %500 = load i32, ptr %82, align 4, !tbaa !183
  %501 = icmp slt i32 %500, %495
  br i1 %501, label %505, label %502

502:                                              ; preds = %499
  %503 = load i32, ptr %83, align 4, !tbaa !184
  %504 = icmp eq i32 %503, 0
  br i1 %504, label %505, label %506

505:                                              ; preds = %502, %499
  store i32 %495, ptr %82, align 4, !tbaa !183
  br label %506

506:                                              ; preds = %505, %502
  %507 = load i32, ptr %84, align 4, !tbaa !185
  %508 = icmp slt i32 %507, %496
  br i1 %508, label %512, label %509

509:                                              ; preds = %506
  %510 = load i32, ptr %85, align 4, !tbaa !184
  %511 = icmp eq i32 %510, 0
  br i1 %511, label %512, label %513

512:                                              ; preds = %509, %506
  store i32 %496, ptr %84, align 4, !tbaa !185
  br label %513

513:                                              ; preds = %512, %509
  %514 = load i32, ptr %86, align 8, !tbaa !186
  %515 = icmp sgt i32 %514, %495
  br i1 %515, label %519, label %516

516:                                              ; preds = %513
  %517 = load i32, ptr %87, align 4, !tbaa !184
  %518 = icmp eq i32 %517, 0
  br i1 %518, label %519, label %520

519:                                              ; preds = %516, %513
  store i32 %495, ptr %86, align 8, !tbaa !186
  br label %520

520:                                              ; preds = %519, %516
  %521 = load i32, ptr %88, align 8, !tbaa !187
  %522 = icmp sgt i32 %521, %496
  br i1 %522, label %526, label %523

523:                                              ; preds = %520
  %524 = load i32, ptr %89, align 4, !tbaa !184
  %525 = icmp eq i32 %524, 0
  br i1 %525, label %526, label %527

526:                                              ; preds = %523, %520
  store i32 %496, ptr %88, align 8, !tbaa !187
  br label %527

527:                                              ; preds = %526, %523
  store i32 1, ptr %90, align 4, !tbaa !184
  br label %541

528:                                              ; preds = %484
  %529 = load ptr, ptr %91, align 8, !tbaa !29
  %530 = load i32, ptr %92, align 8, !tbaa !32
  %531 = sext i32 %530 to i64
  %532 = getelementptr inbounds %struct.stbtt_vertex, ptr %529, i64 %531
  %533 = getelementptr inbounds nuw i8, ptr %532, i64 12
  store i8 2, ptr %533, align 2, !tbaa !141
  %534 = trunc i32 %495 to i16
  store i16 %534, ptr %532, align 2, !tbaa !21
  %535 = trunc i32 %496 to i16
  %536 = getelementptr inbounds nuw i8, ptr %532, i64 2
  store i16 %535, ptr %536, align 2, !tbaa !24
  %537 = getelementptr inbounds nuw i8, ptr %532, i64 4
  store i16 0, ptr %537, align 2, !tbaa !25
  %538 = getelementptr inbounds nuw i8, ptr %532, i64 6
  store i16 0, ptr %538, align 2, !tbaa !26
  %539 = getelementptr inbounds nuw i8, ptr %532, i64 8
  store i16 0, ptr %539, align 2, !tbaa !188
  %540 = getelementptr inbounds nuw i8, ptr %532, i64 10
  store i16 0, ptr %540, align 2, !tbaa !189
  br label %541

541:                                              ; preds = %527, %528
  %542 = load i32, ptr %93, align 8, !tbaa !32
  %543 = add nsw i32 %542, 1
  store i32 %543, ptr %93, align 8, !tbaa !32
  br label %989

544:                                              ; preds = %135
  %545 = icmp slt i32 %141, 8
  br i1 %545, label %1000, label %546

546:                                              ; preds = %544
  %547 = add nsw i32 %141, -6
  %548 = load i32, ptr %2, align 8, !tbaa !180
  %549 = icmp eq i32 %548, 0
  %550 = load float, ptr %67, align 8, !tbaa !181
  %551 = load float, ptr %68, align 4, !tbaa !182
  %552 = load i32, ptr %79, align 8, !tbaa !32
  %553 = sext i32 %552 to i64
  %554 = zext nneg i32 %547 to i64
  br label %555

555:                                              ; preds = %546, %609
  %556 = phi i64 [ 0, %546 ], [ %611, %609 ]
  %557 = phi i64 [ %553, %546 ], [ %610, %609 ]
  %558 = phi float [ %551, %546 ], [ %566, %609 ]
  %559 = phi float [ %550, %546 ], [ %565, %609 ]
  %560 = getelementptr inbounds nuw float, ptr %4, i64 %556
  %561 = load float, ptr %560, align 8, !tbaa !58
  %562 = getelementptr inbounds nuw float, ptr %4, i64 %556
  %563 = getelementptr inbounds nuw i8, ptr %562, i64 4
  %564 = load float, ptr %563, align 4, !tbaa !58
  %565 = fadd float %561, %559
  %566 = fadd float %564, %558
  %567 = fptosi float %565 to i32
  %568 = fptosi float %566 to i32
  br i1 %549, label %598, label %569

569:                                              ; preds = %555
  %570 = load i32, ptr %69, align 4, !tbaa !183
  %571 = icmp slt i32 %570, %567
  br i1 %571, label %575, label %572

572:                                              ; preds = %569
  %573 = load i32, ptr %70, align 4, !tbaa !184
  %574 = icmp eq i32 %573, 0
  br i1 %574, label %575, label %576

575:                                              ; preds = %572, %569
  store i32 %567, ptr %69, align 4, !tbaa !183
  br label %576

576:                                              ; preds = %575, %572
  %577 = load i32, ptr %71, align 4, !tbaa !185
  %578 = icmp slt i32 %577, %568
  br i1 %578, label %582, label %579

579:                                              ; preds = %576
  %580 = load i32, ptr %72, align 4, !tbaa !184
  %581 = icmp eq i32 %580, 0
  br i1 %581, label %582, label %583

582:                                              ; preds = %579, %576
  store i32 %568, ptr %71, align 4, !tbaa !185
  br label %583

583:                                              ; preds = %582, %579
  %584 = load i32, ptr %73, align 8, !tbaa !186
  %585 = icmp sgt i32 %584, %567
  br i1 %585, label %589, label %586

586:                                              ; preds = %583
  %587 = load i32, ptr %74, align 4, !tbaa !184
  %588 = icmp eq i32 %587, 0
  br i1 %588, label %589, label %590

589:                                              ; preds = %586, %583
  store i32 %567, ptr %73, align 8, !tbaa !186
  br label %590

590:                                              ; preds = %589, %586
  %591 = load i32, ptr %75, align 8, !tbaa !187
  %592 = icmp sgt i32 %591, %568
  br i1 %592, label %596, label %593

593:                                              ; preds = %590
  %594 = load i32, ptr %76, align 4, !tbaa !184
  %595 = icmp eq i32 %594, 0
  br i1 %595, label %596, label %597

596:                                              ; preds = %593, %590
  store i32 %568, ptr %75, align 8, !tbaa !187
  br label %597

597:                                              ; preds = %596, %593
  store i32 1, ptr %77, align 4, !tbaa !184
  br label %609

598:                                              ; preds = %555
  %599 = load ptr, ptr %78, align 8, !tbaa !29
  %600 = getelementptr inbounds %struct.stbtt_vertex, ptr %599, i64 %557
  %601 = getelementptr inbounds nuw i8, ptr %600, i64 12
  store i8 2, ptr %601, align 2, !tbaa !141
  %602 = trunc i32 %567 to i16
  store i16 %602, ptr %600, align 2, !tbaa !21
  %603 = trunc i32 %568 to i16
  %604 = getelementptr inbounds nuw i8, ptr %600, i64 2
  store i16 %603, ptr %604, align 2, !tbaa !24
  %605 = getelementptr inbounds nuw i8, ptr %600, i64 4
  store i16 0, ptr %605, align 2, !tbaa !25
  %606 = getelementptr inbounds nuw i8, ptr %600, i64 6
  store i16 0, ptr %606, align 2, !tbaa !26
  %607 = getelementptr inbounds nuw i8, ptr %600, i64 8
  store i16 0, ptr %607, align 2, !tbaa !188
  %608 = getelementptr inbounds nuw i8, ptr %600, i64 10
  store i16 0, ptr %608, align 2, !tbaa !189
  br label %609

609:                                              ; preds = %597, %598
  %610 = add nsw i64 %557, 1
  %611 = add nuw nsw i64 %556, 2
  %612 = or disjoint i64 %611, 1
  %613 = icmp samesign ult i64 %612, %554
  br i1 %613, label %555, label %614, !llvm.loop !195

614:                                              ; preds = %609
  %615 = trunc nsw i64 %610 to i32
  store float %565, ptr %67, align 8, !tbaa !181
  store float %566, ptr %68, align 4, !tbaa !182
  store i32 %615, ptr %79, align 8, !tbaa !32
  %616 = trunc nuw nsw i64 %611 to i32
  %617 = add nuw nsw i32 %616, 5
  %618 = icmp slt i32 %617, %141
  br i1 %618, label %619, label %1000

619:                                              ; preds = %614
  %620 = and i64 %612, 4294967295
  %621 = and i64 %611, 4294967294
  %622 = getelementptr inbounds nuw float, ptr %4, i64 %621
  %623 = load float, ptr %622, align 8, !tbaa !58
  %624 = getelementptr inbounds nuw float, ptr %4, i64 %620
  %625 = load float, ptr %624, align 4, !tbaa !58
  %626 = getelementptr inbounds nuw i8, ptr %622, i64 8
  %627 = load float, ptr %626, align 8, !tbaa !58
  %628 = getelementptr inbounds nuw i8, ptr %622, i64 12
  %629 = load float, ptr %628, align 4, !tbaa !58
  %630 = getelementptr inbounds nuw i8, ptr %622, i64 16
  %631 = load float, ptr %630, align 8, !tbaa !58
  %632 = zext nneg i32 %617 to i64
  %633 = getelementptr inbounds nuw float, ptr %4, i64 %632
  %634 = load float, ptr %633, align 4, !tbaa !58
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %623, float noundef %625, float noundef %627, float noundef %629, float noundef %631, float noundef %634) #25
  br label %989

635:                                              ; preds = %135, %135
  %636 = icmp slt i32 %141, 4
  br i1 %636, label %1000, label %637

637:                                              ; preds = %635
  %638 = and i32 %141, 1
  %639 = add nuw nsw i32 %638, 3
  %640 = icmp slt i32 %639, %141
  br i1 %640, label %641, label %989

641:                                              ; preds = %637
  %642 = icmp eq i32 %638, 0
  %643 = load float, ptr %4, align 16
  %644 = select i1 %642, float 0.000000e+00, float %643
  %645 = icmp eq i8 %149, 27
  %646 = and i32 %141, 1
  %647 = zext nneg i32 %646 to i64
  br label %648

648:                                              ; preds = %641, %663
  %649 = phi i64 [ %647, %641 ], [ %664, %663 ]
  %650 = phi i32 [ %639, %641 ], [ %668, %663 ]
  %651 = phi float [ %644, %641 ], [ 0.000000e+00, %663 ]
  %652 = getelementptr inbounds nuw float, ptr %4, i64 %649
  %653 = load float, ptr %652, align 4, !tbaa !58
  %654 = getelementptr inbounds nuw i8, ptr %652, i64 4
  %655 = load float, ptr %654, align 4, !tbaa !58
  %656 = getelementptr inbounds nuw i8, ptr %652, i64 8
  %657 = load float, ptr %656, align 4, !tbaa !58
  %658 = zext nneg i32 %650 to i64
  %659 = getelementptr inbounds nuw float, ptr %4, i64 %658
  %660 = load float, ptr %659, align 4, !tbaa !58
  br i1 %645, label %661, label %662

661:                                              ; preds = %648
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %653, float noundef %651, float noundef %655, float noundef %657, float noundef %660, float noundef 0.000000e+00) #25
  br label %663

662:                                              ; preds = %648
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %651, float noundef %653, float noundef %655, float noundef %657, float noundef 0.000000e+00, float noundef %660) #25
  br label %663

663:                                              ; preds = %662, %661
  %664 = add nuw nsw i64 %649, 4
  %665 = add nuw nsw i64 %649, 7
  %666 = trunc nuw i64 %665 to i32
  %667 = icmp sgt i32 %141, %666
  %668 = trunc nuw i64 %665 to i32
  br i1 %667, label %648, label %989, !llvm.loop !196

669:                                              ; preds = %135
  %670 = icmp eq i32 %142, 0
  br i1 %670, label %671, label %785

671:                                              ; preds = %669
  %672 = load i32, ptr %59, align 4, !tbaa !197
  %673 = icmp eq i32 %672, 0
  br i1 %673, label %785, label %674

674:                                              ; preds = %671
  %675 = load ptr, ptr %60, align 8, !tbaa !57
  %676 = tail call i32 @llvm.smin.i32(i32 %672, i32 0)
  %677 = icmp sgt i32 %672, 0
  br i1 %677, label %678, label %682

678:                                              ; preds = %674
  %679 = zext nneg i32 %676 to i64
  %680 = getelementptr inbounds nuw i8, ptr %675, i64 %679
  %681 = load i8, ptr %680, align 1, !tbaa !14
  br label %682

682:                                              ; preds = %678, %674
  %683 = phi i32 [ 1, %678 ], [ %676, %674 ]
  %684 = phi i8 [ %681, %678 ], [ 0, %674 ]
  switch i8 %684, label %773 [
    i8 0, label %685
    i8 3, label %696
  ]

685:                                              ; preds = %682
  %686 = add nsw i32 %683, %1
  %687 = icmp slt i32 %686, 0
  %688 = tail call i32 @llvm.smin.i32(i32 %686, i32 %672)
  %689 = select i1 %687, i32 %672, i32 %688
  %690 = icmp slt i32 %689, %672
  br i1 %690, label %691, label %773

691:                                              ; preds = %685
  %692 = sext i32 %689 to i64
  %693 = getelementptr inbounds i8, ptr %675, i64 %692
  %694 = load i8, ptr %693, align 1, !tbaa !14
  %695 = zext i8 %694 to i32
  br label %773

696:                                              ; preds = %682, %710
  %697 = phi i32 [ %711, %710 ], [ %683, %682 ]
  %698 = phi i32 [ %712, %710 ], [ %683, %682 ]
  %699 = phi i1 [ true, %710 ], [ false, %682 ]
  %700 = phi i32 [ %713, %710 ], [ 0, %682 ]
  %701 = shl i32 %700, 8
  %702 = icmp slt i32 %698, %672
  br i1 %702, label %703, label %710

703:                                              ; preds = %696
  %704 = add nsw i32 %698, 1
  %705 = sext i32 %698 to i64
  %706 = getelementptr inbounds i8, ptr %675, i64 %705
  %707 = load i8, ptr %706, align 1, !tbaa !14
  %708 = zext i8 %707 to i32
  %709 = or disjoint i32 %701, %708
  br label %710

710:                                              ; preds = %703, %696
  %711 = phi i32 [ %704, %703 ], [ %697, %696 ]
  %712 = phi i32 [ %704, %703 ], [ %698, %696 ]
  %713 = phi i32 [ %709, %703 ], [ %701, %696 ]
  br i1 %699, label %714, label %696, !llvm.loop !139

714:                                              ; preds = %710, %728
  %715 = phi i32 [ %729, %728 ], [ %711, %710 ]
  %716 = phi i32 [ %730, %728 ], [ %711, %710 ]
  %717 = phi i1 [ true, %728 ], [ false, %710 ]
  %718 = phi i32 [ %731, %728 ], [ 0, %710 ]
  %719 = shl i32 %718, 8
  %720 = icmp slt i32 %716, %672
  br i1 %720, label %721, label %728

721:                                              ; preds = %714
  %722 = add nsw i32 %716, 1
  %723 = sext i32 %716 to i64
  %724 = getelementptr inbounds i8, ptr %675, i64 %723
  %725 = load i8, ptr %724, align 1, !tbaa !14
  %726 = zext i8 %725 to i32
  %727 = or disjoint i32 %719, %726
  br label %728

728:                                              ; preds = %721, %714
  %729 = phi i32 [ %722, %721 ], [ %715, %714 ]
  %730 = phi i32 [ %722, %721 ], [ %716, %714 ]
  %731 = phi i32 [ %727, %721 ], [ %719, %714 ]
  br i1 %717, label %732, label %714, !llvm.loop !139

732:                                              ; preds = %728
  %733 = icmp sgt i32 %713, 0
  br i1 %733, label %737, label %773

734:                                              ; preds = %769
  %735 = add nuw nsw i32 %739, 1
  %736 = icmp eq i32 %735, %713
  br i1 %736, label %773, label %737, !llvm.loop !198

737:                                              ; preds = %732, %734
  %738 = phi i32 [ %768, %734 ], [ %731, %732 ]
  %739 = phi i32 [ %735, %734 ], [ 0, %732 ]
  %740 = phi i32 [ %766, %734 ], [ %729, %732 ]
  %741 = icmp slt i32 %740, %672
  br i1 %741, label %742, label %748

742:                                              ; preds = %737
  %743 = add nsw i32 %740, 1
  %744 = sext i32 %740 to i64
  %745 = getelementptr inbounds i8, ptr %675, i64 %744
  %746 = load i8, ptr %745, align 1, !tbaa !14
  %747 = zext i8 %746 to i32
  br label %748

748:                                              ; preds = %742, %737
  %749 = phi i32 [ %743, %742 ], [ %740, %737 ]
  %750 = phi i32 [ %747, %742 ], [ 0, %737 ]
  br label %751

751:                                              ; preds = %765, %748
  %752 = phi i32 [ %749, %748 ], [ %766, %765 ]
  %753 = phi i32 [ %749, %748 ], [ %767, %765 ]
  %754 = phi i1 [ false, %748 ], [ true, %765 ]
  %755 = phi i32 [ 0, %748 ], [ %768, %765 ]
  %756 = shl i32 %755, 8
  %757 = icmp slt i32 %753, %672
  br i1 %757, label %758, label %765

758:                                              ; preds = %751
  %759 = add nsw i32 %753, 1
  %760 = sext i32 %753 to i64
  %761 = getelementptr inbounds i8, ptr %675, i64 %760
  %762 = load i8, ptr %761, align 1, !tbaa !14
  %763 = zext i8 %762 to i32
  %764 = or disjoint i32 %756, %763
  br label %765

765:                                              ; preds = %758, %751
  %766 = phi i32 [ %759, %758 ], [ %752, %751 ]
  %767 = phi i32 [ %759, %758 ], [ %753, %751 ]
  %768 = phi i32 [ %764, %758 ], [ %756, %751 ]
  br i1 %754, label %769, label %751, !llvm.loop !139

769:                                              ; preds = %765
  %770 = icmp sge i32 %1, %738
  %771 = icmp slt i32 %1, %768
  %772 = select i1 %770, i1 %771, i1 false
  br i1 %772, label %773, label %734

773:                                              ; preds = %734, %769, %682, %685, %691, %732
  %774 = phi i32 [ %695, %691 ], [ -1, %682 ], [ 0, %685 ], [ -1, %732 ], [ %750, %769 ], [ -1, %734 ]
  %775 = load ptr, ptr %62, align 8
  %776 = load i64, ptr %63, align 8
  %777 = tail call fastcc { ptr, i64 } @stbtt__cff_index_get(ptr %775, i64 %776, i32 noundef %774) #25
  %778 = extractvalue { ptr, i64 } %777, 0
  %779 = extractvalue { ptr, i64 } %777, 1
  %780 = load ptr, ptr %61, align 8
  %781 = load i64, ptr %64, align 8
  %782 = tail call fastcc { ptr, i64 } @stbtt__get_subrs(ptr %780, i64 %781, ptr %778, i64 %779) #25
  %783 = extractvalue { ptr, i64 } %782, 0
  %784 = extractvalue { ptr, i64 } %782, 1
  br label %785

785:                                              ; preds = %671, %773, %669, %135
  %786 = phi ptr [ %144, %669 ], [ %144, %135 ], [ %783, %773 ], [ %144, %671 ]
  %787 = phi i64 [ %143, %669 ], [ %143, %135 ], [ %784, %773 ], [ %143, %671 ]
  %788 = phi i32 [ 1, %669 ], [ %142, %135 ], [ 1, %773 ], [ 1, %671 ]
  %789 = icmp slt i32 %141, 1
  br i1 %789, label %1000, label %790

790:                                              ; preds = %785
  %791 = add nsw i32 %141, -1
  %792 = zext nneg i32 %791 to i64
  %793 = getelementptr inbounds nuw float, ptr %4, i64 %792
  %794 = load float, ptr %793, align 4, !tbaa !58
  %795 = fptosi float %794 to i32
  %796 = icmp sgt i32 %140, 9
  br i1 %796, label %1000, label %797

797:                                              ; preds = %790
  %798 = add nsw i32 %140, 1
  %799 = sext i32 %140 to i64
  %800 = getelementptr inbounds %struct.stbtt__buf, ptr %5, i64 %799
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %800, ptr noundef nonnull align 8 dereferenceable(16) %6, i64 16, i1 false), !tbaa.struct !199
  %801 = icmp eq i8 %149, 10
  br i1 %801, label %805, label %802

802:                                              ; preds = %797
  %803 = load ptr, ptr %65, align 8, !tbaa !57
  %804 = load i64, ptr %66, align 8
  br label %805

805:                                              ; preds = %797, %802
  %806 = phi i64 [ %804, %802 ], [ %787, %797 ]
  %807 = phi ptr [ %803, %802 ], [ %786, %797 ]
  %808 = lshr i64 %806, 32
  %809 = trunc nuw i64 %808 to i32
  %810 = tail call i32 @llvm.smin.i32(i32 %809, i32 0)
  br label %811

811:                                              ; preds = %825, %805
  %812 = phi i32 [ %810, %805 ], [ %826, %825 ]
  %813 = phi i32 [ %810, %805 ], [ %827, %825 ]
  %814 = phi i1 [ false, %805 ], [ true, %825 ]
  %815 = phi i32 [ 0, %805 ], [ %828, %825 ]
  %816 = shl i32 %815, 8
  %817 = icmp slt i32 %813, %809
  br i1 %817, label %818, label %825

818:                                              ; preds = %811
  %819 = add nsw i32 %813, 1
  %820 = sext i32 %813 to i64
  %821 = getelementptr inbounds i8, ptr %807, i64 %820
  %822 = load i8, ptr %821, align 1, !tbaa !14
  %823 = zext i8 %822 to i32
  %824 = or disjoint i32 %816, %823
  br label %825

825:                                              ; preds = %818, %811
  %826 = phi i32 [ %819, %818 ], [ %812, %811 ]
  %827 = phi i32 [ %819, %818 ], [ %813, %811 ]
  %828 = phi i32 [ %824, %818 ], [ %816, %811 ]
  br i1 %814, label %829, label %811, !llvm.loop !139

829:                                              ; preds = %825
  %830 = icmp sgt i32 %828, 33899
  %831 = icmp sgt i32 %828, 1239
  %832 = select i1 %831, i32 1131, i32 107
  %833 = select i1 %830, i32 32768, i32 %832
  %834 = add nsw i32 %833, %795
  %835 = icmp sgt i32 %834, -1
  %836 = icmp slt i32 %834, %828
  %837 = and i1 %835, %836
  br i1 %837, label %838, label %843

838:                                              ; preds = %829
  %839 = and i64 %806, -4294967296
  %840 = zext i32 %826 to i64
  %841 = or disjoint i64 %839, %840
  %842 = tail call fastcc { ptr, i64 } @stbtt__cff_index_get(ptr readonly %807, i64 %841, i32 noundef %834) #25
  br label %843

843:                                              ; preds = %829, %838
  %844 = phi { ptr, i64 } [ %842, %838 ], [ zeroinitializer, %829 ]
  %845 = extractvalue { ptr, i64 } %844, 0
  %846 = extractvalue { ptr, i64 } %844, 1
  store ptr %845, ptr %6, align 8, !tbaa !57
  store i64 %846, ptr %18, align 8
  %847 = load i32, ptr %19, align 4, !tbaa !178
  %848 = icmp eq i32 %847, 0
  br i1 %848, label %1000, label %849

849:                                              ; preds = %843
  store i32 0, ptr %18, align 8, !tbaa !177
  br label %989

850:                                              ; preds = %135
  %851 = icmp slt i32 %140, 1
  br i1 %851, label %1000, label %852

852:                                              ; preds = %850
  %853 = add nsw i32 %140, -1
  %854 = zext nneg i32 %853 to i64
  %855 = getelementptr inbounds nuw %struct.stbtt__buf, ptr %5, i64 %854
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %6, ptr noundef nonnull align 16 dereferenceable(16) %855, i64 16, i1 false), !tbaa.struct !199
  br label %989

856:                                              ; preds = %135
  tail call fastcc void @stbtt__csctx_close_shape(ptr noundef %2) #25
  br label %1000

857:                                              ; preds = %135
  %858 = load i32, ptr %18, align 8, !tbaa !177
  %859 = icmp slt i32 %858, %136
  br i1 %859, label %860, label %866

860:                                              ; preds = %857
  %861 = load ptr, ptr %6, align 8, !tbaa !179
  %862 = add nsw i32 %858, 1
  store i32 %862, ptr %18, align 8, !tbaa !177
  %863 = sext i32 %858 to i64
  %864 = getelementptr inbounds i8, ptr %861, i64 %863
  %865 = load i8, ptr %864, align 1, !tbaa !14
  br label %866

866:                                              ; preds = %857, %860
  %867 = phi i8 [ %865, %860 ], [ 0, %857 ]
  switch i8 %867, label %1000 [
    i8 34, label %868
    i8 35, label %879
    i8 36, label %894
    i8 37, label %909
  ]

868:                                              ; preds = %866
  %869 = icmp slt i32 %141, 7
  br i1 %869, label %1000, label %870

870:                                              ; preds = %868
  %871 = load float, ptr %4, align 16, !tbaa !58
  %872 = load float, ptr %53, align 4, !tbaa !58
  %873 = load float, ptr %54, align 8, !tbaa !58
  %874 = load float, ptr %55, align 4, !tbaa !58
  %875 = load float, ptr %56, align 16, !tbaa !58
  %876 = load float, ptr %57, align 4, !tbaa !58
  %877 = load float, ptr %58, align 8, !tbaa !58
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %871, float noundef 0.000000e+00, float noundef %872, float noundef %873, float noundef %874, float noundef 0.000000e+00) #25
  %878 = fneg float %873
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %875, float noundef 0.000000e+00, float noundef %876, float noundef %878, float noundef %877, float noundef 0.000000e+00) #25
  br label %989

879:                                              ; preds = %866
  %880 = icmp slt i32 %141, 13
  br i1 %880, label %1000, label %881

881:                                              ; preds = %879
  %882 = load float, ptr %4, align 16, !tbaa !58
  %883 = load float, ptr %42, align 4, !tbaa !58
  %884 = load float, ptr %43, align 8, !tbaa !58
  %885 = load float, ptr %44, align 4, !tbaa !58
  %886 = load float, ptr %45, align 16, !tbaa !58
  %887 = load float, ptr %46, align 4, !tbaa !58
  %888 = load float, ptr %47, align 8, !tbaa !58
  %889 = load float, ptr %48, align 4, !tbaa !58
  %890 = load float, ptr %49, align 16, !tbaa !58
  %891 = load float, ptr %50, align 4, !tbaa !58
  %892 = load float, ptr %51, align 8, !tbaa !58
  %893 = load float, ptr %52, align 4, !tbaa !58
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %882, float noundef %883, float noundef %884, float noundef %885, float noundef %886, float noundef %887) #25
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %888, float noundef %889, float noundef %890, float noundef %891, float noundef %892, float noundef %893) #25
  br label %989

894:                                              ; preds = %866
  %895 = icmp slt i32 %141, 9
  br i1 %895, label %1000, label %896

896:                                              ; preds = %894
  %897 = load float, ptr %4, align 16, !tbaa !58
  %898 = load float, ptr %34, align 4, !tbaa !58
  %899 = load float, ptr %35, align 8, !tbaa !58
  %900 = load float, ptr %36, align 4, !tbaa !58
  %901 = load float, ptr %37, align 16, !tbaa !58
  %902 = load float, ptr %38, align 4, !tbaa !58
  %903 = load float, ptr %39, align 8, !tbaa !58
  %904 = load float, ptr %40, align 4, !tbaa !58
  %905 = load float, ptr %41, align 16, !tbaa !58
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %897, float noundef %898, float noundef %899, float noundef %900, float noundef %901, float noundef 0.000000e+00) #25
  %906 = fadd float %898, %900
  %907 = fadd float %906, %904
  %908 = fneg float %907
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %902, float noundef 0.000000e+00, float noundef %903, float noundef %904, float noundef %905, float noundef %908) #25
  br label %989

909:                                              ; preds = %866
  %910 = icmp slt i32 %141, 11
  br i1 %910, label %1000, label %911

911:                                              ; preds = %909
  %912 = load float, ptr %4, align 16, !tbaa !58
  %913 = load float, ptr %24, align 4, !tbaa !58
  %914 = load float, ptr %25, align 8, !tbaa !58
  %915 = load float, ptr %26, align 4, !tbaa !58
  %916 = load float, ptr %27, align 16, !tbaa !58
  %917 = load float, ptr %28, align 4, !tbaa !58
  %918 = load float, ptr %29, align 8, !tbaa !58
  %919 = load float, ptr %30, align 4, !tbaa !58
  %920 = load float, ptr %31, align 16, !tbaa !58
  %921 = load float, ptr %32, align 4, !tbaa !58
  %922 = load float, ptr %33, align 8, !tbaa !58
  %923 = fadd float %912, %914
  %924 = fadd float %923, %916
  %925 = fadd float %924, %918
  %926 = fadd float %925, %920
  %927 = fadd float %913, %915
  %928 = fadd float %927, %917
  %929 = fadd float %928, %919
  %930 = fadd float %929, %921
  %931 = fpext float %926 to double
  %932 = tail call double @fabs(double noundef %931) #28
  %933 = fpext float %930 to double
  %934 = tail call double @fabs(double noundef %933) #28
  %935 = fcmp ogt double %932, %934
  %936 = fneg float %930
  %937 = fneg float %926
  %938 = select i1 %935, float %922, float %937
  %939 = select i1 %935, float %936, float %922
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %912, float noundef %913, float noundef %914, float noundef %915, float noundef %916, float noundef %917) #25
  tail call fastcc void @stbtt__csctx_rccurve_to(ptr noundef %2, float noundef %918, float noundef %919, float noundef %920, float noundef %921, float noundef %938, float noundef %939) #25
  br label %989

940:                                              ; preds = %135
  %941 = icmp ne i8 %149, 28
  %942 = icmp ult i8 %149, 32
  %943 = and i1 %942, %941
  br i1 %943, label %1000, label %944

944:                                              ; preds = %940
  %945 = icmp eq i8 %149, -1
  %946 = load i32, ptr %18, align 8, !tbaa !177
  br i1 %945, label %947, label %972

947:                                              ; preds = %944
  %948 = load ptr, ptr %6, align 8
  br label %949

949:                                              ; preds = %963, %947
  %950 = phi i32 [ %946, %947 ], [ %964, %963 ]
  %951 = phi i32 [ %946, %947 ], [ %965, %963 ]
  %952 = phi i32 [ 0, %947 ], [ %967, %963 ]
  %953 = phi i32 [ 0, %947 ], [ %966, %963 ]
  %954 = shl i32 %953, 8
  %955 = icmp slt i32 %951, %136
  br i1 %955, label %956, label %963

956:                                              ; preds = %949
  %957 = add nsw i32 %951, 1
  %958 = sext i32 %951 to i64
  %959 = getelementptr inbounds i8, ptr %948, i64 %958
  %960 = load i8, ptr %959, align 1, !tbaa !14
  %961 = zext i8 %960 to i32
  %962 = or disjoint i32 %954, %961
  br label %963

963:                                              ; preds = %956, %949
  %964 = phi i32 [ %957, %956 ], [ %950, %949 ]
  %965 = phi i32 [ %957, %956 ], [ %951, %949 ]
  %966 = phi i32 [ %962, %956 ], [ %954, %949 ]
  %967 = add nuw nsw i32 %952, 1
  %968 = icmp eq i32 %967, 4
  br i1 %968, label %969, label %949, !llvm.loop !139

969:                                              ; preds = %963
  store i32 %964, ptr %18, align 8
  %970 = sitofp i32 %966 to float
  %971 = fmul float %970, 0x3EF0000000000000
  br label %980

972:                                              ; preds = %944
  %973 = add nsw i32 %946, -1
  %974 = icmp slt i32 %946, 1
  %975 = tail call i32 @llvm.smin.i32(i32 %973, i32 %136)
  %976 = select i1 %974, i32 %136, i32 %975
  store i32 %976, ptr %18, align 8, !tbaa !177
  %977 = call fastcc i32 @stbtt__cff_int(ptr noundef %6) #25
  %978 = trunc i32 %977 to i16
  %979 = sitofp i16 %978 to float
  br label %980

980:                                              ; preds = %972, %969
  %981 = phi float [ %971, %969 ], [ %979, %972 ]
  %982 = icmp sgt i32 %141, 47
  br i1 %982, label %1000, label %983

983:                                              ; preds = %980
  %984 = add nsw i32 %141, 1
  %985 = sext i32 %141 to i64
  %986 = getelementptr inbounds float, ptr %4, i64 %985
  store float %981, ptr %986, align 4, !tbaa !58
  br label %989

987:                                              ; preds = %254
  %988 = trunc nsw i64 %255 to i32
  store float %210, ptr %122, align 8, !tbaa !181
  store float %211, ptr %123, align 4, !tbaa !182
  store i32 %988, ptr %134, align 8, !tbaa !32
  br label %989

989:                                              ; preds = %663, %439, %637, %987, %911, %896, %881, %870, %389, %412, %263, %324, %983, %852, %849, %619, %541, %185, %178, %169, %164, %155
  %990 = phi ptr [ %144, %983 ], [ %144, %155 ], [ %144, %164 ], [ %144, %169 ], [ %144, %178 ], [ %144, %185 ], [ %144, %911 ], [ %144, %324 ], [ %144, %263 ], [ %144, %412 ], [ %144, %389 ], [ %144, %987 ], [ %144, %541 ], [ %144, %619 ], [ %144, %637 ], [ %786, %849 ], [ %144, %852 ], [ %144, %870 ], [ %144, %881 ], [ %144, %896 ], [ %144, %439 ], [ %144, %663 ]
  %991 = phi i64 [ %143, %983 ], [ %143, %155 ], [ %143, %164 ], [ %143, %169 ], [ %143, %178 ], [ %143, %185 ], [ %143, %911 ], [ %143, %324 ], [ %143, %263 ], [ %143, %412 ], [ %143, %389 ], [ %143, %987 ], [ %143, %541 ], [ %143, %619 ], [ %143, %637 ], [ %787, %849 ], [ %143, %852 ], [ %143, %870 ], [ %143, %881 ], [ %143, %896 ], [ %143, %439 ], [ %143, %663 ]
  %992 = phi i32 [ %984, %983 ], [ 0, %155 ], [ 0, %164 ], [ 0, %169 ], [ 0, %178 ], [ 0, %185 ], [ 0, %911 ], [ 0, %324 ], [ 0, %263 ], [ 0, %412 ], [ 0, %389 ], [ 0, %987 ], [ 0, %541 ], [ 0, %619 ], [ 0, %637 ], [ %791, %849 ], [ %141, %852 ], [ 0, %870 ], [ 0, %881 ], [ 0, %896 ], [ 0, %439 ], [ 0, %663 ]
  %993 = phi i32 [ %142, %983 ], [ %142, %155 ], [ %142, %164 ], [ %142, %169 ], [ %142, %178 ], [ %142, %185 ], [ %142, %911 ], [ %142, %324 ], [ %142, %263 ], [ %142, %412 ], [ %142, %389 ], [ %142, %987 ], [ %142, %541 ], [ %142, %619 ], [ %142, %637 ], [ %788, %849 ], [ %142, %852 ], [ %142, %870 ], [ %142, %881 ], [ %142, %896 ], [ %142, %439 ], [ %142, %663 ]
  %994 = phi i32 [ %140, %983 ], [ %140, %155 ], [ %140, %164 ], [ %140, %169 ], [ %140, %178 ], [ %140, %185 ], [ %140, %911 ], [ %140, %324 ], [ %140, %263 ], [ %140, %412 ], [ %140, %389 ], [ %140, %987 ], [ %140, %541 ], [ %140, %619 ], [ %140, %637 ], [ %798, %849 ], [ %853, %852 ], [ %140, %870 ], [ %140, %881 ], [ %140, %896 ], [ %140, %439 ], [ %140, %663 ]
  %995 = phi i32 [ %139, %983 ], [ %156, %155 ], [ %166, %164 ], [ %139, %169 ], [ %139, %178 ], [ %139, %185 ], [ %139, %911 ], [ %139, %324 ], [ %139, %263 ], [ %139, %412 ], [ %139, %389 ], [ %139, %987 ], [ %139, %541 ], [ %139, %619 ], [ %139, %637 ], [ %139, %849 ], [ %139, %852 ], [ %139, %870 ], [ %139, %881 ], [ %139, %896 ], [ %139, %439 ], [ %139, %663 ]
  %996 = phi i32 [ %138, %983 ], [ 0, %155 ], [ %138, %164 ], [ 0, %169 ], [ 0, %178 ], [ 0, %185 ], [ %138, %911 ], [ %138, %324 ], [ %138, %263 ], [ %138, %412 ], [ %138, %389 ], [ %138, %987 ], [ %138, %541 ], [ %138, %619 ], [ %138, %637 ], [ %138, %849 ], [ %138, %852 ], [ %138, %870 ], [ %138, %881 ], [ %138, %896 ], [ %138, %439 ], [ %138, %663 ]
  %997 = load i32, ptr %18, align 8, !tbaa !177
  %998 = load i32, ptr %19, align 4, !tbaa !178
  %999 = icmp slt i32 %997, %998
  br i1 %999, label %135, label %1000, !llvm.loop !200

1000:                                             ; preds = %167, %176, %183, %190, %259, %261, %385, %387, %435, %457, %480, %544, %614, %635, %785, %790, %843, %850, %940, %980, %989, %879, %868, %866, %894, %909, %3, %856
  %1001 = phi i32 [ 1, %856 ], [ 0, %3 ], [ 0, %909 ], [ 0, %894 ], [ 0, %866 ], [ 0, %868 ], [ 0, %879 ], [ 0, %989 ], [ 0, %980 ], [ 0, %940 ], [ 0, %850 ], [ 0, %843 ], [ 0, %790 ], [ 0, %785 ], [ 0, %635 ], [ 0, %614 ], [ 0, %544 ], [ 0, %480 ], [ 0, %457 ], [ 0, %435 ], [ 0, %387 ], [ 0, %385 ], [ 0, %261 ], [ 0, %259 ], [ 0, %190 ], [ 0, %183 ], [ 0, %176 ], [ 0, %167 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %4) #26
  ret i32 %1001
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define internal fastcc { ptr, i64 } @stbtt__cff_index_get(ptr %0, i64 %1, i32 noundef %2) unnamed_addr #20 {
  %4 = lshr i64 %1, 32
  %5 = trunc nuw i64 %4 to i32
  %6 = tail call i32 @llvm.smin.i32(i32 %5, i32 0)
  br label %7

7:                                                ; preds = %21, %3
  %8 = phi i32 [ %6, %3 ], [ %22, %21 ]
  %9 = phi i32 [ %6, %3 ], [ %23, %21 ]
  %10 = phi i1 [ false, %3 ], [ true, %21 ]
  %11 = phi i32 [ 0, %3 ], [ %24, %21 ]
  %12 = shl i32 %11, 8
  %13 = icmp slt i32 %9, %5
  br i1 %13, label %14, label %21

14:                                               ; preds = %7
  %15 = add nsw i32 %9, 1
  %16 = sext i32 %9 to i64
  %17 = getelementptr inbounds i8, ptr %0, i64 %16
  %18 = load i8, ptr %17, align 1, !tbaa !14
  %19 = zext i8 %18 to i32
  %20 = or disjoint i32 %12, %19
  br label %21

21:                                               ; preds = %14, %7
  %22 = phi i32 [ %15, %14 ], [ %8, %7 ]
  %23 = phi i32 [ %15, %14 ], [ %9, %7 ]
  %24 = phi i32 [ %20, %14 ], [ %12, %7 ]
  br i1 %10, label %25, label %7, !llvm.loop !139

25:                                               ; preds = %21
  %26 = icmp slt i32 %22, %5
  br i1 %26, label %27, label %33

27:                                               ; preds = %25
  %28 = add nsw i32 %22, 1
  %29 = sext i32 %22 to i64
  %30 = getelementptr inbounds i8, ptr %0, i64 %29
  %31 = load i8, ptr %30, align 1, !tbaa !14
  %32 = zext i8 %31 to i32
  br label %33

33:                                               ; preds = %25, %27
  %34 = phi i32 [ %28, %27 ], [ %22, %25 ]
  %35 = phi i32 [ %32, %27 ], [ 0, %25 ]
  %36 = mul nsw i32 %35, %2
  %37 = add nsw i32 %36, %34
  %38 = icmp slt i32 %37, 0
  %39 = tail call i32 @llvm.smin.i32(i32 %37, i32 %5)
  %40 = select i1 %38, i32 %5, i32 %39
  %41 = icmp eq i32 %35, 0
  br i1 %41, label %62, label %42

42:                                               ; preds = %33, %56
  %43 = phi i32 [ %57, %56 ], [ %40, %33 ]
  %44 = phi i32 [ %58, %56 ], [ %40, %33 ]
  %45 = phi i32 [ %60, %56 ], [ 0, %33 ]
  %46 = phi i32 [ %59, %56 ], [ 0, %33 ]
  %47 = shl i32 %46, 8
  %48 = icmp slt i32 %44, %5
  br i1 %48, label %49, label %56

49:                                               ; preds = %42
  %50 = add nsw i32 %44, 1
  %51 = sext i32 %44 to i64
  %52 = getelementptr inbounds i8, ptr %0, i64 %51
  %53 = load i8, ptr %52, align 1, !tbaa !14
  %54 = zext i8 %53 to i32
  %55 = or disjoint i32 %47, %54
  br label %56

56:                                               ; preds = %49, %42
  %57 = phi i32 [ %50, %49 ], [ %43, %42 ]
  %58 = phi i32 [ %50, %49 ], [ %44, %42 ]
  %59 = phi i32 [ %55, %49 ], [ %47, %42 ]
  %60 = add nuw nsw i32 %45, 1
  %61 = icmp eq i32 %60, %35
  br i1 %61, label %62, label %42, !llvm.loop !139

62:                                               ; preds = %56, %33
  %63 = phi i32 [ %40, %33 ], [ %57, %56 ]
  %64 = phi i32 [ 0, %33 ], [ %59, %56 ]
  br i1 %41, label %83, label %65

65:                                               ; preds = %62, %78
  %66 = phi i32 [ %79, %78 ], [ %63, %62 ]
  %67 = phi i32 [ %81, %78 ], [ 0, %62 ]
  %68 = phi i32 [ %80, %78 ], [ 0, %62 ]
  %69 = shl i32 %68, 8
  %70 = icmp slt i32 %66, %5
  br i1 %70, label %71, label %78

71:                                               ; preds = %65
  %72 = add nsw i32 %66, 1
  %73 = sext i32 %66 to i64
  %74 = getelementptr inbounds i8, ptr %0, i64 %73
  %75 = load i8, ptr %74, align 1, !tbaa !14
  %76 = zext i8 %75 to i32
  %77 = or disjoint i32 %69, %76
  br label %78

78:                                               ; preds = %71, %65
  %79 = phi i32 [ %72, %71 ], [ %66, %65 ]
  %80 = phi i32 [ %77, %71 ], [ %69, %65 ]
  %81 = add nuw nsw i32 %67, 1
  %82 = icmp eq i32 %81, %35
  br i1 %82, label %83, label %65, !llvm.loop !139

83:                                               ; preds = %78, %62
  %84 = phi i32 [ 0, %62 ], [ %80, %78 ]
  %85 = add nsw i32 %24, 1
  %86 = mul nsw i32 %35, %85
  %87 = add nsw i32 %86, 2
  %88 = add nsw i32 %87, %64
  %89 = sub nsw i32 %84, %64
  %90 = or i32 %89, %88
  %91 = icmp sgt i32 %90, -1
  br i1 %91, label %92, label %102

92:                                               ; preds = %83
  %93 = icmp sgt i32 %88, %5
  %94 = sub nsw i32 %5, %88
  %95 = icmp sgt i32 %89, %94
  %96 = select i1 %93, i1 true, i1 %95
  br i1 %96, label %102, label %97

97:                                               ; preds = %92
  %98 = zext nneg i32 %88 to i64
  %99 = getelementptr inbounds nuw i8, ptr %0, i64 %98
  %100 = zext nneg i32 %89 to i64
  %101 = shl nuw nsw i64 %100, 32
  br label %102

102:                                              ; preds = %83, %92, %97
  %103 = phi ptr [ null, %83 ], [ null, %92 ], [ %99, %97 ]
  %104 = phi i64 [ 0, %83 ], [ 0, %92 ], [ %101, %97 ]
  %105 = insertvalue { ptr, i64 } poison, ptr %103, 0
  %106 = insertvalue { ptr, i64 } %105, i64 %104, 1
  ret { ptr, i64 } %106
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define internal fastcc void @stbtt__csctx_rmove_to(ptr noundef nonnull captures(none) %0, float noundef %1, float noundef %2) unnamed_addr #23 {
  tail call fastcc void @stbtt__csctx_close_shape(ptr noundef %0) #25
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %5 = load float, ptr %4, align 8, !tbaa !181
  %6 = fadd float %1, %5
  store float %6, ptr %4, align 8, !tbaa !181
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store float %6, ptr %7, align 8, !tbaa !201
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 20
  %9 = load float, ptr %8, align 4, !tbaa !182
  %10 = fadd float %2, %9
  store float %10, ptr %8, align 4, !tbaa !182
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 12
  store float %10, ptr %11, align 4, !tbaa !202
  %12 = fptosi float %6 to i32
  %13 = fptosi float %10 to i32
  %14 = load i32, ptr %0, align 8, !tbaa !180
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %54, label %16

16:                                               ; preds = %3
  %17 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %18 = load i32, ptr %17, align 4, !tbaa !183
  %19 = icmp slt i32 %18, %12
  br i1 %19, label %24, label %20

20:                                               ; preds = %16
  %21 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %22 = load i32, ptr %21, align 4, !tbaa !184
  %23 = icmp eq i32 %22, 0
  br i1 %23, label %24, label %25

24:                                               ; preds = %20, %16
  store i32 %12, ptr %17, align 4, !tbaa !183
  br label %25

25:                                               ; preds = %24, %20
  %26 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %27 = load i32, ptr %26, align 4, !tbaa !185
  %28 = icmp slt i32 %27, %13
  br i1 %28, label %33, label %29

29:                                               ; preds = %25
  %30 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %31 = load i32, ptr %30, align 4, !tbaa !184
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %33, label %34

33:                                               ; preds = %29, %25
  store i32 %13, ptr %26, align 4, !tbaa !185
  br label %34

34:                                               ; preds = %33, %29
  %35 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %36 = load i32, ptr %35, align 8, !tbaa !186
  %37 = icmp sgt i32 %36, %12
  br i1 %37, label %42, label %38

38:                                               ; preds = %34
  %39 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %40 = load i32, ptr %39, align 4, !tbaa !184
  %41 = icmp eq i32 %40, 0
  br i1 %41, label %42, label %43

42:                                               ; preds = %38, %34
  store i32 %12, ptr %35, align 8, !tbaa !186
  br label %43

43:                                               ; preds = %42, %38
  %44 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %45 = load i32, ptr %44, align 8, !tbaa !187
  %46 = icmp sgt i32 %45, %13
  br i1 %46, label %51, label %47

47:                                               ; preds = %43
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %49 = load i32, ptr %48, align 4, !tbaa !184
  %50 = icmp eq i32 %49, 0
  br i1 %50, label %51, label %52

51:                                               ; preds = %47, %43
  store i32 %13, ptr %44, align 8, !tbaa !187
  br label %52

52:                                               ; preds = %51, %47
  %53 = getelementptr inbounds nuw i8, ptr %0, i64 4
  store i32 1, ptr %53, align 4, !tbaa !184
  br label %69

54:                                               ; preds = %3
  %55 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %56 = load ptr, ptr %55, align 8, !tbaa !29
  %57 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %58 = load i32, ptr %57, align 8, !tbaa !32
  %59 = sext i32 %58 to i64
  %60 = getelementptr inbounds %struct.stbtt_vertex, ptr %56, i64 %59
  %61 = getelementptr inbounds nuw i8, ptr %60, i64 12
  store i8 1, ptr %61, align 2, !tbaa !141
  %62 = trunc i32 %12 to i16
  store i16 %62, ptr %60, align 2, !tbaa !21
  %63 = trunc i32 %13 to i16
  %64 = getelementptr inbounds nuw i8, ptr %60, i64 2
  store i16 %63, ptr %64, align 2, !tbaa !24
  %65 = getelementptr inbounds nuw i8, ptr %60, i64 4
  store i16 0, ptr %65, align 2, !tbaa !25
  %66 = getelementptr inbounds nuw i8, ptr %60, i64 6
  store i16 0, ptr %66, align 2, !tbaa !26
  %67 = getelementptr inbounds nuw i8, ptr %60, i64 8
  store i16 0, ptr %67, align 2, !tbaa !188
  %68 = getelementptr inbounds nuw i8, ptr %60, i64 10
  store i16 0, ptr %68, align 2, !tbaa !189
  br label %69

69:                                               ; preds = %52, %54
  %70 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %71 = load i32, ptr %70, align 8, !tbaa !32
  %72 = add nsw i32 %71, 1
  store i32 %72, ptr %70, align 8, !tbaa !32
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define internal fastcc void @stbtt__csctx_rccurve_to(ptr noundef nonnull captures(none) %0, float noundef %1, float noundef %2, float noundef %3, float noundef %4, float noundef %5, float noundef %6) unnamed_addr #23 {
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %9 = load float, ptr %8, align 8, !tbaa !181
  %10 = fadd float %1, %9
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 20
  %12 = load float, ptr %11, align 4, !tbaa !182
  %13 = fadd float %2, %12
  %14 = fadd float %3, %10
  %15 = fadd float %4, %13
  %16 = fadd float %5, %14
  store float %16, ptr %8, align 8, !tbaa !181
  %17 = fadd float %6, %15
  store float %17, ptr %11, align 4, !tbaa !182
  %18 = fptosi float %16 to i32
  %19 = fptosi float %17 to i32
  %20 = fptosi float %10 to i32
  %21 = fptosi float %13 to i32
  %22 = fptosi float %14 to i32
  %23 = fptosi float %15 to i32
  %24 = load i32, ptr %0, align 8, !tbaa !180
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %96, label %26

26:                                               ; preds = %7
  %27 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %28 = load i32, ptr %27, align 4, !tbaa !183
  %29 = icmp slt i32 %28, %18
  br i1 %29, label %34, label %30

30:                                               ; preds = %26
  %31 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %32 = load i32, ptr %31, align 4, !tbaa !184
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %34, label %35

34:                                               ; preds = %30, %26
  store i32 %18, ptr %27, align 4, !tbaa !183
  br label %35

35:                                               ; preds = %34, %30
  %36 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %37 = load i32, ptr %36, align 4, !tbaa !185
  %38 = icmp slt i32 %37, %19
  br i1 %38, label %43, label %39

39:                                               ; preds = %35
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %41 = load i32, ptr %40, align 4, !tbaa !184
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %43, label %44

43:                                               ; preds = %39, %35
  store i32 %19, ptr %36, align 4, !tbaa !185
  br label %44

44:                                               ; preds = %43, %39
  %45 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %46 = load i32, ptr %45, align 8, !tbaa !186
  %47 = icmp sgt i32 %46, %18
  br i1 %47, label %52, label %48

48:                                               ; preds = %44
  %49 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %50 = load i32, ptr %49, align 4, !tbaa !184
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %52, label %53

52:                                               ; preds = %48, %44
  store i32 %18, ptr %45, align 8, !tbaa !186
  br label %53

53:                                               ; preds = %52, %48
  %54 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %55 = load i32, ptr %54, align 8, !tbaa !187
  %56 = icmp sgt i32 %55, %19
  br i1 %56, label %61, label %57

57:                                               ; preds = %53
  %58 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %59 = load i32, ptr %58, align 4, !tbaa !184
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %61, label %62

61:                                               ; preds = %57, %53
  store i32 %19, ptr %54, align 8, !tbaa !187
  br label %62

62:                                               ; preds = %61, %57
  %63 = getelementptr inbounds nuw i8, ptr %0, i64 4
  store i32 1, ptr %63, align 4, !tbaa !184
  %64 = load i32, ptr %27, align 4, !tbaa !183
  %65 = icmp slt i32 %64, %20
  br i1 %65, label %66, label %67

66:                                               ; preds = %62
  store i32 %20, ptr %27, align 4, !tbaa !183
  br label %67

67:                                               ; preds = %66, %62
  %68 = load i32, ptr %36, align 4, !tbaa !185
  %69 = icmp slt i32 %68, %21
  br i1 %69, label %70, label %71

70:                                               ; preds = %67
  store i32 %21, ptr %36, align 4, !tbaa !185
  br label %71

71:                                               ; preds = %70, %67
  %72 = load i32, ptr %45, align 8, !tbaa !186
  %73 = icmp sgt i32 %72, %20
  br i1 %73, label %74, label %75

74:                                               ; preds = %71
  store i32 %20, ptr %45, align 8, !tbaa !186
  br label %75

75:                                               ; preds = %74, %71
  %76 = load i32, ptr %54, align 8, !tbaa !187
  %77 = icmp sgt i32 %76, %21
  br i1 %77, label %78, label %79

78:                                               ; preds = %75
  store i32 %21, ptr %54, align 8, !tbaa !187
  br label %79

79:                                               ; preds = %78, %75
  store i32 1, ptr %63, align 4, !tbaa !184
  %80 = load i32, ptr %27, align 4, !tbaa !183
  %81 = icmp slt i32 %80, %22
  br i1 %81, label %82, label %83

82:                                               ; preds = %79
  store i32 %22, ptr %27, align 4, !tbaa !183
  br label %83

83:                                               ; preds = %82, %79
  %84 = load i32, ptr %36, align 4, !tbaa !185
  %85 = icmp slt i32 %84, %23
  br i1 %85, label %86, label %87

86:                                               ; preds = %83
  store i32 %23, ptr %36, align 4, !tbaa !185
  br label %87

87:                                               ; preds = %86, %83
  %88 = load i32, ptr %45, align 8, !tbaa !186
  %89 = icmp sgt i32 %88, %22
  br i1 %89, label %90, label %91

90:                                               ; preds = %87
  store i32 %22, ptr %45, align 8, !tbaa !186
  br label %91

91:                                               ; preds = %90, %87
  %92 = load i32, ptr %54, align 8, !tbaa !187
  %93 = icmp sgt i32 %92, %23
  br i1 %93, label %94, label %95

94:                                               ; preds = %91
  store i32 %23, ptr %54, align 8, !tbaa !187
  br label %95

95:                                               ; preds = %94, %91
  store i32 1, ptr %63, align 4, !tbaa !184
  br label %115

96:                                               ; preds = %7
  %97 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %98 = load ptr, ptr %97, align 8, !tbaa !29
  %99 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %100 = load i32, ptr %99, align 8, !tbaa !32
  %101 = sext i32 %100 to i64
  %102 = getelementptr inbounds %struct.stbtt_vertex, ptr %98, i64 %101
  %103 = getelementptr inbounds nuw i8, ptr %102, i64 12
  store i8 4, ptr %103, align 2, !tbaa !141
  %104 = trunc i32 %18 to i16
  store i16 %104, ptr %102, align 2, !tbaa !21
  %105 = trunc i32 %19 to i16
  %106 = getelementptr inbounds nuw i8, ptr %102, i64 2
  store i16 %105, ptr %106, align 2, !tbaa !24
  %107 = trunc i32 %20 to i16
  %108 = getelementptr inbounds nuw i8, ptr %102, i64 4
  store i16 %107, ptr %108, align 2, !tbaa !25
  %109 = trunc i32 %21 to i16
  %110 = getelementptr inbounds nuw i8, ptr %102, i64 6
  store i16 %109, ptr %110, align 2, !tbaa !26
  %111 = trunc i32 %22 to i16
  %112 = getelementptr inbounds nuw i8, ptr %102, i64 8
  store i16 %111, ptr %112, align 2, !tbaa !188
  %113 = trunc i32 %23 to i16
  %114 = getelementptr inbounds nuw i8, ptr %102, i64 10
  store i16 %113, ptr %114, align 2, !tbaa !189
  br label %115

115:                                              ; preds = %95, %96
  %116 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %117 = load i32, ptr %116, align 8, !tbaa !32
  %118 = add nsw i32 %117, 1
  store i32 %118, ptr %116, align 8, !tbaa !32
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define internal fastcc void @stbtt__csctx_close_shape(ptr noundef nonnull captures(none) %0) unnamed_addr #23 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load float, ptr %2, align 8, !tbaa !201
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %5 = load float, ptr %4, align 8, !tbaa !181
  %6 = fcmp une float %3, %5
  br i1 %6, label %13, label %7

7:                                                ; preds = %1
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %9 = load float, ptr %8, align 4, !tbaa !202
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 20
  %11 = load float, ptr %10, align 4, !tbaa !182
  %12 = fcmp une float %9, %11
  br i1 %12, label %13, label %77

13:                                               ; preds = %7, %1
  %14 = fptosi float %3 to i32
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %16 = load float, ptr %15, align 4, !tbaa !202
  %17 = fptosi float %16 to i32
  %18 = load i32, ptr %0, align 8, !tbaa !180
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %58, label %20

20:                                               ; preds = %13
  %21 = getelementptr inbounds nuw i8, ptr %0, i64 28
  %22 = load i32, ptr %21, align 4, !tbaa !183
  %23 = icmp slt i32 %22, %14
  br i1 %23, label %28, label %24

24:                                               ; preds = %20
  %25 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %26 = load i32, ptr %25, align 4, !tbaa !184
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %28, label %29

28:                                               ; preds = %24, %20
  store i32 %14, ptr %21, align 4, !tbaa !183
  br label %29

29:                                               ; preds = %28, %24
  %30 = getelementptr inbounds nuw i8, ptr %0, i64 36
  %31 = load i32, ptr %30, align 4, !tbaa !185
  %32 = icmp slt i32 %31, %17
  br i1 %32, label %37, label %33

33:                                               ; preds = %29
  %34 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %35 = load i32, ptr %34, align 4, !tbaa !184
  %36 = icmp eq i32 %35, 0
  br i1 %36, label %37, label %38

37:                                               ; preds = %33, %29
  store i32 %17, ptr %30, align 4, !tbaa !185
  br label %38

38:                                               ; preds = %37, %33
  %39 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %40 = load i32, ptr %39, align 8, !tbaa !186
  %41 = icmp sgt i32 %40, %14
  br i1 %41, label %46, label %42

42:                                               ; preds = %38
  %43 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %44 = load i32, ptr %43, align 4, !tbaa !184
  %45 = icmp eq i32 %44, 0
  br i1 %45, label %46, label %47

46:                                               ; preds = %42, %38
  store i32 %14, ptr %39, align 8, !tbaa !186
  br label %47

47:                                               ; preds = %46, %42
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 32
  %49 = load i32, ptr %48, align 8, !tbaa !187
  %50 = icmp sgt i32 %49, %17
  br i1 %50, label %55, label %51

51:                                               ; preds = %47
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %53 = load i32, ptr %52, align 4, !tbaa !184
  %54 = icmp eq i32 %53, 0
  br i1 %54, label %55, label %56

55:                                               ; preds = %51, %47
  store i32 %17, ptr %48, align 8, !tbaa !187
  br label %56

56:                                               ; preds = %55, %51
  %57 = getelementptr inbounds nuw i8, ptr %0, i64 4
  store i32 1, ptr %57, align 4, !tbaa !184
  br label %73

58:                                               ; preds = %13
  %59 = getelementptr inbounds nuw i8, ptr %0, i64 40
  %60 = load ptr, ptr %59, align 8, !tbaa !29
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %62 = load i32, ptr %61, align 8, !tbaa !32
  %63 = sext i32 %62 to i64
  %64 = getelementptr inbounds %struct.stbtt_vertex, ptr %60, i64 %63
  %65 = getelementptr inbounds nuw i8, ptr %64, i64 12
  store i8 2, ptr %65, align 2, !tbaa !141
  %66 = trunc i32 %14 to i16
  store i16 %66, ptr %64, align 2, !tbaa !21
  %67 = trunc i32 %17 to i16
  %68 = getelementptr inbounds nuw i8, ptr %64, i64 2
  store i16 %67, ptr %68, align 2, !tbaa !24
  %69 = getelementptr inbounds nuw i8, ptr %64, i64 4
  store i16 0, ptr %69, align 2, !tbaa !25
  %70 = getelementptr inbounds nuw i8, ptr %64, i64 6
  store i16 0, ptr %70, align 2, !tbaa !26
  %71 = getelementptr inbounds nuw i8, ptr %64, i64 8
  store i16 0, ptr %71, align 2, !tbaa !188
  %72 = getelementptr inbounds nuw i8, ptr %64, i64 10
  store i16 0, ptr %72, align 2, !tbaa !189
  br label %73

73:                                               ; preds = %56, %58
  %74 = getelementptr inbounds nuw i8, ptr %0, i64 48
  %75 = load i32, ptr %74, align 8, !tbaa !32
  %76 = add nsw i32 %75, 1
  store i32 %76, ptr %74, align 8, !tbaa !32
  br label %77

77:                                               ; preds = %73, %7
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define internal fastcc i32 @stbtt__cff_int(ptr noundef nonnull captures(none) %0) unnamed_addr #6 {
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %3 = load i32, ptr %2, align 8, !tbaa !177
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %5 = load i32, ptr %4, align 4, !tbaa !178
  %6 = icmp slt i32 %3, %5
  br i1 %6, label %7, label %13

7:                                                ; preds = %1
  %8 = load ptr, ptr %0, align 8, !tbaa !179
  %9 = add nsw i32 %3, 1
  store i32 %9, ptr %2, align 8, !tbaa !177
  %10 = sext i32 %3 to i64
  %11 = getelementptr inbounds i8, ptr %8, i64 %10
  %12 = load i8, ptr %11, align 1, !tbaa !14
  br label %13

13:                                               ; preds = %1, %7
  %14 = phi i8 [ %12, %7 ], [ 0, %1 ]
  %15 = zext i8 %14 to i32
  %16 = add i8 %14, -32
  %17 = icmp ult i8 %16, -41
  br i1 %17, label %18, label %20

18:                                               ; preds = %13
  %19 = add nsw i32 %15, -139
  br label %97

20:                                               ; preds = %13
  %21 = add i8 %14, 9
  %22 = icmp ult i8 %21, 4
  br i1 %22, label %23, label %38

23:                                               ; preds = %20
  %24 = shl nuw nsw i32 %15, 8
  %25 = load i32, ptr %2, align 8, !tbaa !177
  %26 = icmp slt i32 %25, %5
  br i1 %26, label %27, label %34

27:                                               ; preds = %23
  %28 = load ptr, ptr %0, align 8, !tbaa !179
  %29 = add nsw i32 %25, 1
  store i32 %29, ptr %2, align 8, !tbaa !177
  %30 = sext i32 %25 to i64
  %31 = getelementptr inbounds i8, ptr %28, i64 %30
  %32 = load i8, ptr %31, align 1, !tbaa !14
  %33 = zext i8 %32 to i32
  br label %34

34:                                               ; preds = %23, %27
  %35 = phi i32 [ %33, %27 ], [ 0, %23 ]
  %36 = add nsw i32 %24, -63124
  %37 = add nuw nsw i32 %36, %35
  br label %97

38:                                               ; preds = %20
  %39 = add i8 %14, 5
  %40 = icmp ult i8 %39, 4
  br i1 %40, label %41, label %56

41:                                               ; preds = %38
  %42 = load i32, ptr %2, align 8, !tbaa !177
  %43 = icmp slt i32 %42, %5
  br i1 %43, label %44, label %51

44:                                               ; preds = %41
  %45 = load ptr, ptr %0, align 8, !tbaa !179
  %46 = add nsw i32 %42, 1
  store i32 %46, ptr %2, align 8, !tbaa !177
  %47 = sext i32 %42 to i64
  %48 = getelementptr inbounds i8, ptr %45, i64 %47
  %49 = load i8, ptr %48, align 1, !tbaa !14
  %50 = zext i8 %49 to i32
  br label %51

51:                                               ; preds = %41, %44
  %52 = phi i32 [ %50, %44 ], [ 0, %41 ]
  %53 = shl nuw nsw i32 %15, 8
  %54 = or disjoint i32 %53, %52
  %55 = sub nsw i32 64148, %54
  br label %97

56:                                               ; preds = %38
  switch i8 %14, label %97 [
    i8 28, label %57
    i8 29, label %76
  ]

57:                                               ; preds = %56
  %58 = load i32, ptr %2, align 8, !tbaa !177
  br label %59

59:                                               ; preds = %73, %57
  %60 = phi i32 [ %58, %57 ], [ %74, %73 ]
  %61 = phi i1 [ false, %57 ], [ true, %73 ]
  %62 = phi i32 [ 0, %57 ], [ %75, %73 ]
  %63 = shl i32 %62, 8
  %64 = icmp slt i32 %60, %5
  br i1 %64, label %65, label %73

65:                                               ; preds = %59
  %66 = load ptr, ptr %0, align 8, !tbaa !179
  %67 = add nsw i32 %60, 1
  store i32 %67, ptr %2, align 8, !tbaa !177
  %68 = sext i32 %60 to i64
  %69 = getelementptr inbounds i8, ptr %66, i64 %68
  %70 = load i8, ptr %69, align 1, !tbaa !14
  %71 = zext i8 %70 to i32
  %72 = or disjoint i32 %63, %71
  br label %73

73:                                               ; preds = %65, %59
  %74 = phi i32 [ %67, %65 ], [ %60, %59 ]
  %75 = phi i32 [ %72, %65 ], [ %63, %59 ]
  br i1 %61, label %97, label %59, !llvm.loop !139

76:                                               ; preds = %56
  %77 = load i32, ptr %2, align 8, !tbaa !177
  br label %78

78:                                               ; preds = %92, %76
  %79 = phi i32 [ %77, %76 ], [ %93, %92 ]
  %80 = phi i32 [ 0, %76 ], [ %95, %92 ]
  %81 = phi i32 [ 0, %76 ], [ %94, %92 ]
  %82 = shl i32 %81, 8
  %83 = icmp slt i32 %79, %5
  br i1 %83, label %84, label %92

84:                                               ; preds = %78
  %85 = load ptr, ptr %0, align 8, !tbaa !179
  %86 = add nsw i32 %79, 1
  store i32 %86, ptr %2, align 8, !tbaa !177
  %87 = sext i32 %79 to i64
  %88 = getelementptr inbounds i8, ptr %85, i64 %87
  %89 = load i8, ptr %88, align 1, !tbaa !14
  %90 = zext i8 %89 to i32
  %91 = or disjoint i32 %82, %90
  br label %92

92:                                               ; preds = %84, %78
  %93 = phi i32 [ %86, %84 ], [ %79, %78 ]
  %94 = phi i32 [ %91, %84 ], [ %82, %78 ]
  %95 = add nuw nsw i32 %80, 1
  %96 = icmp eq i32 %95, 4
  br i1 %96, label %97, label %78, !llvm.loop !139

97:                                               ; preds = %92, %73, %56, %51, %34, %18
  %98 = phi i32 [ %19, %18 ], [ %37, %34 ], [ %55, %51 ], [ 0, %56 ], [ %75, %73 ], [ %94, %92 ]
  ret i32 %98
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define internal fastcc { ptr, i64 } @stbtt__get_subrs(ptr %0, i64 %1, ptr %2, i64 %3) unnamed_addr #0 {
  %5 = alloca %struct.stbtt__buf, align 8
  %6 = alloca i32, align 4
  %7 = alloca [2 x i32], align 8
  %8 = alloca %struct.stbtt__buf, align 8
  %9 = lshr i64 %1, 32
  %10 = trunc nuw i64 %9 to i32
  store ptr %2, ptr %5, align 8
  %11 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store i64 %3, ptr %11, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %6) #26
  store i32 0, ptr %6, align 4, !tbaa !4
  call void @llvm.lifetime.start.p0(ptr nonnull %7) #26
  store i64 0, ptr %7, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %8) #26
  call fastcc void @stbtt__dict_get_ints(ptr noundef %5, i32 noundef 18, i32 noundef 2, ptr noundef %7) #25
  %12 = getelementptr inbounds nuw i8, ptr %7, i64 4
  %13 = load i32, ptr %12, align 4, !tbaa !4
  %14 = icmp ne i32 %13, 0
  %15 = load i32, ptr %7, align 8
  %16 = icmp ne i32 %15, 0
  %17 = select i1 %14, i1 %16, i1 false
  br i1 %17, label %18, label %123

18:                                               ; preds = %4
  %19 = or i32 %15, %13
  %20 = icmp sgt i32 %19, -1
  br i1 %20, label %21, label %31

21:                                               ; preds = %18
  %22 = icmp sgt i32 %13, %10
  %23 = sub nsw i32 %10, %13
  %24 = icmp sgt i32 %15, %23
  %25 = select i1 %22, i1 true, i1 %24
  br i1 %25, label %31, label %26

26:                                               ; preds = %21
  %27 = zext nneg i32 %13 to i64
  %28 = getelementptr inbounds nuw i8, ptr %0, i64 %27
  %29 = zext nneg i32 %15 to i64
  %30 = shl nuw nsw i64 %29, 32
  br label %31

31:                                               ; preds = %18, %21, %26
  %32 = phi ptr [ null, %18 ], [ null, %21 ], [ %28, %26 ]
  %33 = phi i64 [ 0, %18 ], [ 0, %21 ], [ %30, %26 ]
  store ptr %32, ptr %8, align 8, !tbaa !57
  %34 = getelementptr inbounds nuw i8, ptr %8, i64 8
  store i64 %33, ptr %34, align 8
  call fastcc void @stbtt__dict_get_ints(ptr noundef %8, i32 noundef 19, i32 noundef 1, ptr noundef %6) #25
  %35 = load i32, ptr %6, align 4, !tbaa !4
  %36 = icmp eq i32 %35, 0
  br i1 %36, label %123, label %37

37:                                               ; preds = %31
  %38 = add i32 %35, %13
  %39 = icmp slt i32 %38, 0
  %40 = tail call i32 @llvm.smin.i32(i32 %38, i32 %10)
  %41 = select i1 %39, i32 %10, i32 %40
  br label %42

42:                                               ; preds = %56, %37
  %43 = phi i32 [ %41, %37 ], [ %57, %56 ]
  %44 = phi i32 [ %41, %37 ], [ %58, %56 ]
  %45 = phi i1 [ false, %37 ], [ true, %56 ]
  %46 = phi i32 [ 0, %37 ], [ %59, %56 ]
  %47 = shl i32 %46, 8
  %48 = icmp slt i32 %44, %10
  br i1 %48, label %49, label %56

49:                                               ; preds = %42
  %50 = add nsw i32 %44, 1
  %51 = sext i32 %44 to i64
  %52 = getelementptr inbounds i8, ptr %0, i64 %51
  %53 = load i8, ptr %52, align 1, !tbaa !14
  %54 = zext i8 %53 to i32
  %55 = or disjoint i32 %47, %54
  br label %56

56:                                               ; preds = %49, %42
  %57 = phi i32 [ %50, %49 ], [ %43, %42 ]
  %58 = phi i32 [ %50, %49 ], [ %44, %42 ]
  %59 = phi i32 [ %55, %49 ], [ %47, %42 ]
  br i1 %45, label %60, label %42, !llvm.loop !139

60:                                               ; preds = %56
  %61 = icmp eq i32 %59, 0
  br i1 %61, label %108, label %62

62:                                               ; preds = %60
  %63 = icmp slt i32 %57, %10
  br i1 %63, label %64, label %70

64:                                               ; preds = %62
  %65 = add nsw i32 %57, 1
  %66 = sext i32 %57 to i64
  %67 = getelementptr inbounds i8, ptr %0, i64 %66
  %68 = load i8, ptr %67, align 1, !tbaa !14
  %69 = zext i8 %68 to i32
  br label %70

70:                                               ; preds = %64, %62
  %71 = phi i32 [ %65, %64 ], [ %57, %62 ]
  %72 = phi i32 [ %69, %64 ], [ 0, %62 ]
  %73 = mul nsw i32 %72, %59
  %74 = add nsw i32 %73, %71
  %75 = icmp slt i32 %74, 0
  %76 = tail call i32 @llvm.smin.i32(i32 %74, i32 %10)
  %77 = select i1 %75, i32 %10, i32 %76
  %78 = icmp eq i32 %72, 0
  br i1 %78, label %101, label %79

79:                                               ; preds = %70, %93
  %80 = phi i32 [ %94, %93 ], [ %77, %70 ]
  %81 = phi i32 [ %95, %93 ], [ %77, %70 ]
  %82 = phi i32 [ %97, %93 ], [ 0, %70 ]
  %83 = phi i32 [ %96, %93 ], [ 0, %70 ]
  %84 = shl i32 %83, 8
  %85 = icmp slt i32 %81, %10
  br i1 %85, label %86, label %93

86:                                               ; preds = %79
  %87 = add nsw i32 %81, 1
  %88 = sext i32 %81 to i64
  %89 = getelementptr inbounds i8, ptr %0, i64 %88
  %90 = load i8, ptr %89, align 1, !tbaa !14
  %91 = zext i8 %90 to i32
  %92 = or disjoint i32 %84, %91
  br label %93

93:                                               ; preds = %86, %79
  %94 = phi i32 [ %87, %86 ], [ %80, %79 ]
  %95 = phi i32 [ %87, %86 ], [ %81, %79 ]
  %96 = phi i32 [ %92, %86 ], [ %84, %79 ]
  %97 = add nuw nsw i32 %82, 1
  %98 = icmp eq i32 %97, %72
  br i1 %98, label %99, label %79, !llvm.loop !139

99:                                               ; preds = %93
  %100 = add i32 %96, -1
  br label %101

101:                                              ; preds = %99, %70
  %102 = phi i32 [ %77, %70 ], [ %94, %99 ]
  %103 = phi i32 [ -1, %70 ], [ %100, %99 ]
  %104 = add nsw i32 %103, %102
  %105 = icmp slt i32 %104, 0
  %106 = tail call i32 @llvm.smin.i32(i32 %104, i32 %10)
  %107 = select i1 %105, i32 %10, i32 %106
  br label %108

108:                                              ; preds = %101, %60
  %109 = phi i32 [ %57, %60 ], [ %107, %101 ]
  %110 = sub nsw i32 %109, %41
  %111 = or i32 %110, %41
  %112 = icmp slt i32 %111, 0
  %113 = icmp sgt i32 %109, %10
  %114 = select i1 %112, i1 true, i1 %113
  %115 = zext nneg i32 %41 to i64
  %116 = getelementptr inbounds nuw i8, ptr %0, i64 %115
  %117 = zext nneg i32 %110 to i64
  %118 = shl nuw nsw i64 %117, 32
  %119 = select i1 %114, ptr null, ptr %116
  %120 = select i1 %114, i64 0, i64 %118
  %121 = insertvalue { ptr, i64 } poison, ptr %119, 0
  %122 = insertvalue { ptr, i64 } %121, i64 %120, 1
  br label %123

123:                                              ; preds = %31, %4, %108
  %124 = phi { ptr, i64 } [ %122, %108 ], [ zeroinitializer, %4 ], [ zeroinitializer, %31 ]
  call void @llvm.lifetime.end.p0(ptr nonnull %8) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %7) #26
  call void @llvm.lifetime.end.p0(ptr nonnull %6) #26
  ret { ptr, i64 } %124
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none)
define internal fastcc void @stbtt__dict_get_ints(ptr noundef nonnull captures(none) initializes((8, 12)) %0, i32 noundef range(i32 17, 294) %1, i32 noundef range(i32 1, 3) %2, ptr noundef nonnull writeonly captures(none) %3) unnamed_addr #6 {
  %5 = alloca %struct.stbtt__buf, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %5) #26
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 12
  %7 = load i32, ptr %6, align 4, !tbaa !178
  %8 = tail call i32 @llvm.smin.i32(i32 %7, i32 0)
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i32 %8, ptr %9, align 8, !tbaa !177
  br label %10

10:                                               ; preds = %91, %4
  %11 = phi ptr [ undef, %4 ], [ %92, %91 ]
  %12 = phi i64 [ undef, %4 ], [ %93, %91 ]
  %13 = load i32, ptr %9, align 8, !tbaa !177
  %14 = load i32, ptr %6, align 4, !tbaa !178
  %15 = icmp slt i32 %13, %14
  br i1 %15, label %16, label %94

16:                                               ; preds = %10, %49
  %17 = phi i32 [ %51, %49 ], [ %14, %10 ]
  %18 = phi i32 [ %50, %49 ], [ %13, %10 ]
  %19 = load ptr, ptr %0, align 8, !tbaa !179
  %20 = sext i32 %18 to i64
  %21 = getelementptr inbounds i8, ptr %19, i64 %20
  %22 = load i8, ptr %21, align 1, !tbaa !14
  %23 = icmp ugt i8 %22, 27
  br i1 %23, label %24, label %53

24:                                               ; preds = %16
  %25 = icmp eq i8 %22, 30
  br i1 %25, label %26, label %47

26:                                               ; preds = %24
  %27 = add nsw i32 %18, 1
  %28 = icmp slt i32 %18, -1
  %29 = tail call i32 @llvm.smin.i32(i32 %27, i32 %17)
  %30 = select i1 %28, i32 %17, i32 %29
  store i32 %30, ptr %9, align 8, !tbaa !177
  %31 = sext i32 %30 to i64
  %32 = sext i32 %17 to i64
  br label %33

33:                                               ; preds = %36, %26
  %34 = phi i64 [ %37, %36 ], [ %31, %26 ]
  %35 = icmp eq i64 %34, %32
  br i1 %35, label %49, label %36

36:                                               ; preds = %33
  %37 = add nsw i64 %34, 1
  %38 = trunc nsw i64 %37 to i32
  store i32 %38, ptr %9, align 8, !tbaa !177
  %39 = getelementptr inbounds i8, ptr %19, i64 %34
  %40 = load i8, ptr %39, align 1, !tbaa !14
  %41 = zext i8 %40 to i32
  %42 = and i32 %41, 15
  %43 = icmp eq i32 %42, 15
  %44 = and i32 %41, 240
  %45 = icmp eq i32 %44, 240
  %46 = or i1 %43, %45
  br i1 %46, label %49, label %33, !llvm.loop !203

47:                                               ; preds = %24
  %48 = tail call fastcc i32 @stbtt__cff_int(ptr noundef nonnull %0) #25
  br label %49

49:                                               ; preds = %36, %33, %47
  %50 = load i32, ptr %9, align 8, !tbaa !177
  %51 = load i32, ptr %6, align 4, !tbaa !178
  %52 = icmp slt i32 %50, %51
  br i1 %52, label %16, label %57, !llvm.loop !204

53:                                               ; preds = %16
  %54 = getelementptr inbounds i8, ptr %19, i64 %20
  %55 = add nsw i32 %18, 1
  store i32 %55, ptr %9, align 8, !tbaa !177
  %56 = load i8, ptr %54, align 1, !tbaa !14
  br label %57

57:                                               ; preds = %49, %53
  %58 = phi i32 [ %18, %53 ], [ %50, %49 ]
  %59 = phi i32 [ %17, %53 ], [ %51, %49 ]
  %60 = phi i8 [ %56, %53 ], [ 0, %49 ]
  %61 = zext i8 %60 to i32
  %62 = icmp eq i8 %60, 12
  br i1 %62, label %63, label %74

63:                                               ; preds = %57
  %64 = load i32, ptr %9, align 8, !tbaa !177
  %65 = icmp slt i32 %64, %59
  br i1 %65, label %66, label %74

66:                                               ; preds = %63
  %67 = load ptr, ptr %0, align 8, !tbaa !179
  %68 = add nsw i32 %64, 1
  store i32 %68, ptr %9, align 8, !tbaa !177
  %69 = sext i32 %64 to i64
  %70 = getelementptr inbounds i8, ptr %67, i64 %69
  %71 = load i8, ptr %70, align 1, !tbaa !14
  %72 = zext i8 %71 to i32
  %73 = or disjoint i32 %72, 256
  br label %74

74:                                               ; preds = %66, %63, %57
  %75 = phi i32 [ %61, %57 ], [ %73, %66 ], [ 256, %63 ]
  %76 = icmp eq i32 %75, %1
  br i1 %76, label %77, label %91

77:                                               ; preds = %74
  %78 = sub nsw i32 %58, %13
  %79 = or i32 %78, %13
  %80 = icmp sgt i32 %79, -1
  br i1 %80, label %81, label %91

81:                                               ; preds = %77
  %82 = icmp sgt i32 %13, %59
  %83 = icmp sgt i32 %58, %59
  %84 = or i1 %82, %83
  br i1 %84, label %91, label %85

85:                                               ; preds = %81
  %86 = load ptr, ptr %0, align 8, !tbaa !179
  %87 = zext nneg i32 %13 to i64
  %88 = getelementptr inbounds nuw i8, ptr %86, i64 %87
  %89 = zext nneg i32 %78 to i64
  %90 = shl nuw nsw i64 %89, 32
  br label %91

91:                                               ; preds = %85, %81, %77, %74
  %92 = phi ptr [ %11, %74 ], [ null, %77 ], [ null, %81 ], [ %88, %85 ]
  %93 = phi i64 [ %12, %74 ], [ 0, %77 ], [ 0, %81 ], [ %90, %85 ]
  br i1 %76, label %98, label %10

94:                                               ; preds = %10
  %95 = icmp slt i32 %14, 0
  br i1 %95, label %98, label %96

96:                                               ; preds = %94
  %97 = load ptr, ptr %0, align 8, !tbaa !179
  br label %98

98:                                               ; preds = %91, %94, %96
  %99 = phi ptr [ null, %94 ], [ %97, %96 ], [ %92, %91 ]
  %100 = phi i64 [ 0, %94 ], [ 0, %96 ], [ %93, %91 ]
  store ptr %99, ptr %5, align 8
  %101 = getelementptr inbounds nuw i8, ptr %5, i64 8
  store i64 %100, ptr %101, align 8
  %102 = getelementptr inbounds nuw i8, ptr %5, i64 12
  %103 = load i32, ptr %101, align 8
  %104 = load i32, ptr %102, align 4
  %105 = icmp slt i32 %103, %104
  br i1 %105, label %106, label %118

106:                                              ; preds = %98
  %107 = zext nneg i32 %2 to i64
  br label %108

108:                                              ; preds = %106, %108
  %109 = phi i64 [ 0, %106 ], [ %112, %108 ]
  %110 = call fastcc i32 @stbtt__cff_int(ptr noundef %5) #25
  %111 = getelementptr inbounds nuw i32, ptr %3, i64 %109
  store i32 %110, ptr %111, align 4, !tbaa !4
  %112 = add nuw nsw i64 %109, 1
  %113 = icmp samesign ult i64 %112, %107
  %114 = load i32, ptr %101, align 8
  %115 = load i32, ptr %102, align 4
  %116 = icmp slt i32 %114, %115
  %117 = select i1 %113, i1 %116, i1 false
  br i1 %117, label %108, label %118, !llvm.loop !205

118:                                              ; preds = %108, %98
  call void @llvm.lifetime.end.p0(ptr nonnull %5) #26
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define internal fastcc i32 @stbtt__GetGlyphClass(ptr noundef readonly captures(none) %0, i32 noundef %1) unnamed_addr #20 {
  %3 = load i8, ptr %0, align 1, !tbaa !14
  %4 = zext i8 %3 to i16
  %5 = shl nuw i16 %4, 8
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 1
  %7 = load i8, ptr %6, align 1, !tbaa !14
  %8 = zext i8 %7 to i16
  %9 = or disjoint i16 %5, %8
  switch i16 %9, label %108 [
    i16 1, label %10
    i16 2, label %47
  ]

10:                                               ; preds = %2
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %12 = load i8, ptr %11, align 1, !tbaa !14
  %13 = zext i8 %12 to i32
  %14 = shl nuw nsw i32 %13, 8
  %15 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %16 = load i8, ptr %15, align 1, !tbaa !14
  %17 = zext i8 %16 to i32
  %18 = or disjoint i32 %14, %17
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 6
  %20 = icmp slt i32 %1, %18
  br i1 %20, label %44, label %21

21:                                               ; preds = %10
  %22 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %23 = load i8, ptr %22, align 1, !tbaa !14
  %24 = zext i8 %23 to i32
  %25 = shl nuw nsw i32 %24, 8
  %26 = getelementptr inbounds nuw i8, ptr %0, i64 5
  %27 = load i8, ptr %26, align 1, !tbaa !14
  %28 = zext i8 %27 to i32
  %29 = or disjoint i32 %25, %28
  %30 = add nuw nsw i32 %29, %18
  %31 = icmp slt i32 %1, %30
  br i1 %31, label %32, label %44

32:                                               ; preds = %21
  %33 = sub nsw i32 %1, %18
  %34 = shl nsw i32 %33, 1
  %35 = sext i32 %34 to i64
  %36 = getelementptr inbounds i8, ptr %19, i64 %35
  %37 = load i8, ptr %36, align 1, !tbaa !14
  %38 = zext i8 %37 to i32
  %39 = shl nuw nsw i32 %38, 8
  %40 = getelementptr inbounds nuw i8, ptr %36, i64 1
  %41 = load i8, ptr %40, align 1, !tbaa !14
  %42 = zext i8 %41 to i32
  %43 = or disjoint i32 %39, %42
  br label %44

44:                                               ; preds = %10, %21, %32
  %45 = phi i1 [ false, %32 ], [ true, %21 ], [ true, %10 ]
  %46 = phi i32 [ %43, %32 ], [ undef, %21 ], [ undef, %10 ]
  br i1 %45, label %107, label %108

47:                                               ; preds = %2
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %49 = load i8, ptr %48, align 1, !tbaa !14
  %50 = zext i8 %49 to i32
  %51 = shl nuw nsw i32 %50, 8
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %53 = load i8, ptr %52, align 1, !tbaa !14
  %54 = zext i8 %53 to i32
  %55 = or disjoint i32 %51, %54
  %56 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %57 = add nsw i32 %55, -1
  br label %58

58:                                               ; preds = %100, %47
  %59 = phi i32 [ %57, %47 ], [ %101, %100 ]
  %60 = phi i32 [ 0, %47 ], [ %102, %100 ]
  %61 = phi i32 [ undef, %47 ], [ %104, %100 ]
  %62 = icmp sgt i32 %60, %59
  br i1 %62, label %105, label %63

63:                                               ; preds = %58
  %64 = add nsw i32 %60, %59
  %65 = ashr i32 %64, 1
  %66 = mul nsw i32 %65, 6
  %67 = sext i32 %66 to i64
  %68 = getelementptr inbounds i8, ptr %56, i64 %67
  %69 = load i8, ptr %68, align 1, !tbaa !14
  %70 = zext i8 %69 to i32
  %71 = shl nuw nsw i32 %70, 8
  %72 = getelementptr inbounds nuw i8, ptr %68, i64 1
  %73 = load i8, ptr %72, align 1, !tbaa !14
  %74 = zext i8 %73 to i32
  %75 = or disjoint i32 %71, %74
  %76 = icmp slt i32 %1, %75
  br i1 %76, label %77, label %79

77:                                               ; preds = %63
  %78 = add nsw i32 %65, -1
  br label %100

79:                                               ; preds = %63
  %80 = getelementptr inbounds nuw i8, ptr %68, i64 2
  %81 = load i8, ptr %80, align 1, !tbaa !14
  %82 = zext i8 %81 to i32
  %83 = shl nuw nsw i32 %82, 8
  %84 = getelementptr inbounds nuw i8, ptr %68, i64 3
  %85 = load i8, ptr %84, align 1, !tbaa !14
  %86 = zext i8 %85 to i32
  %87 = or disjoint i32 %83, %86
  %88 = icmp sgt i32 %1, %87
  br i1 %88, label %89, label %91

89:                                               ; preds = %79
  %90 = add nsw i32 %65, 1
  br label %100

91:                                               ; preds = %79
  %92 = getelementptr inbounds nuw i8, ptr %68, i64 4
  %93 = load i8, ptr %92, align 1, !tbaa !14
  %94 = zext i8 %93 to i32
  %95 = shl nuw nsw i32 %94, 8
  %96 = getelementptr inbounds nuw i8, ptr %68, i64 5
  %97 = load i8, ptr %96, align 1, !tbaa !14
  %98 = zext i8 %97 to i32
  %99 = or disjoint i32 %95, %98
  br label %100

100:                                              ; preds = %77, %89, %91
  %101 = phi i32 [ %59, %91 ], [ %78, %77 ], [ %59, %89 ]
  %102 = phi i32 [ %60, %91 ], [ %60, %77 ], [ %90, %89 ]
  %103 = phi i1 [ false, %91 ], [ true, %77 ], [ true, %89 ]
  %104 = phi i32 [ %99, %91 ], [ %61, %77 ], [ %61, %89 ]
  br i1 %103, label %58, label %105, !llvm.loop !206

105:                                              ; preds = %58, %100
  %106 = phi i32 [ %61, %58 ], [ %104, %100 ]
  br i1 %62, label %107, label %108

107:                                              ; preds = %44, %105
  br label %108

108:                                              ; preds = %2, %44, %105, %107
  %109 = phi i32 [ %106, %105 ], [ 0, %107 ], [ %46, %44 ], [ -1, %2 ]
  ret i32 %109
}

; Function Attrs: nounwind
declare float @fmodf(float noundef, float noundef) local_unnamed_addr #11

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @stbtt__isfont(ptr noundef readonly captures(none) %0) unnamed_addr #16 {
  %2 = load i8, ptr %0, align 1, !tbaa !14
  %3 = icmp eq i8 %2, 49
  br i1 %3, label %4, label %16

4:                                                ; preds = %1
  %5 = getelementptr inbounds nuw i8, ptr %0, i64 1
  %6 = load i8, ptr %5, align 1, !tbaa !14
  %7 = icmp eq i8 %6, 0
  br i1 %7, label %8, label %16

8:                                                ; preds = %4
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %10 = load i8, ptr %9, align 1, !tbaa !14
  %11 = icmp eq i8 %10, 0
  br i1 %11, label %12, label %16

12:                                               ; preds = %8
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %14 = load i8, ptr %13, align 1, !tbaa !14
  %15 = icmp eq i8 %14, 0
  br i1 %15, label %69, label %16

16:                                               ; preds = %12, %8, %4, %1
  %17 = icmp eq i8 %2, 116
  br i1 %17, label %18, label %30

18:                                               ; preds = %16
  %19 = getelementptr inbounds nuw i8, ptr %0, i64 1
  %20 = load i8, ptr %19, align 1, !tbaa !14
  %21 = icmp eq i8 %20, 121
  br i1 %21, label %22, label %30

22:                                               ; preds = %18
  %23 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %24 = load i8, ptr %23, align 1, !tbaa !14
  %25 = icmp eq i8 %24, 112
  br i1 %25, label %26, label %30

26:                                               ; preds = %22
  %27 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %28 = load i8, ptr %27, align 1, !tbaa !14
  %29 = icmp eq i8 %28, 49
  br i1 %29, label %69, label %30

30:                                               ; preds = %26, %22, %18, %16
  switch i8 %2, label %55 [
    i8 79, label %31
    i8 0, label %43
  ]

31:                                               ; preds = %30
  %32 = getelementptr inbounds nuw i8, ptr %0, i64 1
  %33 = load i8, ptr %32, align 1, !tbaa !14
  %34 = icmp eq i8 %33, 84
  br i1 %34, label %35, label %55

35:                                               ; preds = %31
  %36 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %37 = load i8, ptr %36, align 1, !tbaa !14
  %38 = icmp eq i8 %37, 84
  br i1 %38, label %39, label %55

39:                                               ; preds = %35
  %40 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %41 = load i8, ptr %40, align 1, !tbaa !14
  %42 = icmp eq i8 %41, 79
  br i1 %42, label %69, label %55

43:                                               ; preds = %30
  %44 = getelementptr inbounds nuw i8, ptr %0, i64 1
  %45 = load i8, ptr %44, align 1, !tbaa !14
  %46 = icmp eq i8 %45, 1
  br i1 %46, label %47, label %55

47:                                               ; preds = %43
  %48 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %49 = load i8, ptr %48, align 1, !tbaa !14
  %50 = icmp eq i8 %49, 0
  br i1 %50, label %51, label %55

51:                                               ; preds = %47
  %52 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %53 = load i8, ptr %52, align 1, !tbaa !14
  %54 = icmp eq i8 %53, 0
  br i1 %54, label %69, label %55

55:                                               ; preds = %31, %35, %39, %30, %51, %47, %43
  br i1 %17, label %56, label %68

56:                                               ; preds = %55
  %57 = getelementptr inbounds nuw i8, ptr %0, i64 1
  %58 = load i8, ptr %57, align 1, !tbaa !14
  %59 = icmp eq i8 %58, 114
  br i1 %59, label %60, label %68

60:                                               ; preds = %56
  %61 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %62 = load i8, ptr %61, align 1, !tbaa !14
  %63 = icmp eq i8 %62, 117
  br i1 %63, label %64, label %68

64:                                               ; preds = %60
  %65 = getelementptr inbounds nuw i8, ptr %0, i64 3
  %66 = load i8, ptr %65, align 1, !tbaa !14
  %67 = icmp eq i8 %66, 101
  br i1 %67, label %69, label %68

68:                                               ; preds = %64, %60, %56, %55
  br label %69

69:                                               ; preds = %64, %51, %39, %26, %12, %68
  %70 = phi i32 [ 0, %68 ], [ 1, %12 ], [ 1, %26 ], [ 1, %39 ], [ 1, %51 ], [ 1, %64 ]
  ret i32 %70
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define internal fastcc range(i32 0, 2) i32 @stbtt__matchpair(ptr noundef readonly captures(none) %0, i32 noundef range(i32 1, 0) %1, ptr noundef readonly captures(none) %2, i32 noundef %3, i32 noundef range(i32 1, 17) %4, i32 noundef range(i32 -1, 18) %5) unnamed_addr #20 {
  %7 = zext i32 %1 to i64
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 %7
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 2
  %10 = load i8, ptr %9, align 1, !tbaa !14
  %11 = zext i8 %10 to i32
  %12 = shl nuw nsw i32 %11, 8
  %13 = getelementptr inbounds nuw i8, ptr %8, i64 3
  %14 = load i8, ptr %13, align 1, !tbaa !14
  %15 = zext i8 %14 to i32
  %16 = or disjoint i32 %12, %15
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %184, label %18

18:                                               ; preds = %6
  %19 = getelementptr inbounds nuw i8, ptr %8, i64 4
  %20 = load i8, ptr %19, align 1, !tbaa !14
  %21 = zext i8 %20 to i32
  %22 = shl nuw nsw i32 %21, 8
  %23 = getelementptr inbounds nuw i8, ptr %8, i64 5
  %24 = load i8, ptr %23, align 1, !tbaa !14
  %25 = zext i8 %24 to i32
  %26 = or disjoint i32 %22, %25
  %27 = add i32 %26, %1
  %28 = add i32 %1, 6
  %29 = sext i32 %27 to i64
  %30 = getelementptr inbounds i8, ptr %0, i64 %29
  %31 = zext nneg i32 %16 to i64
  %32 = zext nneg i32 %16 to i64
  br label %33

33:                                               ; preds = %18, %181
  %34 = phi i64 [ 0, %18 ], [ %182, %181 ]
  %35 = trunc i64 %34 to i32
  %36 = mul i32 %35, 12
  %37 = add i32 %28, %36
  %38 = zext i32 %37 to i64
  %39 = getelementptr inbounds nuw i8, ptr %0, i64 %38
  %40 = getelementptr inbounds nuw i8, ptr %39, i64 6
  %41 = load i8, ptr %40, align 1, !tbaa !14
  %42 = zext i8 %41 to i32
  %43 = shl nuw nsw i32 %42, 8
  %44 = getelementptr inbounds nuw i8, ptr %39, i64 7
  %45 = load i8, ptr %44, align 1, !tbaa !14
  %46 = zext i8 %45 to i32
  %47 = or disjoint i32 %43, %46
  %48 = icmp eq i32 %4, %47
  br i1 %48, label %49, label %181

49:                                               ; preds = %33
  %50 = load i8, ptr %39, align 1, !tbaa !14
  %51 = zext i8 %50 to i16
  %52 = shl nuw i16 %51, 8
  %53 = getelementptr inbounds nuw i8, ptr %39, i64 1
  %54 = load i8, ptr %53, align 1, !tbaa !14
  %55 = zext i8 %54 to i16
  %56 = or disjoint i16 %52, %55
  %57 = getelementptr inbounds nuw i8, ptr %39, i64 2
  %58 = load i8, ptr %57, align 1, !tbaa !14
  %59 = zext i8 %58 to i16
  %60 = shl nuw i16 %59, 8
  %61 = getelementptr inbounds nuw i8, ptr %39, i64 3
  %62 = load i8, ptr %61, align 1, !tbaa !14
  %63 = zext i8 %62 to i16
  %64 = or disjoint i16 %60, %63
  %65 = getelementptr inbounds nuw i8, ptr %39, i64 4
  %66 = load i8, ptr %65, align 1, !tbaa !14
  %67 = zext i8 %66 to i16
  %68 = shl nuw i16 %67, 8
  %69 = getelementptr inbounds nuw i8, ptr %39, i64 5
  %70 = load i8, ptr %69, align 1, !tbaa !14
  %71 = zext i8 %70 to i16
  %72 = or disjoint i16 %68, %71
  %73 = icmp eq i16 %56, 0
  br i1 %73, label %80, label %74

74:                                               ; preds = %49
  %75 = icmp eq i16 %56, 3
  %76 = icmp eq i16 %64, 1
  %77 = icmp eq i16 %64, 10
  %78 = or i1 %76, %77
  %79 = select i1 %75, i1 %78, i1 false
  br i1 %79, label %80, label %181

80:                                               ; preds = %74, %49
  %81 = getelementptr inbounds nuw i8, ptr %39, i64 8
  %82 = load i8, ptr %81, align 1, !tbaa !14
  %83 = zext i8 %82 to i32
  %84 = shl nuw nsw i32 %83, 8
  %85 = getelementptr inbounds nuw i8, ptr %39, i64 9
  %86 = load i8, ptr %85, align 1, !tbaa !14
  %87 = zext i8 %86 to i32
  %88 = or disjoint i32 %84, %87
  %89 = getelementptr inbounds nuw i8, ptr %39, i64 10
  %90 = load i8, ptr %89, align 1, !tbaa !14
  %91 = zext i8 %90 to i64
  %92 = shl nuw nsw i64 %91, 8
  %93 = getelementptr inbounds nuw i8, ptr %39, i64 11
  %94 = load i8, ptr %93, align 1, !tbaa !14
  %95 = zext i8 %94 to i64
  %96 = getelementptr inbounds nuw i8, ptr %30, i64 %92
  %97 = getelementptr inbounds nuw i8, ptr %96, i64 %95
  %98 = tail call fastcc i32 @stbtt__CompareUTF8toUTF16_bigendian_prefix(ptr noundef %2, i32 noundef %3, ptr noundef %97, i32 noundef %88) #25
  %99 = icmp sgt i32 %98, -1
  br i1 %99, label %100, label %181

100:                                              ; preds = %80
  %101 = add nuw nsw i64 %34, 1
  %102 = icmp samesign ult i64 %101, %31
  br i1 %102, label %103, label %179

103:                                              ; preds = %100
  %104 = getelementptr inbounds nuw i8, ptr %39, i64 18
  %105 = load i8, ptr %104, align 1, !tbaa !14
  %106 = zext i8 %105 to i32
  %107 = shl nuw nsw i32 %106, 8
  %108 = getelementptr inbounds nuw i8, ptr %39, i64 19
  %109 = load i8, ptr %108, align 1, !tbaa !14
  %110 = zext i8 %109 to i32
  %111 = or disjoint i32 %107, %110
  %112 = icmp eq i32 %5, %111
  br i1 %112, label %113, label %179

113:                                              ; preds = %103
  %114 = getelementptr inbounds nuw i8, ptr %39, i64 12
  %115 = load i8, ptr %114, align 1, !tbaa !14
  %116 = zext i8 %115 to i16
  %117 = shl nuw i16 %116, 8
  %118 = getelementptr inbounds nuw i8, ptr %39, i64 13
  %119 = load i8, ptr %118, align 1, !tbaa !14
  %120 = zext i8 %119 to i16
  %121 = or disjoint i16 %117, %120
  %122 = icmp eq i16 %121, %56
  br i1 %122, label %123, label %179

123:                                              ; preds = %113
  %124 = getelementptr inbounds nuw i8, ptr %39, i64 14
  %125 = load i8, ptr %124, align 1, !tbaa !14
  %126 = zext i8 %125 to i16
  %127 = shl nuw i16 %126, 8
  %128 = getelementptr inbounds nuw i8, ptr %39, i64 15
  %129 = load i8, ptr %128, align 1, !tbaa !14
  %130 = zext i8 %129 to i16
  %131 = or disjoint i16 %127, %130
  %132 = icmp eq i16 %131, %64
  br i1 %132, label %133, label %179

133:                                              ; preds = %123
  %134 = getelementptr inbounds nuw i8, ptr %39, i64 16
  %135 = load i8, ptr %134, align 1, !tbaa !14
  %136 = zext i8 %135 to i16
  %137 = shl nuw i16 %136, 8
  %138 = getelementptr inbounds nuw i8, ptr %39, i64 17
  %139 = load i8, ptr %138, align 1, !tbaa !14
  %140 = zext i8 %139 to i16
  %141 = or disjoint i16 %137, %140
  %142 = icmp eq i16 %141, %72
  br i1 %142, label %143, label %179

143:                                              ; preds = %133
  %144 = getelementptr inbounds nuw i8, ptr %39, i64 20
  %145 = load i8, ptr %144, align 1, !tbaa !14
  %146 = zext i8 %145 to i16
  %147 = shl nuw i16 %146, 8
  %148 = getelementptr inbounds nuw i8, ptr %39, i64 21
  %149 = load i8, ptr %148, align 1, !tbaa !14
  %150 = zext i8 %149 to i16
  %151 = or disjoint i16 %147, %150
  %152 = zext i16 %151 to i32
  %153 = getelementptr inbounds nuw i8, ptr %39, i64 22
  %154 = load i8, ptr %153, align 1, !tbaa !14
  %155 = zext i8 %154 to i64
  %156 = shl nuw nsw i64 %155, 8
  %157 = getelementptr inbounds nuw i8, ptr %39, i64 23
  %158 = load i8, ptr %157, align 1, !tbaa !14
  %159 = zext i8 %158 to i64
  %160 = icmp eq i16 %151, 0
  br i1 %160, label %161, label %163

161:                                              ; preds = %143
  %162 = icmp eq i32 %98, %3
  br i1 %162, label %184, label %181

163:                                              ; preds = %143
  %164 = icmp slt i32 %98, %3
  br i1 %164, label %165, label %181

165:                                              ; preds = %163
  %166 = zext nneg i32 %98 to i64
  %167 = getelementptr inbounds nuw i8, ptr %2, i64 %166
  %168 = load i8, ptr %167, align 1, !tbaa !14
  %169 = icmp eq i8 %168, 32
  br i1 %169, label %170, label %181

170:                                              ; preds = %165
  %171 = add nuw nsw i32 %98, 1
  %172 = zext nneg i32 %171 to i64
  %173 = getelementptr inbounds nuw i8, ptr %2, i64 %172
  %174 = sub nsw i32 %3, %171
  %175 = getelementptr inbounds nuw i8, ptr %30, i64 %156
  %176 = getelementptr inbounds nuw i8, ptr %175, i64 %159
  %177 = tail call fastcc i32 @stbtt__CompareUTF8toUTF16_bigendian_prefix(ptr noundef nonnull readonly %173, i32 noundef %174, ptr noundef readonly %176, i32 noundef %152) #25
  %178 = icmp eq i32 %174, %177
  br i1 %178, label %184, label %181

179:                                              ; preds = %133, %123, %113, %103, %100
  %180 = icmp eq i32 %98, %3
  br i1 %180, label %184, label %181

181:                                              ; preds = %74, %163, %165, %170, %161, %179, %80, %33
  %182 = add nuw nsw i64 %34, 1
  %183 = icmp eq i64 %182, %32
  br i1 %183, label %184, label %33, !llvm.loop !207

184:                                              ; preds = %181, %161, %170, %179, %6
  %185 = phi i32 [ 0, %6 ], [ 0, %181 ], [ 1, %179 ], [ 1, %170 ], [ 1, %161 ]
  ret i32 %185
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define internal fastcc i32 @stbtt__CompareUTF8toUTF16_bigendian_prefix(ptr noundef readonly captures(none) %0, i32 noundef %1, ptr noundef readonly captures(none) %2, i32 noundef %3) unnamed_addr #20 {
  %5 = icmp eq i32 %3, 0
  br i1 %5, label %144, label %6

6:                                                ; preds = %4, %137
  %7 = phi ptr [ %141, %137 ], [ %2, %4 ]
  %8 = phi i32 [ %142, %137 ], [ %3, %4 ]
  %9 = phi i32 [ %138, %137 ], [ 0, %4 ]
  %10 = load i8, ptr %7, align 1, !tbaa !14
  %11 = zext i8 %10 to i32
  %12 = shl nuw nsw i32 %11, 8
  %13 = getelementptr inbounds nuw i8, ptr %7, i64 1
  %14 = load i8, ptr %13, align 1, !tbaa !14
  %15 = zext i8 %14 to i32
  %16 = or disjoint i32 %12, %15
  %17 = icmp samesign ult i32 %16, 128
  br i1 %17, label %18, label %27

18:                                               ; preds = %6
  %19 = icmp slt i32 %9, %1
  br i1 %19, label %20, label %144

20:                                               ; preds = %18
  %21 = add nsw i32 %9, 1
  %22 = sext i32 %9 to i64
  %23 = getelementptr inbounds i8, ptr %0, i64 %22
  %24 = load i8, ptr %23, align 1, !tbaa !14
  %25 = zext i8 %24 to i32
  %26 = icmp eq i32 %16, %25
  br i1 %26, label %137, label %144

27:                                               ; preds = %6
  %28 = icmp ult i8 %10, 8
  br i1 %28, label %29, label %49

29:                                               ; preds = %27
  %30 = add nsw i32 %9, 1
  %31 = icmp slt i32 %30, %1
  br i1 %31, label %32, label %144

32:                                               ; preds = %29
  %33 = sext i32 %9 to i64
  %34 = getelementptr inbounds i8, ptr %0, i64 %33
  %35 = load i8, ptr %34, align 1, !tbaa !14
  %36 = zext i8 %35 to i32
  %37 = lshr i32 %16, 6
  %38 = or disjoint i32 %37, 192
  %39 = icmp eq i32 %38, %36
  br i1 %39, label %40, label %144

40:                                               ; preds = %32
  %41 = add nsw i32 %9, 2
  %42 = sext i32 %30 to i64
  %43 = getelementptr inbounds i8, ptr %0, i64 %42
  %44 = load i8, ptr %43, align 1, !tbaa !14
  %45 = zext i8 %44 to i32
  %46 = and i32 %15, 63
  %47 = or disjoint i32 %46, 128
  %48 = icmp eq i32 %47, %45
  br i1 %48, label %137, label %144

49:                                               ; preds = %27
  %50 = and i8 %10, -4
  %51 = icmp eq i8 %50, -40
  br i1 %51, label %52, label %105

52:                                               ; preds = %49
  %53 = getelementptr inbounds nuw i8, ptr %7, i64 2
  %54 = add nsw i32 %9, 3
  %55 = icmp slt i32 %54, %1
  br i1 %55, label %56, label %144

56:                                               ; preds = %52
  %57 = getelementptr inbounds nuw i8, ptr %7, i64 3
  %58 = load i8, ptr %57, align 1, !tbaa !14
  %59 = load i8, ptr %53, align 1, !tbaa !14
  %60 = zext i8 %59 to i32
  %61 = shl nuw nsw i32 %60, 8
  %62 = zext i8 %58 to i32
  %63 = or disjoint i32 %61, %62
  %64 = shl nuw nsw i32 %16, 10
  %65 = add nsw i32 %64, -56613888
  %66 = add nuw nsw i32 %65, %63
  %67 = sext i32 %9 to i64
  %68 = getelementptr inbounds i8, ptr %0, i64 %67
  %69 = load i8, ptr %68, align 1, !tbaa !14
  %70 = zext i8 %69 to i32
  %71 = lshr i32 %66, 18
  %72 = add nuw nsw i32 %71, 240
  %73 = icmp eq i32 %72, %70
  br i1 %73, label %74, label %144

74:                                               ; preds = %56
  %75 = sext i32 %9 to i64
  %76 = getelementptr i8, ptr %0, i64 %75
  %77 = getelementptr i8, ptr %76, i64 1
  %78 = load i8, ptr %77, align 1, !tbaa !14
  %79 = zext i8 %78 to i32
  %80 = lshr i32 %66, 12
  %81 = and i32 %80, 63
  %82 = or disjoint i32 %81, 128
  %83 = icmp eq i32 %82, %79
  br i1 %83, label %84, label %144

84:                                               ; preds = %74
  %85 = sext i32 %9 to i64
  %86 = getelementptr i8, ptr %0, i64 %85
  %87 = getelementptr i8, ptr %86, i64 2
  %88 = load i8, ptr %87, align 1, !tbaa !14
  %89 = zext i8 %88 to i32
  %90 = lshr i32 %66, 6
  %91 = and i32 %90, 63
  %92 = or disjoint i32 %91, 128
  %93 = icmp eq i32 %92, %89
  br i1 %93, label %94, label %144

94:                                               ; preds = %84
  %95 = sext i32 %54 to i64
  %96 = getelementptr inbounds i8, ptr %0, i64 %95
  %97 = load i8, ptr %96, align 1, !tbaa !14
  %98 = zext i8 %97 to i32
  %99 = and i32 %62, 63
  %100 = or disjoint i32 %99, 128
  %101 = icmp eq i32 %100, %98
  br i1 %101, label %102, label %144

102:                                              ; preds = %94
  %103 = add nsw i32 %9, 4
  %104 = add nsw i32 %8, -2
  br label %137

105:                                              ; preds = %49
  %106 = icmp ne i8 %50, -36
  %107 = add nsw i32 %9, 2
  %108 = icmp slt i32 %107, %1
  %109 = select i1 %106, i1 %108, i1 false
  br i1 %109, label %110, label %144

110:                                              ; preds = %105
  %111 = sext i32 %9 to i64
  %112 = getelementptr inbounds i8, ptr %0, i64 %111
  %113 = load i8, ptr %112, align 1, !tbaa !14
  %114 = zext i8 %113 to i32
  %115 = lshr i32 %11, 4
  %116 = or disjoint i32 %115, 224
  %117 = icmp eq i32 %116, %114
  br i1 %117, label %118, label %144

118:                                              ; preds = %110
  %119 = sext i32 %9 to i64
  %120 = getelementptr i8, ptr %0, i64 %119
  %121 = getelementptr i8, ptr %120, i64 1
  %122 = load i8, ptr %121, align 1, !tbaa !14
  %123 = zext i8 %122 to i32
  %124 = lshr i32 %16, 6
  %125 = and i32 %124, 63
  %126 = or disjoint i32 %125, 128
  %127 = icmp eq i32 %126, %123
  br i1 %127, label %128, label %144

128:                                              ; preds = %118
  %129 = add nsw i32 %9, 3
  %130 = sext i32 %107 to i64
  %131 = getelementptr inbounds i8, ptr %0, i64 %130
  %132 = load i8, ptr %131, align 1, !tbaa !14
  %133 = zext i8 %132 to i32
  %134 = and i32 %15, 63
  %135 = or disjoint i32 %134, 128
  %136 = icmp eq i32 %135, %133
  br i1 %136, label %137, label %144

137:                                              ; preds = %102, %40, %128, %20
  %138 = phi i32 [ %21, %20 ], [ %41, %40 ], [ %103, %102 ], [ %129, %128 ]
  %139 = phi i32 [ %8, %20 ], [ %8, %40 ], [ %104, %102 ], [ %8, %128 ]
  %140 = phi ptr [ %7, %20 ], [ %7, %40 ], [ %53, %102 ], [ %7, %128 ]
  %141 = getelementptr inbounds nuw i8, ptr %140, i64 2
  %142 = add nsw i32 %139, -2
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %144, label %6, !llvm.loop !208

144:                                              ; preds = %137, %128, %110, %105, %40, %32, %29, %20, %18, %118, %94, %84, %74, %56, %52, %4
  %145 = phi i32 [ 0, %4 ], [ %138, %137 ], [ -1, %52 ], [ -1, %56 ], [ -1, %74 ], [ -1, %84 ], [ -1, %18 ], [ -1, %20 ], [ -1, %29 ], [ -1, %118 ], [ -1, %32 ], [ -1, %40 ], [ -1, %94 ], [ -1, %105 ], [ -1, %110 ], [ -1, %128 ]
  ret i32 %145
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.smin.i16(i16, i16) #24

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.smax.i16(i16, i16) #24

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #24

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #24

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.copysign.f32(float, float) #24

attributes #0 = { nofree norecurse nosync nounwind memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nofree norecurse nosync nounwind willreturn memory(read, inaccessiblemem: none, target_mem0: none, target_mem1: none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { mustprogress nofree norecurse nosync nounwind willreturn memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nofree norecurse nosync nounwind memory(read, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { mustprogress nofree nosync nounwind willreturn memory(none) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #10 = { mustprogress nofree nosync nounwind willreturn memory(argmem: readwrite) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #11 = { nounwind "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #12 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #13 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #14 = { nofree norecurse nosync nounwind memory(readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #15 = { nofree norecurse nosync nounwind memory(write, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #16 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #17 = { nofree norecurse nosync nounwind memory(argmem: write) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #18 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #19 = { nofree nounwind memory(read) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #20 = { nofree norecurse nosync nounwind memory(argmem: read) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #21 = { mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, argmem: none, inaccessiblemem: none, target_mem0: none, target_mem1: none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #22 = { mustprogress nofree nounwind willreturn memory(read) "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #23 = { mustprogress nofree norecurse nosync nounwind willreturn memory(write, argmem: readwrite, inaccessiblemem: none, target_mem0: none, target_mem1: none) "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #24 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #25 = { nobuiltin "no-builtins" }
attributes #26 = { nounwind }
attributes #27 = { nobuiltin nounwind "no-builtins" }
attributes #28 = { nobuiltin nounwind willreturn memory(none) "no-builtins" }
attributes #29 = { nobuiltin nounwind willreturn memory(read) "no-builtins" }

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
!8 = !{!9, !11, i64 8}
!9 = !{!"stbtt_fontinfo", !10, i64 0, !11, i64 8, !5, i64 16, !5, i64 20, !5, i64 24, !5, i64 28, !5, i64 32, !5, i64 36, !5, i64 40, !5, i64 44, !5, i64 48, !5, i64 52, !5, i64 56, !5, i64 60, !12, i64 64, !12, i64 80, !12, i64 96, !12, i64 112, !12, i64 128, !12, i64 144}
!10 = !{!"any pointer", !6, i64 0}
!11 = !{!"p1 omnipotent char", !10, i64 0}
!12 = !{!"", !11, i64 0, !5, i64 8, !5, i64 12}
!13 = !{!9, !5, i64 56}
!14 = !{!6, !6, i64 0}
!15 = distinct !{!15, !16, !17}
!16 = !{!"llvm.loop.mustprogress"}
!17 = !{!"llvm.loop.unroll.disable"}
!18 = distinct !{!18, !16, !17}
!19 = !{!9, !5, i64 76}
!20 = !{!10, !10, i64 0}
!21 = !{!22, !23, i64 0}
!22 = !{!"", !23, i64 0, !23, i64 2, !23, i64 4, !23, i64 6, !23, i64 8, !23, i64 10, !6, i64 12, !6, i64 13}
!23 = !{!"short", !6, i64 0}
!24 = !{!22, !23, i64 2}
!25 = !{!22, !23, i64 4}
!26 = !{!22, !23, i64 6}
!27 = distinct !{!27, !16, !17}
!28 = distinct !{!28, !16, !17}
!29 = !{!30, !10, i64 40}
!30 = !{!"", !5, i64 0, !5, i64 4, !31, i64 8, !31, i64 12, !31, i64 16, !31, i64 20, !5, i64 24, !5, i64 28, !5, i64 32, !5, i64 36, !10, i64 40, !5, i64 48}
!31 = !{!"float", !6, i64 0}
!32 = !{!30, !5, i64 48}
!33 = !{!9, !5, i64 20}
!34 = !{!9, !5, i64 60}
!35 = !{!9, !5, i64 32}
!36 = !{!9, !5, i64 24}
!37 = !{!9, !5, i64 36}
!38 = !{!9, !5, i64 40}
!39 = !{!9, !5, i64 44}
!40 = !{!41, !5, i64 0}
!41 = !{!"stbtt_kerningentry", !5, i64 0, !5, i64 4, !5, i64 8}
!42 = !{!41, !5, i64 4}
!43 = !{!41, !5, i64 8}
!44 = distinct !{!44, !16, !17}
!45 = !{!9, !5, i64 48}
!46 = distinct !{!46, !16, !17}
!47 = distinct !{!47, !16, !17}
!48 = distinct !{!48, !16, !17}
!49 = distinct !{!49, !16, !17}
!50 = distinct !{!50, !16, !17}
!51 = distinct !{!51, !16, !17}
!52 = !{!9, !5, i64 16}
!53 = distinct !{!53, !16, !17}
!54 = !{!9, !5, i64 28}
!55 = !{!9, !5, i64 52}
!56 = distinct !{!56, !16, !17}
!57 = !{!11, !11, i64 0}
!58 = !{!31, !31, i64 0}
!59 = !{!60, !31, i64 8}
!60 = !{!"", !23, i64 0, !23, i64 2, !23, i64 4, !23, i64 6, !31, i64 8, !31, i64 12, !31, i64 16}
!61 = !{!60, !31, i64 12}
!62 = !{!63, !31, i64 0}
!63 = !{!"", !31, i64 0, !31, i64 4, !31, i64 8, !31, i64 12, !31, i64 16, !31, i64 20, !31, i64 24, !31, i64 28}
!64 = !{!63, !31, i64 4}
!65 = !{!60, !23, i64 4}
!66 = !{!60, !23, i64 0}
!67 = !{!63, !31, i64 16}
!68 = !{!60, !23, i64 6}
!69 = !{!60, !23, i64 2}
!70 = !{!63, !31, i64 20}
!71 = !{!63, !31, i64 8}
!72 = !{!63, !31, i64 12}
!73 = !{!63, !31, i64 24}
!74 = !{!63, !31, i64 28}
!75 = !{!60, !31, i64 16}
!76 = !{!77, !5, i64 36}
!77 = !{!"stbtt_pack_context", !10, i64 0, !10, i64 8, !5, i64 16, !5, i64 20, !5, i64 24, !5, i64 28, !5, i64 32, !5, i64 36, !5, i64 40, !11, i64 48, !10, i64 56}
!78 = !{!77, !5, i64 40}
!79 = !{!77, !5, i64 32}
!80 = !{!81, !31, i64 0}
!81 = !{!"", !31, i64 0, !5, i64 4, !82, i64 8, !5, i64 16, !10, i64 24, !6, i64 32, !6, i64 33}
!82 = !{!"p1 int", !10, i64 0}
!83 = !{!81, !6, i64 32}
!84 = !{!81, !6, i64 33}
!85 = !{!81, !5, i64 16}
!86 = !{!81, !82, i64 8}
!87 = !{!81, !5, i64 4}
!88 = !{!89, !5, i64 16}
!89 = !{!"stbrp_rect", !5, i64 0, !5, i64 4, !5, i64 8, !5, i64 12, !5, i64 16, !5, i64 20}
!90 = !{!89, !5, i64 12}
!91 = !{!77, !5, i64 28}
!92 = distinct !{!92, !16, !17}
!93 = distinct !{!93, !16, !17}
!94 = distinct !{!94, !16, !17}
!95 = distinct !{!95, !16, !17}
!96 = distinct !{!96, !16, !17}
!97 = distinct !{!97, !16, !17}
!98 = distinct !{!98, !16, !17}
!99 = distinct !{!99, !16, !17}
!100 = distinct !{!100, !16, !17}
!101 = distinct !{!101, !16, !17}
!102 = distinct !{!102, !16, !17}
!103 = distinct !{!103, !16, !17}
!104 = distinct !{!104, !16, !17}
!105 = distinct !{!105, !16, !17}
!106 = distinct !{!106, !16, !17}
!107 = distinct !{!107, !16, !17}
!108 = !{!89, !5, i64 20}
!109 = !{!81, !10, i64 24}
!110 = !{!89, !5, i64 0}
!111 = !{!89, !5, i64 4}
!112 = !{!77, !11, i64 48}
!113 = !{!77, !5, i64 24}
!114 = !{!115, !23, i64 0}
!115 = !{!"", !23, i64 0, !23, i64 2, !23, i64 4, !23, i64 6, !31, i64 8, !31, i64 12, !31, i64 16, !31, i64 20, !31, i64 24}
!116 = !{!115, !23, i64 2}
!117 = !{!115, !23, i64 4}
!118 = !{!115, !23, i64 6}
!119 = !{!115, !31, i64 16}
!120 = !{!115, !31, i64 8}
!121 = !{!115, !31, i64 12}
!122 = !{!115, !31, i64 20}
!123 = !{!115, !31, i64 24}
!124 = !{i64 0, i64 2, !125, i64 2, i64 2, !125, i64 4, i64 2, !125, i64 6, i64 2, !125, i64 8, i64 4, !58, i64 12, i64 4, !58, i64 16, i64 4, !58, i64 20, i64 4, !58, i64 24, i64 4, !58}
!125 = !{!23, !23, i64 0}
!126 = distinct !{!126, !16, !17}
!127 = distinct !{!127, !16, !17}
!128 = !{!77, !10, i64 8}
!129 = !{!130, !5, i64 0}
!130 = !{!"", !5, i64 0, !5, i64 4, !5, i64 8, !5, i64 12, !5, i64 16}
!131 = !{!130, !5, i64 4}
!132 = !{!130, !5, i64 8}
!133 = !{!130, !5, i64 12}
!134 = !{!130, !5, i64 16}
!135 = distinct !{!135, !16, !17}
!136 = distinct !{!136, !16, !17}
!137 = distinct !{!137, !16, !17}
!138 = distinct !{!138, !16, !17}
!139 = distinct !{!139, !16, !17}
!140 = distinct !{!140, !16, !17}
!141 = !{!22, !6, i64 12}
!142 = distinct !{!142, !16, !17}
!143 = distinct !{!143, !16, !17}
!144 = distinct !{!144, !16, !17}
!145 = distinct !{!145, !16, !17}
!146 = distinct !{!146, !16, !17}
!147 = !{!9, !10, i64 0}
!148 = distinct !{!148, !16, !17}
!149 = distinct !{!149, !17}
!150 = !{!151, !151, i64 0}
!151 = !{!"long", !6, i64 0}
!152 = !{!153, !5, i64 0}
!153 = !{!"FontResult", !5, i64 0, !5, i64 4, !5, i64 8, !6, i64 12, !6, i64 1036, !6, i64 2060, !6, i64 3084, !6, i64 4108, !6, i64 5132, !5, i64 6156, !6, i64 6160, !6, i64 6672, !6, i64 7184, !6, i64 7696}
!154 = !{!153, !5, i64 4}
!155 = !{!156, !5, i64 32}
!156 = !{!"", !5, i64 0, !5, i64 4, !5, i64 8, !5, i64 12, !5, i64 16, !5, i64 20, !5, i64 24, !5, i64 28, !5, i64 32}
!157 = !{!156, !5, i64 8}
!158 = !{!156, !5, i64 12}
!159 = !{!156, !5, i64 16}
!160 = !{!156, !5, i64 20}
!161 = !{!156, !5, i64 24}
!162 = !{!156, !5, i64 28}
!163 = !{!156, !5, i64 0}
!164 = !{!156, !5, i64 4}
!165 = distinct !{!165, !16, !17}
!166 = distinct !{!166, !16, !17}
!167 = !{!153, !5, i64 8}
!168 = !{!153, !5, i64 6156}
!169 = distinct !{!169, !16, !17}
!170 = distinct !{!170, !16, !17}
!171 = !{i64 0, i64 4, !4, i64 4, i64 4, !4, i64 8, i64 4, !4, i64 12, i64 1024, !14, i64 1036, i64 1024, !14, i64 2060, i64 1024, !14, i64 3084, i64 1024, !14, i64 4108, i64 1024, !14, i64 5132, i64 1024, !14, i64 6156, i64 4, !4, i64 6160, i64 512, !14, i64 6672, i64 512, !14, i64 7184, i64 512, !14, i64 7696, i64 4194304, !14}
!172 = distinct !{!172, !16, !17}
!173 = distinct !{!173, !16, !17}
!174 = distinct !{!174, !16, !17}
!175 = distinct !{!175, !16, !17}
!176 = distinct !{!176, !16, !17}
!177 = !{!12, !5, i64 8}
!178 = !{!12, !5, i64 12}
!179 = !{!12, !11, i64 0}
!180 = !{!30, !5, i64 0}
!181 = !{!30, !31, i64 16}
!182 = !{!30, !31, i64 20}
!183 = !{!30, !5, i64 28}
!184 = !{!30, !5, i64 4}
!185 = !{!30, !5, i64 36}
!186 = !{!30, !5, i64 24}
!187 = !{!30, !5, i64 32}
!188 = !{!22, !23, i64 8}
!189 = !{!22, !23, i64 10}
!190 = distinct !{!190, !16, !17}
!191 = distinct !{!191, !17}
!192 = distinct !{!192, !17}
!193 = distinct !{!193, !16, !17}
!194 = distinct !{!194, !16, !17}
!195 = distinct !{!195, !16, !17}
!196 = distinct !{!196, !16, !17}
!197 = !{!9, !5, i64 156}
!198 = distinct !{!198, !16, !17}
!199 = !{i64 0, i64 8, !57, i64 8, i64 4, !4, i64 12, i64 4, !4}
!200 = distinct !{!200, !16, !17}
!201 = !{!30, !31, i64 8}
!202 = !{!30, !31, i64 12}
!203 = distinct !{!203, !16, !17}
!204 = distinct !{!204, !16, !17}
!205 = distinct !{!205, !16, !17}
!206 = distinct !{!206, !16, !17}
!207 = distinct !{!207, !16, !17}
!208 = distinct !{!208, !16, !17}
