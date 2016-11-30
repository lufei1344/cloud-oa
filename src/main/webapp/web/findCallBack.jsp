<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <title>查询</title>

    <link rel="shortcut icon" href="favicon.ico"/>
    <link href="${ctx}/scripts/hplus/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${ctx}/scripts/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet"/>
    <link href="${ctx}/scripts/hplus/css/animate.min.css" rel="stylesheet"/>
    <link href="${ctx}/scripts/hplus/css/style.min.css" rel="stylesheet"/>
    
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/scripts/hplus/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${ctx}/web/showPage.js"></script>
    <script type="text/javascript">
        var pagedata;
        var params = new Object();
    	function getParams(){
    		var p = decodeURI(window.location.search.substring(1)).split("&");
        	for(var i = 0; i < p.length; i++){
        		var v = p[i].split("=");
        		if(v.length==2){
        			params[v[0]] = v[1];
        		}
        	}
    	}
    	getParams();
    	function jumpPage(i){
    		$("#pageNo").val(i);
    		var data =  $("#mainForm").serialize();
    		var url = "${ctx}/form/findCallBack";
    		$.post(url,data,function(redata){
    			if(redata.status){
    				var page = redata.obj.page;
    				pagedata = page;
    				queryParams(redata.obj.keys);
    				dataPage(page,redata.obj.keys);
    				showPage("page",page);
    			}else{
    				alert(redata.msg);
    			}
    		});
    		
    	}
    	function queryParams(keys){
    		var query = "<td>";
    		for(var i=0; i<keys.length; i++){
    			query += keys[i].show+":<input class='form-control' name='col_"+keys[i].kkey+"'/>"
    		}
    		query += "<button type='button'  class='btn btn-sm btn-primary' onclick='jumpPage(1)'> 搜索</button></td>";
    		$("#query").html(query);
    	}
    	function dataPage(page,keys){
    		 var $table = $("#page");
    		 var title = "<tr>";
   		     var content = "";
   		     for(var i=0; i<keys.length; i++){
   		    	 title +="<th>"+keys[i].show+"</th>";
   		     }
   		  	 title +="<th>操作</th></tr>";
   		     for(var i=0; i<page.result.length; i++){
   		    	content += "<tr>";
   		    	for(var n=0; n<keys.length; n++){
   		    		content +="<td>"+page.result[i][keys[n].columnkey]+"</td>";
   		    	}
   		    	content +="<td><a href='javascript:void(0)' onclick='getValue("+i+")'>选择</a></td>";
   		    	content += "</tr>";
   		    }
   		  $table.find("thead").html(title);
   		    $table.find("tbody").html(content);
    	}
    	function getValue(index){
    		var o = pagedata.result[index];
    		for(key in o){
    			var k = key.substring(0,key.indexOf("#")).toUpperCase();
    			o[k] = o[key];
    		}
    		window.returnValue = o;
    		window.close();
    	}
    	$(function(){
    		jumpPage(1);
    	});
    	
    	
    </script>
</head>

	<body>
	<form id="mainForm" action="${ctx}/form/findCallBack" method="get" class="form-inline">
		<input type="hidden" name="lookup" value="${lookup}" />
		<input type="hidden" name="pageNo" id="pageNo" value="${page.pageNo}"/>
		<input type="hidden" name="orderBy" id="orderBy" value="${page.orderBy}"/>
		<input type="hidden" name="order" id="order" value="${page.order}"/>
		<input type="hidden" name="sql" id="sql" value="SELECT CODE AS 'code#值',NAME AS 'NAME#名称' FROM conf_dictitem WHERE dictionary=4"/>
		<div class="ibox-content">
		 <div class="table-responsive">
		 <table class="table table-striped table-hover table-bordered" id="query">
		 </table>
		 <hr/>
          <table class="table table-striped table-hover table-bordered" id="page">
			<thead>
			<tr>
						
			</tr>
			</thead>
			<tbody>
			</tbody>
			<tfoot></tfoot>
		</table>
		</div>
		</div>
	</form>
	</body>
</html>


