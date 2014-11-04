package com.jv.test.upload.domain;

public class TopSecretServiceState {
	
	 private WebSocketAction action;
	 private String fileName;
	 private Integer percentage;

	public WebSocketAction getAction() {
		return action;
	}

	public void setAction(WebSocketAction action) {
		this.action = action;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Integer getPercentage() {
		return percentage;
	}

	public void setPercentage(Integer percentage) {
		this.percentage = percentage;
	}

	public static enum WebSocketAction { 
		
		START, STATUS, FINISH;
		
	}
	

}
