package com.jv.test.upload.service;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jv.test.upload.domain.TopSecretServiceState;
import com.jv.test.upload.domain.TopSecretServiceState.WebSocketAction;

@Component
@Scope(proxyMode=ScopedProxyMode.TARGET_CLASS, value="prototype")
public class TopSecretService extends AbstractObservableAdapter<String> {
	
	public void executeWithObserver(TopSecretServiceState state, Observer<String> observer) {
		
		if (TopSecretServiceState.WebSocketAction.START.equals(state.getAction())) { 
			this.clearObservers().registerObserver(observer);
			ultraComplexBusinessLogicInALoop(state.getFileName());
		}
		
	}
	
	public void ultraComplexBusinessLogicInALoop(String fileName) {
		final int TOTAL_LOOP_COUNT = 500;		
		for (int i = 0; i <= TOTAL_LOOP_COUNT; i++) {
			ultraComplexBusinessLogic();
			notifyObservers(createNotificationJson(calculatePercentage(i,  TOTAL_LOOP_COUNT), fileName)); //String.valueOf(calculatePercentage(i, TOTAL_LOOP_COUNT)));
		}		
	}
	
	
	protected void ultraComplexBusinessLogic() { 
		try {
			Thread.sleep(25);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
	
	protected int calculatePercentage(int current, int total) {
		return (int)(((double)current/total)*100);
	}
	
	protected String createNotificationJson(int percentage, String fileName) { 
		
		TopSecretServiceState notification = new TopSecretServiceState();
		notification.setAction(WebSocketAction.STATUS);
		notification.setFileName(fileName);
		notification.setPercentage(percentage);
		
		String notificationJson = null;
		ObjectMapper mapper = new ObjectMapper();
		 
		try {
			notificationJson = mapper.writeValueAsString(notification);
		} catch (JsonProcessingException e) {		
			e.printStackTrace();
		} 
		
		return notificationJson; 
		
	}


}
