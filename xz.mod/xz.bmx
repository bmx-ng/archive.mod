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

Module Archive.Xz


ModuleInfo "CC_OPTS: -DHAVE_LZMA_H -DHAVE_LIBLZMA -std=gnu99"
ModuleInfo "CC_OPTS: -DHAVE_CONFIG_H -D_FILE_OFFSET_BITS=64"
?win32
ModuleInfo "CC_OPTS: -DLIBARCHIVE_STATIC"
?

' config.h
ModuleInfo "CC_OPTS: -DASSUME_RAM=128 -DHAVE_CFLOCALECOPYCURRENT=1"
ModuleInfo "CC_OPTS: -DHAVE_CFPREFERENCESCOPYAPPVALUE=1"
ModuleInfo "CC_OPTS: -DHAVE_DECL_PROGRAM_INVOCATION_NAME=0"
ModuleInfo "CC_OPTS: -DHAVE_DLFCN_H=1"
ModuleInfo "CC_OPTS: -DHAVE_FCNTL_H=1 -DHAVE_FUTIMES=1 -DHAVE_GETOPT_H=1 -DHAVE_GETOPT_LONG=1"
ModuleInfo "CC_OPTS: -DHAVE_ICONV=1"
ModuleInfo "CC_OPTS: -DHAVE_INTTYPES_H=1 -DHAVE_LIMITS_H=1 -DHAVE_MBRTOWC=1 -DHAVE_MEMORY_H=1"
ModuleInfo "CC_OPTS: -DHAVE_OPTRESET=1"

ModuleInfo "CC_OPTS: -DHAVE_CHECK_CRC32=1 -DHAVE_CHECK_CRC64=1 -DHAVE_CHECK_SHA256=1"
ModuleInfo "CC_OPTS: -DHAVE_DECODERS=1"
ModuleInfo "CC_OPTS: -DHAVE_DECODER_ARM=1 -DHAVE_DECODER_ARMTHUMB=1"
ModuleInfo "CC_OPTS: -DHAVE_DECODER_DELTA=1"
ModuleInfo "CC_OPTS: -DHAVE_DECODER_IA64=1"
ModuleInfo "CC_OPTS: -DHAVE_DECODER_LZMA1=1 -DHAVE_DECODER_LZMA2=1"
ModuleInfo "CC_OPTS: -DHAVE_DECODER_POWERPC=1 -DHAVE_DECODER_SPARC=1 -DHAVE_DECODER_X86=1"
ModuleInfo "CC_OPTS: -DHAVE_ENCODERS=1"
ModuleInfo "CC_OPTS: -DHAVE_ENCODER_ARM=1 -DHAVE_ENCODER_ARMTHUMB=1"
ModuleInfo "CC_OPTS: -DHAVE_ENCODER_DELTA=1"
ModuleInfo "CC_OPTS: -DHAVE_ENCODER_IA64=1"
ModuleInfo "CC_OPTS: -DHAVE_ENCODER_LZMA1=1 -DHAVE_ENCODER_LZMA2=1"
ModuleInfo "CC_OPTS: -DHAVE_ENCODER_POWERPC=1 -DHAVE_ENCODER_SPARC=1 -DHAVE_ENCODER_X86=1"
ModuleInfo "CC_OPTS: -DHAVE_MF_BT2=1 -DHAVE_MF_BT3=1 -DHAVE_MF_BT4=1 -DHAVE_MF_HC3=1 -DHAVE_MF_HC4=1"

?not win32
ModuleInfo "CC_OPTS: -DHAVE_PTHREAD=1"
ModuleInfo "CC_OPTS: -DHAVE_PTHREAD_PRIO_INHERIT=1"
ModuleInfo "CC_OPTS: -DMYTHREAD_POSIX=1"
?
ModuleInfo "CC_OPTS: -DHAVE_STDBOOL_H=1 -DHAVE_STDINT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRINGS_H=1"
ModuleInfo "CC_OPTS: -DHAVE_STRING_H=1"
ModuleInfo "CC_OPTS: -DHAVE_STRUCT_STAT_ST_ATIMESPEC_TV_NSEC=1"
ModuleInfo "CC_OPTS: -DHAVE_SYS_PARAM_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_SYS_TIME_H=1 -DHAVE_SYS_TYPES_H=1"
ModuleInfo "CC_OPTS: -DHAVE_UINTPTR_T=1 -DHAVE_UNISTD_H=1 -DHAVE_VISIBILITY=1 -DHAVE_WCWIDTH=1"
ModuleInfo "CC_OPTS: -DHAVE__BOOL=1"
ModuleInfo "CC_OPTS: -DNDEBUG=1"
?ptr64
ModuleInfo "CC_OPTS: -DSIZEOF_SIZE_T=8"
?ptr32
ModuleInfo "CC_OPTS: -DSIZEOF_SIZE_T=4"
?
ModuleInfo "CC_OPTS: -DSTDC_HEADERS=1"
ModuleInfo "CC_OPTS: -DTUKLIB_CPUCORES_SYSCTL=1 -DTUKLIB_FAST_UNALIGNED_ACCESS=1 -DTUKLIB_PHYSMEM_SYSCTL=1"
ModuleInfo "CC_OPTS: -DVERSION=5.0.4"


Import Archive.Core
Import "common.bmx"

Private

Type TXzArchiveFormat Extends TArchiveFormat

	Method AddReadFormat:Int(archive:Byte Ptr, format:EArchiveFormat)
		Return False
	End Method

	Method AddWriteFormat:Int(archive:Byte Ptr, format:EArchiveFormat)
		Return False
	End Method

	Method AddReadFilter:Int(archive:Byte Ptr, filter:EArchiveFilter)
		If filter = EArchiveFilter.XZ Then
			archive_read_support_filter_xz(archive)
			Return True
		End If
	End Method

	Method AddWriteFilter:Int(archive:Byte Ptr, filter:EArchiveFilter)
		If filter = EArchiveFilter.XZ Then
			archive_write_add_filter_xz(archive)
			Return True
		End If
	End Method
End Type

New TXzArchiveFormat
