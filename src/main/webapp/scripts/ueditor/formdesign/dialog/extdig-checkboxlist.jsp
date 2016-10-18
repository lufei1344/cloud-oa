<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="ui" uri="http://www.redxun.cn/formUI" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 	<title>复选按钮列表-mini-checkboxlist</title>
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
				<table class="form-table" cellpadding="1" cellspacing="0">
					<caption>复选按钮列表属性配置</caption>
					<tr>
						<th class="form-table-th">字段备注*</th>
						<td class="form-table-td">
							<input class="mini-textbox" name="label" required="true" vtype="maxLength:100"  style="width:90%" emptytext="请输入字段备注" />
						</td>
						<th class="form-table-th">字段标识*</th>
						<td class="form-table-td">
							<input name="name" class="mini-treeselect" url="${ctxPath}/bpm/bm/bpmFormModel/getModelAttTree.do?modelId=${param['modelId']}" multiSelect="false"  valueFromSelect="false" emptytext="请输入字段标识，为英文开头或与数字组合" style="width:90%"
						        textField="key" valueField="key" parentField="parentId"  allowInput="true" onvalidation="onKeyValidation" required="true"
						        onvaluechanged="fieldChange"
						        showRadioButton="true" showFolderCheckBox="false"/>
						</td>
					</tr>
					
					<tr>
						<th class="form-table-th">值来源</th>
						<td colspan="3" class="form-table-td">
							<div id="from" name="from" class="mini-radiobuttonlist" onvaluechanged="fromChanged" required="true"
							data="[{id:'self',text:'自定义'},{id:'url',text:'URL'},{id:'dic',text:'数据字典'},{id:'sql',text:'自定义SQL'}]" value="self"></div>
						</td>
					</tr>
					<tr id="url_row" style="display:none">
						<th class="form-table-th">
							JSON URL
						</th>
						<td class="form-table-td" colspan="2">
							<input id="url" class="mini-textbox" name="url" required="true" style="width:99%"/>
						</td>
						<td class="form-table-td">
						文本字段:<input id="url_textfield" class="mini-textbox" name="url_textfield" style="width:80px" required="true">&nbsp;-&nbsp;数值字段:<input id="url_valuefield" class="mini-textbox" name="url_valuefield" required="true" style="width:80px">
						</td>
					</tr>
					<tr id="dic_row" style="display:none">
						<th class="form-table-th">
							数据字典项
						</th>
						<td class="form-table-td" colspan="3">
							<input name="dickey" class="mini-treeselect" url="${ctxPath}/sys/core/sysTree/listDicTree.do"  style="width:80%"
						        textField="name" valueField="key" parentField="parentId" 
						        showRadioButton="true" showFolderCheckBox="false"/>
						</td>
					</tr>
					<tr id="selfSQL_row" style="display: none">
						<th class="form-table-th">自定SQL设置</th>
						<td colspan="3" style="padding: 5px;" class="form-table-td"><input id="sql" name="sql" value="${sysDbSql.key}"  text="${sysDbSql.sql}"  style="width: 250px;" class="mini-buttonedit" onbuttonclick="onButtonEdit_sql" />&nbsp;&nbsp;&nbsp;&nbsp;文本字段:<input id="sql_textfield" name="sql_textfield" class="mini-combobox" style="width: 100px;"  data=""  valueField="field"  textField="header"  required="true" allowInput="false" enabled="false" /> &nbsp;-&nbsp;数值字段:<input id="sql_valuefield" name="sql_valuefield" class="mini-combobox" style="width: 100px;" valueField="field"  textField="header"  value="" required="true"
							allowInput="false" enabled="false" /></td>
					</tr>					
					<tr id="self_row" style="display:none">
						<th class="form-table-th">选项</th>
						<td colspan="3" style="padding:5px;" class="form-table-td">
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
							<div id="props" class="mini-datagrid" style="width:100%;min-height:100px;" height="auto" showPager="false"
								allowCellEdit="true" allowCellSelect="true">
							    <div property="columns">
							        <div type="indexcolumn"></div>                
							        <div field="key" width="120" headerAlign="center">标识键
							         <input property="editor" class="mini-textbox" style="width:100%;" minWidth="120" />
							        </div>    
							        <div field="name" width="120" headerAlign="center">名称
							        	<input property="editor" class="mini-textbox" style="width:100%;" minWidth="120" />
							        </div>    
							    </div>
							</div>
						</td>
					</tr>
					<tr>
						<th class="form-table-th">排版方式</th>
						<td class="form-table-td">
							<div name="repeatLayout" class="mini-radiobuttonlist" repeatItems="4" repeatLayout="table" repeatDirection="horizontal"
								value="flow" data="[{id:'none',text:'无'},{id:'table',text:'表格'},{id:'flow',text:'流式布局'}]" ></div>
						</td>
						<th class="form-table-th">排版方向</th>
						<td class="form-table-td">
							<div name="repeatDirection" class="mini-radiobuttonlist" repeatItems="4" repeatLayout="table" repeatDirection="horizontal"
								value="flow" data="[{id:'horizontal',text:'横排'},{id:'vertical',text:'纵排'}]" ></div>
						</td>
					</tr>
					<tr>
						<th class="form-table-th">每行项数</th>
						<td class="form-table-td" colspan="3">
							<input  name="repeatitems" class="mini-spinner"  minValue="1" maxValue="50"  value="5"/>
						</td>
					</tr>
					<tr>
						<th class="form-table-th">必填*</th>
						<td class="form-table-td">
							<input class="mini-checkbox" name="required" id="required"/>是
						</td>
						<th class="form-table-th">默认值</th>
						<td class="form-table-td" colspan="3">
							<input class="mini-textbox" name="value" style="width:80%"/>
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
		var grid=mini.get('props');
		//编辑的控件的值
		var oNode = null,
		thePlugins = 'mini-checkboxlist';
		
		/*点击选择自定义SQL对话框时间处理*/
		function onButtonEdit_sql(e) {
			var btnEdit = this;
			mini.open({
						url : "${ctxPath}/sys/core/sysDbSql/dialog.do",
						title : "选择自定义SQL",
						width : 650,
						height : 380,
						ondestroy : function(action) {
							if (action == "ok") {
								var iframe = this.getIFrameEl();
								var data = iframe.contentWindow.GetData();
								data = mini.clone(data); 
								if (data) {
									btnEdit.setValue(data.key);   //设置自定义SQL的Key
									btnEdit.setText(data.sql);
									_SubmitJson({                             //根据SQK的KEY获取SQL的列名和列头
										url:"${ctxPath}/sys/core/sysDbSql/querycolumns.do",
										data:{
											key:data.key
										},
										showMsg:false,
										method:'POST',
										success:function(result){
											var data=result.data;
											var text=mini.get("sql_textfield");
											var value=mini.get("sql_valuefield");
											text.setEnabled(true);   //设置下拉控件为可用状态
											value.setEnabled(true);
											text.setData();          //每次选择不同SQL，清空下拉框的数据
											value.setData();
											text.setData(data);      //设置下拉框的数据
											value.setData(data);
										}
									});
								}
							}
						}
					});
		}
		
		/*数据来源点击事件处理*/
		function fromChanged(e){
			var val=mini.get('from').getValue();
			if(val=='self'){
				$("#self_row").css('display','');
				$("#url_row").css('display','none');
				$("#dic_row").css('display','none');
				$("#selfSQL_row").css('display','none');
			}else if(val=='url'){
				$("#self_row").css('display','none');
				$("#url_row").css('display','');
				$("#dic_row").css('display','none');
				$("#selfSQL_row").css('display','none');
			}else if(val=='dic'){
				$("#self_row").css('display','none');
				$("#url_row").css('display','none');
				$("#dic_row").css('display','');
				$("#selfSQL_row").css('display','none');
			}else if(val=='sql'){
				$("#self_row").css('display','none');
				$("#url_row").css('display','none');
				$("#dic_row").css('display','none');
				$("#selfSQL_row").css('display','');
			}
		}
		//添加行
		function addRow(){
			grid.addRow({},0);
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
		
		window.onload = function() {
			//若控件已经存在，则设置回调其值
		    if( UE.plugins[thePlugins].editdom ){
		        //
		    	oNode = UE.plugins[thePlugins].editdom;
		        //获得字段名称
		        var formData={};
		        var attrs=oNode.attributes;
		        
		        for(var i=0;i<attrs.length;i++){
		        	if(attrs[i].name=='data'){
		        		grid.setData(mini.decode(attrs[i].value));	
		        	}else{
		        		formData[attrs[i].name]=attrs[i].value;
		        	}
		        }
	        	if(formData['from']=='sql'){     //自定义SQL的KEY属性
	        		var btnEdit=mini.get("sql");
					btnEdit.setValue(formData['sql']);  //设置KEY属性
					_SubmitJson({      //根据sql的Key获取SQL
						url:"${ctxPath}/sys/core/sysDbSql/getdata.do",
						data:{
							key:formData['sql']
						},
						showMsg:false,
						method:'POST',
						success:function(result){
							btnEdit.setText(result.data.sql);  //设置自定义SQL值的显示
							_SubmitJson({     //根据sql的key 获取列名
								url:"${ctxPath}/sys/core/sysDbSql/querycolumns.do",
								data:{
									key:result.data.key
								},
								showMsg:false,
								method:'POST',
								success:function(result){
									var data=result.data;
									var text=mini.get("sql_textfield");
									var value=mini.get("sql_valuefield");
									text.setEnabled(true);          //设置下拉框为可用状态
									value.setEnabled(true);	
									text.setData(data);    //设置下拉框数据
									value.setData(data);
								}
							});
						}
					});
	        	} 
		        form.setData(formData);
		    }
		    fromChanged();  //触发数据来源事件处理
		};
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
		        try {
		            oNode = createElement('input',name);
		            oNode.setAttribute('class','mini-checkboxlist rxc');
		            //需要设置该属性，否则没有办法其编辑及删除的弹出菜单
		            oNode.setAttribute('plugins',thePlugins);
		        }catch(e){
		        	alert('error');
		        	return;
		        }
	        }
	        //更新控件Attributes
	        var style="";
            if(formData.mwidth!=0){
            	style+="width:"+formData.mwidth+formData.wunit;
            }
            if(formData.mheight!=0){
            	if(style!=""){
            		style+=";";
            	}
            	style+="height:"+formData.mheight+formData.hunit;
            }
            oNode.setAttribute('style',style);
            
            for(var key in formData){
            	oNode.setAttribute(key,formData[key]);
            }

            var from=mini.get('from').getValue();
          //数据来源判断
            if(from=='self'){//来自自定义
  		    	oNode.setAttribute('textfield','name');
  		    	oNode.setAttribute('valuefield','key');  	
  		    	oNode.setAttribute('dickey','');
  		    	oNode.setAttribute('url','');            //设置url来源的相关属性为空
  		    	oNode.setAttribute('url_textfield','');
  		    	oNode.setAttribute('url_valuefield','');
  		    	oNode.setAttribute('sql_textfield','');  //设置自定义SQL来源的相关属性为空
  		    	oNode.setAttribute('sql_valuefield','');
  		    	oNode.setAttribute('sql','');
  		    	var gridData=grid.getData();
  		    	oNode.setAttribute('data',mini.encode(gridData));
  	    	}else if(from=='url'){//来自url
  	    		oNode.setAttribute('data','');  
  	    		oNode.setAttribute('dickey','');
  		    	oNode.setAttribute('sql_textfield','');    //设置自定义SQL来源的相关属性为空
  		    	oNode.setAttribute('sql_valuefield','');
  	    		oNode.setAttribute('sql','');
  	    		oNode.setAttribute('textfield',oNode.getAttribute('url_textfield'));
  		    	oNode.setAttribute('valuefield',oNode.getAttribute('url_valuefield'));
  	    	}else if(from=='dic'){//来自数据字典
  	    		oNode.setAttribute('data','');
  	    		oNode.setAttribute('url','');     //设置url来源的相关属性为空
  		    	oNode.setAttribute('url_textfield','');
  		    	oNode.setAttribute('url_valuefield','');
  		    	oNode.setAttribute('sql_textfield','');  //设置自定义SQL来源的相关属性为空
  		    	oNode.setAttribute('sql_valuefield','');
  	    		oNode.setAttribute('sql','');
  	    		oNode.setAttribute('textfield','name');
  		    	oNode.setAttribute('valuefield','key');
  	    	}else if(from=='sql'){//来自自定义SQL
  	    		oNode.setAttribute('data','');      
  	    		oNode.setAttribute('url','');      //设置url来源的相关属性为空
  		    	oNode.setAttribute('url_textfield','');
  		    	oNode.setAttribute('url_valuefield','');
  	    		oNode.setAttribute('dickey','');
  	    		oNode.setAttribute('textfield',oNode.getAttribute('sql_textfield'));
  		    	oNode.setAttribute('valuefield',oNode.getAttribute('sql_valuefield'));
  	    	}
	    	 if(isCreate){
	    		 //创建选项
	    		 editor.execCommand('insertHtml',oNode.outerHTML);
		     }else{
		         delete UE.plugins[thePlugins].editdom;
		     }
		};
		
	</script>
</body>
</html>
