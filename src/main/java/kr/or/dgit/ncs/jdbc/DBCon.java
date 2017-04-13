package kr.or.dgit.ncs.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBCon {
	private static DBCon instance = new DBCon();
	private static Connection con;
	private LoadProperties prop;
	private Properties properties;
	
	private DBCon() {
		try {
			prop = new LoadProperties("resources/conf.properties");
			properties = prop.getConfProp();
			con = DriverManager.getConnection(properties.getProperty("url"), properties.getProperty("user"), properties.getProperty("pwd"));
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static Connection getConnection() {
		if (instance == null) {
			new DBCon();
		}
		return DBCon.con;
	}

	public static void close() {
		if (con != null){
			try {
				con.close();
				con = null;
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}		
	}
	
}
