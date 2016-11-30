package com.cloudoa.framework.form.web;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.cloudoa.framework.form.entity.AutoPrev;
import com.cloudoa.framework.form.entity.Form;
import com.cloudoa.framework.form.service.FormService;
import com.cloudoa.framework.orm.Page;
import com.cloudoa.framework.orm.PropertyFilter;
import com.cloudoa.framework.security.shiro.ShiroUtils;
import com.cloudoa.framework.utils.DbConn;
import com.cloudoa.framework.utils.MsgUtils;

/**
 * 动态表单管理Controller
 * @author yuqs
 * @since 0.1
 */
@Controller
@RequestMapping(value = "/form")
public class FormController {
	private static Logger logger = Logger.getLogger(FormController.class);
    public static final String PARA_PROCESSID = "processId";
    public static final String PARA_ORDERID = "orderId";
    public static final String PARA_TASKID = "taskId";

    @Autowired
    private FormService formService;
    @Autowired
    private DbConn db;
    

    @RequestMapping(value = "list",method = RequestMethod.GET)
    public String list(Model model, Page<Form> page, HttpServletRequest request, String lookup) {
        List<PropertyFilter> filters = PropertyFilter.buildFromHttpRequest(request);
        //设置默认排序方式
        if (!page.isOrderBySetted()) {
            page.setOrderBy("id");
            page.setOrder(Page.ASC);
        }
        page = formService.findPage(page, filters);
        model.addAttribute("page", page);
        model.addAttribute("lookup", lookup);
        return "form/formList";
    }

    @RequestMapping(value = "create", method = RequestMethod.GET)
    public String create(Model model) {
        model.addAttribute("form", new Form());
        return "form/formEdit";
    }

    @RequestMapping(value = "view/{id}", method = RequestMethod.GET)
    public String view(@PathVariable("id") Long id, Model model) {
        model.addAttribute("form", formService.get(id));
        return "form/formView";
    }
   
    @RequestMapping(value = "update/{id}", method = RequestMethod.GET)
    public String edit(@PathVariable("id") Long id, Model model) {
        model.addAttribute("form", formService.get(id));
        return "form/formEdit";
    }


    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(Form form) {
        form.setCreator(ShiroUtils.getUsername());
        form.setCreateTime(null);
        form.setFieldNum(0);
        formService.save(form);
        return MsgUtils.returnOk("");
    }


    @RequestMapping(value = "delete/{id}")
    public String delete(@PathVariable("id") Long id) {
    	formService.delete(id);
        return "redirect:/form/list";
    }

    @RequestMapping(value = "findForm")
    @ResponseBody
    public Object findForm(Long formType, Model model) {
    	List<PropertyFilter> filters = new ArrayList<PropertyFilter>();
    	PropertyFilter f = new PropertyFilter("EQS_formType", formType.toString());
    	filters.add(f);
        return MsgUtils.returnOk("",formService.find(filters));
    }
    @RequestMapping(value = "findFormField")
    @ResponseBody
    public Object findFormField(Long formid, Model model) {
    	Form f = formService.get(formid);
    	return MsgUtils.returnOk("",f.getFields());
    }
    @RequestMapping(value = "parseSql")
    @ResponseBody
    public Object parseSql(String sql) {
        return MsgUtils.returnOk("",formService.parseSql(sql));
    }
    @RequestMapping(value = "findAutoPrev")
    @ResponseBody
    public Object findAutoPrev() {
    	JSONObject jobj = new JSONObject();
    	jobj.put("auto", formService.findAutoPrev());
    	jobj.put("depart", formService.findAllOrg());
    	return jobj.toString();
    }
    @RequestMapping(value = "saveAutoPrev")
    @ResponseBody
    public Object saveAutoPrev(AutoPrev prev) {
    	prev = formService.saveAutoPrev(prev);
    	return MsgUtils.returnOk("",prev);
    }
    /**
     * 删除自增序列
     * @param id
     * @return
     */
    @RequestMapping(value = "deleteAutoPrev")
    @ResponseBody
    public Object delAutoPrev(Long id) {
    	formService.deleteAutoPrev(id);
    	return MsgUtils.returnOk("");
    }
    /**
     * 流程表单打开
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "views", method = RequestMethod.GET)
    @ResponseBody
    public Object views(Model model,HttpServletRequest request) {
    	String formsid = request.getParameter("forms");
    	String executionId = request.getParameter("executionId");
    	List<Form> forms = new ArrayList<Form>();
    	if(formsid != ""){
    		String[] ids = formsid.split(",");
    		for(String id : ids){
    			forms.add(formService.get(Long.valueOf(id),executionId));
    		}
    	}
    	//model.addAttribute("forms", forms);
    	//return "form/views";
    	Map<String,Object> obj = new HashMap<String,Object>();
    	obj.put("forms", forms);
    	obj.put("user", ShiroUtils.getUser());
    	return JSONObject.toJSONString(MsgUtils.returnOk("",obj));
    }
    /**
     * 查询sql语句数据
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "findSqlData")
    @ResponseBody
    public Object findSqlData(Model model,HttpServletRequest request) {
    	String sql = request.getParameter("sql");
    	List<Map<String,Object>> list = null;
    	if(sql != null && !"".equals(sql)){
    		list = db.getList(sql, null);
    	}
    	return JSONObject.toJSONString(MsgUtils.returnOk("",list));
    }
    /**
     * 查询字典数据
     * @param model
     * @param request
     * @return
     */
    @RequestMapping(value = "findDictData")
    @ResponseBody
    public Object findDictData(Model model,HttpServletRequest request) {
    	String name = request.getParameter("name");
    	List<Map<String,Object>> list = null;
    	if(name != null && !"".equals(name)){
    		String sql = "select code as value,name from conf_dictitem where dictionary=(select id from conf_dictionary where cn_name='"+name+"')";
    		list = db.getList(sql, null);
    	}
    	return JSONObject.toJSONString(MsgUtils.returnOk("",list));
    }
    
    /**
	 * 保存表单数据
	 * @param request 
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/saveFormData")
	public String saveFormData(HttpServletRequest request,HttpServletResponse response){
		JSONObject result = new JSONObject();
		try{
			String ids = request.getParameter("forms");//表单
			String executionId = request.getParameter("executionId");//实例
			String userid = ShiroUtils.getUserId().toString();
			String fields = request.getParameter("fields"); //可以编辑元素
			Map<String,List<String>> files = this.update(request, "upload");
			if(ids != null && !"".equals(ids)){
				//表单
				List<Form> forms = new ArrayList<Form>();
				if(ids != null && !"".equals(ids)){
					String[] id = ids.split(",");
					for(int i=0; i<id.length; i++){
						forms.add(formService.get(Long.valueOf(id[i])));
					}
				}
				//
				List<String> sqls = new ArrayList<String>();
				List<String> uids = new ArrayList<String>();
				
				String sql = "insert into df_form_DATA(execution_id,form_id,field_id,char_value,num_value,date_value,writer)values(?,?,?,?,?,?,?)";
				List<List<Object>> params = new ArrayList<List<Object>>();
				String[] vals;
				if(fields != null && !"".equals(fields)){//只删除可以编辑的，保存只保存可以编辑的数据，否则所有数据
					sqls.add("delete from df_form_data where form_id in ("+ids+") and execution_id="+executionId+" and field_id in ("+fields+")");
				}else{
					sqls.add("delete from df_form_data where form_id in ("+ids+") and execution_id="+executionId);
				}
				for(int i=0; i<forms.size(); i++){
					for(int j=0; j<forms.get(i).getFields().size(); j++){
						if(!fields.contains(String.valueOf(forms.get(i).getFields().get(j).getId()))){//只读跳过
							continue;
						}
						String val = "";
						if("checkbox".equals(forms.get(i).getFields().get(j).getShowType())){
							String[] vs = request.getParameterValues(forms.get(i).getFields().get(j).getEnname());
							if(vs!=null && vs.length>0){
								for(int nn=0; nn<vs.length; nn++){
									if(nn == 0){
										val +=vs[nn];
									}else{
										val += ","+vs[nn];	
									}
								}
							}
						}else{
							val = request.getParameter(forms.get(i).getFields().get(j).getEnname());
						}
						List<Object> p = new ArrayList<Object>();
						p.add(executionId);
						p.add(forms.get(i).getId());
						p.add(forms.get(i).getFields().get(j).getId());
						if("char".equals(forms.get(i).getFields().get(j).getDataType())){
							//文件
							if("file".equals(forms.get(i).getFields().get(j).getExtType())){
								List<String> f = files.get(forms.get(i).getFields().get(j).getEnname());
								if(f != null && f.size()>0){
									StringBuffer s = new StringBuffer();
									for(int fi=0; fi<f.size(); fi++){
										s.append(f.get(fi));
										s.append(",");
									}
									val =  s.toString().substring(0,s.toString().length()-1);
								}else{
									val = request.getParameter("file_"+forms.get(i).getFields().get(j).getEnname());
								}
							}
							//人员,部门
							if("user".equals(forms.get(i).getFields().get(j).getExtType())||
									"dept".equals(forms.get(i).getFields().get(j).getExtType())
							){
								uids.add(forms.get(i).getFields().get(j).getEnname()+"_ids"+"#"+forms.get(i).getFields().get(j).getId());
								
							}
							p.add(val);
							p.add(null);
							p.add(null);
							p.add(userid);
						}
						if("num".equals(forms.get(i).getFields().get(j).getDataType())){
							p.add(null);
							if(val != null && !"".equals(val)){
								p.add(Double.valueOf(val));
							}else{
								p.add(null);
							}
							p.add(null);
							p.add(userid);
						}
						if("date".equals(forms.get(i).getFields().get(j).getDataType())){
							SimpleDateFormat formatter = new SimpleDateFormat(forms.get(i).getFields().get(j).getDateFormat());
							p.add(null);
							p.add(null);
							if("".equals(forms.get(i).getFields().get(j).getDateFormat()) || "".equals(val) ){
								p.add(null);								
							}else{
								p.add(new java.sql.Timestamp(formatter.parse(val).getTime()));
							}
							p.add(userid);
						}
						if("text".equals(forms.get(i).getFields().get(j).getDataType())){
							p.add(val);
							p.add(null);
							p.add(null);
							p.add(userid);
						}
						
						params.add(p);
					}
					/*//二维表
					if(forms.get(i).getf!=null && forms.get(i).getTwiceFormatElement().size()>0){
						for(int v=0; v<forms.get(i).getTwiceFormatElement().size(); v++){
							vals = request.getParameterValues("twice_"+forms.get(i).getTwiceFormatElement().get(v).getWe_English_Name());
							if(vals != null && vals.length>0){
								for(int n=0; n<vals.length; n++){
									List<Object> p = new ArrayList<Object>();
									p.add(exampleId);
									p.add(forms.get(i).getId());
									p.add(forms.get(i).getTwiceFormatElement().get(v).getId());
									p.add(vals[n]);
									p.add(null);
									p.add(null);
									p.add(null);
									p.add(userid);
									params.add(p);
								}
							}
							
						}
					}*/
				}
				sqls.add(sql);
				
				//会签数据
				String mutiEles = request.getParameter("mutiElesName");
				String mutiElesId = request.getParameter("mutiElesId");
				String acdo = request.getParameter("acdo");//下一步还是保存，空保存,sub下一步
				if(mutiEles != null && !"".equals(mutiEles)){
					if(acdo == null || "".equals(acdo)){
						acdo = "save";
					}
					String[] els = mutiEles.split(",");
					String[] eids = mutiElesId.split(",");
					for(int i=0; i<els.length; i++){
						if(!fields.contains(eids[i])){//只读跳过
							continue;
						}
						//只操作自己的意见
						sqls.add("delete from df_form_data_expand where execution_id="+executionId+" and field_id="+eids[i]+" and writer='"+userid+"'");
						String[] writer = request.getParameterValues("signwriter_"+els[i]);
						String[] value = request.getParameterValues("sign_"+els[i]);
						String[] date = request.getParameterValues("signdate_"+els[i]);
						for(int j=0; j<writer.length; j++){
							if(!"".equals(value[j]) && userid.equals(writer[j])){
								sqls.add("insert into df_form_data_expand(execution_id,field_id,writer,value,writetime,opertype)values("+executionId+","+eids[i]+",'"+writer[j]+"','"+value[j]+"','"+date[j]+"','"+acdo+"')");
							}
							
						}
					}
					
				}
				//人员
				if(uids.size()>0){
					for(int i=0; i<uids.size(); i++){
						String[] tkey = uids.get(i).split("#");
						String v = request.getParameter(tkey[0]);
						if(v != null && !"".equals(v)){
							String[] vids = v.split(",");
							sqls.add("delete from df_form_data_expand where example_id="+executionId+" and element_id="+tkey[1]);
							for(int j=0; j<vids.length; j++){
								if(!"".equals(vids[j])){
									sqls.add("insert into td_example_data_expand(example_id,element_id,writer,value)values("+executionId+","+tkey[1]+",'','"+vids[j]+"')");
								}
								
							}
						}
					}
				}
				
				if(db.execUpdates(sqls,1, params)){
					
					result.put("status", true);
				}else{
					result.put("status", false);
					result.put("msg", "数据错误");
				}
			}else{
				result.put("status", false);
				result.put("msg", "参数错误");
			}
			request.setAttribute("msg", result.toString());
			return "form/callback";
		}catch(Exception e){
			logger.error(e.getMessage(),e);
			result.put("status", false);
			result.put("msg", e.getMessage());
			request.setAttribute("msg", result.toString());
			return "form/callback";
		}
	}
	
	
	@RequestMapping(value = "/uploadFormFile")	
	public String uploadFile(HttpServletRequest request,HttpServletResponse response){
		try {
			JSONObject jobj = (JSONObject) JSONObject.toJSON(this.update(request, "upload"));
			String callback = request.getParameter("callback");
			if("1".equals(callback)){
				request.setAttribute("msg", jobj.toString());
				return "form/callback";
			}else{
				response.setCharacterEncoding("UTF-8");
				PrintWriter out;
				out = response.getWriter();
				out.print(jobj.toString());
				out.flush();
				return null;
			}
			
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			return "error";
		}
	}
	
	
	//会签数据
	@RequestMapping(value = "/findJoinSignData")	
	public String findJoinSignData(HttpServletRequest request,HttpServletResponse response){
		try {
			String eid = request.getParameter("eid");
			String exid = request.getParameter("exid");
			String sql = "select a.id,a.value,a.writer,b.username,convert(varchar, a.writetime, 120) writetime,opertype from td_example_data_expand a,tab_userinfo b,Tab_Department c,Tab_HasUserDepartPos d  where a.writer=b.userid and b.userid=d.UserId and c.Id=d.DepartId and a.element_id="+eid+" and example_id="+exid+" order by c.showorder,b.ShowOrder,a.writetime ";
			List<Map<String,Object>> list = db.getList(sql, null);
			
			JSONArray jarr = new JSONArray();
			jarr.addAll(list);
			response.setCharacterEncoding("UTF-8");
			PrintWriter out;
			out = response.getWriter();
			out.print(jarr.toJSONString());
			out.flush();
			return null;
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			return "error";
		}
	}
	
	//删除上传文件
	@RequestMapping(value = "/delUploadFile")	
	public String delUploadFile(HttpServletRequest request,HttpServletResponse response){
		try {
			String file = request.getParameter("file");
			response.setCharacterEncoding("UTF-8");
			JSONObject jobj = new JSONObject();
			File f = new File(request.getSession(true).getServletContext().getRealPath("/")+file);
			if(f.exists()){
				f.delete();
			}
			jobj.put("result", true);
			PrintWriter out;
			out = response.getWriter();
			out.print(jobj.toJSONString());
			out.flush();
			return null;
		} catch (IOException e) {
			logger.error(e.getMessage(),e);
			return "error";
		}
	}
	
	
	
	
	//文件上传
	private Map<String,List<String>> update(HttpServletRequest request,String path){
		Map<String,List<String>> files = new HashMap<String,List<String>>(); 
		try{
			String date = new SimpleDateFormat("yyyyMM").format(new Date());
			path = path+"/"+date;
			File f = new File(request.getSession(true).getServletContext().getRealPath("/")+path);
			if(!f.exists()){
				f.mkdirs();
			}
			CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());  
	        //判断 request 是否有文件上传,即多部分请求  
	        if(multipartResolver.isMultipart(request)){  
	            //转换成多部分request    
	            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest)request;  
	            //取得request中的所有文件名  
	            Iterator<String> iter = multiRequest.getFileNames();
	            int i = 0;
	            while(iter.hasNext()){  
	                  
	                //取得上传文件  
	                MultipartFile file = multiRequest.getFile(iter.next());
	                if(file != null){  
	                    //取得当前上传文件的文件名称  
	                    String myFileName = file.getOriginalFilename();  
	                    //如果名称不为“”,说明该文件存在，否则说明该文件不存在  
	                    if(myFileName.trim() !=""){
	                    	String[] ext = file.getOriginalFilename().split("\\.");
		                	String filepath = path+"/"+System.currentTimeMillis()+(++i)+"."+ext[ext.length-1];
		                	if(files.get(file.getName()) == null){
		                		files.put(file.getName(), new ArrayList<String>());
		                	}
		                	//添加文件上传人员
		                	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		                	files.get(file.getName()).add(myFileName+":"+filepath+":"+(ShiroUtils.getOrgName()==null ? "" : ShiroUtils.getOrgName())+"_"+ShiroUtils.getFullname()+"_"+df.format(new Date()));
	                        //定义上传路径  
	                        file.transferTo(new File(request.getSession(true).getServletContext().getRealPath("/")+filepath));  
	                       
	                    }  
	                }  
	                  
	            }  
	              
	        }  
		}catch(Exception e){
			e.printStackTrace();
		}
		
        return files;
	}


}
