//
//  AppDelegate.m
//  Test iOS App
//

#import "AppDelegate.h"
#include <curl/curl.h>


#ifndef BYTE
typedef const char BYTE;
typedef char* LPBYTE;
#endif

typedef struct _CURL_DOWNLOAD_OBJECT {
    long size;
    LPBYTE data;
} CURL_DOWNLOAD_OBJECT, *LPCURL_DOWNLOAD_OBJECT;


size_t curlCallback(char *data, size_t size, size_t count, void* userdata);
BOOL downloadUrl(const char* url, LPCURL_DOWNLOAD_OBJECT downloadObject);

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    const char* url = "https://www.google.com";
    NSLog(@"Starting the download of url %s", url);
    CURL_DOWNLOAD_OBJECT downloadObject;
    downloadObject.data = NULL;
    downloadObject.size = 0;
    downloadUrl(url, &downloadObject);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end

BOOL downloadUrl(const char* url, LPCURL_DOWNLOAD_OBJECT downloadObject ) {
	CURL* curl = curl_easy_init();
	curl_easy_setopt(curl, CURLOPT_URL, url);
	curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, TRUE);
	curl_easy_setopt(curl, CURLOPT_FAILONERROR, TRUE);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &curlCallback);
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, downloadObject);
	curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, FALSE);
	curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, FALSE);
    
	CURLcode res = curl_easy_perform(curl);
	if (res != CURLE_OK){
	    NSLog(@"CURL failed with error code %d", res);
	}
	curl_easy_cleanup(curl);
	return res == CURLE_OK;
}

size_t curlCallback(char *data, size_t size, size_t count, void* userdata) {
	NSLog(@"Downloaded data size is %lu", size*count);
    
    LPCURL_DOWNLOAD_OBJECT downloadObject = (LPCURL_DOWNLOAD_OBJECT) userdata;
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

