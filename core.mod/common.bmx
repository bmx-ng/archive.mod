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

Import "source.bmx"

Extern

	Function bmx_libarchive_read_archive_new:Byte Ptr()

	Function bmx_libarchive_archive_read_open_memory:Int(handle:Byte Ptr, buf:Byte Ptr, size:Size_T)

	Function bmx_libarchive_archive_read_next_header:Int(handle:Byte Ptr, entry:Byte Ptr)
	Function bmx_libarchive_archive_read_data_skip:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_read_open:Int(handle:Byte Ptr, data:Object)
	Function bmx_libarchive_archive_read_set_read_callback:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_read_set_seek_callback:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_read_set_callback_data:Int(handle:Byte Ptr, callbackData:Object)
	Function bmx_libarchive_archive_read_data:Int(handle:Byte Ptr, buf:Byte Ptr, size:Size_T)
	Function bmx_libarchive_archive_read_add_passphrase:Int(handle:Byte Ptr, passphrase:String)
	Function bmx_libarchive_archive_read_has_encrypted_entries:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_read_set_filter_option:Int(handle:Byte Ptr, option:String, value:String, moduleName:String)
	Function bmx_libarchive_archive_read_set_format_option:Int(handle:Byte Ptr, option:String, value:String, moduleName:String)

	Function archive_read_set_read_callback:Int(handle:Byte Ptr, cb:Int(arc:Byte Ptr, cbData:Object, block:Byte Ptr Ptr))

	Function bmx_libarchive_archive_read_free:Int(handle:Byte Ptr)
	
	Function bmx_libarchive_write_archive_new:Byte Ptr()
	Function bmx_libarchive_archive_write_free:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_write_open_memory:Int(handle:Byte Ptr, buf:Byte Ptr, size:Int, used:Int Ptr)
	Function bmx_libarchive_archive_write_data:Int(handle:Byte Ptr, data:Byte Ptr, size:Size_T)
	Function bmx_libarchive_archive_write_header:Int(handle:Byte Ptr, entry:Byte Ptr)
	Function bmx_libarchive_archive_write_close:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_write_finish_entry:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_write_set_passphrase:Int(handle:Byte Ptr, passphrase:String)
	Function bmx_libarchive_archive_write_set_filter_option:Int(handle:Byte Ptr, option:String, value:String, moduleName:String)
	Function bmx_libarchive_archive_write_set_format_option:Int(handle:Byte Ptr, option:String, value:String, moduleName:String)
	Function bmx_libarchive_archive_write_open:Int(handle:Byte Ptr, data:Object)
		
	Function bmx_libarchive_archive_clear_error(handle:Byte Ptr)
	Function bmx_libarchive_archive_errno:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_error_string:String(handle:Byte Ptr)
	Function bmx_libarchive_archive_file_count:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_filter_code:Int(handle:Byte Ptr, filter:Int)
	Function bmx_libarchive_archive_filter_count:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_filter_name:String(handle:Byte Ptr, filter:Int)
	Function bmx_libarchive_archive_format:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_format_name:String(handle:Byte Ptr)
	Function bmx_libarchive_archive_position(handle:Byte Ptr, filter:Int, v:Long Ptr)

	Function bmx_libarchive_archive_entry_new:Byte Ptr()
	Function bmx_libarchive_archive_entry_free(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_clear:Byte Ptr(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_clone:Byte Ptr(handle:Byte Ptr)
	
	Function bmx_libarchive_archive_entry_hardlink:String(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_sourcepath:String(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_symlink:String(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_pathname:String(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_set_link(handle:Byte Ptr, path:String)
	Function bmx_libarchive_archive_entry_set_pathname(handle:Byte Ptr, path:String)
	Function bmx_libarchive_archive_entry_set_sourcepath(handle:Byte Ptr, path:String)
	Function bmx_libarchive_archive_entry_set_symlink(handle:Byte Ptr, path:String)
	Function bmx_libarchive_archive_entry_set_size(handle:Byte Ptr, size:Long)
	Function bmx_libarchive_archive_entry_unset_size(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_set_ctime(handle:Byte Ptr, time:Long, nanoseconds:Long)
	Function bmx_libarchive_archive_entry_set_mtime(handle:Byte Ptr, time:Long, nanoseconds:Long)
	Function bmx_libarchive_archive_entry_set_filetype(handle:Byte Ptr, fType:EArchiveFileType)
	Function bmx_libarchive_archive_entry_set_perm(handle:Byte Ptr, perm:Int)
	Function bmx_libarchive_archive_entry_is_data_encrypted:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_is_metadata_encrypted:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_is_encrypted:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_size_is_set:Int(handle:Byte Ptr)
	Function bmx_libarchive_archive_entry_size:Long(handle:Byte Ptr)

	Function archive_error_string:Byte Ptr(handle:Byte Ptr)
End Extern

Enum EArchiveFilter
	NONE
	GZIP
	BZIP2
	COMPRESS
	PROGRAM
	LZMA
	XZ
	UU
	RPM
	LZIP
	LRZIP
	LZOP
	GRZIP
	LZ4
	ZSTD
End Enum

Enum EArchiveFormat
	CPIO = $10000
	SHAR = $20000
	TAR = $30000
	PAX = $30000 | 3
	GNUTAR = $30000 | 4
	ISO9660 = $40000
	ZIP = $50000
	EMPTY = $60000
	AR = $70000
	MTREE = $80000
	RAW = $90000
	XAR = $A0000
	LHA = $B0000
	CAB = $C0000
	RAR = $D0000
	SEVEN_ZIP = $E0000
	WARC = $F0000
	RAR_V5 = $100000
End Enum

Enum EArchiveFileType:UInt
	File = 100000 ' regular file
	Link = 120000 ' symbolic link
	Socket = 140000 ' socket
	CharDevice = 20000 ' character device
	BlockDevice = 60000 ' block device
	Dir = 40000 ' directory
	Fifo = 10000 ' named pipe
End Enum

Const ARCHIVE_FILTER_NONE:Int = 0
Const ARCHIVE_FILTER_GZIP:Int = 1
Const ARCHIVE_FILTER_BZIP2:Int = 2
Const ARCHIVE_FILTER_COMPRESS:Int = 3
Const ARCHIVE_FILTER_PROGRAM:Int = 4
Const ARCHIVE_FILTER_LZMA:Int = 5
Const ARCHIVE_FILTER_XZ:Int = 6
Const ARCHIVE_FILTER_UU:Int = 7
Const ARCHIVE_FILTER_RPM:Int = 8
Const ARCHIVE_FILTER_LZIP:Int = 9
Const ARCHIVE_FILTER_LRZIP:Int = 10
Const ARCHIVE_FILTER_LZOP:Int = 11
Const ARCHIVE_FILTER_GRZIP:Int = 12
Const ARCHIVE_FILTER_LZ4:Int = 13
Const ARCHIVE_FILTER_ZSTD:Int = 14

Const ARCHIVE_FORMAT_BASE_MASK:Int = $ff0000
Const ARCHIVE_FORMAT_CPIO:Int = $10000
Const ARCHIVE_FORMAT_CPIO_POSIX:Int = ARCHIVE_FORMAT_CPIO | 1
Const ARCHIVE_FORMAT_CPIO_BIN_LE:Int = ARCHIVE_FORMAT_CPIO | 2
Const ARCHIVE_FORMAT_CPIO_BIN_BE:Int = ARCHIVE_FORMAT_CPIO | 3
Const ARCHIVE_FORMAT_CPIO_SVR4_NOCRC:Int = ARCHIVE_FORMAT_CPIO | 4
Const ARCHIVE_FORMAT_CPIO_SVR4_CRC:Int = ARCHIVE_FORMAT_CPIO | 5
Const ARCHIVE_FORMAT_CPIO_AFIO_LARGE:Int = ARCHIVE_FORMAT_CPIO | 6
Const ARCHIVE_FORMAT_SHAR:Int = $20000
Const ARCHIVE_FORMAT_SHAR_BASE:Int = ARCHIVE_FORMAT_SHAR | 1
Const ARCHIVE_FORMAT_SHAR_DUMP:Int = ARCHIVE_FORMAT_SHAR | 2
Const ARCHIVE_FORMAT_TAR:Int = $30000
Const ARCHIVE_FORMAT_TAR_USTAR:Int = ARCHIVE_FORMAT_TAR | 1
Const ARCHIVE_FORMAT_TAR_PAX_INTERCHANGE:Int = ARCHIVE_FORMAT_TAR | 2
Const ARCHIVE_FORMAT_TAR_PAX_RESTRICTED:Int = ARCHIVE_FORMAT_TAR | 3
Const ARCHIVE_FORMAT_TAR_GNUTAR:Int = ARCHIVE_FORMAT_TAR | 4
Const ARCHIVE_FORMAT_ISO9660:Int = $40000
Const ARCHIVE_FORMAT_ISO9660_ROCKRIDGE:Int = ARCHIVE_FORMAT_ISO9660 | 1
Const ARCHIVE_FORMAT_ZIP:Int = $50000
Const ARCHIVE_FORMAT_EMPTY:Int = $60000
Const ARCHIVE_FORMAT_AR:Int = $70000
Const ARCHIVE_FORMAT_AR_GNU:Int = ARCHIVE_FORMAT_AR | 1
Const ARCHIVE_FORMAT_AR_BSD:Int = ARCHIVE_FORMAT_AR | 2
Const ARCHIVE_FORMAT_MTREE:Int = $80000
Const ARCHIVE_FORMAT_RAW:Int = $90000
Const ARCHIVE_FORMAT_XAR:Int = $A0000
Const ARCHIVE_FORMAT_LHA:Int = $B0000
Const ARCHIVE_FORMAT_CAB:Int = $C0000
Const ARCHIVE_FORMAT_RAR:Int = $D0000
Const ARCHIVE_FORMAT_7ZIP:Int = $E0000
Const ARCHIVE_FORMAT_WARC:Int = $F0000
Const ARCHIVE_FORMAT_RAR_V5:Int = $100000

Rem
bbdoc:  Found end of archive.
End Rem
Const ARCHIVE_EOF:Int = 1
Rem
bbdoc:  Operation was successful.
End Rem
Const ARCHIVE_OK:Int = 0
Rem
bbdoc:  Retry might succeed.
End Rem
Const ARCHIVE_RETRY:Int = -10
Rem
bbdoc:  Partial success.
End Rem
Const ARCHIVE_WARN:Int = -20
Rem
bbdoc:  Current operation cannot complete.
about: For example, if WriteHeader "fails", tThen you can't push data.
End Rem
Const ARCHIVE_FAILED:Int = -25
Rem
bbdoc:  No more operations are possible.
about: For example, if WriteHeader is "fatal," then this archive is dead and useless.
End Rem
Const ARCHIVE_FATAL:Int = -30

Const ARCHIVE_READ_FORMAT_ENCRYPTION_UNSUPPORTED:Int = -2
Const ARCHIVE_READ_FORMAT_ENCRYPTION_DONT_KNOW:Int = -1

