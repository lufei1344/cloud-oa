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
@Table(name = "DF_FORM_DATA_EXPAND")
public class FormDataExpand implements Serializable {
    private static final long serialVersionUID = -1;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    private String executionId;
    private long formId;
    private long fieldId; 
    private String value; 
    private String writer;
    private java.sql.Timestamp writerTime;
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
	
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public java.sql.Timestamp getWriterTime() {
		return writerTime;
	}
	public void setWriterTime(java.sql.Timestamp writerTime) {
		this.writerTime = writerTime;
	}
    
    
    
}
