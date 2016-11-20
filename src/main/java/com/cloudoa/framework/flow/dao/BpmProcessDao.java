package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmProcess;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmProcessDao extends HibernateDao<BpmProcess,Long> {
}
