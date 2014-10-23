package com.jv.test.upload.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.jv.test.upload.service.TopSecretService;
import com.jv.test.upload.service.WebSocketObserver;

public class ProcessWebSocketHandler extends TextWebSocketHandler {
	
	private final TopSecretService service;
	
	@Autowired
	public ProcessWebSocketHandler(TopSecretService service) {
		this.service = service;		
	}
	
	@Override
	public void handleTextMessage(WebSocketSession session, TextMessage message) throws IOException {
		
		service.clearObservers().registerObserver(new WebSocketObserver(session));
		service.ultraComplexBusinessLogic();		
		session.close(CloseStatus.NORMAL);
	
	}
	
	


}
