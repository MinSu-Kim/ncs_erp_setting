package kr.or.dgit.ncs;

import java.sql.Connection;

import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import kr.or.dgit.ncs.jdbc.DBCon;

public class DbConnectionTest {
	private static Connection connection;
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		connection = DBCon.getConnection();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
		connection = null;
	}

	@Test
	public void testConnection() {
		Assert.assertNotNull(connection);
	}

}
