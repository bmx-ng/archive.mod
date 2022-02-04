SuperStrict

Framework Archive.Zip
Import brl.standardio

Local wa:TWriteArchive = New TWriteArchive
wa.SetFormat(EArchiveFormat.ZIP)
wa.SetCompressionLevel(9)

wa.Open("data.zip")

wa.AddEntry("testdata.txt", "files/testdata.txt")
wa.AddEntry("테스트_데이터.txt", "files/테스트_데이터.txt")
wa.AddEntry("", "empty", 0, 0, EArchiveFileType.Dir)

wa.Close()


Local entry:TArchiveEntry = New TArchiveEntry

Local ra:TReadArchive = New TReadArchive
ra.SetFormat(EArchiveFormat.ZIP)
ra.Open("data.zip")

While ra.ReadNextHeader(entry) = ARCHIVE_OK
	Print "File : " + entry.Pathname()
	Print "Size : " + entry.Size()
	Print "Type : " + entry.FileType().ToString()
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()

