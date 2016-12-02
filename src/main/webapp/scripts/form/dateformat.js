Date.prototype.format=function (mask) {
	var format = mask;
	if(typeof format == 'undefined' || format == null){
		return format;
	}
     var date = {
         "M+": this.getMonth() + 1,
         "d+": this.getDate(),
         "H+": this.getHours(),
         "m+": this.getMinutes(),
         "s+": this.getSeconds(),
         "q+": Math.floor((this.getMonth() + 3) / 3),
         "S+": this.getMilliseconds()
     };
     if (/(y+)/i.test(format)) {
         format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
     }
     for (var k in date) {
         if (new RegExp("(" + k + ")").test(format)) {
             format = format.replace(RegExp.$1, RegExp.$1.length == 1
                             ? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
         }
     }
     return format;
 }
 Date.daysInMonth = function (year, month) {
     if (month == 1) {
         if (year % 4 == 0 && year % 100 != 0)
             return 29;
         else
             return 28;
     } else if ((month <= 6 && month % 2 == 0) || (month = 6 && month % 2 == 1))
         return 31;
     else
         return 30;
 };
 Date.prototype.addMonth = function (addMonth) {
     var y = this.getFullYear();
     var m = this.getMonth();
     var nextY = y;
     var nextM = m;
     //如果当前月+要加上的月>11 这里之所以用11是因为 js的月份从0开始
     if (m > 11) {
         nextY = y + 1;
         nextM = parseInt(m + addMonth) - 11;
     } else {
         nextM = this.getMonth() + addMonth
     }
     var daysInNextMonth = Date.daysInMonth(nextY, nextM);
     var day = this.getDate();
     if (day > daysInNextMonth) {
         day = daysInNextMonth;
     }
     return new Date(nextY, nextM, day);
 };
 //yyyy年MM月dd日 HH时mm分ss秒
 String.prototype.toFormatDate = function(format){
 	var datestr = this;
 	format = format.replace('yyyy','(\\d{4})').replace('MM','(\\d{2})').replace('dd','(\\d{2})').replace('HH','(\\d{2})').replace('mm','(\\d{2})').replace('ss','(\\d{2})');
 	var exp = new RegExp(format);
 	return new Date(Date.parse(datestr.replace(exp,"$1\/$2\/$3")));
 }
 
 
 /** 
* 获取本周、本季度、本月、上月的开端日期、停止日期 
*/ 
var now = new Date(); //当前日期 
now.setHours(0);
now.setMinutes(0);
now.setSeconds(0);
now.setMilliseconds(0);
var nowDayOfWeek = now.getDay(); //今天本周的第几天 
var nowDay = now.getDate(); //当前日 
var nowMonth = now.getMonth(); //当前月 
var nowYear = now.getYear(); //当前年 
nowYear += (nowYear < 2000) ? 1900 : 0; // 

var lastMonthDate = new Date(); //上月日期 
lastMonthDate.setDate(1); 
lastMonthDate.setMonth(lastMonthDate.getMonth()-1); 

var nextMonthDate = new Date(); //下月日期 
nextMonthDate.setDate(1); 
nextMonthDate.setMonth(lastMonthDate.getMonth()+1); 

var lastYear = lastMonthDate.getYear(); 
var lastMonth = lastMonthDate.getMonth(); 

//去年当日
var lastYearDate = new Date();
lastYearDate.setYear(nowYear-1);

//明年当日
var nextYearDate = new Date();
nextYearDate.setYear(nowYear+1);

//获得某月的天数 
function getMonthDays(myMonth){ 
	var monthStartDate = new Date(nowYear, myMonth, 1); 
	var monthEndDate = new Date(nowYear, myMonth + 1, 1); 
	var days = (monthEndDate - monthStartDate)/(1000 * 60 * 60 * 24); 
	return days; 
} 

//获得本季度的开端月份 
function getQuarterStartMonth(){ 
	var quarterStartMonth = 0; 
	if(nowMonth<3){ 
		quarterStartMonth = 0; 
	} 
	if(2<nowMonth && nowMonth<6){ 
		quarterStartMonth = 3; 
	} 
	if(5<nowMonth && nowMonth<9){ 
		quarterStartMonth = 6; 
	} 
	if(nowMonth>8){ 
		quarterStartMonth = 9; 
	} 
	return quarterStartMonth; 
} 

//获得本周的开端日期 
function getWeekStartDate() { 
	var weekStartDate = new Date(nowYear, nowMonth, nowDay - nowDayOfWeek); 
	return weekStartDate; 
} 

//获得本周的停止日期 
function getWeekEndDate() { 
	var weekEndDate = new Date(nowYear, nowMonth, nowDay + (6 - nowDayOfWeek)); 
	return weekEndDate; 
} 

//获得下月的开端日期 
function getNextMonthStartDate(){ 
	var monthStartDate = new Date(nowYear, nowMonth+1, 1); 
	return monthStartDate; 
} 

//获得下月的停止日期 
function getNextMonthEndDate(){ 
	var monthEndDate = new Date(nowYear, nowMonth+1, getMonthDays(nowMonth+1)); 
	return monthEndDate; 
} 
//获得本月的开端日期 
function getMonthStartDate(){ 
	var monthStartDate = new Date(nowYear, nowMonth, 1); 
	return monthStartDate; 
} 

//获得本月的停止日期 
function getMonthEndDate(){ 
	var monthEndDate = new Date(nowYear, nowMonth, getMonthDays(nowMonth)); 
	return monthEndDate; 
} 

//获得上月开端时候 
function getLastMonthStartDate(){ 
	var lastMonthStartDate = new Date(nowYear, lastMonth, 1); 
	return lastMonthStartDate; 
} 

//获得上月停止时候 
function getLastMonthEndDate(){ 
	var lastMonthEndDate = new Date(nowYear, lastMonth, getMonthDays(lastMonth)); 
	return lastMonthEndDate; 
} 

//获得本季度的开端日期 
function getQuarterStartDate(){ 
	var quarterStartDate = new Date(nowYear, getQuarterStartMonth(), 1); 
	return quarterStartDate; 
} 

//或的本季度的停止日期 
function getQuarterEndDate(){ 
	var quarterEndMonth = getQuarterStartMonth() + 2; 
	var quarterStartDate = new Date(nowYear, quarterEndMonth, getMonthDays(quarterEndMonth)); 
	return quarterStartDate; 
} 

//获得去年的开端日期 
function getLastYearStartDate(){ 
	var monthStartDate = new Date(nowYear-1, 1, 1); 
	return monthStartDate; 
} 

//获得去年的停止日期 
function getLastYearEndDate(){ 
	var monthEndDate = new Date(nowYear-1, 1, 31); 
	return monthEndDate; 
} 
//获得本年的开端日期 
function getYearStartDate(){ 
	var monthStartDate = new Date(nowYear, 1, 1); 
	return monthStartDate; 
} 

//获得本年的停止日期 
function getYearEndDate(){ 
	var monthEndDate = new Date(nowYear, 1, 31); 
	return monthEndDate; 
} 
//获得明年年的开端日期 
function getNextYearStartDate(){ 
	var monthStartDate = new Date(nowYear+1, 1, 1); 
	return monthStartDate; 
} 

//获得明年的停止日期 
function getNextYearEndDate(){ 
	var monthEndDate = new Date(nowYear+1, 1, 31); 
	return monthEndDate; 
} 

var dateMap = new Object();
dateMap['当前日期'] = now;
dateMap['上月当日'] = lastMonthDate;
dateMap['去年当日'] = lastYearDate;
dateMap['下月当日'] = nextMonthDate;
dateMap['明年当日'] = nextYearDate;
dateMap['上月初'] = getLastMonthStartDate();
dateMap['本月初'] = getMonthStartDate();
dateMap['下月初'] = getNextMonthStartDate();
dateMap['去年初'] = getLastYearStartDate();
dateMap['本年初'] = getYearStartDate();
dateMap['明年初'] = getNextYearStartDate();

dateMap['上月末'] = getLastMonthEndDate();
dateMap['本月末'] = getMonthEndDate();
dateMap['下月末'] = getNextMonthEndDate();
dateMap['去年末'] = getLastYearEndDate();
dateMap['本年末'] = getYearEndDate();
dateMap['明年末'] = getNextYearEndDate();

