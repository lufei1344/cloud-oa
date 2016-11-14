/*
 *  Copyright 2013-2014 the original author or authors.
 *  *
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * you may not use this file except in compliance with the License.
 *  * You may obtain a copy of the License at
 *  *
 *  *     http://www.apache.org/licenses/LICENSE-2.0
 *  *
 *  * Unless required by applicable law or agreed to in writing, software
 *  * distributed under the License is distributed on an "AS IS" BASIS,
 *  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  * See the License for the specific language governing permissions and
 *  * limitations under the License.
 *
 */

package com.cloudoa.framework.orm;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 * Jdbc的工具类
 * @author yuqs
 * @since 1.0
 */
public class JdbcUtils {
    private static Properties databaseTypeMappings = getDefaultDatabaseTypeMappings();
    private static Logger logger = Logger.getLogger(JdbcUtils.class);

    private static Properties getDefaultDatabaseTypeMappings() {
        Properties databaseTypeMappings = new Properties();
        databaseTypeMappings.setProperty("H2","h2");
        databaseTypeMappings.setProperty("MySQL","mysql");
        databaseTypeMappings.setProperty("Oracle","oracle");
        databaseTypeMappings.setProperty("PostgreSQL","postgres");
        databaseTypeMappings.setProperty("Microsoft SQL Server","mssql");
        return databaseTypeMappings;
    }

    /**
     * 根据连接对象获取数据库类型
     * @param conn 数据库连接
     * @return 类型
     * @throws Exception
     */
    public static String getDatabaseType(Connection conn) throws Exception {
        DatabaseMetaData databaseMetaData = conn.getMetaData();
        String databaseProductName = databaseMetaData.getDatabaseProductName();
        return databaseTypeMappings.getProperty(databaseProductName);
    }
    /**
	 * 批量执行
	 * 
	 * @param sqls
	 * @param params
	 * @return
	 */
	public static boolean execUpdates(JdbcTemplate jdbcTemplate,String[] sql, List<List<Object>>...  params) {
		List<Object> p;
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = jdbcTemplate.getDataSource().getConnection();
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
	public static List<String> getColumnName(JdbcTemplate jdbcTemplate,String sql, List<Object> params) {
		logger.info("sql=[" + sql + "]" + ",params=" + params);
		List<String> list = new ArrayList<String>();
		ResultSet rs = null;
		Statement stmt = null;
		Connection conn = null;
		try {
			conn = jdbcTemplate.getDataSource().getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if (rs != null) {
				ResultSetMetaData meta = rs.getMetaData();
				for (int i = 1; i <= meta.getColumnCount(); i++) {
					list.add(meta.getColumnLabel(i).toLowerCase());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResultSet(rs);
			closeStatement(stmt);
			closeConnection(conn);
		}
		return list;
	}
	public static void closePreparedStatement(PreparedStatement pstmt) {
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

	public static void closeConnection(Connection connection) {
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public static void closeResultSet(ResultSet rs) {
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
}
