package com.property.util;

import java.sql.*;
import java.lang.reflect.*;

/**
 * 数据库连接工具类 - ThreadLocal + 事务保护代理
 * 事务中所有 DAO 通过 getConnection() 拿到的都是代理连接，
 * 其 close() 被拦截变为空操作，防止 try-with-resources 误关连接
 */
public class DBUtil {
    private static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=PropertyManagementDB;encrypt=false;trustServerCertificate=true";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "Pass123456";

    private static final ThreadLocal<Connection> threadLocal = new ThreadLocal<>();
    private static final ThreadLocal<Boolean> inTransaction = ThreadLocal.withInitial(() -> false);

    static {
        try { Class.forName(DRIVER); } catch (ClassNotFoundException e) { e.printStackTrace(); }
    }

    public static Connection getConnection() throws SQLException {
        Connection conn = threadLocal.get();
        if (conn != null && inTransaction.get()) {
            return conn;
        }
        if (conn == null) {
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            threadLocal.set(conn);
            return conn;
        }
        try {
            if (conn.isClosed()) {
                conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                threadLocal.set(conn);
            }
        } catch (SQLException e) {
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            threadLocal.set(conn);
        }
        return conn;
    }

    public static void closeConnection() {
        if (inTransaction.get()) return;
        Connection conn = threadLocal.get();
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            threadLocal.remove();
        }
    }

    public static void beginTransaction() throws SQLException {
        Connection raw = getConnection();
        raw.setAutoCommit(false);
        inTransaction.set(true);
        Connection proxy = wrap(raw);
        threadLocal.set(proxy);
    }

    public static void commit() throws SQLException {
        Connection conn = threadLocal.get();
        inTransaction.remove();
        threadLocal.remove();
        if (conn != null) {
            try { conn.commit(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public static void rollback() {
        inTransaction.remove();
        Connection conn = threadLocal.get();
        threadLocal.remove();
        if (conn != null) {
            try { conn.rollback(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public static String testConnection() {
        try (Connection c = DriverManager.getConnection(URL, USERNAME, PASSWORD)) {
            return c != null && !c.isClosed() ? "SUCCESS|数据库连接成功！" : "ERROR|连接失败";
        } catch (SQLException e) {
            return "ERROR|连接异常: " + e.getMessage();
        }
    }

    private static Connection wrap(Connection real) {
        return (Connection) Proxy.newProxyInstance(Connection.class.getClassLoader(),
            new Class<?>[] { Connection.class },
            new InvocationHandler() {
                public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                    String name = method.getName();
                    if ("close".equals(name)) {
                        return null;
                    }
                    if ("isClosed".equals(name)) {
                        return false;
                    }
                    return method.invoke(real, args);
                }
            });
    }
}