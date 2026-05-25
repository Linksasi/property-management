package com.property.service;

import com.property.dao.ShiftRecordDAO;
import com.property.model.ShiftRecord;

import java.sql.SQLException;
import java.util.List;

public class ShiftRecordService {
    private ShiftRecordDAO dao = new ShiftRecordDAO();

    public List<ShiftRecord> getAll() throws SQLException {
        return dao.getAll();
    }

    public List<ShiftRecord> getByStaffId(String staffId) throws SQLException {
        return dao.getByStaffId(staffId);
    }

    public ShiftRecord getById(String id) throws SQLException {
        return dao.getById(id);
    }

    public int add(ShiftRecord sr) throws SQLException {
        return dao.add(sr);
    }

    public void update(ShiftRecord sr) throws SQLException {
        dao.update(sr);
    }

    public void delete(String id) throws SQLException {
        dao.delete(id);
    }
}