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
Import "../core.mod/libarchive/libarchive/archive_read_support_filter_lzop.c"
Import "../core.mod/libarchive/libarchive/archive_write_add_filter_lzop.c"

Import "lzo/include/*.h"

Import "lzo/src/lzo1.c"
Import "lzo/src/lzo1_99.c"
Import "lzo/src/lzo1a.c"
Import "lzo/src/lzo1a_99.c"
Import "lzo/src/lzo1b_1.c"
Import "lzo/src/lzo1b_2.c"
Import "lzo/src/lzo1b_3.c"
Import "lzo/src/lzo1b_4.c"
Import "lzo/src/lzo1b_5.c"
Import "lzo/src/lzo1b_6.c"
Import "lzo/src/lzo1b_7.c"
Import "lzo/src/lzo1b_8.c"
Import "lzo/src/lzo1b_9.c"
Import "lzo/src/lzo1b_99.c"
Import "lzo/src/lzo1b_9x.c"
Import "lzo/src/lzo1b_cc.c"
Import "lzo/src/lzo1b_d1.c"
Import "lzo/src/lzo1b_d2.c"
Import "lzo/src/lzo1b_rr.c"
Import "lzo/src/lzo1b_xx.c"
Import "lzo/src/lzo1c_1.c"
Import "lzo/src/lzo1c_2.c"
Import "lzo/src/lzo1c_3.c"
Import "lzo/src/lzo1c_4.c"
Import "lzo/src/lzo1c_5.c"
Import "lzo/src/lzo1c_6.c"
Import "lzo/src/lzo1c_7.c"
Import "lzo/src/lzo1c_8.c"
Import "lzo/src/lzo1c_9.c"
Import "lzo/src/lzo1c_99.c"
Import "lzo/src/lzo1c_9x.c"
Import "lzo/src/lzo1c_cc.c"
Import "lzo/src/lzo1c_d1.c"
Import "lzo/src/lzo1c_d2.c"
Import "lzo/src/lzo1c_rr.c"
Import "lzo/src/lzo1c_xx.c"
Import "lzo/src/lzo1f_1.c"
Import "lzo/src/lzo1f_9x.c"
Import "lzo/src/lzo1f_d1.c"
Import "lzo/src/lzo1f_d2.c"
Import "lzo/src/lzo1x_1.c"
Import "lzo/src/lzo1x_1k.c"
Import "lzo/src/lzo1x_1l.c"
Import "lzo/src/lzo1x_1o.c"
Import "lzo/src/lzo1x_9x.c"
Import "lzo/src/lzo1x_d1.c"
Import "lzo/src/lzo1x_d2.c"
Import "lzo/src/lzo1x_d3.c"
Import "lzo/src/lzo1x_o.c"
Import "lzo/src/lzo1y_1.c"
Import "lzo/src/lzo1y_9x.c"
Import "lzo/src/lzo1y_d1.c"
Import "lzo/src/lzo1y_d2.c"
Import "lzo/src/lzo1y_d3.c"
Import "lzo/src/lzo1y_o.c"
Import "lzo/src/lzo1z_9x.c"
Import "lzo/src/lzo1z_d1.c"
Import "lzo/src/lzo1z_d2.c"
Import "lzo/src/lzo1z_d3.c"
Import "lzo/src/lzo2a_9x.c"
Import "lzo/src/lzo2a_d1.c"
Import "lzo/src/lzo2a_d2.c"
Import "lzo/src/lzo_crc.c"
Import "lzo/src/lzo_init.c"
Import "lzo/src/lzo_ptr.c"
Import "lzo/src/lzo_str.c"
Import "lzo/src/lzo_util.c"
