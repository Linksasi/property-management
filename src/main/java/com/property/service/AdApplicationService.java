package com.property.service;

import com.property.dao.AdApplicationDAO;
import com.property.dao.ApprovalRecordDAO;
import com.property.model.AdApplication;
import com.property.model.ApprovalRecord;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class AdApplicationService {
    private AdApplicationDAO appDao = new AdApplicationDAO();
    private ApprovalRecordDAO approvalDao = new ApprovalRecordDAO();

    public List<AdApplication> getAll() throws SQLException {
        return appDao.getAll();
    }

    public List<AdApplication> getByCompanyId(String companyId) throws SQLException {
        return appDao.getByCompanyId(companyId);
    }

    public AdApplication getById(String id) throws SQLException {
        return appDao.getById(id);
    }

    public void add(AdApplication app) throws SQLException {
        app.setApplyDate(new Date());
        app.setStatus("待审核");
        appDao.add(app);
    }

    public void update(AdApplication app) throws SQLException {
        appDao.update(app);
    }

    public List<AdApplication> getBySlotId(String slotId) throws SQLException {
        return appDao.getBySlotId(slotId);
    }

    public boolean hasTimeConflict(String slotId, Date startDate, Date endDate, String excludeAppId) throws SQLException {
        return appDao.hasTimeConflict(slotId, startDate, endDate, excludeAppId);
    }

    public void approve(String appId, String slotId) throws SQLException {
        AdApplication app = appDao.getById(appId);
        if (app != null) {
            app.setStatus("已通过");
            app.setSlotId(slotId);
            appDao.update(app);

            ApprovalRecord ar = new ApprovalRecord();
            ar.setRecordId("AR" + System.currentTimeMillis());
            ar.setAppId(appId);
            ar.setApproveTime(new Date());
            ar.setApproveResult("approved");
            approvalDao.add(ar);
        }
    }

    public void reject(String appId, String comments) throws SQLException {
        AdApplication app = appDao.getById(appId);
        if (app != null) {
            app.setStatus("已驳回");
            appDao.update(app);

            ApprovalRecord ar = new ApprovalRecord();
            ar.setRecordId("AR" + System.currentTimeMillis());
            ar.setAppId(appId);
            ar.setApproveTime(new Date());
            ar.setApproveResult("rejected");
            ar.setComments(comments);
            approvalDao.add(ar);
        }
    }
}