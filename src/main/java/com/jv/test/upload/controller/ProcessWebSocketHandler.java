package com.jv.test.upload.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jv.test.upload.domain.TopSecretServiceState;
import com.jv.test.upload.service.TopSecretService;
import com.jv.test.upload.service.WebSocketObserver;

public class ProcessWebSocketHandler extends TextWebSocketHandler {
	
	@Autowired
	private TopSecretService service;
	
	@Override	
	public void handleTextMessage(WebSocketSession session, TextMessage message) throws IOException {
		
		String msg = message.getPayload();
		
		ObjectMapper mapper = new ObjectMapper();
		TopSecretServiceState state = mapper.readValue(msg, TopSecretServiceState.class);
		
		service.executeWithObserver(state, new WebSocketObserver(session));
		session.close(CloseStatus.NORMAL);
	
	}


}
