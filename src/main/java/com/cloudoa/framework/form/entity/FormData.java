package com.cloudoa.framework.form.entity;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

/**
 * 表单数据
 * @author yuqs
 * @since 0.1
 */
@Entity
@Table(name = "DF_FORM_DATA")
public class FormData implements Serializable {
    private static final long serialVersionUID = -1;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    private String executionId;
    private long formId;
    private long fieldId; 
    private String charValue; 
    private String numValue;
    private java.sql.Timestamp dateValue;
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getExecutionId() {
		return executionId;
	}
	public void setExecutionId(String executionId) {
		this.executionId = executionId;
	}
	public long getFormId() {
		return formId;
	}
	public void setFormId(long formId) {
		this.formId = formId;
	}
	public long getFieldId() {
		return fieldId;
	}
	public void setFieldId(long fieldId) {
		this.fieldId = fieldId;
	}
	public String getCharValue() {
		return charValue;
	}
	public void setCharValue(String charValue) {
		this.charValue = charValue;
	}
	public String getNumValue() {
		return numValue;
	}
	public void setNumValue(String numValue) {
		this.numValue = numValue;
	}
	public java.sql.Timestamp getDateValue() {
		return dateValue;
	}
	public void setDateValue(java.sql.Timestamp dateValue) {
		this.dateValue = dateValue;
	}
    
    
    
}
