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
		   seltab = $("#myTab li[class='active'] a").attr("id");
			var o = new Object();
			if(seltab == "tsys"){
				o.type = "sys";
				o.show = [];
				$("#radval").find("li").each(function(){
					var oo = new Object();
					var $a = $($(this).find("a:first")[0]);
					oo.type = $a.attr("type");
					oo.show = $a.text();
					oo.key = $a.attr("key");
					o.show.push(oo);
				});
			}
			
			if(seltab == "tsql"){
				o.type = "sql";
				o.sql = $("#sql").val();
			}
			if(seltab == "tdict"){
				o.type = "dict";
				o.dictname = $("#dict_name").val();
			}
			window.parent.returnValue = encodeURIComponent(JSON.stringify(o));
	}
	
	//回填
	function initVal(){
		//本表单
		if(typeof ww != 'undefined'){
			//设置
			var o = ww.selectrule;
			if(o != ""){
				o = decodeURIComponent(o);
				o = string2Object(o);
				if(o.type == "sys"){
					for(var i=0; i<o.show.length; i++){
						var html = "<li><a type='"+o.show[i].type+"'   key='"+o.show[i].key+"'>"+o.show[i].show+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
						$("#radval").append(html);
					}
				}
				if(o.type == "dict"){
					$('#myTab li:eq(1) a').tab('show');
					$("#dict_name").val(o.dictname);
					
				}
				if(o.type == "sql"){
					$('#myTab li:eq(2) a').tab('show');
					$("#sql").val(o.sql);
					
				}
			}
		}
	}
	
	
	$(function(){
		initVal();
	});
	
	//系统变量
	function selxtbl(fh,obj){
		var html = "<li><a type='xtbl'   key='"+fh+"'>"+obj.innerText+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
		$("#radval").append(html);
	}
	//符号
	function addFuhao(obj) {
		var html = "<li><a type='xtfh'   key='"+obj.innerText+"'>"+obj.innerText+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
		$("#radval").append(html);
	}
	//流程变量
	function sellcbl(obj){
		var cl = $("#lcbl").val();
		if(cl == ""){
			alert("请先填写流程变量");
		}else{
			var html = "<li><a type='lcbl'   key='"+cl+"'>"+cl+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
			$("#radval").append(html);
		}
	}
	//删除
	function cls(obj){
		$(obj).parent().remove();
	}
	
	//常量
	function selcl(obj){
		var cl = $("#cl").val();
		var v = $("#clv").val();
		if(v == ""){
			v = cl;
		}
		if(cl == ""){
			alert("请先填写常量值");
		}else{
			var html = "<li><a type='cl'   key='"+v+"'>"+cl+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
			$("#radval").append(html);
			$("#cl").val("");
			$("#clv").val("");
		}
	}
	
	//解析sql
	function parseSql(obj){
		if(obj.value == ""){
			return;
		}
		var sql = obj.value.toUpperCase();
		if(sql.indexOf("SELECT")>=0 && sql.indexOf("FROM")>0){
			var data = getSqlColumns(sql);
			if(data.length != 2){
				alert("语句错误");
			}
		}else{
			alert("语句错误");
		}
	}
	

</script>
</script>
	</head>
	<body style="margin: 0px; padding: 0px; width: 100%;">
		<table style="width: 100%;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="height: 130px;" valign="top">
					<ul id="myTab" class="nav nav-tabs">
						<li class="active">
							<a href="#tabsys" id="tsys" data-toggle="tab">
								依据常量
							</a>
						</li>
						<li><a href="#tabdict" id="tdict" data-toggle="tab">依据字典</a></li>
						<li><a href="#tabsql" id="tsql" data-toggle="tab">依据SQL</a></li>
					</ul>
					<div id="myTabContent" class="tab-content">
						<div class="tab-pane fade in active" id="tabsys">
							<table class="table" style="width: 100%;  font-size: 13px; text-align: center;"
						border="0" cellpadding="0" cellspacing="1"  >
								<tr>
										<td>常量: &nbsp;&nbsp;显示<input id="cl" style="width:60px;" onkeypress="if(event.keyCode==13){selcl(this);};"/>-
										值<input id="clv" style="width:60px;" onkeypress="if(event.keyCode==13){selcl(this);};"/>
										<input type="button" onclick="selcl()" value="确定"/></td>
									</tr>
							</table>	
						</div>
						<div class="tab-pane fade" id="tabdict">
						    <table class="table" style="width: 100%;  font-size: 13px; text-align: center;"
						border="0" cellpadding="0" cellspacing="1"  >
								<tr>
										<td>名称<input id="dict_name" style="width:60px;" />
									</tr>
							</table>	
						</div>
						<div class="tab-pane fade" id="tabsql">
						    例：SELECT ID AS VALUE,NAME FROM DUAL;注name作为显示值，value作为值
							<textarea style="width: 390px;height: 90px;" id="sql" onblur="parseSql(this)"></textarea>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<table class="table" style="width: 400;  font-size: 13px; text-align: center;"
							border="0" cellpadding="5" cellspacing="1">
						<tr>
							<td style="background-color: #dde4ea;" height="10px" align="left">可选值</td>
						</tr>
						<tr>
							<td valign="top"  align="left" style="height: 150px;">
								<ul style="list-style-type: decimal;overflow-y:scorll; " id="radval">
								</ul>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
	</body>
</html>
