package com.jv.test.upload.service;

public interface Observer<T> {
	
	void receiveNotification(T notification);

}
