SuperStrict

Framework Archive.Ar
Import brl.standardio

Local wa:TWriteArchive = New TWriteArchive
wa.SetFormat(EArchiveFormat.AR_BSD)

wa.Open("data.a")

wa.AddEntry("testdata.txt", "files/testdata.txt")
wa.AddEntry("테스트_데이터.txt", "files/테스트_데이터.txt")

wa.Close()


Local entry:TArchiveEntry = New TArchiveEntry

Local ra:TReadArchive = New TReadArchive
ra.SetFormat(EArchiveFormat.AR)
ra.Open("data.a")

While ra.ReadNextHeader(entry) = ARCHIVE_OK
	Print "File : " + entry.Pathname()
	Print "Size : " + entry.Size()
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()
