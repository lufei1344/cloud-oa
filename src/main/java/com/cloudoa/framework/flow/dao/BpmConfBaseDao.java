package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmConfBase;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmConfBaseDao extends HibernateDao<BpmConfBase,Long> {
}
