<html>
	<head>
	
		<!-- JQuery stuff -->
		<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/smoothness/jquery-ui.css" />		
		<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>		
		<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js"></script>
		<script src="<%=request.getContextPath() %>/pages/jquery.fileupload.js"></script>
		<script src="<%=request.getContextPath() %>/pages/jquery.iframe-transport.js"></script>
		
		<!-- Bootstrap stuff -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
		
		<!-- Sock JS -->
		<script src="<%=request.getContextPath()%>/pages/sockjs-0.3.4.js"></script>
		
		<style type="text/css">
		
			#mainPanel { 
				width: 900px;									
			}
			
			#fileupload_dropzone {
				width: 125px;
				height: 125px; 
			}
		
			#fileupload_progressContainer {
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
			
		</style>
		
	</head>

	<body>	
		 <div id="mainPanel" class="panel panel-primary">
            <div class="panel-heading">
              <h3 class="panel-title">File Upload and WebSocket Demo</h3>
            </div>
            <div class="panel-body">
            
                <input id="fileupload_input" type="file" name="files[]" data-url="<%=request.getContextPath() %>/controller/upload" multiple />                
               	<br/>
               	<span>Or</span>
                <br/><br/>
                <div id="fileupload_dropzone" class="img-thumbnail">Drop files here</div>
                
                <br/><br/>
                
                <div id="fileupload_progressContainer" class="progress">
			        <div id="fileupload_progressBar" class="progress-bar progress-bar-striped" style="width: 0%"></div>
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
            
            <!-- MODAL Processing DIV -->
			<div id="processPanel" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    			<div class="modal-dialog">
      				<div class="modal-content">
        				<div class="modal-header">
          					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          					<h4 class="modal-title">Processing</h4>
        				</div>
        				<div class="modal-body">
          					Processing file: <span id="panel-body-fileName"></span>
              				<br/><br/>
							<div id="processPanel_progress" class="progress">
			        			<div id="processPanel_bar" class="progress-bar progress-bar-striped" style="width: 0%"></div>
			    			</div>
        				</div>
      				</div>
    			</div>
  			</div>
         	<!-- MODAL Processing DIV -->
            
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
				$('#fileupload_input').fileupload({
					dataType: 'json',
			 
			        done: function (e, data) {		      	 
			            //$("tr:has(td)").remove();
			            $.each(data.result, function (index, file) {			 
			                $("#uploaded-files")
			                		.append($("<tr/>")			                        
			                        .append($('<td/>').text(file.fileName))
			                        .append($('<td/>').text(file.fileSize))
			                        .append($('<td/>').text(file.fileType))
			                        .append($('<td/>').html("<a href='<%= request.getContextPath() %>/controller/upload/"+index+"'>Click</a>"))
			                        .append($('<td/>')
			                        	.append($('<span/>').css("cursor", "pointer").text("Process").click(function(){
			                        		var fileName = file.fileName;			                        		
			                        		process(event,fileName);
			                        	}))
			                        	)                      		
			             			)
			            });
			            reposition("#mainPanel");
			        },
			        
			        progressall: function (e, data) {			        	
			            var progress = parseInt(data.loaded / data.total * 100, 10);			            
			            $('#fileupload_progressBar').css('width', progress + '%');			            
			            if (progress < 100) { 
			            	$('#fileupload_progressContainer').fadeIn(200);	
			            } else {			            	
			            	$('#fileupload_progressContainer').fadeOut(200);			            	
			            	showAlert("Upload completed successfully.");
			            }			            
			        },
			 
			        dropZone: $('#fileupload_dropzone')        
			        
			    });
				/* End File Upload Component */		    
				
				/* Init Process Dialog */
// 				$("#processPanel").dialog({
// 					modal:true,
// 					autoOpen:false,
// 					show: {
// 				        effect: 'fade',
// 				        duration: 2000
// 				    },
// 				    hide: {
// 				        effect: 'fade',
// 				        duration: 500
// 				    }
// 				});
				/* Init Process Dialog */
			
			});
			
			
			 function process(event, fileName) {
				 		 				  
				var socket = new SockJS('<%= request.getContextPath() %>/controller/process');				
				socket.onopen = function() {
					console.log('web socket opened...');
					socket.send('process');				
					$(event.srcElement || event.target).text("Processing").css("color", "yellow").unbind("click");
					$("#processPanel_bar").css('width', '0%');					
					$("#panel-body-fileName").html(fileName);
					$("#processPanel").modal('show');					
					this.fileName = fileName;
				};
				socket.onclose = function() {
					console.log('web socket closed...');
				};
				socket.onmessage = function(e) { 
					var message = e.data;
					console.log('received message: ' + message)
					$("#processPanel_bar").css('width', message + '%');
					if (message == 100) { 
						$("#processPanel").modal('hide');												
						showAlert("Process completed for file: " + this.fileName);						
						var eventElement = $(event.srcElement || event.target);
						$(eventElement).css("color", "green").css("cursor", "default").html("Processed").unbind("click");
					}
				}
				   		
			}
		
		
		</script>
	
	
	
</html>
