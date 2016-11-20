package com.cloudoa.framework.flow.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.flow.entity.BpmCategory;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

@Component
public class BpmCategoryDao extends HibernateDao<BpmCategory,Long> {
}
