/*
  Copyright (C) 2026 Bruce A Henderson

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/
#include "mz.h"
#include "mz_crypt.h"
#include "mz_os.h"

#include "mbedtls/sha1.h"
#include "mbedtls/sha256.h"
#include "mbedtls/sha512.h"
#include "mbedtls/cipher.h"
#include "mbedtls/md.h"

/***************************************************************************/

int32_t mz_crypt_rand(uint8_t *buf, int32_t size) {
    return mz_os_rand(buf, size);
}

/***************************************************************************/

static const uint8_t mz_crypt_sha_digest_size[] = {
    MZ_HASH_SHA1_SIZE, 0, MZ_HASH_SHA224_SIZE, MZ_HASH_SHA256_SIZE, MZ_HASH_SHA384_SIZE, MZ_HASH_SHA512_SIZE};

/***************************************************************************/

typedef struct mz_crypt_sha_s {
    union {
        mbedtls_sha512_context ctx512;
        mbedtls_sha256_context ctx256;
        mbedtls_sha1_context ctx1;
    };
    int32_t initialized;
    int error;
    uint16_t algorithm;
} mz_crypt_sha;
    
/***************************************************************************/

static void mz_crypt_sha_free(void *handle) {
    mz_crypt_sha *sha = (mz_crypt_sha *)handle;
    if (sha->initialized) {
        switch(sha->algorithm) {
            case MZ_HASH_SHA1:
                mbedtls_sha1_free(&sha->ctx1);
                break;
            case MZ_HASH_SHA224:
            case MZ_HASH_SHA256:
                mbedtls_sha256_free(&sha->ctx256);
                break;
            case MZ_HASH_SHA384:
            case MZ_HASH_SHA512:
                mbedtls_sha512_free(&sha->ctx512);
                break;
        }
    }
    sha->initialized = 0;
}
    
void mz_crypt_sha_reset(void *handle) {
    mz_crypt_sha *sha = (mz_crypt_sha *)handle;

    mz_crypt_sha_free(handle);

    sha->error = 0;
    sha->initialized = 0;

}

int32_t mz_crypt_sha_begin(void *handle) {
    mz_crypt_sha *sha = (mz_crypt_sha *)handle;
    int result = 0;

    if (!sha)
        return MZ_PARAM_ERROR;

    mz_crypt_sha_reset(handle);

    switch (sha->algorithm) {
    case MZ_HASH_SHA1:
        mbedtls_sha1_init(&sha->ctx1);
        result = mbedtls_sha1_starts(&sha->ctx1);
        break;
    case MZ_HASH_SHA224:
        mbedtls_sha256_init(&sha->ctx256);
        result = mbedtls_sha256_starts(&sha->ctx256, 1);
        break;
    case MZ_HASH_SHA256:
        mbedtls_sha256_init(&sha->ctx256);
        result = mbedtls_sha256_starts(&sha->ctx256, 0);
        break;
    case MZ_HASH_SHA384:
        mbedtls_sha512_init(&sha->ctx512);
        result = mbedtls_sha512_starts(&sha->ctx512, 1);
        break;
    case MZ_HASH_SHA512:
        mbedtls_sha512_init(&sha->ctx512);
        result = mbedtls_sha512_starts(&sha->ctx512, 0);
        break;
    }

    if (result != 0) {
        sha->error = result;
        return MZ_HASH_ERROR;
    }

    sha->initialized = 1;
    return MZ_OK;
}

int32_t mz_crypt_sha_update(void *handle, const void *buf, int32_t size) {
    mz_crypt_sha *sha = (mz_crypt_sha *)handle;
    int result = 0;

    if (!sha || !buf || !sha->initialized)
        return MZ_PARAM_ERROR;
    
    switch (sha->algorithm) {
    case MZ_HASH_SHA1:
        result = mbedtls_sha1_update(&sha->ctx1, (const unsigned char *)buf, size);
        break;
    case MZ_HASH_SHA224:
    case MZ_HASH_SHA256:
        result = mbedtls_sha256_update(&sha->ctx256, (const unsigned char *)buf, size);
        break;
    case MZ_HASH_SHA384:
    case MZ_HASH_SHA512:
        result = mbedtls_sha512_update(&sha->ctx512, (const unsigned char *)buf, size);
        break;
    }

    if (result != 0) {
        sha->error = result;
        return MZ_HASH_ERROR;
    }

    return size;
}

int32_t mz_crypt_sha_end(void *handle, uint8_t *digest, int32_t digest_size) {
    mz_crypt_sha *sha = (mz_crypt_sha *)handle;
    int result = 0;

    if (!sha || !digest || !sha->initialized)
        return MZ_PARAM_ERROR;
    if (digest_size < mz_crypt_sha_digest_size[sha->algorithm - MZ_HASH_SHA1])
        return MZ_PARAM_ERROR;

    switch (sha->algorithm) {
    case MZ_HASH_SHA1:
        result = mbedtls_sha1_finish(&sha->ctx1, (unsigned char *)digest);
        break;
    case MZ_HASH_SHA224:
    case MZ_HASH_SHA256:
        result = mbedtls_sha256_finish(&sha->ctx256, (unsigned char *)digest);
        break;
    case MZ_HASH_SHA384:
    case MZ_HASH_SHA512:
        result = mbedtls_sha512_finish(&sha->ctx512, (unsigned char *)digest);
        break;
    }

    if (result != 0) {
        sha->error = result;
        return MZ_HASH_ERROR;
    }

    return MZ_OK;
}

int32_t mz_crypt_sha_set_algorithm(void *handle, uint16_t algorithm) {
    mz_crypt_sha *sha = (mz_crypt_sha *)handle;
    if (algorithm < MZ_HASH_SHA1 || algorithm > MZ_HASH_SHA512)
        return MZ_PARAM_ERROR;
    sha->algorithm = algorithm;
    return MZ_OK;
}

void *mz_crypt_sha_create(void) {
    mz_crypt_sha *sha = (mz_crypt_sha *)calloc(1, sizeof(mz_crypt_sha));
    if (sha)
        sha->algorithm = MZ_HASH_SHA256;
    return sha;
}

void mz_crypt_sha_delete(void **handle) {
    mz_crypt_sha *sha = NULL;
    if (!handle)
        return;
    sha = (mz_crypt_sha *)*handle;
    if (sha) {
        mz_crypt_sha_free(*handle);
        free(sha);
    }
    *handle = NULL;
}

/***************************************************************************/

typedef struct mz_crypt_aes_s {
    int32_t mode;
    int error;
    int32_t initialized;
    mbedtls_cipher_context_t ctx;
} mz_crypt_aes;

/***************************************************************************/

static void mz_crypt_aes_free(void *handle) {
    mz_crypt_aes *aes = (mz_crypt_aes *)handle;
    if (aes->initialized)
        mbedtls_cipher_free(&aes->ctx);
    aes->initialized = 0;
}

void mz_crypt_aes_reset(void *handle) {
    mz_crypt_aes *aes = (mz_crypt_aes *)handle;
    // mz_crypt_init();
    mz_crypt_aes_free(handle);

    aes->error = 0;
}

int32_t mz_crypt_aes_encrypt(void *handle, const void *aad, int32_t aad_size, uint8_t *buf, int32_t size) {
    mz_crypt_aes *aes = (mz_crypt_aes *)handle;
    size_t out_len = size + MZ_AES_BLOCK_SIZE;

    if (!aes || !buf || size % MZ_AES_BLOCK_SIZE != 0 || !aes->initialized)
        return MZ_PARAM_ERROR;
    if (aes->mode != MZ_AES_MODE_GCM && aad && aad_size > 0)
        return MZ_PARAM_ERROR;

    if (aad && aad_size > 0) {
        if (mbedtls_cipher_update_ad(&aes->ctx, aad, aad_size) != 0)
            return MZ_CRYPT_ERROR;
    }

    uint8_t *tmp_buf = (uint8_t *)calloc(1, size + MZ_AES_BLOCK_SIZE);
    if (tmp_buf == NULL)
        return MZ_MEM_ERROR;

    if (mbedtls_cipher_update(&aes->ctx, buf, size, tmp_buf, &out_len) != 0) {
        free(tmp_buf);
        return MZ_CRYPT_ERROR;
    }

    memcpy(buf, tmp_buf, out_len);
    free(tmp_buf);
    
    return out_len;
}

int32_t mz_crypt_aes_encrypt_final(void *handle, uint8_t *buf, int32_t size, uint8_t *tag, int32_t tag_size) {
    mz_crypt_aes *aes = (mz_crypt_aes *)handle;
    int result = 0;
    size_t out_len = 0;
    size_t final_len = 0;
    uint8_t *p = buf;

    if (!aes || !tag || !tag_size || !aes->initialized || aes->mode != MZ_AES_MODE_GCM)
        return MZ_PARAM_ERROR;

    if (!p) {
        p = tag;
    }

    if (buf && size) {
        uint8_t *tmp_buf = (uint8_t *)calloc(1, size + MZ_AES_BLOCK_SIZE);
        
        if (tmp_buf == NULL)
            return MZ_MEM_ERROR;

        if (mbedtls_cipher_update(&aes->ctx, buf, size, tmp_buf, &out_len) != 0)
        {
            free(tmp_buf);
            return MZ_CRYPT_ERROR;
        }

        p += out_len;

        memcpy(buf, tmp_buf, out_len);
        free(tmp_buf);
    }

    result = mbedtls_cipher_finish(&aes->ctx, p, &final_len);

    p += final_len;
    out_len += final_len;

    if (result == 0)
    {
        result = mbedtls_cipher_write_tag(&aes->ctx, tag, tag_size);
    }

    if (result != 0) {
        aes->error = result;
        return MZ_CRYPT_ERROR;
    }

    return out_len;
}

int32_t mz_crypt_aes_decrypt(void *handle, const void *aad, int32_t aad_size, uint8_t *buf, int32_t size) {
    return mz_crypt_aes_encrypt(handle, aad, aad_size, buf, size);
}

int32_t mz_crypt_aes_decrypt_final(void *handle, uint8_t *buf, int32_t size, const uint8_t *tag, int32_t tag_size) {
    mz_crypt_aes *aes = (mz_crypt_aes *)handle;
    int result = 0;
    size_t out_len = 0;
    size_t final_len = 0;

    if (!aes || !tag || !tag_size || !aes->initialized || aes->mode != MZ_AES_MODE_GCM)
        return MZ_PARAM_ERROR;

    if (buf && size) {
        uint8_t *tmp_buf = (uint8_t *)calloc(1, size + MZ_AES_BLOCK_SIZE);
        
        if (tmp_buf == NULL)
            return MZ_MEM_ERROR;

        if (mbedtls_cipher_update(&aes->ctx, buf, size, tmp_buf, &out_len) != 0)
        {
            free(tmp_buf);
            return MZ_CRYPT_ERROR;
        }

        memcpy(buf, tmp_buf, out_len);
        free(tmp_buf);
    }

    result = mbedtls_cipher_finish(&aes->ctx, NULL, &final_len);

    if (result == 0)
        result = mbedtls_cipher_check_tag(&aes->ctx, tag, tag_size);

    if (result != 0) {
        aes->error = result;
        return MZ_CRYPT_ERROR;
    }

    return out_len;
}

static int32_t mz_crypt_aes_set_key(void *handle, const void *key, int32_t key_length, const void *iv, int32_t iv_length, int32_t encrypt) {
    mz_crypt_aes *aes = (mz_crypt_aes *)handle;
    const mbedtls_cipher_info_t *type = NULL;

    switch (aes->mode) {
    case MZ_AES_MODE_CBC:
        if (key_length == 16)
            type = mbedtls_cipher_info_from_type(MBEDTLS_CIPHER_AES_128_CBC);
        else if (key_length == 24)
            type = mbedtls_cipher_info_from_type(MBEDTLS_CIPHER_AES_192_CBC);
        else if (key_length == 32)
            type = mbedtls_cipher_info_from_type(MBEDTLS_CIPHER_AES_256_CBC);
        break;
    case MZ_AES_MODE_ECB:
        if (key_length == 16)
            type = mbedtls_cipher_info_from_type(MBEDTLS_CIPHER_AES_128_ECB);
        else if (key_length == 24)
            type = mbedtls_cipher_info_from_type(MBEDTLS_CIPHER_AES_192_ECB);
        else if (key_length == 32)
            type = mbedtls_cipher_info_from_type(MBEDTLS_CIPHER_AES_256_ECB);
        break;
    case MZ_AES_MODE_GCM:
        if (key_length == 16)
            type = mbedtls_cipher_info_from_type(MBEDTLS_CIPHER_AES_128_GCM);
        else if (key_length == 24)
            type = mbedtls_cipher_info_from_type(MBEDTLS_CIPHER_AES_192_GCM);
        else if (key_length == 32)
            type = mbedtls_cipher_info_from_type(MBEDTLS_CIPHER_AES_256_GCM);
        break;
    }

    if (!type)
        return MZ_PARAM_ERROR;
    
    mbedtls_cipher_init(&aes->ctx);
    aes->initialized = 1;

    // if (!aes->initialized)
    //     return MZ_MEM_ERROR;

    int result = mbedtls_cipher_setup(&aes->ctx, type);
    if (result != 0) {
        aes->error = result;
        return MZ_HASH_ERROR;
    }

    result = mbedtls_cipher_setkey(&aes->ctx, key, key_length * 8, encrypt ? MBEDTLS_ENCRYPT : MBEDTLS_DECRYPT);
    if (result != 0) {
        aes->error = result;
        return MZ_HASH_ERROR;
    }

    mbedtls_cipher_set_padding_mode(&aes->ctx, aes->mode == MZ_AES_MODE_GCM ? MBEDTLS_PADDING_PKCS7 : MBEDTLS_PADDING_NONE);

    if (iv && iv_length > 0) {
        result = mbedtls_cipher_set_iv(&aes->ctx, iv, iv_length);
        if (result != 0) {
            aes->error = result;
            return MZ_HASH_ERROR;
        }
    }

    mbedtls_cipher_reset(&aes->ctx);

    return MZ_OK;
}

int32_t mz_crypt_aes_set_encrypt_key(void *handle, const void *key, int32_t key_length, const void *iv, int32_t iv_length) {
    mz_crypt_aes *aes = (mz_crypt_aes *)handle;

    if (!aes || !key || !key_length)
        return MZ_PARAM_ERROR;
    if (key_length != 16 && key_length != 24 && key_length != 32)
        return MZ_PARAM_ERROR;
    if (iv && iv_length != MZ_AES_BLOCK_SIZE)
        return MZ_PARAM_ERROR;

    mz_crypt_aes_reset(handle);

    return mz_crypt_aes_set_key(handle, key, key_length, iv, iv_length, 1);
}

int32_t mz_crypt_aes_set_decrypt_key(void *handle, const void *key, int32_t key_length, const void *iv, int32_t iv_length) {
    mz_crypt_aes *aes = (mz_crypt_aes *)handle;

    if (!aes || !key || !key_length)
        return MZ_PARAM_ERROR;
    if (key_length != 16 && key_length != 24 && key_length != 32)
        return MZ_PARAM_ERROR;
    if (iv && iv_length > MZ_AES_BLOCK_SIZE)
        return MZ_PARAM_ERROR;

    mz_crypt_aes_reset(handle);

    return mz_crypt_aes_set_key(handle, key, key_length, iv, iv_length, 0);
}

void mz_crypt_aes_set_mode(void *handle, int32_t mode) {
    mz_crypt_aes *aes = (mz_crypt_aes *)handle;
    aes->mode = mode;
}

void *mz_crypt_aes_create(void) {
    mz_crypt_aes *aes = (mz_crypt_aes *)calloc(1, sizeof(mz_crypt_aes));
    return aes;
}

void mz_crypt_aes_delete(void **handle) {
    mz_crypt_aes *aes = NULL;
    if (!handle)
        return;
    aes = (mz_crypt_aes *)*handle;
    if (aes) {
        mz_crypt_aes_free(*handle);
        free(aes);
    }
    *handle = NULL;
}

/***************************************************************************/

typedef struct mz_crypt_hmac_s {
    mbedtls_md_context_t ctx;
    int32_t initialized;
    int error;
    uint16_t algorithm;
} mz_crypt_hmac;
    
/***************************************************************************/

static void mz_crypt_hmac_free(void *handle) {
    mz_crypt_hmac *hmac = (mz_crypt_hmac *)handle;

    mbedtls_md_free(&hmac->ctx);
    hmac->initialized = 0;
}

static int mz_crypt_hmac_setup(void *handle) {
    mz_crypt_hmac *hmac = (mz_crypt_hmac *)handle;

    mbedtls_md_type_t type;

    if (hmac->algorithm == MZ_HASH_SHA1)
        type = MBEDTLS_MD_SHA1;
    else
        type = MBEDTLS_MD_SHA256;

    return mbedtls_md_setup(&hmac->ctx, mbedtls_md_info_from_type(type), 1);
}

void mz_crypt_hmac_reset(void *handle) {
    mz_crypt_hmac *hmac = (mz_crypt_hmac *)handle;

    mz_crypt_hmac_free(handle);

    hmac->error = 0;
    hmac->initialized = 0;
}

int32_t mz_crypt_hmac_init(void *handle, const void *key, int32_t key_length) {
    mz_crypt_hmac *hmac = (mz_crypt_hmac *)handle;
    int result = 0;

    if (!hmac || !key)
        return MZ_PARAM_ERROR;

    mz_crypt_hmac_reset(handle);

    mbedtls_md_init(&hmac->ctx);

    result = mz_crypt_hmac_setup(handle);

    if (result != 0) {
        hmac->error = result;
        return MZ_HASH_ERROR;
    }

    result = mbedtls_md_hmac_starts(&hmac->ctx, (const unsigned char *)key, key_length);

    if (result != 0) {
        hmac->error = result;
        return MZ_HASH_ERROR;
    }

    hmac->initialized = 1;

    return MZ_OK;
}

int32_t mz_crypt_hmac_update(void *handle, const void *buf, int32_t size) {
    mz_crypt_hmac *hmac = (mz_crypt_hmac *)handle;
    int result = 0;

    if (!hmac || !buf || !hmac->initialized)
        return MZ_PARAM_ERROR;

    result = mbedtls_md_hmac_update(&hmac->ctx, buf, size);

    if (result != 0) {
        hmac->error = result;
        return MZ_HASH_ERROR;
    }

    return MZ_OK;
}

int32_t mz_crypt_hmac_end(void *handle, uint8_t *digest, int32_t digest_size) {
    mz_crypt_hmac *hmac = (mz_crypt_hmac *)handle;
    int result = 0;

    if (!hmac || !digest)
        return MZ_PARAM_ERROR;

    if (hmac->algorithm == MZ_HASH_SHA1) {
        if (digest_size < MZ_HASH_SHA1_SIZE)
            return MZ_BUF_ERROR;
    } else {
        if (digest_size < MZ_HASH_SHA256_SIZE)
            return MZ_BUF_ERROR;
    }
    
    result = mbedtls_md_hmac_finish(&hmac->ctx, digest);

    if (result != 0) {
        hmac->error = result;
        return MZ_HASH_ERROR;
    }

    return MZ_OK;
}

int32_t mz_crypt_hmac_copy(void *src_handle, void *target_handle) {
    mz_crypt_hmac *source = (mz_crypt_hmac *)src_handle;
    mz_crypt_hmac *target = (mz_crypt_hmac *)target_handle;
    int result = 0;

    if (!source || !target)
        return MZ_PARAM_ERROR;

    if (target->initialized) {
        mz_crypt_hmac_free(target_handle);
    }

    target->algorithm = source->algorithm;

    mbedtls_md_init(&target->ctx);

    result = mz_crypt_hmac_setup(target);

    if (result != 0) {
        target->error = result;
        return MZ_HASH_ERROR;
    }

    result = mbedtls_md_clone(&target->ctx, &source->ctx);

    if (result != 0) {
        target->error = result;
        return MZ_HASH_ERROR;
    }

    /* mbedtls_md_clone copies the digest state, but not the HMAC pads. */
    memcpy(target->ctx.MBEDTLS_PRIVATE(hmac_ctx),
           source->ctx.MBEDTLS_PRIVATE(hmac_ctx), 2 * 64);

    target->initialized = 1;

    return MZ_OK;
}

void mz_crypt_hmac_set_algorithm(void *handle, uint16_t algorithm) {
    mz_crypt_hmac *hmac = (mz_crypt_hmac *)handle;
    hmac->algorithm = algorithm;
}

void *mz_crypt_hmac_create(void) {
    mz_crypt_hmac *hmac = (mz_crypt_hmac *)calloc(1, sizeof(mz_crypt_hmac));
    if (hmac)
        hmac->algorithm = MZ_HASH_SHA256;
    return hmac;
}

void mz_crypt_hmac_delete(void **handle) {
    mz_crypt_hmac *hmac = NULL;
    if (!handle)
        return;
    hmac = (mz_crypt_hmac *)*handle;
    if (hmac) {
        mz_crypt_hmac_free(*handle);
        free(hmac);
    }
    *handle = NULL;
}
