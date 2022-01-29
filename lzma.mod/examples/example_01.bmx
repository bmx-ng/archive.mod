SuperStrict

Framework Archive.Lzma
Import Archive.Raw
Import brl.standardio

Local wa:TWriteArchive = New TWriteArchive
wa.AddFilter(EArchiveFilter.LZMA)
wa.SetFormat(EArchiveFormat.RAW)

wa.Open("data.lzma")

wa.AddEntry("testdata.txt")

wa.Close()


Local entry:TArchiveEntry = New TArchiveEntry

Local ra:TReadArchive = New TReadArchive
ra.AddFilter(EArchiveFilter.LZMA)
ra.SetFormat(EArchiveFormat.RAW)

ra.Open("data.lzma")

While ra.ReadNextHeader(entry) = ARCHIVE_OK
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()
