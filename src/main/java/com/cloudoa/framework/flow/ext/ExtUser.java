package com.cloudoa.framework.flow.ext;

import org.activiti.engine.impl.persistence.entity.UserEntity;

import com.cloudoa.framework.security.entity.User;

public class ExtUser extends UserEntity {

	private User extuser;

	public User getExtuser() {
		return extuser;
	}

	public void setExtuser(User extuser) {
		this.extuser = extuser;
	}

	
	
}
