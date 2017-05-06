#ifndef _SM3_H_
#define _SM3_H_

typedef struct
{
    unsigned int total[2];
    unsigned int state[8];
    unsigned char buffer[64];
}
sm3_context;

#ifdef __cplusplus
extern "C" {
#endif

extern void sm3_init( sm3_context *ctx );
extern void sm3_init_ex( sm3_context *ctx ,unsigned char iv[32]);
extern void sm3_update( sm3_context *ctx, unsigned char *input, unsigned int length );
extern void sm3_finish( sm3_context *ctx, unsigned char digest[32] );
extern void sm3_hash( unsigned char *input, unsigned int length, unsigned char digest[32] );
extern void sm3_hash_ex( unsigned char *input, unsigned int length,unsigned char iv[32], unsigned char digest[32] );

#ifdef __cplusplus
}
#endif

#endif /* sm3.h */

