SuperStrict

Framework Archive.Rar
Import brl.standardio

Local entry:TArchiveEntry = New TArchiveEntry

Local ra:TReadArchive = New TReadArchive
ra.SetFormat(EArchiveFormat.RAR)
ra.Open("data.rar")

While ra.ReadNextHeader(entry) = ARCHIVE_OK
	Print "File : " + entry.Pathname()
	Print "Size : " + entry.Size()
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()
