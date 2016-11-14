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
			var ids = [];
			$("input[name='auto']:checked").each(function(){
				ids.push(this.value);
			});
			window.parent.returnValue = ids.join(",");
		}
		$(function(){
			init();
		});
		var auto;
		function init(){
			var val = "";
			if(typeof ww != 'undefined'){
				val = ww.val;
			}
			$.getJSON("${pageContext.request.contextPath}/config/form/findAutoPrev",function(data){
				auto = data.auto;
				var depart = data.depart;
				var $table = $("#show");
				var html = "";
				for(var i=0; i<auto.length; i++){
					html += '<tr>'+
							'	<td><input name="auto" value="'+auto[i].id+'" type="checkbox"/></td>'+
							'	<td>'+auto[i].name+'</td>'+
							'	<td>'+auto[i].prev+'</td>'+
							'	<td><a href="javascript:void(0)" onclick="edit('+i+')">*</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="del(this,'+auto[i].id+')">-</a></td>'+
							'</tr>'
				}
				$table.html(html);
				if(val!=undefined){
					var ids = val.split(",");
					for(var i=0; i<ids.length; i++){
						$("input[value='"+ids[i]+"']").attr("checked",true);
					}
				}
				
				var seldepart = document.getElementById("depart");
				seldepart.options.add(new Option("",""));
				for(var i=0; i<depart.length; i++){
					seldepart.options.add(new Option(depart[i].name,depart[i].id));
				}
				
			});
			
			
		}
		var selindex = -1;
		function edit(i){
			$("#depart").val(auto[i].deptid); 
			$("#prev").val(auto[i].prev);
			$("#id").val(auto[i].id);
			
			selindex = i;
		}
		function del(obj,id){
			var o = new Object();
			o.id = id;
			$.getJSON("${pageContext.request.contextPath}/config/form/deleteAutoPrev.html",o,function(data){
				if(data.status){
					$(obj).parent().parent().remove();
				}
			});
		}
		
		
		
		function addPrev(){
			var depart = document.getElementById("depart").value;
			var oid = document.getElementById("id").value;
			var departname =  $("#depart").find("option:selected").text(); 
			var prev = document.getElementById("prev").value;
			if(depart == ""){
				alert("请选择部门");
				return;
			}
			if(prev == ""){
				alert("请输入内容");
				return;
			} 
			var o = new Object();
			o.deptid=depart;
			o.prev = prev;
			o.id = oid;
			var url = "${pageContext.request.contextPath}/config/form/saveAutoPrev";
			$.ajax({
	                cache: true,
	                type: "POST",
	                url:url,
	                data:o,// 你的formid
	                async: false,
	                dataType:'json',
	                error: function(request) {
	                    alert("Connection error");
	                },
	                success: function(data) {
	                	if(data.status){
	                		if(oid != "0"){
	                			auto[selindex].deptid = depart;
	                			auto[selindex].departmentname = departname;
	                			auto[selindex].prev = prev;
	                			
	                			$("#show").find("input[value='"+oid+"']").parent().parent().remove();
	                		}else{
	                			var o = new Object();
	                			o.deptid = depart;
	                			o.id = data.id;
	                			o.departmentname = departname;
	                			o.prev = prev;
	                			auto.push(o);
	                			selindex = auto.length-1;
	                		}
	                		var $table = $("#show");
							var html = "";
							html += '<tr>'+
										'	<td><input name="auto" value="'+auto[selindex].id+'" type="checkbox"/></td>'+
										'	<td>'+departname+'</td>'+
										'	<td>'+prev+'</td>'+
										'	<td><a href="javascript:void(0)" onclick="edit('+selindex+')">*</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="del(this,'+auto[selindex].id+')">-</a></td>'+
										'</tr>'
							$table.append(html);
							
							$("#prev").val("");
							$("#id").val(0);
	                	}else{
	                		alert("保存失败");
	                	}
	                }
	            });
		}
	</script>
	</head>

	<body>
		<input name="elementtype" id="eletype" type="hidden" value="char"/>
		<table class="table table-bordered"  id="base">
			<tr>
				<td colspan="2" valign="top">
					<div style="overflow-y: auto;height:250px;" >
					<table width="100%" id="show"></table>
					</div>
				</td>
			</tr>
			<tr>
				<td>部门：<select   id="depart"/>前缀<input id="prev"  style="width:120px;"/><input type="hidden" id="id" value="0"/></td>
				<td><input type="button" value="添加" class="btn btn-sm btn-primary" onclick="addPrev()"/></td>
			</tr>
		</table>
	</body>
</html>
