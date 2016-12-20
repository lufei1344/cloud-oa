
TaskOperation = function(conf) {
	if (!conf) {
		conf = {
			formId: 'xform',
			toolbarId: 'xformToolbar'
		};
	}

	this.formId = conf.formId;
	this.toolbarId = conf.toolbarId;
};

TaskOperation.prototype.saveDraft = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/process-operation-saveDraft.do');
	$('#' + this.formId).submit();
};

TaskOperation.prototype.startProcess = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/process-operation-startProcess.do');
	$('#' + this.formId).submit();
};

TaskOperation.prototype.taskConf = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/process-operation-taskConf.do');
	$('#' + this.formId).submit();
};

TaskOperation.prototype.confirmStartProcess = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/process-operation-confirmStartProcess.do');
	$('#' + this.formId).submit();
};

//提交任务
TaskOperation.prototype.completeTask = function() {
	var url = ROOT_URL+"/web/next.jsp?taskId="+(params.taskId ?  params.taskId : "")+"&executionId="+params.executionId+"&processInstanceId="+params.processInstanceId+"&processDefinitionId="+params.processDefinitionId+"&activityId="+params.activityId;
	var index = layer.open({
		  type: 2,
	      title: '提交任务',
	      area: ['750px', '400px'],
	      content: url
		});
	
};
//流程跟踪
TaskOperation.prototype.taskTrace = function() {
	var url = ROOT_URL+"/web/taskTrace.jsp?executionId="+params.executionId+"&processInstanceId="+params.processInstanceId+"&processDefinitionId="+params.processDefinitionId+"&activityId="+params.activityId;
	var index = layer.open({
		  type: 2,
	      title: '流程跟踪',
	      area: ['750px', '400px'],
	      content: url
		});
	
};

TaskOperation.prototype.rollbackPrevious = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/task-operation-rollbackPrevious.do');
	$('#' + this.formId).submit();
};

TaskOperation.prototype.rollbackStart = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/task-operation-rollbackStart.do');
	$('#' + this.formId).submit();
};

TaskOperation.prototype.rollbackInitiator = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/task-operation-rollbackInitiator.do');
	$('#' + this.formId).submit();
};

TaskOperation.prototype.transfer = function() {
	$('#modal form').attr('action', ROOT_URL + '/operation/task-operation-transfer.do');
	$('#modal').modal();
};

TaskOperation.prototype.delegateTask = function() {
	$('#modal form').attr('action', ROOT_URL + '/operation/task-operation-delegateTask.do');
	$('#modal').modal();
};

TaskOperation.prototype.delegateTaskCreate = function() {
	$('#modal form').attr('action', ROOT_URL + '/operation/task-operation-delegateTaskCreate.do');
	$('#modal').modal();
};

TaskOperation.prototype.communicate = function() {
	$('#modalCommunicate form').attr('action', ROOT_URL + '/operation/task-operation-communicate.do');
	$('#modalCommunicate').modal();
};

TaskOperation.prototype.approve = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/task-operation-completeTask.do');
	$('#_humantask_action_').val("同意");
	$('#' + this.formId).submit();
};

TaskOperation.prototype.reject = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/task-operation-completeTask.do');
	$('#_humantask_action_').val("反对");
	$('#' + this.formId).submit();
};

TaskOperation.prototype.abandon = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/task-operation-completeTask.do');
	$('#_humantask_action_').val("弃权");
	$('#' + this.formId).submit();
};

TaskOperation.prototype.callback = function() {
	$('#modalCallback form').attr('action', ROOT_URL + '/operation/task-operation-callback.do');
	$('#modalCallback').modal();
};

TaskOperation.prototype.addCounterSign = function() {
	$('#modalCreateVote form').attr('action', ROOT_URL + '/operation/task-operation-createVote.do');
	$('#modalCreateVote').modal();
};
