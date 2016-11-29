package join;

import java.util.HashMap;
import java.util.Map;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.junit.Test;

import com.cloudoa.framework.utils.SpringUtil;

public class TestMultiInstance {  
	// 流程引擎对象  
    ProcessEngine processEngine = SpringUtil.getBean("processEngine");
    @Test  
    public void testProcess() {  
        RepositoryService repositoryService = processEngine.getRepositoryService();  
        RuntimeService runtimeService = processEngine.getRuntimeService();  
        TaskService taskService = processEngine.getTaskService();  
        Deployment deploy = repositoryService.createDeployment()//  
                .name("会签流程测试")//  
                .addInputStream("multiInstances.bpmn", this.getClass().getResourceAsStream("multiInstances.bpmn"))//  
                .addInputStream("multiInstances.png", this.getClass().getResourceAsStream("multiInstances.png"))//  
                .deploy();  
        System.out.println(deploy.getId() + " " + deploy.getName());  
        Map<String, Object> variables = new HashMap<String, Object>();  
        //variables.put("mulitiInstance", new MulitiInstanceCompleteTask());  
        ProcessInstance pi = runtimeService.startProcessInstanceByKey("multiInstances",variables);  
        System.out.println(pi.getId() + "  " + pi.getActivityId());  
        Task task1 = taskService.createTaskQuery().processInstanceId(pi.getId()).taskAssignee("张三").singleResult();  
        System.out.println(task1.getId() + " - " + task1.getAssignee() + " - " + task1.getProcessInstanceId() + " - " + task1.getProcessDefinitionId());  
        Task task2 = taskService.createTaskQuery().processInstanceId(pi.getId()).taskAssignee("李四").singleResult();  
        System.out.println(task2.getId() + " - " + task2.getAssignee() + " - " + task2.getProcessInstanceId() + " - " + task2.getProcessDefinitionId());  
        Task task3 = taskService.createTaskQuery().processInstanceId(pi.getId()).taskAssignee("王五").singleResult();  
        System.out.println(task3.getId() + " - " + task3.getAssignee() + " - " + task3.getProcessInstanceId() + " - " + task3.getProcessDefinitionId());  
        Task task4 = taskService.createTaskQuery().processInstanceId(pi.getId()).taskAssignee("赵六").singleResult();  
        if (task4 != null) {  
            System.out.println(task4.getId() + " - " + task4.getAssignee() + " - " + task4.getProcessInstanceId() + " - " + task4.getProcessDefinitionId());  
        }  
        Task task5 = taskService.createTaskQuery().processInstanceId(pi.getId()).taskAssignee("钱七").singleResult();  
        System.out.println(task5);  
        taskService.complete(task1.getId());  
        taskService.complete(task2.getId());  
        taskService.complete(task3.getId());  
        Task task6 = taskService.createTaskQuery().processInstanceId(pi.getId()).taskAssignee("钱七").singleResult();  
        System.out.println(task6);  
        taskService.complete(task4.getId());  
        Task task7 = taskService.createTaskQuery().processInstanceId(pi.getId()).taskAssignee("钱七").singleResult();  
        System.out.println(task7);  
        taskService.complete(task7.getId());  
        ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().processInstanceId(pi.getId()).singleResult();  
        if (null == processInstance) {  
            System.out.println("流程完成.");  
        }  
    }  
} 