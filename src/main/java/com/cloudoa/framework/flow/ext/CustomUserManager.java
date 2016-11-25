package com.cloudoa.framework.flow.ext;  
import org.activiti.engine.identity.User;
import org.activiti.engine.impl.persistence.entity.UserEntity;
import org.activiti.engine.impl.persistence.entity.UserEntityManager;

import com.cloudoa.framework.security.dao.UserDao;  
  
public class CustomUserManager extends UserEntityManager {  
	 private UserDao userDao;
	public UserDao getUserDao() {
		return userDao;
	}

	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}

	@Override
	public UserEntity findUserById(String userId) {
		com.cloudoa.framework.security.entity.User u = userDao.get(Long.valueOf(userId));
		if(u != null){
			ExtUser au = new ExtUser();
			au.setId(u.getId().toString());
			au.setFirstName(u.getFullname());
			au.setLastName(u.getFullname());
			au.setExtuser(u);
			return au;
		}else{
			return null;
		}
		
	}
	 
}  