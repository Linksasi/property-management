package com.property.service;

import com.property.dao.WorkTypeDAO;
import com.property.entity.WorkType;

import java.sql.SQLException;
import java.util.List;

public class WorkTypeService {
    private WorkTypeDAO dao = new WorkTypeDAO();

    public List<WorkType> getAll() throws SQLException {
        return dao.getAll();
    }

    public WorkType getById(String id) throws SQLException {
        return dao.getById(id);
    }

    public void add(WorkType wt) throws SQLException {
        dao.add(wt);
    }

    public void update(WorkType wt) throws SQLException {
        dao.update(wt);
    }

    public void delete(String id) throws SQLException {
        dao.delete(id);
    }

    public List<WorkType> findAll() {
        return dao.findAll();
    }

    public List<WorkType> findForStaff() {
        return dao.findForStaff();
    }
}