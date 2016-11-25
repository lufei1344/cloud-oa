import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;

import com.cloudoa.framework.flow.service.ProcessService;
import com.cloudoa.framework.utils.SpringUtil;

public class Tshenqing {

	public static void main(String[] args) {
		Tshenqing t = new Tshenqing();
		t.deployProcess();
	}
	
	//部署流程
		public  void  deployProcess(){
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
}
