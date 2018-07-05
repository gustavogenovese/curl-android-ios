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
  amigaos.c asyn-ares.c asyn-thread.c base64.c conncache.c \
  connect.c content_encoding.c cookie.c curl_addrinfo.c curl_ctype.c curl_des.c \
  curl_endian.c curl_fnmatch.c curl_gethostname.c curl_gssapi.c curl_memrchr.c \
  curl_multibyte.c curl_ntlm_core.c curl_ntlm_wb.c curl_path.c curl_range.c \
	curl_rtmp.c curl_sasl.c curl_sspi.c curl_threads.c dict.c dotdot.c easy.c \
	escape.c file.c fileinfo.c formdata.c ftp.c ftplistparser.c getenv.c \
	getinfo.c gopher.c hash.c hmac.c hostasyn.c hostcheck.c hostip.c hostip4.c \
	hostip6.c hostsyn.c http_chunks.c http_digest.c http_negotiate.c http_ntlm.c \
	http_proxy.c http.c http2.c idn_win32.c if2ip.c imap.c inet_ntop.c \
	inet_pton.c krb5.c ldap.c llist.c md4.c md5.c memdebug.c mime.c mprintf.c \
	multi.c netrc.c non-ascii.c nonblock.c nwlib.c nwos.c openldap.c parsedate.c \
	pingpong.c pipeline.c pop3.c progress.c rand.c rtsp.c security.c select.c \
	sendf.c setopt.c sha256.c share.c slist.c smb.c smtp.c socks.c socks_gssapi.c \
	socks_sspi.c speedcheck.c splay.c ssh.c ssh-libssh.c strcase.c strdup.c \
	strerror.c strtok.c strtoofft.c system_win32.c telnet.c tftp.c timeval.c \
	transfer.c url.c version.c warnless.c wildcard.c x509asn1.c vtls/axtls.c \
	vtls/cyassl.c vtls/darwinssl.c vtls/gskit.c vtls/gtls.c vtls/mbedtls.c \
	vtls/nss.c vtls/openssl.c vtls/polarssl_threadlock.c vtls/polarssl.c \
	vtls/schannel_verify.c vtls/schannel.c vtls/vtls.c vauth/cleartext.c \
	vauth/cram.c vauth/digest.c vauth/digest_sspi.c vauth/krb5_gssapi.c \
	vauth/krb5_sspi.c vauth/ntlm_sspi.c vauth/ntlm.c vauth/oauth2.c \
	vauth/spnego_gssapi.c vauth/spnego_sspi.c vauth/vauth.c
CURL_LOCAL_SRC_FILES := $(addprefix ../../curl/lib/,$(CURL_CSOURCES))
CURL_LOCAL_C_INCLUDES += \
  $(LOCAL_PATH)/../../curl/include \
  $(LOCAL_PATH)/../../curl/lib \
  $(LOCAL_PATH)/../../openssl/include
