; ModuleID = 'bpftrace'
source_filename = "bpftrace"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf-pc-linux"

%"struct map_t" = type { ptr, ptr, ptr, ptr }
%"struct map_t.0" = type { ptr, ptr, ptr, ptr }
%"struct map_t.1" = type { ptr, ptr }
%"struct map_t.2" = type { ptr, ptr, ptr, ptr }
%helper_error_t = type <{ i64, i64, i32 }>

@LICENSE = global [4 x i8] c"GPL\00", section "license"
@AT_x = dso_local global %"struct map_t" zeroinitializer, section ".maps", !dbg !0
@AT_y = dso_local global %"struct map_t.0" zeroinitializer, section ".maps", !dbg !16
@ringbuf = dso_local global %"struct map_t.1" zeroinitializer, section ".maps", !dbg !18
@event_loss_counter = dso_local global %"struct map_t.2" zeroinitializer, section ".maps", !dbg !32

; Function Attrs: nounwind
declare i64 @llvm.bpf.pseudo(i64 %0, i64 %1) #0

define i64 @kprobe_f_1(ptr %0) section "s_kprobe_f_1" !dbg !47 {
entry:
  %key10 = alloca i32, align 4
  %helper_error_t5 = alloca %helper_error_t, align 8
  %"@y_val" = alloca i64, align 8
  %"@y_key" = alloca i64, align 8
  %key = alloca i32, align 4
  %helper_error_t = alloca %helper_error_t, align 8
  %"@x_val" = alloca i64, align 8
  %"@x_key" = alloca i64, align 8
  %get_pid_tgid = call i64 inttoptr (i64 14 to ptr)()
  %1 = lshr i64 %get_pid_tgid, 32
  %pid = trunc i64 %1 to i32
  call void @llvm.lifetime.start.p0(i64 -1, ptr %"@x_key")
  store i64 0, ptr %"@x_key", align 8
  call void @llvm.lifetime.start.p0(i64 -1, ptr %"@x_val")
  %2 = zext i32 %pid to i64
  store i64 %2, ptr %"@x_val", align 8
  %update_elem = call i64 inttoptr (i64 2 to ptr)(ptr @AT_x, ptr %"@x_key", ptr %"@x_val", i64 0)
  %3 = trunc i64 %update_elem to i32
  %4 = icmp sge i32 %3, 0
  br i1 %4, label %helper_merge, label %helper_failure

helper_failure:                                   ; preds = %entry
  call void @llvm.lifetime.start.p0(i64 -1, ptr %helper_error_t)
  %5 = getelementptr %helper_error_t, ptr %helper_error_t, i64 0, i32 0
  store i64 30006, ptr %5, align 8
  %6 = getelementptr %helper_error_t, ptr %helper_error_t, i64 0, i32 1
  store i64 0, ptr %6, align 8
  %7 = getelementptr %helper_error_t, ptr %helper_error_t, i64 0, i32 2
  store i32 %3, ptr %7, align 4
  %ringbuf_output = call i64 inttoptr (i64 130 to ptr)(ptr @ringbuf, ptr %helper_error_t, i64 20, i64 0)
  %ringbuf_loss = icmp slt i64 %ringbuf_output, 0
  br i1 %ringbuf_loss, label %event_loss_counter, label %counter_merge

helper_merge:                                     ; preds = %counter_merge, %entry
  call void @llvm.lifetime.end.p0(i64 -1, ptr %"@x_val")
  call void @llvm.lifetime.end.p0(i64 -1, ptr %"@x_key")
  %get_pid_tgid1 = call i64 inttoptr (i64 14 to ptr)()
  %tid = trunc i64 %get_pid_tgid1 to i32
  call void @llvm.lifetime.start.p0(i64 -1, ptr %"@y_key")
  store i64 0, ptr %"@y_key", align 8
  call void @llvm.lifetime.start.p0(i64 -1, ptr %"@y_val")
  %8 = zext i32 %tid to i64
  store i64 %8, ptr %"@y_val", align 8
  %update_elem2 = call i64 inttoptr (i64 2 to ptr)(ptr @AT_y, ptr %"@y_key", ptr %"@y_val", i64 0)
  %9 = trunc i64 %update_elem2 to i32
  %10 = icmp sge i32 %9, 0
  br i1 %10, label %helper_merge4, label %helper_failure3

event_loss_counter:                               ; preds = %helper_failure
  call void @llvm.lifetime.start.p0(i64 -1, ptr %key)
  store i32 0, ptr %key, align 4
  %lookup_elem = call ptr inttoptr (i64 1 to ptr)(ptr @event_loss_counter, ptr %key)
  %map_lookup_cond = icmp ne ptr %lookup_elem, null
  br i1 %map_lookup_cond, label %lookup_success, label %lookup_failure

counter_merge:                                    ; preds = %lookup_merge, %helper_failure
  call void @llvm.lifetime.end.p0(i64 -1, ptr %helper_error_t)
  br label %helper_merge

lookup_success:                                   ; preds = %event_loss_counter
  %11 = atomicrmw add ptr %lookup_elem, i64 1 seq_cst, align 8
  br label %lookup_merge

lookup_failure:                                   ; preds = %event_loss_counter
  br label %lookup_merge

lookup_merge:                                     ; preds = %lookup_failure, %lookup_success
  call void @llvm.lifetime.end.p0(i64 -1, ptr %key)
  br label %counter_merge

helper_failure3:                                  ; preds = %helper_merge
  call void @llvm.lifetime.start.p0(i64 -1, ptr %helper_error_t5)
  %12 = getelementptr %helper_error_t, ptr %helper_error_t5, i64 0, i32 0
  store i64 30006, ptr %12, align 8
  %13 = getelementptr %helper_error_t, ptr %helper_error_t5, i64 0, i32 1
  store i64 1, ptr %13, align 8
  %14 = getelementptr %helper_error_t, ptr %helper_error_t5, i64 0, i32 2
  store i32 %9, ptr %14, align 4
  %ringbuf_output6 = call i64 inttoptr (i64 130 to ptr)(ptr @ringbuf, ptr %helper_error_t5, i64 20, i64 0)
  %ringbuf_loss9 = icmp slt i64 %ringbuf_output6, 0
  br i1 %ringbuf_loss9, label %event_loss_counter7, label %counter_merge8

helper_merge4:                                    ; preds = %counter_merge8, %helper_merge
  call void @llvm.lifetime.end.p0(i64 -1, ptr %"@y_val")
  call void @llvm.lifetime.end.p0(i64 -1, ptr %"@y_key")
  ret i64 0

event_loss_counter7:                              ; preds = %helper_failure3
  call void @llvm.lifetime.start.p0(i64 -1, ptr %key10)
  store i32 0, ptr %key10, align 4
  %lookup_elem11 = call ptr inttoptr (i64 1 to ptr)(ptr @event_loss_counter, ptr %key10)
  %map_lookup_cond15 = icmp ne ptr %lookup_elem11, null
  br i1 %map_lookup_cond15, label %lookup_success12, label %lookup_failure13

counter_merge8:                                   ; preds = %lookup_merge14, %helper_failure3
  call void @llvm.lifetime.end.p0(i64 -1, ptr %helper_error_t5)
  br label %helper_merge4

lookup_success12:                                 ; preds = %event_loss_counter7
  %15 = atomicrmw add ptr %lookup_elem11, i64 1 seq_cst, align 8
  br label %lookup_merge14

lookup_failure13:                                 ; preds = %event_loss_counter7
  br label %lookup_merge14

lookup_merge14:                                   ; preds = %lookup_failure13, %lookup_success12
  call void @llvm.lifetime.end.p0(i64 -1, ptr %key10)
  br label %counter_merge8
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg %0, ptr nocapture %1) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg %0, ptr nocapture %1) #1

attributes #0 = { nounwind }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!llvm.dbg.cu = !{!44}
!llvm.module.flags = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "AT_x", linkageName: "global", scope: !2, file: !2, type: !3, isLocal: false, isDefinition: true)
!2 = !DIFile(filename: "bpftrace.bpf.o", directory: ".")
!3 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 256, elements: !4)
!4 = !{!5, !11, !12, !15}
!5 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !2, file: !2, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 32, elements: !9)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{!10}
!10 = !DISubrange(count: 1, lowerBound: 0)
!11 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !2, file: !2, baseType: !6, size: 64, offset: 64)
!12 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !2, file: !2, baseType: !13, size: 64, offset: 128)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIBasicType(name: "int64", size: 64, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !2, file: !2, baseType: !13, size: 64, offset: 192)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "AT_y", linkageName: "global", scope: !2, file: !2, type: !3, isLocal: false, isDefinition: true)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "ringbuf", linkageName: "global", scope: !2, file: !2, type: !20, isLocal: false, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 128, elements: !21)
!21 = !{!22, !27}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !2, file: !2, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 864, elements: !25)
!25 = !{!26}
!26 = !DISubrange(count: 27, lowerBound: 0)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !2, file: !2, baseType: !28, size: 64, offset: 64)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 8388608, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 262144, lowerBound: 0)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(name: "event_loss_counter", linkageName: "global", scope: !2, file: !2, type: !34, isLocal: false, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 256, elements: !35)
!35 = !{!36, !11, !41, !15}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !2, file: !2, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 64, elements: !39)
!39 = !{!40}
!40 = !DISubrange(count: 2, lowerBound: 0)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !2, file: !2, baseType: !42, size: 64, offset: 128)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DIBasicType(name: "int32", size: 32, encoding: DW_ATE_signed)
!44 = distinct !DICompileUnit(language: DW_LANG_C, file: !2, producer: "bpftrace", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, globals: !45)
!45 = !{!0, !16, !18, !32}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = distinct !DISubprogram(name: "kprobe_f_1", linkageName: "kprobe_f_1", scope: !2, file: !2, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !44, retainedNodes: !52)
!48 = !DISubroutineType(types: !49)
!49 = !{!14, !50}
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = !DIBasicType(name: "int8", size: 8, encoding: DW_ATE_signed)
!52 = !{!53}
!53 = !DILocalVariable(name: "ctx", arg: 1, scope: !47, file: !2, type: !50)
