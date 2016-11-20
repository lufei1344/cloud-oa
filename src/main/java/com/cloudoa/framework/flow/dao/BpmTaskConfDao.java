package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmTaskConf;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmTaskConfDao extends HibernateDao<BpmTaskConf,Long> {
}
