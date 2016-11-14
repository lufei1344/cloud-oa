package com.cloudoa.framework.form.dao;

import com.cloudoa.framework.form.entity.Form;
import com.cloudoa.framework.orm.hibernate.HibernateDao;
import org.springframework.stereotype.Component;

/**
 * 表单持久化类
 * @author yuqs
 * @since 0.1
 */
@Component
public class FormDao extends HibernateDao<Form, Long> {
}
