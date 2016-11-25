package com.cloudoa.framework.flow.ext;  
import java.util.ArrayList;
import java.util.List;

import org.activiti.engine.identity.Group;
import org.activiti.engine.impl.persistence.entity.GroupEntityManager;

import com.cloudoa.framework.security.dao.OrgDao;
import com.cloudoa.framework.security.dao.UserDao;
import com.cloudoa.framework.security.entity.Org;  
/** 
 * 自定义的Activiti用户组管理器 
 * 
 */  
public class CustomGroupManager extends GroupEntityManager {  
	 private OrgDao orgDao;
	 private UserDao userDao;

	 
	@Override
	    public List<Group> findGroupsByUser(String userId) {

	        List<Group> groups = new ArrayList<Group>();
	        Org  org = userDao.get(Long.valueOf(userId)).getOrg();
	        if(org != null){
	        	ExtGroup groupEntity = new ExtGroup(org.getId().toString());
	            groupEntity.setName(org.getName());
	            groupEntity.setType(org.getType());
	            groupEntity.setOrg(org);
	            groups.add(groupEntity);
	        }
	        return groups;
	    }


	public OrgDao getOrgDao() {
		return orgDao;
	}


	public void setOrgDao(OrgDao orgDao) {
		this.orgDao = orgDao;
	}


	public UserDao getUserDao() {
		return userDao;
	}


	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	} 
	
	
	
}  