SuperStrict

Framework Archive.Lha
Import brl.standardio


Local entry:TArchiveEntry = New TArchiveEntry

Local ra:TReadArchive = New TReadArchive
ra.SetFormat(EArchiveFormat.LHA)

ra.Open("example.lha")

While ra.ReadNextHeader(entry) = ARCHIVE_OK
	Print "File : " + entry.Pathname()
	Print "Size : " + entry.Size()
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()
