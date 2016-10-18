<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>业务表单视图编辑</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link href="${ctxPath}/scripts/ueditor/formdesign/images/icons.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" charset="utf-8" src="${ctxPath}/scripts/ueditor/ueditor-fd-config.js"></script>
<script type="text/javascript" charset="utf-8" src="${ctxPath}/scripts/ueditor/ueditor-fd.all.js"> </script>
<script type="text/javascript" charset="utf-8" src="${ctxPath}/scripts/ueditor/lang/zh-cn/zh-cn.js"></script>
<!-- 引入表单控件 -->
<script type="text/javascript" charset="utf-8" src="${ctxPath}/scripts/ueditor/formdesign/design-plugin.js"></script>

<style type="text/css">
html,body
{
    width:100%;
    height:100%;
    border:0;
    margin:0;
    padding:0;
    overflow:visible;
}
</style>
</head>
<body>
	
	<div class="mini-toolbar" style="padding:0px;">
           <table style="width:100%;">
               <tr>
                   <td style="width:100%;">
                       <a  class="icon-textbox" plain="true" onclick="exePlugin('extdig-textbox')">文本控件</a>
                       <a  class="icon-textarea" plain="true" onclick="exePlugin('extdig-textarea')">多行文本控件</a>
                       <a  class="icon-checkbox" plain="true" onclick="exePlugin('extdig-checkbox')">复选框</a>
                       <a  class="icon-radiobuttonlist" plain="true" onclick="exePlugin('extdig-radiobuttonlist')">单选按钮列表</a>
                       <a  class="icon-checkboxlist" plain="true" onclick="exePlugin('extdig-checkboxlist')">复选按钮列表</a>
                       <a  class="icon-combobox" plain="true" onclick="exePlugin('extdig-combobox')">下拉框控件</a>
                       <a  class="icon-datepicker" plain="true" onclick="exePlugin('extdig-datepicker')">日期控件</a>
                       <a  class="icon-monthpicker" plain="true" onclick="exePlugin('extdig-monthpicker')">月份控件</a>
                       <a  class="icon-timespinner" plain="true" onclick="exePlugin('extdig-timespinner')">时间输入框</a>
                       <a  class="icon-spinner" plain="true" onclick="exePlugin('extdig-spinner')">数据输入框</a>
                       <a  class="icon-ueditor" plain="true" onclick="exePlugin('extdig-ueditor')">富文本输入框</a>
                       <a  class="icon-user" plain="true" onclick="exePlugin('extdig-user')">用户选择框</a>
                       <a  class="icon-group" plain="true" onclick="exePlugin('extdig-group')">用户组选择框</a>
                       <a  class="icon-upload" plain="true" onclick="exePlugin('upload-panel')">上传控件</a>
                       <a  class="icon-hidden" plain="true" onclick="exePlugin('extdig-hidden')">隐藏域控件</a>
                       <a  class="icon-buttonedit" plain="true" onclick="exePlugin('extdig-buttonedit')">按钮输入框</a>
                       <a  class="icon-dep" plain="true" onclick="exePlugin('extdig-dep')">部门选择控件</a>
                       <a  class="rx-grid" plain="true" onclick="exePlugin('rx-grid')">表格控件</a>
                       <a  class="icon-treeselect" plain="true" onclick="exePlugin('extdig-treeselect')">下拉树选择控件</a>
                       <a  class="icon-btn" plain="true" onclick="exePlugin('extdig-button')">自定义按钮</a>
                   </td>
               </tr>
         </table>
       </div>
	<script id="templateView" name="templateView" type="text/plain" style="width:100%;height:500px;"></script>
								
	
	<script type="text/javascript">
		
		var templateView = UE.getEditor('templateView');
		
		templateView.addListener("ready", function () {
			//采用后加载方式加载html编辑器的内容
			var pkId="";
			if(pkId.trim()=='')return;
			_SubmitJson({
				url:__rootPath+'/bpm/form/bpmFormView/getTemplateView.do?viewId='+pkId,
				showMsg:false,
				success:function(result){
					templateView.setContent(result.data);		
				}
			})
		});
		
		$(function(){
			
			
			
			typeChanged();
		});
		
		function bindMd(obj){
			if(obj.checked){
				$("#md1").css('display','');
				mini.get('genButton').show();
			}else{
				$("#md1").css('display','none');
				mini.get('genButton').hide();
			}
		}
		
		function changeFormType(e){
			var val=this.getValue();
			var formTab=tabs.getTab('formDesignTab');
			if(val=='ONLINE-DESIGN'){
				tabs.updateTab(formTab, { visible: true });
			}else{
				tabs.updateTab(formTab, { visible: false });
			}
		}
		
		function getModelId(){
			return mini.get('fmId').getValue();
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
	        	url:__rootPath+"/bpm/form/bpmFormView/save.do",
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
		
	
		
	    function deploy() {
	    	var form = new mini.Form("form1");
	    	form.validate();
	        if (form.isValid() == false) {
	            return;
	        }
	        
	        var formData=$("#form1").serializeArray();
            formData.push({
	        	name:'deploy',
	        	value:true
	        });
	        
	        _SubmitJson({
	        	url:__rootPath+"/bpm/form/bpmFormView/save.do",
	        	method:'POST',
	        	data:formData,
	        	success:function(result){
	        		CloseWindow('ok');
	        	}
	        });
	     }
	    
	    function deployNew(){
	    	var form = new mini.Form("form1");
	    	form.validate();
	        if (form.isValid() == false) {
	            return;
	        }
	        
	        var formData=$("#form1").serializeArray();
            formData.push({
	        	name:'deployNew',
	        	value:true
	        });
	        
	        _SubmitJson({
	        	url:__rootPath+"/bpm/form/bpmFormView/save.do",
	        	method:'POST',
	        	data:formData,
	        	success:function(result){
	        		CloseWindow('ok');
	        	}
	        });
	    }
	    
	    function previewRight(){
	    	var formViewId='${bpmFormView.viewId}';
	    	preview(formViewId);
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
		
		//选择模型
		function onSelecFormModel(){
			_OpenWindow({
				url:__rootPath+'/bpm/bm/bpmFormModel/dialog.do?single=true',
				title:'业务模型选择器',
				height:450,
				width:800,
				ondestroy:function(action){
					if(action!='ok')return;
					var iframe = this.getIFrameEl();
		            var model=iframe.contentWindow.getFormModel();
		           
		            var fmId=mini.get('fmId');
		            fmId.setValue(model.fmId);
		            fmId.setText(model.name);
				}
			});
		}
		//生成业务模型HTML
		function genFormHtml(){
			var templateId=mini.get('templateId').getValue();
			
			if(templateId==''){
				alert('请选择模板类型！');
				return;
			}
			var fmId=mini.get('fmId').getValue();
			_SubmitJson({
				url:__rootPath+'/bpm/form/bpmFormView/genTemplateHtml.do?templateId='+templateId + "&fmId="+fmId,
				method:'POST',
				success:function(result){
					templateView.setContent(result.data);
				}
			});
		}
	</script>
</body>
</html>