'  Copyright (C) 2026 Bruce A Henderson
'
'  This software is provided 'as-is', without any express or implied
'  warranty.  In no event will the authors be held liable for any damages
'  arising from the use of this software.
'
'  Permission is granted to anyone to use this software for any purpose,
'  including commercial applications, and to alter it and redistribute it
'  freely, subject to the following restrictions:
'
'  1. The origin of this software must not be misrepresented; you must not
'     claim that you wrote the original software. If you use this software
'     in a product, an acknowledgment in the product documentation would be
'     appreciated but is not required.
'  2. Altered source versions must be plainly marked as such, and must not be
'     misrepresented as being the original software.
'  3. This notice may not be removed or altered from any source distribution.
'
SuperStrict

Module archive.minizip

ModuleInfo "Version: 1.01"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Wrapper - 2026 Bruce A Henderson"
ModuleInfo "Upstream: minizip-ng 4.2.2"

ModuleInfo "History: 1.01"
ModuleInfo "History: Updated minizip-ng from 4.0.10 to 4.2.2."
ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release."

ModuleInfo "CC_OPTS: -DHAVE_BZIP2 -DHAVE_WZAES -DHAVE_PKCRYPT -DHAVE_ZLIB -DZLIB_COMPAT -DHAVE_ZSTD -DHAVE_LZMA"

Import "common.bmx"



Type TMzSha

	Field shaPtr:Byte Ptr

	Method New()
		shaPtr = mz_crypt_sha_create()
	End Method

	Method SetAlgorithm:Int(algorithm:Short)
		Return mz_crypt_sha_set_algorithm(shaPtr, algorithm)
	End Method

	Method Start:Int()
		Return mz_crypt_sha_begin(shaPtr)
	End Method

	Method Update:Int(data:Byte Ptr, length:Int)
		Return mz_crypt_sha_update(shaPtr, data, length)
	End Method

	Method Finish:Int(digest:Byte Ptr, size:Int)
		Return mz_crypt_sha_end(shaPtr, digest, size)
	End Method

	Method Free()
		mz_crypt_sha_delete(Varptr shaPtr)
	End Method

End Type

Type TMzAes

	Field aesPtr:Byte Ptr

	Method New()
		aesPtr = mz_crypt_aes_create()
	End Method

	Method Encrypt:Int(aad:Byte Ptr, aad_size:Int, buf:Byte Ptr, size:Int)
		Return mz_crypt_aes_encrypt(aesPtr, aad, aad_size, buf, size)
	End Method

	Method EncryptFinal:Int(buf:Byte Ptr, size:Int, tag:Byte Ptr, tag_size:Int)
		Return mz_crypt_aes_encrypt_final(aesPtr, buf, size, tag, tag_size)
	End Method

	Method Decrypt:Int(aad:Byte Ptr, aad_size:Int, buf:Byte Ptr, size:Int)
		Return mz_crypt_aes_decrypt(aesPtr, aad, aad_size, buf, size)
	End Method

	Method DecryptFinal:Int(buf:Byte Ptr, size:Int, tag:Byte Ptr, tag_size:Int)
		Return mz_crypt_aes_decrypt_final(aesPtr, buf, size, tag, tag_size)
	End Method

	Method SetEncryptKey:Int(key:Byte Ptr, key_length:Int, iv:Byte Ptr, iv_length:Int)
		Return mz_crypt_aes_set_encrypt_key(aesPtr, key, key_length, iv, iv_length)
	End Method

	Method SetDecryptKey:Int(key:Byte Ptr, key_length:Int, iv:Byte Ptr, iv_length:Int)
		Return mz_crypt_aes_set_decrypt_key(aesPtr, key, key_length, iv, iv_length)
	End Method

	Method SetMode(mode:Int)
		mz_crypt_aes_set_mode(aesPtr, mode)
	End Method

	Method Free()
		mz_crypt_aes_delete(Varptr aesPtr)
	End Method

End Type

Type TMzHmac

	Field hmacPtr:Byte Ptr

	Method New()
		hmacPtr = mz_crypt_hmac_create()
	End Method

	Method Reset()
		mz_crypt_hmac_reset(hmacPtr)
	End Method

	Method Start:Int(key:Byte Ptr, key_length:Int)
		Return mz_crypt_hmac_init(hmacPtr, key, key_length)
	End Method

	Method Update:Int(buf:Byte Ptr, size:Int)
		Return mz_crypt_hmac_update(hmacPtr, buf, size)
	End Method

	Method Finish:Int(digest:Byte Ptr, digest_size:Int)
		Return mz_crypt_hmac_end(hmacPtr, digest, digest_size)
	End Method

	Method Copy:Int(target:TMzHmac)
		Return mz_crypt_hmac_copy(hmacPtr, target.hmacPtr)
	End Method

	Method SetAlgorithm(algorithm:Short)
		mz_crypt_hmac_set_algorithm(hmacPtr, algorithm)
	End Method

	Method Free()
		mz_crypt_hmac_delete(Varptr hmacPtr)
	End Method

End Type
