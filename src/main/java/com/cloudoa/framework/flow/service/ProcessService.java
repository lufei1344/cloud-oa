package com.cloudoa.framework.flow.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
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

import com.cloudoa.framework.orm.Page;
@Component
public class ProcessService {
    private Logger logger = LoggerFactory.getLogger(ProcessService.class);
    @Autowired
    private ProcessEngine processEngine;

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
                .deploymentTenantId(tenantId).count();
        List<Deployment> deployments = repositoryService
                .createDeploymentQuery().deploymentTenantId(tenantId)
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
                .processDefinitionTenantId(tenantId).count();
        List<ProcessDefinition> processDefinitions = repositoryService
                .createProcessDefinitionQuery()
                .processDefinitionTenantId(tenantId)
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(processDefinitions);
        page.setTotalCount(count);

        return page;
    }
    /**
     * 流程定义发布
     */
    public boolean processDefinitionDeployment(String name,String xml,String tenantId) {
    	 
		try {
			RepositoryService repositoryService = processEngine
	                 .getRepositoryService();
	         ByteArrayInputStream bais;
			bais = new ByteArrayInputStream(
			         xml.getBytes("UTF-8"));
			Deployment deployment = repositoryService.createDeployment().tenantId(tenantId)
	                 .addInputStream(name+".bpmn", bais).name(name).deploy();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return false;
		}
         return true;
    }
    /**
     * 获取定义
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
     * 获取定义
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
     * 未结流程.
     */
    public Page findRunningProcessInstances(String userId, String tenantId,
            Page page) {
        HistoryService historyService = processEngine.getHistoryService();

        // TODO: 改成通过runtime表搜索，提高效率
        long count = historyService.createHistoricProcessInstanceQuery()
                .processInstanceTenantId(tenantId).startedBy(userId)
                .unfinished().count();
        HistoricProcessInstanceQuery query = historyService
                .createHistoricProcessInstanceQuery()
                .processInstanceTenantId(tenantId).startedBy(userId)
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
                .processInstanceTenantId(tenantId).startedBy(userId).finished()
                .count();
        List<HistoricProcessInstance> historicProcessInstances = historyService
                .createHistoricProcessInstanceQuery().startedBy(userId)
                .processInstanceTenantId(tenantId).finished()
                .listPage((int) page.getStart(), page.getPageSize());

        page.setResult(historicProcessInstances);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 参与流程.
     */
    public Page findInvolvedProcessInstances(String userId, String tenantId,
            Page page) {
        HistoryService historyService = processEngine.getHistoryService();

        // TODO: finished(), unfinished()
        long count = historyService.createHistoricProcessInstanceQuery()
                .processInstanceTenantId(tenantId).involvedUser(userId).count();
        List<HistoricProcessInstance> historicProcessInstances = historyService
                .createHistoricProcessInstanceQuery()
                .processInstanceTenantId(tenantId).involvedUser(userId)
                .listPage((int) page.getStart(), page.getPageSize());

        page.setResult(historicProcessInstances);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 待办任务（个人任务）.
     */
    public Page findPersonalTasks(String userId, String tenantId, Page page) {
        TaskService taskService = processEngine.getTaskService();

        long count = taskService.createTaskQuery().taskTenantId(tenantId)
                .taskAssignee(userId).active().count();
        List<Task> tasks = taskService.createTaskQuery().taskTenantId(tenantId)
                .taskAssignee(userId).active()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(tasks);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 代领任务（组任务）.
     */
    public Page findGroupTasks(String userId, String tenantId, Page page) {
        TaskService taskService = processEngine.getTaskService();

        long count = taskService.createTaskQuery().taskTenantId(tenantId)
                .taskCandidateUser(userId).active().count();
        List<Task> tasks = taskService.createTaskQuery().taskTenantId(tenantId)
                .taskCandidateUser(userId).active()
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(tasks);
        page.setTotalCount(count);

        return page;
    }

    /**
     * 已办任务（历史任务）.
     */
    public Page findHistoryTasks(String userId, String tenantId, Page page) {
        HistoryService historyService = processEngine.getHistoryService();

        long count = historyService.createHistoricTaskInstanceQuery()
                .taskTenantId(tenantId).taskAssignee(userId).finished().count();
        List<HistoricTaskInstance> historicTaskInstances = historyService
                .createHistoricTaskInstanceQuery().taskTenantId(tenantId)
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

        long count = taskService.createTaskQuery().taskTenantId(tenantId)
                .taskOwner(userId).taskDelegationState(DelegationState.PENDING)
                .count();
        List<Task> tasks = taskService.createTaskQuery().taskTenantId(tenantId)
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

        long count = taskService.createTaskQuery().taskTenantId(tenantId)
                .taskCandidateOrAssigned(userId).count();
        List<Task> tasks = taskService.createTaskQuery().taskTenantId(tenantId)
                .taskCandidateOrAssigned(userId)
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
                .processInstanceTenantId(tenantId).count();
        List<ProcessInstance> processInstances = runtimeService
                .createProcessInstanceQuery().processInstanceTenantId(tenantId)
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
        long count = taskService.createTaskQuery().taskTenantId(tenantId)
                .count();
        List<Task> tasks = taskService.createTaskQuery().taskTenantId(tenantId)
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
                .processInstanceTenantId(tenantId).count();
        List<HistoricProcessInstance> historicProcessInstances = historyService
                .createHistoricProcessInstanceQuery()
                .processInstanceTenantId(tenantId)
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
                .activityTenantId(tenantId).count();
        List<HistoricActivityInstance> historicActivityInstances = historyService
                .createHistoricActivityInstanceQuery()
                .activityTenantId(tenantId)
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
                .taskTenantId(tenantId).count();
        List<HistoricTaskInstance> historicTaskInstances = historyService
                .createHistoricTaskInstanceQuery().taskTenantId(tenantId)
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

        long count = managementService.createJobQuery().jobTenantId(tenantId)
                .count();
        List<Job> jobs = managementService.createJobQuery()
                .jobTenantId(tenantId)
                .listPage((int) page.getStart(), page.getPageSize());
        page.setResult(jobs);
        page.setTotalCount(count);

        return page;
    }

   
}
