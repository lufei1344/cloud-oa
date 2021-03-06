<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="frame" uri="/WEB-INF/tld/framework.tld"%>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 	<title>保存表单</title>
	 	<link   type="text/css"  href="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.css" rel="stylesheet" />
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/jquery.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/FormUtil.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/validate/jquery.validate.js"></script>
	 	
</head>
<body>
	<div style="width:100%;text-align: center">
		<div style="margin-left:auto;margin-right: auto;padding:5px;">
			<form id="form" class="form">
				<input type="hidden" name="id" id="id" value="0"/>
				<input type="hidden" name="type" id="type" value="html"/>
				<input type="hidden" name="contentHtml" id="contentHtml"/>
				<table class="table table-bordered" >
					<caption style="text-align:center;"><h2>文本框属性配置</h2></caption>
					<tr>
						<td align="right">
							名称:
						</td>
						<td align="left">
							<input type="text" name="name" value=""
								id="name" class="form-control"  required data-msg-required="不能为空" data-rule-gt="true" data-gt="0"><font color="red">*</font>
							
						</td>
					</tr>
					<tr>
						<td align="right">
							类别:
						</td>
						<td align="left">
							<frame:select name="formType" cssClass="form-control" style="width:120px;" type="select" configName="formType" displayType="0" value="" />&nbsp;
						</td>
					</tr>
					<tr>
						<td align="right">
							描述:
						</td>
						<td align="left">
							<input type="text" name="displayName" value="" id="displayName" class="form-control"  required data-msg-required="不能为空" data-rule-gt="true" data-gt="0"><font color="red">*</font>
						</td>
					</tr>
					<tr>
						<td align="right">
							标题:
						</td>
						<td align="left">
							<input type="text" name="showTitle" value="" id="showTitle" class="form-control"  required data-msg-required="不能为空" data-rule-gt="true" data-gt="0">
							<input type="button" class="btn btn-sm btn-primary" onclick="setTitle()" value="选择"/>
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
		window.onload = function() {
			//若控件已经存在，则设置回调其值
		   var doc = window.parent.document;
		   $("#id").val($("#id",doc).val())	 
		   $("#name").val($("#name",doc).val());
		   $("#displayName").val($("#displayName",doc).val());
		   $("#formType").val($("#formType",doc).val());
		}
		//编辑的控件的值
		var oNode = null,
		thePlugins = 'extdig-save';
		
		//取消按钮
		dialog.oncancel = function () {
		    if( UE.plugins[thePlugins].editdom ) {
		        delete UE.plugins[thePlugins].editdom;
		    }
		};
		//确认
		dialog.onok = function (){
			
            if(!$("#form").valid()){
            	return false;
            }
            $("#contentHtml").val(editor.getContent());
            var url = "${ctxPath}/form/update";
			$.ajax({
                cache: true,
                type: "POST",
                url:url,
                data:$('#form').serialize(),// 你的formid
                async: false,
                dataType:'json',
                error: function(request) {
                    alert("Connection error");
                },
                success: function(data) {
                	if(data.status == 1){
                		alert("保存成功！");
                	}else{
                		alert("保存失败！");
                	}
                	
                }
            });
            	
		};
		
		//设置前置
		function setTitle(obj){
			var o = new Object();
			o.val = $("#showTitle").val();
			var dialog = new UE.ui.Dialog({
				iframeUrl:editor.options.UEDITOR_HOME_URL + UE.FormDesignBaseUrl+'/dialog/settitle.jsp',
				name:"default",
				editor:editor,
				title: '设置标题',
				cssRules:"width:600px;height:300px;",
				buttons:[
				{
					className:'edui-okbutton',
					label:'确定',
					onclick:function () {
						dialog.close(true);
						var ret = window.parent.returnValue;
						if(typeof ret != 'undefined'){
							$("#showTitle").val(ret);
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
	</script>
</body>
</html>
