<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>查询</title>

    <link rel="shortcut icon" href="favicon.ico"/>
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet"/>
    <script type="text/javascript" src="${ctx}/scripts/zTreeStyle/jquery-1.4.4.min.js"></script>
    <!-- ztree -->
    <link href="${pageContext.request.contextPath}/scripts/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css" />
	<script src="${pageContext.request.contextPath}/scripts/zTreeStyle/jquery.ztree.all-3.1.min.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/web/dialog/search.js" type="text/javascript"></script>
<script type="text/javascript">
var ztree1;
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
function del(obj){
	$(obj).remove();
}
var ww = window.dialogArguments;	
var scArr;
//加载树
function refreshTree() {
	$.getJSON("${pageContext.request.contextPath}/form/findSelDept?s="+Math.random(),function(data){
		for(var i=0; i<data.obj.length; i++){
			if(ww.ids.indexOf(data.obj[i].id)>=0){
				data.obj[i].checked = true;
			}
		}
		data.obj[0].open = true;
		ztree1 = $.fn.zTree.init($("#treediv1"), setting, data.obj);
	});
	
}


$(function(){
	refreshTree();
});	

function saveIt(){
	var node = ztree1.getCheckedNodes(true);
	var ret = new Object();
	var userids = [];
	var names = [];
	for(var i=0; i<node.length; i++){
		if(node[i].type == "d"){
			userids.push(node[i].id);
			names.push(node[i].name);
		}
	}
	ret.ids = userids.join(",");
	ret.names = names.join(",");
	window.returnValue = ret;
	window.close();
}

</script>
</head>

<body>
<div class="panel panel-info">
    <div class="panel-heading">
        	名称：<input  id="name"  style="width:50%;" onkeypress="if(event.keyCode==13){search_ztree('treediv1', 'name');};"/>
        	<input type="button" class="btn btn-sm btn-primary" onclick="search_ztree('treediv1', 'name')" value="搜索"/>
    </div>
    <div class="panel-body">
        <ul id="treediv1" class="ztree"></ul>
        <div class="row" style="text-align: center;">
        	<input type="button" class="btn btn-sm btn-primary" value="确定" onclick="saveIt()"/>
        	<input type="button" class="btn btn-sm btn-primary" value="取消" onclick="window.close()"/>
        </div>
    </div>
</div>
</body>
</html>
