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
	dialog.onok = function (){
		exitDialog();
	};
	var seltab = "sqlcolumn";
	function exitDialog(){
		//sql
		if(seltab == "sqlcolumn"){
			var o = new Object();
			o.type = "sql";
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
	var selecthtml="";
	function initValue(){
		//本表单
		if(typeof ww != 'undefined'){
			fs = getFields();
			if(fs.length>0){
				selecthtml = "<select>"
				selecthtml = selecthtml+"<option value=''>表单元素</option>"
				for(var i=0; i<fs.length; i++){
					selecthtml = selecthtml+"<option value='"+fs[i].enname+"'>"+fs[i].cnname+"</option>"
				}
				selecthtml = selecthtml + "</select>";
			}
			//设置
			var o = ww.selectrule;
			//alert(o);
			if(o != ""){
				o = decodeURIComponent(o);
				o = string2Object(o);
				
				if(o.type == "sql"){
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
		
		initValue();
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
	function parseSql(obj){
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
	
	
	function getColumnName(sql,show){
		$("#"+show).find("tr").each(function(i){
   			if(i>0){
   				$(this).remove();
   			}
   		});
		var data = getSqlColumns(sql);
		for(var i=0; i<data.length; i++){
			var cols = data[i].split("#");
			if(cols.length>1){
				var html = '<tr>'+
						'	<td>'+cols[1]+'</td>'+
						'	<td><input type="checkbox"/></td>'+
						'	<td><input type="checkbox" onclick="selval(this,\''+show+'\',\''+cols[0]+'\')" show="'+show+'" value="'+cols[1]+'"/></td>'+
						'</tr>';
				$("#"+show).append(html);							
			}else{
				var html = '<tr>'+
						'	<td>'+data.obj[i]+'</td>'+
						'	<td><input type="checkbox"/></td>'+
						'	<td><input type="checkbox" onclick="selval(this,\''+show+'\',\''+data.obj[i]+'\')" show="'+show+'" value="'+data.obj[i]+'"/></td>'+
						'</tr>';
				$("#"+show).append(html);
			}
		}
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
	
	function getSqlColumns(sql){
		 var k = sql.toUpperCase().indexOf(" FROM ");
         if(k <= 0){
             return;
         }
         var Fields = sql.substring(7, k).split(",");
         var outFields = new Array();
         var blackStack = 0;
         var t = 0;
         for(var i = 0; i < Fields.length; i++){
             var x = Fields[i].indexOf("(");
             if(x>=0){
                 while(x>=0){
                     blackStack++;
                     Fields[i] = Fields[i].substring(x+1);
                     t = Fields[i].indexOf(")");
                     x = Fields[i].indexOf("(");
             		if(t<x){
             			blackStack--;
                         Fields[i] = Fields[i].substring(t+1);
             		}
                     x = Fields[i].indexOf("(");
                 }
             }
             x = Fields[i].indexOf(")");
             if(x>=0){
                 while(x>=0){
                     blackStack--;
                     Fields[i] = Fields[i].substring(x+1);
                     x = Fields[i].indexOf(")");
                  }
             }
             if(blackStack==0){
                 var units = Fields[i].split(" ");
                 units = units[units.length - 1].split(".");
                 outFields[outFields.length] = units[units.length - 1];
             }
         }
		return outFields;
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
				            <li id="tab3">
				                依据SQL</li>
				        </ul>
				        <div style="clear: both;display: none;">
				        </div>
				        <div id="con3" >
				        	<table class="table" style="width: 100%;  font-size: 13px; text-align: center;"
						border="0" cellpadding="0" cellspacing="1"  >
							<tr>
								<td colspan="2">
									实例-[exampleid],用户ID-[userid],部门ID-[deptid],转义'-\\'
								</td>
							</tr>
							<tr>
								<td colspan="2">
								例子：select username as username#姓名,sex as sex#性别  from table
				            	<textarea style="width: 390px;height: 90px;" id="sql" onblur="parseSql(this)"></textarea>
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
