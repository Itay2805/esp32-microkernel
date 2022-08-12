#pragma once

#include <util/except.h>

err_t loader_load_app(const char* name, void* app, size_t app_size);
