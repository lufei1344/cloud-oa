

/**
 * 自动定义按钮，点击弹出自定义对话框
 * @param e
 */
function _OnSelDialogShow(e){
	var button=e.sender;
	var dialogid=button.dialogid;
	var dialogname=button.dialogname;
	var returnFields=button.returnFields;
	
	var fields=mini.decode(returnFields);
	var callback=button.callback;
	
	_OpenWindow({
		title:dialogname,
		url:__rootPath+'/sys/core/sysDefDialog/show.do?id='+dialogid,
		width:700,
		height:450,
		ondestroy:function(action){
			if(action!='ok'){return;}
			var win = this.getIFrameEl().contentWindow;
			var data=win.getData();
			if(data!=null && data.length>0){
				data=data[0];
				for(var i=0;i<fields.length;i++){
					var ctl=mini.getbyName(fields[i]['bindField']);
					if(ctl){
						ctl.setValue(data[fields[i]['field']]);
					}
				}
			}else if(callback){
				callback.call(this,data);
			}
		}
	});
}


/**
 * 用户选择按钮点击事件
 * @param e
 */
function _UserButtonClick(e){
	var userSel=e.sender;
	var single=userSel.single;
	_UserDlg(single,function(users){
		if(single){
			userSel.setValue(users.userId);
			userSel.setText(users.fullname);
		}else{
			var uIds=[];
			var uNames=[];
			for(var i=0;i<users.length;i++){
				uIds.push(users[i].userId);
				uNames.push(users[i].fullname);
			}
			userSel.setValue(uIds.join(','));
			userSel.setText(uNames.join(','));
		}
	});
}
/**
 * 用户组选择按钮点击事件
 * @param e
 */
function _GroupButtonClick(e){
	var groupSel=e.sender;
	var single=groupSel.single;
	if(single=='true'){
		single=true;
	}else{
		single=false;
	}
	var showDim=groupSel.showDim;
	var dimId=groupSel.dimId;
	var callback=function(groups){
		if(single=='true'){
			groupSel.setValue(groups.groupId);
			groupSel.setText(groups.name);
		}else{
			var uIds=[];
			var uNames=[];
			for(var i=0;i<groups.length;i++){
				uIds.push(groups[i].groupId);
				uNames.push(groups[i].name);
			}
			groupSel.setValue(uIds.join(','));
			groupSel.setText(uNames.join(','));
		}
	};
	
	if(showDim=='true'){
		_GroupDlg(single,callback);
	}else{
		_GroupSingleDim(single,dimId,callback);
	}
}

/**
 * 部门按钮的点击事件
 * @param e
 */
function _DepButtonClick(e){
	var depSel=e.sender;	
	var single=depSel.single;

	if(single=='true'){
		single=true;
	}else{
		single=false;
	}
	
	var callback=function(groups){
		if(single){
			depSel.setValue(groups.groupId);
			depSel.setText(groups.name);
		}else{
			var uIds=[];
			var uNames=[];
			for(var i=0;i<groups.length;i++){
				uIds.push(groups[i].groupId);
				uNames.push(groups[i].name);
			}
			depSel.setValue(uIds.join(','));
			depSel.setText(uNames.join(','));
		}
	};
	_DepDlg(single,callback);
}

//解析grid中的html，以转成-grid的html格式
function parseGridPlugins(){
	//列表控件
	$('div.rx-grid').each(function(){$(this).GenGrid();});
}

//解析扩展的插件
function parseExtendPlugins(){
	//自定义富文本
	var useUeditor=false;
	$('.mini-textarea.mini-ueditor').each(function(){
  		var obj=$(this);
  		var textarea=obj.find('span > textarea');
  		var randId=parseInt(Math.random()*100000);
  		$(this).replaceWith('<script id="'+ randId + '" name="'+ textarea.attr('name') + '" style="'+obj.attr('style')+'" class="mini-ueditor" type="text/plain">'+textarea.val()+'</script>');
  		useUeditor=true;
  	});
	
	if(useUeditor){
		//加载需要的ueditor需要的Js
		var jsArr=[
			__rootPath+'/scripts/ueditor/ueditor-mini.config.js',
			__rootPath+'/scripts/ueditor/ueditor.all.min.js',
			__rootPath+'/scripts/ueditor/lang/zh-cn/zh-cn.js'
		];
		
		$.getScripts({
			urls: jsArr,
			  cache: false,  // Default
			  async: false, // Default
			  success: function(response) {
				$("script.mini-ueditor").each(function(){
					var id=$(this).attr('id');
					UE.getEditor(id);
				});
			  }
		});
	}
	//上传控件
	$('.upload-panel').each(function(){$(this).uploadPanel();});
	
}

/**
 * 动态表单视图解析
 * @param conf
 *   taskId:
 *   instId:
 *   solId:
 *   三个ID仅需要传入其中之一即可
 *   containerId
 * 
 */
function reqFormParse(conf){
	
	if(!conf.taskId){
		conf.taskId='';
	}
	if(!conf.solId){
		conf.solId='';
	}
	
	if(!conf.instId){
		conf.instId='';
	}
	
	if(!conf.viewId){
		conf.viewId='';
	}
	
	_SubmitJson({
		url:__rootPath+'/bpm/form/bpmFormView/parseHtml.do?solId='+conf.solId+'&instId='+conf.instId+'&taskId='+conf.taskId +'&viewId='+conf.viewId,
		method:'POST',
		showMsg:false,
		success:function(result){
			$('#'+conf.containerId).html(result.data);
			parseGridPlugins();
			mini.parse();
			parseExtendPlugins();
			//初始化表格数据
			$('._initdata').each(function(){
				var gridId=$(this).attr('gridId');
				var grid=mini.get(gridId);
				var gridData=$(this).html().trim(); 
		        try{
		        	var json=mini.decode(gridData);
		        	grid.setData(json);
		        }catch(e){
		        	//console.log(e);
		        }
			});
		}
	});
}