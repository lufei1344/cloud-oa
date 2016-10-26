package com.snakerflow.framework.form.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.snakerflow.framework.form.entity.Form;
import com.snakerflow.framework.form.service.FormManager;
import com.snakerflow.framework.orm.Page;
import com.snakerflow.framework.orm.PropertyFilter;
import com.snakerflow.framework.security.shiro.ShiroUtils;
import com.snakerflow.framework.utils.DateUtils;
import com.snakerflow.framework.utils.MsgUtils;

/**
 * 动态表单管理Controller
 * @author yuqs
 * @since 0.1
 */
@Controller
@RequestMapping(value = "/config/form")
public class FormController {
    public static final String PARA_PROCESSID = "processId";
    public static final String PARA_ORDERID = "orderId";
    public static final String PARA_TASKID = "taskId";

    @Autowired
    private FormManager formManager;

    @RequestMapping(method = RequestMethod.GET)
    public String list(Model model, Page<Form> page, HttpServletRequest request, String lookup) {
        List<PropertyFilter> filters = PropertyFilter.buildFromHttpRequest(request);
        //设置默认排序方式
        if (!page.isOrderBySetted()) {
            page.setOrderBy("id");
            page.setOrder(Page.ASC);
        }
        page = formManager.findPage(page, filters);
        model.addAttribute("page", page);
        model.addAttribute("lookup", lookup);
        return "config/formList";
    }

    @RequestMapping(value = "create", method = RequestMethod.GET)
    public String create(Model model) {
        model.addAttribute("form", new Form());
        return "config/formEdit";
    }

    @RequestMapping(value = "view/{id}", method = RequestMethod.GET)
    public String view(@PathVariable("id") Long id, Model model) {
        model.addAttribute("form", formManager.get(id));
        return "config/formView";
    }

    @RequestMapping(value = "update/{id}", method = RequestMethod.GET)
    public String edit(@PathVariable("id") Long id, Model model) {
        model.addAttribute("form", formManager.get(id));
        return "config/formEdit";
    }


    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseBody
    public Object update(Form form) {
        form.setCreator(ShiroUtils.getUsername());
        form.setCreateTime(DateUtils.getCurrentTime());
        form.setFieldNum(0);
        formManager.save(form);
        return MsgUtils.returnOk("");
    }


    @RequestMapping(value = "delete/{id}")
    public String delete(@PathVariable("id") Long id) {
    	formManager.delete(id);
        return "redirect:/config/form";
    }

   
    
}
