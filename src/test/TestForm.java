import java.util.List;

import com.cloudoa.framework.form.entity.Field;
import com.cloudoa.framework.form.entity.Form;
import com.cloudoa.framework.form.service.FormService;
import com.cloudoa.framework.utils.SpringUtil;


public class TestForm {

	public static void main(String[] args){
		new TestForm().testForm();
	}
	
	public void testForm(){
		FormService formService = SpringUtil.getBean("formService");
		Form form  = formService.get(1l, "1");
		System.out.println(form.getName());
		System.out.println(form.getFields());
	}
	
	
}
