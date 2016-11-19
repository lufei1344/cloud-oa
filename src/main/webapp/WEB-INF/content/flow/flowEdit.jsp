<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
	<!-- framework CSS -->
	<link href="${ctx}/scripts/wfdesigner/themes/default/css/style.css" type="text/css" rel="stylesheet" title="blue"/>

	<!-- JQuery EasyUi CSS-->
	<link type="text/css" href="${ctx}/scripts/wfdesigner/js/jquery-easyui/themes/default/easyui.css" rel="stylesheet" title="blue">
	<link href="${ctx}/scripts/wfdesigner/js/jquery-easyui/themes/icon.css" type="text/css" rel="stylesheet"/>
	
	<!-- JQuery validate CSS-->
	<link href="${ctx}/scripts/wfdesigner/js/validate/jquery.validate.extend.css" type="text/css" rel="stylesheet"/>
	
	<!-- JQuery AutoComplete -->
	<link rel="stylesheet" type="text/css" href="${ctx}/scripts/wfdesigner/js/jquery-autocomplete/jquery.autocomplete.css" />
	<!--<link rel="stylesheet" type="text/css" href="${ctx}/scripts/wfdesigner/js/jquery-autocomplete/lib/thickbox.css" />-->
	
	<!-- JQuery-->
	<script src="${ctx}/scripts/wfdesigner/js/jquery-1.4.4.min.js" type="text/javascript"></script>
	<!--<script src="${ctx}/scripts/wfdesigner/js/jquery-1.6.min.js" type="text/javascript"></script>-->
	
	<!-- JQuery EasyUi JS-->
	<script src="${ctx}/scripts/wfdesigner/js/jquery-easyui/jquery.easyui.min.js" type="text/javascript"></script>
	<!-- JQuery validate JS-->
	<script src="${ctx}/scripts/wfdesigner/js/validate/jquery.validate.js" type="text/javascript"></script>
	<script src="${ctx}/scripts/wfdesigner/js/validate/jquery.metadata.js" type="text/javascript"></script>
	<script src="${ctx}/scripts/wfdesigner/js/validate/jquery.validate.method.js" type="text/javascript"></script>
	<script src="${ctx}/scripts/wfdesigner/js/validate/jquery.validate.extend.js" type="text/javascript"></script>
	
	<!-- JQuery form Plugin -->
	<script src="${ctx}/scripts/wfdesigner/js/jquery.form.js" type="text/javascript"></script>
	
	<!-- JSON JS-->
	<script src="${ctx}/scripts/wfdesigner/js/json2.js" type="text/javascript"></script>
	
	<!-- JQuery AutoComplete -->
	<script type='text/javascript' src='${ctx}/scripts/wfdesigner/js/jquery-autocomplete/lib/jquery.bgiframe.min.js'></script>
	<script type='text/javascript' src='${ctx}/scripts/wfdesigner/js/jquery-autocomplete/lib/jquery.ajaxQueue.js'></script>
	<!--<script type='text/javascript' src='${ctx}/scripts/wfdesigner/js/jquery-autocomplete/lib/thickbox-compressed.js'></script>-->
	<script type='text/javascript' src='${ctx}/scripts/wfdesigner/js/jquery-autocomplete/jquery.autocomplete.min.js'></script>
	
	<!-- framework JS -->
	<script src="${ctx}/scripts/wfdesigner/js/skin.js" type="text/javascript"></script>
	<link href="${ctx}/scripts/wfdesigner/js/designer/designer.css" type="text/css" rel="stylesheet"/>
  			
    <!-- common, all times required, imports -->
    <SCRIPT src='${ctx}/scripts/wfdesigner/js/draw2d/wz_jsgraphics.js'></SCRIPT>          
    <SCRIPT src='${ctx}/scripts/wfdesigner/js/draw2d/mootools.js'></SCRIPT>          
    <SCRIPT src='${ctx}/scripts/wfdesigner/js/draw2d/moocanvas.js'></SCRIPT>                        
    <SCRIPT src='${ctx}/scripts/wfdesigner/js/draw2d/draw2d.js'></SCRIPT>


    <!-- example specific imports -->
    <SCRIPT src="${ctx}/scripts/wfdesigner/js/designer/MyCanvas.js"></SCRIPT>
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
</head>
<script type="text/javascript">
	
	var processDefinitionId="${deploy.id}";
	var processDefinitionName="${deploy.name}";
	var processDefinitionVariables="";
	var _process_def_provided_listeners="";
	var is_open_properties_panel = false;
	var task;
	var line;
	jq(function(){
		try{
			_task_obj = jq('#task');
			_designer = jq('#designer');
			_properties_panel_obj = _designer.layout('panel','east');
			_properties_panel_obj.panel({
				onOpen:function(){
					is_open_properties_panel = true;
				},
				onClose:function(){
					is_open_properties_panel = false;
				}
			});
			_process_panel_obj = _designer.layout('panel','center');
			_task_context_menu = jq('#task-context-menu').menu({});
			_designer.layout('collapse','east');
			
			jq('.easyui-linkbutton').draggable({
						proxy:function(source){
							var n = jq('<div class="draggable-model-proxy"></div>');
							n.html(jq(source).html()).appendTo('body');
							return n;
						},
						deltaX:0,
						deltaY:0,
						revert:true,
						cursor:'auto',
						onStartDrag:function(){
							jq(this).draggable('options').cursor='not-allowed';
						},
						onStopDrag:function(){
							jq(this).draggable('options').cursor='auto';
						}	
			});
			jq('#paintarea').droppable({
						accept:'.easyui-linkbutton',
						onDragEnter:function(e,source){
							jq(source).draggable('options').cursor='auto';
						},
						onDragLeave:function(e,source){
							jq(source).draggable('options').cursor='not-allowed';
						},
						onDrop:function(e,source){
							//jq(this).append(source)
							//jq(this).removeClass('over');
							var wfModel = jq(source).attr('wfModel');
							var shape = jq(source).attr('iconImg');
							if(wfModel){
								var x=jq(source).draggable('proxy').offset().left;
								var y=jq(source).draggable('proxy').offset().top;
								var xOffset    = workflow.getAbsoluteX();
			                    var yOffset    = workflow.getAbsoluteY();
			                    var scrollLeft = workflow.getScrollLeft();
			                    var scrollTop  = workflow.getScrollTop();
			                  //alert(xOffset+"|"+yOffset+"|"+scrollLeft+"|"+scrollTop);
			                  //alert(shape);
			                    addModel(wfModel,x-xOffset+scrollLeft,y-yOffset+scrollTop,shape);
							}
						}
					});
			//jq('#paintarea').bind('contextmenu',function(e){
				//alert(e.target.tagName);
			//});
		}catch(e){
			alert(e.message);
		};
		jq(window).unload( function () { 
			window.opener._list_grid_obj.datagrid('reload');
		} );
	});
	function addModel(name,x,y,icon){
		var model = null;
		if(icon!=null&&icon!=undefined){
			model = eval("new draw2d."+name+"('"+icon+"')");
		}else{
			model = eval("new draw2d."+name+"(openTaskProperties)");
		}
		//userTask.setContent("DM Approve");
		model.generateId();
		//var id= task.getId();
		//task.id=id;
		//task.setId(id);
		//task.taskId=id;
		//task.taskName=id;
		//var parent = workflow.getBestCompartmentFigure(x,y);
		//workflow.getCommandStack().execute(new draw2d.CommandAdd(workflow,task,x,y,parent));
		workflow.addModel(model,x,y);
	}
	
	function openTaskProperties(t){
		if(!is_open_properties_panel)
			_designer.layout('expand','east');
		task=t;
		if(task.type=="draw2d.UserTask")
			_properties_panel_obj.panel('refresh','userTaskProperties.html');
		else if(task.type=="draw2d.ManualTask")
			_properties_panel_obj.panel('refresh','manualTaskProperties.html');
		else if(task.type=="draw2d.ServiceTask")
			_properties_panel_obj.panel('refresh','serviceTaskProperties.html');
		else if(task.type=="draw2d.ScriptTask")
			_properties_panel_obj.panel('refresh','scriptTaskProperties.html');
		else if(task.type=="draw2d.ReceiveTask")
			_properties_panel_obj.panel('refresh','receiveTaskProperties.html');
		else if(task.type=="draw2d.MailTask")
			_properties_panel_obj.panel('refresh','mailTaskProperties.html');
		else if(task.type=="draw2d.BusinessRuleTask")
			_properties_panel_obj.panel('refresh','businessRuleTaskProperties.html');
		else if(task.type=="draw2d.CallActivity")
			_properties_panel_obj.panel('refresh','callActivityProperties.html');
	}
	function openProcessProperties(id){
		//alert(id);
		if(!is_open_properties_panel)
			_designer.layout('expand','east');
		_properties_panel_obj.panel('refresh','${ctx}/scripts/wfdesigner/wf/designer/processProperties.html');
	}
	function openFlowProperties(l){
		//alert(id);
		if(!is_open_properties_panel)
			_designer.layout('expand','east');
		line=l;
		_properties_panel_obj.panel('refresh','${ctx}/scripts/wfdesigner/wf/designer/flowProperties.html');
	}
	function deleteModel(id){
		var task = workflow.getFigure(id);
		workflow.removeFigure(task);
	}
	function redo(){
		workflow.getCommandStack().redo();
	}
	function undo(){
		workflow.getCommandStack().undo();
	}
	function saveProcessDef(){
		var processName = jq("#processName").val();
		if(processName == ""){
			jq.messager.prompt("名称","",function(val){
				if(val == ""){
					return;
				}else{
					processName = val;
					var xml = workflow.toXML();
					var data = {
							processDescriptor:xml,
							processName:processName,
							processVariables:workflow.process.getVariablesJSONObject()
						};
					saveFlow(data);
				}
			});
		}else{
			processName = processName.replace(".bpmn","");
			var xml = workflow.toXML();
			var data = {
					processDescriptor:xml,
					processName:processName,
					processVariables:workflow.process.getVariablesJSONObject()
				};
			saveFlow(data);
		}
		
		
	}
	function saveFlow(data){
		jq.ajax({
			url:"${ctx}/flow/process/update",
			type: 'POST',
			data:data,
			dataType:'json',
			error:function(){
				//$.messager.alert("<s:text name='label.common.error'></s:text>","<s:text name='message.common.save.failure'></s:text>","error");
				return "";
			},
			success:function(data){
				if(data.status){
					jq.messager.alert('信息','保存成功!','info');
				}else{
					jq.messager.alert('信息',data.msg,'error');
				}
			}	
		}); 
	}
	function exportProcessDef(obj){
		//obj.href="${ctx}/wf/procdef/procdef!exportProcessDef.action?procdefId="+processDefinitionId+"&processName="+processDefinitionName;
	}

</script>

<body id="designer" class="easyui-layout">
	<div region="west" split="true" iconCls="palette-icon" title="流程元素" style="width:150px;">
		<div class="easyui-accordion" fit="true" border="false">
<!--				<div id="connection" title="Connection" iconCls="palette-menu-icon" class="palette-menu">-->
<!--					<a href="##" class="easyui-linkbutton" plain="true" iconCls="sequence-flow-icon">SequenceFlow</a><br>-->
<!--				</div>-->
				<div id="event" title="事件" iconCls="palette-menu-icon" class="palette-menu">
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="start-event-icon">开始</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="end-event-icon">结束</a><br>
				</div>
				<div id="task" title="任务" iconCls="palette-menu-icon" selected="true" class="palette-menu">
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="user-task-icon" wfModel="UserTask">用户任务</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="manual-task-icon" wfModel="ManualTask">手动任务</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="service-task-icon" wfModel="ServiceTask">服务任务</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="script-task-icon" wfModel="ScriptTask">脚本任务</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="mail-task-icon" wfModel="MailTask">邮件任务</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="receive-task-icon" wfModel="ReceiveTask">接收任务</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="business-rule-task-icon" wfModel="BusinessRuleTask">业务规则</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="subprocess-icon">子流程</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="callactivity-icon" wfModel="CallActivity">CallActivity</a><br>
				</div>
				<div id="gateway" title="网关" iconCls="palette-menu-icon" class="palette-menu">
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="parallel-gateway-icon" wfModel="ParallelGateway" iconImg="${ctx}/scripts/wfdesigner/js/designer/icons/type.gateway.parallel.png">同步</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="exclusive-gateway-icon" wfModel="ExclusiveGateway" iconImg="${ctx}/scripts/wfdesigner/js/designer/icons/type.gateway.exclusive.png">分支</a><br>
				</div>
				<div id="boundary-event" title="边界事件" iconCls="palette-menu-icon" class="palette-menu">
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="timer-boundary-event-icon">时间边界</a><br>
					<a href="##" class="easyui-linkbutton" plain="true" iconCls="error-boundary-event-icon">错误边界</a><br>
				</div>
		</div>
	</div>
	<div id="process-panel" region="center" split="true"  iconCls="process-icon" title="流程">
				<div id="process-definition-tab">
							<div id="designer-area" title="流程" style="POSITION: absolute;width:100%;height:100%;padding: 0;border: none;overflow:auto;">
								<div id="paintarea" style="POSITION: absolute;WIDTH: 3000px; HEIGHT: 3000px" ></div>
							</div>
							<div id="xml-area" title="XML" style="width:100%;height:100%;overflow:hidden;overflow-x:hidden;overflow-y:hidden;">
								<!-- 
								<button onclick="parXml()">解析</button>
								 -->
								<textarea id="descriptorarea" rows="38" style="width: 100%;height:90%;padding-top: 20px;border: none;" >${xml}</textarea>
							</div>
				</div>
				
	</div>
	<div id="properties-panel" region="east" split="true" iconCls="properties-icon" title="属性" style="width:500px;">
		
	</div>
	<!-- toolbar -->
	<div id="toolbar-panel" region="north" border="false" style="height: 55px; background: #d8e4fe;" title="工具栏">
	   <input type="hidden" name="processId" id="processId" value="402880e74d94576e014d94603b370004">
	   &nbsp;&nbsp;
	   <img width="20" height="18" title="创建流程" src="${ctx}/scripts/wfdesigner/js/jquery-easyui/themes/icons/filesave.png" onclick="saveProcessDef()" class="buttonStyle" />
	   <img width="20" height="18" title="上一步" src="${ctx}/scripts/wfdesigner/js/jquery-easyui/themes/icons/undo.png" onclick="undo()" class="buttonStyle" />
	   <img width="20" height="18" title="下一步" src="${ctx}/scripts/wfdesigner/js/jquery-easyui/themes/icons/redo.png" onclick="redo()" class="buttonStyle" />
	   <img width="20" height="18" title="导出" src="${ctx}/scripts/wfdesigner/img/printer.png" onclick="exportProcessDef(this)" class="buttonStyle" />
	  </div>
	
	<!-- task context menu -->
	<div id="task-context-menu" class="easyui-menu" style="width:120px;">
		<div id="properties-task-context-menu" iconCls="properties-icon">属性</div>
		<div id="delete-task-context-menu" iconCls="icon-remove">删除</div>
	</div>
	<!-- form configuration window -->
	<div id="form-win" title="Form Configuration" style="width:750px;height:500px;">
	</div>
	<!-- listener configuration window -->
	<div id="listener-win" title="Listener Configuration" style="width:750px;height:500px;">
	</div>
	<!-- candidate configuration window -->
	<div id="task-candidate-win" title="" style="width:750px;height:500px;">
	</div>
	<input type="hidden" name="processName" id="processName" value="${deploy.resourceName }"/>
</body>
</html>
<script type="text/javascript">
	var workflow;
	//解析
	function parXml(){
		var xml = jq("#descriptorarea").val();
		if(xml != "" && workflow != null){
			workflow.parseXML(xml);
		}
	}
	jq('#process-definition-tab').tabs({
		fit:true,
		onSelect:function(title){
			if(title=='流程'){
				parXml();
			}else if(title=='XML'){
				jq('#descriptorarea').val(workflow.toXML());
				/*
				if(document.body.innerText)
					jq('#xml-area').get(0).innerText=workflow.toXML();
				else if(document.body.textContent)
					jq('#xml-area').get(0).textContent=workflow.toXML();
				*/
			}
		}
	});
	
	
	function createCanvas(disabled){
		try{
			//initCanvas();
			workflow  = new draw2d.MyCanvas("paintarea");
			workflow.scrollArea=document.getElementById("designer-area");
			if(disabled)
				workflow.setDisabled();
			if(typeof processDefinitionId != "undefined" && processDefinitionId != null &&  processDefinitionId != "null" && processDefinitionId != "" && processDefinitionId != "NULL"){
				workflow.webpath ="${ctx}/scripts/";
				parXml();
			}else{
					var id = "process"+Sequence.create();
					//var id = workflow.getId();
					workflow.process.category='demo_wf_process_def';
					workflow.process.id=id;
					workflow.process.name=id;
				// Add the start,end,connector to the canvas
				  var startObj = new draw2d.Start("${ctx}/scripts/wfdesigner/js/designer/icons/type.startevent.none.png");
				  //startObj.setId("start");
				  workflow.addFigure(startObj, 200,50);
				  
				  var endObj   = new draw2d.End("${ctx}/scripts/wfdesigner/js/designer/icons/type.endevent.none.png");
				  //endObj.setId("end");
				  workflow.addFigure(endObj,200,400);
			} 
		}catch(e){
			alert(e.message);
		}
	}
	
	createCanvas(false);
	

</script>