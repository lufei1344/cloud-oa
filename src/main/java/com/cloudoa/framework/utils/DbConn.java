package com.cloudoa.framework.utils;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Serializable;
import java.io.StringReader;
import java.io.Writer;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Savepoint;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;

import com.cloudoa.framework.orm.Page;
import com.sun.xml.internal.bind.v2.ClassFactory;

public class DbConn {
	private static final Logger logger = Logger.getLogger(DbConn.class);
	private DataSource dataSource;
	private String dataBase;
	private Connection conn = null;

	public DbConn() {
/*		if (dataSource == null) {
			try {
				ComboPooledDataSource cpds;
				Properties ps=new Properties();
			    ps.load(this.getClass().getResourceAsStream("/jdbc.properties"));
		        String dburl=ps.getProperty("jdbc.url");
		        String ddriver=ps.getProperty("jdbc.driver");
		        String uname=ps.getProperty("jdbc.username");
		        String pword=ps.getProperty("jdbc.password");
				cpds = new ComboPooledDataSource();
				cpds.setDriverClass(ddriver);
				cpds.setJdbcUrl(dburl);
				cpds.setUser(uname);
				cpds.setPassword(pword);
				cpds.setMaxPoolSize(5);
				cpds.setMinPoolSize(1);
				cpds.setMaxIdleTime(1800);
				cpds.setAcquireIncrement(1);
				cpds.setInitialPoolSize(1);
				cpds.setIdleConnectionTestPeriod(60);
				cpds.setAcquireRetryAttempts(3);
				cpds.setAcquireRetryDelay(1000);
				cpds.setBreakAfterAcquireFailure(false);
				cpds.setPreferredTestQuery("select 1 from dual");
				dataSource = cpds;
			} catch (Exception ex) {
				logger.error(ex);
			}
		}*/
	}
	
	
	
	public Connection getConnection() {
		Connection conn = null;
		try {
			try {
				conn = dataSource.getConnection();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
	/**
	 * 自己控制conn和resultset
	 * @param conn
	 * @param SqlStr
	 * @param Parameters
	 * @return
	 */
	public ResultSet execSql(Connection conn, String SqlStr,
			List<Object> Parameters) {
		logger.info("sql=[" + SqlStr + "]" + ",params=" + Parameters);
		ResultSet rset = null;
		if (Parameters != null) {
			try {
				PreparedStatement pstmt = conn.prepareStatement(SqlStr);
				for (int i = 0; i < Parameters.size(); i++) {
					pstmt.setObject(i + 1, Parameters.get(i));
				}
				rset = pstmt.executeQuery();
			} catch (Exception ex) {
				ex.printStackTrace();
				closeConnection(conn);
			}
		} else {
			try {
				Statement stmt = conn.createStatement(
						java.sql.ResultSet.TYPE_FORWARD_ONLY,
						java.sql.ResultSet.CONCUR_READ_ONLY);// 准备SQL语句
				rset = stmt.executeQuery(SqlStr);
			} catch (Exception ex) {
				ex.printStackTrace();
				closeConnection(conn);
			}
		}
		return rset;
	}
	/**
	 * 自己控制conn和resultset
	 * @param conn
	 * @param SqlStr
	 * @param Parameters
	 * @return
	 */
	public ResultSet execSql(Connection conn, String sql) {
		return execSql(conn,sql,null);
	}

	public int execUpd(String SqlStr, List<Object> Parameters) {
		logger.info("sql=[" + SqlStr + "]" + ",params=" + Parameters);
		int total = 0;
		Connection conn = null;
		if (Parameters != null) {
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement(SqlStr);
				for (int i = 0; i < Parameters.size(); i++) {
					if(Parameters.get(i) instanceof Reader){
						pstmt.setCharacterStream(i+1, (Reader)Parameters.get(i));
					}else if(Parameters.get(i) instanceof InputStream){
						pstmt.setBinaryStream(i+1, (InputStream)Parameters.get(i));
					}else{
						pstmt.setObject(i + 1, Parameters.get(i));
					}
					
				}
				total = pstmt.executeUpdate();
			} catch (Exception ex) {
				ex.printStackTrace();
			} finally {
				closePreparedStatement(pstmt);
				closeConnection(conn);
			}
		} else {
			Statement stmt = null;
			try {
				conn = getConnection();
				stmt = conn.createStatement();
				total = stmt.executeUpdate(SqlStr);
			} catch (Exception ex) {
				System.out.println("SqlErr:" + SqlStr);
				ex.printStackTrace();
			} finally {
				closeStatement(stmt);
				closeConnection(conn);
			}
		}
		return total;
	}
	public int executeUpdate(String SqlStr, Object[] Parameters) {
		logger.info("sql=[" + SqlStr + "]" + ",params=" + Parameters);
		int total = 0;
		Connection conn = null;
		if (Parameters != null) {
			PreparedStatement pstmt = null;
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement(SqlStr);
				for (int i = 0; i < Parameters.length; i++) {
					if(Parameters[i] instanceof Reader){
						pstmt.setCharacterStream(i+1, (Reader)Parameters[i]);
					}else if(Parameters[i] instanceof InputStream){
						pstmt.setBinaryStream(i+1, (InputStream)Parameters[i]);
					}else{
						pstmt.setObject(i + 1, Parameters[i]);
					}
					
				}
				total = pstmt.executeUpdate();
			} catch (Exception ex) {
				ex.printStackTrace();
			} finally {
				closePreparedStatement(pstmt);
				closeConnection(conn);
			}
		} else {
			Statement stmt = null;
			try {
				conn = getConnection();
				stmt = conn.createStatement();
				total = stmt.executeUpdate(SqlStr);
			} catch (Exception ex) {
				System.out.println("SqlErr:" + SqlStr);
				ex.printStackTrace();
			} finally {
				closeStatement(stmt);
				closeConnection(conn);
			}
		}
		return total;
	}
	public int execUpd(String sql) {
		return execUpd(sql,null);
	}
   public  boolean executeUpdate(Connection conn,String sql) throws SQLException{
	      logger.info("sql=[" + sql + "]" + "");
		  if((sql==null)||sql.trim().equals("")){return true;}
		  Statement stmt = conn.createStatement();
		  stmt.executeUpdate(sql);
		  stmt.close();
		  return true;
   }
   public  boolean executeUpdate(Connection sconn,String sql, Object[] params) throws SQLException{
	   logger.info("sql=[" + sql + "]" + ",params=" + params);  
	   if((sql==null)||sql.trim().equals("")){return true;}
		  if((params==null)||(params.length==0)){return executeUpdate(conn,sql);}
		  Connection conn = sconn;
		  PreparedStatement pstmt;
		  boolean res;
		  pstmt = conn.prepareStatement(sql);
		  for(int i = 0; i < params.length; i++){
			  pstmt.setObject(i+1, params[i]);
		  }
		  res = (pstmt.executeUpdate()>0);
		  pstmt.close();
		  return res;
	}

	/**
	 * 批量执行
	 * 
	 * @param sqls
	 * @param params
	 * @return
	 */
	public boolean execUpdates(List<String> sqls, List<List<Object>> params) {
		String sql;
		List<Object> p;
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		Statement stmt = null;
		try {
			conn.setAutoCommit(false);
			for (int v = 0; v < sqls.size(); v++) {
				sql = sqls.get(v);
				p = params == null || params.size() < v + 1 ? null : params
						.get(v);
				logger.info("sql=[" + sql + "]" + ",params=" + p);
				if (p != null) {
					pstmt = conn.prepareStatement(sql);
					for (int i = 0; i < p.size(); i++) {
						pstmt.setObject(i + 1, p.get(i));
					}
					pstmt.executeUpdate();
					closePreparedStatement(pstmt);
				} else {
					stmt = conn.createStatement();
					stmt.executeUpdate(sql);
					closeStatement(stmt);
				}
			}
			conn.commit();
		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			logger.error(e.getMessage(), e);
			return false;
		} finally {
			closeConnection(conn);
		}
		return true;
	}
	
	/**
	 * 安全sql防止注入
	 * @param sql
	 * @return
	 */
	public String selfSql(String sql){
		return sql.replaceAll("([';])+|(--)+","");
	}
	
	
	
	/**
	 * 批量执行
	 * 
	 * @param sqls
	 * @param params
	 * @return
	 */
	public boolean execUpdates(String sql, List<List<Object>> params) {
		List<Object> p;
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		try {
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(sql);
			for(int v=0; v<params.size(); v++){
				p = params.get(v);
				logger.info("sql=[" + sql + "]" + ",params=" + p);
				
				for (int i = 0; i < p.size(); i++) {
					pstmt.setObject(i + 1, p.get(i));
				}
				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
			closePreparedStatement(pstmt);
			conn.commit();
		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			logger.error(e.getMessage(), e);
			return false;
		} finally {
			closeConnection(conn);
		}
		return true;
	}
	/**
	 * 批量执行
	 * 
	 * @param sqls
	 * @param params
	 * @return
	 */
	public boolean execUpdates(String[] sql, List<List<Object>>...  params) {
		List<Object> p;
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		try {
			conn.setAutoCommit(false);
			for(int t=0; t<sql.length; t++){
				pstmt = conn.prepareStatement(sql[t]);
				for(int v=0; v<params[t].size(); v++){
					p = params[t].get(v);
					logger.info("sql=[" + sql[t] + "]" + ",params=" + p);
					
					for (int i = 0; i < p.size(); i++) {
						pstmt.setObject(i + 1, p.get(i));
					}
					pstmt.executeUpdate();
					pstmt.clearParameters();
				}
				closePreparedStatement(pstmt);
			}
			conn.commit();
		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			logger.error(e.getMessage(), e);
			return false;
		} finally {
			closeConnection(conn);
		}
		return true;
	}
	/**
	 * 批量执行
	 * 
	 * @param sqls
	 * @param location 启用参数位置
	 * @param params
	 * @return
	 */
	public boolean execUpdates(List<String> sqls,int location, List<List<Object>> params) {
		List<Object> p;
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		Statement stmt = null;
		Savepoint sp = null;
		try {
			conn.setAutoCommit(false);
			sp = conn.setSavepoint();
			String sql = null;
			for(int s=0; s<sqls.size(); s++){
				sql = sqls.get(s);
				pstmt = conn.prepareStatement(sql);
				if(s == location){
					for(int v=0; v<params.size(); v++){
						p = params.get(v);
						logger.info("sql=[" + sql + "]" + ",params=" + p);
						for (int i = 0; i < p.size(); i++) {
							pstmt.setObject(i + 1, p.get(i));
						}
						pstmt.addBatch();
					}
					int[] ret = pstmt.executeBatch();
					logger.info("update : "+ret.length);
				}else{
					logger.info("sql=[" + sql + "]");
					pstmt.execute();
				}
				closePreparedStatement(pstmt);
			}
			conn.commit();
			conn.setAutoCommit(true);
		} catch (Exception e) {
			try {
				if(sp != null){
					conn.rollback(sp);
				}else{
					conn.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			logger.error(e.getMessage(), e);
			return false;
		} finally {
			closeStatement(pstmt);
			closeStatement(stmt);
			closeConnection(conn);
		}
		return true;
	}

	/**
	 * 
	 * @param SqlStr
	 * @param Parameters
	 * @param keys
	 *            主键名
	 * @return 主键id
	 */
	public long execUpd(String SqlStr, List<Object> Parameters, String[] keys) {
		logger.info("sql=[" + SqlStr + "]" + ",params=" + Parameters);
		long total = 0;
		Connection conn = null;
		if (Parameters != null) {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement(SqlStr, keys);
				for (int i = 0; i < Parameters.size(); i++) {
					pstmt.setObject(i + 1, Parameters.get(i));
				}
				total = pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					total = rs.getLong(1);
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			} finally {
				closeResultSet(rs);
				closePreparedStatement(pstmt);
				closeConnection(conn);
			}
		} else {
			Statement stmt = null;
			ResultSet rs = null;
			try {
				conn = getConnection();
				stmt = conn.createStatement();
				total = stmt.executeUpdate(SqlStr, keys);
				rs = stmt.getGeneratedKeys();
				if (rs.next()) {
					total = rs.getLong(1);
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			} finally {
				closeResultSet(rs);
				closeStatement(stmt);
				closeConnection(conn);
			}
		}
		return total;
	}
	
	public void runScript(String sql){
		this.runScript(new StringReader(sql));
	}
	 public void runScript(Reader reader){
		   StringBuffer command = null;
		   Connection conn = null;
		   try {
			  conn = this.getConnection();
		     LineNumberReader lineReader = new LineNumberReader(reader);
		     String line = null;
		     while ((line = lineReader.readLine()) != null) {
			       if (command == null) {
			         command = new StringBuffer();
			       }
			       String trimmedLine = line.trim();
			       if (trimmedLine.startsWith("--")) {
			       } else if (trimmedLine.length() < 1 || trimmedLine.startsWith("//")) {
			         //Do nothing
			       } else if (trimmedLine.length() < 1 || trimmedLine.startsWith("--")) {
			         //Do nothing
			       } else if (trimmedLine.endsWith(";")) {
			         command.append(line.substring(0, line.lastIndexOf(";")));
			         command.append(" ");
			         Statement statement = conn.createStatement();
			         logger.info("sql=[" + command.toString() + "]");
			         statement.execute(command.toString());
			         conn.commit();
			         command = null;
			         try {
			           statement.close();
			         } catch (Exception e) {
			         }
			         Thread.yield();
			       } else {
			         command.append(line);
			         command.append(" ");
			       }
		     }
		   } catch (Exception e) {
		      e.printStackTrace();
		   } finally {
			   this.closeConnection(conn);
		   }
		 }


	/**
	 * 取序列值
	 * @param seq
	 * @return
	 */
	public long getNextValue(String seq){
		long id = -1;
		ResultSet rs = null;
		Connection conn = null;
		try {
			conn = getConnection();
			rs = this.execSql(conn,"SELECT SEQ.NEXTVAL FROM DUAL".replaceAll("SEQ", seq),null);
			if(rs.next()){
				id = rs.getLong(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			closeResultSet(rs);
			closeConnection(conn);
		}
		return id;
	}

	public void closePreparedStatement(PreparedStatement pstmt) {
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public static void closeStatement(Statement stmt) {
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public void closeConnection(Connection connection) {
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public void closeResultSet(ResultSet rs) {
		if (rs != null) {
			try {
				Statement stmt = rs.getStatement();
				rs.close();
				if (stmt != null) {
					closeStatement(stmt);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public String getDataBase(){
		if(dataBase == null){
			Connection conn = null;
			try{
				conn = this.getConnection();
				dataBase = conn.getMetaData().getDatabaseProductName();
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				closeConnection(conn);
			}
			
		}
		return dataBase;
	}
	
	public Page<Map<String,Object>> getPage(Page<Map<String,Object>> page,StringBuffer sql,List<Object> params){
		if(this.getDataBase().toLowerCase().contains("mysql")){
			return this.getMysqlPage(page, sql, params);
		}else if(this.getDataBase().toLowerCase().contains("oracle")){
			return this.getOraclePage(page, sql, params);
		}else if(this.getDataBase().toLowerCase().contains("sql server")){
			return this.getSqlServer2005Page(page, sql, params);
		}
		return null;
	}
	
	public Page<Map<String, Object>> getMysqlPage(
			Page<Map<String, Object>> page, StringBuffer sql,
			List<Object> params) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		ResultSet rsCount = null;
		ResultSet rs = null;
		Connection conn = null;
		try {
			conn = this.getConnection();
			rsCount = this.execSql(conn, "SELECT count(*) as total FROM ( "
					+ sql.toString() + " )T", params);
			int pagesize = page.getPageSize();
			int begin = 1;
			if (rsCount != null && rsCount.next()) {
				page.setTotalCount(rsCount.getInt("total"));
			}

			begin = (page.getPageNo() - 1) * pagesize + 1;

			if (params == null) {
				params = new ArrayList<Object>();
			}
			params.add(begin - 1);
			params.add(pagesize);

			rs = this.execSql(conn, "SELECT * FROM (  " + sql.toString()
					+ " ) T LIMIT ?,?", params);
			if (rs != null) {
				Map<String, String> metaMap = this.getResultSetMetaMap(rs);
				while (rs.next()) {
					list.add(this.CreateMap(metaMap, rs));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			this.closeResultSet(rs);
			this.closeResultSet(rsCount);
			closeConnection(conn);
		}
		page.setResult(list);
		return page;
	}

	public Page<Map<String, Object>> getOraclePage(
			Page<Map<String, Object>> page, StringBuffer sql,
			List<Object> params) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		ResultSet rsCount = null;
		ResultSet rs = null;
		Connection conn = null;
		try {
			conn = this.getConnection();
			rsCount = this.execSql(conn, "SELECT count(*) as total FROM ( "
					+ sql.toString() + " )T", params);
			int pagesize = page.getPageSize();
			int begin = 1;
			int end = pagesize;
			if (rsCount != null && rsCount.next()) {
				page.setTotalCount(rsCount.getInt("total"));
			}

			begin = (page.getPageNo() - 1) * pagesize + 1;
			end = page.getPageNo() * pagesize;

			if (params == null) {
				params = new ArrayList<Object>();
			}
			params.add(Integer.toString(begin));
			params.add(Integer.toString(end));

			rs = this.execSql(
					conn,
					"SELECT * FROM ( SELECT rownum row_id,T.* from ( "
							+ sql.toString()
							+ " ) T ) T WHERE row_id between ? and ?", params);
			if (rs != null) {
				Map<String, String> metaMap = this.getResultSetMetaMap(rs);
				while (rs.next()) {
					list.add(this.CreateMap(metaMap, rs));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			this.closeResultSet(rs);
			this.closeResultSet(rsCount);
			closeConnection(conn);
		}
		page.setResult(list);
		return page;
	}
	/**
	 * @param page
	 * @param sql select row_number() over (order by id desc) rowid ,a.* from t_table a
	 * @param params
	 * @return
	 */
	public Page<Map<String, Object>> getSqlServer2005Page(
			Page<Map<String, Object>> page, StringBuffer sql,
			List<Object> params) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		ResultSet rsCount = null;
		ResultSet rs = null;
		Connection conn = null;
		try {
			conn = this.getConnection();
			rsCount = this.execSql(conn, "SELECT count(*) as total FROM ( "
					+ sql.toString() + " )T", params);
			int pagesize = page.getPageSize();
			int begin = 1;
			int end = pagesize;
			if (rsCount != null && rsCount.next()) {
				page.setTotalCount(rsCount.getInt("total"));
			}
			
			begin = (page.getPageNo() - 1) * pagesize + 1;
			end = page.getPageNo() * pagesize;
			
			if (params == null) {
				params = new ArrayList<Object>();
			}
			params.add(Integer.toString(begin));
			params.add(Integer.toString(end));
			
			rs = this.execSql(
					conn,
					"SELECT * FROM (  "
					+ sql.toString()
					+ "   ) T WHERE rowid between ? and ?", params);
			if (rs != null) {
				Map<String, String> metaMap = this.getResultSetMetaMap(rs);
				while (rs.next()) {
					list.add(this.CreateMap(metaMap, rs));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			this.closeResultSet(rs);
			this.closeResultSet(rsCount);
			closeConnection(conn);
		}
		page.setResult(list);
		return page;
	}

	// 没关闭连接，使用后关闭连接
	public List<Map<String, Object>> getList(String sql, List<Object> params) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		ResultSet rs = null;
		Connection conn = null;
		try {
			conn = this.getConnection();
			rs = this.execSql(conn, sql, params);
			if (rs != null) {
				Map<String, String> metaMap = this.getResultSetMetaMap(rs);
				while (rs.next()) {
					list.add(this.CreateMap(metaMap, rs));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			this.closeResultSet(rs);
			closeConnection(conn);
		}
		return list;
	}
	//resultset转list
	public List<Map<String, Object>> getList(ResultSet rs) throws Exception{
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();	
		if (rs != null) {
			Map<String, String> metaMap = this.getResultSetMetaMap(rs);
			while (rs.next()) {
				list.add(this.CreateMap(metaMap, rs));
			}
		}
		return list;
	}
	// 没关闭连接，使用后关闭连接
	public List<String> getColumnName(String sql, List<Object> params) {
		List<String> list = new ArrayList<String>();
		ResultSet rs = null;
		Connection conn = null;
		try {
			conn = this.getConnection();
			rs = this.execSql(conn, sql, params);
			if (rs != null) {
				ResultSetMetaData meta = rs.getMetaData();
				for (int i = 1; i <= meta.getColumnCount(); i++) {
					list.add(meta.getColumnLabel(i).toLowerCase());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			this.closeResultSet(rs);
			closeConnection(conn);
		}
		return list;
	}

	public Page<List<Object>> getPage(Page<List<Object>> page, String sql,
			List<Object> params) {
		List<List<Object>> list = new ArrayList<List<Object>>();
		ResultSet rsCount = null;
		ResultSet rs = null;
		Connection conn = null;
		try {
			// rsCount = this.getResultSet(conn,
			// "SELECT MAX(rowid) as total FROM ( " + sql.toString() + " )T",
			// params);
			conn = this.getConnection();
			rsCount = this.execSql(conn, "SELECT count(*) as total FROM ( "
					+ sql.toString() + " )T", params);
			int pagesize = page.getPageSize();
			int begin = 1;
			int end = pagesize;
			if (rsCount != null && rsCount.next()) {
				page.setTotalCount(rsCount.getInt("total"));
			}

			begin = (page.getPageNo() - 1) * pagesize + 1;
			end = page.getPageNo() * pagesize;

			if (params == null) {
				params = new ArrayList<Object>();
			}
			params.add(Integer.toString(begin));
			params.add(Integer.toString(end));

			rs = this.execSql(
					conn,
					"SELECT * FROM ( SELECT rownum row_id,T.* from ( "
							+ sql.toString()
							+ " ) T ) T WHERE row_id between ? and ?", params);
			if (rs != null) {
				int size = this.getResultSetMetaMap(rs).size();
				while (rs.next()) {
					list.add(this.CreateMap(size, rs));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			this.closeResultSet(rs);
			this.closeResultSet(rsCount);
			closeConnection(conn);
		}
		page.setResult(list);
		return page;
	}

	public Map<String, String> getResultSetMetaMap(ResultSet rs)
			throws Exception {
		ResultSetMetaData meta = rs.getMetaData();
		Map<String, String> metaMap = new HashMap<String, String>();
		for (int i = 1; i <= meta.getColumnCount(); i++) {
			metaMap.put(meta.getColumnLabel(i).toLowerCase(), meta
					.getColumnLabel(i).toLowerCase());
		}
		return metaMap;
	}

	public Map<String, Object> CreateMap(Map<String, String> metaMap,
			ResultSet rs) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		Iterator<String> it = metaMap.keySet().iterator();
		while (it.hasNext()) {
			String key = it.next();
			if (metaMap.containsKey(key)) {
				String value = rs.getString(key);
				map.put(key, value);
			}
		}
		return map;
	}

	public List<Object> CreateMap(int size, ResultSet rs) throws Exception {
		List<Object> row = new ArrayList<Object>();
		for (int i = 2; i <= size; i++) {
			row.add(rs.getString(i));
		}
		return row;
	}

	// 单行查询
	public <T> T getObject(String sql, Class<T> clazz) {
		logger.info(sql);
		Statement stmt = null;
		ResultSet rset = null;
		T t = null;
		ClassFactory factory = new ClassFactory();
		Connection conn = getConnection();
		try {
			stmt = conn.createStatement();
			rset = stmt.executeQuery(sql);
			if (rset.next()) {
				t = clazz.newInstance();
				//Field[] fie = clazz.getDeclaredFields();
				BeanInfo info = Introspector.getBeanInfo(clazz);
				PropertyDescriptor[] fie = info.getPropertyDescriptors();
				for (int i = 0; i < fie.length; i++) {
					this.mapResultSet2Object(rset, t, fie[i]);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			closeResultSet(rset);
			closeStatement(stmt);
			closeConnection(conn);
		}
		return t;
	}

	// 单行查询
	public <T> T getObject(String sql, List<Object> params, Class<T> clazz) {
		logger.info("sql=[" + sql + "]" + ",params=" + params);
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		T t = null;
		ClassFactory factory = new ClassFactory();
		Connection conn = getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			if (params != null) {
				for (int i = 0; i < params.size(); i++) {
					pstmt.setObject(i + 1, params.get(i));
				}
			}
			rset = pstmt.executeQuery();
			if (rset.next()) {
				t = clazz.newInstance();
				BeanInfo info = Introspector.getBeanInfo(clazz);
				PropertyDescriptor[] fie = info.getPropertyDescriptors();
				for (int i = 0; i < fie.length; i++) {
					this.mapResultSet2Object(rset, t, fie[i]);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			closeResultSet(rset);
			closePreparedStatement(pstmt);
			closeConnection(conn);
		}
		return t;
	}

	// 单行查询
	public Map<String, Object> getMap(String sql, List<Object> params) {
		logger.info("sql=[" + sql + "]" + ",params=" + params);
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		Map<String, Object> t = null;
		Connection conn = getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			if (params != null) {
				for (int i = 0; i < params.size(); i++) {
					pstmt.setObject(i + 1, params.get(i));
				}
			}
			rset = pstmt.executeQuery();
			if (rset.next()) {
				t = CreateMap(this.getResultSetMetaMap(rset), rset);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			closeResultSet(rset);
			closePreparedStatement(pstmt);
			closeConnection(conn);
		}
		return t;
	}

	// 一个列
	@SuppressWarnings("unchecked")
	public <T> T getColumnObject(String sql, List<Object> params, Class<T> clazz) {
		logger.info(sql);
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		T t = null;
		Connection conn = getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			if (params != null) {
				for (int i = 0; i < params.size(); i++) {
					pstmt.setObject(i + 1, params.get(i));
				}
			}
			rset = pstmt.executeQuery();
			if (rset.next()) {
				t = (T) rset.getObject(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			closeResultSet(rset);
			closePreparedStatement(pstmt);
			closeConnection(conn);
		}
		return t;
	}

	// 多行查询
	public <T> List<T> getObjects(String sql, Class<T> clazz) {
		logger.info(sql);
		Statement stmt = null;
		ResultSet rset = null;
		List<T> list = new ArrayList<T>();
		ClassFactory factory = new ClassFactory();
		Connection conn = getConnection();
		try {
			stmt = conn.createStatement();
			rset = stmt.executeQuery(sql);
			BeanInfo info = Introspector.getBeanInfo(clazz);
			PropertyDescriptor[] fie = info.getPropertyDescriptors();
			while (rset.next()) {
				T t = clazz.newInstance();
				for (int i = 0; i < fie.length; i++) {
					this.mapResultSet2Object(rset, t, fie[i]);
				}
				if (null == t)
					continue;
				list.add(t);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			closeResultSet(rset);
			closeStatement(stmt);
			closeConnection(conn);
		}
		// logger.info(System.currentTimeMillis()-l);
		return list;
	}

	// 多行查询
	public <T> List<T> getObjects(String sql, Class<T> clazz, Object[] params) {
		logger.info(sql);
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		List<T> list = new ArrayList<T>();
		ClassFactory factory = new ClassFactory();
		try {
			pstmt = conn.prepareStatement(sql);
			if(params != null){
				for (int i = 0; i < params.length; i++) {
					pstmt.setObject(i + 1, params[i]);
				}
			}
			rset = pstmt.executeQuery();
			BeanInfo info = Introspector.getBeanInfo(clazz);
			PropertyDescriptor[] fie = info.getPropertyDescriptors();
			while (rset.next()) {
				T t = clazz.newInstance();
				for (int i = 0; i < fie.length; i++) {
					this.mapResultSet2Object(rset, t, fie[i]);
				}
				if (null == t)
					continue;
				list.add(t);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			closeResultSet(rset);
			closePreparedStatement(pstmt);
			closeConnection(conn);
		}
		return list;
	}

	public static Blob createBlob(byte[] bytes) {
		return new SerializableBlob(new BlobImpl(bytes));
	}

	public static Blob createBlob(InputStream stream, int length) {
		return new SerializableBlob(new BlobImpl(stream, length));
	}

	public static Blob createBlob(InputStream stream) throws IOException {
		return new SerializableBlob(new BlobImpl(stream, stream.available()));
	}

	public static Clob createClob(String string) {
		return new SerializableClob(new ClobImpl(string));
	}
	public static Clob createClob(InputStream stream) {
		return new SerializableClob(new ClobImpl(stream));
	}

	public static Clob createClob(Reader reader, int length) {
		return new SerializableClob(new ClobImpl(reader, length));
	}
	

	public DataSource getDataSource() {
		return dataSource;
	}

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	//

	public static class BlobImpl implements Blob {
		private InputStream stream;
		private int length;
		private boolean needsReset = false;

		public BlobImpl(byte[] bytes) {
			this.stream = new ByteArrayInputStream(bytes);
			this.length = bytes.length;
		}

		public BlobImpl(InputStream stream, int length) {
			this.stream = stream;
			this.length = length;
		}

		public long length() throws SQLException {
			return this.length;
		}

		public void truncate(long pos) throws SQLException {
			excep();
		}

		public byte[] getBytes(long pos, int len) throws SQLException {

		    if (pos < 1L) {
		      throw new SQLException("Error");
		    }

		    pos -= 1L;

		    if (pos > this.length) {
		    	throw new SQLException("\"pos\" argument can not be larger than the BLOB's length.S1009");
		    }

		    if (pos + length > this.length) {
		    	throw new SQLException("\"pos\" argument can not be larger than the BLOB's length.S1009");
		    }

		    byte[] newData = new byte[length];
		    try {
				stream.read(newData);
			} catch (IOException e) {
				e.printStackTrace();
			}

		    return newData;
		}

		public int setBytes(long pos, byte[] bytes) throws SQLException {
			excep();
			return 0;
		}

		public int setBytes(long pos, byte[] bytes, int i, int j)
				throws SQLException {
			excep();
			return 0;
		}

		public long position(byte[] bytes, long pos) throws SQLException {
			excep();
			return 0L;
		}

		public InputStream getBinaryStream() throws SQLException {
			try {
				if (this.needsReset)
					this.stream.reset();
			} catch (IOException ioe) {
				throw new SQLException("could not reset reader");
			}
			this.needsReset = true;
			return this.stream;
		}

		public OutputStream setBinaryStream(long pos) throws SQLException {
			excep();
			return null;
		}

		public long position(Blob blob, long pos) throws SQLException {
			excep();
			return 0L;
		}

		private static void excep() {
			throw new UnsupportedOperationException(
					"Blob may not be manipulated from creating session");
		}

		public void free() throws SQLException {
			try {
				stream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		public InputStream getBinaryStream(long pos, long length)
				throws SQLException {
			return stream;
		}
	}

	//

	public static class ClobImpl implements Clob {
		private Reader reader;
		private int length;
		private boolean needsReset = false;

		public ClobImpl(String string) {
			this.reader = new StringReader(string);
			this.length = string.length();
		}

		public ClobImpl(Reader reader, int length) {
			this.reader = reader;
			this.length = length;
		}
		public ClobImpl(InputStream input) {
			this.reader = new InputStreamReader(input);
			try {
				this.length = input.available();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		public long length() throws SQLException {
			return this.length;
		}

		public void truncate(long pos) throws SQLException {
			excep();
		}

		public InputStream getAsciiStream() throws SQLException {
			try {
				if (this.needsReset)
					this.reader.reset();
			} catch (IOException ioe) {
				throw new SQLException("could not reset reader");
			}
			this.needsReset = true;
			return new ReaderInputStream(this.reader);
		}

		public OutputStream setAsciiStream(long pos) throws SQLException {
			excep();
			return null;
		}

		public Reader getCharacterStream() throws SQLException {
			try {
				if (this.needsReset)
					this.reader.reset();
			} catch (IOException ioe) {
				throw new SQLException("could not reset reader");
			}
			this.needsReset = true;
			return this.reader;
		}

		public Writer setCharacterStream(long pos) throws SQLException {
			excep();
			return null;
		}

		public String getSubString(long pos, int len) throws SQLException {
			 if (pos < 1L) {
			      throw new SQLException("Error");
			    }

			    pos -= 1L;

			    if (pos > this.length) {
			    	throw new SQLException("\"pos\" argument can not be larger than the BLOB's length.S1009");
			    }

			    if (pos + length > this.length) {
			    	throw new SQLException("\"pos\" argument can not be larger than the BLOB's length.S1009");
			    }

			    char[] newData = new char[length];
			    try {
					reader.read(newData);
				} catch (IOException e) {
					e.printStackTrace();
				}
			return new String(newData);
		}

		public int setString(long pos, String string) throws SQLException {
			excep();
			return 0;
		}

		public int setString(long pos, String string, int i, int j)
				throws SQLException {
			excep();
			return 0;
		}

		public long position(String string, long pos) throws SQLException {
			excep();
			return 0L;
		}

		public long position(Clob colb, long pos) throws SQLException {
			excep();
			return 0L;
		}

		private static void excep() {
			throw new UnsupportedOperationException(
					"Blob may not be manipulated from creating session");
		}

		public void free() throws SQLException {
			try {
				reader.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		public Reader getCharacterStream(long pos, long length)
				throws SQLException {
			return reader;
		}
	}

	public static class ReaderInputStream extends InputStream {
		private Reader reader;

		public ReaderInputStream(Reader reader) {
			this.reader = reader;
		}

		public int read() throws IOException {
			return this.reader.read();
		}
	}

	//

	public static class SerializableBlob implements Serializable, Blob {
		private static final long serialVersionUID = 8361562034302708977L;
		private final transient Blob blob;

		public SerializableBlob(Blob blob) {
			this.blob = blob;
		}

		public Blob getWrappedBlob() {
			if (this.blob == null) {
				throw new IllegalStateException(
						"Blobs may not be accessed after serialization");
			}

			return this.blob;
		}

		public long length() throws SQLException {
			return getWrappedBlob().length();
		}

		public byte[] getBytes(long pos, int length) throws SQLException {
			return getWrappedBlob().getBytes(pos, length);
		}

		public InputStream getBinaryStream() throws SQLException {
			return getWrappedBlob().getBinaryStream();
		}

		public long position(byte[] pattern, long start) throws SQLException {
			return getWrappedBlob().position(pattern, start);
		}

		public long position(Blob pattern, long start) throws SQLException {
			return getWrappedBlob().position(pattern, start);
		}

		public int setBytes(long pos, byte[] bytes) throws SQLException {
			return getWrappedBlob().setBytes(pos, bytes);
		}

		public int setBytes(long pos, byte[] bytes, int offset, int len)
				throws SQLException {
			return getWrappedBlob().setBytes(pos, bytes, offset, len);
		}

		public OutputStream setBinaryStream(long pos) throws SQLException {
			return getWrappedBlob().setBinaryStream(pos);
		}

		public void truncate(long len) throws SQLException {
			getWrappedBlob().truncate(len);
		}

		public void free() throws SQLException {
			blob.free();
		}

		public InputStream getBinaryStream(long pos, long length)
				throws SQLException {
			return blob.getBinaryStream();
		}
	}

	//
	public static class SerializableClob implements Serializable, Clob {
		private static final long serialVersionUID = 10055712772737954L;
		private final transient Clob clob;

		public SerializableClob(Clob blob) {
			this.clob = blob;
		}

		public Clob getWrappedClob() {
			if (this.clob == null) {
				throw new IllegalStateException(
						"Clobs may not be accessed after serialization");
			}

			return this.clob;
		}
		
		
		public long length() throws SQLException {
			return getWrappedClob().length();
		}

		public String getSubString(long pos, int length) throws SQLException {
			return getWrappedClob().getSubString(pos, length);
		}

		public Reader getCharacterStream() throws SQLException {
			return getWrappedClob().getCharacterStream();
		}

		public InputStream getAsciiStream() throws SQLException {
			return getWrappedClob().getAsciiStream();
		}

		public long position(String searchstr, long start) throws SQLException {
			return getWrappedClob().position(searchstr, start);
		}

		public long position(Clob searchstr, long start) throws SQLException {
			return getWrappedClob().position(searchstr, start);
		}

		public int setString(long pos, String str) throws SQLException {
			return getWrappedClob().setString(pos, str);
		}

		public int setString(long pos, String str, int offset, int len)
				throws SQLException {
			return getWrappedClob().setString(pos, str, offset, len);
		}

		public OutputStream setAsciiStream(long pos) throws SQLException {
			return getWrappedClob().setAsciiStream(pos);
		}

		public Writer setCharacterStream(long pos) throws SQLException {
			return getWrappedClob().setCharacterStream(pos);
		}

		public void truncate(long len) throws SQLException {
			getWrappedClob().truncate(len);
		}

		public void free() throws SQLException {
			clob.free();
		}

		public Reader getCharacterStream(long pos, long length)
				throws SQLException {
			return clob.getCharacterStream();
		}
	}

	
	/****/
	private static String upperFirstChar(String s) {
		char[] chars = s.toCharArray();
		chars[0] = Character.toUpperCase(chars[0]);
		return new String(chars);
	}
	//取得类属性,
	private Field[] getFields(Class clazz){
		List<Field> f = new ArrayList<Field>();
		Field[] fs = clazz.getDeclaredFields();
		for(Field ff : fs){
			f.add(ff);
		}
		Class superclass = clazz.getSuperclass(); 
		if(superclass != null){
			fs = getFields(superclass);
			for(Field ff : fs){
				f.add(ff);
			}
		}
		return f.toArray(new Field[f.size()]);
	}

	@SuppressWarnings("unchecked")
	public Object[] getDeclaredMethod(Class clazz,String method,Class[] type) throws SecurityException, NoSuchMethodException{
		Method m = clazz.getDeclaredMethod(method, type);
		if(clazz == Object.class){
			return null;
		}
		if(m == null){
			return getDeclaredMethod(clazz.getSuperclass(),method,type);
		}
		return new Object[]{m,clazz};
	}
	// ResultSet 映射成 Object
	public void mapResultSet2Object(ResultSet rs, Object obj,String propertyName, String columName)
			throws NoSuchMethodException, IllegalAccessException,
			InvocationTargetException, SQLException, SecurityException
			,NoSuchFieldException{
	    try{
	        rs.findColumn(columName);
	    }
	    catch(SQLException e){
	        return;
	    }
		Class<? extends Object> clazz = obj.getClass();
		Class<? extends Object> propertyType = clazz.getDeclaredField(
				propertyName).getType();
		Method method = clazz.getDeclaredMethod("set"+ upperFirstChar(propertyName), new Class[] { propertyType });
		if (propertyType == String.class)
			method.invoke(obj, (Object[]) new String[] { rs.getString(columName)==null?"":rs.getString(columName)});
		else if (propertyType == int.class||propertyType == Integer.class)
			method.invoke(obj, (Object[]) new Integer[] { new Integer(rs
					.getInt(columName)) });
		else if (propertyType == float.class||propertyType == Float.class)
			method.invoke(obj, (Object[]) new Float[] { new Float(rs
					.getFloat(columName)) });
		else if (propertyType == long.class||propertyType==Long.class)
			method.invoke(obj, (Object[]) new Long[] { new Long(rs
					.getLong(columName)) });
		else if (propertyType == double.class||propertyType == Double.class)
			method.invoke(obj, (Object[]) new Double[] { new Double(rs
					.getDouble(columName)) });
		else if (propertyType == boolean.class||propertyType == Boolean.class)
			method.invoke(obj, (Object[]) new Boolean[] { new Boolean(rs
					.getBoolean(columName)) });
		else if (propertyType == Date.class) {
			method.invoke(obj, (Object[]) new Date[] { rs.getDate(columName) });
		}
	}
	// ResultSet 映射成 Object
	public void mapResultSet2Object(ResultSet rs, Object obj,PropertyDescriptor propertyName)
	throws NoSuchMethodException, IllegalAccessException,
	InvocationTargetException, SQLException, SecurityException
	,NoSuchFieldException{
		String columnName = propertyName.getName().toLowerCase();
		try{
			rs.findColumn(columnName);
		}
		catch(SQLException e){
			return;
		}
		Class<? extends Object> propertyType  = propertyName.getPropertyType();
		Method method = propertyName.getWriteMethod();
		if (propertyType == String.class)
			method.invoke(obj, (Object[]) new String[] { rs.getString(columnName)==null?"":rs.getString(columnName)});
		else if (propertyType == int.class||propertyType == Integer.class)
			method.invoke(obj, (Object[]) new Integer[] { new Integer(rs
					.getInt(columnName)) });
		else if (propertyType == float.class||propertyType == Float.class)
			method.invoke(obj, (Object[]) new Float[] { new Float(rs
					.getFloat(columnName)) });
		else if (propertyType == long.class||propertyType==Long.class)
			method.invoke(obj, (Object[]) new Long[] { new Long(rs
					.getLong(columnName)) });
		else if (propertyType == double.class||propertyType == Double.class)
			method.invoke(obj, (Object[]) new Double[] { new Double(rs
					.getDouble(columnName)) });
		else if (propertyType == boolean.class||propertyType == Boolean.class)
			method.invoke(obj, (Object[]) new Boolean[] { new Boolean(rs
					.getBoolean(columnName)) });
		else if (propertyType == Date.class || propertyType == java.sql.Date.class) {
			method.invoke(obj, (Object[]) new Date[] { rs.getDate(columnName) });
		}else if (propertyType == Timestamp.class) {
			method.invoke(obj, (Object[]) new Date[] { rs.getTimestamp(columnName) });
		}
	}
}


