
#ifndef _SM4_H_
#define _SM4_H_

#define SM4_ENCRYPT     1
#define SM4_DECRYPT     0

/**
 * \brief          SM4 context structure
 */
typedef struct
{
    int mode;                   /*!<  encrypt/decrypt   */
    unsigned long sk[32];       /*!<  SM4 subkeys       */
}
sm4_context;


#ifdef __cplusplus
extern "C" {
#endif

/**
 * \brief          SM4 key schedule (128-bit, encryption)
 *
 * \param ctx      SM4 context to be initialized
 * \param key      16-byte secret key
 */
extern void sm4_setkey_enc( sm4_context *ctx, unsigned char key[16] );

/**
 * \brief          SM4 key schedule (128-bit, decryption)
 *
 * \param ctx      SM4 context to be initialized
 * \param key      16-byte secret key
 */
extern void sm4_setkey_dec( sm4_context *ctx, unsigned char key[16] );

/**
 * \brief          SM4-ECB block encryption/decryption
 * \param ctx      SM4 context
 * \param mode     SM4_ENCRYPT or SM4_DECRYPT
 * \param length   length of the input data
 * \param input    input block
 * \param output   output block
 */
extern void sm4_crypt_ecb( sm4_context *ctx,
				     int mode,
					 unsigned int length,
                     unsigned char *input,
                     unsigned char *output);

/*
 *说明：不需要考虑打补丁，该函数会自动添加补丁和去除补丁
 *输入参数length表示input的长度，返回值表示output的长度
 *input和output的地址不能重叠
*/
extern int sm4_crypt_ecb_ex(unsigned char key[16],
					 int mode,
					 unsigned int length,
					 unsigned char *input,
					 unsigned char *output);
					 
/**
 * \brief          SM4-CBC buffer encryption/decryption
 * \param ctx      SM4 context
 * \param mode     SM4_ENCRYPT or SM4_DECRYPT
 * \param length   length of the input data
 * \param iv       initialization vector (updated after use)
 * \param input    buffer holding the input data
 * \param output   buffer holding the output data
 */
extern void sm4_crypt_cbc( sm4_context *ctx,
                     int mode,
                     unsigned int length,
                     unsigned char iv[16],
                     unsigned char *input,
                     unsigned char *output );


/**
 * \brief          SM4-OFB buffer encryption/decryption
 * \param ctx      SM4 context
 * \param mode     SM4_ENCRYPT or SM4_DECRYPT
 * \param length   length of the input data
 * \param iv       initialization vector (updated after use)
 * \param input    buffer holding the input data
 * \param output   buffer holding the output data
 */
extern void sm4_crypt_ofb( sm4_context *ctx,
                     int mode,
                     unsigned int length,
                     unsigned char iv[16],
                     unsigned char *input,
                     unsigned char *output);

#ifdef __cplusplus
}
#endif

#endif /* sm4.h */
