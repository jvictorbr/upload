package com.jv.test.upload.service;

import java.io.IOException;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

public class WebSocketObserver implements Observer<String> {
	
	private final WebSocketSession session;
	
	public WebSocketObserver(WebSocketSession session) {
		this.session = session;
	}

	@Override
	public void receiveNotification(String notification) {

		try {
			session.sendMessage(new TextMessage(notification));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
