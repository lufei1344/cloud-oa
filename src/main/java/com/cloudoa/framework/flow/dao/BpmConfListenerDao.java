package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmConfListener;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmConfListenerDao extends HibernateDao<BpmConfListener,Long> {
}
