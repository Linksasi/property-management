package com.property.dao;

import com.property.model.ApprovalRecord;
import com.property.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ApprovalRecordDAO {
    public ApprovalRecord getByAppId(String appId) throws SQLException {
        String sql = "SELECT approval_id, app_id, approval_date, result, reject_reason FROM ApprovalRecord WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, appId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ApprovalRecord ar = new ApprovalRecord();
                    ar.setRecordId(rs.getString("approval_id"));
                    ar.setAppId(rs.getString("app_id"));
                    ar.setApproveTime(rs.getTimestamp("approval_date"));
                    ar.setApproveResult(rs.getString("result"));
                    ar.setComments(rs.getString("reject_reason"));
                    return ar;
                }
            }
        }
        return null;
    }

    public void add(ApprovalRecord ar) throws SQLException {
        String sql = "INSERT INTO ApprovalRecord(approval_id, app_id, approval_date, result, reject_reason) VALUES(?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ar.getRecordId());
            stmt.setString(2, ar.getAppId());
            stmt.setTimestamp(3, ar.getApproveTime() != null ? new java.sql.Timestamp(ar.getApproveTime().getTime()) : null);
            stmt.setString(4, ar.getApproveResult());
            stmt.setString(5, ar.getComments());
            stmt.executeUpdate();
        }
    }
}