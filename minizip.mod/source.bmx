'  Copyright (C) 2026 Bruce A Henderson
'
'  This software is provided 'as-is', without any express or implied
'  warranty.  In no event will the authors be held liable for any damages
'  arising from the use of this software.
'
'  Permission is granted to anyone to use this software for any purpose,
'  including commercial applications, and to alter it and redistribute it
'  freely, subject to the following restrictions:
'
'  1. The origin of this software must not be misrepresented; you must not
'     claim that you wrote the original software. If you use this software
'     in a product, an acknowledgment in the product documentation would be
'     appreciated but is not required.
'  2. Altered source versions must be plainly marked as such, and must not be
'     misrepresented as being the original software.
'  3. This notice may not be removed or altered from any source distribution.
'
SuperStrict

Import Archive.zlib
Import Archive.bzip2
Import Archive.zstd
Import Archive.xz

Import "minizip/*.h"
Import "../zlib.mod/zlib/*.h"
Import "../bzip2.mod/bzip2/*.h"
Import "../zstd.mod/zstd/lib/*.h"
Import "../xz.mod/xz/src/liblzma/api/*.h"
Import "../../net.mod/mbedtls.mod/mbedtls/include/*.h"


Import "minizip/mz_crypt.c"
Import "minizip/mz_os.c"
Import "minizip/mz_strm.c"
Import "minizip/mz_strm_buf.c"
Import "minizip/mz_strm_mem.c"
Import "minizip/mz_strm_split.c"
Import "minizip/mz_zip.c"
Import "minizip/mz_zip_rw.c"

Import "minizip/mz_strm_bzip.c"
Import "minizip/mz_strm_zlib.c"
Import "minizip/mz_strm_zstd.c"
Import "minizip/mz_strm_lzma.c"
Import "minizip/mz_strm_pkcrypt.c"
Import "minizip/mz_strm_wzaes.c"

?win32
Import "minizip/mz_os_win32.c"
Import "minizip/mz_strm_os_win32.c"
?macos
Import "minizip/mz_os_posix.c"
Import "minizip/mz_strm_os_posix.c"
?linux
Import "minizip/mz_os_posix.c"
Import "minizip/mz_strm_os_posix.c"
?

Import "mz_crypt_mbedtls.c"
