//前台显示流程使用
draw2d.MyCanvas=function(id){
		draw2d.Workflow.call(this,id);
		this.html.style.backgroundImage="";//remove default backgourd
		this.disabled=true;
		this.process=new draw2d.Process();
};
draw2d.MyCanvas.prototype = new draw2d.Workflow();
draw2d.MyCanvas.prototype.type = "MyCanvas";

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


//解析
draw2d.MyCanvas.prototype.showXml=function(data,taskId){
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
	var shapes = descriptor.find('bpmndi\\:BPMNShape'); //任务位置
	var edges = descriptor.find('bpmndi\\:BPMNEdge');//连线
	
	
	
	workflow.process.category=definitions.attr('targetNamespace');
	workflow.process.id=process.attr('id');
	workflow.process.name=process.attr('name');
	var documentation = trim(descriptor.find('process > documentation').text());
	if(documentation != null && documentation != "")
		workflow.process.documentation=documentation;
	
	
	startEvent.each(function(i){
		var start = new draw2d.Start(webpath+"wfdesigner/js/designer/icons/type.startevent.none.png");
		start.setCanDrag(false);
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
		var end = new draw2d.End(webpath+"wfdesigner/js/designer/icons/type.endevent.none.png");
		end.setCanDrag(false);
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
		if(tid == taskId){
			task.setTitleColor("red");
		}
		task.setCanDrag(false);
		
		var assignee=jq(this).attr('activiti:assignee');
		var candidataUsers=jq(this).attr('activiti:candidateUsers');
		var candidataGroups=jq(this).attr('activiti:candidateGroups');
		var formKey=jq(this).attr('activiti:formKey');
		
		var documentation = trim(jq(this).find('documentation').text());
		if(documentation != null && documentation != "")
			task.documentation=documentation;
		task.taskId=tid;
		task.taskName=tname;
		if(tid!= tname)
			task.setContent(tname);
		
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

