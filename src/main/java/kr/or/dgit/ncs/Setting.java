package kr.or.dgit.ncs;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import kr.or.dgit.ncs.jdbc.Dao;
import kr.or.dgit.ncs.jdbc.JdbcUtil;
import kr.or.dgit.ncs.jdbc.LoadProperties;

public class Setting {

	private static Setting instance = new Setting();
	private LoadProperties loadProp;
	private Properties propSql;
	
	private String[] createDbSql;
	private String[] createTblSql;
	private String[] tbl_name;
	private String importDir;
	private String exportDir;
	private String grantSql;
	private String user;
	
	private Dao dao;
	
	private Setting() {
		loadProp = new LoadProperties("resources/sql.properties");
		propSql = loadProp.getConfProp();
		dao = Dao.getInstance();
		
		createDbSql = propSql.getProperty("database").split("#");
		createTblSql = propSql.getProperty("table").split("#");
		tbl_name =  propSql.getProperty("tbl_name").split("#");
		
		importDir=propSql.getProperty("import_dir");
		exportDir=System.getProperty("user.dir")+propSql.getProperty("export_dir");
		
		grantSql = propSql.getProperty("grant");
		user = propSql.getProperty("user");
	}

	public static Setting getInstance() {
		return instance;
	}

	public void initSetting() {
		initDatabase();
		setForeignKeyCheck(0);
		createTable();
		setForeignKeyCheck(1);	
		createUser();
	}
	
	private void createUser() {
		try {
			dao.execQueryCnt(String.format(grantSql, propSql.getProperty("db_name"), user, user));		
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void initDatabase(){
		try {
			for(int i=0; i<createDbSql.length; i++){
				System.out.println(String.format(createDbSql[i], propSql.getProperty("db_name")));
				dao.execQueryCnt(String.format(createDbSql[i], propSql.getProperty("db_name")));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	private void createTable() {
		for(int i=0; i<createTblSql.length; i++){
			try {
				dao.execUpdateRes(createTblSql[i]);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
	}
	
	public void executeLoadData() {
		for(int i=0; i<createTblSql.length; i++){
			try {
				int res = dao.execUpdateRes(String.format(propSql.getProperty("import"),getFilePath(tbl_name[i], true), tbl_name[i]));
				System.out.printf("Import Table(%s) %d Rows Success! %n",tbl_name[i], res);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
	}
	
	private void setForeignKeyCheck(int isCheck){
		try{
			dao.execUpdateRes("SET FOREIGN_KEY_CHECKS = ?", isCheck);
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	private String getFilePath(String tableName, boolean isImport) {
		StringBuilder sb = new StringBuilder();
		sb.append(isImport ? System.getProperty("user.dir"):"");
		sb.append(isImport ? importDir : exportDir).append(tableName).append(".txt");
		return sb.toString().replace("\\", "/");
	}
	
		
	public void executeSaveData(){		
		checkBackupDir();
		for (String tableName : tbl_name) {
			String sql = String.format(propSql.getProperty("export"), propSql.getProperty("db_name")+"."+tableName);
			exportData(sql, getFilePath(tableName, false), tableName);
		}
	}
	
	public void exportData(String sql, String exportPath, String tblName){
		StringBuilder sb = new StringBuilder();
		ResultSet rs = null;
		try {
			rs = dao.execQueryRes(sql);
			int colCnt = rs.getMetaData().getColumnCount();// 컬럼의 개수
			int rowCnt=0;
			while (rs.next()) {
				rowCnt++;
				for (int i = 1; i <= colCnt; i++) { // 'A001',아메리카노,
					sb.append(rs.getObject(i) + ",");
				}
				sb.replace(sb.length() - 1, sb.length(), ""); // 마지막 라인의 comma 제거
				sb.append("\r\n");
			}
//			sb.replace(sb.length() - 2, sb.length(), ""); //마지막 줄의 개행 제거
			
			backupFileWrite(sb.toString(), exportPath);
			System.out.printf("Export Table(%s) %d Rows Success! %n",tblName, rowCnt);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(rs);
		}
	}
	
	private void backupFileWrite(String str, String exportPath) throws UnsupportedEncodingException, FileNotFoundException, IOException {
		try(OutputStreamWriter dos = new OutputStreamWriter(new FileOutputStream(exportPath),"UTF-8")){
			dos.write(str);
		} 	
	}

	private void checkBackupDir() {
		File backupDir = new File(exportDir);
		if (backupDir.exists()) {
			for (File file : backupDir.listFiles()) {
				file.delete();
				System.out.printf("%s Delete Success! %n", file.getName());
			}
		} else {
			backupDir.mkdir();
			System.out.printf("%s make dir Success! %n", exportDir);
		}
	}

}
