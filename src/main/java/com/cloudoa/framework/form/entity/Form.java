package com.cloudoa.framework.form.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;
import javax.persistence.Transient;

/**
 * 表单实体类
 * @author yuqs
 * @since 0.1
 */
@Entity
@Table(name = "DF_FORM")
public class Form implements Serializable {
    private static final long serialVersionUID = -1;
    private long id;
    private String name;
    private String displayName;
    private String type; //表单类别,html或doc
    private String formType; //字典formType
    private String creator;
    private String createTime;
    private String contentHtml;
    private String showTitle;  //显示标题
    private int fieldNum = 0;
    
    private List<Field> fields;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    @Lob
    public String getContentHtml() {
		return contentHtml;
	}
    
	public void setContentHtml(String contentHtml) {
		this.contentHtml = contentHtml;
	}

	

    public int getFieldNum() {
        return fieldNum;
    }

    public void setFieldNum(int fieldNum) {
        this.fieldNum = fieldNum;
    }
    @Transient
	public List<Field> getFields() {
		return fields;
	}

	public void setFields(List<Field> fields) {
		this.fields = fields;
	}

	public String getFormType() {
		return formType;
	}

	public void setFormType(String formType) {
		this.formType = formType;
	}

	public String getShowTitle() {
		return showTitle;
	}

	public void setShowTitle(String showTitle) {
		this.showTitle = showTitle;
	}
    
}
