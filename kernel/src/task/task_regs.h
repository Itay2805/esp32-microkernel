#pragma once

#define TASK_REGS_AR(x)         ((x) * 4)
#define TASK_REGS_AR_END        256
#define TASK_REGS_SAR           256
#define TASK_REGS_LBEG          260
#define TASK_REGS_LEND          264
#define TASK_REGS_LCOUNT        268
#define TASK_REGS_PC            272
#define TASK_REGS_PS            276
#define TASK_REGS_WINDOWBASE    280
#define TASK_REGS_WINDOWSTART   284
#define TASK_REGS_WINDOWMASK    288
#define TASK_REGS_WINDOWSIZE    290
#define TASK_REGS_SIZE          292
