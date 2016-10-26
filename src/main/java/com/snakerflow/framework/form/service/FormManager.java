package com.snakerflow.framework.form.service;

import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import com.snakerflow.framework.flow.service.SnakerEngineFacets;
import com.snakerflow.framework.form.dao.FieldDao;
import com.snakerflow.framework.form.dao.FormDao;
import com.snakerflow.framework.form.dao.TwiceFieldDao;
import com.snakerflow.framework.form.entity.Field;
import com.snakerflow.framework.form.entity.Form;
import com.snakerflow.framework.form.entity.TwiceField;
import com.snakerflow.framework.orm.Page;
import com.snakerflow.framework.orm.PropertyFilter;

/**
 * 动态表单管理类
 * @author yuqs
 * @since 0.1
 */
@Component
public class FormManager {
    private static final String TABLE_PREFIX = "TBL_";
    @Autowired
    private SnakerEngineFacets facets;
    @Autowired
    private FormDao formDao;
   
    @Autowired
    private FieldDao fieldDao;
    
    @Autowired
    private TwiceFieldDao twiceFieldDao;
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void save(Form value) {
        formDao.save(value);
        long nid = Long.valueOf(value.getId());
		if("form".equals(value.getType())){
			//解析html
			String eids = "";
			if(value.getContentHtml() != null){
				Document doc = Jsoup.parse(value.getContentHtml());
				//input
				Elements inputs =  doc.getElementsByTag("input");
				for(Element  e : inputs){
					if(e.attr("cnname") != null){
						if(e.attr("enname") == null || "".equals(e.attr("enname"))){
							continue;
						}
						eids += "'"+e.attr("enname")+"',";
						Field b = fieldDao.findUnique("from Field where form_id=? and enname=?", new Object[]{nid,e.attr("enname")});
						if(b == null){
							b = new Field();
						}
						b.setFormId(nid);
						b.setCnname(e.attr("cnname"));
						b.setEnname(e.attr("enname"));
						b.setDataType("".equals(e.attr("datatype")) || e.attr("datatype") == null ? "char" : e.attr("datatype"));
						b.setShowType("".equals(e.attr("showtype")) ? "text" : e.attr("showtype"));
						b.setValidate(e.attr("validate"));
						b.setSelectRule(e.attr("selectrule"));
						b.setOtherValue(e.attr("othervalue"));
						b.setOtherRead(e.attr("otherread"));
						b.setOtherInput(e.attr("otherinput"));
						b.setDefaultValue(e.attr("defaultvalue"));
						b.setAuto(e.attr("auto"));
						b.setAutoPrev(e.attr("autoprev"));
						fieldDao.save(b);
					}
				}
				//select
				inputs =  doc.getElementsByTag("select");
				for(Element  e : inputs){
					if(e.attr("cnname") != null){
						if(e.attr("enname") == null || "".equals(e.attr("enname"))){
							continue;
						}
						eids += "'"+e.attr("elementid")+"',";
						Field b = fieldDao.findUnique("from Field where form_id=? and enname=?", new Object[]{nid,e.attr("enname")});
						if(b == null){
							b = new Field();
						}
						b.setFormId(nid);
						b.setCnname(e.attr("cnname"));
						b.setEnname(e.attr("enname"));
						b.setDataType("".equals(e.attr("datatype")) || e.attr("datatype") == null ? "char" : e.attr("datatype"));
						b.setShowType("select");
						b.setValidate(e.attr("validate"));
						b.setSelectRule(e.attr("selectrule"));
						b.setOtherValue(e.attr("othervalue"));
						b.setOtherRead(e.attr("otherread"));
						b.setOtherInput(e.attr("otherinput"));
						b.setDefaultValue(e.attr("defaultvalue"));
						b.setAuto(e.attr("auto"));
						b.setAutoPrev(e.attr("autoprev"));
						fieldDao.save(b);
					}
				}
				//textarea
				inputs =  doc.getElementsByTag("textarea");
				for(Element  e : inputs){
					if(e.attr("cnname") != null){
						if(e.attr("enname") == null || "".equals(e.attr("enname"))){
							continue;
						}
						eids += "'"+e.attr("elementid")+"',";
						Field b = fieldDao.findUnique("from Field where form_id=? and enname=?", new Object[]{nid,e.attr("enname")});
						if(b == null){
							b = new Field();
						}
						b.setFormId(nid);
						b.setCnname(e.attr("cnname"));
						b.setEnname(e.attr("enname"));
						b.setDataType("".equals(e.attr("datatype")) || e.attr("datatype") == null ? "char" : e.attr("datatype"));
						b.setShowType("textarea");
						b.setValidate(e.attr("validate"));
						b.setSelectRule(e.attr("selectrule"));
						b.setOtherValue(e.attr("othervalue"));
						b.setOtherRead(e.attr("otherread"));
						b.setOtherInput(e.attr("otherinput"));
						b.setDefaultValue(e.attr("defaultvalue"));
						b.setAuto(e.attr("auto"));
						b.setAutoPrev(e.attr("autoprev"));
						fieldDao.save(b);
					}
				}
				//删除没有的元素
				jdbcTemplate.execute("delete from df_field  where form_id="+nid+" and enname not in ("+eids+"'-1')");
			
				//二维表
				inputs =  doc.getElementsByTag("table");
				int i=0;
				eids = "";
				for(Element e : inputs){
					String c = e.attr("class");
					if(c != null && "twice".equals(c)){
						Elements tr = e.getElementsByTag("tr");
						if(tr.size()>0){
							Elements td = tr.get(0).getElementsByTag("td");
							for(Element d : td){
								eids += "'"+d.attr("id")+"',";
								TwiceField b = twiceFieldDao.findUnique("from TwiceField where form_id=? and enname=?", new Object[]{nid,e.attr("enname")});
								if(b == null){
									b = new TwiceField();
								}
								b.setFormId(nid);
								b.setCnname(d.text());
								b.setEnname(d.attr("id"));
								b.setDataType(d.attr("datatype"));
								b.setEleId(i);
								twiceFieldDao.save(b);
							}
						}
					}
					i++;
				}
				jdbcTemplate.execute("delete from df_twicefield  where form_id="+nid+" and enname not in ("+eids+"'-1')");
			}
			
			
		}
    }

  
    public Form get(Long id) {
        Form form = formDao.get(id);
        form.setFields(fieldDao.findBy("formId", form.getId()));
        return form;
    }

  
    public void delete(Long id) {
        formDao.delete(id);
        jdbcTemplate.execute("delete from df_field where form_Id="+id);
        jdbcTemplate.execute("delete from df_twicefield where form_Id="+id);
    }
    public Page<Form> findPage(final Page<Form> page, final List<PropertyFilter> filters) {
        return formDao.findPage(page, filters);
    }

   

    
    /*
    public void submit(long formId, List<Field> fields, Map<String, Object> params,
                       HttpServletRequest request, String processId, String orderId, String taskId) {
        if(StringUtils.isNotEmpty(processId)) {
            if (StringUtils.isEmpty(orderId) && StringUtils.isEmpty(taskId)) {
                orderId = facets.startAndExecute(processId, ShiroUtils.getUsername(), params).getId();
            } else {
                int method = 0;
                String methodStr = request.getParameter("method");
                if(StringUtils.isNotEmpty(methodStr)) {
                    method = Integer.parseInt(methodStr);
                }
                String nextOperator = request.getParameter("nextOperator");
                switch(method) {
                    case 0://任务执行
                        facets.execute(taskId, ShiroUtils.getUsername(), params);
                        break;
                    case -1://驳回、任意跳转
                        facets.executeAndJump(taskId, ShiroUtils.getUsername(), params, request.getParameter("nodeName"));
                        break;
                    case 1://转办
                        if(StringUtils.isNotEmpty(nextOperator)) {
                            facets.transferMajor(taskId, ShiroUtils.getUsername(), nextOperator.split(","));
                        }
                        break;
                    case 2://协办
                        if(StringUtils.isNotEmpty(nextOperator)) {
                            facets.transferAidant(taskId, ShiroUtils.getUsername(), nextOperator.split(","));
                        }
                        break;
                    default:
                        facets.execute(taskId, ShiroUtils.getUsername(), params);
                        break;
                }
            }
        }
        Form entity = get(formId);
        String tableName = getTableName(entity);
        StringBuilder beforeSql = new StringBuilder();
        StringBuilder afterSql = new StringBuilder();
        beforeSql.append("INSERT INTO ").append(tableName);
        beforeSql.append(" (FORMID, UPDATETIME, ORDERID, TASKID ");
        afterSql.append(") values (?,?,?,?");
        List<Object> datas = new ArrayList<Object>();
        datas.add(entity.getId());
        datas.add(DateUtils.getCurrentTime());
        datas.add(orderId);
        datas.add(taskId);
        if(fields != null) {
            StringBuilder fieldSql = new StringBuilder();
            StringBuilder valueSql = new StringBuilder();
            Map<String, String[]> paraMap = request.getParameterMap();
            for(Field field : fields) {
                String[] data = paraMap.get(field.getName());
                if(data == null) {
                    continue;
                }
                fieldSql.append(",").append(field.getName());
                valueSql.append(",?");
                if(data.length == 1) {
                    datas.add(data[0]);
                } else {
                    String dataArr = ArrayUtils.toString(data);
                    if(dataArr.length() > 1) {
                        datas.add(dataArr.substring(1, dataArr.length() - 1));
                    }
                }
            }
            if(fieldSql.length() > 0) {
                beforeSql.append(fieldSql.toString());
                afterSql.append(valueSql.toString());
            }
        }
        afterSql.append(")");
        beforeSql.append(afterSql.toString());
        String sql = beforeSql.toString();
        jdbcTemplate.update(sql, datas.toArray());
    }
*/
   

   

    
}
