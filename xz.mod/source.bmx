' Copyright (c) 2022 Bruce A Henderson
' All rights reserved.
'
' Redistribution and use in source and binary forms, with or without
' modification, are permitted provided that the following conditions are met:
'     * Redistributions of source code must retain the above copyright
'       notice, this list of conditions and the following disclaimer.
'     * Redistributions in binary form must reproduce the above copyright
'       notice, this list of conditions and the following disclaimer in the
'       documentation and/or other materials provided with the distribution.
'
' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY
' EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
' WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
' DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
' (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
' LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
' ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
' (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
' SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'
SuperStrict


Import "../core.mod/include/*.h"
Import "../core.mod/libarchive/libarchive/*.h"
Import "../core.mod/libarchive/libarchive/archive_read_support_filter_xz.c"
Import "../core.mod/libarchive/libarchive/archive_write_add_filter_xz.c"

 Import "xz/src/*.h"
 Import "xz/src/common/*.h"
 Import "xz/src/liblzma/api/*.h"
 Import "xz/src/liblzma/common/*.h"
 Import "xz/src/liblzma/check/*.h"
 Import "xz/src/liblzma/delta/*.h"
 Import "xz/src/liblzma/lzma/*.h"
 Import "xz/src/liblzma/lz/*.h"
 Import "xz/src/liblzma/rangecoder/*.h"
 Import "xz/src/liblzma/simple/*.h"

 Import "xz/src/liblzma/check/check.c"
 Import "xz/src/liblzma/check/crc32_fast.c"
 Import "xz/src/liblzma/check/crc32_table.c"
 Import "xz/src/liblzma/check/crc64_fast.c"
 Import "xz/src/liblzma/check/crc64_table.c"
 Import "xz/src/liblzma/check/sha256.c"

 Import "xz/src/liblzma/common/alone_decoder.c"
 Import "xz/src/liblzma/common/alone_encoder.c"
 Import "xz/src/liblzma/common/auto_decoder.c"
 Import "xz/src/liblzma/common/block_buffer_decoder.c"
 Import "xz/src/liblzma/common/block_buffer_encoder.c"
 Import "xz/src/liblzma/common/block_decoder.c"
 Import "xz/src/liblzma/common/block_encoder.c"
 Import "xz/src/liblzma/common/block_header_decoder.c"
 Import "xz/src/liblzma/common/block_header_encoder.c"
 Import "xz/src/liblzma/common/block_util.c"
 Import "xz/src/liblzma/common/common.c"
 Import "xz/src/liblzma/common/easy_buffer_encoder.c"
 Import "xz/src/liblzma/common/easy_decoder_memusage.c"
 Import "xz/src/liblzma/common/easy_encoder_memusage.c"
 Import "xz/src/liblzma/common/easy_encoder.c"
 Import "xz/src/liblzma/common/easy_preset.c"
 Import "xz/src/liblzma/common/filter_buffer_decoder.c"
 Import "xz/src/liblzma/common/filter_buffer_encoder.c"
 Import "xz/src/liblzma/common/filter_common.c"
 Import "xz/src/liblzma/common/filter_decoder.c"
 Import "xz/src/liblzma/common/filter_encoder.c"
 Import "xz/src/liblzma/common/filter_flags_decoder.c"
 Import "xz/src/liblzma/common/filter_flags_encoder.c"
 Import "xz/src/liblzma/common/hardware_physmem.c"
 Import "xz/src/liblzma/common/index_decoder.c"
 Import "xz/src/liblzma/common/index_encoder.c"
 Import "xz/src/liblzma/common/index_hash.c"
 Import "xz/src/liblzma/common/index.c"
 Import "xz/src/liblzma/common/stream_buffer_decoder.c"
 Import "xz/src/liblzma/common/stream_buffer_encoder.c"
 Import "xz/src/liblzma/common/stream_decoder.c"
 Import "xz/src/liblzma/common/stream_encoder.c"
 Import "xz/src/liblzma/common/stream_flags_common.c"
 Import "xz/src/liblzma/common/stream_flags_decoder.c"
 Import "xz/src/liblzma/common/stream_flags_encoder.c"
 Import "xz/src/liblzma/common/vli_decoder.c"
 Import "xz/src/liblzma/common/vli_encoder.c"
 Import "xz/src/liblzma/common/vli_size.c"

 Import "xz/src/liblzma/delta/delta_common.c"
 Import "xz/src/liblzma/delta/delta_decoder.c"
 Import "xz/src/liblzma/delta/delta_encoder.c"

 Import "xz/src/liblzma/lz/lz_decoder.c"
 Import "xz/src/liblzma/lz/lz_encoder_mf.c"
 Import "xz/src/liblzma/lz/lz_encoder.c"

 Import "xz/src/liblzma/lzma/fastpos_table.c"
 Import "xz/src/liblzma/lzma/lzma_decoder.c"
 Import "xz/src/liblzma/lzma/lzma_encoder_optimum_fast.c"
 Import "xz/src/liblzma/lzma/lzma_encoder_optimum_normal.c"
 Import "xz/src/liblzma/lzma/lzma_encoder_presets.c"
 Import "xz/src/liblzma/lzma/lzma_encoder.c"
 Import "xz/src/liblzma/lzma/lzma2_decoder.c"
 Import "xz/src/liblzma/lzma/lzma2_encoder.c"

 Import "xz/src/liblzma/rangecoder/price_table.c"

 Import "xz/src/liblzma/simple/simple_coder.c"
 Import "xz/src/liblzma/simple/simple_decoder.c"
 Import "xz/src/liblzma/simple/simple_encoder.c"
 Import "xz/src/liblzma/simple/arm.c"
 Import "xz/src/liblzma/simple/armthumb.c"
 Import "xz/src/liblzma/simple/ia64.c"
 Import "xz/src/liblzma/simple/powerpc.c"
 Import "xz/src/liblzma/simple/sparc.c"
 Import "xz/src/liblzma/simple/x86.c"
