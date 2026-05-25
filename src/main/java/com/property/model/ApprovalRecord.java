package com.property.model;

import java.util.Date;

public class ApprovalRecord {
    private String recordId;
    private String appId;
    private String approverId;
    private Date approveTime;
    private String approveResult;
    private String comments;

    public ApprovalRecord() {}

    public String getRecordId() { return recordId; }
    public void setRecordId(String recordId) { this.recordId = recordId; }

    public String getAppId() { return appId; }
    public void setAppId(String appId) { this.appId = appId; }

    public String getApproverId() { return approverId; }
    public void setApproverId(String approverId) { this.approverId = approverId; }

    public Date getApproveTime() { return approveTime; }
    public void setApproveTime(Date approveTime) { this.approveTime = approveTime; }

    public String getApproveResult() { return approveResult; }
    public void setApproveResult(String approveResult) { this.approveResult = approveResult; }

    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }
}