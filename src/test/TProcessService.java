import com.cloudoa.framework.flow.service.ProcessService;
import com.cloudoa.framework.orm.Page;
import com.cloudoa.framework.utils.SpringUtil;

public class TProcessService {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		 ProcessService ps = SpringUtil.getBean("processService");
		 Page page = new Page();
		// page = ps.findProcessInstances("1", page);
		 page = ps.findProcessInstances(page,"1","1");
		 
	}

}
