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

Rem
bbdoc: Streaming Archive Library
End Rem
Module Archive.Core


ModuleInfo "Version: 1.07"
ModuleInfo "License: BSD"
ModuleInfo "Copyright: libarchive - 2003-2018 Tim Kientzle"
ModuleInfo "Copyright: Wrapper - 2013-2022 Bruce A Henderson"

ModuleInfo "History: 1.07"
ModuleInfo "History: Update to libarchive 3.6.2.2d32907."
ModuleInfo "History: Added DataStream() to TWriteArchive, returning a writeable TStream."
ModuleInfo "History: 1.06"
ModuleInfo "History: Update to libarchive 3.5.2.b967588."
ModuleInfo "History: 1.05"
ModuleInfo "History: Update to libarchive 3.3.4.458e493."
ModuleInfo "History: 1.04"
ModuleInfo "History: Update to libarchive 3.3.4.c16ce12."
ModuleInfo "History: 1.03"
ModuleInfo "History: Added zstd support."
ModuleInfo "History: 1.02"
ModuleInfo "History: Update to libarchive 3.3.2.77d26b0."
ModuleInfo "History: 1.01"
ModuleInfo "History: Removed libiconv requirement from Win32."
ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release. libarchive 3.1.2"

ModuleInfo "CC_OPTS: -DHAVE_CONFIG_H -D_FILE_OFFSET_BITS=64"
?win32
ModuleInfo "CC_OPTS: -DLIBARCHIVE_STATIC"
?

Import "common.bmx"

Import BRL.Stream
Import BRL.FileSystem

Rem
bbdoc: Archive base type.
End Rem
Type TArchive

	Field archivePtr:Byte Ptr

	Rem
	bbdoc: Clears any error information left over from a previous call.
	about: Not generally used in client code.
	End Rem
	Method ClearError()
		bmx_libarchive_archive_clear_error(archivePtr)
	End Method
	
	Rem
	bbdoc: Returns a numeric error code indicating the reason for the most recent error return.
	about: Note that this can not be reliably used to detect whether an error has occurred.
	It should be used only after another libarchive function has returned an error status.
	End Rem
	Method Errno:Int()
		Return bmx_libarchive_archive_errno(archivePtr)
	End Method
	
	Rem
	bbdoc: Returns a textual error message suitable for display.
	about: The error message here is usually more specific than that obtained from passing the result of archive_errno() to strerror(3).
	End Rem
	Method ErrorString:String()
		Return bmx_libarchive_archive_error_string(archivePtr)
	End Method
	
	Rem
	bbdoc: Returns a count of the number of files processed by this archive object.
	about: The count is incremented by calls to WriteHeader or ReadNextHeader.
	End Rem
	Method FileCount:Int()
		Return bmx_libarchive_archive_file_count(archivePtr)
	End Method
	
	Rem
	bbdoc: Returns a numeric code identifying the indicated filter.
	about: See FilterCount() for details of the numbering.
	End Rem
	Method FilterCode:Int(filter:Int)
		Return bmx_libarchive_archive_filter_code(archivePtr, filter)
	End Method
	
	Rem
	bbdoc: Returns the number of filters in the current pipeline.
	about: For read archive handles, these filters are added automatically by the automatic format detection.
	For write archive handles, these filters are added by calls to the various AddFilterXXX() methods. Filters in the
	resulting pipeline are numbered so that filter 0 is the filter closest to the format handler. As a convenience,
	methods that expect a filter number will accept -1 as a synonym for the highest-numbered filter.
	<p>
	For example, when reading a uuencoded gzipped tar archive, there are three filters: filter 0 is the gunzip filter, filter 1 is the uudecode
	filter, and filter 2 is the pseudo-filter that wraps the archive read methods. In this case, requesting Position(-1) would be a synonym
	for Position(2) which would return the number of bytes currently read from the archive, while Position(1) would return the number of
	bytes after uudecoding, and Position(0) would return the number of bytes after decompression.
	</p>
	End Rem
	Method FilterCount:Int()
		Return bmx_libarchive_archive_filter_count(archivePtr)
	End Method
	
	Rem
	bbdoc: Returns a textual name identifying the indicated filter.
	about: See FilterCount() for details of the numbering.
	End Rem
	Method FilterName:String(filter:Int)
		Return bmx_libarchive_archive_filter_name(archivePtr, filter)
	End Method
	
	Rem
	bbdoc: Returns a numeric code indicating the format of the current archive entry.
	about: This value is set by a successful call to ReadNextHeader(). Note that it is common for this value to
	change from entry to entry. For example, a tar archive might have several entries that utilize GNU
	tar extensions and several entries that do not. These entries will have different format codes.
	End Rem
	Method Format:Int()
		Return bmx_libarchive_archive_format(archivePtr)
	End Method
	
	Rem
	bbdoc: A textual description of the format of the current entry.
	End Rem
	Method FormatName:String()
		Return bmx_libarchive_archive_format_name(archivePtr)
	End Method
	
	Rem
	bbdoc: Returns the number of bytes read from or written to the indicated filter.
	about: In particular, Position(0) returns the number of bytes read or written by the format handler,
	while Position(-1) returns the number of bytes read or written to the archive. See FilterCount() for details of the numbering here.
	End Rem
	Method Position:Long(filter:Int)
		Local v:Long
		bmx_libarchive_archive_position(archivePtr, filter, Varptr v)
		Return v
	End Method

	Method Data:Int(data:Byte Ptr, size:Size_T) Abstract
	Method Free() Abstract
	
	Method Delete()
		Free()
	End Method
	
End Type

Rem
bbdoc: A readable archive.
about: This is used for extracting data from existing archives.
End Rem
Type TReadArchive Extends TArchive

	Field callbackData:TArchiveCallbackData
	Field passphraseCallback:String(archive:TReadArchive, data:Object, cancel:Int Var)
	Field passphraseCallbackData:Object
	Field StaticArray pw:Byte[1024]

	Function CreateArchive:TReadArchive()
		Return New TReadArchive()
	End Function
	
	Rem
	bbdoc: Creates a new instance of #TReadArchive.
	End Rem
	Method New()
		archivePtr = bmx_libarchive_read_archive_new()
	End Method

	Rem
	bbdoc: Creates a new instance of #TReadArchive with the specified format and filters.
	End Rem
	Method New(format:EArchiveFormat, filters:EArchiveFilter[])
		New()
		SetFormat(format)
		For Local filter:EArchiveFilter = Eachin filters
			AddFilter(filter)
		Next
	End Method

	Rem
	bbdoc: Registers a passphrase for the archive.
	End Rem
	Method AddPassphrase:Int(passphrase:String)
		Return bmx_libarchive_archive_read_add_passphrase(archivePtr, passphrase)
	End Method

Private
	Function _passphraseCallback:Byte Ptr(archive:TReadArchive) { nomangle }
		Local cancel:Int
		Local pass:String = archive.passphraseCallback(archive, archive.passphraseCallbackData, cancel)
		If cancel Then
			Return Null
		Else
			Local length:Size_T = 1024
			Return pass.ToUTF8StringBuffer(archive.pw, length)
		End If
	End Function
Public

	Rem
	bbdoc: Registers a callback function that will be invoked to get a passphrase for decryption after trying all the passphrases registered by #AddPassphrase.
	End Rem
	Method SetPassphraseCallback:Int(callback:String(archive:TReadArchive, data:Object, cancel:Int Var), data:Object)
		Local cb:Byte Ptr = callback
		If Not cb Then
			passphraseCallback = Null
			passphraseCallbackData = Null
			Return bmx_libarchive_archive_read_set_passphrase_callback(archivePtr, Null)
		Else
			passphraseCallback = callback
			passphraseCallbackData = data
			Return bmx_libarchive_archive_read_set_passphrase_callback(archivePtr, self)
		End If
	End Method

	Rem
	bbdoc: Returns #True if the archive has encrypted entries.
	End Rem
	Method HasEncryptedEntries:Int()
		Return bmx_libarchive_archive_read_has_encrypted_entries(archivePtr)
	End Method

	Rem
	bbdoc: Opens archive for reading from a file of the given @filename, with a block size of @blockSize bytes.
	about: The file should be readable.
	End Rem
	Method Open:Int(filename:String, blockSize:Int = 10240)
		Local stream:TStream = ReadStream(filename)

		If Not stream Then
			Throw New TArchiveException("Unable to create stream for reading")
		End If

		Return Open(stream, blockSize, True)
	End Method
	
	Rem
	bbdoc: Opens archive for reading from memory.
	about: @size indicates the size of the archive in memory at location @buf.
	End Rem
	Method Open:Int(buf:Byte Ptr, size:Size_T)
		Return bmx_libarchive_archive_read_open_memory(archivePtr, buf, size)
	End Method
	
	Rem
	bbdoc: Opens archive for reading from a @stream, with a block size of @blockSize bytes.
	about: @stream should already be created and readable.
	If @closeAfterRead is set, the stream will be closed when the archive is closed.
	End Rem
	Method Open:Int(stream:TStream, blockSize:Int = 10240, closeAfterRead:Int = False)

		If Not stream Then
			Throw New TArchiveException("stream cannot be Null")
		End If

		If Not callbackData Then
			callbackData = New TArchiveCallbackData(stream, blockSize)
		Else
			callbackData.Update(stream, blockSize)
		End If

		callbackData.shouldClose = closeAfterRead

		Return bmx_libarchive_archive_read_open(archivePtr, callbackData)
	End Method
	
	Rem
	bbdoc: Read the header for the next entry and populate the provided entry
	returns: ARCHIVE_OK (the operation succeeded), ARCHIVE_WARN (the operation succeeded but a non-critical error was encountered), ARCHIVE_EOF (end-of-archive was encountered), ARCHIVE_RETRY (the operation failed but can be retried), and ARCHIVE_FATAL (there was a fatal error; the archive should be closed immediately).
	End Rem
	Method ReadNextHeader:Int(entry:TArchiveEntry)
		Return bmx_libarchive_archive_read_next_header(archivePtr, entry.entryPtr)
	End Method

	Rem
	bbdoc: A convenience method that repeatedly skips all of the data for this archive entry. 
	End Rem
	Method DataSkip:Int()
		Return bmx_libarchive_archive_read_data_skip(archivePtr)
	End Method
	
	Rem
	bbdoc: Read data associated with the header just read.
	returns: A count of bytes actually read or zero at the end of the entry. On error, a value of #ARCHIVE_FATAL, #ARCHIVE_WARN, or #ARCHIVE_RETRY is returned.
	End Rem
	Method Data:Int(buf:Byte Ptr, size:Size_T) Override
		Return bmx_libarchive_archive_read_data(archivePtr, buf, size)
	End Method
	
	Rem
	bbdoc: Returns a readable #TStream of the current entry data.
	about: This can be used by any #TStream supported functionality.
	End Rem
	Method DataStream:TStream()
		Return New TArchiveInputStream(Self)
	End Method

	Rem
	bbdoc: Adds a filter for reading.
	End Rem
	Method AddFilter(filter:EArchiveFilter)
		ArchiveAddReadFilter(archivePtr, filter)
	End Method

	Rem
	bbdoc: Sets a format for reading.
	End Rem
	Method SetFormat(format:EArchiveFormat)
		ArchiveSetReadFormat(archivePtr, format)
	End Method

	Rem
	bbdoc: Sets a filter option.
	End Rem
	Method SetFilterOption:Int(option:String, value:String = Null, moduleName:String = Null)
		Return bmx_libarchive_archive_read_set_filter_option(archivePtr, option, value, moduleName)
	End Method

	Rem
	bbdoc: Sets a format option.
	End Rem
	Method SetFormatOption:Int(option:String, value:String = Null, moduleName:String = Null)
		Return bmx_libarchive_archive_read_set_format_option(archivePtr, option, value, moduleName)
	End Method

	Method Free() Override
		If archivePtr Then
			bmx_libarchive_archive_read_free(archivePtr)
			archivePtr = Null
		End If
	End Method

End Type

Rem
bbdoc: Data from a TReadArchive entry as a stream.
End Rem
Type TArchiveInputStream Extends TStream

	Field archive:TArchive
	
	Field _eof:Int
	
	Method New(archive:TArchive)
		Self.archive = archive
	End Method

	Method Read:Long( buf:Byte Ptr,count:Long )
		Local size:Long = archive.Data(buf, Size_T(count))
		If size <= 0 Then
			_eof = True
			If size < 0 Then
				size = 0
			End If
		End If
		Return size
	End Method

	Method ReadBytes:Long( buf:Byte Ptr,count:Long )
		Local t:Long=0
		While count>0
			Local n:Long=Read( buf,count )
			If Not n Exit
			count:-n
			buf:+n
			t:+ n
		Wend
		Return t
	End Method

	Method Eof:Int()
		Return _eof
	End Method

End Type

Type TArchiveOutputStream Extends TStream

	Field archive:TWriteArchive
	
	Field _eof:Int
	
	Method New(archive:TWriteArchive)
		Self.archive = archive
	End Method

	Method Write:Long( buf:Byte Ptr,count:Long )
		Return archive.Data(buf, Size_T(count))
	End Method

	Method WriteBytes:Long( buf:Byte Ptr,count:Long )
		Local t:Long=count
		While count>0
			Local n:Long=Write( buf,count )
			If Not n Exit
			count:-n
			buf:+n
		Wend
		Return t
	End Method

End Type

Type TArchiveCallbackData

	Field data:Byte[]
	Field stream:TStream
	Field shouldClose:Int

	Method New(stream:TStream, blockSize:Int = 10240)
		Self.data = New Byte[blockSize]
		Self.stream = stream
	End Method
	
	Function _read:Byte Ptr(cbData:Object, count:Long Var) { nomangle }
		Local data:TArchiveCallbackData = TArchiveCallbackData(cbData)
		
		Local buf:Byte Ptr = data.data
		Local c:Long = data.data.Length
		Local ncount:Long
		While c
			Local n:Long = data.stream.Read(buf, c)
			If Not n Then
				Exit
			End If
			c:-n
			ncount:+ n
			buf:+n
		Wend

		count = ncount
		Return data.data
	End Function
	
	Function _seek(cbData:Object, offset:Long, whence:Int, count:Long Var) { nomangle }
		Local data:TArchiveCallbackData = TArchiveCallbackData(cbData)

		Select whence
			Case SEEK_SET_
				count = data.stream.seek(offset)
			Case SEEK_CUR_
				count = data.stream.seek(offset + data.stream.pos())
			Case SEEK_END_
				count = data.stream.seek(data.stream.size())
		End Select
	End Function

	Function _write(cbData:Object, buf:Byte Ptr, length:Size_T, count:Long Var) { nomangle }
		Local data:TArchiveCallbackData = TArchiveCallbackData(cbData)
		count = data.stream.Write(buf, length)
	End Function

	Function _close:Int(cbData:Object) { nomangle }
		Local data:TArchiveCallbackData = TArchiveCallbackData(cbData)
		data.Close()
		Return ARCHIVE_OK
	End Function

	Method Update(stream:TStream, size:Int)
		Self.stream = stream
		data = data[..size]
	End Method

	Method Close()
		If shouldClose Then
			stream.Close()
		End If
	End Method

	Method Delete()
		data = Null
	End Method
End Type

Rem
bbdoc: A writeable archive.
End Rem
Type TWriteArchive Extends TArchive

	Field callbackData:TArchiveCallbackData

	Function CreateArchive:TWriteArchive()
		Return New TWriteArchive()
	End Function
	
	Rem
	bbdoc: Creates a new instance of #TWriteArchive.
	End Rem
	Method New()
		archivePtr = bmx_libarchive_write_archive_new()
	End Method

	Rem
	bbdoc: Creates a new instance of #TWriteArchive with the specified format and filters.
	End Rem
	Method New(format:EArchiveFormat, filters:EArchiveFilter[])
		New()
		SetFormat(format)
		For Local filter:EArchiveFilter = Eachin filters
			AddFilter(filter)
		Next
	End Method

	Rem
	bbdoc: Opens archive for writing to a file of the given @filename.
	about: The file should be writeable.
	End Rem
	Method Open:Int(filename:String)
		Local stream:TStream = WriteStream(filename)

		If Not stream Then
			Throw New TArchiveException("Unable to create stream for writing")
		End If

		Return Open(stream, True)
	End Method
	
	Rem
	bbdoc: Opens archive for writing to memory.
	about: The @size should be large enough for the final archive.
	After writing, @used will be populated with the total bytes used, so the pointer should remain valid until then.
	End Rem
	Method Open:Int(buf:Byte Ptr, size:Int, used:Size_T Ptr)
		Return bmx_libarchive_archive_write_open_memory(archivePtr, buf, size, Varptr used)
	End Method
	
	Rem
	bbdoc: Opens archive for writing to a @stream.
	about: @stream should already be created and writeable.
	If @closeAfterWrite is set, the stream will be closed once the write completes.
	End Rem
	Method Open:Int(stream:TStream, closeAfterWrite:Int = False)

		If Not stream Then
			Throw New TArchiveException("stream cannot be Null")
		End If

		If Not callbackData Then
			callbackData = New TArchiveCallbackData(stream, 0)
		Else
			callbackData.Update(stream, 0)
		End If

		callbackData.shouldClose = closeAfterWrite

		Return bmx_libarchive_archive_write_open(archivePtr, callbackData)
	End Method

	Rem
	bbdoc: Convience method for adding a file or #TStream to the archive.
	about: If adding a #TStream, you will also need to provide @pathname, @size and @ftime values.
	By default, files are added with the permission '0644' (decimal 420).
	@pathname can also be used to define the path (include sub directories) of the file within the archive - this
	is also dependent on support from the archive in question.

	@fileType will 
	End Rem
	Method AddEntry(file:Object, pathname:String = Null, size:Long = 0, ftime:Long = 0, fileType:EArchiveFileType = EArchiveFileType.File)
		If String(file) Then
			If Not pathname Then
				pathname = StripDir(String(file))
			End If

			If Not ftime Then
				ftime = FileTime(String(file))
			End If
		End If

		If Not pathname Then
			Throw New TArchiveException("Pathname is required. Unable to determine pathname from input")
		End If

		If fileType <> EArchiveFileType.File And fileType <> EArchiveFileType.Dir Then
			Throw New TArchiveException("fileType must be a File or a Dir.")
		End If

		Local stream:TStream
		
		If fileType = EArchiveFileType.File Then
			stream = ReadStream(file)

			If Not stream Then
				Throw New TArchiveException("Unabled to open stream for input file for path '" + pathname + "'")
			End If

			If Not size Then
				size = stream.Size()
			End If
		End If

		Local entry:TArchiveEntry = New TArchiveEntry
		entry.SetPathname(pathname)
		entry.SetFileType(fileType)

		If fileType = EArchiveFileType.File Then
			entry.SetPermission(420) ' 0644
			entry.SetSize(size)
			If ftime Then
				entry.SetModifiedTime(ftime)
			End If
		End If

		If Header(entry) <> ARCHIVE_OK Then
			Throw New TArchiveException(String.FromUTF8String(archive_error_string(archivePtr)))
		End If

		If fileType = EArchiveFileType.File Then
			Local StaticArray buf:Byte[8192]
			Local count:Size_T = size
			While count
				Local nCount:Long = stream.Read(buf, Min(count, buf.Length))
				If nCount <= 0 Then
					Exit
				End If
				Data(buf, Size_T(nCount))
				count :- nCount
			Wend

			If Not TStream(file) Then
				stream.Close()
			End If
		End If

		FinishEntry()
		entry.Free()
	End Method
	
	Rem
	bbdoc: Build and write a header using the data in the provided in the TArchiveEntry object.
	about: See TArchiveEntry for information on creating and populating such objects.
	End Rem
	Method Header:Int(entry:TArchiveEntry)
		Return bmx_libarchive_archive_write_header(archivePtr, entry.entryPtr)
	End Method
	
	Rem
	bbdoc: Closes the archive.
	End Rem
	Method Close:Int()
		Return bmx_libarchive_archive_write_close(archivePtr)
	End Method

	Rem
	bbdoc: Informs the archive that the current archive entry is finished.
	End Rem
	Method FinishEntry:Int()
		Return bmx_libarchive_archive_write_finish_entry(archivePtr)
	End Method
	
	Rem
	bbdoc: Writes @size bytes of data to the current archive entry.
	End Rem
	Method Data:Int(data:Byte Ptr, size:Size_T) Override
		Return bmx_libarchive_archive_write_data(archivePtr, data, size)
	End Method

	Rem
	bbdoc: Returns a writeable #TStream.
	about: This can be used by any #TStream supported functionality.
	End Rem
	Method DataStream:TStream()
		Return New TArchiveOutputStream(Self)
	End Method

	Rem
	bbdoc: Sets a passphrase for the archive.
	End Rem
	Method SetPassphrase:Int(passphrase:String)
		Return bmx_libarchive_archive_write_set_passphrase(archivePtr, passphrase)
	End Method

	Rem
	bbdoc: Adds a filter for writing.
	End Rem
	Method AddFilter(filter:EArchiveFilter)
		ArchiveAddWriteFilter(archivePtr, filter)
	End Method

	Rem
	bbdoc: Adds a format for writing.
	End Rem
	Method SetFormat(format:EArchiveFormat)
		ArchiveSetWriteFormat(archivePtr, format)
	End Method

	Rem
	bbdoc: Sets a filter option.
	End Rem
	Method SetFilterOption:Int(option:String, value:String = Null, moduleName:String = Null)
		Return bmx_libarchive_archive_write_set_filter_option(archivePtr, option, value, moduleName)
	End Method

	Rem
	bbdoc: Sets a format option.
	End Rem
	Method SetFormatOption:Int(option:String, value:String = Null, moduleName:String = Null)
		Return bmx_libarchive_archive_write_set_format_option(archivePtr, option, value, moduleName)
	End Method

	Rem
	bbdoc: Sets the compression level for a compatible format/filter.
	returns: #ARCHIVE_OK on success, or an error code.
	about: 

| Type    | Supported Compression Level | Notes                                                                                                                                     |
|---------|:---------------------------:|-------------------------------------------------------------------------------------------------------------------------------------------|
| bzip2   |            1 - 9            |                                                                                                                                           |
| gzip    |            0 - 9            |                                                                                                                                           |
| lz4     |            0 - 9            |                                                                                                                                           |
| lzop    |            1 - 9            |                                                                                                                                           |
| xz      |            0 - 9            |                                                                                                                                           |
| zstd    |            1 - 22           |                                                                                                                                           |
| 7zip    |            0 - 9            |                                                                                                                                           |
| iso9660 |      0 - 9 (default 6)      |                                                                                                                                           |
| zip     |            0 - 9            | A compression level of 0 switches the compression method to "store", other values will enable "deflate" compression with the given level. |

	End Rem
	Method SetCompressionLevel:Int(level:Int)
		Return bmx_libarchive_archive_write_set_option(archivePtr, "compression-level", String(level), Null)
	End Method

	Rem
	bbdoc: Sets the compression type for a compatible format/filter.
	returns: #ARCHIVE_OK on success, or an error code.
	about: 

| Type | Notes                                                                                                                                                                                                                                    |
|------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 7zip | The value is one of "store", "deflate", "bzip2", "lzma1", "lzma2" or "ppmd" to indicate how the following entries should be compressed.<br>Note that this setting is ignored for directories, symbolic links, and other special entries. |
| zip  | The value is either "store" or "deflate" to indicate how the following entries should be compressed.<br>Note that this setting is ignored for directories, symbolic links, and other special entries.                                    |

	End Rem
	Method SetCompressionType:Int(compressionType:String)
		Return bmx_libarchive_archive_write_set_option(archivePtr, "compression", compressionType, Null)
	End Method

	Rem
	bbdoc: Sets the encryption type.
	about: Only applies to Zip archives.
	End Rem
	Method SetEncryption:Int(encryptionType:EArchiveEncryptionType)
		Local ty:String
		Select encryptionType
			Case EArchiveEncryptionType.Zip
				ty = "zipcrypt"
			Case EArchiveEncryptionType.AES128
				ty = "aes128"
			Case EArchiveEncryptionType.AES256
				ty = "aes256"
		End Select
		If Not ty Then
			Return ARCHIVE_FAILED
		End If
		Return bmx_libarchive_archive_write_set_option(archivePtr, "encryption", ty, Null)
	End Method

	Rem
	bbdoc: Frees the archive.
	End Rem
	Method Free() Override
		If archivePtr Then
			bmx_libarchive_archive_write_free(archivePtr)
			archivePtr = Null
		End If
	End Method

End Type

Rem
bbdoc: Represents entries within an archive.
about: You can think of a #TArchiveEntry as a heavy-duty version of the c struct stat: it includes everything from struct stat plus
associated pathname, textual group and user names, etc. These objects are used by libarchive to represent the metadata associated
with a particular entry in an archive.
End Rem
Type TArchiveEntry

	Field entryPtr:Byte Ptr
	
	Function _create:TArchiveEntry(entryPtr:Byte Ptr)
		If entryPtr Then
			Local this:TArchiveEntry = New TArchiveEntry(entryPtr)
			Return this
		End If
		Return Null
	End Function
	
	Rem
	bbdoc: Creates a new #TArchiveEntry instance.
	End Rem
	Method New()
		entryPtr = bmx_libarchive_archive_entry_new()
		SetFileType(EArchiveFileType.File)
	End Method

	Rem
	bbdoc: Creates a new #TArchiveEntry instance using the specified @entryPtr handle.
	End Rem
	Method New(entryPtr:Byte Ptr)
		Self.entryPtr = entryPtr
	End Method
	
	Rem
	bbdoc: Returns the entry access time, if set.
	End Rem
	Method AccessTime:Long()
		return bmx_libarchive_archive_entry_atime(entryPtr)
	End Method

	Rem
	bbdoc: Returns the entry access time, in nanoseconds.
	End Rem
	Method AccessTimeNano:Long()
		Return bmx_libarchive_archive_entry_atime_nsec(entryPtr)
	End Method

	Rem
	bbdoc: Returns #True if the access time is set.
	End Rem
	Method AccessTimeIsSet:Int()
		Return bmx_libarchive_archive_entry_atime_is_set(entryPtr)
	End Method

	Rem
	bbdoc: Sets the access time for the entry.
	End Rem
	Method SetAccessTime(atime:Long, nanoseconds:Long = 0)
		bmx_libarchive_archive_entry_set_atime(entryPtr, atime, nanoseconds)
	End Method

	Rem
	bbdoc: Unsets entry access time.
	End Rem
	Method UnsetAccessTime()
		bmx_libarchive_archive_entry_unset_atime(entryPtr)
	End Method

	Rem
	bbdoc: Returns the entry birth time, if set.
	End Rem
	Method BirthTime:Long()
		return bmx_libarchive_archive_entry_birthtime(entryPtr)
	End Method

	Rem
	bbdoc: Returns the entry birth time, in nanoseconds.
	End Rem
	Method BirthTimeNano:Long()
		return bmx_libarchive_archive_entry_birthtime_nsec(entryPtr)
	End Method

	Rem
	bbdoc: Returns #True if the birth time is set.
	End Rem
	Method BirthTimeIsSet:Int()
		return bmx_libarchive_archive_entry_birthtime_is_set(entryPtr)
	End Method

	Rem
	bbdoc: Sets the birth time for the entry.
	End Rem
	Method SetBirthTime(btime:Long, nanoseconds:Long = 0)
		bmx_libarchive_archive_entry_set_birthtime(entryPtr, btime, nanoseconds)
	End Method

	Rem
	bbdoc: Unsets the birth time of the entry.
	End Rem
	Method UnsetBirthTime()
		bmx_libarchive_archive_entry_unset_birthtime(entryPtr)
	End Method

	Rem
	bbdoc: Erases the object, resetting all internal fields to the same state as a newly-created object.
	about: This is provided to allow you to quickly recycle objects.
	End Rem
	Method Clear()
		entryPtr = bmx_libarchive_archive_entry_clear(entryPtr)
	End Method
	
	Rem
	bbdoc: A deep copy operation; all text fields are duplicated.
	End Rem
	Method Clone:TArchiveEntry()
		Return TArchiveEntry._create(bmx_libarchive_archive_entry_clone(entryPtr))
	End Method

	Rem
	bbdoc: Returns the entry inode change time, if set.
	End Rem
	Method CTime:Long()
		return bmx_libarchive_archive_entry_ctime(entryPtr)
	End Method

	Rem
	bbdoc: Returns the entry inode change time, in nanoseconds.
	End Rem
	Method CTimeNano:Long()
		return bmx_libarchive_archive_entry_ctime_nsec(entryPtr)
	End Method

	Rem
	bbdoc: Returns #True if the inode change time is set.
	End Rem
	Method CTimeIsSet:Int()
		return bmx_libarchive_archive_entry_ctime_is_set(entryPtr)
	End Method

	Rem
	bbdoc: Unsets the inode change time.
	End Rem
	Method UnsetCTime()
		bmx_libarchive_archive_entry_unset_ctime(entryPtr)
	End Method

	Rem
	bbdoc: Returns the entry file type.
	End Rem
	Method FileType:EArchiveFileType()
		Return bmx_libarchive_archive_entry_filetype(entryPtr)
	End Method

	Rem
	bbdoc: Destination of the hardlink.
	End Rem
	Method Hardlink:String()
		Return bmx_libarchive_archive_entry_hardlink(entryPtr)
	End Method

	Rem
	bbdoc: Returns #True if the entry data is encrypted.
	End Rem
	Method IsDataEncrypted:Int()
		Return bmx_libarchive_archive_entry_is_data_encrypted(entryPtr)
	End Method

	Rem
	bbdoc: Returns #True if the entry metadata is encrypted.
	End Rem
	Method IsMetadataEncrypted:Int()
		Return bmx_libarchive_archive_entry_is_metadata_encrypted(entryPtr)
	End Method

	Rem
	bbdoc: Returns #True if the entry is encrypted.
	End Rem
	Method IsEncrypted:Int()
		Return bmx_libarchive_archive_entry_is_encrypted(entryPtr)
	End Method

	Rem
	bbdoc: Path in the archive.
	End Rem
	Method Pathname:String()
		Return bmx_libarchive_archive_entry_pathname(entryPtr)
	End Method
	
	Rem
	bbdoc: Destination of the symbolic link.
	End Rem
	Method Symlink:String()
		Return bmx_libarchive_archive_entry_symlink(entryPtr)
	End Method
	
	Rem
	bbdoc: Sets the creation time of the entry.
	End Rem
	Method SetCreationTime(time:Long, nanoseconds:Long = 0)
		bmx_libarchive_archive_entry_set_ctime(entryPtr, time, nanoseconds)
	End Method

	Rem
	bbdoc: Sets the file type of the entry.
	End Rem
	Method SetFileType(fType:EArchiveFileType)
		bmx_libarchive_archive_entry_set_filetype(entryPtr, fType)
	End Method

	Rem
	bbdoc: 
	End Rem
	Method SetHardlink(path:String)
	End Method
	
	Rem
	bbdoc: For a symlink, update the destination, otherwise, make the entry a hardlink and alter the destination for that.
	about: Update only. 
	End Rem
	Method SetLink(path:String)
		bmx_libarchive_archive_entry_set_link(entryPtr, path)
	End Method
	
	Rem
	bbdoc: Sets the modified time of the entry.
	End Rem
	Method SetModifiedTime(time:Long, nanoseconds:Long = 0)
		bmx_libarchive_archive_entry_set_mtime(entryPtr, time, nanoseconds)
	End Method

	Rem
	bbdoc: Returns the entry modified time, if set.
	End Rem
	Method ModifiedTime:Long()
		return bmx_libarchive_archive_entry_mtime(entryPtr)
	End Method

	Rem
	bbdoc: Returns the entry modified time, in nanoseconds.
	End Rem
	Method ModifiedTimeNano:Long()
		return bmx_libarchive_archive_entry_mtime_nsec(entryPtr)
	End Method

	Rem
	bbdoc: Returns #True if the modified time is set.
	End Rem
	Method ModifiedTimeIsSet:Int()
		return bmx_libarchive_archive_entry_mtime_is_set(entryPtr)
	End Method

	Rem
	bbdoc: Unsets the modified time.
	End Rem
	Method UnsetModifiedTime()
		bmx_libarchive_archive_entry_unset_mtime(entryPtr)
	End Method

	Rem
	bbdoc: Sets the pathname of the entry.
	End Rem
	Method SetPathname(path:String)
		bmx_libarchive_archive_entry_set_pathname(entryPtr, path)
	End Method
	
	Rem
	bbdoc: Sets the permission of the entry.
	End Rem
	Method SetPermission(perm:Int)
		bmx_libarchive_archive_entry_set_perm(entryPtr, perm)
	End Method

	Rem
	bbdoc: Sets the size, in bytes, of the entry.
	End Rem
	Method SetSize(size:Long)
		bmx_libarchive_archive_entry_set_size(entryPtr, size)
	End Method

	Rem
	bbdoc: 
	End Rem
	Method SetSymlink(path:String)
		bmx_libarchive_archive_entry_set_symlink(entryPtr, path)
	End Method

	Rem
	bbdoc: Returns true if the size is set.
	End Rem
	Method SizeIsSet:Int()
		Return bmx_libarchive_archive_entry_size_is_set(entryPtr)
	End Method

	Rem
	bbdoc: Returns the uncompressed size of the entry, if available.
	End Rem
	Method Size:Long()
		Return bmx_libarchive_archive_entry_size(entryPtr)
	End Method

	Rem
	bbdoc: Unsets the size of the entry.
	End Rem
	Method UnsetSize()
		bmx_libarchive_archive_entry_unset_size(entryPtr)
	End Method

	Rem
	bbdoc: Releases the archive entry object.
	End Rem
	Method Free()
		If entryPtr Then
			bmx_libarchive_archive_entry_free(entryPtr)
			entryPtr = Null
		End If
	End Method
	
	Method Delete()
		Free()
	End Method
	
End Type


Private

Global _archive_formats:TArchiveFormat

Function ArchiveSetReadFormat(archive:Byte Ptr, format:EArchiveFormat)
	Local af:TArchiveFormat=_archive_formats

	While af
		If af.AddReadFormat(archive, format) Then
			Return
		End If
		af=af._succ
	Wend

	Throw New TArchiveException("Read format not found. Ensure the module has been imported : " + format.ToString())
End Function

Function ArchiveSetWriteFormat(archive:Byte Ptr, format:EArchiveFormat)
	Local af:TArchiveFormat=_archive_formats

	While af
		If af.AddWriteFormat(archive, format) Then
			Return
		End If
		af=af._succ
	Wend

	Throw New TArchiveException("Write format not found. Ensure the module has been imported : " + format.ToString())
End Function

Function ArchiveAddReadFilter(archive:Byte Ptr, filter:EArchiveFilter)
	Local af:TArchiveFormat=_archive_formats

	While af
		If af.AddReadFilter(archive, filter) Then
			Return
		End If
		af=af._succ
	Wend

	Throw New TArchiveException("Read filter not found. Ensure the module has been imported : " + filter.ToString())
End Function

Function ArchiveAddWriteFilter(archive:Byte Ptr, filter:EArchiveFilter)
	Local af:TArchiveFormat=_archive_formats

	While af
		If af.AddWriteFilter(archive, filter) Then
			Return
		End If
		af=af._succ
	Wend

	Throw New TArchiveException("Write filter not found. Ensure the module has been imported : " + filter.ToString())
End Function

Public

Type TArchiveFormat
	Field _succ:TArchiveFormat
	
	Method New()
		_succ=_archive_formats
		_archive_formats=Self
	End Method
	
	Method AddReadFormat:Int(archive:Byte Ptr, format:EArchiveFormat) Abstract
	Method AddWriteFormat:Int(archive:Byte Ptr, format:EArchiveFormat) Abstract
	Method AddReadFilter:Int(archive:Byte Ptr, filter:EArchiveFilter) Abstract
	Method AddWriteFilter:Int(archive:Byte Ptr, filter:EArchiveFilter) Abstract
	
End Type

Type TArchiveException Extends TRuntimeException

End Type
