SuperStrict

Framework Archive.UU
Import Archive.tar
Import Archive.GZip
Import brl.standardio

Local wa:TWriteArchive = New TWriteArchive
wa.AddFilter(EArchiveFilter.GZIP)
wa.SetFormat(EArchiveFormat.Tar)
wa.AddFilter(EArchiveFilter.UU)
wa.SetCompressionLevel(9)

wa.Open("data.tar.gz.uu")

wa.AddEntry("testdata.txt", "files/testdata.txt")
wa.AddEntry("테스트_데이터.txt", "files/테스트_데이터.txt")
wa.AddEntry("", "empty", 0, 0, EArchiveFileType.Dir)

wa.Close()


Local entry:TArchiveEntry = New TArchiveEntry

Local ra:TReadArchive = New TReadArchive
ra.AddFilter(EArchiveFilter.GZIP)
ra.SetFormat(EArchiveFormat.Tar)
ra.AddFilter(EArchiveFilter.UU)

ra.Open("data.tar.gz.uu")

While ra.ReadNextHeader(entry) = ARCHIVE_OK
	Print "File : " + entry.Pathname()
	Print "Size : " + entry.Size()
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()

