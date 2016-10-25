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
	 	<link   type="text/css"  href="${ctxPath}/scripts/ueditor/formdesign/validate/bootstrapValidator.min.css" rel="stylesheet" />
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/validate/bootstrapValidator.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/FormUtil.js"></script>
</head>
<body>
	<div style="width:100%;text-align: center">
		<div style="margin-left:auto;margin-right: auto;padding:5px;">
			<form id="form">
				<table class="table table-bordered" cellspacing="1" cellpadding="1">
					<caption>文本框属性配置</caption>
					<tr>
						<th>字段备注*</th>
						<td>
							<input class="form-control" name="label"   style="width:90%" minlength="2" type="text" class="form-control" required="" aria-required="true" />
						</td>
						<th>字段标识*</th>
						<td>
							<input name="name" class="form-control" url="${ctxPath}/bpm/bm/bpmFormModel/getModelAttTree.do?modelId=${param['modelId']}" multiSelect="false"  valueFromSelect="false" emptytext="请输入字段标识，为英文开头或与数字组合" style="width:90%"
						        textField="key" valueField="key" parentField="parentId"  allowInput="true" onvalidation="onKeyValidation" required="true"
						        onvaluechanged="fieldChange"
						        showRadioButton="true" showFolderCheckBox="false"/>
						</td>
					</tr>
					<tr>
						<th>字符长度</th>
						<td colspan="3">
							<input id="minlen" name="minlen" class="form-control"  minValue="0" maxValue="50" value="0" />&nbsp;-&nbsp;<input id="maxlen" name="maxlen" class="mini-spinner"  minValue="1" maxValue="1024" value="50" />
						</td>
					</tr>
					<tr>
						<th>校验规则</th>
						<td>
							<input name="onvalidation" class="form-control" style="width:80%" textField="name" valueField="value" 
		    				url="${ctxPath}/sys/core/sysDic/getByDicKey.do?dicKey=_FieldValidateRule"  allowInput="false" showNullItem="true" nullItemText="请选择..."/>
						</td>
						<th>必填*</th>
						<td>
							<input class="form-control" name="required" id="required"/>是
						</td>
					</tr>
					<tr>
						<th>允许文本输入</th>
						<td>
							<input class="form-control" name="allowinput" id="allowinput" value="true"/>是
						</td>
						<th>
							默认值
						</th>
						<td>
							<input class="form-control" name="value" style="width:90%"/>
						</td>
					</tr>
					<tr>
						<th>
							控件长
						</th>
						<td colspan="3">
							<input id="mwidth" name="mwidth" class="mini-spinner" style="width:80px" value="0" minValue="0" maxValue="1200"/>
							
							<input id="wunit" name="wunit" class="mini-combobox" style="width:50px" onvaluechanged="changeMinMaxWidth"
							data="[{'id':'px','text':'px'},{'id':'%','text':'%'}]" textField="text" valueField="id"
						    value="px"  required="true" allowInput="false" />

							&nbsp;&nbsp;高:<input id="mheight" name="mheight" class="mini-spinner" style="width:80px" value="0" minValue="0" maxValue="1200"/>
							<input id="hunit" name="hunit" class="mini-combobox" style="width:50px" onvaluechanged="changeMinMaxHeight"
							data="[{'id':'px','text':'px'},{'id':'%','text':'%'}]" textField="text" valueField="id"
						    value="px"  required="true" allowInput="false" />
						    
						</td>
					</tr>
				</table>
			</form>
			</div>
	</div>
	<script type="text/javascript">
	$("#form").bootstrapValidator({  
        message: 'This value is not valid',  
        //反馈图标  
        feedbackIcons:faIcon,  
        fields: {  
        	label:{  
                message:'登录名无效',  
                validators:{  
                    notEmpty:{  
                        message:'登录名不能为空'  
                    },  
                    StringLength:{  
                        min:5,  
                        max:30,  
                        message:'用户名长度大于6位并且小于30位'  
                    },  
                    regexp:{  
                        regexp:/^[a-zA-Z0-9_]+$/,  
                        message:'用户名只能由字母、数字和下划线'  
                    }  
                }  
            }  
        }  
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
			 $('#form').data('bootstrapValidator').validate();  
            if(!$('#form').data('bootstrapValidator').isValid()){  
                return ;  
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
            	style+="width:"+formData.mwidth+formData.wunit;
            }
            if(formData.mheight!=0){
            	if(style!=""){
            		style+=";";
            	}
            	style+="height:"+formData.mheight+formData.hunit;
            }
            oNode.setAttribute('style',style);
            
            if(isCreate){
	            editor.execCommand('insertHtml',oNode.outerHTML);
            }else{
            	delete UE.plugins[thePlugins].editdom;
            }
            	
		};
		
		
	</script>
</body>
</html>
