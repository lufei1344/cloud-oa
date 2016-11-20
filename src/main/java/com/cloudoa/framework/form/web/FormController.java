package com.cloudoa.framework.form.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cloudoa.framework.form.entity.AutoPrev;
import com.cloudoa.framework.form.entity.Form;
import com.cloudoa.framework.form.service.FormService;
import com.cloudoa.framework.orm.Page;
import com.cloudoa.framework.orm.PropertyFilter;
import com.cloudoa.framework.security.shiro.ShiroUtils;
import com.cloudoa.framework.utils.DateUtils;
import com.cloudoa.framework.utils.MsgUtils;

/**
 * 动态表单管理Controller
 * @author yuqs
 * @since 0.1
 */
@Controller
@RequestMapping(value = "/form")
public class FormController {
    public static final String PARA_PROCESSID = "processId";
    public static final String PARA_ORDERID = "orderId";
    public static final String PARA_TASKID = "taskId";

    @Autowired
    private FormService formService;
    

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
        form.setCreateTime(DateUtils.getCurrentTime());
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
    @RequestMapping(value = "deleteAutoPrev")
    @ResponseBody
    public Object delAutoPrev(Long id) {
    	formService.deleteAutoPrev(id);
    	return MsgUtils.returnOk("");
    }

}
