#pragma once

void* umem_alloc_code_page();

void* umem_alloc_data_page();

void umem_free_code_page(void* ptr);

void umem_free_data_page(void* ptr);
