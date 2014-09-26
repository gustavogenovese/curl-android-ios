#ifndef __TEST_LIBRARY_H
#define __TEST_LIBRARY_H

#include <string>

#ifndef BYTE
    typedef const char BYTE;
    typedef char* LPBYTE;
#endif

struct CURL_DOWNLOAD_OBJECT {
    long size;
    LPBYTE data;
};

bool downloadUrl(const char* url, CURL_DOWNLOAD_OBJECT* downloadObject);

#endif
