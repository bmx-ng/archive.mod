' Copyright (c) 2022-2023 Bruce A Henderson
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

Module Archive.Lz4

ModuleInfo "Version: 1.01"
ModuleInfo "License: BSD"
ModuleInfo "Copyright: Wrapper - 2022-2023 Bruce A Henderson"

ModuleInfo "History: 1.01"
ModuleInfo "History: Update to lz4 1.9.4"
ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release."

ModuleInfo "CC_OPTS: -DHAVE_LIBLZ4 -DHAVE_LZ4_H -DHAVE_LZ4HC_H"
ModuleInfo "CC_OPTS: -DHAVE_CONFIG_H -D_FILE_OFFSET_BITS=64"
?win32
ModuleInfo "CC_OPTS: -DLIBARCHIVE_STATIC"
?

Import "common.bmx"

Private

Type TLz4ArchiveFormat Extends TArchiveFormat

	Method AddReadFormat:Int(archive:Byte Ptr, format:EArchiveFormat)
		Return False
	End Method

	Method AddWriteFormat:Int(archive:Byte Ptr, format:EArchiveFormat)
		Return False
	End Method

	Method AddReadFilter:Int(archive:Byte Ptr, filter:EArchiveFilter)
		If filter = EArchiveFilter.LZ4 Then
			archive_read_support_filter_lz4(archive)
			Return True
		End If
	End Method

	Method AddWriteFilter:Int(archive:Byte Ptr, filter:EArchiveFilter)
		If filter = EArchiveFilter.LZ4 Then
			archive_write_add_filter_lz4(archive)
			Return True
		End If
	End Method
End Type

New TLz4ArchiveFormat
