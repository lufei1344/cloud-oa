//UEditor控件扩展的属性

/**
 * 
 * @param type
 * @param name
 * @returns
 */
function createElement(type, name){     
    var element = null;     
    try {        
        element = document.createElement('<'+type+' name="'+name+'">');     
    } catch (e) {}   
    if(element==null) {     
        element = document.createElement(type);     
        element.name = name;     
    } 
    return element;     
}


function fieldChange(){
	var field=mini.getbyName('name');

	if(field){
		var node= field.getSelectedNode();

		var label=mini.getbyName('label');
		if(node && label && label.getValue()==''){
			label.setValue(node.title);
		}
		
		if(node && node.dataType=='String'){
			var maxlen =mini.getbyName('maxlen');
			if(maxlen){
				maxlen.setValue(node.len);
			}
		}
		
	}
}

function changeMinMaxWidth(){
	var mwidth=mini.get('mwidth');
	var wunit=mini.get('wunit');
	if(wunit.getValue()=='%'){
		mwidth.setMinValue(0);
		mwidth.setMaxValue(100);
	}else{
		mwidth.setMinValue(0);
		mwidth.setMaxValue(1200);
	}
}

function changeMinMaxHeight(){
	var mheight=mini.get('mheight');
	var hunit=mini.get('hunit');
	if(hunit.getValue()=='%'){
		mheight.setMinValue(0);
		mheight.setMaxValue(100);
	}else{
		mheight.setMinValue(0);
		mheight.setMaxValue(1200);
	}
}