<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
   		<meta charset="utf-8">
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<meta name="renderer" content="webkit">
	 	<title>文件上传</title>
	 	<link   type="text/css"  href="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.css" rel="stylesheet" />
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/jquery.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/FormUtil.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/DialogUtil.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/validate/jquery.validate.js"></script>
	 	
</head>
<body>
	<div style="width:100%;text-align: center">
		<div style="margin-left:auto;margin-right: auto;padding:5px;">
			<form id="form" class="form-horizontal">
			<input type="hidden" name="datatype" id="datatype" value="char"/>
			<input type="hidden" name="showtype" id="showtype" value="file"/>
				<table class="table table-bordered" >
					<caption style="text-align:center"><h2>文件上传配置</h2></caption>
					<tr>
						<td align="right">
							中文名称(<font color="red">*</font>):
						</td>
						<td align="left">
							<div class="col-xs-6">
							<input type="text" name="cnname" value=""
								id="cnname" class="form-control"  required data-msg-required="不能为空" data-rule-gt="true" data-gt="0">
								
							</div>	
						</td>
					</tr>
					<tr>
						<td align="right">
							英文名称(<font color="red">*</font>):
						</td>
						<td align="left">
							<div class="col-xs-6">
							<input type="text" name="enname" value="" id="enname" class="form-control" onblur="checkTextValid(this)" required data-msg-required="不能为空" data-rule-gt="true" data-gt="0">
							</div>
						</td>
					</tr>
					
					<tr>
						<td align="right">
							类型:
						</td>
						<td align="left">
							<select name="exttype" id="exttype">
								<option value="fix">固定</option>
								<option value="free">自由</option>
								<option value="zhengwen">正文</option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right">
							控件大小:
						</td>
						<td align="left">
								<label for="mheight" class="control-label">高</label>
								<input type="text" style="width:80px;" value="0" name="mheight" />
								</div>
								<label for="mwidth" class="control-label">宽</label>
								<input type="text" style="width:80px;" value="0" name="mwidth" />
								<label for="munit" class="control-label">单位</label>
								<input type="text" style="width:60px;"  value="px" name="munit"/>
							</div>
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
		nodeInfo = {thePlugins : 'extdig-upload',tag:"input",type:"file"};
		//加载初始化
		window.onload = function() {
			//若控件已经存在，则设置回调其值
		    if( UE.plugins[nodeInfo.thePlugins].editdom ){
		        //
		    	oNode = UE.plugins[nodeInfo.thePlugins].editdom;
		       //赋值
		       loadSetValue(oNode);
		        
		    }
		}
		//取消按钮
		dialog.oncancel = function () {
		    if( UE.plugins[nodeInfo.thePlugins].editdom ) {
		        delete UE.plugins[nodeInfo.thePlugins].editdom;
		    }
		};
		//确认
		dialog.onok = function (){
			
            if(!$("#form").valid()){
            	return false;
            }
	        var formData=getFormData("form");
	        updateOrCreateNode(oNode,editor,formData);
            	
		};
		
		
		
		
		
	</script>
</body>
</html>
