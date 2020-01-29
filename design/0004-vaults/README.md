```yaml
id: OP-0004
title: Vaults
status: Draft
```

# Vaults

This proposal specifies the **vault interface** that will be used for cryptographic functions within the various Ockam protocols. An Ockam Vault or Vaults make up a required set of cryptographic building blocks that allow the Ockam protocols to establish secure channels with other devices or services. This proposal defines the implementation of the Vault interface and how it will be used by other pieces of the Ockam SDK.

The Vault interface is broken up into six different building blocks:
* Initialization
* Random Number Generation
* Public/Private Keys and ECDH
* SHA-256
* HKDF
* AES GCM

---

# Initialization

```
/**
 ********************************************************************************************************
 *                                          ockam_vault_init()
 *
 * @brief   Initialize the Ockam Vault. Must be called before any other Vault calls.
 *
 * @param   p_cfg[in]   Configuration values for a TPM/Secure Element  and/or a host software library.
 *
 * @return  OCKAM_ERR_NONE if initialized successfully. OCKAM_ERR_VAULT_ALREADY_INIT if already
 *          initialized. Other errors if specific chip fails init.
 *
 ********************************************************************************************************
 */

OCKAM_ERR ockam_vault_init(OCKAM_VAULT_CFG_s *p_cfg);
```

The initialization call must always be the first call made to Vault as it will handle all set-up of any external hardware or The `OCKAM_VAULT_CFG_s` struct contains void pointers for a TPM/Secure Element Vault and a Host-based Vault.




# Random Number Generation

```
/**
 ********************************************************************************************************
 *                                        ockam_vault_random()
 *
 * @brief   Generate and return a random number
 *
 * @param   p_rand_num[out]     Byte array to be filled with the random number
 *
 * @param   rand_num_size[in]   The size of the desired random number & buffer passed in. Used to verify
 *                              correct size.
 *
 * @return  OCKAM_ERR_NONE if successful. OCKAM_ERR_VAULT_INVALID_SIZE if size
 *
 ********************************************************************************************************
 */

OCKAM_ERR ockam_vault_random(uint8_t *p_rand_num, uint32_t rand_num_size);
```

Random number generation supports the generation of any size random number requested. Special considerations will need to be made for platforms that can only generate fixed-size random numbers.


# Public/Private Keys and ECDH

```
/**
 ********************************************************************************************************
 *                                          ockam_vault_key_gen()
 *
 * @brief   Generate an ECC keypair using the specified Ockam key slot.
 *
 * @param   key_type[in]        The type of key pair to generate.
 *
 * @return  OCKAM_ERR_NONE if successful.
 *
 ********************************************************************************************************
 */

OCKAM_ERR ockam_vault_key_gen(OCKAM_VAULT_KEY_e key_type);
```

Generates a key pair in the specified key slot. If a key already existed in the slot it will be overwritten so the caller must keep track of what keys it uses.

```
/**
 ********************************************************************************************************
 *                                          ockam_vault_key_get_pub()
 *
 * @brief   Get the public key for the specified key pair.
 *
 * @param   key_type[in]        The specific key pair to retrieve the public key for.
 *
 * @param   p_pub_key[out]      Buffer to place the public key in.
 *
 * @param   pub_key_size[in]    Size of the public key buffer.
 *
 * @return  OCKAM_ERR_NONE if successful.
 *
 ********************************************************************************************************
 */

OCKAM_ERR ockam_vault_key_get_pub(OCKAM_VAULT_KEY_e key_type,
                                  uint8_t *p_key_pub, uint32_t key_pub_size);
```

Retrieves a public key from the specified key type. If a key pair has not yet been generated or the written key is invalid, an error should be returned.

```
/**
 ********************************************************************************************************
 *                                          ockam_vault_key_write()
 *
 * @brief   Write a private key to the Ockam Vault. Should typically be used for testing only.
 *
 * @param   key_type[in]        The specific Ockam key to write to
 *
 * @param   p_key_priv[out]     Buffer containing the uncompressed, big endian private key
 *
 * @param   key_priv_size[in]   Size of the private key to write
 *
 * @return  OCKAM_ERR_NONE if successful.
 *
 ********************************************************************************************************
 */

OCKAM_ERR ockam_vault_key_write(OCKAM_VAULT_KEY_e key_type,
                                uint8_t *p_key_priv, uint32_t key_priv_size);
```

There is a large security risk writing private keys so this function should be used mainly for testing purposes.

```
/**
 ********************************************************************************************************
 *                                          ockam_vault_ecdh()
 *
 * @brief   Perform ECDH using the specified private key and the received public key
 *
 * @param   key_type[in]        The specific Ockam key to use in the ECDH execution
 *
 * @param   p_pub_key[in]       Buffer with the public key
 *
 * @param   pub_key_size[in]    Size of the public key buffer
 *
 * @param   p_ss[out]           Buffer for the shared secret calculated from ECDH
 *
 * @param   ss_size[in]         Size of the shared secret buffer
 *
 * @return  OCKAM_ERR_NONE if successful.
 *
 ********************************************************************************************************
 */

OCKAM_ERR ockam_vault_ecdh(OCKAM_VAULT_KEY_e key_type,
                           uint8_t *p_key_pub, uint32_t key_pub_size,
                           uint8_t *p_ss, uint32_t ss_size);
```

Performs an ECDH calculation using the specified private key and the passed in public key.

# SHA-256

```
/**
 ********************************************************************************************************
 *                                          ockam_vault_sha256()
 *
 * @brief   Perform a SHA-256 hash on the message passed in.
 *
 * @param   p_msg[in]       The message to run through SHA256
 *
 * @param   msg_size[in]    The size of the message to be run through SHA256
 *
 * @param   p_digest[out]   Buffer to place the resulting SHA256 digest in
 *
 * @param   digest_size[in] The size of the digest buffer
 *
 * @return  OCKAM_ERR_NONE on success
 *
 ********************************************************************************************************
 */

 OCKAM_ERR ockam_vault_sha256(uint8_t *p_msg, uint16_t msg_size,
                              uint8_t *p_digest, uint8_t digest_size);
 ```

Some of the Ockam protocols use SHA-256 hashing to ensure both parties are communicating securely and in the expected order. Vault provides a simple SHA-256 hashing function for the protocols to use.

# HKDF

```
/**
 ********************************************************************************************************
 *                                          ockam_vault_hkdf()
 *
 * @brief   Perform HKDF operation on the input key material and optional salt and info. Place the
 *          result in the output buffer.
 *
 * @param   p_salt[in]          Buffer for the salt value
 *
 * @param   salt_size[in]       Size of the Ockam salt value
 *
 * @param   p_ikm[in]           Buffer with the input key material for HKDF
 *
 * @param   ikm_size[in]        Size of the input key material
 *
 * @param   p_info[in]          Buffer with the optional context specific info. Can be 0.
 *
 * @param   info_size[in]       Size of the optional context specific info.
 *
 * @param   p_out[out]          Buffer for the output of the HKDF operation
 *
 * @param   out_size[in]        Size of the HKDF output buffer
 *
 * @return  OCKAM_ERR_NONE if successful.
 *
 ********************************************************************************************************
 */

OCKAM_ERR ockam_vault_hkdf(uint8_t *p_salt, uint32_t salt_size,
                           uint8_t *p_ikm, uint32_t ikm_size,
                           uint8_t *p_info, uint32_t info_size,
                           uint8_t *p_out, uint32_t out_size);
```

The implementation of HKDF must follow the standard set in [RFC 5869](https://tools.ietf.org/html/rfc5869).


# AES GCM

```
/**
 ********************************************************************************************************
 *                                ockam_vault_aes_gcm_encrypt()
 *
 * @brief   AES GCM function for encrypt. 
 *
 * @param   p_key[in]           Buffer for the AES Key
 *
 * @param   key_size[in]        Size of the AES Key.
 *
 * @param   p_iv[in]            Buffer with the initialization vector
 *
 * @param   iv_size[in]         Size of the initialization vector
 *
 * @param   p_aad[in]           Buffer with the additional data (can be NULL)
 *
 * @param   aad_size[in]        Size of the additional data (set to 0 if p_aad is NULL)
 *
 * @param   p_tag[out]          Buffer to either hold the tag when encrypting or pass in the tag
 *                              when decrypting.
 *
 * @param   tag_size[in]        Size of the tag buffer
 *
 * @param   p_input[in]         Buffer with the input data to encrypt or decrypt
 *
 * @param   input_size[in]      Size of the input data
 *
 * @param   p_output[out]       Buffer for the output of the AES GCM operation. Can NOT be the
 *                              input buffer.
 *
 * @param   output_size[in]     Size of the output buffer
 *
 * @return  OCKAM_ERR_NONE if successful.
 *          OCKAM_ERR_VAULT_TPM_AES_GCM_FAIL if unable to perform the requested AES GCM operation.
 *
 ********************************************************************************************************
 */

OCKAM_ERR ockam_vault_aes_gcm_encrypt(uint8_t *p_key, uint32_t key_size,
                                      uint8_t *p_iv, uint32_t iv_size,
                                      uint8_t *p_aad, uint32_t aad_size,
                                      uint8_t *p_tag, uint32_t tag_size,
                                      uint8_t *p_input, uint32_t input_size,
                                      uint8_t *p_output, uint32_t output_size);
```

Key size must always be 16 as only AES-GCM-128 is supported. 

```
/**
 ********************************************************************************************************
 *                                ockam_vault_aes_gcm_decrypt()
 *
 * @brief   AES GCM function for decrypt. 
 *
 * @param   p_key[in]           Buffer for the AES Key
 *
 * @param   key_size[in]        Size of the AES Key.
 *
 * @param   p_iv[in]            Buffer with the initialization vector
 *
 * @param   iv_size[in]         Size of the initialization vector
 *
 * @param   p_aad[in]           Buffer with the additional data (can be NULL)
 *
 * @param   aad_size[in]        Size of the additional data (set to 0 if p_aad is NULL)
 *
 * @param   p_tag[in,out]       Buffer to either hold the tag when encrypting or pass in the tag
 *                              when decrypting.
 *
 * @param   tag_size[in]        Size of the tag buffer
 *
 * @param   p_input[in]         Buffer with the input data to encrypt or decrypt
 *
 * @param   input_size[in]      Size of the input data
 *
 * @param   p_output[out]       Buffer for the output of the AES GCM operation. Can NOT be the
 *                              input buffer.
 *
 * @param   output_size[in]     Size of the output buffer
 *
 * @return  OCKAM_ERR_NONE if successful.
 *          OCKAM_ERR_VAULT_TPM_AES_GCM_FAIL if unable to perform the requested AES GCM operation.
 *
 ********************************************************************************************************
 */

OCKAM_ERR ockam_vault_aes_gcm_decrypt(uint8_t *p_key, uint32_t key_size,
                                      uint8_t *p_iv, uint32_t iv_size,
                                      uint8_t *p_aad, uint32_t aad_size,
                                      uint8_t *p_tag, uint32_t tag_size,
                                      uint8_t *p_input, uint32_t input_size,
                                      uint8_t *p_output, uint32_t output_size)
```

Key size must always be 16 as only AES-GCM-128 is supported. 
