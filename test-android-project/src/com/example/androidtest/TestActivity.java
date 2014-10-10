package com.example.androidtest;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

public class TestActivity extends Activity{
	static {
		System.loadLibrary("testlibrary");
	}
	
	@Override
	protected void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
		Log.i("TestActivity", "Launching new thread to run the request");

		new Thread(){
			public void run(){
				String url = "https://www.google.com";
				Log.i("TestActivity", "Requesting URL to download: " + url);

				byte[] content = downloadUrl(url);
				String contentString=content == null ? null : new String(content);
				Log.i("TestActivity", contentString != null ? 
										(contentString.length() > 50 ?
											"First 50 bytes downloaded: " + contentString.substring(0,50) 
											: "Downloaded data: " + contentString)
										: "Content is null");
			}
		}.start();

	}

	public native byte[] downloadUrl(String url);
}; 
