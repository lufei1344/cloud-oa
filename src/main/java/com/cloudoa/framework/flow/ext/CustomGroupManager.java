package com.cloudoa.framework.flow.ext;  
import java.util.ArrayList;
import java.util.List;

import org.activiti.engine.identity.Group;
import org.activiti.engine.impl.persistence.entity.GroupEntity;
import org.activiti.engine.impl.persistence.entity.GroupEntityManager;
import org.springframework.beans.factory.annotation.Autowired;

import com.cloudoa.framework.security.entity.Org;
import com.cloudoa.framework.security.service.OrgManager;
import com.cloudoa.framework.security.service.UserManager;  
/** 
 * 自定义的Activiti用户组管理器 
 * 
 */  
public class CustomGroupManager extends GroupEntityManager {  
	 @Autowired
	 private OrgManager orgManager;
	 @Autowired
	 private UserManager userManager;

	 @Override
	    public List<Group> findGroupsByUser(String userId) {

	        List<Group> groups = new ArrayList<Group>();
	        Org  org = userManager.get(Long.valueOf(userId)).getOrg();
	        GroupEntity groupEntity = new GroupEntity(org.getId().toString());
            groupEntity.setName(org.getName());
            groupEntity.setType(org.getType());
            groups.add(groupEntity);

	        return groups;
	    } 
}  