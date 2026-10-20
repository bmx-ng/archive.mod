Framework brl.standardio
Import BRL.MaxUnit
Import Archive.MiniZip

New TTestSuite.run()

Type TMzShaTest Extends TTest

	Const testString:String = "the quick and lazy fox did his thang"
	
	Method testSha1() { test }

		Local sha:TMzSha = New TMzSha()
		Local data:Byte Ptr = testString.ToUtf8String()
		Local digest:Byte Ptr = StackAlloc(MZ_HASH_SHA1_SIZE)
		Local size:Int = MZ_HASH_SHA1_SIZE

		sha.SetAlgorithm(MZ_HASH_SHA1)

		sha.Start()
		sha.Update(data, testString.Length)
		sha.Finish(digest, size)
		sha.Free()
		MemFree(data)

		AssertEquals("3efb8392b6cd8e14bd76bd08081521dc73df418c", BytesToHex(digest, size), "test sha1")
	End Method

	Method testSha224() { test }

		Local sha:TMzSha = New TMzSha()
		Local data:Byte Ptr = testString.ToUtf8String()
		Local digest:Byte Ptr = StackAlloc(MZ_HASH_SHA224_SIZE)
		Local size:Int = MZ_HASH_SHA224_SIZE

		sha.SetAlgorithm(MZ_HASH_SHA224)

		sha.Start()
		sha.Update(data, testString.Length)
		sha.Finish(digest, size)
		sha.Free()
		MemFree(data)

		AssertEquals("9e444f5f0b6582a923bd48696155f4a2f0d914e044cb64b8729a6600", BytesToHex(digest, size), "test sha224")
	End Method

	Method testSha256() { test }

		Local sha:TMzSha = New TMzSha()
		Local data:Byte Ptr = testString.ToUtf8String()
		Local digest:Byte Ptr = StackAlloc(MZ_HASH_SHA256_SIZE)
		Local size:Int = MZ_HASH_SHA256_SIZE

		sha.SetAlgorithm(MZ_HASH_SHA256)

		sha.Start()
		sha.Update(data, testString.Length)
		sha.Finish(digest, size)
		sha.Free()
		MemFree(data)

		AssertEquals("7a31ea0848525f7ebfeec9ee532bcc5d6d26772427e097b86cf440a56546541c", BytesToHex(digest, size), "test sha256")
	End Method

	Method testSha384() { test }

		Local sha:TMzSha = New TMzSha()
		Local data:Byte Ptr = testString.ToUtf8String()
		Local digest:Byte Ptr = StackAlloc(MZ_HASH_SHA384_SIZE)
		Local size:Int = MZ_HASH_SHA384_SIZE

		sha.SetAlgorithm(MZ_HASH_SHA384)

		sha.Start()
		sha.Update(data, testString.Length)
		sha.Finish(digest, size)
		sha.Free()
		MemFree(data)

		AssertEquals("e1e42e5977965bb3621231a5df3a1e83c471fa91fde33b6a30c8c4fa0d8be29ba7171c7c9487db91e9ee7e85049f7b41", BytesToHex(digest, size), "test sha256")
	End Method

	Method testSha512() { test }

		Local sha:TMzSha = New TMzSha()
		Local data:Byte Ptr = testString.ToUtf8String()
		Local digest:Byte Ptr = StackAlloc(MZ_HASH_SHA512_SIZE)
		Local size:Int = MZ_HASH_SHA512_SIZE

		sha.SetAlgorithm(MZ_HASH_SHA512)

		sha.Start()
		sha.Update(data, testString.Length)
		sha.Finish(digest, size)
		sha.Free()
		MemFree(data)

		AssertEquals("6627e7643ee7ce633e03f52d22329c3a32597364247c5275d4369985e1518626da46f595ad327667346479d246359b8b381af791ce2ac8c53a4788050eea11fe", BytesToHex(digest, size), "test sha256")
	End Method

End Type

Type TMzAesTest Extends TTest

	Const shortKey:String = "awesomekeythisis"
	Const longerKey:String = "awesomekeythisisbeefyone"
	Const longestKey:String = "awesomekeythisisevenmoresolidone"
	Const test:String = "youknowitsogrowi"
	Const iv:String = "0123456789123456"
	Const aad:String = "additional authentication data"

	Method testAes128() { test }

		Local aes:TMzAes = New TMzAes()
		Local k:Byte Ptr = shortKey.ToUtf8String()
		Local t:Byte Ptr = test.ToUtf8String()
		Local buf:Byte Ptr = StackAlloc(120)

		aes.SetEncryptKey(k, shortKey.Length, Null, 0)
		MemCopy(buf, t, Size_T(test.Length))

		AssertEquals(test.Length, aes.Encrypt(Null, 0, buf, test.Length), "test aes128 encrypt")

		aes.Free()

		AssertFalse(CompareBytes(buf, t, test.Length))

		aes = New TMzAes()
		aes.SetDecryptKey(k, shortKey.Length, Null, 0)
		AssertEquals(test.Length, aes.Decrypt(Null, 0, buf, test.Length), "test aes128 decrypt")
		
		aes.Free()

		AssertTrue(CompareBytes(buf, t, test.Length))

		MemFree(k)
		MemFree(t)

	End Method

	Method testAes128Cbc() { test }

		Local aes:TMzAes = New TMzAes()
		Local k:Byte Ptr = shortKey.ToUtf8String()
		Local t:Byte Ptr = test.ToUtf8String()
		Local i:Byte Ptr = iv.ToUtf8String()
		Local buf:Byte Ptr = StackAlloc(120)

		aes.SetMode(MZ_AES_MODE_CBC)
		aes.SetEncryptKey(k, shortKey.Length, i, iv.Length)
		MemCopy(buf, t, Size_T(test.Length))

		AssertEquals(test.Length, aes.Encrypt(Null, 0, buf, test.Length), "test aes128cbc encrypt")

		aes.Free()

		AssertFalse(CompareBytes(buf, t, test.Length))

		aes = New TMzAes()
		aes.SetMode(MZ_AES_MODE_CBC)
		aes.SetDecryptKey(k, shortKey.Length, i, iv.Length)
		AssertEquals(test.Length, aes.Decrypt(Null, 0, buf, test.Length), "test aes128cbc decrypt")
		
		aes.Free()

		AssertTrue(CompareBytes(buf, t, test.Length))

		MemFree(i)
		MemFree(k)
		MemFree(t)

	End Method

	Method testAes128Gcm() { test }

		Local aes:TMzAes = New TMzAes()
		Local k:Byte Ptr = shortKey.ToUtf8String()
		Local t:Byte Ptr = test.ToUtf8String()
		Local i:Byte Ptr = iv.ToUtf8String()
		Local a:Byte Ptr = aad.ToUtf8String()
		Local buf:Byte Ptr = StackAlloc(120)
		Local tag:Byte Ptr = StackAlloc(MZ_AES_BLOCK_SIZE)

		aes.SetMode(MZ_AES_MODE_GCM)
		aes.SetEncryptKey(k, shortKey.Length, i, iv.Length)
		MemCopy(buf, t, Size_T(test.Length))
		MemCopy(buf + test.Length, t, Size_T(test.Length))

		AssertEquals(test.Length, aes.Encrypt(a, aad.Length, buf, test.Length), "test aes128gcm encrypt")
		AssertEquals(test.Length, aes.EncryptFinal(buf + test.Length, test.Length, tag, MZ_AES_BLOCK_SIZE), "test aes128gcm encryptfinal")

		aes.Free()

		AssertFalse(CompareBytes(buf, t, test.Length))

		aes = New TMzAes()
		aes.SetMode(MZ_AES_MODE_GCM)
		aes.SetDecryptKey(k, shortKey.Length, i, iv.Length)
		AssertEquals(test.Length, aes.Decrypt(a, aad.Length, buf, test.Length), "test aes128gcm decrypt")
		AssertEquals(test.Length, aes.DecryptFinal(buf + test.Length, test.Length, tag, MZ_AES_BLOCK_SIZE), "test aes128gcm decryptfinal")
		
		aes.Free()

		AssertTrue(CompareBytes(buf, t, test.Length))
		AssertTrue(CompareBytes(buf + test.Length, t, test.Length))

		MemFree(i)
		MemFree(k)
		MemFree(t)
		MemFree(a)

	End Method

	Method testAes192() { test }

		Local aes:TMzAes = New TMzAes()
		Local k:Byte Ptr = longerKey.ToUtf8String()
		Local t:Byte Ptr = test.ToUtf8String()
		Local buf:Byte Ptr = StackAlloc(120)

		aes.SetEncryptKey(k, longerKey.Length, Null, 0)
		MemCopy(buf, t, Size_T(test.Length))

		AssertEquals(test.Length, aes.Encrypt(Null, 0, buf, test.Length), "test aes192 encrypt")

		aes.Free()

		AssertFalse(CompareBytes(buf, t, test.Length))

		aes = New TMzAes()
		aes.SetDecryptKey(k, longerKey.Length, Null, 0)
		AssertEquals(test.Length, aes.Decrypt(Null, 0, buf, test.Length), "test aes192 decrypt")
		
		aes.Free()

		AssertTrue(CompareBytes(buf, t, test.Length))

		MemFree(k)
		MemFree(t)

	End Method

	Method testAes256() { test }

		Local aes:TMzAes = New TMzAes()
		Local k:Byte Ptr = longestKey.ToUtf8String()
		Local t:Byte Ptr = test.ToUtf8String()
		Local buf:Byte Ptr = StackAlloc(120)

		aes.SetEncryptKey(k, longestKey.Length, Null, 0)
		MemCopy(buf, t, Size_T(test.Length))

		AssertEquals(test.Length, aes.Encrypt(Null, 0, buf, test.Length), "test aes192 encrypt")

		aes.Free()

		AssertFalse(CompareBytes(buf, t, test.Length))

		aes = New TMzAes()
		aes.SetDecryptKey(k, longestKey.Length, Null, 0)
		AssertEquals(test.Length, aes.Decrypt(Null, 0, buf, test.Length), "test aes192 decrypt")
		
		aes.Free()

		AssertTrue(CompareBytes(buf, t, test.Length))

		MemFree(k)
		MemFree(t)

	End Method
End Type

Type TMzHmacTest Extends TTest

	Const key:String = "hm123"
	Const test:String = "12345678"

	Method testHmac128() { test }

		Local hmac:TMzHmac = New TMzHmac()
		Local k:Byte Ptr = key.ToUtf8String()
		Local t:Byte Ptr = test.ToUtf8String()
		Local hash1:Byte Ptr = StackAlloc(MZ_HASH_SHA1_SIZE)

		hmac.SetAlgorithm(MZ_HASH_SHA1)
		hmac.Start(k, key.Length)
		hmac.Update(t, test.Length)
		hmac.Update(t, test.Length)
		hmac.Finish(hash1, MZ_HASH_SHA1_SIZE)
		hmac.Free()

		AssertEquals("3c8c576d947994177af9366c05a6d6cb060edab7", BytesToHex(hash1, MZ_HASH_SHA1_SIZE), "test Hmac128")

		MemFree(k)
		MemFree(t)

	End Method

	Method testHmac256() { test }

		Local hmac:TMzHmac = New TMzHmac()
		Local k:Byte Ptr = key.ToUtf8String()
		Local t:Byte Ptr = test.ToUtf8String()
		Local hash1:Byte Ptr = StackAlloc(MZ_HASH_SHA256_SIZE)

		hmac.SetAlgorithm(MZ_HASH_SHA256)
		hmac.Start(k, key.Length)
		hmac.Update(t, test.Length)
		hmac.Finish(hash1, MZ_HASH_SHA256_SIZE)
		hmac.Free()

		AssertEquals("fb22a9c715a47a06bad4f6cee9badc31c921562f5d6b24adf2be009f73181f7a", BytesToHex(hash1, MZ_HASH_SHA256_SIZE), "test Hmac256")

		MemFree(k)
		MemFree(t)

	End Method
End Type

Function CompareBytes:Int(a:Byte Ptr, b:Byte Ptr, size:Int)
	For Local i:Int = 0 Until size
		If a[i] <> b[i] Then Return False
	Next
	Return True
End Function

Function BytesToHex:String(data:Byte Ptr, size:Int)
	Local hex:String = ""

	' Lookup table for hex digits
	Local digits:String[] = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]

	For Local i:Int = 0 Until size

		Local b:Int = data[i] & $FF  ' Make sure we only get the byte value

        ' Build two hex chars for each byte
        hex :+ digits[b Shr 4]
		hex :+ digits[b & $0F]

	Next

	Return hex
End Function
