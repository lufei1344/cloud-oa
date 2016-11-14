<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
   		<meta charset="utf-8">
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<meta name="renderer" content="webkit">
	 	<title>复选框</title>
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
			<input type="hidden" name="datatype" id="datatype" value="char"/>
			<input type="hidden" name="showtype" id="showtype" value="input"/>
			<input type="hidden" name="exttype" id="exttype" value="checkbox"/>
				<table class="table table-bordered" >
					<caption style="text-align:center"><h2>复选框属性配置</h2></caption>
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
							默认行数:
						</td>
						<td align="left">
						<div class="col-xs-6">
							<input type="text" name="defrow" value="" id="defrow"  class="form-control" value="1">
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="background-color: #dde4ea;" align="left">
							元素
						</td>
					</tr>
					<tr>
						<td colspan="2">
							名称：<input type="text" style="width: 60px;" id="grid_cnname"/>
							英文名：<input  type="text" style="width: 60px;" id="grid_enname" onkeypress="if(event.keyCode==13){addEle();};"/>
							数据类型<select id="grid_datatype" style="width: 60px;"><option value="char">文本</option><option value="num">数值</option><option value="date">日期</option></select>
							<input type="button" value="添加" onclick="addEle()"/>
						</td>
					</tr>
					<tr>
						<td colspan="2" valign="top" align="left">
							<select id="output" size="3" multiple="multiple"
								style="width: 240px; font-size: 16px;height: 100px;">
							</select>
							<input type="button" value="↑" onclick="listbox_move('output','up')"/>
							<input type="button" value="↓" onclick="listbox_move('output','down')"/>
							<input type="button" value="删除" onclick="delone('output')"/>
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
		nodeInfo = {thePlugins : 'extdig-checkbox',tag:"input",type:"checkbox"};
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
		
		
		
		//////
		var ww=window.dialogArguments;
	function onlo(){
		if(ww.xml!=undefined){
			var x=ww.xml;
			}
		if(ww.kjobj!=undefined){
			var table = ww.kjobj.parentNode.parentNode.parentNode;
			document.getElementById("elename").value=table.getAttribute("elementname");
			document.getElementById("eleid").value=table.getAttribute("elementid");
			document.getElementById("defrow").value=table.getAttribute("defrow");
			var sel = document.getElementById("output");
			for(var i=0; i<table.rows[0].cells.length; i++){
				var o = new Object();
				o.name = table.rows[0].cells[i].innerText;
				o.ename = table.rows[0].cells[i].id;
				o.datatype = table.rows[0].cells[i].getAttribute("datatype");
				sel.options.add(new Option(o.name,object2String(o)));
			}
			
		}
	}
	function setele(em,ev,relaid){
		document.getElementById("eleid").value=ev;
		document.getElementById("elename").value=em;
	}
	function ret(){
		if(document.getElementById("cnname").value==""){
			alert("请填写名称！！");
			return;
		}
		if(document.getElementById("enname").value==""){
			alert("请输入别名！！");
			return;
		}else{
			if(checkTextValid(document.getElementById("eleid"))){
                return false;
			}
		}
		
		var o = new Object();
		o.elementname = document.getElementById("cnname").value;
		o.elementid = document.getElementById("enname").value
		o.defrow = document.getElementById("defrow").value
		o.tablerows = [];
		var op = document.getElementById("output");
		for(var i=0; i<op.options.length; i++){
			o.tablerows.push(string2Object(op.options[i].value));
		} 
		
		window.returnValue="{}^"+object2String(o);
		
		var html = "<table class='twice' width='100%'  cellspacing='0' cellpadding='0'  border='1'  elementname='"+fcp.elementname+"' id='"+fcp.elementid+"'><tr>";
     	for(var i=0; i<fcp.tablerows.length; i++){
     		html = html + "<td id='"+fcp.tablerows[i].ename+"' datatype='"+fcp.tablerows[i].datatype+"'>"+decodeURI(fcp.tablerows[i].name)+"</td>"
     	}
     	html = html + "</tr>";
     	for(var i=0; i<fcp.defrow; i++){
     		html  = html +"<tr>";
     		for(var j=0; j<fcp.tablerows.length; j++){
     			html = html +"<td></td>";
     		}
     		html  = html +"</tr>";
     	}
     	html = html + "</table>";
     	myeditor.execCommand('insertHtml', html)
		self.close();
	}
	//添加元素
	function addEle(){
		var cnname = $("#grid_cnname").val();
		var enname = $("#grid_enname").val();
		if(name == ""){
			alert("请填写元素名称");
			return;
		}
		if(ename == ""){
			alert("请填写英文名");
			return;
		}
		var datatype =  $("#grid_datatype").val();
		
		var sel = document.getElementById("output");
		var o = new Object();
		o.cnname = name;
		o.enname = ename;
		o.datatype = datatype;
		sel.options.add(new Option(name,object2String(o)));
		
		$("#grid_cnname").val("");
		$("#grid_enname").val("");
		$("#grid_cnname")[0].focus();
	}
	
	//上移下移的函数
	/*
	使用方法，只需要传递Listbox的ID和移动的方向(up或down)：
	listbox_move('list', 'up'); //将所选项上移
	listbox_move('ist', 'down'); //将所选项下移
	*/
	function listbox_move(listID, direction) {
	    var listbox = window.document.getElementById(listID);
	    var selIndex = listbox.selectedIndex;
	
	    if(-1 == selIndex) {
	        alert("请选择元素");
	        return;
	    }
	
	    var increment = -1;
	    if(direction == 'up')
	        increment = -1;
	    else
	        increment = 1;
	
	    if((selIndex + increment) < 0 ||
	        (selIndex + increment) > (listbox.options.length-1)) {
	        return;
	    }
	
	    var selValue = listbox.options[selIndex].value;
	    var selText = listbox.options[selIndex].text;
	    listbox.options[selIndex].value = listbox.options[selIndex + increment].value
	    listbox.options[selIndex].text = listbox.options[selIndex + increment].text
	
	    listbox.options[selIndex + increment].value = selValue;
	    listbox.options[selIndex + increment].text = selText;
	
	    listbox.selectedIndex = selIndex + increment;
	}
	//删除
	function delone(res)//删除获得焦点的项目
	{
	    var lst2=window.document.getElementById(res); 
         for(var i=0;i<lst2.options.length;i++)  
           {  
               if(lst2.options[i].selected)  
               {  
               var lstindex=lst2.selectedIndex;
			//alert(lstindex)
                if(lstindex>=0)
                 {
                 var v = lst2.options[lstindex].value+";";
                 lst2.options[lstindex].parentNode.removeChild(lst2.options[lstindex]);
			  i--
                 } 
               }
            }  
	}
	//编辑
	function editone(res)//删除获得焦点的项目
	{
	    var lst2=window.document.getElementById(res);
	    var indx = lst2.selectedIndex;
	    var op = lst2.options[indx]; 
        var o = string2Object(op.value);
           
	}
		
	</script>
</body>
</html>
