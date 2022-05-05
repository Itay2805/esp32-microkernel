#pragma once

#include "cpp_magic.h"
#include "trace.h"

typedef enum err {
    /**
     * No error
     */
    NO_ERROR,

    /**
     * Generic unknown error
     */
    ERROR_CHECK_FAILED,
} err_t;

#define IS_ERROR(x) ((x) != 0)

//----------------------------------------------------------------------------------------------------------------------
// A check that fails if the expression returns false
//----------------------------------------------------------------------------------------------------------------------

#define CHECK_ERROR_LABEL(check, error, label, ...) \
    do { \
        if (!(check)) { \
            err = error; \
            IF(HAS_ARGS(__VA_ARGS__))(ERROR(__VA_ARGS__)); \
            ERROR("Check failed with error %d in function %s (%s:%d)", err, __FUNCTION__, __FILE__, __LINE__); \
            goto label; \
        } \
    } while(0)

#define CHECK_ERROR(check, error, ...)              CHECK_ERROR_LABEL(check, error, cleanup, ## __VA_ARGS__)
#define CHECK_LABEL(check, label, ...)              CHECK_ERROR_LABEL(check, ERROR_CHECK_FAILED, label, ## __VA_ARGS__)
#define CHECK(check, ...)                           CHECK_ERROR_LABEL(check, ERROR_CHECK_FAILED, cleanup, ## __VA_ARGS__)

#define DEBUG_CHECK_ERROR(check, error, ...)              CHECK_ERROR_LABEL(check, error, cleanup, ## __VA_ARGS__)
#define DEBUG_CHECK_LABEL(check, label, ...)              CHECK_ERROR_LABEL(check, ERROR_CHECK_FAILED, label, ## __VA_ARGS__)
#define DEBUG_CHECK(check, ...)                           CHECK_ERROR_LABEL(check, ERROR_CHECK_FAILED, cleanup, ## __VA_ARGS__)

//----------------------------------------------------------------------------------------------------------------------
// A check that fails without a condition
//----------------------------------------------------------------------------------------------------------------------

#define CHECK_FAIL(...)                             CHECK_ERROR_LABEL(0, ERROR_CHECK_FAILED, cleanup, ## __VA_ARGS__)
#define CHECK_FAIL_ERROR(error, ...)                CHECK_ERROR_LABEL(0, error, cleanup, ## __VA_ARGS__)
#define CHECK_FAIL_LABEL(label, ...)                CHECK_ERROR_LABEL(0, ERROR_CHECK_FAILED, label, ## __VA_ARGS__)
#define CHECK_FAIL_ERROR_LABEL(error, label, ...)   CHECK_ERROR_LABEL(0, error, label, ## __VA_ARGS__)

//----------------------------------------------------------------------------------------------------------------------
// A check that fails if an error was returned, used around functions returning an error
//----------------------------------------------------------------------------------------------------------------------

#define CHECK_AND_RETHROW_LABEL(error, label) \
    do { \
        err = error; \
        if (IS_ERROR(err)) { \
            ERROR("\trethrown at %s (%s:%d)", __FUNCTION__, __FILE__, __LINE__); \
            goto label; \
        } \
    } while(0)

#define CHECK_AND_RETHROW(error) CHECK_AND_RETHROW_LABEL(error, cleanup)
