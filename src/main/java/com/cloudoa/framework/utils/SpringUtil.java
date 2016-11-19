package com.cloudoa.framework.utils;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.support.ClassPathXmlApplicationContext;


/**
 * 获得Spring的信息的工具类。
 */
public class SpringUtil implements ApplicationContextAware{

	private static ApplicationContext applicationContext;

	static{
		applicationContext = new ClassPathXmlApplicationContext("applicationContext.xml");
	}
	
	
	/**
	 * 实现ApplicationContextAware接口的context注入函数, 将其存入静态变量.
	 */
	public void setApplicationContext(ApplicationContext context) {
		applicationContext = context;
	}

	/**
	 * 取得存储在静态变量中的ApplicationContext.
	 */
	public static ApplicationContext getApplicationContext() {
		if (applicationContext == null)
			throw new IllegalStateException(
					"applicaitonContext未注入,请在applicationContext.xml中定义SpringUtil");
		return applicationContext;
	}

	/**
	 * 从静态变量ApplicationContext中取得Bean, 自动转型为所赋值对象的类型.
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getBean(String name) {
		return (T) applicationContext.getBean(name);
	}
}
