<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
   		<meta charset="utf-8">
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<meta name="renderer" content="webkit">
	 	<title>单选框</title>
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
			<input type="hidden" name="showtype" id="showtype" value="input"/>
			<input type="hidden" name="exttype" id="exttype" value="radio"/>
				<table class="table table-bordered" >
					<caption style="text-align:center"><h2>单选框属性配置</h2></caption>
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
							默认值:
						</td>
						<td align="left">
							<input type="hidden" id="defaultvalue" value="" name="defaultvalue"/>&nbsp;&nbsp;
							<span id="defaultvalueexp"></span>
							<input type="button" onclick="setDefaultValue(this)" class="btn btn-sm btn-info" value="..."/>
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
					<tr>
						<td colspan="2" align="left">
							<input type="checkbox" id="chkvalidate" onclick="setValidate(this)"  name="chkvalidate"/>
							<a href="javascript:void(0)" onclick="setValidate()">设置校验规则</a>
							<input type="hidden" name="validate" id="validate"/>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="left">
							<input type="checkbox" id="chkselectrule" name="chkselectrule" onclick="setSelectRule(this)"/><a href="javascript:void(0)" onclick="setSelectRule()">设置输入选择</a>
							<input type="hidden" name="selectrule" id="selectrule"/>
						</td>
						
					</tr>
					<tr>
						<td colspan="2" align="left">
							<input type="checkbox" id="chkothervalue" onclick="othervalueshow(this)" name="chkothervalue" /><a href="javascript:void(0)" onclick="othervalueshow()">影响其他元素的值</a>
							<input type="hidden" name="othervalue" id="eleothervalueval"/>
						</td>
						
					</tr>
					<tr>
						<td colspan="2" align="left">
							<input type="checkbox" id="chkotherread" name="chkotherread"  onclick="otherreadshow(this)"/><a href="javascript:void(0)" onclick="otherreadshow()">影响其他元素的读写属性</a>
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
		nodeInfo = {thePlugins : 'extdig-radio',tag:"input",type:"radio"};
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
