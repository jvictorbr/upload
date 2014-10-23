package com.jv.test.upload.service;

import java.util.HashSet;
import java.util.Set;

public abstract class AbstractObservableAdapter<T> implements Observable<T> {
	
	private Set<Observer<T>> observers = new HashSet<Observer<T>>();
	
	public Observable<T> registerObserver(Observer<T> observer) { 
		this.observers.add(observer);
		return this;
	}
	
	public Observable<T> clearObservers() { 
		this.observers.clear();
		return this;
	}
	
	protected void notifyObservers(T notification) { 		
		for (Observer<T> observer : observers) { 
			observer.receiveNotification(notification);
		}		
	}
	
	
	

}
