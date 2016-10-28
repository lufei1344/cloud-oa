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
	 	<title>默认值设置</title>
	 	<link   type="text/css"  href="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.css" rel="stylesheet" />
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/jquery.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/bootstrap/3.7/bootstrap.min.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/formdesign/FormUtil.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
		<script type="text/javascript">
	
	function exitDialog(){
		
		var rev = [];
		$("#expression").find("a").each(function(){
			rev.push(string2Object($(this).attr("val")));
		});
		
		var obj = new Object();
		obj.val = object2String(rev);
		obj.html =  $("#expression").html();
		window.parent.returnValue = obj;
		
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
		 $("#expression").html(obj.html);
	}
	
	function initVal(){
		if(typeof ww != 'undefined' && ww.eledef != ""){
			var o = string2Object(ww.eledef);
			var $exp =  $("#expression");
			for(var i=0; i<o.exp.length; i++){
				var html = '<a  onclick="cls(this)" val="'+object2String(o.exp[i])+'">'+o.exp[i].elementname+'</a>';
				$exp.append(html);
			}
			//条件
			if(o.cond.length>0){
				$("#group").val(o.gid);
				selForm($("#group")[0],o);
			}
		}
	}
	
	function selectForm(id,o){
			$.getJSON("${pageContext.request.contextPath}/config/form/findForm?type=json&formType="+id,function(data){
				var form = document.getElementById("form");
				form.options.length=0;
				form.options.add(new Option("表单",0));
				for(var i=0; i<data.obj.length; i++){
					form.options.add(new Option(data.obj[i].name,data.obj[i].id));
				}
				if(typeof o != 'undefined'){
					group.value = o.id;
					selFormEelment(group,o);
				}
			});
	}
	//表单元素
	function selFormEelment(obj,o){
		if(obj.value == 0){
			return;
		}
		$.getJSON("${pageContext.request.contextPath}/config/form/findFormField?formid="+obj.value,function(data){
			var $yybd = $("#yybd");
			$yybd.find("tr").remove();
			yybd = data.obj;
			for(var i=0; i<data.obj.length; i++){
				var tr = '<tr>'+
						'	<td align="left">&nbsp;&nbsp;<a href="javascript:void(0)" onclick="selyybd('+i+')">'+data.obj[i].cnname+'</a></td>'
						'</tr>';
				$yybd.append(tr);		
			}
			
			
		});
	}
	//选择本表单
	function selbbd(index){
		var html = "{type:'bbd',key:'"+bbd[index].enname+"',cnname:'"+bbd[index].cnname+"'}";
		html = '<a  onclick="cls(this)" val="'+html+'">'+bbd[index].cnname+"</a>";
		$("#expression").append(html);
	}
	function cls(obj){
		$(obj).remove();
	}
	//选择引用表单
	function selyybd(index){
		var html = "{type:'yybd',fid:'"+yybd[index].formId+"',id:'"+yybd[index].id+"',key:'"+yybd[index].enname+"',cnname:'"+yybd[index].enname+"'}";
		html = '<a  onclick="cls(this)" val="'+html+'">'+yybd[index].cnname+"</a>";
		$("#expression").append(html);
	}
	//系统变量
	function selxtbl(fh,obj){
		var html = "{type:'xtbl',key:'"+fh+"',cnname:'"+$(obj).text()+"'}";
		html = '<a  onclick="cls(this)" val="'+html+'">'+$(obj).text()+"</a>";
		$("#expression").append(html);
	}
	//符号
	function addFuhao(obj) {
		var html = "{type:'xtfh',key:'"+$(obj).text()+"',cnname:'"+$(obj).text()+"'}";
		html = '<a  onclick="cls(this)" val="'+html+'">'+$(obj).text()+"</a>";
		$("#expression").append(html);
	}
	//流程变量
	function sellcbl(obj){
		var cl = $("#lcbl").val();
		if(cl == ""){
			alert("请先填写流程变量");
		}else{
			var html = "{type:'lcbl',key:'"+cl+"',cnname:'"+cl+"'}";
			html = '<a  onclick="cls(this)" val="'+html+'">'+cl+"</a>";
		$("#expression").append(html);
		}
	}
	//常量
	function selcl(obj){
		var cl = $("#cl").val();
		if(cl == ""){
			alert("请先填写常量值");
		}else{
			var html = "{type:'xtcl',key:'"+cl+"',cnname:'"+cl+"'}";
			html = '<a  onclick="cls(this)" val="'+html+'">'+cl+"</a>";
			$("#expression").append(html);
		}
	}
	
	function del(obj){
		$(obj).parent().parent().remove();
	}
	$(function(){
		
		$("#formType").change(function(){
			if(this.value != ""){
				selectForm(this.value);
			}
		});
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
				<td valign="top" width="40%">
					<table style="width: 100%;text-align: center;" class="table table-bordered" >
					<tr>
						<th class="active">引用表单</th>
					</tr>
					<tr >
						<td align="left">
							类别<frame:select name="formType" style="width:80px;" type="select" configName="formType" displayType="0" value="" />&nbsp;表单
							<select style="width: 30%" id="form" onchange="selFormEelment(this)">
							</select>
						</td>
					</tr>
					<tr>
						<td>
						<div style="overflow-y: auto;height: 150px;">	
						<table  class="table table-bordered" id="yybd">
						
						</table>
						</div>
						</td>
					</tr>
					</table>
				</td>
				<td valign="top" width="40%">
					<table style="width: 100%;text-align: center;" class="table table-bordered" >
					<tr>
						<th class="active">系统变量</th>
					</tr>
					<tr>
						<td align="left">
							&nbsp;&nbsp;<a href="javascript:void(0)" onclick="selxtbl('dept',this)">部门</a>
							&nbsp;&nbsp;<a href="javascript:void(0)" onclick="selxtbl('post',this)">岗位</a>
							&nbsp;&nbsp;<a href="javascript:void(0)" onclick="selxtbl('user',this)">人员</a>
							&nbsp;&nbsp;<a href="javascript:void(0)" onclick="selxtbl('time',this)">时间</a>
							&nbsp;&nbsp;<a href="javascript:void(0)" onclick="selxtbl('date',this)">日期</a>
						</td>
					</tr>
					<tr>
						<td align="left">
							<table style="width: 100%;  font-size: 13px; text-align: center;"
			border="0" cellpadding="5" cellspacing="1" bordercolor="gray" >
								<tr>
									<td align="right">流程变量</td>
									<td><input id="lcbl" style="width:80px;" /><input type="button" onclick="sellcbl()" value="确定"/></td>
								</tr>
								<tr>
									<td align="right">常量</td>
									<td><input id="cl" style="width:80px;"/><input type="button" onclick="selcl()" value="确定"/></td>
								</tr>
								<tr>
									<td colspan="2">
									<a href="javascript:void(0)" onClick="addFuhao(this)">if</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">+</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">-</a>&nbsp;&nbsp;
									<a href="javascript:void(0" onClick="addFuhao(this)">*</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">/</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">(</a>&nbsp;&nbsp;
									<a href="javascript:void(0" onClick="addFuhao(this)">)</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">&gt;</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">&gt;=</a>&nbsp;&nbsp;
									<a href="javascript:void(0" onClick="addFuhao(this)">&lt;</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">&lt;=</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">==</a>&nbsp;&nbsp;
									<a href="javascript:void(0" onclick="addFuhao(this)">&lt;&gt;</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">and</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onClick="addFuhao(this)">or</a>
									</td>
								</tr>
							</table>
						
						</td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="3" align="left">
				&nbsp;&nbsp;&nbsp;&nbsp;表达式：<span id="expression"  ></span>
				<input type="type" style="width: 80%;display:none;"  />
				</td>
			</tr>
			<!-- 
			<tr>
				<td colspan="3">
					<input type="button" onclick="ret();" value="确定">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" onclick="self.close();" value="取消">
				</td>
			</tr>
			 -->
		</table>
	</body>
</html>
