package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmConfOperation;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmConfOperationDao extends
HibernateDao<BpmConfOperation,Long> {
}
