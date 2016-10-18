<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 	<title>月份选择器-mini-monthpicker</title>
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
				<table class="table-detail" cellspacing="1" cellpadding="1">
					<caption>月份选择器属性配置</caption>
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
						<th>允许文本输入</th>
						<td>
							<input class="mini-checkbox" name="allowinput" id="allowinput"/>是
						</td>
						<th>
							初始当前时间
						</th>
						<td>
							<input class="mini-checkbox" name="initcurtime" id="initcurtime"/>是
						</td>
						
					</tr>
					<tr>
						<th>
							默认值
						</th>
						<td colspan="3">
							<input class="mini-textbox" name="value" style="width:90%"/>
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

							&nbsp;&nbsp;宽:<input id="mheight" name="mheight" class="mini-spinner" style="width:80px" value="0" minValue="0" maxValue="1200"/>
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

		mini.parse();
		var form=new mini.Form('miniForm');
		//编辑的控件的值
		var oNode = null,
		thePlugins = 'mini-monthpicker';
		
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
		            oNode.setAttribute('class','mini-monthpicker rxc');
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
            oNode.setAttribute('format','yyyy-MM');
            if(isCreate){
	            editor.execCommand('insertHtml',oNode.outerHTML);
            }else{
            	delete UE.plugins[thePlugins].editdom;
            }
            	
		};
		
		
	</script>
</body>
</html>
