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
		<style type="text/css">
			a{
				text-decoration: none;
			}
			#tabContainer
        {
            padding:2px;
            width:310px;
        }
        #tabContainer li
        {
            float: left;
            width: 80px;
            margin: 0 3px;
            background: #ffffff;
            text-align: center;
            border:1px solid #ccc;
        }
        #tabContainer div
        {
            border:1px solid #ccc;
            height:94px;
            width:392px;
        }
        #tabContainer a
        {
            display: block;
        }
        #tabContainer a.on
        {
            background: #dde4ea;
        }
        
        .table{ background:#dde4ea}
		.table td{ background:#FFF}
		.a{ text-decoration: none;display:inline;}
		</style>
		<script type="text/javascript">
	var ww=window.parent.dialogParameter;
	
	var seltab = "objcolumn";
	function extDialog(){
		if(seltab == "objcolumn"){
			var o = new Object();
			o.type = "obj";
			o.obj = $("#objcolumnobj").val();
			o.sql = $("#objsql").val();
			o.cond = $("#objcolumncon").val();
			var table = document.getElementById("objcolumn");
			//显示回传
			var show = [];
			for(var i=1; i<table.rows.length; i++){
				var oo = new Object();
				oo.column = table.rows[i].cells[0].innerText;
				oo.show = $(table.rows[i].cells[1]).find("input")[0].checked;
				oo.back = $(table.rows[i].cells[2]).find("input")[0].checked;
				show.push(oo);
			}
			o.show = show;
			//值设置
			var valset = [];
			table = document.getElementById("objcolumnval");
			for(var i=1; i<table.rows.length; i++){
				var oo = new Object();
				oo.column = table.rows[i].cells[0].getAttribute("elementid");
				oo.columnname = table.rows[i].cells[0].innerText;
				oo.elementid = $(table.rows[i].cells[1]).find("select").length==0 ? "" : $(table.rows[i].cells[1]).find("select")[0].value;
				valset.push(oo); 
			}
			o.valset = valset;
			window.parent.returnValue = encodeURIComponent(JSON.stringify(o));
		}
		//表单
		if(seltab == "formcolumn"){
			var o = new Object();
			o.type = "form";
			o.gid = $("#group").val()
			o.fid = $("#form").val();
			o.cond = $("#formcolumncon").val();
			var table = document.getElementById("formcolumn");
			//显示回传
			var show = [];
			for(var i=1; i<table.rows.length; i++){
				var oo = new Object();
				oo.column = table.rows[i].getAttribute("elementid");
				oo.show = $(table.rows[i].cells[1]).find("input")[0].checked;
				oo.back = $(table.rows[i].cells[2]).find("input")[0].checked;
				show.push(oo);
			}
			o.show = show;
			//值设置
			var valset = [];
			table = document.getElementById("formcolumnval");
			for(var i=1; i<table.rows.length; i++){
				var oo = new Object();
				oo.column = table.rows[i].cells[0].getAttribute("elementid");
				oo.columnname = table.rows[i].cells[0].innerText;
				oo.elementid = $(table.rows[i].cells[1]).find("select").length==0 ? "" : $(table.rows[i].cells[1]).find("select")[0].value;
				valset.push(oo); 
			}
			o.valset = valset;
			
			window.parent.returnValue = encodeURIComponent(JSON.stringify(o));	
		}
		//sql
		if(seltab == "sqlcolumn"){
			var o = new Object();
			o.type = "sql";
			//o.sql = encodeURIComponent($("#sql").val());
			o.sql = $("#sql").val();
			var table = document.getElementById("sqlcolumn");
			//显示回传
			var show = [];
			for(var i=1; i<table.rows.length; i++){
				var oo = new Object();
				oo.column = table.rows[i].cells[0].innerText;
				oo.show = $(table.rows[i].cells[1]).find("input")[0].checked;
				oo.back = $(table.rows[i].cells[2]).find("input")[0].checked;
				show.push(oo);
			}
			o.show = show;
			//值设置
			var valset = [];
			table = document.getElementById("sqlcolumnval");
			for(var i=1; i<table.rows.length; i++){
				var oo = new Object();
				oo.column = table.rows[i].cells[0].getAttribute("elementid");
				//alert(oo.column);
				oo.columnname = table.rows[i].cells[0].innerText;
				oo.elementid = $(table.rows[i].cells[1]).find("select").length==0 ? "" : $(table.rows[i].cells[1]).find("select")[0].value;
				valset.push(oo); 
			}
			o.valset = valset;
			window.parent.returnValue = encodeURIComponent(JSON.stringify(o));
		}
		
	}
	var kjarr,selecthtml="";
	function initValue(){
		//本表单
		if(typeof ww != 'undefined'){
			kjarr = getFileds();
			if(kjarr.length>0){
				selecthtml = "<select>"
				selecthtml = selecthtml+"<option value=''>表单</option>"
				for(var i=0; i<kjarr.length; i++){
					selecthtml = selecthtml+"<option value='"+kjarr[i].enname+"'>"+kjarr[i].cnname+"</option>"
				}
				selecthtml = selecthtml + "</select>";
			}
			//设置
			var o = ww.selectrule;
			//alert(o);
			if(o != ""){
				o = decodeURIComponent(o);
				o = JSON.parse(o);
				//alert(o.type);
				if(o.type == "obj"){
					//tab
					switchTab('tab1','con1','objcolumn');
					
					$("#objcolumnobj").val(o.obj);
					$("#objcolumncon").val(o.cond);
					$("#objsql").val(o.sql);
					var table = document.getElementById("objcolumn");
					//显示回传
					for(var i=0; i<o.show.length; i++){
						var oo = o.show[i];
						var html = '<tr>'+
									'	<td>'+oo.column+'</td>'+
									'	<td><input type="checkbox" /></td>'+
									'	<td><input type="checkbox"   onclick="selval(this,\'objcolumn\',\''+oo.column+'\')" show="objcolumn" value="'+oo.column+'"/></td>'+
									'</tr>';
						var $html = $(html);
						$html.find("input")[0].checked = oo.show;	
						$html.find("input")[1].checked = oo.back;		
						$(table).append($html);	
					}
					
					//值设置
					table = document.getElementById("objcolumnval");
					for(var i=0; i<o.valset.length; i++){
						var oo = o.valset[i];
						var html = '<tr>'+
							'	<td elementid="'+oo.column+'">'+oo.columnname+'</td>'+
							'	<td>'+selecthtml+'</td>'+
							'</tr>';
						 var $html = $(html);
						 $html.find("select").val(oo.elementid);							
						 $(table).append($html);			
					}
				}
				if(o.type == "form"){
					switchTab('tab2','con2','formcolumn');
				
					 $("#group").val(o.gid);
					$("#form").val(o.fid);
					$("#formcolumncon").val(o.cond);
					selForm(document.getElementById("group"),o);
					
					
					
					//值设置
					table = document.getElementById("formcolumnval");
					for(var i=0; i<o.valset.length; i++){
						var oo = o.valset[i];
						var html = '<tr>'+
							'	<td elementid="'+oo.column+'">'+oo.columnname+'</td>'+
							'	<td>'+selecthtml+'</td>'+
							'</tr>';
						 var $html = $(html);
						 $html.find("select").val(oo.elementid);							
						 $(table).append($html);			
					}
				}
				if(o.type == "sql"){
					switchTab('tab3','con3','sqlcolumn');
				
					$("#sql").val(o.sql);
					var table = document.getElementById("sqlcolumn");
					//显示回传
					for(var i=0; i<o.show.length; i++){
						var oo = o.show[i];
						var html = '<tr>'+
									'	<td>'+oo.column+'</td>'+
									'	<td><input type="checkbox" /></td>'+
									'	<td><input type="checkbox"   onclick="selval(this,\'sqlcolumn\',\''+oo.column+'\')" show="sqlcolumn" value="'+oo.column+'"/></td>'+
									'</tr>';
									
						var $html = $(html);
						$html.find("input")[0].checked = oo.show;	
						$html.find("input")[1].checked = oo.back;		
						$(table).append($html);	
					}
					
					//值设置
					table = document.getElementById("sqlcolumnval");
					for(var i=0; i<o.valset.length; i++){
						var oo = o.valset[i];
						var html = '<tr>'+
							'	<td elementid="'+oo.column+'">'+oo.columnname+'</td>'+
							'	<td>'+selecthtml+'</td>'+
							'</tr>';
						 var $html = $(html);
						 $html.find("select").val(oo.elementid);							
						 $(table).append($html);			
					}
				}
			}
		}
	}
	function init(){
		
		//引用表单
		$.getJSON("${pageContext.request.contextPath}/allFormGroup.html",function(data){
			var group = document.getElementById("group");
			for(var i=0; i<data.length; i++){
				group.options.add(new Option(data[i].g_name,data[i].id));
			}
			if(typeof ww.gid != 'undefined' && ww.gid != ""){
				group.value = ww.gid;
			}
			initValue();
		});
	}
	function selForm(obj,o){
		if(obj.value != 0){
			$.getJSON("${pageContext.request.contextPath}/findForm.html?type=json&gid="+obj.value,function(data){
				var group = document.getElementById("form");
				group.options.length=0;
				group.options.add(new Option("表单",0));
				for(var i=0; i<data.length; i++){
					group.options.add(new Option(data[i].f_name,data[i].id));
				}
				if(typeof o != 'undefined'){
					group.value = o.fid;
					selFormEelment(group,o);
				}
			});
		}
	}
	//表单元素
	function selFormEelment(obj,o){
		if(obj.value == 0){
			return;
		}
		$.getJSON("${pageContext.request.contextPath}/findFormElement.html?fid="+obj.value,function(data){
			var $yybd = $("#formcolumn");
			var show = "formcolumn";
			$yybd.find("tr").each(function(i,data){
				if(i > 0){
					$(this).remove();
				}
			});
			if(typeof o == 'undefined'){
				$("#formcolumnval").find("tr").each(function(i,data){
					if(i > 0){
						$(this).remove();
					}
				});
			}
			for(var i=0; i<data.length; i++){
				var html = '<tr fid='+data[i].f_id+' eid='+data[i].id+' elementid=\''+data[i].e_english_name+'\'>'+
							'	<td>'+data[i].e_name+'</td>'+
							'	<td><input type="checkbox"/></td>'+
							'	<td><input type="checkbox" onclick="selval(this,\''+show+'\',\''+data[i].e_english_name+'\')" show="'+show+'" value="'+data[i].e_name+'"/></td>'+
							'</tr>';
				var $html = $(html);			
				if(typeof o != 'undefined'){
					$html.find("input")[0].checked = o.show[i].show;
					$html.find("input")[1].checked = o.show[i].back;
				}			
				$("#"+show).append($html);	
			}
		});
	}
	$(function(){
		init();
		allanduall();
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
		if(cl == ""){
			alert("请先填写常量值");
		}else{
			var html = "<li><a type='cl'   key='"+cl+"'>"+cl+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
			$("#radval").append(html);
		}
	}
	
	//解析sql
	function jiexi(obj){
		var sql = obj.value.toUpperCase();
		if(sql == ""){
			return;
		}
		if(sql.indexOf("SELECT")>=0 && sql.indexOf("FROM")>0){
			getColumnName(sql,'sqlcolumn');
		}else{
			alert("语句错误");
		}
	}
	//选择系统对象
	function sysObject(tab){
		$("#objcolumnobj").val(tab);
		var sql = "";
		if(tab == "tab_userinfo"){
			sql = "select username username#姓名,sex sex#性别,usernumber usernumber#号码,addresses addresses#地址,email email#邮箱,mobile mobile#手机,tel tel#电话,companyname companyname#公司名,companyaddress companyaddress#公司地址,companytel companytel#公司电话 from tab_userinfo";
		}
		if(tab == "tab_department"){
			sql = "select departmentname departmentname#部门名称,departmanager departmanager#负责人,remark remark#备注 from tab_department";
		}
		if(tab == "tf_flow"){
			sql = "select f_name f_name#名称,f_createuser f_createuser#创建人,f_createtime f_createtime#创建时间,f_version f_version#版本 from  tf_flow";
		}
		if(tab == "td_format"){
			sql = "select f_name f_name#名称,f_remark f_remark#备注,f_description f_description#描述 from td_format";
		}
		$("#objsql").val(sql);
		getColumnName(sql,'objcolumn');
	}
	
	function getColumnName(sql,show){
		var o = new Object();
		o.sql = sql;
		var url = "${pageContext.request.contextPath}/selFromSql.html";
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
               	if(data.result){
               		$("#"+show).find("tr").each(function(i){
               			if(i>0){
               				$(this).remove();
               			}
               		});
					for(var i=0; i<data.columns.length; i++){
						var cols = data.columns[i].split("#");
						if(cols.length>1){
							var html = '<tr>'+
									'	<td>'+cols[1]+'</td>'+
									'	<td><input type="checkbox"/></td>'+
									'	<td><input type="checkbox" onclick="selval(this,\''+show+'\',\''+cols[0]+'\')" show="'+show+'" value="'+cols[1]+'"/></td>'+
									'</tr>';
							$("#"+show).append(html);							
						}else{
							var html = '<tr>'+
									'	<td>'+data.columns[i]+'</td>'+
									'	<td><input type="checkbox"/></td>'+
									'	<td><input type="checkbox" onclick="selval(this,\''+show+'\',\''+data.columns[i]+'\')" show="'+show+'" value="'+data.columns[i]+'"/></td>'+
									'</tr>';
							$("#"+show).append(html);
						}
					}
				}else{
					alert("语句错误");
				}
               }
           });
	}
	
	//checkbox 回传
	function selval(obj,show,id){
		if(obj.checked){
			var table = $("#"+show+"val")[0];
			var isex = false;
			for(var i=1; i<table.rows.length; i++){
				if(table.rows[i].cells[0].innerText == obj.value){
					isex = true;
					break;
				}
			}
			if(!isex){
				var html = '<tr>'+
							'	<td elementid="'+id+'">'+obj.value+'</td>'+
							'	<td>'+selecthtml+'</td>'+
							'</tr>';
				$(table).append(html);			
			}
		}else{
			var table = $("#"+show+"val")[0];
			var isex = false;
			for(var i=1; i<table.rows.length; i++){
				if(table.rows[i].cells[0].innerText == obj.value){
					$(table.rows[i]).remove();
				}
			}
		}
	}
	
	//全选反选
	function allanduall(){
		$("input[value='all']").click(function(){
			var index = $(this).parent()[0].cellIndex;
			var table = $(this).parent().parent().parent()[0];
			for(var i=1; i<table.rows.length; i++){
				$(table.rows[i].cells[index]).find("input")[0].checked = this.checked;
				if(index == 2){
					selval($(table.rows[i].cells[index]).find("input")[0],$(table.rows[i].cells[index]).find("input").attr("show"),$(table.rows[i]).attr("elementid"));
				}
			}
		});
		$("input[value='uall']").click(function(){
			var index = $(this).parent()[0].cellIndex;
			var table = $(this).parent().parent().parent()[0];
			for(var i=1; i<table.rows.length; i++){
				$(table.rows[i].cells[index]).find("input")[0].checked = !$(table.rows[i].cells[index]).find("input")[0].checked;
				if(index == 2){
					selval($(table.rows[i].cells[index]).find("input")[0],$(table.rows[i].cells[index]).find("input").attr("show"),$(table.rows[i]).attr("elementid"));
				}
			}
		});
	}
	
	//值设置
	function valset(){
		
	}
	
	/*************tab*******************/
	function switchTab(ProTag, ProBox,sel) {
			seltab = sel;
            for (i = 1; i < 4; i++) {
                if ("tab" + i == ProTag) {
                    document.getElementById(ProTag).getElementsByTagName("a")[0].className = "on";
                } else {
                    document.getElementById("tab" + i).getElementsByTagName("a")[0].className = "";
                }
                if ("con" + i == ProBox) {
                    document.getElementById(ProBox).style.display = "";
                } else {
                    document.getElementById("con" + i).style.display = "none";
                }
            }
        }
</script>
</script>
	</head>
	<body style="margin: 0px; padding: 0px; width: 100%;  ">
		<table style="width: 100%;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="height: 130px;" valign="top">
					<div id="tabContainer">
				        <ul>
				            <li id="tab1"><a href="#" class="on" onclick="switchTab('tab1','con1','objcolumn');this.blur();return false;">
				                依据系统</a></li>
				            <li id="tab2"><a href="#" onclick="switchTab('tab2','con2','formcolumn');this.blur();return false;">
				                依据表单</a></li>
				            <li id="tab3"><a href="#" onclick="switchTab('tab3','con3','sqlcolumn');this.blur();return false;">
				                依据SQL</a></li>
				        </ul>
				        <div style="clear: both;display: none;">
				        </div>
				        <div id="con1" style="overflow-y: scorll;">
				            <table class="table" style="width: 100%;  font-size: 13px; text-align: center;"
						border="0" cellpadding="0" cellspacing="1"  >
								<tr>
									<td>对象选择</td>
									<td align="left">
									&nbsp;&nbsp;<a style="display: inline;" href="javascript:void(0)" onclick="sysObject('tab_userinfo')">用户</a>&nbsp;&nbsp;/
									&nbsp;&nbsp;<a style="display: inline;" href="javascript:void(0)" onclick="sysObject('tab_department')">组织</a>&nbsp;&nbsp;/
									&nbsp;&nbsp;<a style="display: inline;" href="javascript:void(0)" onclick="sysObject('tf_flow')">流程</a>&nbsp;&nbsp;/
									&nbsp;&nbsp;<a style="display: inline;" href="javascript:void(0)" onclick="sysObject('td_format')">表单</a>
									</td>
								</tr>
								<tr>
									<td>条件设置</td>
									<td align="left">
										<input type="text" id="objcolumncon"/><input type="button" value="..."/>
										<input type="hidden" value="" id="objcolumnobj"/>
										<input type="hidden" value="" id="objsql"/>
									</td>
								</tr>
								<tr>
									<td align="left" colspan="2">
										<table class="table" style="width: 100%;  font-size: 13px;text-align: center;"
						border="0" cellpadding="1" cellspacing="1"  id="objcolumn">
											<tr>
												<td background="#dde4ea">元素名称</td>
												<td background="#dde4ea">显示<!-- <input type="checkbox" value="all"/>全选/<input type="checkbox" value="uall"/>反选 --></td>
												<td background="#dde4ea">回传<!-- <input type="checkbox" value="all"/>全选/<input type="checkbox" value="uall"/>反选 --></td>
											</tr>
											
										</table>
									</td>
								</tr>
								<tr>
									<td background="#dde4ea" colspan="2" align="left">值设置</td>
								</tr>
								<tr>
									<td align="left" colspan="2">
										<table class="table" style="width: 100%;  font-size: 13px;text-align: center;"
						border="0" cellpadding="1" cellspacing="1" id="objcolumnval" >
											<tr>
												<td background="#dde4ea">值</td>
												<td background="#dde4ea">写入</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>	
				        </div>
				        <div id="con2" style="display: none">
				           <table class="table" style="width: 100%;  font-size: 13px; text-align: center;"
							border="0" cellpadding="5" cellspacing="1" bordercolor="gray" >
								<tr >
									<td align="left" colspan="2">
										表单选择：
										<select style="width: 80px" id="group" onchange="selForm(this)">
											<option value="0">表单组</option>
										</select>-
										<select style="width: 80px" id="form" onchange="selFormEelment(this)">
										</select>
									</td>
								</tr>
								<tr >
									<td align="left"  colspan="2">
										条件设置：<input type="text" id="formcolumncon"/><input type="button"  value="..."/>
									</td>
								</tr>
								<tr>
									<td align="left" colspan="2">
										<table class="table" style="width: 100%;  font-size: 13px;text-align: center;"
						border="0" cellpadding="1" cellspacing="1" id="formcolumn">
											<tr>
												<td background="#dde4ea">元素名称</td>
												<td background="#dde4ea">显示<!-- <input type="checkbox" value="all"/>全选/<input type="checkbox" value="uall"/>反选 --></td>
												<td background="#dde4ea">回传<!-- <input type="checkbox" value="all"/>全选/<input type="checkbox" value="uall"/>反选 --></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td background="#dde4ea" colspan="2" align="left">值设置</td>
								</tr>
								<tr>
									<td align="left" colspan="2">
										<table class="table" style="width: 100%;  font-size: 13px;text-align: center;"
						border="0" cellpadding="1" cellspacing="1" id="formcolumnval">
											<tr>
												<td background="#dde4ea">值</td>
												<td background="#dde4ea">写入</td>
											</tr>
											<tr>
												<td></td>
												<td></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>	
				        </div>
				        <div id="con3" style="display: none">
				        	<table class="table" style="width: 100%;  font-size: 13px; text-align: center;"
						border="0" cellpadding="0" cellspacing="1"  >
							<tr>
								<td colspan="2">
									实例-[exampleid],用户ID-[userid],部门ID-[deptid],转义'-\\'
								</td>
							</tr>
							<tr>
								<td colspan="2">
				            	<textarea style="width: 390px;height: 90px;" id="sql" onblur="jiexi(this)"></textarea>
				            	</td>
				            </tr>
				            <tr>
									<td align="left" colspan="2">
										<table class="table" style="width: 100%;  font-size: 13px;text-align: center;"
						border="0" cellpadding="1" cellspacing="1" id="sqlcolumn">
											<tr>
												<td background="#dde4ea">元素名称</td>
												<td background="#dde4ea">显示<!-- <input type="checkbox" value="all"/>全选/<input type="checkbox" value="uall"/>反选 --></td>
												<td background="#dde4ea">回传<!-- <input type="checkbox" value="all"/>全选/<input type="checkbox" value="uall"/>反选 --></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td background="#dde4ea" colspan="2" align="left">值设置</td>
								</tr>
								<tr>
									<td align="left" colspan="2">
										<table class="table" style="width: 100%;  font-size: 13px;text-align: center;"
						border="0" cellpadding="1" cellspacing="1" id="sqlcolumnval">
											<tr>
												<td background="#dde4ea">值</td>
												<td background="#dde4ea">写入</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>	
				        </div>
				    </div>
						
				</td>
			</tr>
		</table>
		
	</body>
</html>
