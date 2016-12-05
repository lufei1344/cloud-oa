<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>

<div class="panel panel-info">
    <div class="panel-heading">
        	名称：<input  id="name"  style="width:50%;" onkeypress="if(event.keyCode==13){search_ztree('treediv1', 'name');};"/>
        	<input type="button" class="btn btn-sm btn-primary" onclick="search_ztree('treediv1', 'name')" value="搜索"/>
    </div>
    <div class="panel-body">
        <ul id="treediv1" class="ztree"></ul>
        <div class="row" style="text-align: center;">
        	<input type="button" class="btn btn-sm btn-primary" value="确定" onclick="saveIt()"/>
        </div>
    </div>
</div>
<script type="text/javascript">
var ztree1 = null;
var setting = {
		data: {
			key: {
				name:"name"
			},
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "pid",
				rootPId: "0"
			}
		},
		check: {
			enable: true
		},
		view :{  
            fontCss: setFontCss_ztree  
        },
        callback:{
        	onDblClick: zTreeOnClick
        }
	};
	
function zTreeOnClick(event, treeId, treeNode) {
	
};	

var ids = "";
//加载树
function refreshTree() {
	if(ztree1 == null){
		jq.getJSON("${pageContext.request.contextPath}/flow/process/forms?s="+Math.random(),function(data){
			for(var i=0; i<data.obj.length; i++){
				if(data.obj[i].type == "type"){
					data.obj[i].nocheck=true;
				}
			}
			ztree1 = jq.fn.zTree.init(jq("#treediv1"), setting, data.obj);
			setValue();
		});
	}else{
		setValue();
	}
	
	
}


jq(function(){
	refreshTree();
});	

function setValue(){
	var forms = jq("#forms").val();
	var fields = jq("#fields").val();
	if(forms != ""){
		ids += forms;
	}
	if(fields != ""){
		if(ids != ""){
			ids += ","+fields;
		}else{
			ids =+ fields;
		}
	}
	
	var node = ztree1.getNodes();
	for(var i=0; i<node.length; i++){
		if(ids.indexOf(node[i].oid)>=0){
			ztree1.checkNode(node[i],true,true);
		}else{
			ztree1.checkNode(node[i],flase,false);
		}
	}
}

function saveIt(){
	var node = ztree1.getCheckedNodes(true);
	var ret = new Object();
	var forms = [];
	var fields = [];
	for(var i=0; i<node.length; i++){
		if(node[i].type == "form"){
			forms.push(node[i].oid);
		}
		if(node[i].type == "field"){
			fields.push(node[i].id);
		}
	}
	jq("#forms").val(forms.join(","));
	jq("#fields").val(fields.join(","));
	
	_form_win.window('close');
}

</script>