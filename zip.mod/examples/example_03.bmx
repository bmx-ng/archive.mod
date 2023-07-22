SuperStrict

Framework Archive.Zip
Import brl.standardio

Local wa:TWriteArchive = New TWriteArchive
wa.SetFormat(EArchiveFormat.ZIP)
wa.SetEncryption(EArchiveEncryptionType.AES256)
wa.SetPassphrase("abc123")

wa.Open("data.zip")

wa.AddEntry("testdata.txt", "files/testdata.txt")
wa.AddEntry("테스트_데이터.txt", "files/테스트_데이터.txt")

wa.Close()


Local entry:TArchiveEntry = New TArchiveEntry

Local ra:TReadArchive = New TReadArchive
ra.SetFormat(EArchiveFormat.ZIP)
ra.SetPassphraseCallback(GetPass, Null)

ra.Open("data.zip")

While ra.ReadNextHeader(entry) = ARCHIVE_OK	
	Print "File : " + entry.Pathname()
	Print "Size : " + entry.Size()
	Local s:String = LoadText(ra.DataStream())
	Print "String size   : " + s.Length
	Print "First n chars : " + s[0..17]
	Print
Wend

ra.Free()

Function GetPass:String(archive:TReadArchive, data:Object, cancel:Int Var)
	Global count:Int
	If count = 3 Then
		cancel = True
		Return Null
	End If

	count :+ 1
	Local pass:String = Input("Enter Password (abc123): ")
	Return pass
End Function
