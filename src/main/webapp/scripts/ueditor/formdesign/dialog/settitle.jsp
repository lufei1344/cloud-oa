<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="frame" uri="/WEB-INF/tld/framework.tld"%>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
   		<meta charset="utf-8">
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<meta name="renderer" content="webkit">
	 	<title>设置标题</title>
	 	<link   type="text/css"  href="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.css" rel="stylesheet" />
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/jquery.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/FormUtil.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
		<script type="text/javascript">
	
	function exitDialog(){
		
		window.parent.returnValue = $("#expression").val();
		
	}
	dialog.onok = function (){
		exitDialog();
	};
	function init(){
		//本表单
		var arr = getFields();
		if(arr.length>0){
			var $bbd = $("#bbd");
			bbd = arr;
			for(var i=0; i<arr.length; i++){
				var tr = '<tr>'+
						'	<td align="left">&nbsp;&nbsp;<a href="javascript:void(0)" onclick="selbbd('+i+')">'+arr[i].cnname+'</a></td>'
						'</tr>';
				$bbd.after(tr);
			}
		}
		var obj = window.parent.dialogParameter;
		$("#expression").val(obj.val);
	}
	
	
	
	
	//选择本表单
	function selbbd(index){
		var val = "["+bbd[index].cnname+"]";
		insertAtCaret($("#expression")[0],val);
	}
	
	function insertAtCaret(textObj, textFeildValue) {
	    if (document.all) {
	        if (textObj.createTextRange && textObj.caretPos) {
	            var caretPos = textObj.caretPos;
	            caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == '   ' ? textFeildValue + '   ' : textFeildValue;
	        } else {
	            textObj.value = textFeildValue;
	        }
	    } else {
	        if (textObj.setSelectionRange) {
	            var rangeStart = textObj.selectionStart;
	            var rangeEnd = textObj.selectionEnd;
	            var tempStr1 = textObj.value.substring(0, rangeStart);
	            var tempStr2 = textObj.value.substring(rangeEnd);
	            textObj.value = tempStr1 + textFeildValue + tempStr2;
	        } else {
	            alert("This   version   of   Mozilla   based   browser   does   not   support   setSelectionRange");
	        }
	    }
	} 
	
	$(function(){
		
		
		init();
	});
	
</script>
	</head>

	<body>
		<table class="table table-bordered" >
			<tr>
				<td valign="top" width="18%">
					<div style="overflow-y: auto;">
					<table  class="table table-bordered"  >
					<tr  id="bbd"  class="active" align="center">
						<td>本表单</td>
					</tr>
					</table>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="3" align="left">
				&nbsp;&nbsp;&nbsp;&nbsp;表达式：<input id="expression"  class="form-control"/>
				<input type="type" style="width: 80%;display:none;"  />
				</td>
			</tr>
			
		</table>
	</body>
</html>
