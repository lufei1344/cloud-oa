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
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/plugins/layer/layer.js"></script>
    <!-- 表单处理 -->
    <script type="text/javascript" src="${ctx}/scripts/form/views.js"></script>
    <!-- 任务处理 -->
    <script type="text/javascript" src="${ctx}/scripts/task/TaskOperation.js"></script>
    <script type="text/javascript">
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
    	getParams();
    	var ROOT_URL = '${ctx}';
    	var taskOperation = new TaskOperation();
    	var viewsdata;
    	function show(){
    		var url = ROOT_URL+"/form/views"+window.location.search;
    		$.getJSON(url,function(redata){
    			if(redata.status){
    				viewsdata = redata.obj;
    				var forms = redata.obj.forms;
    				var title = "";
        			var content = "";
        			for(var i=0; i<forms.length; i++){
        				if(i == 0){
        					title +='<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true" id="'+forms[i].id+'">'+forms[i].name+'</a>'+
    	                        	'</li>'
    	                    content +='<div id="tab-1" class="tab-pane active">'+
    			                    '        <div class="panel-body">'+forms[i].contentHtml+
    			                    '        </div>'+
    			                    '</div>'
        				}else{
        					title +='<li><a data-toggle="tab" href="#tab-'+(i+1)+'" aria-expanded="true" id="'+forms[i].id+'">'+forms[i].name+'</a>'+
		                        	'</li>'
		                    content +='<div id="tab-'+(i+1)+'" class="tab-pane">'+
				                    '        <div class="panel-body">'+forms[i].contentHtml+
				                    '        </div>'+
				                    '</div>'
        				}
        			}
        			$("#title").html(title);
        			$("#content").html(content);
    			}else{
    				alert(redata.msg);
    			}
    		});
    	}
    	$(function(){
    		show();
    	});
    </script>

</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
               <div class="ibox float-e-margins">
                   <div class="ibox-title">
                       <h5>任务处理 
	                       <small class="m-l-sm">
	                       <button type="button" class="btn btn-sm btn-primary" onclick="jumpPage(1)">保存草稿</button> 
	                       <button type="button" class="btn btn-sm btn-primary" onclick="taskOperation.completeTask()">完成任务</button> 
	                       <button type="button" class="btn btn-sm btn-primary" onclick="jumpPage(1)">回退（上一步）</button> 
	                       <button type="button" class="btn btn-sm btn-primary" onclick="jumpPage(1)">回退（发起人）</button> 
	                       <button type="button" class="btn btn-sm btn-primary" onclick="jumpPage(1)">转办</button> 
	                       <button type="button" class="btn btn-sm btn-primary" onclick="jumpPage(1)">协办</button> 
	                       <button type="button" class="btn btn-sm btn-primary" onclick="jumpPage(1)">沟通</button> 
	                       <button type="button" class="btn btn-sm btn-primary" onclick="jumpPage(1)">加签</button> 
	                       </small>
                       </h5>
                       <div class="ibox-tools">
                           <a class="collapse-link">
                               <i class="fa fa-chevron-up"></i>
                           </a>
                       </div>
                   </div>
                   <iframe name="formsubmit" id="formsubmit" style="display: none;"></iframe>
                    <form action="${ctx}/form/saveFormData" id="form" method="post" enctype="multipart/form-data" target="formsubmit">
                   <div class="ibox-content">
                       	  <div class="tabs-container">
		                    <ul class="nav nav-tabs" id="title">
		                    	<c:forEach items="${forms}" var="form" varStatus="status">
		                    	<c:if test="${status.index ==0}">
			                    	<li class="active"><a data-toggle="tab" href="#tab-${status.index+1 }" aria-expanded="true">${form.name }</a>
			                        </li>
		                    	</c:if>
		                    	<c:if test="${status.index > 0}">
			                    	<li class=""><a data-toggle="tab" href="#tab-${status.index+1 }" aria-expanded="false">${form.name }</a>
		                        	</li>
		                    	</c:if>
		                        </c:forEach>
		                    </ul>
		                    <div class="tab-content" id="content">
		                    	<c:forEach items="${forms}" var="form" varStatus="status">
		                    	<c:if test="${status.index ==0}">
			                    	<div id="tab-${status.index+1 }" class="tab-pane active">
			                            <div class="panel-body">
			                               ${form.contentHtml }
			                            </div>
			                        </div>
		                    	</c:if>
		                    	<c:if test="${status.index > 0}">
			                    	 <div id="tab-${status.index+1 }" class="tab-pane">
			                            <div class="panel-body">
			                               ${form.contentHtml } 
			                            </div>
			                        </div>
		                    	</c:if>
		                        </c:forEach>
		                        
		                       
		                    </div>
		                </div>
                   </div>
                   </form>
               </div>
        </div>
    </div>
</body>
</html>

