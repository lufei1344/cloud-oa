draw2d.ScriptTask=function(configPropCallback){
	draw2d.Task.call(this,configPropCallback);
	this.setTitle("脚本任务");
	this.scriptLanguage=null;
	this.script=null;
};
draw2d.ScriptTask.prototype=new draw2d.Task();
draw2d.ScriptTask.prototype.type="draw2d.ScriptTask";
draw2d.ScriptTask.prototype.getIconClassName = function(){
	return "script-task-icon";
};
draw2d.ScriptTask.prototype.getStartElementXML=function(){
	var xml='<scriptTask ';
	xml=xml+this.getGeneralXML();
	xml=xml+this.getScriptLanguageXML();
	xml=xml+'>\n';
	return xml;
};
draw2d.ScriptTask.prototype.getScriptLanguageXML=function(){
	var xml=''
	if(this.scriptLanguage!=null&&this.scriptLanguage!='')
		xml=xml+' scriptFormat="'+this.scriptLanguage+'" activiti:autoStoreVariables="true" '
	return xml;
}
draw2d.ScriptTask.prototype.getScriptXML=function(){
	var xml=''
	if(this.script!=null&&this.script!='')
		xml=xml+'<script>'+this.script+'</script>\n'
	return xml;
}
draw2d.ScriptTask.prototype.getEndElementXML=function(){
	var xml = '</scriptTask>\n';
	return xml;
};
draw2d.ScriptTask.prototype.toXML=function(){
	var xml=this.getStartElementXML();
	xml=xml+this.getScriptXML();
	xml=xml+this.getExtensionElementsXML();
	xml=xml+this.getMultiInstanceXML();
	xml=xml+this.getEndElementXML();
	return xml;
}