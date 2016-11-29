<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>上传文件</title>
    <link rel="shortcut icon" href="favicon.ico">
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet">
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
    <script>
		function load() {
			var win = document.getElementById("formsubmit").contentWindow;
		    var redata;
		    if(win.document.body.innerText == ""){
		    	return;
		    }
		    eval("redata = "+win.document.body.innerText);
		    if(redata.status){
		    	alert("成功");
		    }else{
		    	alert("失败");
		    }
		}
		
	</script>
</head>
	<body>
		<iframe name="formsubmit" id="formsubmit" onload="load()" style="display:none;"></iframe>
		<form id="inputForm" action="${ctx }/flow/process/saveUpload" method="post" target="formsubmit" enctype="multipart/form-data">
			<input type="hidden" name="id" id="id" value="${id }"/>
		
		<table  class="table table-bordered" style="width: 90%;" align="center" >
		<caption style="text-align: center;"><h2>流程文件上传</h2></caption>
				<tr>
					<td style="text-align: right;">
						<span>名称：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<input type="text" class="form-control" id="processName" name="processName"
							value="" />
						</div>	
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<span>类别：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<frame:select name="category" cssClass="form-control" type="select" configName="formType" displayType="0" value="" />
						</div>
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						<span>文件：</span>
					</td>
					<td>
						<div class="col-sm-6">
						<input type="file" class="form-control"  name="xml"
							value="" />
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
