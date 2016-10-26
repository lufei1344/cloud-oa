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
		<form id="inputForm" action="${ctx }/security/user/update" method="post">
			<input type="hidden" name="id" id="id" value="${id }"/>
		<table class="table table-bordered" style="width: 90%;" align="center" >
		<caption style="text-align: center;"><h2>用户管理</h2></caption>
				<tr>
					<td style="text-align: right;">
						账号：
					</td>
					<td>
						<div class="col-sm-6">
                            <input id="username" name="username" value="${user.username }" minlength="2" type="text" class="form-control" required="" aria-required="true">
                        </div>	
					</td>
					<td style="text-align: right;">
						姓名：
					</td>
					<td>
						<div class="col-sm-6">
						<input type="text" class="form-control" id="fullname" name="fullname"
							value="${user.fullname }" />
						</div>	
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						密码：
					</td>
					<td>
						<div class="col-sm-6">
						<input type="password" class="form-control" id="plainPassword" name="plainPassword"
							value="${user.plainPassword }" />
						</div>	
					</td>
					<td style="text-align: right;">
						确认密码：
					</td>
					<td>
						<div class="col-sm-6">
						<input type="password" class="form-control" id="passwordConfirm"
							name="passwordConfirm" value="${user.plainPassword }" />
						</div>	
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						邮箱：
					</td>
					<td>
						<div class="col-sm-6">
						<input type="text" class="form-control" id="email" name="email"
							value="${user.email }" />
						</div>	
					</td>
					<td style="text-align: right;">
						性别：
					</td>
					<td>
						<div class="col-sm-6">
						<frame:select name="sex" type="radio" configName="sex" value="${user.sex == null ? '1' : user.sex }" cssClass="input_radio"/>
						</div>
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						是否可用：
					</td>
					<td colspan="3">
						<div class="col-sm-6">
						<frame:select name="enabled" type="radio" configName="yesNo" value="${user.enabled == null ? '1' : user.enabled }" cssClass="input_radio"/>
						</div>
					</td>
				</tr>
 				<tr>
					<td style="text-align: right;">
						部门：
					</td>
					<td colspan="3">
					<div class="col-sm-6">
						<input type="hidden" id="parentOrgId" name="parentOrgId" value="${user.org.id }">
						<input type="text" id="parentOrgName" readonly="readonly" name="parentOrgName" class="form-control" value="${user.org.name }">
						<input type='button' class="btn btn-sm btn-primary" value='选择部门' id="selectOrgBtn" onclick="openOrg()"/>
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
			
			<table class="table table-bordered" style="width: 90%;" align="center">
				<tr>
					<td width=45%  nowrap>
						<input type="checkbox" title="全选" id="selectAll"><a href="javascript:sort('name','asc')">角色名称</a>
					</td>
				</tr>

				<c:forEach items="${roles}" var="role">
					<tr>
						<td  align=left nowrap>
							<input type="checkbox" name="orderIndexs" value="${role.id}" ${role.selected== 1 ? 'checked=true' : '' }>${role.name}&nbsp;
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
