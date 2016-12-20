<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>任务详细</title>

    <link rel="shortcut icon" href="favicon.ico"/>
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet"/>
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet"/>
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet"/>
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
    
    <!--  -->
    <link href="${ctx}/scripts/wfdesigner/js/designer/designer.css" type="text/css" rel="stylesheet"/>
     <SCRIPT src='${ctx}/scripts/wfdesigner/js/draw2d/wz_jsgraphics.js'></SCRIPT>          
    <SCRIPT src='${ctx}/scripts/wfdesigner/js/draw2d/mootools.js'></SCRIPT>          
    <SCRIPT src='${ctx}/scripts/wfdesigner/js/draw2d/moocanvas.js'></SCRIPT>                        
    <SCRIPT src='${ctx}/scripts/wfdesigner/js/draw2d/draw2d.js'></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/FlowShow.js"></SCRIPT>
    <SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/ResizeImage.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/event/Start.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/event/End.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/connection/MyInputPort.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/connection/MyOutputPort.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/connection/DecoratedConnection.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/task/Task.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/task/UserTask.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/task/ManualTask.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/task/ServiceTask.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/task/ScriptTask.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/task/MailTask.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/task/ReceiveTask.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/task/BusinessRuleTask.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/task/CallActivity.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/gateway/ExclusiveGateway.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/gateway/ParallelGateway.js"></SCRIPT>
	<SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/designer.js"></SCRIPT>	
    
    
    <script type="text/javascript">
    var ROOT_URL = "${ctx}";
    var webpath ="${ctx}/scripts/";
	    var params = new Object();
		function getParams(){
			var p = decodeURI(window.location.search.substring(1)).split("&");
	    	for(var i = 0; i < p.length; i++){
	    		var v = p[i].split("=");
	    		if(v.length==2){
	    			params[v[0]] = v[1];
	    		}
	    	}
		}
    	function showViews(){
    		getParams();
    		var data = {processInstanceId:params.processInstanceId,activityId:params.activityId};
    		jq.getJSON("${ctx}/flow/task/taskTrace",data,function(redata){
    			if(redata.status){
    				createCanvas(redata.obj.xml);
    			}else{
    				alert("服务器错误");
    			}
    			
    		});
    	}
    	
    	var workflow;
    	var processDefinitionVariables={};
    	function createCanvas(xml){
    		try{
    			workflow  = new draw2d.MyCanvas("paintarea");
    			workflow.scrollArea=document.getElementById("designer-area");
    			workflow.setDisabled();
    			workflow.showXml(xml,params.activityId);
    		}catch(e){
    			alert(e.message);
    		}
    	}
    	
    	jq(function(){
    		showViews();
    	});
    </script>
</head>

	<body>
	
		<table>
			<tr >
				<td height="300px">
				<div id="designer-area" class="row" title="流程" style="POSITION: absolute;width:100%;height:100%;padding: 0;border: none;overflow:auto;">
					<div id="paintarea" style="POSITION: absolute;WIDTH: 100%; HEIGHT: 300px" ></div>
				</div>
				</td>
			</tr>
			<tr>
				<td>
				 <table class="table table-striped table-hover table-bordered" id="page">
					<thead>
					<tr>
						 <th class="sorting" name="name">名称</th>
		        		<th class="sorting" name="startTime">开始时间</th>
		        		<th class="sorting" name="endTime">结束时间</th>
		        		<th class="sorting" name="assignee">负责人</th>
					</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
				
				</td>
			</tr>
		
		</table>
			
		
   
	</body>
</html>


