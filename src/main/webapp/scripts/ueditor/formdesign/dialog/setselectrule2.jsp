<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>输入选择</title>
		<script type="text/javascript" src="../js/ggjs.js"></script>
		<script type="text/javascript" src="../js/editdialog.js"></script>
		<script type="text/javascript" src="../js/jsonutil.js"></script>
		<script type="text/javascript" src="../jquery-1.8.2.min.js"></script>
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
		</style>
		<script type="text/javascript">
	var ww=window.dialogArguments;
	
	function ret(){
		var o = new Object();
		if(seltab == "sys"){
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
		if(seltab == "form"){
			o.type = "form";
			o.gid = $("#group").val();
			o.fid = $("#form").val();
			o.cond = $("#formcolumncon").val();
			o.show = [];
			$("#radval").find("li").each(function(){
				var oo = new Object();
				var $a = $(this).find("a:frist");
				oo.type = $a.attr("type");
				oo.show = $a.text();
				oo.key = $a.attr("key");
				oo.eid = $a.attr("eid");
				o.show.push(oo);
			});
		}
		if(seltab == "sql"){
			o.type = "sql";
			o.sql = $("#sql").val();
			o.show = [];
			$("#radval").find("li").each(function(){
				var oo = new Object();
				var $a = $(this).find("a:first");
				oo.type = $a.attr("type");
				oo.show = $a.text();
				oo.key = $a.attr("key");
				o.show.push(oo);
			});
		}
		window.returnValue = object2String(o);
		self.close();
	}
	var seltab = "sys";
	function init(){
				
		//引用表单
		$.getJSON("${pageContext.request.contextPath}/allFormGroup.html",function(data){
			var group = document.getElementById("group");
			for(var i=0; i<data.length; i++){
				group.options.add(new Option(data[i].g_name,data[i].id));
			}
			initVal();
		});
	}
	//回填
	function initVal(){
		//本表单
		if(typeof ww != 'undefined'){
			//设置
			var o = ww.eleinputval;
			if(o != ""){
				o = string2Object(o);
				if(o.type == "sys"){
					switchTab('tab1','con1','sys');
					for(var i=0; i<o.show.length; i++){
						var html = "<li><a type='"+o.show[i].type+"'   key='"+o.show[i].key+"'>"+o.show[i].show+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
						$("#radval").append(html);
					}
				}
				if(o.type == "form"){
					switchTab('tab2','con2','form');
					  $("#group").val(o.gid);
					 $("#formcolumncon").val(o.cond);
					selForm(document.getElementById("group"),o);
					for(var i=0; i<o.show.length; i++){
						var html = "<li><a type='"+o.show[i].type+"' eid='"+o.show[i].eid+"'  key='"+o.show[i].key+"'>"+o.show[i].show+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
						$("#radval").append(html);
					}
				}
				if(o.type == "sql"){
					switchTab('tab3','con3','sql');
					$("#sql").val(o.sql);
					for(var i=0; i<o.show.length; i++){
						var html = "<li><a type='"+o.show[i].type+"'   key='"+o.show[i].key+"'>"+o.show[i].show+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
						$("#radval").append(html);
					}
				}
			}
		}
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
				}
			});
		}
	}
	//表单元素
	function selFormEelment(obj){
		if(obj.value == 0){
			return;
		}
		$.getJSON("${pageContext.request.contextPath}/findFormElement.html?fid="+obj.value,function(data){
			for(var i=0; i<data.length; i++){
				var html = "<li><a type='form'   eid='"+data[i].id+"' key='"+data[i].e_english_name+"'>"+data[i].e_name+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
				$("#radval").append(html);			
			}
		});
	}
	$(function(){
		init();
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
	function jiexi(obj){
		if(obj.value == ""){
			return;
		}
		var sql = obj.value.toUpperCase();
		if(sql.indexOf("SELECT")>=0 && sql.indexOf("FROM")>0){
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
                		//$("#radval").find("li").remove();
						for(var i=0; i<data.columns.length; i++){
							var html = "<li><a type='sql'   key='"+data.columns[i]+"'>"+data.columns[i]+"</a>&nbsp;&nbsp;<a href='javascript:void(0)' onclick='cls(this)'>x</a></li>";
							$("#radval").append(html);
						}
					}else{
						alert("语句错误");
					}
                }
            });
			
		}else{
			alert("语句错误");
		}
	}
	
	/*************tab*******************/
	function switchTab(ProTag, ProBox,type) {
			seltab = type;
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
	<body style="margin: 0px; padding: 0px; width: 100%;  overflow: hidden">
		<table style="width: 100%;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="height: 130px;" valign="top">
					<div id="tabContainer">
				        <ul>
				            <li id="tab1"><a href="#" class="on" onclick="switchTab('tab1','con1','sys');this.blur();return false;">
				                依据常量</a></li>
				            <li id="tab2"><a href="#" onclick="switchTab('tab2','con2','form');this.blur();return false;">
				                依据表单</a></li>
				            <li id="tab3"><a href="#" onclick="switchTab('tab3','con3','sql');this.blur();return false;">
				                依据SQL</a></li>
				        </ul>
				        <div style="clear: both;display: none;">
				        </div>
				        <div id="con1" style="overflow-y: scorll;">
				            <table class="table" style="width: 100%;  font-size: 13px; text-align: center;"
						border="0" cellpadding="0" cellspacing="1"  >
								<tr>
										<td>常量: &nbsp;&nbsp;显示<input id="cl" style="width:60px;" onkeypress="if(event.keyCode==13){selcl(this);};"/>-
										值<input id="clv" style="width:60px;" onkeypress="if(event.keyCode==13){selcl(this);};"/>
										<input type="button" onclick="selcl()" value="确定"/></td>
									</tr>
							</table>	
				        </div>
				        <div id="con2" style="display: none">
				           <table class="table" style="width: 100%;  font-size: 13px; text-align: center;"
							border="0" cellpadding="5" cellspacing="1" bordercolor="gray" >
								<tr >
									<td align="left">
										表单组
										<select style="width: 30%" id="group" onchange="selForm(this)">
											<option value="0">表单组</option>
										</select>
										表单
										<select style="width: 30%" id="form" onchange="selFormEelment(this)">
										</select>
									</td>
								</tr>
								<tr>
									<td align="left">
										条件设置&nbsp;<input type="text" id="formcolumncon" value=""/><input type="button" value="..."/>
									</td>
								</tr>
							</table>	
				        </div>
				        <div id="con3" style="display: none">
				            <textarea style="width: 390px;height: 90px;" id="sql" onblur="jiexi(this)"></textarea>
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
			<tr>
				<td align="center">
					<input type="button" onclick="ret();" value="确定">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" onclick="self.close();" value="取消">
				</td>
			</tr>
		</table>
		
	</body>
</html>
