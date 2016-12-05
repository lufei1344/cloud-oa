<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>任务处理</title>
    <link rel="shortcut icon" href="favicon.ico"> 
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet">
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
    <!-- 表单处理 -->
    <script type="text/javascript" src="${ctx}/scripts/form/views.js"></script>
    <!-- 任务处理 -->
    <script type="text/javascript" src="${ctx}/scripts/flow/TaskOperation.js"></script>
    <script type="text/javascript">
    	//taskid=12505&executionId=12505&forms=&fields=&processInstanceId=12505&processDefinitionId=process1479698618758:2:12504&activityId=task1479698622742
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
    	//初始化加载
    	function initLoad(){
    		getParams();
    		var url = "${ctx}/flow/task/tonext";
    		var data = {processDefinitionId:params.processDefinitionId,activityId:params.activityId};
    		$.getJSON(url,data,function(redata){
    			//type : only单人,more多人,multi会签
    			var nodes = redata.obj;
    			var title = "";
    			var users = "";
    			for(var i=0; i<nodes.length; i++){
    				if(i == 0){
    					title +='<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true" id="'+nodes[i].id+'" type="'+nodes[i].type+'">'+nodes[i].name+'</a>'+
	                        	'</li>'
	                    users +='<div id="tab-1" class="tab-pane active">'+
			                    '        <div class="full-height-scroll">'+
                                '        <div class="table-responsive">'+
                                '            <table class="table table-striped table-hover">'+
                                '                <tbody>';
			            for(var n=0; n<nodes[i].users.length;n++){
			            	users += "<tr><td id='"+nodes[i].users[n].id+"'><input type='checkbox' name='user'  title='"+nodes[i].users[n].fullname+"' value='"+nodes[i].users[n].id+"'/>"+nodes[i].users[n].fullname+"</td></tr>";
			            }           
			                    
                        users += '  </tbody></table></div></div></div>';
    				}else{
    					title +='<li><a data-toggle="tab" href="#tab-'+(i+1)+'" aria-expanded="true" id="'+nodes[i].id+'"  type="'+nodes[i].type+'">'+nodes[i].name+'</a>'+
                    			'</li>'
		                users +='<div id="tab-'+(i+1)+'" class="tab-pane">'+
			                    '        <div class="full-height-scroll">'+
		                        '        <div class="table-responsive">'+
		                        '            <table class="table table-striped table-hover">'+
		                        '                <tbody>';
			            for(var n=0; n<nodes[i].users.length;n++){
			            	users += "<tr><td id='"+nodes[i].users[n].id+"'><input type='checkbox' name='user' title='"+nodes[i].users[n].fullname+"' value='"+nodes[i].users[n].id+"'/>"+nodes[i].users[n].fullname+"</td></tr>";
			            }           
			                    
		                users += '  </tbody></table></div></div></div>';
    				}
    			}
    			$("#title").html(title);
    			$("#users").html(users);
    			if(nodes.length == 1 && nodes[0].name == "结束"){//结束节点
    				completeTask();
    			}
    		});
    	}
    	
    	$(function(){
    		initLoad();
    	});
    	function completeTask(){
    		var users = [];
    		var $node = $("#title li[class='active']").find("a");
    		var us = $("#users .tab-pane[class='tab-pane active']").find("input:checked");
    		for(var i=0; i<us.length; i++){
    			//alert(us[i].title);
    			users.push(us[i].value);
    		}
    		var data = new Object();
    		if(typeof params.executionId == 'undefined'){
    			data.executionId = "";
    		}else{
    			data.executionId = params.executionId;
    		}
    		data.taskId = params.taskId;
    		data.activityId = $node.attr("id");
    		data.type = $node.attr("type");
    		data.users = users.join(",");
    		data.next = $node.text();
    		var url = "${ctx}/flow/task/next";
    		$.getJSON(url,data,function(redata){
    			if(redata.status){
    				alert("提交成功");
    				window.parent.close();
    			}else{
    				alert("提交失败")
    			}
    		});
    	}
    </script>

</head>

<body>
    <div class="wrapper animated fadeIn">
        <div class="row">
              <div class="tabs-container">
                  <ul class="nav nav-tabs" id="title">
                  	<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">1</a>
                      </li>
                  </ul>
                  <div class="tab-content" id="users">
                  	<div id="tab-1" class="tab-pane active">
                          <div class="panel-body">
                            	无内容
                          </div>
                      </div>
                  	
                  </div>
              </div>
        </div>
        <div class="row">
        	<center>
        	<input type="submit" class="btn btn-sm btn-primary" name="submit" onclick="completeTask()" value="提交">
						<input type="button" class="btn btn-sm btn-primary" name="reback" value="返回"
							onclick="history.back()">
			</center>				
        </div>
    </div>
</body>
</html>

