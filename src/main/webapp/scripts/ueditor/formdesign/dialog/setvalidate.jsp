<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
   		<meta charset="utf-8">
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<meta name="renderer" content="webkit">
	 	<title>默认值设置</title>
	 	<link   type="text/css"  href="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.css" rel="stylesheet" />
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/jquery.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/FormUtil.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
		<script type="text/javascript">
		var ww=window.parent.dialogParameter;
		dialog.onok = function (){
			exitDialog();
		};
		function exitDialog(){
			var valid = [];
			//系统
			$("input[name='valid']:checked").each(function(){
				valid.push({name:$(this).attr("showname"),exp:this.value,type:'sys'});
			});
			//自定义
			$("#zdy tr").each(function(index){
				if(index >0){
					var name = $(this).find("input[name='name']").val();
					var exp = $(this).find("input[name='exp']").val();
					if(name != "" && exp != ""){
						valid.push({name:name,exp:exp,type:'zdy'});
					}
				}
			});
			window.parent.returnValue = array2String(valid);
		}
		function init(){
			//本表单
			if(typeof ww != 'undefined'){
				//
				if(ww.validate != ""){
					var valid = string2Object(ww.validate);
					for(var i=0; i<valid.length; i++){
						if(valid[i].type == "sys"){
							$("input[showname='"+valid[i].name+"']")[0].checked = true;
						}else{
							addZDY();
							var $tr = $("#zdy tr").last();
							$tr.find("input[name='name']").val(valid[i].name);
							$tr.find("input[name='exp']").val(valid[i].exp);
						}
						
					}
				}
				
			}
			
		}
		function initUi(){
			var valid = [];
			valid.push({name:"非空",exp:"^$"});
			valid.push({name:"全部字母",exp:"^[a-zA-Z\_]+$"});
			valid.push({name:"全部中文",exp:"^[\u4e00-\u9fa5]+$"});
			valid.push({name:"字母数字",exp:"^[0-9a-zA-Z\_]+$"});
			valid.push({name:"RUL",exp:"^[a-zA-z]+://[^\s]*$"});
			valid.push({name:"EMail",exp:"^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$"});
			valid.push({name:"整数",exp:"^-?[1-9]\d*$"});
			valid.push({name:"正整数",exp:"^[1-9]\d*$"});
			valid.push({name:"负整数",exp:"^-[1-9]\d*$"});
			valid.push({name:"浮点数",exp:"^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$"});
			valid.push({name:"邮政编码",exp:"^[1-9]\d{5}(?!\d)$"});
			valid.push({name:"固定电话",exp:"^\d{3}-\d{8}|\d{4}-\d{7}$"});
			valid.push({name:"手机号码",exp:"^((13[0-9])|(15[^4,\\D])|(18[0,2,5-9]))\\d{8}$"});
			valid.push({name:"IP地址",exp:"^\d+\.\d+\.\d+\.\d+$"});
			valid.push({name:"是否英文",exp:"^[a-zA-Z\_]+$"});
			valid.push({name:"是否英文",exp:"^[a-zA-Z\_]+$"});
			var $td = $("#exp");
			var html = "";
			for(var i=0; i<valid.length; i++){
				html += '<input type="checkbox" value="'+valid[i].exp+'" showname="'+valid[i].name+'" name="valid"/>'+valid[i].name+"&nbsp;&nbsp;";
			}
			$td.html(html);
		}
		$(function(){
			initUi();
			init();
		});
		
		function addZDY(){
			var html = '<tr>'+
					   '	<td>'+
					   '		名称：<input name="name" value=""/>'+
					   '	表达式：<input name="exp" value=""/>'+
					   '	<input type="button" value="-" onclick="delZDY(this)"/>'+
					   '	</td>'+
					   '</tr>';
			$("#zdy").append(html);
		}
		function delZDY(obj){
			$(obj).parent().parent().remove();
		}
	</script>
	</head>

	<body>
		<table class="table table-bordered" >
			<tr>
				<td id="exp"></td>
			</tr>
			<tr>
				<td>
					<div style="width:100%;height:180px;overflow-y: scroll;">
						<table class="table table-bordered" id="zdy">
							<tr>
								<td><input type="button" value="自定义" onclick="addZDY()"/></td>
							</tr>
							
						</table>
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
