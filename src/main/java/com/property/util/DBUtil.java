package com.property.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 数据库连接工具类 - ThreadLocal模式
 */
public class DBUtil {
    private static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=PropertyManagementDB;encrypt=false;trustServerCertificate=true";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "Pass123456";

    private static final ThreadLocal<Connection> threadLocal = new ThreadLocal<>();

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        Connection conn = threadLocal.get();
        if (conn == null || conn.isClosed()) {
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            threadLocal.set(conn);
        }
        return conn;
    }

    public static void closeConnection() {
        Connection conn = threadLocal.get();
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            threadLocal.remove();
        }
    }

    public static void beginTransaction() throws SQLException {
        Connection conn = getConnection();
        conn.setAutoCommit(false);
    }

    public static void commit() throws SQLException {
        Connection conn = getConnection();
        conn.commit();
        conn.setAutoCommit(true);
    }

    public static void rollback() {
        Connection conn = threadLocal.get();
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 测试数据库连接，返回格式：SUCCESS|消息 或 ERROR|消息
     */
    public static String testConnection() {
        try (Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD)) {
            if (conn != null && !conn.isClosed()) {
                return "SUCCESS|数据库连接成功！";
            }
            return "ERROR|连接失败";
        } catch (SQLException e) {
            return "ERROR|连接异常: " + e.getMessage();
        }
    }
}