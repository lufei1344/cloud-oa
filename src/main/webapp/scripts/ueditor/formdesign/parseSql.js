function getSqlColumns(sql){
		 var k = sql.toUpperCase().indexOf(" FROM ");
         if(k <= 0){
             return;
         }
         var Fields = sql.substring(7, k).split(",");
         var outFields = new Array();
         var blackStack = 0;
         var t = 0;
         for(var i = 0; i < Fields.length; i++){
             var x = Fields[i].indexOf("(");
             if(x>=0){
                 while(x>=0){
                     blackStack++;
                     Fields[i] = Fields[i].substring(x+1);
                     t = Fields[i].indexOf(")");
                     x = Fields[i].indexOf("(");
             		if(t<x){
             			blackStack--;
                         Fields[i] = Fields[i].substring(t+1);
             		}
                     x = Fields[i].indexOf("(");
                 }
             }
             x = Fields[i].indexOf(")");
             if(x>=0){
                 while(x>=0){
                     blackStack--;
                     Fields[i] = Fields[i].substring(x+1);
                     x = Fields[i].indexOf(")");
                  }
             }
             if(blackStack==0){
                 var units = Fields[i].split(" ");
                 units = units[units.length - 1].split(".");
                 outFields[outFields.length] = units[units.length - 1];
             }
         }
		return outFields;
	 }