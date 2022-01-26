SuperStrict

Framework Archive.Compress
Import Archive.Raw
Import brl.standardio

Local wa:TWriteArchive = New TWriteArchive
wa.AddFilter(EArchiveFilter.COMPRESS)
wa.SetFormat(EArchiveFormat.RAW)

wa.Open("data.Z")

wa.AddEntry("testdata.txt")

wa.Close()


Local entry:TArchiveEntry = New TArchiveEntry

Local ra:TReadArchive = New TReadArchive
ra.AddFilter(EArchiveFilter.COMPRESS)
ra.SetFormat(EArchiveFormat.RAW)

ra.Open("data.Z")

While ra.ReadNextHeader(entry) = ARCHIVE_OK
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()
