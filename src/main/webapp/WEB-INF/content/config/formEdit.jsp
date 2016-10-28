<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>表单管理</title>
    <link rel="shortcut icon" href="favicon.ico">
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet">
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
    <!-- ueditor -->
    <link href="${ctxPath}/scripts/ueditor/formdesign/images/icons.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" charset="utf-8" src="${ctx}/scripts/ueditor/ueditor.config.js"></script>
	<script type="text/javascript" charset="utf-8" src="${ctx}/scripts/ueditor/ueditor.all.js"> </script>
	<script type="text/javascript" charset="utf-8" src="${ctx}/scripts/ueditor/lang/zh-cn/zh-cn.js"></script>
		<!-- 引入表单控件 -->
	<script type="text/javascript" charset="utf-8" src="${ctx}/scripts/ueditor/formdesign/design-plugin.js"></script>
	</head>

	<body>
		<div class="mini-toolbar" style="padding:0px;">
			<table style="width:100%;">
				<tr>
					
					<td>
						<input type="image" src="${ctx}/scripts/ueditor/formdesign/images/icons/formtext.gif"
							onclick="exePlugin('extdig-textbox')" title="插入输入框">
						<input type="image" src="${ctx}/scripts/ueditor/formdesign/images/icons/formtext.jpg"
							onclick="formatit('InsertInputHidden','true','aa');" title="插入隐藏框">	
						<input type="image" src="${ctx}/scripts/ueditor/formdesign/images/icons/formtextarea.gif"
							onclick="exePlugin('extdig-textarea')" title="插入输入域">
						<input type="image" src="${ctx}/scripts/ueditor/formdesign/images/icons/formradio.gif"
							onclick="exePlugin('extdig-radiobuttonlist')" title="插入单选框">	
						<input type="image" src="${ctx}/scripts/ueditor/formdesign/images/icons/formcheckbox.gif"
							onclick="exePlugin('extdig-checkboxlist')" title="插入复选框">	
						<input type="image" src="${ctx}/scripts/ueditor/formdesign/images/icons/formdropdown.gif"
							onclick="exePlugin('extdig-combobox')" title="插入下拉框">	
						<input type="image" src="${ctx}/scripts/ueditor/formdesign/images/icons/formFile.gif"
							onclick="exePlugin('upload-panel')" title="插入上传文件">
						<input type="image" src="${ctx}/scripts/ueditor/formdesign/images/icons/tableinsert.gif"
							onclick="exePlugin('extdig-grid')" title="二维表">	
						<input type="image" src="${ctx}/scripts/ueditor/formdesign/images/icons/save.png"
							onclick="exePlugin('extdig-save');" title="保存">			
					</td>
				</tr>
			</table>
       </div>
	<script id="templateView" name="templateView" type="text/plain" style="width:100%;height:500px;"></script>
								
	<input type="hidden" id="id" value="${form.id}">
	<input type="hidden" id="name" value="${form.name}">
	<input type="hidden" id="displayName" value="${form.displayName}">
	<input type="hidden" id="type" value="${form.type}">
	<input type="hidden" id="formType" value="${form.formType}">
	<textarea id="contentHtml" style="display: none;">${form.contentHtml }</textarea>
	<script type="text/javascript">
		
		var templateView = UE.getEditor('templateView');
		
		templateView.addListener("ready", function () {
			templateView.setContent($("#contentHtml").val());		
		});
		
		function getModelId(){
			return "${form.id}";
		}
		
		//保存不关闭
		function saveNoExit(){
			
			var form=new mini.Form("form1");
			form.validate();
			if(!form.isValid()){
				return;
			}
			var formData=$("#form1").serializeArray();
			_SubmitJson({
	        	url:__rootPath+"/config/form/update",
	        	method:'POST',
	        	data:formData,
	        	success:function(result){
	        		var rep=mini.decode(result);
	        		var obj=rep.data;
	        		$("#fmId").val(obj.fmId);
	        	}
	        });
		}
		
		function exePlugin(pluginName){
			templateView.execCommand(pluginName);
		}
		
	
	   
	    //预览
	    function preview(viewId){
	 		if(viewId==undefined){
	 			viewId='';
	 		}
	    	_SubmitJson({
	    		url:__rootPath+'/bpm/form/bpmFormView/parseFormTemplate.do?viewId='+viewId,
	    		method:'POST',
	    		showMsg:false,
	    		data:{
	    			templateHtml:templateView.getContent(),
	    			json:'{}'
	    		},
	    		success:function(result){
	    			_OpenWindow({
	    	    		url:__rootPath+'/bpm/form/bpmFormView/preview.do',
	    	    		title:'表单预览',
	    	    		width:780,
	    	    		height:400,
	    	    		max:true,
	    	    		onload:function(){
	    	    			 var iframe = this.getIFrameEl();
	    	    			 var content=result.data;
	                         iframe.contentWindow.setContent(content);
	    	    		}
	    	    	});	
	    		}
	    	});
	    }
		
		function clearFormModel(){
			var fmId=mini.get('fmId');
			fmId.setValue('');
			fmId.setText('');
		}
		
		function onClearTree(){
			var treeId=mini.get('treeId');
			treeId.setValue('');
			treeId.setText('');
		}
		
		
	</script>
	</body>
</html>
