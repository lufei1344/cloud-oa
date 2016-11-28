package com.cloudoa.framework.form.entity;

import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * 表单字段实体类
 * @author yuqs
 * @since 0.1
 */
@Entity
@Table(name = "DF_FIELD")
public class Field implements Serializable {
    private static final long serialVersionUID = -1;
    public static final String FLOW = "1";
    private long id;
    private long formId;
    //中文名
    private String cnname;
    //英文名
    private String enname;
    //数据类型
    private String dataType;
    //显示类型
    private String showType;
    //扩展类型(input:(input,user,dept),textarea:(textarea,signtext,jointext))
    private String extType;
    //显示列头
    private String showTitle;
    //自动取号
    private String autoType;
    //是否自动序号
    private String auto;
    //自动序号前缀
    private String autoPrev;
    //校验规则
    private String validate;
    //输入选择
    @Column(length=4000)
    private String selectRule;
    //默认值
    @Column(length=4000)
    private String defaultValue;
    //日期格式
    private String dateFormat;
    //其他元素值
    @Column(length=4000)
    private String otherValue;
    @Column(length=4000)
    private String otherInput;
    //其他元素读写
    private String otherRead;
    
    private String charValue;
    @Transient
    private double numValue;
    @Transient
    @JSONField (format="yyyy-MM-dd HH:mm:ss")  
    private Timestamp   dateValue;
    
/*    private FormData data;
    @OneToOne(cascade = CascadeType.REFRESH )
	@JoinColumn(name="id",referencedColumnName="field_id")
	public FormData getData() {
		return data;
	}

	public void setData(FormData data) {
		this.data = data;
	}*/
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

	public String getShowType() {
		return showType;
	}

	public void setShowType(String showType) {
		this.showType = showType;
	}

	public String getAuto() {
		return auto;
	}

	public void setAuto(String auto) {
		this.auto = auto;
	}

	public String getAutoPrev() {
		return autoPrev;
	}

	public void setAutoPrev(String autoPrev) {
		this.autoPrev = autoPrev;
	}

	public String getValidate() {
		return validate;
	}

	public void setValidate(String validate) {
		this.validate = validate;
	}

	public String getSelectRule() {
		return selectRule;
	}

	public void setSelectRule(String selectRule) {
		this.selectRule = selectRule;
	}

	public String getDefaultValue() {
		return defaultValue;
	}

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	public String getDateFormat() {
		return dateFormat;
	}

	public void setDateFormat(String dateFormat) {
		this.dateFormat = dateFormat;
	}

	public String getOtherValue() {
		return otherValue;
	}

	public void setOtherValue(String otherValue) {
		this.otherValue = otherValue;
	}

	public String getOtherInput() {
		return otherInput;
	}

	public void setOtherInput(String otherInput) {
		this.otherInput = otherInput;
	}

	public String getOtherRead() {
		return otherRead;
	}

	public void setOtherRead(String otherRead) {
		this.otherRead = otherRead;
	}

	public String getShowTitle() {
		return showTitle;
	}

	public void setShowTitle(String showTitle) {
		this.showTitle = showTitle;
	}

	public String getAutoType() {
		return autoType;
	}

	public void setAutoType(String autoType) {
		this.autoType = autoType;
	}

	public String getExtType() {
		return extType;
	}

	public void setExtType(String extType) {
		this.extType = extType;
	}
	@Transient
	public String getCharValue() {
		return charValue;
	}

	public void setCharValue(String charValue) {
		this.charValue = charValue;
	}
	@Transient
	public double getNumValue() {
		return numValue;
	}

	public void setNumValue(double numValue) {
		this.numValue = numValue;
	}
	@Transient
	public Timestamp getDateValue() {
		return dateValue;
	}

	public void setDateValue(Timestamp dateValue) {
		this.dateValue = dateValue;
	}

	
	
    
}
