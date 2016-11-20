package com.cloudoa.framework.flow.web;

import java.io.InputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.ProcessDefinition;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cloudoa.framework.flow.service.ProcessService;
import com.cloudoa.framework.orm.Page;
import com.cloudoa.framework.orm.PropertyFilter;
import com.cloudoa.framework.utils.MsgUtils;

/**
 * 流程管理Controller
 * @author yuqs
 * @since 0.1
 */
@Controller
@RequestMapping(value = "/flow/process")
public class FlowController {
    public static final String PARA_PROCESSID = "processId";
    public static final String PARA_ORDERID = "orderId";
    public static final String PARA_TASKID = "taskId";

    @Autowired
    private ProcessService processService;
    
    /**
     * 流程定义列表
     * @param model
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(method = RequestMethod.GET)
    public String list(Model model,Page<ProcessDefinition> page, HttpServletRequest request) {
        List<PropertyFilter> filters = PropertyFilter.buildFromHttpRequest(request);
        //设置默认排序方式
        if (!page.isOrderBySetted()) {
            page.setOrderBy("id");
            page.setOrder(Page.ASC);
        }
        page = processService.findProcessDefinitions(TenantHolder.TenantId, page);
        model.addAttribute("page", page);
        return "flow/flowList";
    }
    @RequestMapping(value = "create", method = RequestMethod.GET)
    public String create(Model model) {
        return "flow/flowEdit";
    }

    
    @RequestMapping(value = "update/{id}", method = RequestMethod.GET)
    public String edit(@PathVariable("id") String id, Model model) {
    	ProcessDefinition processDefinition = processService.findDefinition(id);
        model.addAttribute("deploy", processService.findDefinition(id));
        model.addAttribute("xml", processService.findDefinitionDeploymentXml(processDefinition));
        return "flow/flowEdit";
    }


    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(String processDescriptor,String processName,String category,String processVariables) {
    	processService.processDefinitionDeployment(processName,processDescriptor,TenantHolder.TenantId,category);
        return MsgUtils.returnOk("");
    }


    @RequestMapping(value = "delete/{id}")
    public String delete(@PathVariable("id") Long id) {
        return "redirect:/flow/process";
    }
   
    /**
     * 流程部署列表
     * @param model
     * @param page
     * @param request
     * @return
     */
    @RequestMapping(value="deploy/list", method = RequestMethod.GET)
    public String deploy_list(Model model,Page<Deployment> page, HttpServletRequest request) {
    	List<PropertyFilter> filters = PropertyFilter.buildFromHttpRequest(request);
    	//设置默认排序方式
    	if (!page.isOrderBySetted()) {
    		page.setOrderBy("id");
    		page.setOrder(Page.ASC);
    	}
    	page = processService.findDeployments(TenantHolder.TenantId, page);
    	model.addAttribute("page", page);
    	return "flow/flowDeployList";
    }

    
    
    
    /**
     * 显示每个部署包里的资源.
     *//*
    @RequestMapping("console-listDeploymentResourceNames")
    public String listDeploymentResourceNames(
            @RequestParam("deploymentId") String deploymentId, Model model) {
        RepositoryService repositoryService = processEngine
                .getRepositoryService();
        List<String> deploymentResourceNames = repositoryService
                .getDeploymentResourceNames(deploymentId);
        model.addAttribute("deploymentResourceNames", deploymentResourceNames);

        return "bpm/console-listDeploymentResourceNames";
    }

    *//**
     * 删除部署.
     *//*
    @RequestMapping("console-removeDeployment")
    public String removeDeployment(
            @RequestParam("deploymentId") String deploymentId) {
        RepositoryService repositoryService = processEngine
                .getRepositoryService();
        List<ProcessDefinition> processDefinitions = repositoryService
                .createProcessDefinitionQuery().deploymentId(deploymentId)
                .list();

        for (ProcessDefinition processDefinition : processDefinitions) {
            String hql = "from BpmConfBase where processDefinitionId=? or (processDefinitionKey=? and processDefinitionVersion=?)";
            List<BpmConfBase> bpmConfBases = bpmConfBaseManager.find(hql,
                    processDefinition.getId(), processDefinition.getKey(),
                    processDefinition.getVersion());

            for (BpmConfBase bpmConfBase : bpmConfBases) {
                for (BpmConfNode bpmConfNode : bpmConfBase.getBpmConfNodes()) {
                    for (BpmConfCountersign bpmConfCountersign : bpmConfNode
                            .getBpmConfCountersigns()) {
                        bpmConfBaseManager.remove(bpmConfCountersign);
                    }

                    for (BpmConfForm bpmConfForm : bpmConfNode
                            .getBpmConfForms()) {
                        bpmConfBaseManager.remove(bpmConfForm);
                    }

                    for (BpmConfListener bpmConfListener : bpmConfNode
                            .getBpmConfListeners()) {
                        bpmConfBaseManager.remove(bpmConfListener);
                    }

                    for (BpmConfNotice bpmConfNotice : bpmConfNode
                            .getBpmConfNotices()) {
                        bpmConfBaseManager.remove(bpmConfNotice);
                    }

                    for (BpmConfOperation bpmConfOperation : bpmConfNode
                            .getBpmConfOperations()) {
                        bpmConfBaseManager.remove(bpmConfOperation);
                    }

                    for (BpmConfRule bpmConfRule : bpmConfNode
                            .getBpmConfRules()) {
                        bpmConfBaseManager.remove(bpmConfRule);
                    }

                    for (BpmConfUser bpmConfUser : bpmConfNode
                            .getBpmConfUsers()) {
                        bpmConfBaseManager.remove(bpmConfUser);
                    }

                    bpmConfBaseManager.remove(bpmConfNode);
                }

                bpmConfBaseManager.remove(bpmConfBase);
            }
        }

        repositoryService.deleteDeployment(deploymentId, true);

        return "redirect:/bpm/console-listDeployments.do";
    }

    *//**
     * 新建流程.
     *//*
    @RequestMapping("console-create")
    public String create() {
        return "bpm/console-create";
    }

    *//**
     * 准备上传流程定义.
     *//*
    @RequestMapping("console-process-input")
    public String processInput() {
        return "bpm/console-process-input";
    }

    *//**
     * 上传发布流程定义.
     *//*
    @RequestMapping("console-process-upload")
    public String processUpload(@RequestParam("file") MultipartFile file,
            RedirectAttributes redirectAttributes) throws Exception {
        String tenantId = tenantHolder.getTenantId();
        String fileName = file.getOriginalFilename();
        Deployment deployment = processEngine.getRepositoryService()
                .createDeployment()
                .addInputStream(fileName, file.getInputStream())
                .tenantId(tenantId).deploy();
        List<ProcessDefinition> processDefinitions = processEngine
                .getRepositoryService().createProcessDefinitionQuery()
                .deploymentId(deployment.getId()).list();

        for (ProcessDefinition processDefinition : processDefinitions) {
            processEngine.getManagementService().executeCommand(
                    new SyncProcessCmd(processDefinition.getId()));
        }

        return "redirect:/bpm/console-listProcessDefinitions.do";
    }

    *//**
     * 发布流程.
     *//*
    @RequestMapping("console-deploy")
    public String deploy(@RequestParam("xml") String xml) throws Exception {
        RepositoryService repositoryService = processEngine
                .getRepositoryService();
        ByteArrayInputStream bais = new ByteArrayInputStream(
                xml.getBytes("UTF-8"));
        Deployment deployment = repositoryService.createDeployment()
                .addInputStream("process.bpmn20.xml", bais).deploy();
        List<ProcessDefinition> processDefinitions = repositoryService
                .createProcessDefinitionQuery()
                .deploymentId(deployment.getId()).list();

        for (ProcessDefinition processDefinition : processDefinitions) {
            processEngine.getManagementService().executeCommand(
                    new SyncProcessCmd(processDefinition.getId()));
        }

        return "redirect:/bpm/console-listProcessDefinitions.do";
    }*/

   /* *//**
     * 显示流程定义列表.
     *//*
    @RequestMapping("console-listProcessDefinitions")
    public String listProcessDefinitions(@ModelAttribute Page page, Model model) {
        String tenantId = tenantHolder.getTenantId();
        page = processConnector.findProcessDefinitions(tenantId, page);
        model.addAttribute("page", page);

        return "bpm/console-listProcessDefinitions";
    }

    *//**
     * 暂停流程定义.
     *//*
    @RequestMapping("console-suspendProcessDefinition")
    public String suspendProcessDefinition(
            @RequestParam("processDefinitionId") String processDefinitionId) {
        RepositoryService repositoryService = processEngine
                .getRepositoryService();
        repositoryService.suspendProcessDefinitionById(processDefinitionId,
                true, null);

        return "redirect:/bpm/console-listProcessDefinitions.do";
    }

    *//**
     * 恢复流程定义.
     *//*
    @RequestMapping("console-activeProcessDefinition")
    public String activeProcessDefinition(
            @RequestParam("processDefinitionId") String processDefinitionId) {
        RepositoryService repositoryService = processEngine
                .getRepositoryService();

        repositoryService.activateProcessDefinitionById(processDefinitionId,
                true, null);

        return "redirect:/bpm/console-listProcessDefinitions.do";
    }

    *//**
     * 显示流程定义图形.
     *//*
    @RequestMapping("console-graphProcessDefinition")
    public void graphProcessDefinition(
            @RequestParam("processDefinitionId") String processDefinitionId,
            HttpServletResponse response) throws Exception {
        Command<InputStream> cmd = new ProcessDefinitionDiagramCmd(
                processDefinitionId);

        InputStream is = processEngine.getManagementService().executeCommand(
                cmd);
        response.setContentType("image/png");

        IOUtils.copy(is, response.getOutputStream());
    }

    *//**
     * 显示流程定义的xml.
     *//*
    @RequestMapping("console-viewXml")
    public void viewXml(
            @RequestParam("processDefinitionId") String processDefinitionId,
            HttpServletResponse response) throws Exception {
        RepositoryService repositoryService = processEngine
                .getRepositoryService();
        ProcessDefinition processDefinition = repositoryService
                .createProcessDefinitionQuery()
                .processDefinitionId(processDefinitionId).singleResult();
        String resourceName = processDefinition.getResourceName();
        InputStream resourceAsStream = repositoryService.getResourceAsStream(
                processDefinition.getDeploymentId(), resourceName);
        response.setContentType("text/xml;charset=UTF-8");
        IOUtils.copy(resourceAsStream, response.getOutputStream());
    }*/
    
}
