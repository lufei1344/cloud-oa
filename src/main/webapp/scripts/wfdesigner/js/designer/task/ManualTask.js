draw2d.ManualTask=function(configPropCallback){
	draw2d.Task.call(this,configPropCallback);
	this.setTitle("手工任务");
};
draw2d.ManualTask.prototype=new draw2d.Task();
draw2d.ManualTask.prototype.type="draw2d.ManualTask";
draw2d.ManualTask.prototype.getIconClassName = function(){
	return "manual-task-icon";
};
draw2d.ManualTask.prototype.getStartElementXML=function(){
	var xml='<task ';
	xml=xml+this.getGeneralXML();
	xml=xml+'>\n';
	return xml;
};
draw2d.ManualTask.prototype.getEndElementXML=function(){
	var xml = '</task>\n';
	return xml;
};
draw2d.ManualTask.prototype.toXML=function(){
	var xml=this.getStartElementXML();
	xml=xml+this.getExtensionElementsXML();
	xml=xml+this.getMultiInstanceXML();
	xml=xml+this.getEndElementXML();
	return xml;
}