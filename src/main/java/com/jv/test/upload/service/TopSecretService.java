package com.jv.test.upload.service;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope(value=ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class TopSecretService extends AbstractObservableAdapter<String> {
	
	public void ultraComplexBusinessLogic() { 
		
		for (int i = 0; i <= 100; i++) {
		
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			notifyObservers(String.valueOf(i));
		}
		
	}



}
