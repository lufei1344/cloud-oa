/**
 *  DialogUtil.js说明
 *  本js提供弹出窗口有关的方法
 */
//默认值设置
function setDefaultValue(obj){
	var dialog = new UE.ui.Dialog({
		iframeUrl:editor.options.UEDITOR_HOME_URL + UE.FormDesignBaseUrl+'/dialog/setdefaultvalue.jsp',
		name:"default",
		editor:editor,
		title: '默认值设置',
		cssRules:"width:600px;height:300px;",
		buttons:[
		{
			className:'edui-okbutton',
			label:'确定',
			onclick:function () {
				dialog.close(true);
				var ret = window.parent.returnValue;
				if(typeof ret != 'undefined'){
					$("#defaultvalue").val(ret.val);
					$("#defaultvalueexp").html(ret.html);
				}
			}
		},
		{
			className:'edui-cancelbutton',
			label:'取消',
			onclick:function () {
				dialog.close(false);
			}
		}]
	});
	
	var obj = new Object();
	obj.val = $("#defaultvalue").val();
	obj.html = $("#defaultvalueexp").html();
	window.parent.dialogParameter = obj;
	dialog.render();
	dialog.open();
}

//校验
function setValidate(obj){
	if(typeof obj == 'undefined'){
		obj = document.getElementById("chkvalidate");
		obj.checked = true;
	}
	if(obj.checked){
		var o = new Object();
		o.datatype = $("#datatype").val();
		o.validate = $("#validate").val();
		var dialog = new UE.ui.Dialog({
			iframeUrl:editor.options.UEDITOR_HOME_URL + UE.FormDesignBaseUrl+'/dialog/setvalidate.jsp',
			name:"default",
			editor:editor,
			title: '设置校验规则',
			cssRules:"width:600px;height:300px;",
			buttons:[
			{
				className:'edui-okbutton',
				label:'确定',
				onclick:function () {
					dialog.close(true);
					var ret = window.parent.returnValue;
					if(typeof ret != 'undefined'){
						$("#validate").val(ret);
					}
				}
			},
			{
				className:'edui-cancelbutton',
				label:'取消',
				onclick:function () {
					dialog.close(false);
				}
			}]
		});
		
		window.parent.dialogParameter = o;
		dialog.render();
		dialog.open();
	}else{
	}
	return true;
}

//
//输入选择
function setSelectRule(obj){
	if(typeof obj == 'undefined'){
		obj = document.getElementById("chkselectrule");
		obj.checked = true;
	}
	if(obj.checked){
		var o = new Object();
		o.selectrule = $("#selectrule").val();
		var ruleurl = "/dialog/setselectrule.jsp";
		var tag = nodeInfo.thePlugins;
		if(tag == "extdig-select" || tag == "extdig-radio" || tag == "extdig-checkbox"){
			ruleurl = "/dialog/setselectrule2.jsp";
		}
		//alert(ruleurl);
		var dialog = new UE.ui.Dialog({
			iframeUrl:editor.options.UEDITOR_HOME_URL + UE.FormDesignBaseUrl+ruleurl,
			name:"default",
			editor:editor,
			title: '设置输入选择',
			cssRules:"width:600px;height:300px;",
			buttons:[
			{
				className:'edui-okbutton',
				label:'确定',
				onclick:function () {
					dialog.close(true);
					var ret = window.parent.returnValue;
					if(typeof ret != 'undefined'){
						$("#selectrule").val(ret);
					}
				}
			},
			{
				className:'edui-cancelbutton',
				label:'取消',
				onclick:function () {
					dialog.close(false);
				}
			}]
		});
		
		window.parent.dialogParameter = o;
		dialog.render();
		dialog.open();
	}else{
		//$("#elevalidateval").val("");
	}
	return true;
}

//设置前置
function setPrev(obj){
	var o = new Object();
	o.val = $("#autoprev").val();
	var dialog = new UE.ui.Dialog({
		iframeUrl:editor.options.UEDITOR_HOME_URL + UE.FormDesignBaseUrl+'/dialog/setautoprev.jsp',
		name:"default",
		editor:editor,
		title: '设置前置',
		cssRules:"width:600px;height:300px;",
		buttons:[
		{
			className:'edui-okbutton',
			label:'确定',
			onclick:function () {
				dialog.close(true);
				var ret = window.parent.returnValue;
				if(typeof ret != 'undefined'){
					$("#autoprev").val(ret);
				}
			}
		},
		{
			className:'edui-cancelbutton',
			label:'取消',
			onclick:function () {
				dialog.close(false);
			}
		}]
	});
	
	window.parent.dialogParameter = o;
	dialog.render();
	dialog.open();
	
}