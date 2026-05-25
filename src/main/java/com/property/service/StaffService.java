package com.property.service;

import com.property.dao.StaffDAO;
import com.property.entity.Staff;

import java.sql.SQLException;
import java.util.List;

public class StaffService {
    private StaffDAO dao = new StaffDAO();

    public List<Staff> getAll() throws SQLException {
        return dao.getAll();
    }

    public Staff getById(String id) throws SQLException {
        return dao.getById(id);
    }

    public void add(Staff staff) throws SQLException {
        // 生成ID
        if (staff.getStaffId() == null || staff.getStaffId().isEmpty()) {
            staff.setStaffId(dao.generateId());
        }
        dao.insert(staff);
    }

    public void update(Staff staff) throws SQLException {
        dao.update(staff);
    }

    public void delete(String id) throws SQLException {
        dao.delete(id);
    }

    public Staff findByUserId(String userId) {
        return dao.findByUserId(userId);
    }

    public List<Staff> findAllNonAdmin() {
        return dao.findAllNonAdmin();
    }
}