import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.impl.RepositoryServiceImpl;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;

import com.cloudoa.framework.security.shiro.ShiroUtils;
import com.cloudoa.framework.utils.SpringUtil;


public class TestFlow {

	public static void main(String[] args){
		//new TestFlow().deployProcess();
		//new TestFlow().processPic();
		//new TestFlow().processPicHeight();
		//new TestFlow().deployProcess();
		new TestFlow().startInstance();
		//new TestFlow().task1();
		//new TestFlow().task("leader", null);
		//new TestFlow().task("boss", null);
	}
	
	public void allAction(){
		ProcessEngine processEngine = SpringUtil.getBean("processEngine");
	 	ProcessDefinition p = processEngine.getRepositoryService().createProcessDefinitionQuery().processDefinitionKey("myLeaveProcess").latestVersion().singleResult();
	 	ProcessDefinitionEntity definition = (ProcessDefinitionEntity) ((RepositoryServiceImpl)processEngine.getRepositoryService()).getDeployedProcessDefinition(p.getId());
	 	
	 	List<ActivityImpl> acts = definition.getActivities();
	 	for(int i=0; i<acts.size(); i++){
	 		System.out.println(acts.get(i).getProperties());
	 	}
		
	}
	
	
	//部署流程
	public void deployProcess(){
		ProcessEngine processEngine = SpringUtil.getBean("processEngine");
		//Deployment deploy = processEngine.getRepositoryService().createDeployment().addClasspathResource("ceshi.xml").deploy();
		
		//System.out.println(deploy.getName()+""+deploy.getId());
		
		 InputStream inputStreamBpmn = this.getClass().getResourceAsStream(  
	                "申请.bpmn");  
	        processEngine.getRepositoryService()//  
	                .createDeployment()//  
	                .addInputStream("申请.bpmn", inputStreamBpmn)//  
	                .deploy();  
	}
	//开启实例
	public void processList(){
		ProcessEngine processEngine = SpringUtil.getBean("processEngine");
		List<ProcessDefinition> dlist = processEngine.getRepositoryService().createProcessDefinitionQuery().list();
		System.out.println(dlist);
		List<Deployment> list = processEngine.getRepositoryService().createDeploymentQuery().list();
		System.out.println(list);
	}
	//开启实例
	public void startInstance(){
		ProcessEngine processEngine = SpringUtil.getBean("processEngine");
		Map<String,Object> vars = new HashMap<String,Object>();
    	vars.put("users", "1");//设置登录用户id  
		//ProcessInstance pi = processEngine.getRuntimeService().startProcessInstanceByKey("process1479871613269",vars);
		ProcessInstance pi = processEngine.getRuntimeService().startProcessInstanceById("process1479871613269:1:4",vars);
		System.out.println(pi.getId());
	}
	//任务办理
	public void task(String name,Map<String,Object> var){
		ProcessEngine processEngine = SpringUtil.getBean("processEngine");
		List<Task> tasks = processEngine.getTaskService().createTaskQuery().processDefinitionKey("myLeaveProcess").taskAssignee(name).list();
		for(int i=0; i<tasks.size(); i++){
			tasks.get(i);
			if("apply".equals(name)){
				var = new HashMap<String,Object>();
				var.put("day", 4);
			}else{
				var = processEngine.getTaskService().getVariables(tasks.get(i).getId()) ;
				System.out.println(var);

			}
			System.out.println(tasks.get(i).getId());
			processEngine.getTaskService().complete(tasks.get(i).getId(), var);
			
		}
	}
	//任务办理
	public void task1(){
		ProcessEngine processEngine = SpringUtil.getBean("processEngine");
		List<Task> tasks = processEngine.getTaskService().createTaskQuery().processDefinitionKey("process1479871613269").taskCandidateUser("1").list();
		for(int i=0; i<tasks.size(); i++){
			tasks.get(i);
			
			System.out.println(tasks.get(i).getId());
			//processEngine.getTaskService().complete(tasks.get(i).getId(), var);
			
		}
	}
}
