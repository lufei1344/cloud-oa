FormViews = function(viewsdata,params,ROOT_URL) {
	this.viewsdata = viewsdata;
	this.params = params;
	this.fields = params.fields;
	this.ROOT_URL = ROOT_URL;
};

FormViews.prototype.saveData = function() {
	//校验
	if(!formValidate()){
		return;
	}
	//公章
	if(gongzhang.length>0){
		//现不使用自动保存
		//$("input[class='gongzhang']").val(GetSealData(''));
	}
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
	var form = $("#form")[0];
	form.action = this.ROOT_URL+"/form/saveFormData";
	form.submit();
};
FormViews.prototype.saveDataCallBack = function() {
	
};

FormViews.prototype.initDefault = function() {
	var forms = this.viewsdata.forms; 
	for(var i=0; i<forms.length; i++){
		var form = forms[i];
		//alert("ele="+form.formatElement.length);
		for(var v =0; v<form.fields.length; v++){
			var e = form.fields[v];
			
			var obj = $("#"+e.enname)[0];
			if(typeof obj == 'undefined' || obj == null){
				continue;	
			}
			//手机端
			if(pweb == "m" && e.showType != "gongzhang"){
				if(e.e_ShowType == 'text'){
					$(obj).css({width:"100%",height:"30px"});
				}
				if(e.e_ShowType == 'textarea'){
					$(obj).css({width:"100%",height:"50px"});
				}
				var $html = $('<li><span class="s1 textcolor" >'+e.e_Name+'</span><span class="s2" id="li_'+e.e_English_Name+'"></span></li>');
				$html.find("#li_"+e.e_English_Name).append(obj);
				$("#"+form.id).append($html);
			}
			//日期
			if(e.dataType == "date"){
				obj.onclick = function(){WdatePicker({dateFmt:this.getAttribute("dateformat")})};
				//赋值
				if(e[e.dataType+"value"] != ""){
					var vvv = e[e.dataType+"value"].substring(0,19);
					obj.value = new Date(Date.parse(vvv.replace(/-/g,"/"))).format(obj.getAttribute("dateformat"));
				}else{
					obj.value = new Date().format(obj.getAttribute("dateformat"));
				}
				
			}
			//select
			if(e.showType == "select"){
				//常量
				e.selectRule = string2Object(e.selectRule);
				if(e.selectRule.type == "sys"){
					for(var n=0; n<e.selectRule.show.length; n++){
						var opt = e.selectRule.show[n];
						obj.options.add(new Option(decodeURI(opt.show),decodeURI(opt.key)));
					}
				}
				//form
				if(e.selectRule.type == "form" || e.selectRule.type == "sql"){
					var key = e.selectRule.show[0].key;
					for(var n=0; n<e.data.length; n++){
						obj.options.add(new Option(e.data[n][key],e.data[n][key]));
					}
				}
				//赋值
				obj.value = e[e.dataType+"value"];
			}
			//radio
			if((e.showType == "radio" || e.showType == "checkbox" ||  e.showType == "textarea") && e.selectRule != ""){
				//常量
				e.selectRule = string2Object(e.selectRule);
				if(e.e_SelectRule.type == "sys"){
					var af = null;
					var html = "";
					//alert(e.e_SelectRule.show.length);
					var menuitem = [];
					for(var n=0; n<e.e_SelectRule.show.length; n++){
						var opt = e.e_SelectRule.show[n];
						if(n == 0 && (e.e_ShowType == "radio" || e.e_ShowType == "checkbox")){
							obj.name = e.e_English_Name;
							obj.value =  decodeURI(opt.key);
							html +="<label  class='radio'>"+decodeURI(opt.show)+"</label>";
							
						}else{
							if(e.e_ShowType == "radio"){
								html += "<input type='radio'  id='"+e.e_English_Name+"' name='"+e.e_English_Name+"' value='"+decodeURI(opt.key)+"'/><label class='radio'>"+decodeURI(opt.show)+"</label>";
							}else if(e.e_ShowType == "checkbox"){
							html += "<input type='checkbox' name='"+e.e_English_Name+"' value='"+decodeURI(opt.key)+"'/><label class='radio'    >"+decodeURI(opt.show)+"</label>";  									
							}			
						}
						//textarea添加右键菜单
						 if(e.e_ShowType == "textarea"){
								menuitem.push({label:decodeURI(opt.key),action:function(id,val){ return function(){$("#"+id).val(val)}; }(e.e_English_Name,decodeURI(opt.key))});
						}
					}
					if(html != ""){
						$(obj).after(html);
					}
					if(menuitem.length>0){//右键菜单
						$("#"+e.e_English_Name).contextPopup({items:menuitem});
					}
				}
				//form,sql
				if(e.e_SelectRule.type == "form" || e.e_SelectRule.type == "sql"){
					var af = null;
					var html = "";
					var key = e.e_SelectRule.show[0].key;
					var menuitem = [];
					for(var n=0; n<e.data.length; n++){
						var opt = e.data[n];
						if(n == 0 && (e.e_ShowType == "radio" || e.e_ShowType == "checkbox")){
							obj.name = e.e_English_Name;
							obj.value =  opt[key];
							html +="<label class='radio'>"+opt[key]+"</label>";
						}else{
							if(e.e_ShowType == "radio"){
								html += "<input type='radio' id='"+e.e_English_Name+"' name='"+e.e_English_Name+"' value='"+opt[key]+"'/><label class='radio'>"+opt[key]+"</label>";
							}else if(e.e_ShowType == "checkbox"){
								html += "<input type='checkbox' id='"+e.e_English_Name+"' name='"+e.e_English_Name+"' value='"+opt[key]+"'/><label class='radio'>"+opt[key]+"</label>";
							}
						}
						
						if(e.e_ShowType == "textarea"){
								menuitem.push({label:opt[key],action:function(id,val){ return function(){$("#"+id).val(val)}; }(e.e_English_Name,opt[key])});
						}
					}
					if(html != ""){
						$(obj).after(html);
					}
					if(menuitem.length>0){//右键菜单
						$("#"+e.e_English_Name).contextPopup({items:menuitem});
					}
				}
				
				//赋值
				if(e.e_ShowType == "radio"){
					$("input[name='"+e.e_English_Name+"'][value='"+e[e.e_DataType+"value"]+"']").attr("checked","checked");
				}else if(e.e_ShowType == "checkbox"){
					$("input[name='"+e.e_English_Name+"']").each(function(){
						if(e[e.e_DataType+"value"] == "" && $("#"+e.e_English_Name).val()!= ""){
							e[e.e_DataType+"value"] = $("#"+e.e_English_Name).val();
						}
						if(e[e.e_DataType+"value"].indexOf(this.value)>=0){
							$(this).attr("checked","checked");
						}
					});
				}
			}
			
			//input输入选择
			if(e.e_ShowType == "text"){
				obj.className = "input";
				if(e.e_SelectRule != "" && e.e_SelectRule != "null"){
					//obj.setAttribute("eid",e.id);
					eval("e.e_SelectRule="+decodeURIComponent(e.e_SelectRule));
					//点击事件
					obj.onclick = function(e){
						return function(){
							var o = new Object();
							if(e.e_SelectRule.type == "sql"){
								e.e_SelectRule.sql = replaceSql(e.e_SelectRule.sql);
							}
							//alert(e.e_SelectRule.sql);
						var fc=window.showModalDialog(cxt+"/findCallBack.html?userid="+userid+"&exapleId="+exampleId+"&eid="+e.id+"&sql="+encodeURIComponent(e.e_SelectRule.sql),o,"dialogHeight:600px;dialogWidth:850px;status:0;");
						if(typeof fc != 'undefined'){
							//var e_SelectRule = string2Object($(this).attr("eleinputval"));
							var e_SelectRule = e.e_SelectRule;
							for(var t=0; t<e_SelectRule.valset.length; t++){
								var vs = e_SelectRule.valset[t];
								var $ele = $("#"+vs.elementid);
								if($ele.attr("elementtype") == 'date'){
									$ele.val(new Date(Date.parse(fc[vs.column].replace(/-/g,"/"))).format($ele.attr("dateformat")));
								}else{
									if($ele[0].tagName == "INPUT" && $ele.attr("type") == "radio"){
										//赋值
											$("input[name='"+e.e_English_Name+"'][value='"+fc[vs.column]+"']").attr("checked","checked");
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
				if(e.e_auto == "1"){
					mAuto(e);
				}
				//人员选择
				if(e.e_ProPerty == "user" && e.e_ShowType == "text"){
					repUser(e);
				}
				//部门选择
				if(e.e_ProPerty == "dept" && e.e_ShowType == "text"){
					repDept(e);
				}
			}
			//file输入选择
			if(e.e_ShowType == "file"){
				if(e.e_ProPerty == "free"){//多个文件
					mfile(e);
				}else{//固定
					var vvv = e['charvalue'];
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
			
			
			//input,textarea赋值
			if(e.e_ShowType == "text" || e.e_ShowType == "textarea"){
				if(e.e_DataType != "date"){
					if(e.e_ProPerty == "1" && e.e_ShowType == "textarea"){//意见
						repSign(e);//意见控件
						//会签形式保存数据
						mutiElesName.push(e.e_English_Name);
  						mutiElesId.push(e.id);
					}if(e.e_ProPerty == "huiqian" && e.e_ShowType == "textarea"){//会签
						//repJoinSign(e);//会签控件
						repSign(e);
						//会签形式保存数据
						mutiElesName.push(e.e_English_Name);
  						mutiElesId.push(e.id);
					}else{
						if(e[e.e_DataType+"value"] != ""){
							obj.value = e[e.e_DataType+"value"];
						}
					}
				}
			}
			
			
			//只读
			if(fields.indexOf(e.id)>=0){
				obj.disabled = true;
				//obj.readOnly = true;
				readonlyeles_id.push(e.e_English_Name);
				if(e.e_ShowType == "checkbox" || e.e_ShowType == "radio"){
					$("input[name='"+e.e_English_Name+"']").attr("disabled",true);
				}
			}
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