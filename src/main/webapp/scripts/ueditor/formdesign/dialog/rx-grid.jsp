<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 	<title>表格控件-rx-grid</title>
	 	<script src="${ctxPath}/scripts/boot.js" type="text/javascript"></script>
	 	<script src="${ctxPath}/scripts/share.js" type="text/javascript"></script>
	 	<script src="${ctxPath}/scripts/common/form.js" type="text/javascript"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/form-design/config/plugin-libs.js"></script>
	 	<link href="${ctxPath}/styles/form.css" rel="stylesheet" type="text/css" />
	 	<link href="${ctxPath}/styles/icons.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<div style="width:100%;text-align: center">
		<div style="margin-left:auto;margin-right: auto;padding:5px;">
			<form id="miniForm">
				<table class="form-table" cellspacing="1" cellpadding="1">
					<caption>表格控件属性配置</caption>
					<tr>
						<th class="form-table-th">字段备注*</th>
						<td class="form-table-td">
							<input class="mini-textbox" name="label" required="true" vtype="maxLength:100"  style="width:90%" emptytext="请输入字段备注" />
						</td>
						<th class="form-table-th">字段标识*</th>
						<td class="form-table-td">
							<input name="name" class="mini-treeselect" url="${ctxPath}/bpm/bm/bpmFormModel/getModelAttTree.do?modelId=${param['modelId']}" multiSelect="false"  valueFromSelect="false" emptytext="请输入字段标识，为英文开头或与数字组合" style="min-width:120px;width:90%"
						        textField="key" valueField="key" parentField="parentId"  allowInput="true" onvalidation="onKeyValidation" required="true"
						        onvaluechanged="fieldChange"
						        showRadioButton="true" showFolderCheckBox="false"/>
						</td>
					</tr>
					<tr>
						<th class="form-table-th">表头配置</th>
						<td colspan="3" class="form-table-td">
							<div class="mini-toolbar" style="padding:2px;text-align:left;border-bottom: none;">
							    <table style="width:100%;">
							        <tr>
								        <td style="width:100%;">
								            <a class="mini-button" iconCls="icon-add" plain="true" onclick="addRow">添加</a>
								            <a class="mini-button" iconCls="icon-remove" plain="true" onclick="removeRow">删除</a>
								            <span class="separator"></span>
								            <a class="mini-button" iconCls="icon-up" plain="true" onclick="upRow">向上</a>
								            <a class="mini-button" iconCls="icon-down" plain="true" onclick="downRow">向下</a>
								        </td>
							        </tr>
							    </table>
							</div>
							<div id="hdgrid" class="mini-datagrid" style="width:100%;min-height:100px;" height="auto" showPager="false"
								allowCellEdit="true" allowCellSelect="true">
							    <div property="columns">
							        <div type="indexcolumn"></div>                
							        <div field="key" width="120" headerAlign="center">字段Key
							         <input property="editor" class="mini-textbox" style="width:100%;" />
							        </div>    
							        <div field="name" width="120" headerAlign="center">字段名称
							        	<input property="editor" class="mini-textbox" style="width:100%;" />
							        </div>
							        <div field="width" width="120" headerAlign="center">宽度
							        	<input property="editor" class="mini-spinner" style="width:100%;" minValue="100" maxValue="1200"/>
							        </div>
							        <div field="format" width="120" headerAlign="center">格式化
							        	<input property="editor" class="mini-textbox" style="width:100%;" />
							        </div>    
							    </div>
							</div>
						</td>
					</tr>
					<!-- tr>
						<th class="form-table-th">数据来源</th>
						<td class="form-table-td" colspan="3">
							<div class="mini-radiobuttonlist" value="self" id="from" name="from" data="[{id:'url',text:'URL'},{id:'self',text:'自定义'}]" onvaluechanged="changeFrom"></div>
						</td>
					</tr>
					<tr id="url_row">
						<th class="form-table-th">外部URL</th>
						<td class="form-table-td">
							<input class="mini-textbox" name="url" vtype="maxLength:100"  style="width:90%" emptytext="请输入URL" />
						</td>
						<th class="form-table-th">
							是否允许分页
						</th>
						<td class="form-table-td">
							<div class="mini-radiobuttonlist" repeatItems="5" repeatLayout="table" 
    						textField="text" valueField="id" value="true" name="showPager" data="[{id:'true',text:'是'},{id:'false',text:'否'}]"></div>
						</td>
					</tr-->
					<tr>
						<th class="form-table-th">数据编辑模式</th>
						<td class="form-table-td" colspan="3">
							<div class="mini-radiobuttonlist" id="edittype"  name="edittype" value="inline" onvaluechanged="changeEditType" data="[{id:'inline',text:'行内'},{id:'openwindow',text:'弹窗'}]"></div>
						</td>
					</tr>
					<tr id="tmprow" style="display:none">
						<th class="form-table-th">
							编辑窗口模板
						</th>
						<td class="from-table-td" colspan="3" style="text-align:left;padding-left:4px;">
							<input id="templateid" name="templateid" class="mini-combobox" style="width:60%;" textField="name" valueField="id" emptyText="请选择..." 
									url="${ctxPath}/bpm/form/bpmFormView/getDetailTemplates.do"  
									required="true"  showNullItem="true" nullItemText="请选择..."/> 
						</td>
					</tr>
					<tr id="self_row">
						<th class="form-table-th">初始数据</th>
						<td colspan="3" class="form-table-td">
							<input class="mini-textarea" id="initData" name="initData" style="width:80%;height:30px;"/>
						</td>
					</tr>
					<tr>
						<th class="form-table-th">
							控件长
						</th>
						<td colspan="3" class="form-table-td">
							<input id="mwidth" name="mwidth" class="mini-spinner" style="width:80px" value="0" minValue="0" maxValue="1200"/>
							<input id="wunit" name="wunit" class="mini-combobox" style="width:50px" onvaluechanged="changeMinMaxWidth"
							data="[{'id':'px','text':'px'},{'id':'%','text':'%'}]" textField="text" valueField="id"
						    value="px"  required="true" allowInput="false" />

							&nbsp;&nbsp;高:<input id="mheight" name="mheight" class="mini-spinner" style="width:80px" value="0" minValue="0" maxValue="1200"/>
							<input id="hunit" name="hunit" class="mini-combobox" style="width:50px" onvaluechanged="changeMinMaxHeight"
							data="[{'id':'px','text':'px'},{'id':'%','text':'%'}]" textField="text" valueField="id"
						    value="px"  required="true" allowInput="false" />
						</td>
					</tr>
				</table>
			</form>
			</div>
	</div>
	<script type="text/javascript">
		
		mini.parse();
		var form=new mini.Form('miniForm');
		
		var grid=mini.get('hdgrid');
		//编辑的控件的值
		var oNode = null,
		thePlugins = 'rx-grid';
		function changeFrom(){
			var val=mini.get('from').getValue();
			if(val=='self'){
				$("#self_row").css('display','');
				$("#url_row").css('display','none');
			}else{
				$("#self_row").css('display','none');
				$("#url_row").css('display','');
			}
		}
		
		
		function changeEditType(){
			var edittype=mini.get('edittype').getValue();
			if(edittype=='openwindow'){
				$("#tmprow").css('display','');
			}else{
				$("#tmprow").css('display','none');
			}
		}
		
		window.onload = function() {
			//若控件已经存在，则设置回调其值
		    if( UE.plugins[thePlugins].editdom ){
		        //
		    	oNode = UE.plugins[thePlugins].editdom;
		        //获得字段名称
		        var formData={};
		        var attrs=oNode.attributes;
		        
		        for(var i=0;i<attrs.length;i++){
		        	formData[attrs[i].name]=attrs[i].value;
		        }
		        
		        form.setData(formData);
		        //恢复表格的表头
		        var headers=[];
		        var row=$(oNode).find('table > thead > tr');
		        
		        row.children().each(function(){
		        	var key=$(this).attr('header');
		        	var name=$(this).html().trim();
		        	var width=$(this).attr('width');
		        	var format=$(this).attr('format');
		        	if(width==undefined){
		        		width=100;
		        	}
		        	headers.push({key:key,name:name,width:width,format:format});
		        });
		        grid.setData(headers);
		    }
			
		    //changeFrom();
		    changeEditType();
		}
		
		//添加行
		function addRow(){
			grid.addRow({});
		}
		
		function removeRow(){
			var selecteds=grid.getSelecteds();
			if(selecteds.length>0 && confirm('确定要删除？')){
				grid.removeRows(selecteds);
			}
		}
		
		function upRow() {
            var row = grid.getSelected();
            if (row) {
                var index = grid.indexOf(row);
                grid.moveRow(row, index - 1);
            }
        }
        function downRow() {
            var row = grid.getSelected();
            if (row) {
                var index = grid.indexOf(row);
                grid.moveRow(row, index + 2);
            }
        }
		
		//取消按钮
		dialog.oncancel = function () {
		    if( UE.plugins[thePlugins].editdom ) {
		        delete UE.plugins[thePlugins].editdom;
		    }
		};
		//确认
		dialog.onok = function (){
			form.validate();
	        if (form.isValid() == false) {
	            return false;
	        }
	        var isCreate=false;
	        var formData=form.getData();
	        
	        //创新新控件
	        if( !oNode ) {
	        	isCreate=true;
		      
		            oNode = createElement('div',name);
		            oNode.setAttribute('class','rx-grid rxc');
		            
		            //需要设置该属性，否则没有办法其编辑及删除的弹出菜单
		            oNode.setAttribute('plugins',thePlugins);
		            
		            var table=$('<table></table>');
		            var gridData=grid.getData();
		            var thead=$("<thead></thead>");
		            var tbody=$("<tbody></tbody>");
		            var hrow=$("<tr></tr>");
		            var brow=$("<tr></tr>");
		            //添加表头
		            for(var i=0;i<gridData.length;i++){
		            	var format=gridData[i].format?gridData[i].format:'';
		            	var td='<th class="header" width="'+gridData[i].width + '" header="'+gridData[i].key+'" format="'+format+'">'+gridData[i].name+'</th>';
		            	var td2='<td header="'+gridData[i].key+'"></td>';
		            	hrow.append(td);
		            	brow.append(td2);
		            }
		            thead.append(hrow);
		            tbody.append(brow);
		            table.append(thead);
		            table.append(tbody);
		           	var initData=$("<div class='_initdata'></div>");
		            $(oNode).append(initData);
		            $(oNode).append(table);
		        
	        }else{//更新表头
	            var gridData=grid.getData();
	            var hrow=$(oNode).find('table >thead > tr');
	            var brow=$(oNode).find('table > tbody > tr:first');
	            
	            var nbrow=$("<tr></tr>");
	            //清空旧表头的内容
	            hrow.empty();
	            //添加表头
	            for(var i=0;i<gridData.length;i++){
	            	var format=(gridData[i].format)? gridData[i].format: '';
	            	var td='<th class="header" width="'+gridData[i].width + '" header="'+gridData[i].key+'" format="'+format+'">'+gridData[i].name+'</th>';
	            	hrow.append(td);
	            	var td=brow.children('[header="'+gridData[i].key+'"]');
	            	var tdHtml=$(td).html();
	            	if(typeof(tdHtml)=='undefined'){
	            		tdHtml='';
	            	}
	            	nbrow.append('<td header="'+gridData[i].key+'">'+tdHtml+'</td>');
	            }
	            //移除旧的行
	            brow.remove();
	            //添加新的行
	            $(oNode).children('table').children('tbody').append(nbrow);
	        }

	        //更新控件Attributes
	        var style="border: dashed 1px #ccc;padding:4px;background-color:#F0F8C7;";
            if(formData.mwidth!=0){
            	style+="width:"+formData.mwidth+formData.wunit+";";
            }
            if(formData.mheight!=0){
            	style+="height:"+formData.mheight+formData.hunit+";";
            }
            oNode.setAttribute('style',style);
            
            for(var key in formData){
            	oNode.setAttribute(key,formData[key]);
            }
			
            //弹出窗口
            var edittype=formData.edittype;
            if(edittype=='openwindow' && isCreate ){//
            	//查找其下弹出窗口，并且加载模板显示控件，允许用户自己填写控件
            	var formWin='<div id="editWindow_'+formData.name+'" class="mini-window" title="编辑信息" style="width:650px;"   showMaxButton="true" showModal="true" allowResize="true" allowDrag="true">';
            	
            	formWin+='<div class="mini-toolbar" style="padding:4px;border-bottom:none;height:26px;"> ';   
            	formWin+='<a class="mini-button" iconCls="icon-save" plain="true" onclick="saveFormDetail(\''+formData.name+'\')">保存</a>';
            	formWin+='<a class="mini-button" iconCls="icon-close" plain="true" onclick="closeFormDetail(\''+formData.name+'\')">关闭</a>';
            	formWin+='</div>';
            	
            	formWin+='<div id="editForm_'+formData.name+'" class="form">';
				formWin+='<input class="mini-hidden" name="_uid"/>';
            	var json = $.ajax({
            		  url: "${ctxPath}/bpm/form/bpmFormView/getTemplateHtml.do?templateId="+formData.templateid,
            		  async: false
            	}).responseText; 
            	try{
	            	var html=mini.decode(json).data;
	            	formWin+=html;
            	}catch(ex){
            		alert(ex);
            	}
	            
	            formWin+='</div></div>';
	           
	            $(oNode).append(formWin);
            }else{
            	$(oNode).children('.mini-window').attr('id','editWindow_'+formData.name);
            	$(oNode).children('.mini-window').children('.form').attr('id','editForm_'+formData.name);
            }
            
    	 	if(isCreate){
	        	editor.execCommand('insertHtml',oNode.outerHTML);
	     	}else{
	        	delete UE.plugins[thePlugins].editdom;
	     	}
		};
		
	</script>
</body>
</html>
