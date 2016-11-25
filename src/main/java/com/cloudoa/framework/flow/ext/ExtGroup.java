package com.cloudoa.framework.flow.ext;

import org.activiti.engine.impl.persistence.entity.GroupEntity;

import com.cloudoa.framework.security.entity.Org;

public class ExtGroup extends GroupEntity{
	
	private Org org;

	public ExtGroup() {
		super();
	}

	public ExtGroup(String id) {
		super(id);
	}

	public Org getOrg() {
		return org;
	}

	public void setOrg(Org org) {
		this.org = org;
	}
	
}
