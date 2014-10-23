package com.jv.test.upload.startup;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.jv.test.upload.controller.ProcessWebSocketHandler;
import com.jv.test.upload.service.TopSecretService;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {
	
	@Autowired TopSecretService service;

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {

		registry.addHandler(new ProcessWebSocketHandler(topSecretService()), "/process").withSockJS();
		
	}
	
	@Bean
	public TopSecretService topSecretService() { 
		return service;
	}

}
