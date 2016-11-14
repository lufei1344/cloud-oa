package com.cloudoa.framework.security.dao;

import com.cloudoa.framework.orm.hibernate.HibernateDao;
import com.cloudoa.framework.security.entity.Org;
import org.springframework.stereotype.Component;

/**
 * 部门持久化类
 * @author yuqs
 * @since 0.1
 */
@Component
public class OrgDao extends HibernateDao<Org, Long> {

}
