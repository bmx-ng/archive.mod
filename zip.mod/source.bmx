' Copyright (c) 2022-2025 Bruce A Henderson
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

Import Archive.zlib
Import Archive.xz
Import Archive.zstd
Import Archive.bzip2

Import "../zlib.mod/zlib/*.h"
Import "../xz.mod/xz/src/liblzma/api/*.h"
Import "../zstd.mod/zstd/lib/*.h"

?linux or win32
Import Net.mbedtlsCrypto

Import "../../net.mod/mbedtls.mod/mbedtls/include/*.h"
?

Import "../core.mod/include/*.h"
Import "../core.mod/libarchive/libarchive/*.h"
Import "../core.mod/libarchive/libarchive/archive_cryptor.c"
Import "../core.mod/libarchive/libarchive/archive_hmac.c"
Import "../core.mod/libarchive/libarchive/archive_read_support_format_zip.c"
Import "../core.mod/libarchive/libarchive/archive_write_set_format_zip.c"
'Import "../core.mod/mods/archive_write_set_format_zip.c"
