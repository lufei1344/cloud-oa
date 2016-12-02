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
/**
 * 表单处理
 * @param viewsdata  显示表单
 * @param params     参数
 * @param ROOT_URL   路径
 * @param sysValue   系统变量
 * @returns
 */
FormViews = function(viewsdata,params,ROOT_URL,sysValue) {
	this.viewsdata = viewsdata;
	this.params = params;
	this.fields = params.fields;
	this.ROOT_URL = ROOT_URL;
	this.sysValue = sysValue; 
};

//保存
FormViews.prototype.saveData = function() {
	//校验
	if(!this.formValidate()){
		return;
	}
	/**
	//会签
	if(mutiElesName.length>0){
		for(var i=0; i<mutiElesName.length; i++){
			var c = [];
			$("textarea[name='sign_"+mutiElesName[i]+"']").each(function(idx){
				if(this.value != ""){
					//var username = $(this).parent().find("input[name='signusername_"+mutiElesName[i]+"']")[idx].value;
					//var ctime = $(this).parent().find("input[name='signdate_"+mutiElesName[i]+"']")[idx].value;
					//c.push(username+":"+this.value+" "+ctime);
				}
			});	  				
			//$("textarea[name='"+mutiElesName[i]+"']").val(c.join("\r\n"));	
		}
		$("#mutiElesName").val(mutiElesName.join(","));
		$("#mutiElesId").val(mutiElesId.join(","));
	}
	var r = readonlyeles_id;
	for(var i=0; i<r.length; i++){
		document.getElementById(r[i]).disabled = false;
		var thisobj = document.getElementById(r[i]);
		if(thisobj.type == 'checkbox' ||
				thisobj.type == 'radio'){
			$("input[name='"+thisobj.name+"']").attr("disabled",false);
		}
		
	}
	*/
	var form = $("#form")[0];
	form.action = this.ROOT_URL+"/form/saveFormData";
	form.submit();
};
FormViews.prototype.saveDataCallBack = function(redata) {
	if(redata.status){
		layer.msg("保存成功！");
	}
};
//校验
FormViews.prototype.formValidate = function(){
	return true;
};
//人员和部门选择对话框
FormViews.prototype.dialogUser = function(obj,e){
	var o = new Object();
	var $obj = $(obj);
	o.ids = $("#"+$obj.attr("enname")+"_ids").val();
	o.names = $("#"+$obj.attr("enname")).val(); 
	var url = "/web/dialog/findUser.jsp";
	if($obj.attr("exttype") == "dept"){
		url = "/web/dialog/findDept.jsp"
	}
	var ret=window.showModalDialog(this.ROOT_URL+url,o,"dialogHeight:500px;dialogWidth:450px;status:0;");
	if(typeof ret != 'undefined'){
		//alert(fc);
		$("#"+$obj.attr("enname")+"_ids").val(ret.ids);
		$("#"+$obj.attr("enname")).val(ret.names);
	}
}
//人员控件
FormViews.prototype.replaceUser = function(e){
	var $obj = $("#"+e.enname);
	//input替换为textarea，显示不下
	$obj.replaceWith("<textarea name='"+e.enname+"' id='"+e.enname+"' style='width:"+$obj.width()+"px;height:"+$obj.height()+"px'>"+e.charValue+"</textarea>");
	$obj = $("#"+e.enname);
	var $id = $("<input type='hidden'  name='"+e.enname+"_ids' id='"+e.enname+"_ids'/>");
	var $btn = $("<input type='button' class='btn btn-sm' enname='"+e.enname+"' exttype='user'  value='选择'/>");
	$btn.click(function(e){
		formViews.dialogUser(this,e);
	});
	$obj.after($btn).after($id);
	if(this.params.fields.indexOf(e.id)<0){
		$btn.hide();
		$obj[0].disabled = true;
	}
	var url = this.ROOT_URL+"/form/findUserData.html?s="+Math.random();
	var o = new Object();
	o.name = e.enname+"_ids";
	o.executionId= params.executionId;
	o.fieldId = e.id;
	o.formId = e.formId;
	$.getJSON(url,o,function(data){
		if(data.obj.length>0){
			$id.val(data.obj.join(","));
		}else{
			$id.val("");
		}
		
	})
};
//部门控件
FormViews.prototype.replaceDept = function(e){
	var $obj = $("#"+e.enname);
	//input替换为textarea，显示不下
	$obj.replaceWith("<textarea name='"+e.enname+"' id='"+e.enname+"' style='width:"+$obj.width()+"px;height:"+$obj.height()+"px'>"+e.charValue+"</textarea>");
	$obj = $("#"+e.enname);
	var $id = $("<input type='hidden'  name='"+e.enname+"_ids' id='"+e.enname+"_ids'/>");
	var $btn = $("<input type='button' class='btn btn-sm' enname='"+e.enname+"' exttype='dept'  value='选择'/>");
	$btn.click(function(e){
		formViews.dialogUser(this,e);
	});
	$obj.after($btn).after($id);
	if(this.params.fields.indexOf(e.id)<0){
		$btn.hide();
		$obj[0].disabled = true;
	}
	var url = this.ROOT_URL+"/form/findUserData.html?s="+Math.random();
	var o = new Object();
	o.name = e.enname+"_ids";
	o.executionId= params.executionId;
	o.fieldId = e.id;
	o.formId = e.formId;
	$.getJSON(url,o,function(data){
		if(data.obj.length>0){
			$id.val(data.obj.join(","));
		}else{
			$id.val("");
		}
		
	})
};
//多文件上传
FormViews.prototype.multiFile = function(e){
	var $input = $("#"+e.enname);
	$input.attr("type","hidden");
	var html = '<span id="'+e.enname+'_uploader" class="wu-example">'+
				'    <div id="'+e.enname+'_thelist" class="uploader-list"></div>'+
				'    <div class="btns">'+
				'        <div id="'+e.enname+'_picker">选择文件</div>'+
				'    </div>'+
				'</span>';
	$input.after(html);
	var uploader = WebUploader.create({
					//是否自动上传
					auto: true,
				    // swf文件路径
				    swf: this.ROOT_URL + '/scripts/webuploader/Uploader.swf',
				    // 文件接收服务端。
				    server: this.ROOT_URL+'/form/uploadFormFile',
				    // 选择文件的按钮。可选。
				    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
				    pick: '#'+e.enname+'_picker',
				    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
				    resize: false
				});
	uploader.on( 'fileQueued', function( file ) {
	   //alert(file.name);
	});
	uploader.on('uploadSuccess', function( file,redata) {
		var html = "";
		for(var i=0; i<redata.file.length; i++){
			var fs = redata.file[i].split(":");
			html += fs[0] +"&nbsp;"+fs[2];
			$input.val($input.val() == "" ? redata.file[i] : ($input.val()+","+redata.file[i]));
		}
		$("#"+e.enname+"_thelist").append(html);
	    //layer.msg("上传成功！");
	});

	uploader.on('uploadError', function( file ) {
		layer.msg("上传出错！");
	});
	
	//默认值
	if(e.charValue != ""){
		var files = e.charValue.split(",");
		var html = "";
		for(var i=0; i<files.length; i++){
			var fs = files[i].split(":");
			html += fs[0] +"&nbsp;"+fs[2];
		}
		$("#"+e.enname+"_thelist").append(html);
		$input.val(e.charValue);
	}
};
//查询sql语句数据
FormViews.prototype.getSqlData = function(sql){
	$.ajaxSettings.async = false;
	var data;
	$.getJSON(this.ROOT_URL+"/form/findSqlData",{sql:sql},function(redata){  
	     data = redata.obj;  
	});  
	$.ajaxSettings.async = true;
	return data;
}
//查询字典数据
FormViews.prototype.getDictData = function(sql){
	$.ajaxSettings.async = false;
	var data;
	$.getJSON(this.ROOT_URL+"/form/findDictData",{name:name},function(redata){  
		data = redata.obj;  
	});  
	$.ajaxSettings.async = true;
	return data;
}
//获取本表单值
FormViews.prototype.getBbdValue = function(e){
	
}
//获取应用表单值
FormViews.prototype.getYybdValue = function(e){
	
}
//获取系统变量值
FormViews.prototype.getSysValue = function(key){
	if(key == "dept"){//部门
		return this.sysValue.org.name;
	}
	if(key == "post"){//岗位
		return this.sysValue.org.name;
	}
	if(key == "user"){//用户名
		return this.sysValue.fullname;
	}
	if(key == "time"){//时间
		return new Date().format("yyyy-MM-dd HH:mm:ss");
	}
	if(key == "date"){//日期
		return new Date().format("yyyy-MM-dd");
	}
	return "";
}
//默认值处理
FormViews.prototype.setDefalutValue = function(e){
	if(e.defaultValue != ""){
		//只有第一次未填值时默认值起作用
		if(e[e.dataType+"Value"] == ""){
			e.defaultValue = decodeURIComponent(e.defaultValue);
			e.defaultValue = string2Object(e.defaultValue);
			var exp = "";
			for(var i=0; i<e.defaultValue.length; i++){
				var o = e.defaultValue[i];
				if(o.type == "xtcl" || o.type == "xtfh"){
					exp += "'"+o.key+"'";
				}
				if(o.type == "xtfh"){
					exp += o.key;
				}
				if(o.type == "xtbl"){//系统变量
					exp += "";
				}
				if(o.type == "bbd"){//本表单
					exp += "";
				}
				if(o.type == "yybd"){//引用表单
					exp += "";
				}
			}
			if(exp != ""){
				var val;
				eval("val = "+exp);
				e[e.dataType+"Value"] = val;
			}
		}
	}
	return e;
}
FormViews.prototype.initForms = function() {
	var forms = this.viewsdata.forms; 
	for(var i=0; i<forms.length; i++){
		var form = forms[i];
		for(var v =0; v<form.fields.length; v++){
			var e = form.fields[v];
			var obj = $("#"+e.enname)[0];
			if(typeof obj == 'undefined' || obj == null){
				continue;	
			}
			//默认值处理
			e = this.setDefalutValue(e);
			//日期
			if(e.dataType == "date"){
				obj.onclick = function(){laydate({istime: true, format: this.getAttribute("dateformat")})};
				//赋值
				if(typeof e[e.dataType+"Value"] != 'undefined' && e[e.dataType+"Value"] != ""){
					var vvv = e[e.dataType+"Value"].substring(0,19);
					obj.value = new Date(Date.parse(vvv.replace(/-/g,"/"))).format(obj.getAttribute("dateformat"));
				}else{
					obj.value = new Date().format(obj.getAttribute("dateformat"));
				}
				
			}
			//select
			if(e.showType == "select"){
				//常量
				e.selectRule = decodeURIComponent(e.selectRule);
				e.selectRule = string2Object(e.selectRule);
				if(e.selectRule.type == "sys"){
					for(var n=0; n<e.selectRule.show.length; n++){
						var opt = e.selectRule.show[n];
						obj.options.add(new Option(opt.show,opt.key));
					}
				}
				//sql
				if(e.selectRule.type == "sql" || e.selectRule.type == "dict"){
					var data = e.selectRule.type == "sql" ? this.getSqlData(e.selectRule.sql) : this.getDictData(e.selectRule.dictname);
					for(var n=0; n<data.length; n++){
						obj.options.add(new Option(data[n].name,data[n].value));
					}
				}
				//赋值
				obj.value = e[e.dataType+"Value"];
			}
			//radio
			if((e.extType == "radio" || e.extType == "checkbox") && e.selectRule != ""){
				//常量
				e.selectRule = decodeURIComponent(e.selectRule);
				e.selectRule = string2Object(e.selectRule);
				var html = "";
				if(e.selectRule.type == "sys"){
					for(var n=0; n<e.selectRule.show.length; n++){
						var opt = e.selectRule.show[n];
						if(n == 0){
							obj.name = e.enname;
							obj.value =  decodeURI(opt.key);
							html +="<label  class='form_radio'>"+opt.show+"</label>";
							
						}else{
							if(e.extType == "radio"){
								html += "<input type='radio'   name='"+e.enname+"' value='"+opt.key+"'/><label class='form_radio'>"+(opt.show)+"</label>";
							}else if(e.extType == "checkbox"){
								html += "<input type='checkbox' name='"+e.enname+"' value='"+(opt.key)+"'/><label class='form_radio'>"+(opt.show)+"</label>";  									
							}			
						}
						
					}
				}
				//sql
				if(e.selectRule.type == "sql" || e.selectRule.type == "dict"){
					var data = e.selectRule.type == "sql" ? this.getSqlData(e.selectRule.sql) : this.getDictData(e.selectRule.dictname);
					for(var n=0; n<data.length; n++){
						var opt = data[n];
						if(n == 0){
							obj.name = e.enname;
							obj.value =  decodeURI(opt.value);
							html +="<label  class='form_radio'>"+opt.name+"</label>";
							
						}else{
							if(e.extType == "radio"){
								html += "<input type='radio'   name='"+e.enname+"' value='"+opt.value+"'/><label class='form_radio'>"+(opt.name)+"</label>";
							}else if(e.extType == "checkbox"){
								html += "<input type='checkbox' name='"+e.enname+"' value='"+(opt.value)+"'/><label class='form_radio'>"+(opt.name)+"</label>";  									
							}			
						}
						
					}
					
				}
				if(html != ""){
					$(obj).after(html);
				}
				//赋值
				if(e[e.dataType+"Value"] != ""){
					if(e.extType == "radio"){
						$("input[name='"+e.enname+"'][value='"+e[e.dataType+"Value"]+"']").attr("checked","checked");
					}else if(e.extType == "checkbox"){
						$("input[name='"+e.enname+"']").each(function(){
							if(e[e.dataType+"Value"].indexOf(this.value)>=0){
								$(this).attr("checked","checked");
							}
						});
					}
				}
				
			}
			
			//input
			if((e.extType == "input" || e.showType == "textarea") && e.dataType != "date"){
				if(e.selectRule != "" && e.selectRule != "null"){
					e.selectRule = decodeURIComponent(e.selectRule);
					e.selectRule = string2Object(e.selectRule);
					//点击事件
					obj.onclick = function(e){
						return function(){
							var o = new Object();
							o.selectRule = e.selectRule;
						    var fc=window.showModalDialog(ROOT_URL+"/web/findCallBack.jsp?sql="+encodeURIComponent(e.selectRule.sql),o,"dialogHeight:600px;dialogWidth:850px;status:0;");
						    if(typeof fc != 'undefined'){
								var e_SelectRule = e.selectRule;
								for(var t=0; t<e_SelectRule.valset.length; t++){
									var vs = e_SelectRule.valset[t];
									var $ele = $("#"+vs.enname);
									vs.column = vs.column.toLowerCase();
									if($ele.attr("datatype") == 'date'){
										$ele.val(new Date(Date.parse(fc[vs.column].replace(/-/g,"/"))).format($ele.attr("dateformat")));
									}else{
										if($ele[0].tagName == "INPUT" && $ele.attr("type") == "radio"){
											//赋值
												$("input[name='"+e.enname+"'][value='"+fc[vs.column]+"']").attr("checked","checked");
										}else if($ele[0].tagName == "INPUT" && $ele.attr("type") == "checkbox"){
											$ele.attr("checked","checked");
										}else{
											//input,textarea,select
											$ele.val(fc[vs.column]);
										}
									}
									
								}
							}
						};
					}(e);
				}
				//自定义序列
				if(e.auto == "1"){
					mAuto(e);
				}
				if(e[e.dataType+"Value"] != ""){
					obj.value = e[e.dataType+"Value"];
				}
			}
			//用户控件
			if(e.extType == "user"){
				this.replaceUser(e);
			}
			//部门控件
			if(e.extType == "dept"){
				this.replaceDept(e);
			}
			//file输入选择
			if(e.showType == "file"){
				if(e.extType == "free"){//多个文件
					this.multiFile(e);
				}else{//固定
					var vvv = e['charValue'];
					if(vvv != ""){
						vvv = vvv.split(":");
						var uname = vvv.length>2 ? "&nbsp;&nbsp;"+vvv[2].replace(/_/g," ") : "";
						if(readonlyeles.indexOf(e.id)>=0 || openType == "2"){
							$(obj).after("<table class='zebra' ><tr><td width='5%'><img src='images/document.png' /></td><td><a href='javascript:void(0)' onclick=\"openUFile('"+vvv[0]+"','"+vvv[1]+"','"+e.e_ProPerty+"','read')\">"+vvv[0]+uname+"</a></td></tr></table>");  									
							$(obj).hide();
						}else{
							$(obj).after("<table class='zebra'><tr><td width='5%'><img src='images/document.png' /></td><td><a href='javascript:void(0)' onclick=\"openUFile('"+vvv[0]+"','"+vvv[1]+"','"+e.e_ProPerty+"','edit')\">"+vvv[0]+uname+"</a></td><td><a href='javascript:void(0)'  onclick=\"delUFile(this,'file_"+e.e_English_Name+"')\" class='fjbtn'>删除</a></td></tr></table>");
						}
					}
					$(obj).after("<input name='file_"+e.e_English_Name+"' id='file_"+e.e_English_Name+"' type='hidden' value='"+e['charvalue']+"'/>");
				}
			}
			
			
		
			
			/**
			//只读
			if(fields.indexOf(e.id)>=0){
				obj.disabled = true;
				//obj.readOnly = true;
				readonlyeles_id.push(e.e_English_Name);
				if(e.e_ShowType == "checkbox" || e.e_ShowType == "radio"){
					$("input[name='"+e.e_English_Name+"']").attr("disabled",true);
				}
			}
			*/
			//会签,改为会签控件，流程不在控制
			/*
			if(mutiEles.indexOf(e.id)>=0){
				mutiElesName.push(e.e_English_Name);
				mutiElesId.push(e.id);
				repJoinSign(e);
			}
			*/
		}
	}
		
		
};