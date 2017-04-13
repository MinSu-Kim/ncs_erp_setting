package kr.or.dgit.ncs.jdbc;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Dao {
	private static Dao instance = new Dao();

	private Dao() {
	}

	public static Dao getInstance() {
		return instance;
	}

	private PreparedStatement createPstmtSql(String sql, Object... objects) throws SQLException {
		PreparedStatement pStmt = DBCon.getConnection().prepareStatement(sql);

		for (int i = 0; i < objects.length; i++) {
			pStmt.setObject(i + 1, objects[i]);
		}

		return pStmt;
	}

	public ResultSet execQueryRes(String sql, Object... objects) throws SQLException  {
		try {
			PreparedStatement pstmt = createPstmtSql(sql, objects);
			ResultSet rs = pstmt.executeQuery();
			return rs;
		} finally {
			
		}
	}

	public int execUpdateRes(String sql, Object... objects) throws SQLException {
		try (PreparedStatement pstmt = createPstmtSql(sql, objects)) {
			return pstmt.executeUpdate();
		}
	}

	public int execQueryCnt(String sql, Object... objects) throws SQLException {
		try (PreparedStatement pstmt = createPstmtSql(sql, objects);) {
			pstmt.execute();
			int res = pstmt.getUpdateCount();
			return res;
		}
	}
}
