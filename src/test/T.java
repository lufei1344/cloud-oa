import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.task.Task;

import com.cloudoa.framework.flow.service.ProcessService;
import com.cloudoa.framework.utils.SpringUtil;

public class T {

	public static void main(String[] args) {
		//PropertyFilter f = new PropertyFilter("LIKES_name","1");
		//ProcessService ps = SpringUtil.getBean("processService");
		//process1479698618758:1:2504&activityId=task1479698622742
		//List<Map<String,Object>> nodes = ps.findProcessInstanceNextNode("process1479698618758:1:2504", "task1479698622742");
		//System.out.println(nodes);
		//testFlow1();
		//testFlow2();
	}
	
	public static void testFlow1(){
		Map<String, Object> variables = new HashMap<String, Object>(); 
    	variables.put("users", "1,2,3");//会签不起作用  
		 ProcessEngine processEngine = SpringUtil.getBean("processEngine");
		 List<Task> tasks = processEngine.getTaskService().createTaskQuery()  
        .processDefinitionId("process1479698618758:1:2504").list();
		 for(Task task: tasks){
			 System.out.println("任务ID：" + task.getId());  
             System.out.println("任务的办理人：" + task.getAssignee());  
             System.out.println("任务名称：" + task.getName());  
             System.out.println("任务的创建时间：" + task.getCreateTime());  
             System.out.println("流程实例ID：" + task.getProcessInstanceId());  
             System.out.println("#######################################");  
            // processEngine.getTaskService().complete(task.getId(), variables);
             
		 }
	}
	/*public static void testFlow2(){
		Map<String, Object> variables = new HashMap<String, Object>(); 
    	variables.put("users", "1,2,3");//会签不起作用  
		ProcessEngine processEngine = SpringUtil.getBean("processEngine");
		List<Task> tasks = processEngine.getTaskService().createTaskQuery()  
				.processDefinitionId("process1479698618758:2:12504").("1").list();
		for(Task task: tasks){
			System.out.println("任务ID：" + task.getId());  
			System.out.println("任务的办理人：" + task.getAssignee());  
			System.out.println("任务名称：" + task.getName());  
			System.out.println("任务的创建时间：" + task.getCreateTime());  
			System.out.println("流程实例ID：" + task.getProcessInstanceId());  
			System.out.println("#######################################");  
			//processEngine.getTaskService().complete(task.getId(), variables);
		}
	}
*/
}
