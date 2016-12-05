<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>

<div class="panel panel-info">
	<table>
	<tr>
		<td>
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
		</td>
		<td>
			<table>
				<tr>
					<a href="javascript:void(0)" onclick="setFh(this)">></a>&nbsp;&nbsp;
					<a href="javascript:void(0)" onclick="setFh(this)">=</a>&nbsp;&nbsp;
					<a href="javascript:void(0)" onclick="setFh(this)"><</a>&nbsp;&nbsp;
					<a href="javascript:void(0)" onclick="setFh(this)">!</a>&nbsp;&nbsp;
					<a href="javascript:void(0)" onclick="setFh(this)">+</a>&nbsp;&nbsp;
					<a href="javascript:void(0)" onclick="setFh(this)">-</a>&nbsp;&nbsp;
					<a href="javascript:void(0)" onclick="setFh(this)">*</a>&nbsp;&nbsp;
					<a href="javascript:void(0)" onclick="setFh(this)">/</a>&nbsp;&nbsp;
				</tr>
				<tr>
					<td>
						<textarea id="exp">
						</textarea>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</table>
    
</div>
<script type="text/javascript">
var ztree2 = null;
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
		view :{  
            fontCss: setFontCss_ztree  
        },
        callback:{
        	onDblClick: zTreeOnClick
        }
	};
	
function zTreeOnClick(event, treeId, treeNode) {
	if(treeNode.type == "field"){
		jq("#exp").val(jq("#exp").val()+treeNode.enname+".value");
	}
};	

var ids = "";
//加载树
function refreshTree() {
		jq.getJSON("${pageContext.request.contextPath}/flow/process/forms?s="+Math.random(),function(data){
			ztree2 = jq.fn.zTree.init(jq("#treediv2"), setting, data.obj);
		});
	
	
	
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
	
	var node = ztree2.getNodes();
	for(var i=0; i<node.length; i++){
		if(ids.indexOf(node[i].oid)>=0){
			ztree2.checkNode(node[i],true,true);
		}else{
			ztree2.checkNode(node[i],flase,false);
		}
	}
}

function saveIt(){
	var node = ztree2.getCheckedNodes(true);
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
	
	_rule_win.window('close');
}

</script>