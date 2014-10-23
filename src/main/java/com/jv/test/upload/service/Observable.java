package com.jv.test.upload.service;

public interface Observable<T> {
	
	Observable<T> registerObserver(Observer<T> observer);
	Observable<T> clearObservers();
		

}
