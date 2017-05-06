#ifndef _SM2_H
#define _SM2_H

#ifdef __cplusplus
extern "C" {
#endif

/*
 *函数：sm2加密
 *功能：对数据进行加密操作
 *输入：加密数据data,数据长度dataLen，随机数randnum	公钥pub_x和pub_y
 *输出：加密结构c1、c2和c3
 *返回值：0成功	-1失败
 */
extern int sm2_enc(unsigned char *data, int dataLen, unsigned char *randnum, unsigned char *pub_x, unsigned char *pub_y, unsigned char *c1, unsigned char *c2, unsigned char *c3);

/*
 *函数：sm2解密
 *功能：对数据进行解密操作
 *输入：加密结果c1、c2和c3	c2的长度c2len	私钥key	
 *输出：解密结果output
 *返回值：0成功	-1失败
 */
extern int sm2_dec(unsigned char *c1, unsigned char *c2, int c2len, unsigned char  *c3, unsigned char *key, unsigned char *output);
/*
 *函数：sm2签名
 *功能：对Hash数据进行签名操作
 *输入：私钥priv_key	签名数据Hash值hash	随机数randnum	
 *输出：签名值bin_r和bin_s
 *返回值：0成功	-1失败
 */
extern int sm2_sign(const unsigned char *priv_key, unsigned char *hash, unsigned char *randnum, unsigned char *bin_r, unsigned char *bin_s);

/*
 *函数：sm2验签
 *功能：对Hash数据进行验签操作
 *输入：签名值bin_r和bin_s	签名数据Hash值hash	公钥pub_x和pub_y
 *返回值：0成功	-1失败
 */
extern int sm2_check(unsigned char *bin_r, unsigned char *bin_s, unsigned char *hash, unsigned char *pub_x, unsigned char *pub_y);

/*
 *函数：sm2点乘
 *功能：点乘操作
 *输入：随机数rand, 椭圆曲线点坐标input_x和input_y
 *输出：椭圆曲线点坐标out_x和out_y
 *返回值：0 成功	1 失败
 */
extern int sm2_mul(unsigned char *rand, unsigned char *input_x, unsigned char *input_y, unsigned char *out_x, unsigned char *out_y);

/*
 *函数：sm2基点乘
 *功能：基点乘操作
 *输入：随机数rand
 *输出：椭圆曲线点坐标out_x和out_y
 *返回值：0 成功	1 失败
 */
extern int sm2_base(unsigned char *rand, unsigned char *out_x, unsigned char *out_y);

extern int sm2_inverse(unsigned char *pri,unsigned char *pri_inv);

#ifdef __cplusplus
}
#endif

#endif /* sm2.h */
