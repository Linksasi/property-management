package com.property.exception;

/**
 * 数据访问层异常
 * 用于包装 DAO 操作中的数据库异常
 */
public class DataAccessException extends RuntimeException {

    public DataAccessException(String message) {
        super(message);
    }

    public DataAccessException(String message, Throwable cause) {
        super(message, cause);
    }
}
