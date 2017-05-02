package kr.or.dgit.ncs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;

import kr.or.dgit.ncs.jdbc.DBCon;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class DataBaseTest {
	private static Connection connection;
	private static String DB_CHECK_SQL = "SELECT EXISTS (SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '%s') AS flag";// 데이터베이스 존재 확인
	private static String TABLE_CHECK_SQL = "SELECT EXISTS (SELECT 1 FROM Information_schema.tables WHERE table_name = '%s' AND table_schema = '%s' ) AS flag";// 데이터베이스내 테이블 확인
	private static String DB_NAME = "ncs_erp";
	private static String[] TBL_NAMES = {"employee", "department", "title"};
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		connection = DBCon.getConnection();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
		connection = null;
	}

	@Test
	public void aTestDBConnection() {
		Assert.assertNotNull(connection);
	}

	@Test
	public void bTestDBExists() throws SQLException{
		int exist = getQueryResult(String.format(DB_CHECK_SQL, DB_NAME));
		
		Assert.assertEquals(1, exist);
	}
	
	@Test
	public void cTestEmployeeTableExists() throws SQLException{
		int exist = getQueryResult(String.format(TABLE_CHECK_SQL, TBL_NAMES[0], DB_NAME));
		Assert.assertEquals(1, exist);
	}
	
	@Test
	public void dTestDepartmentTableExists() throws SQLException{
		int exist = getQueryResult(String.format(TABLE_CHECK_SQL, TBL_NAMES[1], DB_NAME));
		Assert.assertEquals(1, exist);
	}
	
	@Test
	public void eTestTitleTableExists() throws SQLException{
		int exist = getQueryResult(String.format(TABLE_CHECK_SQL, TBL_NAMES[2], DB_NAME));
		Assert.assertEquals(1, exist);
	}

	private int getQueryResult(String sql) throws SQLException {
		int result = 0;
		PreparedStatement pstmt = connection.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()){
			result = rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		return result;
	}
}
