package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmMailTemplate;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmMailTemplateDao extends HibernateDao<BpmMailTemplate,Long> {
}
