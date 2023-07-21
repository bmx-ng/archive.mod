SuperStrict

Framework Archive.Zip
Import brl.standardio
Import archive.sevenzip

Local wa:TWriteArchive = New TWriteArchive
wa.SetFormat(EArchiveFormat.ZIP)
wa.SetEncryption(EArchiveEncryptionType.AES256)
wa.SetPassphrase("abc123")

wa.Open("data.zip")

wa.AddEntry("testdata.txt", "files/testdata.txt")
wa.AddEntry("테스트_데이터.txt", "files/테스트_데이터.txt")

wa.Close()


Local entry:TArchiveEntry = New TArchiveEntry


Local raCheckEncryption:TReadArchive = New TReadArchive
Local hasEncryption:Int
raCheckEncryption.SetFormat(EArchiveFormat.SEVEN_ZIP)
raCheckEncryption.Open("data.7z")
'raCheckEncryption.AddPassphrase("abc123")
print raCheckEncryption.HasEncryptedEntries()

While raCheckEncryption.ReadNextHeader(entry) > ARCHIVE_FAILED	
	hasEncryption = raCheckEncryption.HasEncryptedEntries()
	if hasEncryption = -2 Then exit 'encryption not supported
	if hasEncryption >= 0 Then exit 'we know now if we have (1) or not have (0) encryption
	raCheckEncryption.DataSkip()
Wend
raCheckEncryption.free()
print "hasEncryption = " + hasEncryption
end


Local ra:TReadArchive = New TReadArchive
ra.SetFormat(EArchiveFormat.SEVEN_ZIP)
ra.SetPassphraseCallback(GetPass, Null)

ra.Open("data.7z")

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
