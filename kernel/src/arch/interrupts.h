#pragma once

typedef enum exception_cause {
    IllegalInstructionCause     = 0,
    SyscallCause                = 1,
    InstructionFetchErrorCause  = 2,
    LoadStoreErrorCause         = 3,

    InstrPIFDataErrorCause      = 12,
    LoadStorePIFDataErrorCause  = 13,
    InstrPIFAddrErrorCause      = 14,
    LoadStorePIFAddrErrorCause  = 15,
} exception_cause_t;
