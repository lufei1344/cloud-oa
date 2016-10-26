package com.snakerflow.framework.form.dao;

import org.springframework.stereotype.Component;

import com.snakerflow.framework.form.entity.Field;
import com.snakerflow.framework.orm.hibernate.HibernateDao;

/**
 * 表单持久化类
 * @author yuqs
 * @since 0.1
 */
@Component
public class FieldDao extends HibernateDao<Field, Long> {
}
