draw2d.MyCanvas=function(id){
		draw2d.Workflow.call(this,id);
		this.html.style.backgroundImage="";//remove default backgourd
		this.html.className="MyCanvas";
		this.disabled=false;
		//this.processCategory=null;
		//this.processId=null;
		//this.processName=null;
		this.process=new draw2d.Process();
		//this.listeners=new draw2d.ArrayList();
};
draw2d.MyCanvas.prototype = new draw2d.Workflow();
draw2d.MyCanvas.prototype.type = "MyCanvas";
/*
draw2d.MyCanvas.prototype.showConnectionLine=function(x1, y1, x2, y2){
	var connectionLine = new draw2d.DecoratedConnection();
	connectionLine.setStartPoint(x1, y1);
	connectionLine.setEndPoint(x2, y2);
	if (connectionLine.canvas === null) {
		draw2d.Canvas.prototype.addFigure.call(this, connectionLine);
	}
};
*/
draw2d.MyCanvas.prototype.setDisabled = function(){
	this.disabled = true;
	return this.readOnly;
};
draw2d.MyCanvas.prototype.addFigure = function(figure, xPos, yPos){
	var parent = this.getBestCompartmentFigure(xPos,yPos);
	if(parent === null){
		draw2d.Workflow.prototype.addFigure.call(this,figure, xPos, yPos);
	}else{
		this.getCommandStack().execute(new draw2d.CommandAdd(this,figure,xPos,yPos,parent));
	}
};
draw2d.MyCanvas.prototype.addModel = function(figure, xPos, yPos){
	var parent = this.getBestCompartmentFigure(xPos,yPos);
	this.getCommandStack().execute(new draw2d.CommandAdd(this,figure,xPos,yPos,parent));
};
draw2d.MyCanvas.prototype.getContextMenu=function(){
	if(this.readOnly)return null;
	var menu =new draw2d.ContextMenu(100, 50);
	var data = {workflow:this};
	menu.appendMenuItem(new draw2d.ContextMenuItem("Properties", "properties-icon",data,function(x,y)
	{
		var data = this.getData();
		var workflow = data.workflow;
		var pid = workflow.processId;
		openProcessProperties(pid);
	}));
	return menu;
	
};
/*
draw2d.MyCanvas.prototype.getListener=function(id){
	for(var i=0;i<this.listeners.getSize();i++){
		var listener = this.listeners.get(i);
		if(listener.getId()=== id){
			return listener;
		}
	}
};
draw2d.MyCanvas.prototype.deleteListener=function(id){
	var listener = this.getListener(id);
	this.listeners.remove(listener);
};
draw2d.MyCanvas.prototype.setListener=function(listenser){
	this.listeners.add(listener);
};
*/
draw2d.MyCanvas.prototype.onContextMenu=function(x,y){
	if(this.readOnly)return;
	var f = this.getBestFigure(x, y);
	if(f==null)
		f = this.getBestLine(x, y);
	if(f !=null){
		var menu = f.getContextMenu();
		if (menu !== null) {
			this.showMenu(menu, x, y);
		}
	}else{
		var menu = this.getContextMenu();
		if (menu !== null) {
			this.showMenu(menu, x, y);
		}
	}
};
draw2d.MyCanvas.prototype.getXMLHeader=function(){
	var xml='<?xml version="1.0" encoding="UTF-8"?>\n';
	return xml;
};
draw2d.MyCanvas.prototype.getDefinitionsStartXML=function(){
	var xml = '<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" '
		+'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
		+'xmlns:activiti="http://activiti.org/bpmn" '
		+'xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" '
		+'xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" '
		+'xmlns:omgdi="http://www.omg.org/spec/DD/20100524/DI" '
		+'typeLanguage="http://www.w3.org/2001/XMLSchema" '
		+'expressionLanguage="http://www.w3.org/1999/XPath" '
		+'targetNamespace="'+this.process.category+'">\n';
	return xml;
};
draw2d.MyCanvas.prototype.getDefinitionsEndXML=function(){
	var xml='</definitions>\n';
	return xml;
};

draw2d.MyCanvas.prototype.toXML=function(){
	var xml = this.getXMLHeader();
	xml = xml+this.getDefinitionsStartXML();
	xml=xml+'<process id="'+this.process.id+'" name="'+this.process.name+'">\n';
	xml=xml+this.process.getDocumentationXML();
	xml=xml+this.process.getExtensionElementsXML();
	var bpmnDigramXml='<bpmndi:BPMNDiagram id="BPMNDiagram_'+this.process.id+'">\n'
	bpmnDigramXml=bpmnDigramXml+'<bpmndi:BPMNPlane bpmnElement="'+this.process.id+'" id="BPMNPlane_'+this.process.id+'">\n'
	var models = this.getFigures();
	for(var i=0;i<models.getSize();i++){
		var model=models.get(i);
		for(var j=0;j<DefaultModelTypeEnum.length;j++){
			if(DefaultModelTypeEnum[j]==model.type){
				//alert(model.type);
				xml=xml+model.toXML();
				bpmnDigramXml=bpmnDigramXml+model.toBpmnDI();
				break;
			}
		}
	}
	var lines = this.getLines();
	for(var i=0;i<lines.getSize();i++){
		var line = lines.get(i);
		for(var j=0;j<DefaultModelTypeEnum.length;j++){
			if(DefaultModelTypeEnum[j]==line.type){
				//alert(line.type);
				xml=xml+line.toXML();
				bpmnDigramXml=bpmnDigramXml+line.toBpmnDI();
				break;
			}
		}
	}
	xml=xml+'</process>\n';
	bpmnDigramXml=bpmnDigramXml+'</bpmndi:BPMNPlane>\n'
	bpmnDigramXml=bpmnDigramXml+'</bpmndi:BPMNDiagram>\n';
	xml=xml+bpmnDigramXml;
	xml=xml+this.getDefinitionsEndXML();
	xml=formatXml(xml);
	return xml;
};
draw2d.MyCanvas.prototype.parseXMLbak=function(data){
	var BPMNShape = (jq.browser.webkit) ? 'BPMNShape' : 'bpmndi\\:BPMNShape';
	var BPMNEdge = (jq.browser.webkit) ? 'BPMNEdge' : 'bpmndi\\:BPMNEdge';
	var executionListener = (jq.browser.webkit) ? 'activiti\\:executionListener' : 'executionListener';
	var Bounds = (jq.browser.webkit) ? 'Bounds' : 'omgdc\\:Bounds';
	var waypoint = (jq.browser.webkit) ? 'waypoint' : 'omgdi\\:waypoint';
	var taskListener = (jq.browser.webkit) ? 'taskListener' : 'activiti\\:taskListener';
	var formProperty = (jq.browser.webkit) ? 'formProperty' : 'activiti\\:formProperty';
	var field = (jq.browser.webkit) ? 'activiti\\:field' : 'field';
	var expression = (jq.browser.webkit) ? 'expression' : 'activiti\\:expression';
	var intag = (jq.browser.webkit) ? 'in' : 'activiti\\:in';
	var outtag = (jq.browser.webkit) ? 'out' : 'activiti\\:out';
	var descriptor = jq(data);
	var definitions = descriptor.find('definitions');
	var process = descriptor.find('process');
	var startEvent = descriptor.find('startEvent');
	var endEvent = descriptor.find('endEvent');
	var manualTasks = descriptor.find('manualTask');
	var userTasks = descriptor.find('userTask');
	var serviceTasks = descriptor.find('serviceTask');
	var scriptTasks = descriptor.find('scriptTask');
	var receiveTasks = descriptor.find('receiveTask');
	var exclusiveGateway = descriptor.find('exclusiveGateway');
	var parallelGateway = descriptor.find('parallelGateway');
	var timerBoundary = descriptor.find('boundaryEvent');
	var callActivitys = descriptor.find('callActivity');
	var businessRuleTasks = descriptor.find('businessRuleTask');
	var lines = descriptor.find('sequenceFlow');

	var shapes = descriptor.find(BPMNShape);
	var edges = descriptor.find(BPMNEdge);
	workflow.process.category = definitions.attr('targetNamespace');
	workflow.process.id = process.attr('id');
	workflow.process.name = process.attr('name');
	var documentation = trim(descriptor.find('process > documentation').text());
	if (documentation != null && documentation != "")
		workflow.process.documentation = documentation;
	var extentsion = descriptor.find('process > extensionElements');
	if (extentsion != null) {
		var listeners = extentsion.find('activiti\\:executionListener');
		workflow.process.setListeners(parseListeners(listeners, "draw2d.Process.Listener", "draw2d.Process.Listener.Field"));
	}
	jq.each(processDefinitionVariables, function(i, n) {
		var variable = new draw2d.Process.variable();
		variable.name = n.name;
		variable.type = n.type;
		variable.scope = n.scope;
		variable.defaultValue = n.defaultValue;
		variable.remark = n.remark;
		workflow.process.addVariable(variable);
	});
	startEvent.each(function(i) {
		var start = new draw2d.Start();
		start.id = jq(this).attr('id');
		start.eventId = jq(this).attr('id');
		start.eventName = jq(this).attr('name');
		var expression = jq(this).attr('activiti:initiator');
		if (expression == null || expression == 'null') {
			expression = "";
		}
		start.expression = expression;
		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == start.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				start.setDimension(w, h);
				workflow.addFigure(start, x, y);
				return false;
			}
		});
	});
	endEvent.each(function(i) {
		var end = new draw2d.End();
		end.id = jq(this).attr('id');
		end.eventId = jq(this).attr('id');
		end.eventName = jq(this).attr('name');
		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == end.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				end.setDimension(w, h);
				workflow.addFigure(end, x, y);
				return false;
			}
		});
	});
	userTasks.each(function(i) {
		var task = new draw2d.UserTask();
		var tid = jq(this).attr('id');
		task.id = tid;
		var tname = jq(this).attr('name');
		var assignee = jq(this).attr('activiti:assignee');
		var candidataUsers = jq(this).attr('activiti:candidateUsers');
		var candidataGroups = jq(this).attr('activiti:candidateGroups');
		var formKey = jq(this).attr('activiti:formKey');
		if (assignee != null && assignee != "") {
			task.isUseExpression = true;
			task.performerType = "assignee";
			task.expression = assignee;
		} else if (candidataUsers != null && candidataUsers != "") {
			task.isUseExpression = true;
			task.performerType = "candidateUsers";
			task.expression = candidataUsers;
		} else if (candidataGroups != null && candidataGroups != "") {
			task.isUseExpression = true;
			task.performerType = "candidateGroups";
			task.expression = candidataGroups;
		}
		if (formKey != null && formKey != "") {
			task.formKey = formKey;
		}
		var documentation = trim(jq(this).find('documentation').text());
		if (documentation != null && documentation != "")
			task.documentation = documentation;
		task.taskId = tid;
		task.taskName = tname;
		//if (tid != tname)
		task.setContent(tname);
		var listeners = jq(this).find('extensionElements').find(taskListener);

		task.setListeners(parseListeners(listeners, "draw2d.Task.Listener", "draw2d.Task.Listener.Field"));
		var forms = jq(this).find('extensionElements').find('activiti\\:formProperty');
		//task.setForms(parseForms(forms, "draw2d.Task.Form"));
		var performersExpression = jq(this).find('potentialOwner').find('resourceAssignmentExpression').find('formalExpression').text();
		if (performersExpression.indexOf('user(') != -1) {
			task.performerType = "candidateUsers";
		} else if (performersExpression.indexOf('group(') != -1) {
			task.performerType = "candidateGroups";
		}
		var performers = performersExpression.split(',');
		jq.each(performers, function(i, n) {
			var start = 0;
			var end = n.lastIndexOf(')');
			if (n.indexOf('user(') != -1) {
				start = 'user('.length;
				var performer = n.substring(start, end);
				task.addCandidateUser({
					sso : performer
				});
			} else if (n.indexOf('group(') != -1) {
				start = 'group('.length;
				var performer = n.substring(start, end);
				task.addCandidateGroup(performer);
			}
		});
		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == task.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				task.setDimension(w, h);
				workflow.addModel(task, x, y);
				return false;
			}
		});
	});

	manualTasks.each(function(i) {
		var task = new draw2d.ManualTask();
		var tid = jq(this).attr('id');
		task.id = tid;
		var tname = jq(this).attr('name');
		var assignee = jq(this).attr('activiti:assignee');
		var candidataUsers = jq(this).attr('activiti:candidateUsers');
		var candidataGroups = jq(this).attr('activiti:candidateGroups');
		var formKey = jq(this).attr('activiti:formKey');
		if (assignee != null && assignee != "") {
			task.isUseExpression = true;
			task.performerType = "assignee";
			task.expression = assignee;
		} else if (candidataUsers != null && candidataUsers != "") {
			task.isUseExpression = true;
			task.performerType = "candidateUsers";
			task.expression = candidataUsers;
		} else if (candidataGroups != null && candidataGroups != "") {
			task.isUseExpression = true;
			task.performerType = "candidateGroups";
			task.expression = candidataGroups;
		}
		if (formKey != null && formKey != "") {
			task.formKey = formKey;
		}
		var documentation = trim(jq(this).find('documentation').text());
		if (documentation != null && documentation != "")
			task.documentation = documentation;
		task.taskId = tid;
		task.taskName = tname;
		//if (tid != tname)
		task.setContent(tname);
		var listeners = jq(this).find('extensionElements').find('activiti\\:taskListener');
		task.setListeners(parseListeners(listeners, "draw2d.Task.Listener", "draw2d.Task.Listener.Field"));
		var performersExpression = jq(this).find('potentialOwner').find('resourceAssignmentExpression').find('formalExpression').text();
		if (performersExpression.indexOf('user(') != -1) {
			task.performerType = "candidateUsers";
		} else if (performersExpression.indexOf('group(') != -1) {
			task.performerType = "candidateGroups";
		}
		var performers = performersExpression.split(',');
		jq.each(performers, function(i, n) {
			var start = 0;
			var end = n.lastIndexOf(')');
			if (n.indexOf('user(') != -1) {
				start = 'user('.length;
				var performer = n.substring(start, end);
				task.addCandidateUser({
					sso : performer
				});
			} else if (n.indexOf('group(') != -1) {
				start = 'group('.length;
				var performer = n.substring(start, end);
				task.addCandidateGroup(performer);
			}
		});
		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == task.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				task.setDimension(w, h);
				workflow.addModel(task, x, y);
				return false;
			}
		});
	});

	serviceTasks.each(function(i) {
		var flag = jq(this).attr('activiti:type');
		if (flag == 'mail') {
			var task = new draw2d.MailTask();
			var tid = jq(this).attr('id');
			task.id = tid;
			var elements = jq(this).find('activiti\\:field');
			elements.each(function(i) {
				if (jq(this).attr('name') == 'to') {
					task.toEmail = jq(this).attr('expression');
				}
				if (jq(this).attr('name') == 'from') {
					task.fromEmail = jq(this).attr('expression');
				}
				if (jq(this).attr('name') == 'subject') {
					task.subjectEmail = jq(this).attr('expression');
				}
				if (jq(this).attr('name') == 'cc') {
					task.ccEmail = jq(this).attr('expression');
				}
				if (jq(this).attr('name') == 'bcc') {
					task.bccEmail = jq(this).attr('expression');
				}
				if (jq(this).attr('name') == 'charset') {
					task.charsetEmail = jq(this).attr('expression');
				}
				if (jq(this).attr('name') == 'html') {
					task.htmlEmail = trim(jq(this).find('activiti\\:expression').text());
				}
				if (jq(this).attr('name') == 'text') {
					task.textEmail = trim(jq(this).find('activiti\\:expression').text());
				}

			});

			task.taskId = tid;

			shapes.each(function(i) {
				var id = jq(this).attr('bpmnElement');
				if (id == task.id) {
					var x = parseInt(jq(this).find(Bounds).attr('x'));
					var y = parseInt(jq(this).find(Bounds).attr('y'));
					workflow.addModel(task, x, y);
					return false;
				}
			});
		} else {
			var task = new draw2d.ServiceTask();
			var tid = jq(this).attr('id');
			task.id = tid;
			var tname = jq(this).attr('name');
			var assignee = jq(this).attr('activiti:assignee');
			var candidataUsers = jq(this).attr('activiti:candidateUsers');
			var candidataGroups = jq(this).attr('activiti:candidateGroups');
			var formKey = jq(this).attr('activiti:formKey');
			if (assignee != null && assignee != "") {
				task.isUseExpression = true;
				task.performerType = "assignee";
				task.expression = assignee;
			} else if (candidataUsers != null && candidataUsers != "") {
				task.isUseExpression = true;
				task.performerType = "candidateUsers";
				task.expression = candidataUsers;
			} else if (candidataGroups != null && candidataGroups != "") {
				task.isUseExpression = true;
				task.performerType = "candidateGroups";
				task.expression = candidataGroups;
			}
			if (formKey != null && formKey != "") {
				task.formKey = formKey;
			}
			var documentation = trim(jq(this).find('documentation').text());
			if (documentation != null && documentation != "")
				task.documentation = documentation;
			task.taskId = tid;
			task.taskName = tname;
			//if (tid != tname)
			task.setContent(tname);
			var listeners = jq(this).find('extensionElements').find('activiti\\:taskListener');
			task.setListeners(parseListeners(listeners, "draw2d.Task.Listener", "draw2d.Task.Listener.Field"));
			var performersExpression = jq(this).find('potentialOwner').find('resourceAssignmentExpression').find('formalExpression').text();
			if (performersExpression.indexOf('user(') != -1) {
				task.performerType = "candidateUsers";
			} else if (performersExpression.indexOf('group(') != -1) {
				task.performerType = "candidateGroups";
			}
			var performers = performersExpression.split(',');
			jq.each(performers, function(i, n) {
				var start = 0;
				var end = n.lastIndexOf(')');
				if (n.indexOf('user(') != -1) {
					start = 'user('.length;
					var performer = n.substring(start, end);
					task.addCandidateUser({
						sso : performer
					});
				} else if (n.indexOf('group(') != -1) {
					start = 'group('.length;
					var performer = n.substring(start, end);
					task.addCandidateGroup(performer);
				}
			});
			shapes.each(function(i) {
				var id = jq(this).attr('bpmnElement');
				if (id == task.id) {
					var x = parseInt(jq(this).find(Bounds).attr('x'));
					var y = parseInt(jq(this).find(Bounds).attr('y'));
					var w = parseInt(jq(this).find(Bounds).attr('width'));
					var h = parseInt(jq(this).find(Bounds).attr('height'));
					task.setDimension(w, h);
					workflow.addModel(task, x, y);
					return false;
				}
			});
		}

	});

	scriptTasks.each(function(i) {
		var task = new draw2d.ScriptTask();
		var tid = jq(this).attr('id');
		task.id = tid;
		var tname = jq(this).attr('name');
		var scriptFormat = jq(this).attr('scriptFormat');
		var resultVariable = jq(this).attr('activiti:resultVariable');
		task.scriptFormat = scriptFormat;
		task.resultVariable = resultVariable;
		var documentation = trim(jq(this).find('documentation').text());
		if (documentation != null && documentation != "")
			task.documentation = documentation;
		var script = trim(jq(this).find('script').text());
		if (script != null && script != "")
			task.expression = script;
		task.taskId = tid;
		task.taskName = tname;
		//if (tid != tname)
		task.setContent(tname);

		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == task.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				task.setDimension(w, h);
				workflow.addModel(task, x, y);
				return false;
			}
		});
	});

	receiveTasks.each(function(i) {
		var task = new draw2d.ReceiveTask();
		var tid = jq(this).attr('id');
		task.id = tid;
		var tname = jq(this).attr('name');
		task.taskId = tid;
		task.taskName = tname;
		//if (tid != tname)
		task.setContent(tname);

		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == task.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				task.setDimension(w, h);
				workflow.addModel(task, x, y);
				return false;
			}
		});
	});

	exclusiveGateway.each(function(i) {
		var gateway = new draw2d.ExclusiveGateway();
		var gtwid = jq(this).attr('id');
		var gtwname = jq(this).attr('name');
		gateway.id = gtwid;
		gateway.gatewayId = gtwid;
		gateway.gatewayName = gtwname;
		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == gateway.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				gateway.setDimension(w, h);
				workflow.addModel(gateway, x, y);
				return false;
			}
		});
	});
	parallelGateway.each(function(i) {
		var gateway = new draw2d.ParallelGateway();
		var gtwid = jq(this).attr('id');
		var gtwname = jq(this).attr('name');
		gateway.id = gtwid;
		gateway.gatewayId = gtwid;
		gateway.gatewayName = gtwname;
		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == gateway.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				gateway.setDimension(w, h);
				workflow.addModel(gateway, x, y);
				return false;
			}
		});
	});

	timerBoundary.each(function(i) {

		if (jq(this).find('timeDate').text() != '') {
			var timeBoundaryevent = new draw2d.TimerBoundary("plug-in/designer/icons/timer.png");
			var boundaryId = jq(this).attr('id');
			var cancelActivity = jq(this).attr('cancelActivity');
			var attachedToRef = jq(this).attr('attachedToRef');
			timeBoundaryevent.id = boundaryId;
			timeBoundaryevent.boundaryId = boundaryId;
			timeBoundaryevent.cancelActivity = cancelActivity;
			timeBoundaryevent.attached = attachedToRef;
			timeBoundaryevent.timeType = 'timeDate';
			timeBoundaryevent.expression = jq(this).find('timeDate').text();
		} else if (jq(this).find('timeDuration').text() != '') {
			var timeBoundaryevent = new draw2d.TimerBoundary("plug-in/designer/icons/timer.png");
			var boundaryId = jq(this).attr('id');
			var cancelActivity = jq(this).attr('cancelActivity');
			var attachedToRef = jq(this).attr('attachedToRef');
			timeBoundaryevent.id = boundaryId;
			timeBoundaryevent.boundaryId = boundaryId;
			timeBoundaryevent.cancelActivity = cancelActivity;
			timeBoundaryevent.attached = attachedToRef;
			timeBoundaryevent.timeType = 'timeDuration';
			timeBoundaryevent.expression = jq(this).find('timeDuration').text();
		} else if (jq(this).find('timeCycle').text() != '') {
			var timeBoundaryevent = new draw2d.TimerBoundary("plug-in/designer/icons/timer.png");
			var boundaryId = jq(this).attr('id');
			var cancelActivity = jq(this).attr('cancelActivity');
			var attachedToRef = jq(this).attr('attachedToRef');
			timeBoundaryevent.id = boundaryId;
			timeBoundaryevent.boundaryId = boundaryId;
			timeBoundaryevent.cancelActivity = cancelActivity;
			timeBoundaryevent.attached = attachedToRef;
			timeBoundaryevent.timeType = 'timeCycle';
			timeBoundaryevent.expression = jq(this).find('timeCycle').text();
		} else {
			var timeBoundaryevent = new draw2d.ErrorBoundary("plug-in/designer/icons/error.png");
			var boundaryId = jq(this).attr('id');
			var attachedToRef = jq(this).attr('attachedToRef');
			timeBoundaryevent.id = boundaryId;
			timeBoundaryevent.boundaryId = boundaryId;
			timeBoundaryevent.attached = attachedToRef;
			timeBoundaryevent.expression = jq(this).find('errorEventDefinition').attr('errorRef');
		}
		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == timeBoundaryevent.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				timeBoundaryevent.setDimension(w, h);
				workflow.addModel(timeBoundaryevent, x, y);
				return false;
			}
		});
	});

	callActivitys.each(function(i) {
		var task = new draw2d.CallActivity();
		var tid = jq(this).attr('id');
		task.id=tid;
		task.taskId=tid;
		task.taskName=jq(this).attr('name');
		task.callElement = jq(this).attr('calledElement');
		var paramsins = jq(this).find("activiti\\:in");
		var paramsouts = jq(this).find("activiti\\:out");
		paramsins.each(function(x){
			var o = new Object();
			o.id = jq(this).attr("id");
			o.source = jq(this).attr("source");
			o.target = jq(this).attr("target");
			task.inputParams.add(o);
		});
		paramsouts.each(function(x){
			var o = new Object();
			o.id = jq(this).attr("id");
			o.source = jq(this).attr("source");
			o.target = jq(this).attr("target");
			task.outputParams.add(o);
		});
		shapes.each(function(i){
			var id = jq(this).attr('bpmnElement');
			if(id==task.id){
				var x=parseInt(jq(this).find('omgdc\\:Bounds').attr('x'));
				var y=parseInt(jq(this).find('omgdc\\:Bounds').attr('y'));
				workflow.addModel(task,x,y);
				return false;
			}
		});
	});

	businessRuleTasks.each(function(i) {
		var task = new draw2d.BusinessRuleTask();
		var tid = jq(this).attr('id');
		var valueInput = jq(this).attr('activiti:ruleVariablesInput');
		var valueOutput = jq(this).attr('activiti:resultVariables');
		var rules = jq(this).attr('activiti:rules');
		var exclude = jq(this).attr('exclude');
		if (rules != null && rules != '') {
			task.rules = rules;
			if (exclude != null && exclude != '') {
				task.isclude = 'exclude';
			} else {
				task.isclude = 'include';
			}
		} else {
			task.isclude = '';
		}
		task.id = tid;
		task.taskId = tid;
		task.rulesInput = valueInput;
		task.rulesOutputs = valueOutput;
		shapes.each(function(i) {
			var id = jq(this).attr('bpmnElement');
			if (id == task.id) {
				var x = parseInt(jq(this).find(Bounds).attr('x'));
				var y = parseInt(jq(this).find(Bounds).attr('y'));
				var w = parseInt(jq(this).find(Bounds).attr('width'));
				var h = parseInt(jq(this).find(Bounds).attr('height'));
				task.setDimension(w, h);
				workflow.addModel(task, x, y);
				return false;
			}
		});
	});

	lines.each(function(i) {
		var lid = jq(this).attr('id');
		var name = jq(this).attr('name');
		var condition = jq(this).find('conditionExpression').text();
		var sourceRef = jq(this).attr('sourceRef');
		var targetRef = jq(this).attr('targetRef');
		var source = workflow.getFigure(sourceRef);
		var target = workflow.getFigure(targetRef);
		edges.each(function(i) {
			var eid = jq(this).attr('bpmnElement');
			if (eid == lid) {
				var startPort = null;
				var endPort = null;
				var points = jq(this).find(waypoint);
				var len = points.length;
				var startX = jq(points[0]).attr('x');
				var startY = jq(points[0]).attr('y');
				var endX = jq(points[len - 1]).attr('x');
				var endY = jq(points[len - 1]).attr('y');
				var sports = source.getPorts();
				for ( var i = 0; i < sports.getSize(); i++) {
					var s = sports.get(i);
					var x = parseInt(s.getAbsoluteX());
					var y = parseInt(s.getAbsoluteY());

					if (x == startX && y == startY) {
						startPort = s;
						break;
					}
				}

				var tports = target.getPorts();

				for ( var i = 0; i < tports.getSize(); i++) {
					var t = tports.get(i);
					var x = parseInt(t.getAbsoluteX());
					var y = parseInt(t.getAbsoluteY());
					if (x == endX && y == endY) {
						endPort = t;

						break;
					}
				}
				if (startPort != null && endPort != null) {

					var cmd = new draw2d.CommandConnect(workflow, startPort, endPort);
					var connection = new draw2d.DecoratedConnection();

					connection.id = lid;
					connection.lineId = lid;
					connection.lineName = name;
					connection.setLabel(name);
					if (condition != null && condition != "") {
						connection.condition = condition;
					}
					cmd.setConnection(connection);
					workflow.getCommandStack().execute(cmd);
				}
				return false;
			}
		});
	});
	if (typeof setHightlight != "undefined") {
		setHightlight();
	}
};

//解析
draw2d.MyCanvas.prototype.parseXML=function(data){
	if(data == ""){
		return;
	}
	workflow.clear();
	var descriptor = jq(data);
	var definitions = descriptor.find('definitions');
	var process = descriptor.find('process');
	var startEvent = descriptor.find('startEvent');
	var endEvent = descriptor.find('endEvent');
	var userTasks = descriptor.find('userTask');
	var callActivitys = descriptor.find('callActivity');
	var exclusiveGateway = descriptor.find('exclusiveGateway');
	var parallelGateway = descriptor.find('parallelGateway');
	var lines = descriptor.find('sequenceFlow');
	var shapes = descriptor.find('bpmndi\\:BPMNShape');
	var edges = descriptor.find('bpmndi\\:BPMNEdge');
	
	workflow.process.category=definitions.attr('targetNamespace');
	workflow.process.id=process.attr('id');
	workflow.process.name=process.attr('name');
	var documentation = trim(descriptor.find('process > documentation').text());
	if(documentation != null && documentation != "")
		workflow.process.documentation=documentation;
	var extentsion = descriptor.find('process > extensionElements');
	if(extentsion != null){
		var listeners = extentsion.find('activiti\\:executionListener');
		var taskListeners = extentsion.find('activiti\\:taskListener');
		workflow.process.setListeners(parseListeners(listeners,"draw2d.Process.Listener","draw2d.Process.Listener.Field"));
	}
	jq.each(processDefinitionVariables,function(i,n){
			var variable = new draw2d.Process.variable();
			variable.name=n.name;
			variable.type=n.type;
			variable.scope=n.scope;
			variable.defaultValue=n.defaultValue;
			variable.remark=n.remark;
			workflow.process.addVariable(variable);
		});
	startEvent.each(function(i){
			var start = new draw2d.Start(workflow.webpath+"wfdesigner/js/designer/icons/type.startevent.none.png");
			start.id=jq(this).attr('id');
			start.eventId=jq(this).attr('id');
			start.eventName=jq(this).attr('name');
			shapes.each(function(i){
				var id = jq(this).attr('bpmnElement');
				if(id==start.id){
					var x=parseInt(jq(this).find('omgdc\\:Bounds').attr('x'));
					var y=parseInt(jq(this).find('omgdc\\:Bounds').attr('y'));
					workflow.addFigure(start,x,y);
					return false;
				}
			});
		});
	endEvent.each(function(i){
			var end = new draw2d.End(workflow.webpath+"wfdesigner/js/designer/icons/type.endevent.none.png");
			end.id=jq(this).attr('id');
			end.eventId=jq(this).attr('id');
			end.eventName=jq(this).attr('name');
			shapes.each(function(i){
				var id = jq(this).attr('bpmnElement');
				if(id==end.id){
					var x=parseInt(jq(this).find('omgdc\\:Bounds').attr('x'));
					var y=parseInt(jq(this).find('omgdc\\:Bounds').attr('y'));
					workflow.addFigure(end,x,y);
					return false;
				}
			});
		});
	
	userTasks.each(function(i){
			var task = new draw2d.UserTask();
			var tid = jq(this).attr('id');
			task.id=tid;
			var tname = jq(this).attr('name');
			var assignee=jq(this).attr('activiti:assignee');
			var candidataUsers=jq(this).attr('activiti:candidateUsers');
			var candidataGroups=jq(this).attr('activiti:candidateGroups');
			var formKey=jq(this).attr('activiti:formKey');
			if(assignee!=null&&assignee!=""){
				task.isUseExpression=true;
				task.performerType="assignee";
				task.expression=assignee;
			}else if(candidataUsers!=null&&candidataUsers!=""){
				task.isUseExpression=true;
				task.performerType="candidateUsers";
				task.expression=candidataUsers;
			}else if(candidataGroups!=null&&candidataGroups!=""){
				task.isUseExpression=true;
				task.performerType="candidateGroups";
				task.expression=candidataGroups;
			}
			if(formKey!=null&&formKey!=""){
				task.formKey=formKey;
			}
			var documentation = trim(jq(this).find('documentation').text());
			if(documentation != null && documentation != "")
				task.documentation=documentation;
			task.taskId=tid;
			task.taskName=tname;
			if(tid!= tname)
				task.setContent(tname);
			var listeners = jq(this).find('extensionElements').find('activiti\\:taskListener');
			task.setListeners(parseListeners(listeners,"draw2d.Task.Listener","draw2d.Task.Listener.Field"));
			var performersExpression = jq(this).find('potentialOwner').find('resourceAssignmentExpression').find('formalExpression').text();
			if(performersExpression.indexOf('user(')!=-1){
				task.performerType="candidateUsers";
			}else if(performersExpression.indexOf('group(')!=-1){
				task.performerType="candidateGroups";
			}
			var performers = performersExpression.split(',');
			jq.each(performers,function(i,n){
				var start = 0;
				var end = n.lastIndexOf(')');
				if(n.indexOf('user(')!=-1){
					start = 'user('.length;
					var performer = n.substring(start,end);
					task.addCandidateUser({
							sso:performer
					});
				}else if(n.indexOf('group(')!=-1){
					start = 'group('.length;
					var performer = n.substring(start,end);
					task.addCandidateGroup(performer);
				}
			});
			shapes.each(function(i){
				var id = jq(this).attr('bpmnElement');
				if(id==task.id){
					var x=parseInt(jq(this).find('omgdc\\:Bounds').attr('x'));
					var y=parseInt(jq(this).find('omgdc\\:Bounds').attr('y'));
					workflow.addModel(task,x,y);
					return false;
				}
			});
		});
	callActivitys.each(function(i){
		var task = new draw2d.CallActivity();
		var tid = jq(this).attr('id');
		task.id=tid;
		task.taskId=tid;
		task.taskName=jq(this).attr('name');
		task.callElement = jq(this).attr('calledElement');
		var paramsins = jq(this).find("activiti\\:in");
		var paramsouts = jq(this).find("activiti\\:out");
		paramsins.each(function(x){
			var o = new Object();
			o.id = jq(this).attr("id");
			o.source = jq(this).attr("source");
			o.target = jq(this).attr("target");
			task.inputParams.add(o);
		});
		paramsouts.each(function(x){
			var o = new Object();
			o.id = jq(this).attr("id");
			o.source = jq(this).attr("source");
			o.target = jq(this).attr("target");
			task.outputParams.add(o);
		});
		shapes.each(function(i){
			var id = jq(this).attr('bpmnElement');
			if(id==task.id){
				var x=parseInt(jq(this).find('omgdc\\:Bounds').attr('x'));
				var y=parseInt(jq(this).find('omgdc\\:Bounds').attr('y'));
				workflow.addModel(task,x,y);
				return false;
			}
		});
	});
	exclusiveGateway.each(function(i){
			var gateway = new draw2d.ExclusiveGateway();
			var gtwid = jq(this).attr('id');
			var gtwname = jq(this).attr('name');
			gateway.id=gtwid;
			gateway.gatewayId=gtwid;
			gateway.gatewayName=gtwname;
			shapes.each(function(i){
				var id = jq(this).attr('bpmnElement');
				if(id==gateway.id){
					var x=parseInt(jq(this).find('omgdc\\:Bounds').attr('x'));
					var y=parseInt(jq(this).find('omgdc\\:Bounds').attr('y'));
					workflow.addModel(gateway,x,y);
					return false;
				}
			});
		});
	parallelGateway.each(function(i){
		var gateway = new draw2d.ExclusiveGateway();
		var gtwid = jq(this).attr('id');
		var gtwname = jq(this).attr('name');
		gateway.id=gtwid;
		gateway.gatewayId=gtwid;
		gateway.gatewayName=gtwname;
		shapes.each(function(i){
			var id = jq(this).attr('bpmnElement');
			if(id==gateway.id){
				var x=parseInt(jq(this).find('omgdc\\:Bounds').attr('x'));
				var y=parseInt(jq(this).find('omgdc\\:Bounds').attr('y'));
				workflow.addModel(gateway,x,y);
				return false;
			}
		});
	});
	lines.each(function(i){
			var lid = jq(this).attr('id');
			var name = jq(this).attr('name');
			var condition=jq(this).find('conditionExpression').text();
			var sourceRef = jq(this).attr('sourceRef');
			var targetRef = jq(this).attr('targetRef');
			var source = workflow.getFigure(sourceRef);
			var target = workflow.getFigure(targetRef);
			edges.each(function(i){
					var eid = jq(this).attr('bpmnElement');
					if(eid==lid){
						var startPort = null;
						var endPort = null;
						var points = jq(this).find('omgdi\\:waypoint');
						var startX = jq(points[0]).attr('x');
						var startY = jq(points[0]).attr('y');
						var endX = jq(points[1]).attr('x');
						var endY = jq(points[1]).attr('y');
						//var sports = source.getPorts();
						//if(source != null){
							var sports = source.ports;
							//for(var i=0;i<sports.getSize();i++){
							for(var i=0;i<sports.size;i++){
								var s = sports.get(i);
								var x = s.getAbsoluteX();
								var y = s.getAbsoluteY();
								//if(x == startX&&y==startY){
								if(Math.abs(x-startX)<=10&&Math.abs(y-startY)<=10){	
									startPort = s;
									break;
								}
							}
						//}
						
						var tports = target.ports;
						for(var i=0;i<tports.size;i++){
							var t = tports.get(i);
							var x = t.getAbsoluteX();
							var y = t.getAbsoluteY();
							//if(x==endX&&y==endY){
							if(Math.abs(x-endX)<=10&&Math.abs(y-endY)<=20){
								endPort = t;
								break;
							}
						}
						if(startPort != null&&endPort!=null){
							var cmd=new draw2d.CommandConnect(workflow,startPort,endPort);
							var connection = new draw2d.DecoratedConnection();
							connection.id=lid;
							connection.lineId=lid;
							connection.lineName=name;
							if(lid!=name)
								connection.setLabel(name);
							if(condition != null && condition!=""){
								connection.condition=condition;
							}
							cmd.setConnection(connection);
							workflow.getCommandStack().execute(cmd);
						}
						return false;
					}
				});
		});
	if(typeof setHightlight != "undefined"){
		setHightlight();
	}
};
//解析监听器
function parseListeners(listeners,listenerType,fieldType){
	var parsedListeners = new draw2d.ArrayList();
	listeners.each(function(i){
		var listener = eval("new "+listenerType+"()");
		
		listener.event=jq(this).attr('event');
		var expression = jq(this).attr('expression');
		var clazz = jq(this).attr('class');
		if(expression != null && expression!=""){
			listener.serviceType='expression';
			listener.serviceExpression=expression;
		}else if(clazz != null&& clazz!=""){
			listener.serviceType='javaClass';
			listener.serviceExpression=clazz;
		}
		var fields = jq(this).find('activiti\\:field');
		fields.each(function(i){
			var field = eval("new "+fieldType+"()");
			field.name=jq(this).attr('name');
			//alert(field.name);
			var string = jq(this).find('activiti\\:string').text();
			var expression = jq(this).find('activiti\\:expression').text();
			//alert("String="+string.text()+"|"+"expression="+expression.text());
			if(string != null && string != ""){
				field.type='string';
				field.value=string;
			}else if(expression != null && expression!= ""){
				field.type='expression';
				field.value=expression;
			}
			listener.setField(field);
		});
		parsedListeners.add(listener);
	});
	return parsedListeners;
}

function parseForms(forms, formType) {
	var parsedForms = new draw2d.ArrayList();
	forms.each(function(i) {
		var form = eval("new " + formType + "()");
		form.id = $(this).attr('id');
		var name = $(this).attr('name');
		form.name = name;
		var type = $(this).attr('type');
		form.type = type;
		var value = $(this).attr('value');
		form.value = value;
		var exp = $(this).attr('exp');
		form.exp = exp;
		var remark = $(this).attr('remark');
		form.remark = remark;
		parsedForms.add(form);
	});
	return parsedForms;
}
