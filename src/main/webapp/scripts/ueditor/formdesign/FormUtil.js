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

function createElement(type, name){     
    var element = null;     
    try {        
        element = document.createElement('<'+type+' name="'+name+'">');     
    } catch (e) {}   
    if(element==null) {     
        element = document.createElement(type);     
        element.name = name;     
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