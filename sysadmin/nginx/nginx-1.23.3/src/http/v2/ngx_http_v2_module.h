
/*
 * Copyright (C) Nginx, Inc.
 * Copyright (C) Valentin V. Bartenev
 */


#ifndef _NGX_HTTP_V2_MODULE_H_INCLUDED_
#define _NGX_HTTP_V2_MODULE_H_INCLUDED_


#include <ngx_config.h>
#include <ngx_core.h>
#include <ngx_http.h>


typedef struct {
    size_t                          recv_buffer_size;
    u_char                         *recv_buffer;
} ngx_http_v2_main_conf_t;


typedef struct {
    size_t                          pool_size;
    ngx_uint_t                      concurrent_streams;
    ngx_uint_t                      concurrent_pushes;
    size_t                          preread_size;
    ngx_uint_t                      streams_index_mask;
} ngx_http_v2_srv_conf_t;


typedef struct {
    size_t                          chunk_size;

    ngx_flag_t                      push_preload;

    ngx_flag_t                      push;
    ngx_array_t                    *pushes;
} ngx_http_v2_loc_conf_t;


extern ngx_module_t  ngx_http_v2_module;


#endif /* _NGX_HTTP_V2_MODULE_H_INCLUDED_ */
