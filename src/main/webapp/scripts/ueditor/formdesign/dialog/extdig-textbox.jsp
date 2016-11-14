<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
   		<meta charset="utf-8">
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<meta name="renderer" content="webkit">
	 	<title>文本框-textbox</title>
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
			<input type="hidden" name="showtype" id="showtype" value="input"/>
				<table class="table table-bordered" >
					<caption style="text-align:center"><h2>文本框属性配置</h2></caption>
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
							数据类型:
						</td>
						<td align="left">
							<div class="col-xs-4">
							<select name="datatype"  id="datatype" class="form-control" onchange="selelementtype(this)">
								<option value="char">文本</option>
								<option value="num">数值</option>
								<option value="date">日期</option>
							</select>
							</div>
							<input name="auto" id="auto" type="checkbox"  onclick="setAuto(this)"  />
							前缀<input style="display:none;width:60px;" name="autoprev" id="autoprev" value="" >
							<input style="display:none;" id="autoprevbtn" class="btn btn-sm btn-info" type="button" value="..." onclick="setPrev(this)"/>
							<input name="autotype" id="autotype"  type="checkbox"  />自动取号
							
						</td>
					</tr>
					<tr id="trdateformat" style="display: none;">
						<td align="right">
							日期格式:
						</td>
						<td align="left">
							<div class="col-xs-6">
							<input  name="dateformat" id="dateformat" class="form-control" value="yyyy年MM月dd日" /><br/>
							yyyy年MM月dd日 HH时mm分ss秒
							</div>
						</td>
					</tr>
					<tr>
						<td align="right">
							显示类型:
						</td>
						<td align="left">
							<div class="col-xs-4">
							<select name="exttype"  class="form-control" id="exttype">
								<option value="input">输入框</option>
								<option value="user">人员</option>
								<option value="dept">部门</option>
							</select>
							</div>
							标题显示:
							<input type="checkbox"  name="showtitle" id="showtitle"/>
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
		nodeInfo = {thePlugins : 'extdig-textbox',tag:"input",type:"input"};
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
		
		
	</script>
</body>
</html>
