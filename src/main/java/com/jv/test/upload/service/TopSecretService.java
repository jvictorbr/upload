package com.jv.test.upload.service;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope(value=ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class TopSecretService extends AbstractObservableAdapter<String> {
	
	public void ultraComplexBusinessLogicInALoop() {
		final int TOTAL_LOOP_COUNT = 500;		
		for (int i = 0; i <= TOTAL_LOOP_COUNT; i++) {
			ultraComplexBusinessLogic();
			notifyObservers(String.valueOf(calculatePercentage(i, TOTAL_LOOP_COUNT)));
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



}
