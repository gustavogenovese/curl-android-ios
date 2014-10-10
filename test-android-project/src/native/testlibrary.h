#ifndef __TEST_LIBRARY_H
#define __TEST_LIBRARY_H

#ifndef BYTE
    typedef const char BYTE;
    typedef char* LPBYTE;
#endif

#ifndef BOOL
	typedef short BOOL;
	#define TRUE 1
	#define FALSE 0
#endif

typedef struct _CURL_DOWNLOAD_OBJECT {
    long size;
    LPBYTE data;
} CURL_DOWNLOAD_OBJECT, *LPCURL_DOWNLOAD_OBJECT;

BOOL downloadUrl(const char* url, LPCURL_DOWNLOAD_OBJECT downloadObject);

#endif
