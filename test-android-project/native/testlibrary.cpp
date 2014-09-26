#include "testlibrary.h"

#include <curl/curl.h>

#ifdef ANDROID
	#include <android/log.h>
	#include <jni.h>
#endif

#ifdef ANDROID
	#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO, "TestLibrary", __VA_ARGS__))
#else
	#define LOGI(...) printf(__VA_ARGS__)
#endif

size_t curlCallback(char *data, size_t size, size_t count, void* userdata);

using namespace std;

bool downloadUrl(const char* url, CURL_DOWNLOAD_OBJECT* downloadObject ) {
	CURL* curl = curl_easy_init();
	curl_easy_setopt(curl, CURLOPT_URL, url);
	curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);
	curl_easy_setopt(curl, CURLOPT_FAILONERROR, true);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &curlCallback);
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, downloadObject);

	CURLcode res = curl_easy_perform(curl);
	if (res != CURLE_OK){
	    LOGI("CURL failed with error code %d", res);
	}
	curl_easy_cleanup(curl);
	return res == CURLE_OK;
}

size_t curlCallback(char *data, size_t size, size_t count, void* userdata) {
	LOGI("Downloaded data size is %d", size*count);

    CURL_DOWNLOAD_OBJECT* downloadObject = (CURL_DOWNLOAD_OBJECT*) userdata;
    long newSize = 0;
    long offset = 0;
    LPBYTE dataPtr;

    if (downloadObject->data == NULL){
        newSize = size * count * sizeof(BYTE);
        dataPtr = (LPBYTE)malloc(newSize);
    }else{
        newSize = downloadObject->size + (size * count * sizeof(BYTE));
        dataPtr = (LPBYTE)realloc(downloadObject->data, newSize);
        offset = downloadObject->size;
    }

    if (dataPtr==NULL){//malloc or realloc failed
        if (downloadObject->data != NULL){//realloc failed
            free(downloadObject->data);
            downloadObject->data = NULL;
            downloadObject->size = 0;
        }

        return 0; //this will abort the download
    }
    downloadObject->data = dataPtr;
    downloadObject->size = newSize;

    memcpy(downloadObject->data + offset, data, size * count * sizeof(BYTE));
	return size*count;
}


#ifdef ANDROID
extern "C" 
{
	JNIEXPORT jbyteArray JNICALL
	Java_com_example_androidtest_TestActivity_downloadUrl(JNIEnv* env, jobject obj, jstring url ){
		const char* url_c = env->GetStringUTFChars(url, NULL);
		if (!url_c)
			return NULL;

		LOGI( "Download URL: %s", url_c );
		CURL_DOWNLOAD_OBJECT* downloadObject = new CURL_DOWNLOAD_OBJECT;
        downloadObject->data = NULL;
        downloadObject->size=0;

		if (downloadUrl(url_c, downloadObject)){
			env->ReleaseStringUTFChars(url, url_c);
			jbyteArray ret = env->NewByteArray(downloadObject->size);
			env->SetByteArrayRegion(ret, 0, downloadObject->size, (jbyte*)downloadObject->data);
			free(downloadObject->data);
			delete downloadObject;
			return ret;
		}else{
			env->ReleaseStringUTFChars(url, url_c);
			return NULL;
		}
	}
}
#endif
