package com.cloudoa.framework.form.dao;

import org.springframework.stereotype.Component;

import com.cloudoa.framework.form.entity.TwiceField;
import com.cloudoa.framework.orm.hibernate.HibernateDao;

/**
 * 表单持久化类
 * @author yuqs
 * @since 0.1
 */
@Component
public class TwiceFieldDao extends HibernateDao<TwiceField, Long> {
}
