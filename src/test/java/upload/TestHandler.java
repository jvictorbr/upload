package upload;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.jv.test.upload.controller.ProcessWebSocketHandler;
import com.jv.test.upload.startup.AppConfig;
import com.jv.test.upload.startup.WebSocketConfig;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes={AppConfig.class, WebSocketConfig.class})
public class TestHandler {
	
	@Autowired
	private ProcessWebSocketHandler handler;
		
	@Test
	public void testMyHandler() {
		
		System.out.println(handler);
				
		
		
	}
	
	

}
