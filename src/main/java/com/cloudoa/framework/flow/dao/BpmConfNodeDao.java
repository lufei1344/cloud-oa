package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmConfNode;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmConfNodeDao extends HibernateDao<BpmConfNode,Long> {
}
