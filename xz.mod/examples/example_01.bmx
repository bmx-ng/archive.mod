SuperStrict

Framework Archive.Xz
Import Archive.Raw

Local wa:TWriteArchive = New TWriteArchive
wa.AddFilter(EArchiveFilter.XZ)
wa.SetFormat(EArchiveFormat.RAW)

wa.Open("data.xz")

wa.AddFile("testdata.txt")

wa.Close()
