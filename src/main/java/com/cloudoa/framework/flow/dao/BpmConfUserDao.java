package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmConfUser;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmConfUserDao extends HibernateDao<BpmConfUser,Long> {
}
