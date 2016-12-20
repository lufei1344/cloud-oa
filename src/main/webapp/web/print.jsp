<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>任务处理</title>
    <link rel="shortcut icon" href="favicon.ico"> 
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet">
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet">
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
    <script type="text/javascript">
    	var win = window.opener;
    	var doc = window.opener.document;
    	
    	//初始化加载
    	function initLoad(){
    		var cid = $("#title li[class='active']",doc).find("a").attr("href");
    		$("#content").html($(cid,doc).html());
    		$("input[type='input']").each(function(){
    			$(this).replaceWith($("#"+this.id,doc).val());
    		});
    		$("textarea").each(function(){
    			$(this).replaceWith($("#"+this.id,doc).val());
    		});
    		
    	}
    	
    	$(function(){
    		initLoad();
    	});
    	
    </script>

</head>

<body class="white-bg">
    <div class="wrapper wrapper-content p-xl" id="content">
    </div>
</body>
</html>

