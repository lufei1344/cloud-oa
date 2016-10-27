<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 	<title>保存表单</title>
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
				<input type="hidden" name="id" id="id" value="0"/>
				<input type="hidden" name="type" id="type" value="form"/>
				<input type="hidden" name="contentHtml" id="contentHtml"/>
				<table class="table table-bordered" cellspacing="1" cellpadding="1">
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
							描述:
						</td>
						<td align="left">
							<input type="text" name="displayName" value="" id="displayName" class="form-control"  required data-msg-required="不能为空" data-rule-gt="true" data-gt="0"><font color="red">*</font>
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
		   var doc = window.parent.parent;
			alert($("#id",doc).val());
		   $("#name").val($("#name",doc).val());
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
            alert($("#contentHtml").val());
            var url = "${ctxPath}/config/form/update";
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
                	alert(data.msg);
                	
                }
            });
            	
		};
		
		
	</script>
</body>
</html>
