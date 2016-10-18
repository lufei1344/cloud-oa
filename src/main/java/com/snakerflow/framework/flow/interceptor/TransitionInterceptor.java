package com.snakerflow.framework.flow.interceptor;

import java.util.Iterator;

import org.snaker.engine.SnakerInterceptor;
import org.snaker.engine.core.Execution;
import org.snaker.engine.entity.Task;

public class TransitionInterceptor implements SnakerInterceptor {

	@Override
	public void intercept(Execution execution) {
		System.out.println(execution);
		if(execution.getTask() != null){
			String nextNode = (String)execution.getArgs().get("nextNode");
			if(nextNode != null && !"".equals(nextNode)){
				Iterator<Task> it = execution.getTasks().iterator();
				while(it.hasNext()){
					Task task = it.next();
					if(!task.getDisplayName().equals(nextNode)){
						it.remove();
					}
				}
				
			}
		}
	}

}
