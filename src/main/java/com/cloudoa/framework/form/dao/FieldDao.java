package com.cloudoa.framework.form.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.form.entity.Field;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

/**
 * 表单持久化类
 * @author yuqs
 * @since 0.1
 */
@Component
public class FieldDao extends HibernateDao<Field, Long> {
}
