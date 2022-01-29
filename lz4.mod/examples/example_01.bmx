SuperStrict

Framework Archive.Lz4
Import Archive.Raw
Import brl.standardio

Local wa:TWriteArchive = New TWriteArchive
wa.AddFilter(EArchiveFilter.LZ4)
wa.SetFormat(EArchiveFormat.RAW)

wa.Open("data.lz4")

wa.AddEntry("testdata.txt")

wa.Close()


Local entry:TArchiveEntry = New TArchiveEntry

Local ra:TReadArchive = New TReadArchive
ra.AddFilter(EArchiveFilter.LZ4)
ra.SetFormat(EArchiveFormat.RAW)

ra.Open("data.lz4")

While ra.ReadNextHeader(entry) = ARCHIVE_OK
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()
