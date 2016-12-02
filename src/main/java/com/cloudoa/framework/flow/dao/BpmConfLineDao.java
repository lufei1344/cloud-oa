package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmConfLine;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmConfLineDao extends HibernateDao<BpmConfLine,Long> {
}
