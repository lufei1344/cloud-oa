function showPage(id,page,keys){
    var $table = $("#"+id);
    var footer = "<table class='table' border='0' cellpadding='0' cellspacing='0'><tr><td><div align='left'>总共<font color='red'>"+page.totalCount+"</font>条记录&nbsp; 共<font color='red'>"+page.totalPages+"</font>页&nbsp; 当前所在第<font color='red'>"+page.pageNo+"</font>页</div>";
	
    var prePage = 0, nextPage = 0, pageNo = 1, totalPage = 1;
    pageNo = page.pageNo;
	totalPage = page.totalPages;
	prePage = pageNo - 1;
	nextPage = pageNo + 1;
	prePage = prePage <= 0 ? 1 : prePage;
	nextPage = nextPage >= totalPage ? totalPage : nextPage;
	var pagecontent = "<td><div class='btn-group'><a class='btn btn-white' href='javascript:jumpPage(1)' style='TEXT-DECORATION: none'>首页</a>&nbsp;&nbsp;"+
					"<a class='btn btn-white' href='javascript:jumpPage("+prePage+")' style='TEXT-DECORATION: none'><i class='fa fa-chevron-left'></i></a>&nbsp;&nbsp;"	;
	var pbegin = (pageNo - 2)<=0 ? 1 : (pageNo - 2);
	var pend = totalPage;
	pend = pend>(pbegin+5)?(pbegin+4):pend;
	for(var i=pbegin; i<=pend; i++){
		if(i == pageNo){
			pagecontent += "<a class='btn btn-white active' >"+i+"</a>";				
		}else{
			pagecontent += "<a class='btn btn-white' href='javascript:jumpPage("+i+")' >"+i+"</a>";
		}
	}
	pagecontent += "<a class='btn btn-white' href='javascript:jumpPage("+nextPage+")' style='TEXT-DECORATION: none'><i class='fa fa-chevron-right'></i></a>&nbsp;&nbsp;";
	pagecontent += "<a class='btn btn-white' href='javascript:jumpPage("+totalPage+")' style='TEXT-DECORATION: none'>末页</a></td></tr></table>";
	$table.after(footer+pagecontent);
}

