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

Module Archive.Cab


ModuleInfo "CC_OPTS: -DHAVE_ZLIB_H"
ModuleInfo "CC_OPTS: -DHAVE_CONFIG_H -D_FILE_OFFSET_BITS=64"
?win32
ModuleInfo "CC_OPTS: -DLIBARCHIVE_STATIC"
?

Import Archive.Core
Import "common.bmx"

Private

Type TCabArchiveFormat Extends TArchiveFormat

	Method AddReadFormat:Int(archive:Byte Ptr, format:EArchiveFormat)
		If format = EArchiveFormat.CAB Then
			archive_read_support_format_cab(archive)
			Return True
		End If
	End Method

	Method AddWriteFormat:Int(archive:Byte Ptr, format:EArchiveFormat)
		Return False
	End Method

	Method AddReadFilter:Int(archive:Byte Ptr, filter:EArchiveFilter)
		Return False
	End Method

	Method AddWriteFilter:Int(archive:Byte Ptr, filter:EArchiveFilter)
		Return False
	End Method
End Type

New TCabArchiveFormat
