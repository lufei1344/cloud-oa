package com.cloudoa.framework.flow.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.HistoryService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cloudoa.framework.flow.service.ProcessService;
import com.cloudoa.framework.orm.Page;
import com.cloudoa.framework.security.shiro.ShiroUtils;
import com.cloudoa.framework.utils.MsgUtils;

/**
 * 实例任务管理Controller
 * @author yuqs
 * @since 0.1
 */
@Controller
@RequestMapping(value = "/flow/task")
public class TaskController {
    
    @Autowired
    private ProcessService processService;
    @Autowired
    private ProcessEngine processEngine;
    /**
     * 开启流程
     * @param model
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value="start")
    @ResponseBody
    public Object start(String id, HttpServletRequest request) {
    	Map<String,Object> vars = new HashMap<String,Object>();
    	vars.put("users", ShiroUtils.getUserId().toString());//设置登录用户id  
    	Task task = processService.startProcessInstance(id, vars);
    	Map<String,Object> obj = new HashMap<String,Object>();
    	obj.put("taskId", task.getId());
    	obj.put("executionId", task.getExecutionId());
    	obj.put("activityId", task.getTaskDefinitionKey());
    	obj.put("processDefinitionId", task.getProcessDefinitionId());
    	obj.put("processInstanceId", task.getProcessInstanceId());
    	return MsgUtils.returnOk("",obj);
    }
    /**
     * 可以打开的表单和编辑的元素
     * @param model
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value="openViews")
    @ResponseBody
    public Object openViews(HttpServletRequest request) {
    	String activityId = request.getParameter("activityId");
    	String processDefinitionId = request.getParameter("processDefinitionId");
    	String openType = request.getParameter("openType");
    	Map<String,Object> obj = new HashMap<String,Object>();
    	obj.put("activityId", activityId);
    	obj.put("processDefinitionId", processDefinitionId);
    	if("1".equals(openType)){//任务处理
    		obj.put("forms", processService.findNodeForm(processDefinitionId, activityId));
        	obj.put("fields", processService.findNodeField(processDefinitionId, activityId));
    	}else{//查看
    		obj.put("forms", processService.findNodeForm(processDefinitionId));
        	obj.put("fields", "");
    	}
    	
    	return MsgUtils.returnOk("",obj);
    }
    /**
     * 流程提交人员选择
     * @param model
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value="tonext")
    @ResponseBody
    public Object tonext(String processDefinitionId,String activityId, HttpServletRequest request) {
    	return MsgUtils.returnOk("",processService.findProcessInstanceNextNode(processDefinitionId,activityId));
    }
    /**
     * 流程提交
     * @param model
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value="next")
    @ResponseBody
    public Object next(String taskId,String executionId,String title, HttpServletRequest request) {
    	String users = request.getParameter("users");
    	String next = request.getParameter("next");
    	String type = request.getParameter("type");
    	Map<String,Object> vars = new HashMap<String,Object>();
    	vars.put("users", users);//提交的人员
    	if("multi".equals(type)){//only单人,more多人,multi会签
    		//会签
    		String[] sus = users.split(",");
    		List<String> us = new ArrayList<String>();
    		for(String s : sus){
    			us.add(s);
    		}
    		vars.put("users", us);//提交的人员
    	}
    	vars.put("next", next);//下一步节点
    	processService.taskComplate(taskId,executionId,title,vars);
    	return MsgUtils.returnOk("");
    }
    /**
     * 流程跟踪【包含流程跟踪、任务列表（完成和未完成）、流程变量】.
     */
    @RequestMapping("taskTrace")
    @ResponseBody
    public Object taskTrace(String processInstanceId, Model model) {
        HistoryService historyService = processEngine.getHistoryService();
        HistoricProcessInstance historicProcessInstance = historyService
                .createHistoricProcessInstanceQuery()
                .processInstanceId(processInstanceId).singleResult();

      
        List<HistoricTaskInstance> historicTasks = historyService
                .createHistoricTaskInstanceQuery()
                .processInstanceId(processInstanceId).list();
      
        model.addAttribute("historicTasks", historicTasks);
        String xml = processService.findDefinitionDeploymentXml(historicProcessInstance.getProcessDefinitionId());

        Map<String,Object> obj = new HashMap<String,Object>();
        obj.put("xml", xml);
        return MsgUtils.returnOk("", obj);
    }
    /**
     * 未结任务
     * @param model
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value="runningProcessInstances")
    @ResponseBody
    public Object runningProcessInstances(Model model,@ModelAttribute Page page, HttpServletRequest request) {
    	 page = processService.findRunningProcessInstances(ShiroUtils.getUserId().toString(), TenantHolder.TenantId,
                 page);
    	return MsgUtils.returnOk("",page);
    }
    /**
     * 办结任务
     * @param model
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value="completedProcessInstances")
    @ResponseBody
    public Object completedProcessInstances(Model model,@ModelAttribute Page page, HttpServletRequest request) {
    	page = processService.findCompletedProcessInstances(ShiroUtils.getUserId().toString(), 
    			page);
    	return MsgUtils.returnOk("",page);
    }
    
    
    /**
     * 代领任务（组任务）
     * 
     * @return
     * @throws IOException 
     */
    @RequestMapping("groupTasks")
    @ResponseBody
    public Object groupTasks(@ModelAttribute Page page, HttpServletRequest request,    
            HttpServletResponse response) throws IOException {
    	 String userId = ShiroUtils.getUserId().toString();
         String tenantId = TenantHolder.TenantId;

        page = processService.findGroupTasks(userId, tenantId, page);
        
        return MsgUtils.returnOk("",page);
    }

    /**
     * 已办任务（历史任务）
     * 
     * @return
     */
    @RequestMapping("historyTasks")
    @ResponseBody
    public Object historyTasks(@ModelAttribute Page page, Model model) {
    	 String userId = ShiroUtils.getUserId().toString();
         String tenantId = TenantHolder.TenantId;
        page = processService.findHistoryTasks(userId, page);
        model.addAttribute("page", page);

        return MsgUtils.returnOk("",page);
    }

    private Page task2Map(Page page){
    	List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
        for(Task t : (List<Task>)page.getResult()){
        	Map<String,Object> m = new HashMap<String,Object>();
        	m.put("id", t.getId());
        	m.put("name", t.getName());
        	m.put("createTime", t.getCreateTime());
        	m.put("executionId", t.getExecutionId());
        	m.put("processDefinitionId", t.getProcessDefinitionId());
        	m.put("processInstanceId", t.getProcessInstanceId());
        	m.put("dueDate", t.getDueDate());
        	result.add(m);
        }
        page.setResult(result);
        return page;
    }

}
