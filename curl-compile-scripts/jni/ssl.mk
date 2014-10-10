SSL_COMMON_CFLAGS := \
  -DANDROID -DOPENSSL_NO_ASM -DOPENSSL_THREADS -D_REENTRANT \
  -DDSO_DLFCN -DHAVE_DLFCN_H -DOPENSSL_NO_CAST -DOPENSSL_NO_CAMELLIA \
  -DOPENSSL_NO_IDEA -DOPENSSL_NO_MDC2 -DOPENSSL_NO_SEED -DOPENSSL_NO_WHIRLPOOL
SSL_CSOURCES := \
  bio_ssl.c d1_both.c d1_enc.c d1_lib.c d1_pkt.c d1_srtp.c \
  kssl.c s23_clnt.c s23_lib.c s23_meth.c s23_pkt.c s23_srvr.c \
  s2_clnt.c s2_enc.c s2_lib.c s2_meth.c s2_pkt.c s2_srvr.c \
  s3_both.c s3_cbc.c s3_clnt.c s3_enc.c s3_lib.c s3_meth.c \
  s3_pkt.c s3_srvr.c ssl_algs.c ssl_asn1.c ssl_cert.c ssl_ciph.c \
  ssl_err.c ssl_err2.c ssl_lib.c ssl_rsa.c ssl_sess.c ssl_stat.c \
  ssl_txt.c t1_clnt.c t1_enc.c t1_lib.c t1_meth.c t1_reneg.c \
  t1_srvr.c tls_srp.c
SSL_LOCAL_SRC_FILES := $(addprefix ../../openssl/ssl/,$(SSL_CSOURCES))
SSL_LOCAL_C_INCLUDES := \
  $(LOCAL_PATH)/../../openssl/include \
  $(LOCAL_PATH)/../../openssl \
  $(LOCAL_PATH)/../../openssl/crypto \
  $(NDK_PATH)/platforms/$(TARGET_PLATFORM)/arch-arm/usr/include