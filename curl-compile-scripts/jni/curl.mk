CURL_COMMON_CFLAGS := \
  -DANDROID -DOPENSSL_NO_ASM -DOPENSSL_THREADS -D_REENTRANT \
  -DDSO_DLFCN -DHAVE_DLFCN_H -DOPENSSL_NO_CAST -DOPENSSL_NO_CAMELLIA \
  -DOPENSSL_NO_IDEA -DOPENSSL_NO_MDC2 -DOPENSSL_NO_SEED -DOPENSSL_NO_WHIRLPOOL\
  -Wno-sign-compare -Wno-incompatible-pointer-types-discards-qualifiers
CURL_COMMON_CFLAGS += \
  -DHAVE_CONFIG_H \
  -Wpointer-arith -Wwrite-strings -Wunused -Winline \
  -Wnested-externs -Wmissing-declarations -Wmissing-prototypes -Wno-long-long \
  -Wfloat-equal -Wno-multichar -Wno-format-nonliteral \
  -Wendif-labels -Wstrict-prototypes -Wdeclaration-after-statement \
  -Wno-system-headers -Wno-typedef-redefinition -Wno-unused-variable \
  -Wno-unused-function 
CURL_CSOURCES := \
  amigaos.c asyn-ares.c asyn-thread.c base64.c conncache.c \
  connect.c content_encoding.c cookie.c curl_addrinfo.c curl_fnmatch.c \
  curl_gethostname.c curl_gssapi.c curl_memrchr.c curl_multibyte.c \
  curl_ntlm.c curl_ntlm_core.c curl_ntlm_msgs.c curl_ntlm_wb.c curl_rtmp.c \
  curl_sasl.c curl_sasl_sspi.c curl_sspi.c curl_threads.c dict.c dotdot.c \
  easy.c escape.c file.c fileinfo.c formdata.c ftp.c ftplistparser.c \
  getenv.c getinfo.c gopher.c hash.c hmac.c hostasyn.c hostcheck.c \
  hostip4.c hostip6.c hostip.c hostsyn.c http2.c http.c http_chunks.c \
  http_digest.c http_negotiate.c http_negotiate_sspi.c http_proxy.c \
  idn_win32.c if2ip.c imap.c inet_ntop.c inet_pton.c krb5.c ldap.c llist.c \
  md4.c md5.c memdebug.c mprintf.c multi.c netrc.c non-ascii.c nonblock.c \
  nwlib.c nwos.c openldap.c parsedate.c pingpong.c pipeline.c pop3.c \
  progress.c rawstr.c rtsp.c security.c select.c sendf.c share.c slist.c \
  smtp.c socks.c socks_gssapi.c socks_sspi.c speedcheck.c splay.c ssh.c \
  strdup.c strequal.c strerror.c strtok.c strtoofft.c telnet.c tftp.c \
  timeval.c transfer.c url.c version.c warnless.c wildcard.c x509asn1.c \
  smb.c curl_sasl_gssapi.c curl_endian.c curl_des.c \
  vtls/axtls.c vtls/darwinssl.c vtls/schannel.c vtls/cyassl.c \
  vtls/gskit.c vtls/gtls.c vtls/nss.c vtls/openssl.c vtls/polarssl.c \
  vtls/polarssl_threadlock.c vtls/vtls.c
CURL_LOCAL_SRC_FILES := $(addprefix ../../curl/lib/,$(CURL_CSOURCES))
CURL_LOCAL_C_INCLUDES += \
  $(LOCAL_PATH)/../../curl/include \
  $(LOCAL_PATH)/../../curl/lib \
  $(NDK_PATH)/platforms/$(TARGET_PLATFORM)/arch-arm/usr/include \
  $(LOCAL_PATH)/../../openssl/include
