<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>字典管理</title>
    <link rel="shortcut icon" href="favicon.ico">
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet">
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
</head>
	<body>
		<form id="inputForm" action="${ctx }/config/dictionary/update" method="post">
			<input type="hidden" name="id" id="id" value="${id }"/>
			<table  class="table table-bordered" style="width: 90%;" align="center" >
		     <caption style="text-align: center;"><h2>字典管理</h2></caption>
				<tr>
					<td style="text-align: right;">
						<span>配置名称：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<input type="text" class="form-control" id="name" name="name"
							value="${dictionary.name }" />
						</div>	
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<span>显示名称：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<input type="text" class="form-control" id="cnName" name="cnName"
							value="${dictionary.cnName }" />
						</div>	
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<span>配置描述：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<textarea type="text" class="form-control" id="description" name="description"
							>${dictionary.description }</textarea>
						</div>	
					</td>
				</tr>
			</table>
			
			<table class="table table-bordered" align="center">
				<tr>
					<td style="text-align: right;">
						<span>添加选项：</span>
					</td>
					<td>
						<input type="button" class="btn btn-sm btn-primary" value="添加选项" onclick="addItem()">
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<span>选项列表：</span>
					</td>
					<td>
						<table class="table table-bordered" align="center" id="itemTable">
							<thead>
							<tr>
								<th align=center width=15% >
									序号
								</th>
								<th align=center width=25% >
									编号
								</th>
								<th align=center width=50% >
									名称
								</th>
								<th align=center width=20% >
									操作
								</th>
							</tr>
							</thead>
							<c:forEach var="item" items="${dictionary.dictionaryItems}" varStatus="s">
								<tr>
									<td>
										<input type="text" value="${item.orderby }" name='orderbys' class='form-control' size="2">
									</td>
									<td>
										<input type="text" value='${item.code }' name='codes' class='form-control' >
									</td>
									<td>
										<input type="text" value='${item.name }' name='itemNames' class='form-control' >
									</td>
									<td>
										<a href='javascript:void(0)' onclick='delRow(${item.orderby})' class='btn btn-sm btn-primary' title='删除'>删除</a>
									</td>
								</tr>
								<c:set var="index" value="${item.orderby }"/>
							</c:forEach>
						</table>
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
			
			<script type="text/javascript">
			var order = ${index + 1};
			function addItem() {
				var table = document.getElementById("itemTable");
				var row = table.insertRow(table.rows.length);
				var cell = row.insertCell(0);
				if(order) {
					cell.innerHTML = "<input type='text' value='" + order + "' class='form-control' name='orderbys' size='2'>";
				} else {
					cell.innerHTML = "<input type='text' value='" + 1 + "' class='form-control' name='orderbys' size='2'>";
				}
				
				
				cell = row.insertCell(1);
				cell.innerHTML = "<input type='text' value='' class='form-control' name='codes' >";
				
				cell = row.insertCell(2);
				cell.innerHTML = "<input type='text' value='' class='form-control' name='itemNames' >";
				
				cell = row.insertCell(3);
				cell.innerHTML = "<a href='javascript:void(0)' onclick='delRow(" + order + ")' class='btn btn-sm btn-primary' title='删除'>删除</a>";
				order = order + 1;
			}
			
			function delRow(rowId) {
				var table = document.getElementById("itemTable");
				table.deleteRow(rowId);
				order = order - 1;
				var rns = table.rows.length;
				if(rns >= 2) {
					var cns = table.rows[0].cells.length;
					var idx;
					for(idx = 1; idx < rns; idx++) {
						table.rows[idx].cells[0].innerHTML="<input type='text' value='" + idx + "' name='orderbys' size='2'>";
						table.rows[idx].cells[cns - 1].innerHTML="<a href='javascript:void(0)' onclick='delRow(" + idx + ")' class='btnDel' title='删除'>删除</a>";
					}
				}
			}
			
			function validateInput(){
					var table = document.getElementById("itemTable");
					var rowLen = table.rows.length;
					if(rowLen == 0) {
						alert("请添加选项");
						return false;
					}
					var warning = "";
					$("input[name='itemNames']").each(function(){
						var item = $(this).val();
						if(item == '') {
							warning = "选项列表 不能为空";
						}
					});
					if(warning != '') {
						alert(warning);
						return false;
					}
			}
			</script>
		</form>
	</body>
</html>
