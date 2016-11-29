package join;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.IdentityLink;
import org.activiti.engine.task.Task;
import org.junit.Test;

import com.cloudoa.framework.utils.SpringUtil;

public class Task111 {  
  
    // 流程引擎对象  
    ProcessEngine processEngine = SpringUtil.getBean("processEngine");
  
    public static void main(String[] args){
    	//会签测试，正确流程
    	Task111 t = new Task111();
    	//t.deployementAndStartProcess();
    	t.completeTask();
    }
    
  
    /**部署流程定义+启动流程实例：3905*/  
    @Test  
    public void deployementAndStartProcess() {  
    	//1.发布流程  
    	InputStream inputStreamBpmn = this.getClass().getResourceAsStream(  
    			"111.bpmn");  
    	processEngine.getRepositoryService()//  
    	.createDeployment().category("2")//  
    	.addInputStream("111.bpmn", inputStreamBpmn).category("2")////  
    	.deploy();  
    	//2.启动流程  
    	Map<String, Object> variables = new HashMap<String, Object>(); 
    	
    	variables.put("users", "101,102");//会签不起作用  
    	List<String> list = new ArrayList<String>();
    	list.add("103");
    	list.add("104");
    	variables.put("users", list);
    	ProcessInstance pi = processEngine.getRuntimeService()//  
    			.startProcessInstanceByKey("会签",variables);  
    	System.out.println("pid:" + pi.getId());
    	
    }  
  
   
    /**完成任务*/  
    @Test  
    public void completeTask() {  
    	//完成104任务，
    	 // 任务办理人  
        String candidateUser = "103";  //103,104都有任务
        List<Task> list = processEngine.getTaskService()//  
                .createTaskQuery()//  
                .taskCandidateUser(candidateUser)// 参与者，组任务查询  
                .list();  
        if (list != null && list.size() > 0) {  
            for (Task task : list) {  
                System.out.println("任务ID：" + task.getId());  
                System.out.println("任务的办理人：" + task.getAssignee());  
                System.out.println("任务名称：" + task.getName());  
                System.out.println("任务的创建时间：" + task.getCreateTime());  
                System.out.println("流程实例ID：" + task.getProcessInstanceId());  
                System.out.println("#######################################");  
                System.out.println("完成任务"+task.getId());
                processEngine.getTaskService().complete(task.getId());
            }  
        }  
        // 任务办理人  
        candidateUser = "104";  //103,104都有任务
        list = processEngine.getTaskService()//  
                .createTaskQuery()//  
                .taskCandidateUser(candidateUser)// 参与者，组任务查询  
                .list();  
        if (list != null && list.size() > 0) {  
            for (Task task : list) {  
                System.out.println("任务ID：" + task.getId());  
                System.out.println("任务的办理人：" + task.getAssignee());  
                System.out.println("任务名称：" + task.getName());  
                System.out.println("任务的创建时间：" + task.getCreateTime());  
                System.out.println("流程实例ID：" + task.getProcessInstanceId());  
                System.out.println("#######################################");  
                //processEngine.getTaskService().complete(task.getId());
            }
        }  
    }  
  
   
} 