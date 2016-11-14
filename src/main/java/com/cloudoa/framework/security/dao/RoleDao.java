package com.cloudoa.framework.security.dao;

import com.cloudoa.framework.orm.hibernate.HibernateDao;
import com.cloudoa.framework.security.entity.Role;
import org.springframework.stereotype.Component;

/**
 * 角色持久化类
 * @author yuqs
 * @since 0.1
 */
@Component
public class RoleDao extends HibernateDao<Role, Long> {

}
