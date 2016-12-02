package com.cloudoa.framework.flow.web;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.ProcessDefinition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

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
    @RequestMapping(value = "upload", method = RequestMethod.GET)
    public String upload(Model model) {
    	return "flow/upload";
    }
    @RequestMapping(value = "saveUpload", method = RequestMethod.POST)
    @ResponseBody
    public Object saveUpload(HttpServletRequest request,HttpServletResponse response) throws IllegalStateException, IOException {
    	String processName = request.getParameter("processName");
    	String category = request.getParameter("category");
    	List<String> files = this.saveFile(request);
    	for(int i=0;i<files.size(); i++){
    		processService.processDefinitionDeployment(processName,category,files.get(i));
    	}
        return MsgUtils.returnOk("");
    }
    
    private List<String> saveFile(HttpServletRequest request) throws IllegalStateException, IOException{
    	CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());  
    	List<String> files = new ArrayList<String>();
        //判断 request 是否有文件上传,即多部分请求  
        if(multipartResolver.isMultipart(request)){  
            //转换成多部分request    
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest)request;  
            //取得request中的所有文件名  
            Iterator<String> iter = multiRequest.getFileNames();
            int i = 0;
            while(iter.hasNext()){  
                  
                //取得上传文件  
                MultipartFile file = multiRequest.getFile(iter.next());
                files.add(request.getSession(true).getServletContext().getRealPath("/")+file.getName());
                file.transferTo(new File(files.get(files.size()-1))); 
            }
        } 
        return files;
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
    public Object update(String processDescriptor,String processJson,String processName,String category,String processVariables) {
    	processService.processDefinitionDeployment(processName,processDescriptor,processJson,TenantHolder.TenantId,category);
        return MsgUtils.returnOk("");
    }


    @RequestMapping(value = "delete/{id}")
    @ResponseBody
    public Object delete(@PathVariable("id") String id) {
    	processService.deleteProcessDefinitionDeployment(id);
        return MsgUtils.returnOk("");
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
