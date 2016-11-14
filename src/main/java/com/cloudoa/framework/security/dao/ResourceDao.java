package com.cloudoa.framework.security.dao;

import com.cloudoa.framework.orm.hibernate.HibernateDao;
import com.cloudoa.framework.security.entity.Resource;
import org.springframework.stereotype.Component;

/**
 * 资源持久化类
 * @author yuqs
 * @since 0.1
 */
@Component
public class ResourceDao extends HibernateDao<Resource, Long> {

}
