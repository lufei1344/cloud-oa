package com.cloudoa.framework.flow.cmd;

import java.util.Map;

import org.activiti.engine.impl.context.Context;
import org.activiti.engine.impl.interceptor.Command;
import org.activiti.engine.impl.interceptor.CommandContext;
import org.activiti.engine.impl.persistence.entity.ExecutionEntity;
import org.activiti.engine.impl.persistence.entity.TaskEntity;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.impl.pvm.process.ProcessDefinitionImpl;
import org.activiti.engine.task.Comment;

public class JumpTaskCmd implements Command<Comment> {  
  
    protected String executionId;  
    protected String activityId;  
    protected String title;
    protected Map<String,Object> vars;  
      
      
    public JumpTaskCmd(String executionId, String activityId,Map<String,Object> vars,String title) {  
        this.executionId = executionId;  
        this.activityId = activityId;  
        this.vars = vars;
        this.title = title;
    }  
      
    public Comment execute(CommandContext commandContext) {  
    	
    	
      /*  for (TaskEntity taskEntity : Context.getCommandContext().getTaskEntityManager().findTasksByExecutionId(executionId)) {  
            Context.getCommandContext().getTaskEntityManager().deleteTask(taskEntity, "jump", false);  
        }  
        ExecutionEntity executionEntity = Context.getCommandContext().getExecutionEntityManager().findExecutionById(executionId);  
        ProcessDefinitionImpl processDefinition = executionEntity.getProcessDefinition();  
        ActivityImpl activity = processDefinition.findActivity(activityId); 
        if(this.vars != null){
        	activity.setVariables(vars);
        }
        executionEntity.executeActivity(activity); 
        //设置标题
        commandContext.getProcessEngineConfiguration().getRuntimeService().setProcessInstanceName(executionEntity.getProcessInstanceId(), this.title);*/
        return null;  
    }  
  
}