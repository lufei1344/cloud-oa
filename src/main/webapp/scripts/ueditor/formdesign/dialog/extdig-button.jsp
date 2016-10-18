<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 	<title>按钮-mini-button</title>
	 	<script src="${ctxPath}/scripts/boot.js" type="text/javascript"></script>
	 	<script src="${ctxPath}/scripts/common/form.js" type="text/javascript"></script>
	 	<script src="${ctxPath}/scripts/share.js" type="text/javascript"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/dialogs/internal.js"></script>
	 	<script type="text/javascript" src="${ctxPath}/scripts/ueditor/form-design/config/plugin-libs.js"></script>
	 	<link href="${ctxPath}/styles/form.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<div style="width:100%;text-align: center">
		<div style="margin-left:auto;margin-right: auto;padding:5px;">
			<form id="miniForm">
				<table class="table-detail" cellspacing="0" cellpadding="1">
					<caption>按钮编辑框属性配置</caption>
					<tr>
						<th>字段备注*</th>
						<td>
							<input class="mini-textbox" name="label" required="true" vtype="maxLength:100,chinese"  style="width:90%" emptytext="请输入字段备注" />
						</td>
						<th>字段标识*</th>
						<td>
							<input name="name" class="mini-textbox" required="true"/>
						</td>
					</tr>
					<tr>
						<th>按钮样式</th>
						<td>
							<input class="mini-textbox" name="iconcls"/>
						</td>
						<th>按钮文本</th>
						<td>
							<input class="mini-textbox" name="text"/>
						</td>
					</tr>
					<tr>
						<th>自定义对话框</th>
						<td colspan="3">	
    						<div id="ckselfdlg" name="ckselfdlg" class="mini-checkbox" value="false" readOnly="false" text="是" onvaluechanged="onSelfDlgChanged"></div>
							<div id="bindDlgDiv" style="display:none">
								绑定的对话框&nbsp;
								<input class="mini-buttonedit" id="dialogid" name="dialogid" onclick="selectDialog"/>
								<input class="mini-hidden" name="dialogname" id="dialogname"/>
							</div>
						</td>
					</tr>
					<tr id="bindDlgTr" style="display:none">
						<th>返回值绑定</th>
						<td colspan="3">
							<div id="returnFields" class="mini-datagrid" style="width:100%;minHeight:120px" height="auto" showPager="false"
								allowCellEdit="true" allowCellSelect="true">
							    <div property="columns">
							        <div type="indexcolumn"></div> 
							        <div field="header" width="120" headerAlign="center">字段名称
							        	<input property="editor" class="mini-textbox" style="width:100%;" minWidth="120" />
							        </div>               
							        <div field="field" width="120" headerAlign="center">字段Key
							         	<input property="editor" class="mini-textbox" style="width:100%;" minWidth="140" />
							        </div>
							        <div field="bindField" width="120" headerAlign="center">绑定字段
							         	<input property="editor" class="mini-textbox" style="width:100%;" minWidth="140" />
							        </div>
							    </div>
							</div>
						</td>
					</tr>
					<tr id="eventTr">
						<th>
							按钮事件方法
						</th>
						<td colspan="3">
							<input name="onclick" class="mini-textbox" onvalidation="onKeyValidation"/>
						</td>
					</tr>
				</table>
			</form>
			</div>
	</div>
	<script type="text/javascript">
	
		function createElement(type, name){     
		    var element = null;     
		    try {        
		        element = document.createElement('a');
		        element.name = name;
		    } catch (e) {}   
		    if(element==null) {     
		        element = document.createElement(type);     
		        element.name = name;     
		    } 
		    return element;     
		}
		
		mini.parse();
		
		function onSelfDlgChanged(){
			var checked=mini.get('ckselfdlg').getValue();
			if(checked=='true'){
				$("#bindDlgDiv").css('display','');
				$("#bindDlgTr").css('display','');
				$("#eventTr").css('display','none');
			}else{
				$("#bindDlgDiv").css('display','none');
				$("#bindDlgTr").css('display','none');
				$("#eventTr").css('display','');
			}
		}
		
		var form=new mini.Form('miniForm');
		//编辑的控件的值
		var oNode = null,
		thePlugins = 'mini-button';
		var grid=mini.get('returnFields');
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
		        //设置其返回的字段绑定
		        mini.get('dialogid').setText(formData.dialogname);
		        var dataOptions=mini.decode(formData['data-options']);
		        if(dataOptions.returnFields){
		        	grid.setData(mini.decode(dataOptions.returnFields));
		        }
		    }
		    onSelfDlgChanged();
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
	        
	        var formData=form.getData();
	        var isCreate=false;
		    //控件尚未存在，则创建新的控件，否则进行更新
		    if( !oNode ) {
		        try {
		            oNode = createElement('a',name);
		            oNode.setAttribute('href','#');
		            oNode.setAttribute('class','mini-button rxc');
		            //需要设置该属性，否则没有办法其编辑及删除的弹出菜单
		            oNode.setAttribute('plugins',thePlugins);
		        } catch (e) {
		            try {
		                editor.execCommand('error');
		            } catch ( e ) {
		                alert('控件异常，请联系技术支持');
		            }
		            return false;
		        }
		        isCreate=true;
		    }

		    for(var key in formData){
            	oNode.setAttribute(key,formData[key]);
            }
		    
   			$(oNode).html(formData.text);
   			var fields=mini.get('returnFields').getData();
   			// 设置其数据属性
   		 	oNode.setAttribute("data-options","{dialogid:'"+formData.dialogid+"',dialogname:'"+formData.dialogname+"',returnFields:'"+mini.encode(fields)+"'}");
            if(isCreate){
	            editor.execCommand('insertHtml',oNode.outerHTML);
            }else{
            	delete UE.plugins[thePlugins].editdom;
            }
		};
		
		function selectDialog(){
			_OpenWindow({
				url:'${ctxPath}/sys/core/sysDefDialog/dialog.do',
				height:450,
				width:800,
				title:'选择对话框',
				ondestroy:function(action){
					if(action!='ok'){
						return;
					}
					var win=this.getIFrameEl().contentWindow;
					var rs=win.getData();
					if(rs){
						mini.get('dialogid').setValue(rs.id);
						mini.get('dialogid').setText(rs.name);
						mini.get('dialogname').setValue(rs.name);
						var headerJson=rs.header;
						mini.get('returnFields').setData(mini.decode(headerJson));
					}
				}
			});
		}
	</script>
</body>
</html>
