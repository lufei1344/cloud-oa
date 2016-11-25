package com.cloudoa.framework.flow.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.ManagementService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricProcessInstanceQuery;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.impl.pvm.PvmActivity;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.Job;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.DelegationState;
import org.activiti.engine.task.Task;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.cmd.FindNextActivitiesCmd;
import com.cloudoa.framework.orm.Page;
import com.cloudoa.framework.security.dao.UserDao;
import com.cloudoa.framework.security.entity.User;
import com.cloudoa.framework.security.shiro.ShiroUtils;
import com.cloudoa.framework.utils.DbConn;
@Component
public class ProcessService {
    private Logger logger = LoggerFactory.getLogger(ProcessService.class);
    @Autowired
    private ProcessEngine processEngine;
    @Autowired
    private UserDao userDao;
    @Autowired
    private DbConn db;

    public String startProcess(String userId, String businessKey,
            String processDefinitionId, Map<String, Object> processParameters) {
        // 先设置登录用户
        IdentityService identityService = processEngine.getIdentityService();
        identityService.setAuthenticatedUserId(userId);

        ProcessInstance processInstance = processEngine.getRuntimeService()
                .startProcessInstanceById(processDefinitionId, businessKey,
                        processParameters);

        /*
         * // {流程标题:title}-{发起人:startUser}-{发起时间:startTime} String processDefinitionName =
         * processEngine.getRepositoryService() .createProcessDefinitionQuery()
         * .processDefinitionId(processDefinitionId).singleResult() .getName(); String processInstanceName =
         * processDefinitionName + "-" + userConnector.findById(userId).getDisplayName() + "-" + new
         * SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
         * processEngine.getRuntimeService().setProcessInstanceName( processInstance.getId(), processInstanceName);
         */
        return processInstance.getId();
    }
    /**
     * 部署.列表
     */
    public Page findDeployments(String tenantId, Page page) {
        RepositoryService repositoryService = processEngine
                .getRepositoryService();
        long count = repositoryService.createDeploymentQuery()
                .count();
        List<Deployment> deployments = repositoryService
                .createDeploymentQuery()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(deployments);
        page.setTotalCount(count);

        return page;
    }
    /**
     * 流程定义.
     */
    public Page findProcessDefinitions(String tenantId, Page page) {
        RepositoryService repositoryService = processEngine
                .getRepositoryService();
        long count = repositoryService.createProcessDefinitionQuery()
                .count();
        List<ProcessDefinition> processDefinitions = repositoryService
                .createProcessDefinitionQuery()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(processDefinitions);
        page.setTotalCount(count);

        return page;
    }
    /**
     * 流程定义发布
     */
    public boolean processDefinitionDeployment(String name,String xml,String tenantId,String category) {
    	 
		try {
			RepositoryService repositoryService = processEngine
	                 .getRepositoryService();
	         ByteArrayInputStream bais;
			bais = new ByteArrayInputStream(
			         xml.getBytes("UTF-8"));
			Deployment deployment = repositoryService.createDeployment()
	                 .addInputStream(name+".bpmn", bais).name(name).category(category).deploy();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return false;
		}
         return true;
    }
    /**
     * 获取流程定义
     */
    public ProcessDefinition findDefinition(String id) {
    	 RepositoryService repositoryService = processEngine
                 .getRepositoryService();
         ProcessDefinition processDefinition = repositoryService
                 .createProcessDefinitionQuery()
                 .processDefinitionId(id).singleResult();
         return processDefinition;
    }
    /**
     * 获取部署定义
     */
    public Deployment findDefinitionDeployment(String id) {
    	Deployment deployment = null;
    	deployment = processEngine.getRepositoryService().createDeploymentQuery().deploymentId(id).singleResult();
    	return deployment;
    }
    /**
     * 获取定义xml
     */
    public String findDefinitionDeploymentXml(String id) {
    	 RepositoryService repositoryService = processEngine
                 .getRepositoryService();
         ProcessDefinition processDefinition = repositoryService
                 .createProcessDefinitionQuery()
                 .processDefinitionId(id).singleResult();
         return findDefinitionDeploymentXml(processDefinition);
    }
    /**
     * 获取定义xml
     */
    public String findDefinitionDeploymentXml(ProcessDefinition processDefinition) {
    	String resourceName = processDefinition.getResourceName();
    	InputStream resourceAsStream = processEngine.getRepositoryService().getResourceAsStream(
    			processDefinition.getDeploymentId(), resourceName);
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();
    	try {
    		IOUtils.copy(resourceAsStream, baos);
    		baos.flush();
    	} catch (IOException e) {
    		e.printStackTrace();
    	}
    	return baos.toString();
    }
   
    /**
     * 开启流程实例
     * @param key
     * @param users
     * @return
     */
    public Task startProcessInstance(String id,Map<String,Object> users){
    	ProcessInstance pi = processEngine.getRuntimeService().startProcessInstanceById(id,users);
    	Task task = processEngine.getTaskService().createTaskQuery().processInstanceId(pi.getId()).taskCandidateUser(ShiroUtils.getUserId().toString()).singleResult();
    	return task;
    }
    /**
     * 得到下一步节点
     * @return [{id:id,name:name,users:[]}]
     */
    public List<Map<String,Object>> findProcessInstanceNextNode(String processDefinitionId,String activityId){
    	FindNextActivitiesCmd cmd = new FindNextActivitiesCmd(
                processDefinitionId, activityId);

    	List<PvmActivity> pvmActivities = processEngine.getManagementService().executeCommand(cmd);
    	List<Map<String,Object>> nodes = new ArrayList<Map<String,Object>>();
		for (PvmActivity pvmActivity : pvmActivities) {
            Map<String,Object> node = new HashMap<String,Object>();
            node.put("id", pvmActivity.getId());
            node.put("name", pvmActivity.getProperty("name"));
            node.put("users", this.findNodeUser(pvmActivity.getId()));//该节点可以处理的用户,先测试用，以后改为配置
            nodes.add(node);
        }
		return nodes;
    }
    
    public List<Map<String,Object>> findNodeUser(String activityId){
    	List<User> us = userDao.findBy("sex", "1");
    	List<Map<String,Object>> users = new ArrayList<Map<String,Object>>();
    	for(int i=0; i<us.size(); i++){
    		 Map<String,Object> u = new HashMap<String,Object>();
    		 u.put("id", us.get(i).getId());
    		 u.put("fullname", us.get(i).getFullname());
    		 u.put("orgname", us.get(i).getOrg().getName());
    		 u.put("orgid", us.get(i).getOrg().getId());
    		 users.add(u);
    	}
    	return users;
    }
   /**
    * 任务处理
    * @param taskId   任务id
    * @param executionId 实例id
    * @param title  标题
    * @param vars	变量，users提交人，next下一步
    */
    public void taskComplate(String taskId,String executionId,String title,Map<String,Object> vars){
    	processEngine.getRuntimeService().setProcessInstanceName(executionId,title);
    	processEngine.getTaskService().complete(taskId, vars);
    	//processEngine.getManagementService()..executeCommand(new JumpTaskCmd(executionId,activityId,vars,"测试标题"));
    }
    
    /**
     * 未结流程.
     */
    public Page findRunningProcessInstances(String userId, String tenantId,
            Page page) {
        HistoryService historyService = processEngine.getHistoryService();

        // TODO: 改成通过runtime表搜索，提高效率
        long count = historyService.createHistoricProcessInstanceQuery()
                .startedBy(userId)
                .unfinished().count();
        HistoricProcessInstanceQuery query = historyService
                .createHistoricProcessInstanceQuery()
                .startedBy(userId)
                .unfinished();

        if (page.getOrderBy() != null) {
            String orderBy = page.getOrderBy();

            if ("processInstanceStartTime".equals(orderBy)) {
                query.orderByProcessInstanceStartTime();
            }

            if (page.isAsc()) {
                query.asc();
            } else {
                query.desc();
            }
        }

        List<HistoricProcessInstance> historicProcessInstances = query
                .listPage((int) page.getStart(), page.getPageSize());

        page.setResult(historicProcessInstances);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 已结流程.
     */
    public Page findCompletedProcessInstances(String userId, String tenantId,
            Page page) {
        HistoryService historyService = processEngine.getHistoryService();

        long count = historyService.createHistoricProcessInstanceQuery()
                .startedBy(userId).finished()
                .count();
        List<HistoricProcessInstance> historicProcessInstances = historyService
                .createHistoricProcessInstanceQuery().startedBy(userId)
                .finished()
                .listPage((int) page.getStart(), page.getPageSize());

        page.setResult(historicProcessInstances);
        page.setTotalCount(count);

        return page;
    }

    

    /**
     * 待办任务（个人任务）.在本项目中不适用，所有代办都为taskCandidateUser
     */
    public Page findPersonalTasks(String userId, String tenantId, Page page) {
        TaskService taskService = processEngine.getTaskService();

        long count = taskService.createTaskQuery()
                .taskAssignee(userId).active().count();
        List<Task> tasks = taskService.createTaskQuery()
                .taskAssignee(userId).active()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(tasks);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 代领任务（组任务）.
     */
    public Page findGroupTasks(String userId, String tenantId, Page<Map<String,Object>> page) {
        /*TaskService taskService = processEngine.getTaskService();

        long count = taskService.createTaskQuery().taskTenantId(tenantId)
                .taskCandidateUser(userId).active().count();
        List<Task> tasks = taskService.createTaskQuery().taskTenantId(tenantId)
                .taskCandidateUser(userId).active()
                .listPage((int) page.getStart(), page.getPageSize());
       
      
        page.setResult(tasks);
        page.setTotalCount(count);
*/		String sql = "select distinct"+
					"		res.id_ as id,"+
					"		res.rev_ as rev,"+
					"		res.execution_id_ as executionId,"+
					"		res.proc_def_id_ as processDefinitionId,"+
					"		res.name_ as name,"+
					"		res.task_def_key_ as activityId,"+
					"		res.create_time_ as createtime,"+
					"		res.proc_inst_id_ as processInstanceId,"+
					 "		e.name_ as title,u.fullname,u.id as userid"+
					"	from"+
					"		act_ru_task res"+
					"	inner join act_ru_identitylink i on i.task_id_ = res.id_"+
					"	inner join act_ru_execution e on res.execution_id_=e.id_"+
					"	inner join sec_user u on i.user_id_=u.id"+
					"	where"+
					"		res.assignee_ is null"+
					"	and i.type_ = 'candidate'"+
					"	and i.user_id_ = "+userId+
					"	and res.suspension_state_ = 1"+
					"	order by"+
					"		res.id_ asc";
		page = db.getPage(page, new StringBuffer(sql), null);
        return page;
    }

    /**
     * 已办任务（历史任务）.
     */
    public Page findHistoryTasks(String userId, String tenantId, Page page) {
        HistoryService historyService = processEngine.getHistoryService();

        long count = historyService.createHistoricTaskInstanceQuery()
                .taskAssignee(userId).finished().count();
        List<HistoricTaskInstance> historicTaskInstances = historyService
                .createHistoricTaskInstanceQuery()
                .taskAssignee(userId).finished()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(historicTaskInstances);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 代理中的任务（代理人还未完成该任务）.
     */
    public Page findDelegatedTasks(String userId, String tenantId, Page page) {
        TaskService taskService = processEngine.getTaskService();

        long count = taskService.createTaskQuery()
                .taskOwner(userId).taskDelegationState(DelegationState.PENDING)
                .count();
        List<Task> tasks = taskService.createTaskQuery()
                .taskOwner(userId).taskDelegationState(DelegationState.PENDING)
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(tasks);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 同时返回已领取和未领取的任务.
     */
    public Page findCandidateOrAssignedTasks(String userId, String tenantId,
            Page page) {
        TaskService taskService = processEngine.getTaskService();

        long count = taskService.createTaskQuery()
                .taskCandidateUser(userId).count();
        List<Task> tasks = taskService.createTaskQuery()
                .taskCandidateUser(userId)
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(tasks);
        page.setTotalCount(count);

        return page;
    }

    

    /**
     * 流程实例.
     */
    public Page findProcessInstances(String tenantId, Page page) {
        RuntimeService runtimeService = processEngine.getRuntimeService();
        long count = runtimeService.createProcessInstanceQuery()
                .count();
        List<ProcessInstance> processInstances = runtimeService
                .createProcessInstanceQuery()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(processInstances);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 任务.
     */
    public Page findTasks(String tenantId, Page page) {
        TaskService taskService = processEngine.getTaskService();
        long count = taskService.createTaskQuery()
                .count();
        List<Task> tasks = taskService.createTaskQuery()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(tasks);
        page.setTotalCount(count);

        return page;
    }

    

    /**
     * 历史流程实例.
     */
    public Page findHistoricProcessInstances(String tenantId, Page page) {
        HistoryService historyService = processEngine.getHistoryService();

        long count = historyService.createHistoricProcessInstanceQuery()
                .count();
        List<HistoricProcessInstance> historicProcessInstances = historyService
                .createHistoricProcessInstanceQuery()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(historicProcessInstances);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 历史节点.
     */
    public Page findHistoricActivityInstances(String tenantId, Page page) {
        HistoryService historyService = processEngine.getHistoryService();

        long count = historyService.createHistoricActivityInstanceQuery()
               .count();
        List<HistoricActivityInstance> historicActivityInstances = historyService
                .createHistoricActivityInstanceQuery()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(historicActivityInstances);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 历史任务.
     */
    public Page findHistoricTaskInstances(String tenantId, Page page) {
        HistoryService historyService = processEngine.getHistoryService();

        long count = historyService.createHistoricTaskInstanceQuery()
                .count();
        List<HistoricTaskInstance> historicTaskInstances = historyService
                .createHistoricTaskInstanceQuery()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(historicTaskInstances);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 作业.
     */
    public Page findJobs(String tenantId, Page page) {
        ManagementService managementService = processEngine
                .getManagementService();

        long count = managementService.createJobQuery()
                .count();
        List<Job> jobs = managementService.createJobQuery()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(jobs);
        page.setTotalCount(count);

        return page;
    }

   
}
