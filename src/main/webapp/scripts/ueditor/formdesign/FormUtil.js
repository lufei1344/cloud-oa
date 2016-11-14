/**
 *  FormUtil.js说明
 *  本js提供与Dom操作相关的方法
 */
//对象转字符串
function object2String(obj) {
    var val, output = "";
    if (obj) {  
    	if (isArray(obj)){
    		output = array2String(obj);
    	}else{
    		output += "{";
            for (var i in obj) {
                val = obj[i];
                if(val != null){
                	switch (typeof val) {
    	                case ("object"):
    	                    if (isArray(val)) {
    	                        output += i + ":" + array2String(val) + ",";
    	                    } else {
    	                        output += i + ":" + object2String(val) + ",";
    	                    }
    	                    break;
    	                case ("string"):
    	                    output += i + ":'" + encodeURI(val) + "',";
    	                    break;
    	                default:
    	                    output += i + ":" + val + ",";
    	            }
                }
            }
            output = output.substring(0, output.length-1) + "}";
    	}
        
    }
    return output;
}

function array2String(array) {
    var output = "",val;
    if (array) {
        output += "[";
        for (var i in array) {
            val = array[i];
            switch (typeof val) {
                case ("object"):
                    if (isArray(val)) {
                        output += array2String(val) + ",";
                    } else {
                        output += object2String(val) + ",";
                    }
                    break;
                case ("string"):
                    output += "'" + encodeURI(val) + "',";
                    break;
                default:
                    output += val + ",";
            }
        }
        if(output.length>1){
        	output = output.substring(0, output.length-1) + "]";
        }else{
        	output += "]";
        }
    }
    return output;
}

function string2Object(string) {
	if(typeof string != "string"){
		return string;
	}
    eval("var result = " + decodeURI(string));
    return result;
}

function string2Array(string) {
	if(typeof string != "string"){
		return string;
	}
    eval("var result = " + decodeURI(string));
    return result;
}
function isArray(o) { 
  return Object.prototype.toString.call(o) === '[object Array]';  
}
function getFormData(form) {
	var o = {};
	var a = $(form).serializeArray();
	$.each(a, function () {
		if (o[this.name] !== undefined) {
			if (!o[this.name].push) {
				o[this.name] = [o[this.name]];
			}
			o[this.name].push(this.value || '');
		} else {
			o[this.name] = this.value || '';
		}
	});
	return o;
}
function setFormData(form,formData) {
	var $form = $("#"+form);
	for(var key in formData){
		$form.find("[name='"+key+"']").val(formData[key]);
    }
}
//创建节点
function createElement(tag,ttype, name){     
    var element = null;     
    try {  
    	if(tag == "input"){
    		element = document.createElement('<'+tag+' type="'+ttype+'" name="'+name+'">');  
    	}else{
    		element = document.createElement('<'+tag+'  name="'+name+'">');  
    	}
    } catch (e) {}   
    if(element==null) {     
        element = document.createElement(tag);     
        element.name = name; 
        if(tag == "input"){
        	element.setAttribute("type",ttype);
        }
    } 
    return element;     
}
function node2Object(node){
	var o = new Object();
	var attrs=node.attributes;
    for(var i=0;i<attrs.length;i++){
    	o[attrs[i].name]=attrs[i].value;
    }
    return o;
}
//页面可变控件集合
function getFields(){
	var wedit=window.parent.document.getElementById("ueditor_0");
	var doc = wedit.contentWindow.document;
	var arr = [];
	var objs = doc.getElementsByTagName("input");
	if(objs != null && objs.length>0){
		for(var i=0; i<objs.length; i++){
			if(typeof objs[i].getAttribute("enname") != 'undefined'){
				arr.push(node2Object(objs[i]));
			}
		}
	}
	objs = doc.getElementsByTagName("select");
	if(objs != null && objs.length>0){
		for(var i=0; i<objs.length; i++){
			if(typeof objs[i].getAttribute("enname") != 'undefined'){
				arr.push(node2Object(objs[i]));
			}
		}
	}
	objs = doc.getElementsByTagName("textarea");
	if(objs != null && objs.length>0){
		for(var i=0; i<objs.length; i++){
			if(typeof objs[i].getAttribute("enname") != 'undefined'){
				arr.push(node2Object(objs[i]));
			}
		}
	}
	return arr;
}
//检查是否唯一
function checkTextValid(obj){
	var fs = getFields();
	for(var i=0; i<fs.length; i++){
		if(obj.value == fs[i].enname){
			alert("已经存在");
			obj.value = "";
			obj.focus();
			return;
		}
	}
}
//控件加载赋值
function loadSetValue(oNode){
	 //获得字段名称
    var formData={};
    var attrs=oNode.attributes;
    
    for(var i=0;i<attrs.length;i++){
    	formData[attrs[i].name]=attrs[i].value;
    }
    setFormData("form",formData);
    //默认值表达式
	if(document.getElementById("defaultvalue").value != ""){
		var o = string2Object(document.getElementById("defaultvalue").value);
		var $exp =  $("#defaultvalueexp");
		for(var i=0; i<o.length; i++){
			var html = '<a onclick="cls(this)" val="'+object2String(o[i])+'">'+o[i].cnname+'</a>';
			$exp.append(html);
		}
	}
	//自增
    if(typeof formData["auto"] != 'undefined' && formData["auto"] == "on"){
    	$("#auto")[0].checked = true;
    }
    //自动取值
    if(typeof formData["autotype"] != 'undefined' && formData["autotype"] == "on"){
    	$("#autotype")[0].checked = true;
    }
    //标题显示
    if(typeof formData["showtitle"] != 'undefined' && formData["showtitle"] == "on"){
    	$("#showtitle")[0].checked = true;
    }
	
	//校验
    if(typeof formData["chkvalidate"] != 'undefined' && formData["chkvalidate"] == "on"){
    	$("#chkvalidate")[0].checked = true;
    }
    //输入选择
    if(typeof formData["chkselectrule"] != 'undefined' && formData["chkselectrule"] == "on"){
    	$("#chkselectrule")[0].checked = true;
    }
    //其他元素值
    if(typeof formData["chkothervalue"] != 'undefined' && formData["chkothervalue"] == "on"){
    	$("#chkothervalue")[0].checked = true;
    }
    //其他元素读写
    if(typeof formData["chkotherread"] != 'undefined' && formData["chkotherread"] == "on"){
    	$("#chkotherread")[0].checked = true;
    }
}

//更新控件
function updateOrCreateNode(oNode,editor,formData){
	 var isCreate=false;
    //控件尚未存在，则创建新的控件，否则进行更新
    if( !oNode ) {
        try {
            oNode = createElement(nodeInfo.tag,nodeInfo.type,name);
            //需要设置该属性，否则没有办法其编辑及删除的弹出菜单
            oNode.setAttribute('plugins',nodeInfo.thePlugins);
        } catch (e) {
            try {
                editor.execCommand('error');
            } catch ( e ) {
                alert('控件异常，请联系技术支持');
            }
            return false;
        }
        isCreate=true;
    }
    
  	//设置校验规则
  	//oNode.setAttribute('vtype','rangeLength:'+formData['minlen']+','+formData['maxlen']);
  	
    for(var key in formData){
    	oNode.setAttribute(key,formData[key]);
     }
	    
	  	//更新控件Attributes
     var style="";
     if(formData.mwidth!=0){
     	style+="width:"+formData.mwidth+formData.munit;
     }
     if(formData.mheight!=0){
     	if(style!=""){
     		style+=";";
     	}
     	style+="height:"+formData.mheight+formData.munit;
     }
     oNode.setAttribute('style',style);
     
     if(isCreate){
         editor.execCommand('insertHtml',oNode.outerHTML);
     }else{
     	delete UE.plugins[nodeInfo.thePlugins].editdom;
     }
}