<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 	<title>文本框-textbox</title>
	 	<link   type="text/css"  href="${ctxPath}/scripts/ueditor/formdesign/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/js/jquery.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/js/bootstrap.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/FormUtil.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/validate/jquery.validate.js"></script>
	 	
</head>
<body>
	<div style="width:100%;text-align: center">
		<div style="margin-left:auto;margin-right: auto;padding:5px;">
			<form id="form" class="form">
				<table class="table table-bordered" cellspacing="1" cellpadding="1">
					<caption>文本框属性配置</caption>
					<tr>
						<td align="right">
							中文名称:
						</td>
						<td align="left">
							<input type="text" name="cnname" value=""
								id="cnname" class="form-control"  required data-msg-required="不能为空" data-rule-gt="true" data-gt="0"><font color="red">*</font>
							
						</td>
					</tr>
					<tr>
						<td align="right">
							英文名称:
						</td>
						<td align="left">
							<input type="text" name="enname" value="" id="enname" class="form-control" onblur="checkTextValid(this)" required data-msg-required="不能为空" data-rule-gt="true" data-gt="0"><font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							数据类型:
						</td>
						<td align="left">
							<select name="datatype" id="datatype" class="form-control" onchange="selelementtype(this)">
								<option value="char">文本</option>
								<option value="num">数值</option>
								<option value="date">日期</option>
							</select>
							<input name="auto" id="auto" type="checkbox" class="form-control" onclick="setAuto(this)" value="1" />
							前缀<input style="display:none;width:60px;" name="autoprev" id="autoprev" value="" >
							<input style="display:none;" id="autoprevbtn" class="btn" type="button" value="..." onclick="setPrev(this)"/>
							<input name="autotype" id="autotype" class="form-control" type="checkbox" value="1" />自动取号
						</td>
					</tr>
					<tr id="trdateformat" style="display: none;">
						<td align="right">
							日期格式:
						</td>
						<td align="left">
							<input  name="dateformat" id="dateformat" class="form-control" value="yyyy年MM月dd日" style="width: 190px;"/><br/>
							yyyy年MM月dd日 HH时mm分ss秒
						</td>
					</tr>
					<tr>
						<td align="right">
							列表表头:
						</td>
						<td align="left">
							<input type="checkbox" class="form-control" name="showtitle" id="showtitle"/>
							显示类型:
							<select name="showtype" style="width:80px;" class="form-control" id="showtype">
								<option value="input">输入框</option>
								<option value="user">人员</option>
								<option value="dept">部门</option>
							</select>
							
						</td>
					</tr>
					<tr>
						<td align="right">
							默认值:
						</td>
						<td align="left">
							<input type="hidden" id="defaultvalue" value="" name="defaultvalue"/>&nbsp;&nbsp;
							<input type="button" onclick="eledefshow(this)" class="btn btn-sm btn-info" value="..."/>
						</td>
					</tr>
					<tr>
						<td align="right">
							控件大小:
						</td>
						<td align="left">
							高<input type="text" class="form-control" value="0" name="mheight" style="width:80px"/>*
							宽<input type="text" class="form-control" value="0" name="mwidth" style="width:80px"/>
							单位<input type="text" class="form-control" value="px" name="munit" style="width:60px"/>
						</td>
					</tr> 
					<tr>
						<td colspan="2" align="left">
							<input type="checkbox" id="elevalidate" onclick="validateshow(this)" name="elevalidate"/><a href="javascript:void(0)" onclick="validateshow()">设置校验规则</a>
							<input type="hidden" name="validate" id="validate"/>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="left">
							<input type="checkbox" id="eleinput" name="eleinput" onclick="inputshow(this)"/><a href="javascript:void(0)" onclick="inputshow()">设置输入选择</a>
							<input type="hidden" name="selectrule" id="selectrule"/>
						</td>
						
					</tr>
					<tr>
						<td colspan="2" align="left">
							<input type="checkbox" id="eleothervalue" onclick="othervalueshow(this)" name="eleothervalue" /><a href="javascript:void(0)" onclick="othervalueshow()">影响其他元素的值</a>
							<input type="hidden" name="othervalue" id="eleothervalueval"/>
						</td>
						
					</tr>
					<tr>
						<td colspan="2" align="left">
							<input type="checkbox" id="eleotherread" name="eleotherread"  onclick="otherreadshow(this)"/><a href="javascript:void(0)" onclick="otherreadshow()">影响其他元素的读写属性</a>
							<input type="hidden" name="otherread" id="eleotherreadval"/>
						</td>
						
					</tr>
					
				</table>
			</form>
			</div>
	</div>
	<script type="text/javascript">
		$(function(){
			jQuery.validator.setDefaults({
				  success: "valid"
				});
			$("#form").validate({
				  debug: true,
				  wrapper: "span"
			});
		});
		
		//编辑的控件的值
		var oNode = null,
		thePlugins = 'extdig-textbox';
		
		window.onload = function() {
			//若控件已经存在，则设置回调其值
		    if( UE.plugins[thePlugins].editdom ){
		        //
		    	oNode = UE.plugins[thePlugins].editdom;
		        //获得字段名称
		        var formData={};
		        var attrs=oNode.attributes;
		        
		        for(var i=0;i<attrs.length;i++){
		        	formData[attrs[i].name]=attrs[i].value;
		        }
		        
		        setFormData("form",formData);
		    }
		}
		//取消按钮
		dialog.oncancel = function () {
		    if( UE.plugins[thePlugins].editdom ) {
		        delete UE.plugins[thePlugins].editdom;
		    }
		};
		//确认
		dialog.onok = function (){
			// $('#form').data('bootstrapValidator').validate();  
            //if(!$('#form').data('bootstrapValidator').isValid()){  
             //   return ;  
            //}
            if(!$("#form").valid()){
            	return false;
            }
	        var formData=getFormData("form");
	        var isCreate=false;
		    //控件尚未存在，则创建新的控件，否则进行更新
		    if( !oNode ) {
		        try {
		            oNode = createElement('input',name);
		            //需要设置该属性，否则没有办法其编辑及删除的弹出菜单
		            oNode.setAttribute('plugins',thePlugins);
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
            	delete UE.plugins[thePlugins].editdom;
            }
            	
		};
		
		//校验
		function validateshow(obj){
			if(typeof obj == 'undefined'){
				obj = document.getElementById("elevalidate");
				obj.checked = true;
			}
			if(obj.checked){
				var o = new Object();
				o.datatype = $("#eletype").val();
				o.elevalidateval = $("#elevalidateval").val();
				var ret=window.showModalDialog("../dialog/editvalidate.jsp",o,"dialogHeight:250px;dialogWidth:400px;status:0;");
				if(typeof ret != 'undefined'){
					$("#elevalidateval").val(ret);
				}
			}else{
				//$("#elevalidateval").val("");
			}
			return true;
		}
		//默认值
		function eledefshow(obj){
				var o = new Object();
				//o.kjarr = ww.kjarr;
				o.eledef = $("#eledef").val();
				o.gid = ww.gid;
				var ret=window.showModalDialog("../dialog/editdef.jsp",o,"dialogHeight:470px;dialogWidth:600px;status:0;");
				if(typeof ret != 'undefined'){
					$("#eledef").val(ret.val);
					$("#eledefexp").html(ret.html);
				}
		}
		//输入选择
		function inputshow(obj){
			if(typeof obj == 'undefined'){
				obj = document.getElementById("eleinput");
				obj.checked = true;
			}
			if(obj.checked){
				var o = new Object();
				//o.kjarr = ww.kjarr;
				o.eleinputval = $("#eleinputval").val();
				o.gid = ww.gid;
				var ret=window.showModalDialog("../dialog/editinputsel.jsp",o,"dialogHeight:400px;dialogWidth:400px;status:0;");
				if(typeof ret != 'undefined'){
					//alert(fc);
					$("#eleinputval").val(ret);
				}
			}else{
				//$("#elevalidateval").val("");
			}
			return true;
		}
		//其他元素值
		function othervalueshow(obj){
			if(typeof obj == 'undefined'){
				obj = document.getElementById("eleothervalue");
				obj.checked = true;
			}
			if(obj.checked){
				var o = new Object();
				//o.kjarr = ww.kjarr;
				o.eleothervalue = $("#eleothervalueval").val();
				var ret=window.showModalDialog("../dialog/editothervalue.jsp",o,"dialogHeight:200px;dialogWidth:400px;status:0;");
				if(typeof ret != 'undefined'){
					$("#eleothervalueval").val(ret);
				}
			}else{
				//$("#elevalidateval").val("");
			}
			return true;
		}
		//其他元素读写
		function otherreadshow(obj){
				if(typeof obj == 'undefined'){
					obj = document.getElementById("eleotherread");
					obj.checked = true;
				}
				if(obj.checked){
					var o = new Object();
					//o.kjarr = ww.kjarr;
					o.eleotherread = $("#eleotherreadval").val();
					var ret=window.showModalDialog("../dialog/editotherread.jsp",o,"dialogHeight:200px;dialogWidth:400px;status:0;");
					if(typeof ret != 'undefined'){
						$("#eleotherreadval").val(ret);
					}
				}else{
					//$("#elevalidateval").val("");
				}
				return true;
		}
		//其他元素输入
		function otherinputshow(obj){
				if(typeof obj == 'undefined'){
					obj = document.getElementById("eleotherinput");
					obj.checked = true;
				}
				if(obj.checked){
					$("#treleotherinputval").show();
				}else{
					$("#treleotherinputval").hide();
				}
				return true;
		}
		//设置自动生成
		function setAuto(obj){
			if(typeof obj == 'undefined'){
					obj = document.getElementById("auto");
					obj.checked = true;
			}
			if(obj.checked){
				$("#autoprev").show();
				$("#autoprevbtn").show();
			}else{
				$("#autoprev").hide();
				$("#autoprevbtn").hide();
			}
			return true;
		}
		
		
		function selelementtype(obj){
			if(obj.value == 'date'){
				$("#trdateformat").show();
			}else{
				$("#trdateformat").hide();
			}
		}
		
		//设置前置
		function setPrev(obj){
			var o = new Object();
			o.val = $("#autoprev").val();
			var ret=window.showModalDialog("../dialog/editauto.jsp",o,"dialogHeight:300px;dialogWidth:400px;status:0;");
			if(typeof ret != 'undefined'){
				$("#autoprev").val(ret);
			}
		}
	</script>
</body>
</html>
