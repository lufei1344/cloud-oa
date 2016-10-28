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
			var retobj = "";
			if(ww.datatype == 'char'){
				$table = $("#char").find("table");
				retobj = [];
				$table.find("tr").each(function(){
					var $td = $(this).find("td");
					var o = new Object();
					if($($td[1]).find("input").val() != ""){
						o.lenkey = $($td[1]).find("select").val();
						o.lenval = $($td[1]).find("input").val();
						 
					}
					if($($td[3]).find("input").val() != ""){
						o.conkey = $($td[3]).find("select").val();
						o.conval = $($td[3]).find("input").val();
					}
					o.type = "char";
					retobj.push(o);
				});
			}
			if(ww.datatype == 'num'){
				$table = $("#num").find("table");
				retobj = [];
				$table.find("tr").each(function(){
					var o = new Object();
					var $input = $(this).find("input");
					if($input[0].value != ""){
						o.start = $input[0].value;
					}
					if($input[1].value != ""){
						o.end = $input[1].value;
					}
					o.type = "num";
					retobj.push(o);
				});
			}
			if(ww.datatype == 'date'){
				$table = $("#date").find("table");
				retobj = [];
				$table.find("tr").each(function(){
					var o = new Object();
					var $input = $(this).find("select");
					if($input[0].value != ""){
						o.start = $input[0].value;
					}
					if($input[1].value != ""){
						o.end = $input[1].value;
					}
					o.type = "date";
					retobj.push(o);
				});
			}
			window.parent.returnValue = array2String(retobj);
		}
		function init(){
			//本表单
			if(typeof ww != 'undefined'){
				//
				var datatype = ww.datatype;
				$("#"+datatype).show();
				if(ww.validate != ""){
					var ret = string2Array(ww.validate);
					if(datatype == "char"){
						var $tr = $("#char").find("table tr:first");
						for(var i=0; i<ret.length; i++){
							if(i > 0){
								var $ttr = $tr.clone(true);
								$tr.after($ttr);
								$tr = $ttr;
							}
							if(typeof ret[i].lenkey != 'undefined'){
								$tr.find("select:first").val(ret[i].lenkey);
								$tr.find("input:first").val(ret[i].lenval);
							}
							if(typeof ret[i].conkey != 'undefined'){
								$tr.find("select:last").val(ret[i].conkey);
								$tr.find("input:last").val(ret[i].conval);
							}
						}
				   }else if(datatype == "num"){
				   		var $tr = $("#num").find("table tr:first");
						for(var i=0; i<ret.length; i++){
							if(i > 0){
								var $ttr = $tr.clone(true);
								$tr.after($ttr);
								$tr = $ttr;
							}
							$tr.find("input:first").val(ret[i].start);
							$tr.find("input:last").val(ret[i].end);
						}
				   }else  if(datatype == "date"){
				   		var $tr = $("#date").find("table tr:first");
						for(var i=0; i<ret.length; i++){
							if(i > 0){
								var $ttr = $tr.clone(true);
								$tr.after($ttr);
								$tr = $ttr;
							}
							$tr.find("select:first").val(ret[i].start);
							$tr.find("select:last").val(ret[i].end);
						}
				   }
					
				}
				
			}
			
		}
		
		function add(obj){
			var $tr = $(obj).parent().parent();
			var $v = $("<tr>"+$tr.html()+"</tr>");
			$tr.after($v);
			//
			$v.find("input").val("");
			$($v.find("a")[0]).remove();
			
		}
		function del(obj){
			$(obj).parent().parent().remove();
		}
		$(function(){
			init();
		});
		
	</script>
	</head>

	<body>
		<table class="table table-bordered" id="base">
			<tr id="char" style="display: none;">
				<td style="background-color: #dde4ea;height: 200px;">文本</td>
				<td  align="left" valign="top">
					<div style="overflow-y: scroll;height: 100%;">
					<table style="width: 100%; font-size: 13px; text-align: center;"
			border="0" cellpadding="5" cellspacing="1" bordercolor="gray" >
					<tr>
						<td>长度</td>
						<td>
							<select style="width: 50px;">
								<option value="==">=</option>
								<option value="&lt;">&lt;</option>
								<option value="&gt;">&gt;</option>
								<option value="!=">!=</option>
								<option value="&lt;=">&lt;=</option>
								<option value="&gt;=">&gt;=</option>
							</select>
							<input style="width: 60px;"/>
						</td>
						<td>内容</td>
						<td>
							<select style="width: 50px;">
								<option value="notnull">不为空</option>
								<option value="like">like</option>
								<option value="notlike">notlike</option>
								<option value="start">以*开始</option>
								<option value="end">以*结束</option>
							</select>
							<input style="width: 60px;"/>
						</td>
						<td>
						&nbsp;<a href="javascript:void(0)" style="font-size:14px;" onclick="add(this)">+</a>&nbsp;<a style="font-size:14px;" href="javascript:void(0)" onclick="del(this)">-</a>
						</td>
					</tr>
					</table>
					</div>
				</td>
			</tr>	
			<tr id="num" style="display: none;">
				<td style="background-color: #dde4ea;height: 200px;" >数值</td>
				<td align="left" valign="top">
					<div style="overflow-y: scroll;height: 100%;">
					<table style="width: 100%; font-size: 13px; text-align: center;"
			border="0" cellpadding="5" cellspacing="1" bordercolor="gray" >
					<tr>
						<td>在<input style="width: 60px;"/>~<input style="width: 60px;"/>间
						&nbsp;<a href="javascript:void(0)" style="font-size:14px;" onclick="add(this)">+</a>&nbsp;<a style="font-size:14px;" href="javascript:void(0)" onclick="del(this)">-</a>
						</td>
					</tr>
					</table>
					</div>
				</td>
			</tr>	
			<tr id="date" style="display: none;">
				<td style="background-color: #dde4ea;height: 200px;" >日期</td>
				<td align="left" valign="top">
					<div style="overflow-y: scroll;height: 100%;">
					<table style="width: 100%;  font-size: 13px; text-align: center;"
			border="0" cellpadding="5" cellspacing="1" bordercolor="gray" >
					<tr>
						<td>在
							<select>
								<option value=""></option>
								<option value="当前日期">当前日期</option>
								<option value="上月当日">上月当日</option>
								<option value="去年当日">去年当日</option>
								<option value="下月当日">下月当日</option>
								<option value="明年当日">明年当日</option>
								<option value="上月初">上月初</option>
								<option value="本月初">本月初</option>
								<option value="下月初">下月初</option>
								<option value="去年初">去年初</option>
								<option value="本年初">本年初</option>
								<option value="明年初">明年初</option>
							</select>~
							<select>
								<option value=""></option>
								<option value="当前日期">当前日期</option>
								<option value="上月当日">上月当日</option>
								<option value="去年当日">去年当日</option>
								<option value="下月当日">下月当日</option>
								<option value="明年当日">明年当日</option>
								<option value="上月末">上月末</option>
								<option value="本月末">本月末</option>
								<option value="下月末">下月末</option>
								<option value="去年末">去年末</option>
								<option value="本年末">本年末</option>
								<option value="明年末">明年末</option>
							</select>间
							&nbsp;<a href="javascript:void(0)" style="font-size:14px;" onclick="add(this)">+</a>&nbsp;<a style="font-size:14px;" href="javascript:void(0)" onclick="del(this)">-</a>
							</td>
					</tr>
					</table>
					<div style="overflow-y: scroll;height: 100%;">
				</td>
			</tr>	
		</table>
	</body>
</html>
