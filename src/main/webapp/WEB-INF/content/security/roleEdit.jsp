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
    <script>
		function openOrg() {
			var index = parent.layer.open({
				  type: 2,
			      title: '部门选择',
			      area: ['6500px', '400px'],
			      content: '${ctx}/security/org?lookup=1'
				});
			parent.digCallBack = function(obj){
				document.getElementById("parentOrgId").value=obj.id;
				document.getElementById("parentOrgName").value=obj.name;
				parent.layer.close(index);	
			};
		}
		
	</script>
</head>

	<body>
		<form id="inputForm" action="${ctx }/security/role/update" method="post">
			<input type="hidden" name="id" id="id" value="${id }"/>
		
		<table class="table table-bordered" style="width: 90%;" align="center" >
		<caption style="text-align: center;"><h2>角色管理</h2></caption>
				<tr>
					<td style="text-align: right;">
						<span>角色名称：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<input type="text" class="form-control" id="name" name="name"
							value="${role.name }" />
						</div>	
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<span>角色描述：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<textarea  class="form-control" id="description" name="description">${role.description }</textarea>
						</div>	
					</td>
				</tr>
			</table>
			<table align="center" border="0" cellpadding="0"
				cellspacing="0">
				<tr align="left">
					<td colspan="1">
						<input type="submit" class="btn btn-sm btn-primary"  name="submit" value="提交">
						&nbsp;&nbsp;
						<input type="button" class="btn btn-sm btn-primary"  name="reback" value="返回"
							onclick="history.back()">
					</td>
				</tr>
			</table>
			
			<table class="table table-bordered" style="width: 90%;" align="center" >
				<tr>
					<td align=center width=70% class="td_list_1" nowrap>
						<input type="checkbox" title="全选" id="selectAll"><a href="javascript:sort('name','asc')">&nbsp;权限名称</a>
					</td>
				</tr>
				<c:forEach items="${authorities}" var="authority">
					<tr>
						<td class="td_list_2" align=left nowrap>
							<input type="checkbox" name="orderIndexs" value="${authority.id}" ${authority.selected== 1 ? 'checked' : '' }>
							&nbsp;${authority.name}(${authority.description})&nbsp;
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
