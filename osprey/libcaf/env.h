/*
 Runtime library for supporting Coarray Fortran

 Copyright (C) 2011-2014 University of Houston.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

 Contact information:
 http://www.cs.uh.edu/~hpctools
*/

#ifndef _ENV_H
#define _ENV_H

/* environment */

#define ENV_DTRACE                    "UHCAF_DTRACE"
#define ENV_DTRACE_DIR                "UHCAF_DTRACE_DIR"
#define ENV_PROFILE                   "UHCAF_PROFILE"
#define ENV_STATS                     "UHCAF_STATS"
#define ENV_GETCACHE                  "UHCAF_GETCACHE"
#define ENV_GETCACHE_SYNC_REFETCH     "UHCAF_GETCACHE_SYNC_REFETCH"
#define ENV_PROGRESS_THREAD           "UHCAF_PROGRESS_THREAD"
#define ENV_PROGRESS_THREAD_INTERVAL  "UHCAF_PROGRESS_THREAD_INTERVAL"
#define ENV_GETCACHE_BLOCK_SIZE       "UHCAF_GETCACHE_BLOCK_SIZE"
#define ENV_IMAGE_HEAP_SIZE           "UHCAF_IMAGE_HEAP_SIZE"
#define ENV_TEAMS_HEAP_SIZE           "UHCAF_TEAMS_HEAP_SIZE"
#define ENV_NB_XFER_LIMIT             "UHCAF_NB_XFER_LIMIT"
#define ENV_CO_REDUCE_ALGORITHM       "UHCAF_CO_REDUCE_ALGORITHM"
#define ENV_SYNC_IMAGES_ALGORITHM     "UHCAF_SYNC_IMAGES_ALGORITHM"
#define ENV_TEAM_BARRIER_ALGORITHM    "UHCAF_TEAM_BARRIER_ALGORITHM"
#define ENV_OUT_OF_SEGMENT_RMA        "UHCAF_OUT_OF_SEGMENT_RMA"
#define ENV_ALLOC_BYTE_ALIGNMENT      "UHCAF_ALLOC_BYTE_ALIGNMENT"
#define ENV_LOCAL_PACK_NONCONTIG_PUT  "UHCAF_LOCAL_PACK_NONCONTIG_PUT"
#define ENV_SHARED_MEM_RMA_BYPASS     "UHCAF_SHARED_MEM_RMA_BYPASS"
#define ENV_RMA_ORDERING              "UHCAF_RMA_ORDERING"
#define ENV_COLLECTIVES_BUFSIZE       "UHCAF_COLLECTIVES_BUFSIZE"
#define ENV_COLLECTIVES_MAX_WORKBUFS  "UHCAF_COLLECTIVES_MAX_WORKBUFS"
#define ENV_COLLECTIVES_USE_CANARY    "UHCAF_COLLECTIVES_USE_CANARY"
#define ENV_COLLECTIVES_MPI           "UHCAF_COLLECTIVES_MPI"
#define ENV_COLLECTIVES_2LEVEL        "UHCAF_COLLECTIVES_2LEVEL"
#define ENV_REDUCTION_2LEVEL          "UHCAF_REDUCTION_2LEVEL"
#define ENV_BROADCAST_2LEVEL          "UHCAF_BROADCAST_2LEVEL"
#define ENV_FORM_TEAM_ALGORITHM       "UHCAF_FORM_TEAM_ALGORITHM"

#define DEFAULT_ENABLE_PROFILE                  0
#define DEFAULT_ENABLE_STATS                    0
#define DEFAULT_ENABLE_GETCACHE                 0
#define DEFAULT_ENABLE_GETCACHE_SYNC_REFETCH    1
#define DEFAULT_ENABLE_PROGRESS_THREAD          0
#define DEFAULT_PROGRESS_THREAD_INTERVAL        1000L /* ns */
#define DEFAULT_GETCACHE_BLOCK_SIZE             65536L
#define DEFAULT_NB_XFER_LIMIT                   16
#define DEFAULT_ENABLE_OUT_OF_SEGMENT_RMA       0
#define DEFAULT_ALLOC_BYTE_ALIGNMENT            8
#define DEFAULT_ENABLE_LOCAL_PACK_NONCONTIG_PUT 0
#define DEFAULT_ENABLE_SHARED_MEM_RMA_BYPASS    1
#define DEFAULT_COLLECTIVES_BUFSIZE             4194304 /* 4 MB */
#define DEFAULT_COLLECTIVES_MAX_WORKBUFS        0
#define DEFAULT_ENABLE_COLLECTIVES_MPI          0
#define DEFAULT_ENABLE_COLLECTIVES_USE_CANARY   0
#define DEFAULT_ENABLE_COLLECTIVES_2LEVEL       1
#define DEFAULT_ENABLE_REDUCTION_2LEVEL         0
#define DEFAULT_ENABLE_BROADCAST_2LEVEL         0

/* these should be overridden by the defaults in cafrun script */
#define DEFAULT_IMAGE_HEAP_SIZE                 31457280L
#define DEFAULT_TEAMS_HEAP_SIZE                 10485760L

int get_env_flag(const char *var_name, int default_val);
size_t get_env_size(const char *var_name, size_t default_size);
size_t get_env_size_with_unit(const char *var_name, size_t default_size);

#endif                          /* _ENV_H */
