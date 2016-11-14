package com.cloudoa.framework.utils;

public class MsgUtils {

	public static Msg returnError(String msg){
		return returnMsg(0,msg,null);
	}
	public static Msg returnError(String msg,Object obj){
		return returnMsg(0,msg,obj);
	}
	public static Msg returnOk(String msg){
		return returnMsg(1,msg,null);
	}
	public static Msg returnOk(String msg,Object obj){
		return returnMsg(1,msg,obj);
	}
	public static Msg returnMsg(int status,String msg,Object obj){
		Msg m = new Msg();
		m.setMsg(msg);
		m.setObj(obj);
		m.setStatus(status);
		return m;
	}
}
