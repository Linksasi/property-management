package com.property.service;

import com.property.dao.AdSlotDAO;
import com.property.model.AdSlot;

import java.sql.SQLException;
import java.util.List;

public class AdSlotService {
    private AdSlotDAO dao = new AdSlotDAO();

    public List<AdSlot> getAll() throws SQLException {
        return dao.getAll();
    }

    public AdSlot getById(String id) throws SQLException {
        return dao.getById(id);
    }

    public void add(AdSlot slot) throws SQLException {
        dao.add(slot);
    }

    public void update(AdSlot slot) throws SQLException {
        dao.update(slot);
    }

    public void delete(String id) throws SQLException {
        dao.delete(id);
    }
}