CURL_COMMON_CFLAGS := \
  -DANDROID -DOPENSSL_NO_ASM -DOPENSSL_THREADS -D_REENTRANT -DBUILDING_LIBCURL \
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
  strcase.c dict.c llist.c mprintf.c pingpong.c socks_gssapi.c psl.c url.c \
  timeval.c curl_get_line.c idn_win32.c hmac.c md4.c curl_range.c hostsyn.c \
  strtok.c curl_threads.c if2ip.c http_negotiate.c nwlib.c doh.c curl_endian.c \
  formdata.c hostcheck.c rand.c http2.c content_encoding.c hostip.c escape.c \
  easy.c share.c slist.c inet_pton.c tftp.c socks.c parsedate.c warnless.c \
  nwos.c system_win32.c transfer.c curl_rtmp.c nonblock.c select.c hostip4.c \
  urlapi.c openldap.c getenv.c hash.c http_proxy.c vquic/quiche.c vquic/ngtcp2.c \
  krb5.c multi.c strdup.c mime.c socks_sspi.c smtp.c curl_addrinfo.c memdebug.c \
  progress.c curl_ntlm_core.c curl_path.c hostasyn.c pop3.c gopher.c rtsp.c \
  curl_ntlm_wb.c curl_gethostname.c curl_des.c base64.c splay.c curl_ctype.c \
  dotdot.c http.c curl_sspi.c http_chunks.c telnet.c amigaos.c fileinfo.c \
  version.c ldap.c curl_sasl.c netrc.c socketpair.c strerror.c curl_multibyte.c \
  altsvc.c conncache.c curl_memrchr.c smb.c sha256.c connect.c ftp.c strtoofft.c \
  md5.c vauth/krb5_sspi.c vauth/spnego_sspi.c vauth/ntlm.c vauth/spnego_gssapi.c \
  vauth/ntlm_sspi.c vauth/vauth.c vauth/oauth2.c vauth/cram.c vauth/cleartext.c \
  vauth/krb5_gssapi.c vauth/digest.c vauth/digest_sspi.c file.c http_digest.c \
  asyn-thread.c vtls/gskit.c vtls/mbedtls.c vtls/gtls.c vtls/bearssl.c \
  vtls/polarssl.c vtls/schannel.c vtls/sectransp.c vtls/schannel_verify.c \
  vtls/vtls.c vtls/polarssl_threadlock.c vtls/mesalink.c vtls/nss.c \
  vtls/openssl.c vtls/wolfssl.c vssh/libssh.c vssh/libssh2.c asyn-ares.c imap.c \
  security.c cookie.c hostip6.c sendf.c ftplistparser.c http_ntlm.c x509asn1.c \
  setopt.c non-ascii.c getinfo.c speedcheck.c inet_ntop.c wildcard.c curl_gssapi.c \
  curl_fnmatch.c 
CURL_LOCAL_SRC_FILES := $(addprefix ../../curl/lib/,$(CURL_CSOURCES))
CURL_LOCAL_C_INCLUDES += \
  $(LOCAL_PATH)/../../curl/include \
  $(LOCAL_PATH)/../../curl/lib \
  $(LOCAL_PATH)/../../openssl/include
