<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>H+ 后台主题UI框架 - 主页</title>
    <link rel="shortcut icon" href="favicon.ico">
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet">
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
</head>
	<body>
		<form id="inputForm" action="${ctx }/security/authority/update" method="post">
			<input type="hidden" name="id" id="id" value="${id }"/>
		
		<table  class="table table-bordered" style="width: 90%;" align="center" >
		<caption style="text-align: center;"><h2>权限管理</h2></caption>
				<tr>
					<td style="text-align: right;">
						<span>权限名称：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<input type="text" class="form-control" id="name" name="name"
							value="${authority.name }" />
						</div>	
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<span>权限描述：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<textarea type="text" class="form-control" id="description" name="description"
							 >${authority.description }</textarea>
						</div>	
					</td>
				</tr>
			</table>
			<table align="center" border="0" cellpadding="0"
				cellspacing="0">
				<tr align="left">
					<td colspan="1">
						<input type="submit" class="btn btn-sm btn-primary" name="submit" value="提交">
						&nbsp;&nbsp;
						<input type="button" class="bun btn-sm btn-primary" name="reback" value="返回"
							onclick="history.back()">
					</td>
				</tr>
			</table>
			
			<table class="table table-bordered" style="width: 90%;" align="center">
				<thead>
				<tr>
					<th>
						<input type="checkbox" title="全选" id="selectAll">&nbsp;<a href="javascript:sort('name','asc')">资源名称</a>
					</th>
					<th>
						<a href="javascript:sort('source','asc')">资源</a>
					</th>
				</tr>
				</thead>
				<c:forEach items="${resources}" var="resource">
					<tr>
						<td>
							<input type="checkbox" name="orderIndexs" value="${resource.id}" ${resource.selected== 1 ? 'checked' : '' }>&nbsp;
							${resource.name}&nbsp;
						</td>
						<td>
							${resource.source}&nbsp;
						</td>
					</tr>
				</c:forEach>
			</table>
		</form>
	</body>
	
	<script type="text/javascript">
	$(function(){
		$("#selectAll").click(function(){
			var status = this.checked;
			if(status) {
				$("input[name='orderIndexs']").attr("checked",true);
			} else {
				$("input[name='orderIndexs']").attr("checked",false);
			}
		    
		});
	});
	</script>
</html>
