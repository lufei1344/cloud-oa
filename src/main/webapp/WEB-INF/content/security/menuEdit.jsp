<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>菜单管理</title>
    <link rel="shortcut icon" href="favicon.ico">
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet">
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
    <script>
		function openDialog() {
			var index = parent.layer.open({
				  type: 2,
			      title: '菜单选择',
			      area: ['750px', '400px'],
			      content: '${ctx}/security/menu?lookup=1'
				});
			parent.digCallBack = function(obj){
				parent.layer.close(index);	
				document.getElementById("parentMenuId").value=obj.id;
				document.getElementById("parentMenuName").value=obj.name;
			};
		}
		
	</script>
</head>

	<body>
		<form id="inputForm" action="${ctx }/security/menu/update" method="post">
			<input type="hidden" name="id" id="id" value="${id }"/>
		<table  class="table table-bordered" style="width: 90%;" align="center" >
		<caption style="text-align: center;"><h2>菜单管理</h2></caption>
				<tr>
					<td style="text-align: right;">
						<span>菜单名称：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<input type="text" class="form-control" id="name" name="name"
							value="${menu.name }" />
						</div>	
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<span>上级菜单：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<input type="hidden" id="parentMenuId" name="parentMenuId" value="${menu.parentMenu.id }">
						<input type="text" id="parentMenuName" readonly="readonly" name="parentMenuName" class="form-control" value="${menu.parentMenu.name }">
						<input type='button' class='btn btn-sm btn-primary' value='上级菜单' id="selectMenu" onclick="openDialog()"/>
						</div>
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<span>排序值：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<input type="text" class="form-control" id="orderby" name="orderby"
							value="${menu.orderby }" />
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
						<input type="button" class="btn btn-sm btn-primary" name="reback" value="返回"
							onclick="history.back()">
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
