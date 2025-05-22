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

Module Archive.Zstd

ModuleInfo "Version: 1.02"
ModuleInfo "License: BSD"
ModuleInfo "Copyright: Wrapper - 2022-2025 Bruce A Henderson"
ModuleInfo "Copyright: ZStandard - Meta Platforms, Inc. and affiliates. All rights reserved."

ModuleInfo "History: 1.02"
ModuleInfo "History: Update to zstd 1.5.7"
ModuleInfo "History: 1.01"
ModuleInfo "History: Update to zstd 1.5.5"
ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release. zstd 1.5.2"

ModuleInfo "CC_OPTS: -DHAVE_ZSTD_H -DHAVE_LIBZSTD -DHAVE_LIBZSTD_COMPRESSOR -DHAVE_ZSTD_compressStream"
ModuleInfo "CC_OPTS: -DHAVE_CONFIG_H -D_FILE_OFFSET_BITS=64"
?win32
ModuleInfo "CC_OPTS: -DLIBARCHIVE_STATIC"
?

Import "common.bmx"

Private

Type TZStdArchiveFormat Extends TArchiveFormat

	Method AddReadFormat:Int(archive:Byte Ptr, format:EArchiveFormat)
		Return False
	End Method

	Method AddWriteFormat:Int(archive:Byte Ptr, format:EArchiveFormat)
		Return False
	End Method

	Method AddReadFilter:Int(archive:Byte Ptr, filter:EArchiveFilter)
		If filter = EArchiveFilter.ZSTD Then
			archive_read_support_filter_zstd(archive)
			Return True
		End If
	End Method

	Method AddWriteFilter:Int(archive:Byte Ptr, filter:EArchiveFilter)
		If filter = EArchiveFilter.ZSTD Then
			archive_write_add_filter_zstd(archive)
			Return True
		End If
	End Method
End Type

New TZStdArchiveFormat
