package com.cloudoa.framework.security.dao;

import com.cloudoa.framework.orm.hibernate.HibernateDao;
import com.cloudoa.framework.security.entity.User;
import org.springframework.stereotype.Component;

/**
 * 用户持久化类
 * @author yuqs
 * @since 0.1
 */
@Component
public class UserDao extends HibernateDao<User, Long> {

}
