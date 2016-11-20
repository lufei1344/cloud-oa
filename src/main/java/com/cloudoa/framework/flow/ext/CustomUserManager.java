package com.cloudoa.framework.flow.ext;  
import org.activiti.engine.identity.User;
import org.activiti.engine.impl.persistence.entity.UserEntity;
import org.activiti.engine.impl.persistence.entity.UserEntityManager;
import org.springframework.beans.factory.annotation.Autowired;

import com.cloudoa.framework.security.service.UserManager;  
  
public class CustomUserManager extends UserEntityManager {  
	 @Autowired
	 private UserManager userManager;

	@Override
	public User findUserById(String userId) {
		com.cloudoa.framework.security.entity.User u = userManager.get(Long.valueOf(userId));
		UserEntity au = new UserEntity();
		au.setId(u.getId().toString());
		au.setFirstName(u.getFullname());
		au.setLastName(u.getFullname());
		return au;
	}
	 
}  