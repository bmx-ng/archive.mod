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

Import "include/*.h"

Import "libarchive/libarchive/*.h"

Import "libarchive/libarchive/archive_acl.c"
Import "libarchive/libarchive/archive_check_magic.c"
Import "libarchive/libarchive/archive_cmdline.c"
Import "libarchive/libarchive/archive_entry_copy_stat.c"
Import "libarchive/libarchive/archive_entry_link_resolver.c"
Import "libarchive/libarchive/archive_entry_sparse.c"
Import "libarchive/libarchive/archive_entry_stat.c"
Import "libarchive/libarchive/archive_entry_strmode.c"
Import "libarchive/libarchive/archive_entry_xattr.c"
Import "libarchive/libarchive/archive_entry.c"
Import "libarchive/libarchive/archive_getdate.c"
Import "libarchive/libarchive/archive_options.c"
Import "libarchive/libarchive/archive_pack_dev.c"
Import "libarchive/libarchive/archive_pathmatch.c"
Import "libarchive/libarchive/archive_ppmd7.c"
Import "libarchive/libarchive/archive_ppmd8.c"
Import "libarchive/libarchive/archive_random.c"
Import "libarchive/libarchive/archive_rb.c"
Import "libarchive/libarchive/archive_read_add_passphrase.c"
Import "libarchive/libarchive/archive_read_append_filter.c"
Import "libarchive/libarchive/archive_read_open_memory.c"
Import "libarchive/libarchive/archive_read_set_options.c"
Import "libarchive/libarchive/archive_read_support_filter_program.c"
Import "libarchive/libarchive/archive_read_support_format_empty.c"
Import "libarchive/libarchive/archive_read.c"
Import "libarchive/libarchive/archive_string.c"
Import "libarchive/libarchive/archive_string_sprintf.c"
Import "libarchive/libarchive/archive_util.c"
Import "libarchive/libarchive/archive_virtual.c"
Import "libarchive/libarchive/archive_version_details.c"
Import "libarchive/libarchive/archive_write_add_filter_program.c"
Import "libarchive/libarchive/archive_write_disk_set_standard_lookup.c"
Import "libarchive/libarchive/archive_write_open_memory.c"
Import "libarchive/libarchive/archive_write_set_options.c"
Import "libarchive/libarchive/archive_write_set_passphrase.c"
Import "libarchive/libarchive/archive_write.c"
?Not win32
Import "libarchive/libarchive/filter_fork_posix.c"
?
?win32
Import "libarchive/libarchive/archive_entry_copy_bhfi.c"
Import "libarchive/libarchive/archive_windows.c"
Import "libarchive/libarchive/filter_fork_windows.c"
?

'Import "mods/archive_string.c"
Import "mods/archive_write_set_format.c"
Import "glue.c"
