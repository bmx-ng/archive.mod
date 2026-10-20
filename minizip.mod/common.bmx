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

Import Net.mbedtlscrypto
Import "source.bmx"


Extern
	Function mz_zip_reader_create:Byte Ptr()


	Function mz_crypt_sha_create:Byte Ptr()
	Function mz_crypt_sha_set_algorithm:Int(handle:Byte Ptr, algorithm:Short)
	Function mz_crypt_sha_begin:Int(handle:Byte Ptr)
	Function mz_crypt_sha_update:Int(handle:Byte Ptr, data:Byte Ptr, length:Int)
	Function mz_crypt_sha_end:Int(handle:Byte Ptr, digest:Byte Ptr, size:Int)
	Function mz_crypt_sha_delete(handle:Byte Ptr Ptr)
	
	Function mz_crypt_aes_create:Byte Ptr()
	Function mz_crypt_aes_encrypt:Int(handle:Byte Ptr, aad:Byte Ptr, aad_size:Int, buf:Byte Ptr, size:Int)
	Function mz_crypt_aes_encrypt_final:Int(handle:Byte Ptr, buf:Byte Ptr, size:Int, tag:Byte Ptr, tag_size:Int)
	Function mz_crypt_aes_decrypt:Int(handle:Byte Ptr, aad:Byte Ptr, aad_size:Int, buf:Byte Ptr, size:Int)
	Function mz_crypt_aes_decrypt_final:Int(handle:Byte Ptr, buf:Byte Ptr, size:Int, tag:Byte Ptr, tag_size:Int)
	Function mz_crypt_aes_set_encrypt_key:Int(handle:Byte Ptr, key:Byte Ptr, key_length:Int, iv:Byte Ptr, iv_length:Int)
	Function mz_crypt_aes_set_decrypt_key:Int(handle:Byte Ptr, key:Byte Ptr, key_length:Int, iv:Byte Ptr, iv_length:Int)
	Function mz_crypt_aes_set_mode(handle:Byte Ptr, mode:Int)
	Function mz_crypt_aes_delete(handle:Byte Ptr Ptr)

	Function mz_crypt_hmac_reset(handle:Byte Ptr)
	Function mz_crypt_hmac_init:Int(handle:Byte Ptr, key:Byte Ptr, key_length:Int)
	Function mz_crypt_hmac_update:Int(handle:Byte Ptr, buf:Byte Ptr, size:Int)
	Function mz_crypt_hmac_end:Int(handle:Byte Ptr, digest:Byte Ptr, digest_size:Int)
	Function mz_crypt_hmac_copy:Int(src_handle:Byte Ptr, target_handle:Byte Ptr)
	Function mz_crypt_hmac_set_algorithm(handle:Byte Ptr, algorithm:Short)
	Function mz_crypt_hmac_create:Byte Ptr()
	Function mz_crypt_hmac_delete(handle:Byte Ptr Ptr)
		
End Extern

Const MZ_HASH_MD5:Int = 10
Const MZ_HASH_MD5_SIZE:Int = 16
Const MZ_HASH_SHA1:Int = 20
Const MZ_HASH_SHA1_SIZE:Int = 20
Const MZ_HASH_SHA224:Int = 22
Const MZ_HASH_SHA224_SIZE:Int = 28
Const MZ_HASH_SHA256:Int = 23
Const MZ_HASH_SHA256_SIZE:Int = 32
Const MZ_HASH_SHA384:Int = 24
Const MZ_HASH_SHA384_SIZE:Int = 48
Const MZ_HASH_SHA512:Int = 25
Const MZ_HASH_SHA512_SIZE:Int = 64
Const MZ_HASH_MAX_SIZE:Int = 256

Const MZ_AES_VERSION:Int = 1
Const MZ_AES_MODE_ECB:Int = 0
Const MZ_AES_MODE_CBC:Int = 1
Const MZ_AES_MODE_GCM:Int = 2
Const MZ_AES_STRENGTH_128:Int = 1
Const MZ_AES_STRENGTH_192:Int = 2
Const MZ_AES_STRENGTH_256:Int = 3
Const MZ_AES_KEY_LENGTH_MAX:Int = 32
Const MZ_AES_BLOCK_SIZE:Int = 16
Const MZ_AES_FOOTER_SIZE:Int = 10
