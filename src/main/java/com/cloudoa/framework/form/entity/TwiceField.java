package com.cloudoa.framework.form.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 表单字段实体类
 * @author yuqs
 * @since 0.1
 */
@Entity
@Table(name = "DF_TWICEFIELD")
public class TwiceField implements Serializable {
    private static final long serialVersionUID = -1;
    private long id;
    private long formId;
    private long eleId;
    //中文名
    private String cnname;
    //英文名
    private String enname;
    //数据类型
    private String dataType;
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getFormId() {
        return formId;
    }

    public void setFormId(long formId) {
        this.formId = formId;
    }

	public String getCnname() {
		return cnname;
	}

	public void setCnname(String cnname) {
		this.cnname = cnname;
	}

	public String getEnname() {
		return enname;
	}

	public void setEnname(String enname) {
		this.enname = enname;
	}

	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}

	public long getEleId() {
		return eleId;
	}

	public void setEleId(long eleId) {
		this.eleId = eleId;
	}

	
    
}
