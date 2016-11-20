package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmInstance;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmInstanceDao extends HibernateDao<BpmInstance,Long> {
}
