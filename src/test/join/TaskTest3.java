package join;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.history.HistoricIdentityLink;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.IdentityLink;
import org.activiti.engine.task.Task;
import org.junit.Test;

import com.cloudoa.framework.utils.SpringUtil;

public class TaskTest3 {  
  
    // 流程引擎对象  
    ProcessEngine processEngine = SpringUtil.getBean("processEngine");
  
    public static void main(String[] args){
    	TaskTest3 t = new TaskTest3();
    	t.deployementAndStartProcess();
    	//t.findPersonalTaskList();
    	//t.findGroupTaskList();
    	//t.completeTask();
    }
    
    /**部署流程定义+启动流程实例：3905*/  
    @Test  
    public void deployementAndStartProcess() {  
        //1.发布流程  
        InputStream inputStreamBpmn = this.getClass().getResourceAsStream(  
                "会签.bpmn");  
        processEngine.getRepositoryService()//  
                .createDeployment()//  
                .addInputStream("会签.bpmn", inputStreamBpmn)//  
                .deploy();  
       /* //2.启动流程  
        Map<String, Object> variables = new HashMap<String, Object>(); 
        
        variables.put("touser", "大大,中中,小小");//会签不起作用  
        List<String> list = new ArrayList<String>();
        list.add("1");
        list.add("2");
        variables.put("touserList", list);
        ProcessInstance pi = processEngine.getRuntimeService()//  
                .startProcessInstanceByKey("会签",variables);  
        System.out.println("pid:" + pi.getId());  */
  
    }  
  
    /**查询我的个人任务,没有执行结果*/  
    @Test  
    public void findPersonalTaskList() {  
        // 任务办理人  
        String assignee = "1";  
        List<Task> list = processEngine.getTaskService()//  
                .createTaskQuery()//  
                .taskAssignee(assignee)// 个人任务的查询  
                .list();  
        if (list != null && list.size() > 0) {  
            for (Task task : list) {  
                System.out.println("任务ID：" + task.getId());  
                System.out.println("任务的办理人：" + task.getAssignee());  
                System.out.println("任务名称：" + task.getName());  
                System.out.println("任务的创建时间：" + task.getCreateTime());  
                System.out.println("流程实例ID：" + task.getProcessInstanceId());  
                System.out.println("#######################################");  
            }  
        }  
    }  
  
    /**查询组任务*/  
    @Test  
    public void findGroupTaskList() {  
        // 任务办理人  
        String candidateUser = "1";  
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
            }  
        }  
    }  
  
    /**完成任务*/  
    @Test  
    public void completeTask() {  
        // 任务ID  
        String taskId = "5021";  
        processEngine.getTaskService()//  
                .complete(taskId);  
        System.out.println("完成任务：" + taskId);  
    }  
  
    /**查询正在执行的组任务列表*/  
    @Test  
    public void findGroupCandidate() {  
        // 任务ID  
        String taskId = "3708";  
        List<IdentityLink> list = processEngine.getTaskService()//  
                .getIdentityLinksForTask(taskId);  
        if (list != null && list.size() > 0) {  
            for (IdentityLink identityLink : list) {  
                System.out.println("任务ID：" + identityLink.getTaskId());  
                System.out.println("流程实例ID："  
                        + identityLink.getProcessInstanceId());  
                System.out.println("用户ID：" + identityLink.getUserId());  
                System.out.println("工作流角色ID：" + identityLink.getGroupId());  
                System.out.println("#########################################");  
            }  
        }  
    }  
  
    /**查询历史的组任务列表*/  
    @Test  
    public void findHistoryGroupCandidate() {  
        // 流程实例ID  
        String processInstanceId = "3705";  
        List<HistoricIdentityLink> list = processEngine.getHistoryService()  
                .getHistoricIdentityLinksForProcessInstance(processInstanceId);  
        if (list != null && list.size() > 0) {  
            for (HistoricIdentityLink identityLink : list) {  
                System.out.println("任务ID：" + identityLink.getTaskId());  
                System.out.println("流程实例ID："  
                        + identityLink.getProcessInstanceId());  
                System.out.println("用户ID：" + identityLink.getUserId());  
                System.out.println("工作流角色ID：" + identityLink.getGroupId());  
                System.out.println("#########################################");  
            }  
        }  
    }  
    /**查询会签*/  
    @Test  
    public void findSignData() {  
    	// 流程实例ID  
    	String processInstanceId = "3705";  
    	List<HistoricIdentityLink> list = processEngine.getHistoryService()  
    			.getHistoricIdentityLinksForProcessInstance(processInstanceId);  
    	if (list != null && list.size() > 0) {  
    		for (HistoricIdentityLink identityLink : list) {  
    			System.out.println("任务ID：" + identityLink.getTaskId());  
    			System.out.println("流程实例ID："  
    					+ identityLink.getProcessInstanceId());  
    			System.out.println("用户ID：" + identityLink.getUserId());  
    			System.out.println("工作流角色ID：" + identityLink.getGroupId());  
    			System.out.println("#########################################");  
    		}  
    	}  
    }  
} 