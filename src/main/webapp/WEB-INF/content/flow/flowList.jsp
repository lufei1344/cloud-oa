<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>流程管理</title>

    <link rel="shortcut icon" href="favicon.ico"/>
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet"/>
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet"/>
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet"/>
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
    <script type="text/javascript">
    	function jumpPage(i){
    		$("#pageNo").val(i);
    		$("#mainForm")[0].submit();
    	}
    	function editDialog(url){
    		var index = parent.layer.open({
    		      type: 2,
    		      title: '编辑',
    		      shadeClose: true,
    		      shade: false,
    		      maxmin: true, //开启最大化最小化按钮
    		      area: ['893px', '600px'],
    		      content: url
    		    });
    		parent.layer.full(index);
    	}
    </script>
</head>

	<body>
	<form id="mainForm" action="${ctx}/flow/process" method="get">
		<input type="hidden" name="lookup" value="${lookup}" />
		<input type="hidden" name="pageNo" id="pageNo" value="${page.pageNo}"/>
		<input type="hidden" name="orderBy" id="orderBy" value="${page.orderBy}"/>
		<input type="hidden" name="order" id="order" value="${page.order}"/>
		<div class="ibox-content">
		<div class="row">
                <div class="col-sm-6">
                    <div class="input-group">
                        <input placeholder="字典名称" type="text" class="input-sm form-control" name="filter_LIKES_name" value="${param['filter_LIKES_name']}"/> 
                        <span class="input-group-btn">
                            <button type="button" class="btn btn-sm btn-primary" onclick="jumpPage(1)"> 搜索</button> 
                        </span>
                    </div>
                    
                </div>
				<div class="col-sm-6">	
                       <span class="input-group-btn">
						<shiro:hasPermission name="MENUEDIT">
						<input type='button'  onclick="editDialog('${ctx}/flow/process/create')" class="btn btn-sm btn-primary" value="新建" />
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type='button' onclick="editDialog('${ctx}/flow/process/upload')" class="btn btn-sm btn-primary" value="上传" />
						</shiro:hasPermission>
                       </span>
                   </div>    
            </div>
            <hr/>
		
		 <div class="table-responsive">
          <table class="table table-striped table-hover table-bordered">
			<thead>
			<tr>
				<th name="id">编号</th>
		        <th  name="name">名称</th>
		        <th  name="createTime">Key</th>
		        <th  name="assignee">分类</th>
				<th>
					操作
				</th>				
			</tr>
			</thead>
			<c:forEach items="${page.result}" var="item">
		      <tr>
			    <td>${item.id}</td>
			    <td>${item.resourceName}</td>
			    <td>${item.key }</td>
			    <td><frame:select name="type" type="select" configName="formType" displayType="1" value="${item.category}" />&nbsp;</td>
		        <td>
		          <a href="javascript:void(0)" class="glyphicon glyphicon-trash" title="删除" onclick="confirmDel(this,'${item.deploymentId}')">删除</a>
				  <a href="javascript:void(0)" onclick="editDialog('${ctx}/flow/process/update/${item.id }')" class="glyphicon glyphicon-pencil" title="编辑">编辑</a>
				  <a href="${ctx}/flow/process/view/${item.id }" class="glyphicon glyphicon-search" title="查看">查看</a>
				  <a href="javascript:void(0)" onclick="startInstance('${item.id}')" class="glyphicon glyphicon-search" title="查看">开启流程</a>
		        </td>
		      </tr>
		      </c:forEach>
			<frame:page curPage="${page.pageNo}" totalPages="${page.totalPages }" totalRecords="${page.totalCount }" lookup="${lookup }"/>
		</table>
		</div>
		</div>
	</form>
    <script>
        function confirmDel(obj,id) {
        	var index = parent.layer.confirm('确定要删除吗？', {
		        		  btn: ['确定','取消'] //按钮
		        		}, function(){
		        		    var url = "${ctx}/flow/process/delete/"+id;
		        		    $.getJSON(url,function(redata){
		        		    	if(redata.status){
		        		    		$(obj).parent().parent().remove();
		        		    	}else{
		        		    		param.layer.msg(redata.msg);
		        		    	}
		        		    	parent.layer.close(index);
		        		    });
		        		}, function(){
		        			parent.layer.close(index);
		        		});
        }
        function startInstance(id){
        	var url = "${ctx}/flow/task/start";
        	var data = {id:id};
        	$.getJSON(url,data,function(redata){
        		if(redata.status){
        			//var url = "${ctx}/web/views.jsp?taskId="+redata.obj.taskId+"&executionId="+redata.obj.executionId+"&forms=&fields=&processInstanceId="+redata.obj.processInstanceId+"&processDefinitionId="+redata.obj.processDefinitionId+"&activityId="+redata.obj.activityId;
        			//window.open(url);
        			var data = {processDefinitionId:redata.obj.processDefinitionId,activityId:redata.obj.activityId};
            		$.getJSON("${ctx}/flow/task/openViews",data,function(rdata){
            			if(rdata.status){
            				var url = "${ctx}/web/views.jsp?taskId="+redata.obj.taskId+"&executionId="+redata.obj.executionId+"&forms="+rdata.obj.forms+"&fields="+rdata.obj.fields+"&processInstanceId="+redata.obj.processInstanceId+"&processDefinitionId="+redata.obj.processDefinitionId+"&activityId="+redata.obj.activityId;
                			window.open(url);
            			}else{
            				alert("服务器错误");
            			}
            			
            		});
        		}else{
        			alert(redata.msg);
        		}
        	});
        }
    </script>
	</body>
</html>


