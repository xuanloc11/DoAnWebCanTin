package Util;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

import com.mysql.cj.jdbc.MysqlDataSource;

public class DataSourceUtil {
    private static final String JNDI_NAME = "java:comp/env/jdbc/cantinDS";
    public static DataSource ds;

    public static synchronized DataSource getDataSource() {
        if (ds == null) {
            // Try JNDI first
            try {
                Context ctx = new InitialContext();
                ds = (DataSource) ctx.lookup(JNDI_NAME);
            } catch (NamingException e) {
                // Fallback for non-container execution (e.g., unit tests, running from main)
                System.err.println("[WARN] JNDI lookup failed for '" + JNDI_NAME + "'. Falling back to direct MySQL DataSource. Cause: " + e.getMessage());
                MysqlDataSource mysql = new MysqlDataSource();
                mysql.setURL("jdbc:mysql://localhost:3306/cantin?useSSL=false&characterEncoding=UTF-8");
                mysql.setUser("root");
                mysql.setPassword("12345");
                ds = mysql;
            }
        }
        return ds;
    }

    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }
}
