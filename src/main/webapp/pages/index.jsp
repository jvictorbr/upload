<html>
	<head>
		<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/smoothness/jquery-ui.css" />		
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
	
		<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>		
		<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js"></script>
		<script src="<%=request.getContextPath() %>/pages/jquery.fileupload.js"></script>
		<script src="<%=request.getContextPath() %>/pages/jquery.iframe-transport.js"></script>
		<script src="<%=request.getContextPath()%>/pages/sockjs-0.3.4.js"></script>
		
		<style type="text/css">
		
			#mainPanel { 
				width: 900px;									
			}
			
			#dropzone {
				width: 125px;
				height: 125px; 
			}
		
			#progress {
				width: 80%;
				margin: 0 auto;				
				display: none;			 
			}
			
			#uploaded-files {
				width: 80%;
				font-size: 10px;
				margin: 0 auto;	
			}
			
			#upload-completed-alert {				
				display: none;
				width: 80%;	
				heigth: 30px;			
				margin: 0 auto;				 
			}
			
			#processPanel {
				width:  700px;
				display: none;				
			}
			
			/* hide close button on jquery modal dialogs */
			.ui-dialog-titlebar-close{
				display: none;
			}
		
		</style>
		
	</head>

	<body>	
		 <div id="mainPanel" class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">File Upload and WebSocket Demo</h3>
            </div>
            <div class="panel-body">
            
                <input id="fileupload" type="file" name="files[]" data-url="<%=request.getContextPath() %>/controller/upload" multiple />                
               	<br/>
               	<span>Or</span>
                <br/><br/>
                <div id="dropzone" class="img-thumbnail">Drop files here</div>
                
                <br/><br/>
                
                <div id="progress" class="progress">
			        <div id="bar" class="progress-bar progress-bar-striped" style="width: 0%"></div>
			    </div>
			    <div id="upload-completed-alert" class="alert alert-success"></div>
			    			    
			    <br/><br/>
			    
			  	<div id="uploaded-files-container">
	 				<table id="uploaded-files" class="table">
		        		<tr>
		            		<th>File Name</th>
		            		<th>File Size</th>
		            		<th>File Type</th>
		            		<th>Download</th>
		            		<th>Process</th>
		        		</tr>
		    		</table>			 
				</div>        
            </div>
            
			<div id="processPanel" class="panel panel-info" title="Processing">
            	<div class="panel-body">
              		Processing file: 
					<div id="processPanel_progress" class="progress">
			        	<div id="processPanel_bar" class="progress-bar progress-bar-striped" style="width: 0%"></div>
			    	</div>
            	</div>
			</div>
            
            
          </div>
          
	
        
          
          
          
	</body> 
                 	
			
			<script type="text/javascript">		
			
			function showAlert(message) { 
				$("#upload-completed-alert").html(message).fadeIn(1500);
				setTimeout(function() { 
					$("#upload-completed-alert").fadeOut(1000);	
				}, 2000);
			}
			
			function reposition(elementId) { 
				$(elementId).position({
					my: 'center center',
					at: 'center center',
					of: $(document)
				});					
			}
			
			$(function () {
				

				
				reposition("#mainPanel");

				/* Init File Upload Component */
				$('#fileupload').fileupload({
					dataType: 'json',
			 
			        done: function (e, data) {		      	 
			            //$("tr:has(td)").remove();
			            $.each(data.result, function (index, file) {			 
			                $("#uploaded-files")
			                		.append($('<tr/>')			                        
			                        .append($('<td/>').text(file.fileName))
			                        .append($('<td/>').text(file.fileSize))
			                        .append($('<td/>').text(file.fileType))
			                        .append($('<td/>').html("<a href='<%= request.getContextPath() %>/controller/upload/"+index+"'>Click</a>"))
			                        .append($('<td/>').html("<span onclick='process()'>Process</span>"))
			                        )
			            });
			            reposition("#mainPanel");
			        },
			 
			        progressall: function (e, data) {			        	
			            var progress = parseInt(data.loaded / data.total * 100, 10);			            
			            $('#bar').css('width', progress + '%');			            
			            if (progress < 100) { 
			            	$('#progress').fadeIn(200);	
			            } else {			            	
			            	$('#progress').fadeOut(200);			            	
			            	showAlert("Upload completed successfully.");
			            }			            
			        },
			 
			        dropZone: $('#dropzone')        
			        
			    });
				/* End File Upload Component */		    
				
				/* Init Process Dialog */
				$("#processPanel").dialog({
					modal:true,
					autoOpen:false,
					show: {
				        effect: 'fade',
				        duration: 2000
				    },
				    hide: {
				        effect: 'fade',
				        duration: 500
				    }
				});
			
			});
			
			
			 function process() {			
				 
				var socket = new SockJS('<%= request.getContextPath() %>/controller/process');				
				socket.onopen = function() {
					console.log('web socket opened...');
					socket.send('process');				
					$("#processPanel_bar").css('width', '0%');
					$("#processPanel").dialog("open");					
				};
				socket.onclose = function() {
					console.log('web socket closed...');
				};
				socket.onmessage = function(e) { 
					var message = e.data;
					console.log('received message: ' + message)
					$("#processPanel_bar").css('width', message + '%');
					if (message == 100) { 
						$("#processPanel").dialog("close");												
						showAlert("Process completed");
					}
				}
				
			   		
			}
		
		
		</script>
	
	
	
</html>
