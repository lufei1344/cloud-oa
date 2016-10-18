<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 	<title>复选框-mini-checkbox</title>
	 	<script src="${ctxPath}/scripts/boot.js" type="text/javascript"></script>
	 	<script src="${ctxPath}/scripts/common/form.js" type="text/javascript"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/form-design/config/plugin-libs.js"></script>
	 	<link href="${ctxPath}/styles/form.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<div style="width:100%;text-align: center">
		<div style="margin-left:auto;margin-right: auto;padding:5px;">
			<form id="miniForm">
				<table class="table-detail" cellspacing="0" cellpadding="1">
					<caption>复选框属性配置</caption>
					<tr>
						<th>字段备注*</th>
						<td>
							<input class="mini-textbox" name="label" required="true" vtype="maxLength:100,chinese"  style="width:90%" emptytext="请输入字段备注" />
						</td>
						<th>字段标识*</th>
						<td>
							<input name="name" class="mini-treeselect" url="${ctxPath}/bpm/bm/bpmFormModel/getModelAttTree.do?modelId=${param['modelId']}" multiSelect="false"  valueFromSelect="false" emptytext="请输入字段标识，为英文开头或与数字组合" style="width:90%"
						        textField="key" valueField="key" parentField="parentId"  allowInput="true" onvalidation="onKeyValidation" required="true"
						        onvaluechanged="fieldChange"
						        showRadioButton="true" showFolderCheckBox="false"/>
							
						</td>
					</tr>
					<tr>
						<th>
							默认值
						</th>
						<td colspan="3">
							<div name="value" class="mini-checkbox" checked="true" readOnly="false" text="是否选中"></div>
						</td>
					</tr>
				</table>
			</form>
			</div>
	</div>
	<script type="text/javascript">
	
		function createElement(type, name){     
		    var element = null;     
		    try {        
		        element = document.createElement('<'+type+' name="'+name+'" type="checkbox">');     
		    } catch (e) {}   
		    if(element==null) {     
		        element = document.createElement(type);     
		        element.name = name;     
		    } 
		    return element;     
		}
		
		mini.parse();
		var form=new mini.Form('miniForm');
		//编辑的控件的值
		var oNode = null,
		thePlugins = 'mini-checkbox';
		
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
		        
		        form.setData(formData);
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
			form.validate();
	        if (form.isValid() == false) {
	            return false;
	        }
	        
	        var formData=form.getData();
	        var isCreate=false;
		    //控件尚未存在，则创建新的控件，否则进行更新
		    if( !oNode ) {
		        try {
		            oNode = createElement('input',name);
		            oNode.setAttribute('class','mini-checkbox rxc');
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
		    
		  	
		    for(var key in formData){
            	oNode.setAttribute(key,formData[key]);
            }
   
            if(isCreate){
	            editor.execCommand('insertHtml',oNode.outerHTML);
            }else{
            	delete UE.plugins[thePlugins].editdom;
            }
            	
		};
		
	</script>
</body>
</html>
