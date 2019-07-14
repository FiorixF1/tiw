package start;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;

/**
 * Classe che fornisce un'interfaccia comune per la lettura e la scrittura
 * di dati sul database. Fornisce il metodo executeUpdate per le operazioni
 * di insert, update, delete e il metodo executeQuery per le interrogazioni.
 * Quest'ultimo metodo immagazzina le tuple del ResultSet in un array che
 * viene ritornato al chiamante.
 * @author fiorix
 */

public class DatabaseManager {
	private DatabaseManager() {
		
	}
	
	public static String executeUpdate(String sql, Object... params) {
		Connection conn = null;
		String state = null;
		try {
			conn = DatabaseConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			int index = 1;
			for (Object obj : params) {
				ps.setObject(index, obj);
				++index;
			}
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			state = e.getMessage();
			System.out.println("Errore nell'update del database");
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				;
			}
		}
		return state;
	}
	
	public static List<Map<String, Object>> executeQuery(String sql, Object... params) {
		List<Map<String, Object>> tuples = new ArrayList<Map<String, Object>>();
		Connection conn = null;
		try {
			conn = DatabaseConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			int index = 1;
			for (Object obj : params) {
				ps.setObject(index, obj);
				++index;
			}
			
			ResultSet rs = ps.executeQuery();
			int numberOfColumns = rs.getMetaData().getColumnCount();
			while (rs.next()) {
				Map<String, Object> row = new HashMap<String, Object>();
				for (int col = 1; col <= numberOfColumns; ++col) {
					String columnName = rs.getMetaData().getColumnName(col);
					Object value = rs.getObject(col);
					row.put(columnName, value);
				}
				tuples.add(row);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("Errore nella query al database");
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				;
			}
		}
		return tuples;
	}
}

/**
 * Libreria che gestisce una pool di connessioni al database.
 * DBMS: MySQL
 * Nome DB: tiw
 * Utente: root
 * Password: sweng(Per Ale) / mariadbpass1(Per FIl)
 * @author fiorix
 */

class DatabaseConnection {

	private static DataSource dataSource = null;

	private DatabaseConnection() {
	}
	
	public static synchronized Connection getConnection() throws SQLException {
		Connection connection = null;
		if (dataSource == null) {
			String driver = "com.mysql.jdbc.Driver";
			String url = "jdbc:mysql://localhost:3306/tiw?autoReconnect=true&useSSL=false";
			String user = "root";
			String password = "sweng"; //String password = "mariadbpass1";
			dataSource = setupDataSource(driver, url, user, password);
		}
		try {
			connection = dataSource.getConnection();
		} catch (SQLException e) {			
			e.printStackTrace();
		}
		return connection;
	}

	private static DataSource setupDataSource(String driver, String url, String user, String password) {
		BasicDataSource basicDataSource = new BasicDataSource();
		basicDataSource.setDriverClassName(driver);
		basicDataSource.setUsername(user);
		basicDataSource.setPassword(password);
		basicDataSource.setUrl(url);
		basicDataSource.setMaxActive(10);
		return basicDataSource;
	}

	public static void shutdownDataSource(DataSource dataSource) {
		BasicDataSource basicDataSource = (BasicDataSource)dataSource;
		try {
			basicDataSource.close();
		} catch (SQLException e) {
			System.out.println("È stato riscontrato un problema nella creazione del BasicDataSource");
		}
	}
}