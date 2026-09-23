// Copyright 2023-2026 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.

#if defined(__XS2A__) ||  defined(__XS3A__)
#define NSTACKWORDS     (0)
#define FUNCTION_NAME   main

.text
.issue_mode single
.align 4

.cc_top FUNCTION_NAME.function,FUNCTION_NAME

FUNCTION_NAME:
    entsp NSTACKWORDS
    ldc r0, 0
    retsp NSTACKWORDS


.L_func_end:
.cc_bottom FUNCTION_NAME.function

.globl FUNCTION_NAME
.type FUNCTION_NAME,@function
.set FUNCTION_NAME.nstackwords,NSTACKWORDS;  .global FUNCTION_NAME.nstackwords
.set FUNCTION_NAME.maxcores,1;               .global FUNCTION_NAME.maxcores
.set FUNCTION_NAME.maxtimers,0;              .global FUNCTION_NAME.maxtimers
.set FUNCTION_NAME.maxchanends,0;            .global FUNCTION_NAME.maxchanends
#endif // defined(__XS2A__) ||  defined(__XS3A__)


#if defined(__VX4B__) || defined(__riscv_xxcore)
#define NSTACKWORDS     (0)
#define FUNCTION_NAME   main

.section .text
.globl FUNCTION_NAME
.type FUNCTION_NAME,@function
FUNCTION_NAME:
    li a0, 0
    ret

.size FUNCTION_NAME, . -FUNCTION_NAME
.resource_const FUNCTION_NAME, "stack_frame_bytes", NSTACKWORDS
.resource_list_empty FUNCTION_NAME, "callees"
.resource_list_empty FUNCTION_NAME, "tail_callees"
.resource_list_empty FUNCTION_NAME, "parallel_callees"
#endif // defined(__VX4B__)
