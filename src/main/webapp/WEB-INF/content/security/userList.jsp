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
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/plugins/layer/layer.min.js"></script>
    <script type="text/javascript">
    	function jumpPage(i){
    		$("#pageNo").val(i);
    		$("#mainForm")[0].submit();
    	}
    </script>
</head>

	<body>
	<form id="mainForm" action="${ctx}/security/user" method="get">
	<input type="hidden" name="pageNo" id="pageNo" value="${page.pageNo}"/>
		<input type="hidden" name="orderBy" id="orderBy" value="${page.orderBy}"/>
		<input type="hidden" name="order" id="order" value="${page.order}"/>
    	<div class="ibox-content">
            <div class="row">
                <div class="col-sm-6">
                    <div class="input-group">
                        <input type="text" placeholder="请输入关键词" name="filter_LIKES_username" value="${param.filter_LIKES_username}" class="input-sm form-control"> 
                        <span class="input-group-btn">
                            <button type="button" class="btn btn-sm btn-primary" onclick="jumpPage(1)"> 搜索</button> 
                        </span>
                    </div>
                    
                </div>
                <shiro:hasPermission name="USEREDIT">
					<div class="col-sm-6">	
					  <div class="input-group">
                        <span class="input-group-btn">
                            <a  href="${ctx}/security/user/create" class="btn btn-sm btn-primary">新增</a> 
                        </span>
                        </div>	
                    </div>    
				</shiro:hasPermission>
            </div>
            <hr/>
            <div class="table-responsive">
                <table class="table table-striped table-hover table-bordered">
                    <thead>
                        <tr>

                            <th>账号</th>
                            <th>姓名</th>
                            <th>是否可用</th>
                            <th>部门</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${page.result}" var="user">
							<tr>
								<td align=left nowrap>
									${user.username}&nbsp;
								</td>
								<td align=left nowrap>
									${user.fullname}&nbsp;
								</td>
								<td align=left nowrap>
									<frame:select name="enabled" type="select" configName="yesNo" value="${user.enabled}" displayType="1"/>
									&nbsp;
								</td>
								<td align=left nowrap>
									${user.org.name}&nbsp;
								</td>
								<td align=left nowrap>
								<shiro:hasPermission name="USERDELETE">
									<a href="${ctx}/security/user/delete/${user.id }" class="glyphicon glyphicon-trash" title="删除" onclick="return confirmDel();">删除</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="USEREDIT">
									<a href="${ctx}/security/user/update/${user.id }" class="glyphicon glyphicon-pencil" title="编辑">编辑</a>
								</shiro:hasPermission>
									<a href="${ctx}/security/user/view/${user.id }" class="glyphicon glyphicon-search" title="查看">查看</a>
								</td>
							</tr>
						</c:forEach>
                        
                    </tbody>
                    <tfoot>
                    	<frame:page curPage="${page.pageNo}" totalPages="${page.totalPages }" totalRecords="${page.totalCount }" lookup="${lookup }"/>
                    </tfoot>
                </table>
            </div>

        </div>
	</form>
