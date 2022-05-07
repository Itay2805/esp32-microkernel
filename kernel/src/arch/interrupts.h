#pragma once

/**
 * The possible exception causes, any commented out exception
 * does not exist on our board, but we have it for reference
 */
typedef enum exception_cause {
    IllegalInstructionCause     = 0,
    SyscallCause                = 1,
    InstructionFetchErrorCause  = 2,
    LoadStoreErrorCause         = 3,
    Level1InterruptCause        = 4,
    AllocaCause                 = 5,

    PrivilegedCause             = 8,
    LoadStoreAlignmentCause     = 9,

    InstrPIFDataErrorCause      = 12,
    LoadStorePIFDataErrorCause  = 13,
    InstrPIFAddrErrorCause      = 14,
    LoadStorePIFAddrErrorCause  = 15,

    InstTLBMissCause            = 16,
    InstTLBMultiHitCause        = 17,
    InstFetchPrivilegeCause     = 18,

    InstFetchProhibitedCause    = 20,

    LoadStoreTLBMissCause       = 24,
    LoadStoreTLBMultiHitCause   = 25,
    LoadStorePrivilegeCause     = 26,

    LoadProhibitedCause         = 28,
    StoreProhibitedCause        = 29,

    Coprocessor0Disabled        = 32,
    Coprocessor1Disabled        = 33,
    Coprocessor2Disabled        = 34,
    Coprocessor3Disabled        = 35,
    Coprocessor4Disabled        = 36,
    Coprocessor5Disabled        = 37,
    Coprocessor6Disabled        = 38,
    Coprocessor7Disabled        = 39,
} exception_cause_t;
