FormViews = function(conf) {
	var defconf = conf || {};

	this.formId = conf.formId;
	this.toolbarId = conf.toolbarId;
};

FormViews.prototype.saveDraft = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/process-operation-saveDraft.do');
	$('#' + this.formId).submit();
};

FormViews.prototype.startProcess = function() {
	$('#' + this.formId).attr('action', ROOT_URL + '/operation/process-operation-startProcess.do');
	$('#' + this.formId).submit();
};