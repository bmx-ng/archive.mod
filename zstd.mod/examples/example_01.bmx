SuperStrict

Framework Archive.Zstd
Import Archive.Raw
Import BRL.TextStream

' Write

Local wa:TWriteArchive = New TWriteArchive
wa.SetFormat(EArchiveFormat.RAW)
wa.AddFilter(EArchivefilter.ZSTD)
wa.SetCompressionLevel(20)

wa.Open("data.zstd")

wa.AddEntry("warandpeace.txt")

wa.Close()

' Read

Local ra:TReadArchive = New TReadArchive
ra.SetFormat(EArchiveFormat.RAW)
ra.AddFilter(EArchivefilter.ZSTD)

ra.Open("data.zstd")

Local entry:TArchiveEntry = New TArchiveEntry

While ra.ReadNextHeader(entry) = ARCHIVE_OK
	Print "File : " + entry.Pathname()
	Print "Size : " + entry.Size()
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()
