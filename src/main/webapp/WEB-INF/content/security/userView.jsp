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
			<table class="table table-bordered" style="width: 60%;" align=center >
			<caption style="text-align: center;"><h2>账号信息查看</h2></caption>
				<tr>
					<td>
						<span>账号：</span>
					</td>
					<td>
						${user.username }&nbsp;
					</td>
				</tr>
				<tr>
					<td>
						<span>姓名：</span>
					</td>
					<td>
						${user.fullname }&nbsp;
					</td>
				</tr>
				<tr>
					<td>
						<span>邮箱：</span>
					</td>
					<td>
						${user.email }&nbsp;
					</td>
				</tr>
				<tr>
					<td>
						<span>部门：</span>
					</td>
					<td>
						${user.org.name }&nbsp;
					</td>
				</tr>
				<tr>
					<td align=center width=45% class="td_list_1" nowrap colspan="2">
						<a href="javascript:sort('name','asc')">角色名称</a>
					</td>
				</tr>

				<c:forEach items="${user.roles}" var="role">
					<tr>
						<td colspan="2" align=left nowrap>
							${role.name}&nbsp;
						</td>
					</tr>
				</c:forEach>
			</table>
			<table align="center" border="0" cellpadding="0"
				cellspacing="0">
				<tr align="left">
					<td colspan="1">
						<input type="button" class="btn btn-sm btn-primary"  name="reback" value="返回"
							onclick="history.back()">
					</td>
				</tr>
			</table>
	</body>
</html>
