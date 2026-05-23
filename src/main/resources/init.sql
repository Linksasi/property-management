-- =============================================
-- 小区物业管理系统 - 数据库初始化脚本
-- 数据库名: PropertyManagementDB
-- 对应文档: 数据库表结构_最终版.md
-- =============================================

-- 创建数据库
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PropertyManagementDB')
BEGIN
    CREATE DATABASE PropertyManagementDB;
END
GO

USE PropertyManagementDB;
GO

-- =============================================
-- 公共基础表（系统用户、住户、房屋）
-- =============================================

-- 1. SystemUser（统一用户登录表）
CREATE TABLE SystemUser (
    user_id VARCHAR(20) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    user_type NVARCHAR(20) NOT NULL,
    real_name NVARCHAR(50),
    phone VARCHAR(20),
    status NVARCHAR(20) DEFAULT '正常',
    created_at DATETIME DEFAULT GETDATE()
);

-- 2. Resident（住户）
CREATE TABLE Resident (
    resident_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    name NVARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    id_card VARCHAR(18) NOT NULL UNIQUE,
    check_in_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES SystemUser(user_id)
);

-- 3. Housing（住房）
CREATE TABLE Housing (
    housing_id VARCHAR(20) PRIMARY KEY,
    building VARCHAR(10) NOT NULL,
    unit VARCHAR(10) NOT NULL,
    room_no VARCHAR(10) NOT NULL,
    area DECIMAL(10,2) NOT NULL,
    floor INT NOT NULL,
    house_type NVARCHAR(20) NOT NULL
);

-- 4. ResidentHousing（住户住房关联表）
CREATE TABLE ResidentHousing (
    resident_id VARCHAR(20),
    housing_id VARCHAR(20),
    start_date DATE,
    end_date DATE,
    is_owner BIT DEFAULT 0,
    PRIMARY KEY (resident_id, housing_id),
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id),
    FOREIGN KEY (housing_id) REFERENCES Housing(housing_id)
);

-- =============================================
-- 工作人员管理模块
-- =============================================

-- 5. WorkType（工种）
CREATE TABLE WorkType (
    worktype_id VARCHAR(20) PRIMARY KEY,
    worktype_name NVARCHAR(50) NOT NULL
);

-- 6. WorkLocation（工作地点）
CREATE TABLE WorkLocation (
    location_id VARCHAR(20) PRIMARY KEY,
    location_name NVARCHAR(50) NOT NULL
);

-- 7. Staff（工作人员，含管理员）
CREATE TABLE Staff (
    staff_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    name NVARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    id_card VARCHAR(18) NOT NULL UNIQUE,
    worktype_id VARCHAR(20),
    is_admin BIT DEFAULT 0,
    status NVARCHAR(20) DEFAULT '在职',
    FOREIGN KEY (user_id) REFERENCES SystemUser(user_id),
    FOREIGN KEY (worktype_id) REFERENCES WorkType(worktype_id)
);

-- 8. ShiftRecord（排班记录）
CREATE TABLE ShiftRecord (
    shift_id VARCHAR(20) PRIMARY KEY,
    staff_id VARCHAR(20),
    location_id VARCHAR(20),
    shift_date DATE NOT NULL,
    shift_period NVARCHAR(20) NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (location_id) REFERENCES WorkLocation(location_id)
);

-- =============================================
-- 广告管理模块
-- =============================================

-- 9. ExternalAdCompany（广告公司）
CREATE TABLE ExternalAdCompany (
    company_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(20),
    company_name NVARCHAR(100) NOT NULL,
    contact NVARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES SystemUser(user_id)
);

-- 10. AdStandard（广告收费标准）
CREATE TABLE AdStandard (
    standard_id VARCHAR(20) PRIMARY KEY,
    ad_type NVARCHAR(30) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- 11. AdSlot（广告位）
CREATE TABLE AdSlot (
    slot_id VARCHAR(20) PRIMARY KEY,
    location NVARCHAR(100) NOT NULL,
    standard_id VARCHAR(20),
    status NVARCHAR(20) DEFAULT '空闲',
    FOREIGN KEY (standard_id) REFERENCES AdStandard(standard_id)
);

-- 12. AdApplication（广告入驻申请）
CREATE TABLE AdApplication (
    app_id VARCHAR(20) PRIMARY KEY,
    ad_content NVARCHAR(500) NOT NULL,
    expect_slot NVARCHAR(100),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    apply_date DATETIME NOT NULL,
    status NVARCHAR(20) NOT NULL,
    slot_id VARCHAR(20),
    company_id VARCHAR(20),
    FOREIGN KEY (slot_id) REFERENCES AdSlot(slot_id),
    FOREIGN KEY (company_id) REFERENCES ExternalAdCompany(company_id)
);

-- 13. ApprovalRecord（审批记录）
CREATE TABLE ApprovalRecord (
    approval_id VARCHAR(20) PRIMARY KEY,
    app_id VARCHAR(20) UNIQUE,
    approval_date DATETIME NOT NULL,
    result NVARCHAR(20) NOT NULL,
    reject_reason NVARCHAR(500),
    FOREIGN KEY (app_id) REFERENCES AdApplication(app_id)
);

-- =============================================
-- 物业费管理模块
-- =============================================

-- 14. PropertyStandard（收费标准）
CREATE TABLE PropertyStandard (
    standard_id VARCHAR(20) PRIMARY KEY,
    fee_type NVARCHAR(30) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    effective_date DATE NOT NULL
);

-- 15. PropertyFeeBatch（物业费批次）
CREATE TABLE PropertyFeeBatch (
    batch_id VARCHAR(20) PRIMARY KEY,
    bill_month VARCHAR(7) NOT NULL,
    create_time DATETIME NOT NULL,
    admin_id VARCHAR(20),
    FOREIGN KEY (admin_id) REFERENCES Staff(staff_id)
);

-- 16. PropertyFeeDetail（物业费明细）
CREATE TABLE PropertyFeeDetail (
    detail_id VARCHAR(20) PRIMARY KEY,
    batch_id VARCHAR(20),
    housing_id VARCHAR(20),
    standard_id VARCHAR(20),
    amount DECIMAL(10,2) NOT NULL,
    status NVARCHAR(20) NOT NULL,
    create_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (batch_id) REFERENCES PropertyFeeBatch(batch_id),
    FOREIGN KEY (housing_id) REFERENCES Housing(housing_id),
    FOREIGN KEY (standard_id) REFERENCES PropertyStandard(standard_id)
);

-- 17. PaymentOrder（支付订单）
CREATE TABLE PaymentOrder (
    order_id VARCHAR(20) PRIMARY KEY,
    detail_id VARCHAR(20),
    pay_method NVARCHAR(20),
    pay_time DATETIME,
    status NVARCHAR(20) NOT NULL,
    FOREIGN KEY (detail_id) REFERENCES PropertyFeeDetail(detail_id)
);

-- 18. ElectronicVoucher（电子凭证）
CREATE TABLE ElectronicVoucher (
    voucher_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    user_id VARCHAR(20) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    create_time DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES PaymentOrder(order_id)
);

-- 19. PropertyFeeAppeal（费用申诉）
CREATE TABLE PropertyFeeAppeal (
    appeal_id VARCHAR(20) PRIMARY KEY,
    detail_id VARCHAR(20),
    user_id VARCHAR(20) NOT NULL,
    reason NVARCHAR(500) NOT NULL,
    appeal_date DATETIME NOT NULL,
    status NVARCHAR(20) NOT NULL,
    FOREIGN KEY (detail_id) REFERENCES PropertyFeeDetail(detail_id)
);

-- 20. CollectionRecord（催缴记录）
CREATE TABLE CollectionRecord (
    record_id VARCHAR(20) PRIMARY KEY,
    detail_id VARCHAR(20),
    user_id VARCHAR(20) NOT NULL,
    method NVARCHAR(20) NOT NULL,
    record_time DATETIME NOT NULL,
    result NVARCHAR(20),
    FOREIGN KEY (detail_id) REFERENCES PropertyFeeDetail(detail_id)
);

-- =============================================
-- 水表与水费管理模块
-- =============================================

-- 21. WaterMeter（水表）
CREATE TABLE WaterMeter (
    meter_id VARCHAR(20) PRIMARY KEY,
    housing_id VARCHAR(20),
    current_read DECIMAL(10,2) NOT NULL,
    last_read DECIMAL(10,2) NOT NULL,
    update_date DATE NOT NULL,
    FOREIGN KEY (housing_id) REFERENCES Housing(housing_id)
);

-- 22. WaterBillingRule（水费阶梯规则）
CREATE TABLE WaterBillingRule (
    rule_id VARCHAR(20) PRIMARY KEY,
    base_price DECIMAL(10,2) NOT NULL,
    boost_price DECIMAL(10,2) NOT NULL,
    tier1_limit DECIMAL(10,2) NOT NULL,
    tier2_limit DECIMAL(10,2) NOT NULL,
    tier3_price DECIMAL(10,2) NOT NULL,
    effective_date DATE NOT NULL
);

-- 23. WaterFeeBill（水费账单）
CREATE TABLE WaterFeeBill (
    bill_id VARCHAR(20) PRIMARY KEY,
    meter_id VARCHAR(20),
    bill_month VARCHAR(7) NOT NULL,
    usage DECIMAL(10,2) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status NVARCHAR(20) NOT NULL,
    create_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (meter_id) REFERENCES WaterMeter(meter_id)
);

-- =============================================
-- 维修管理模块
-- =============================================

-- 24. RepairRequest（维修申请表）
CREATE TABLE RepairRequest (
    request_id    VARCHAR(20)   NOT NULL PRIMARY KEY,
    user_id       VARCHAR(20)   FOREIGN KEY REFERENCES SystemUser(user_id),
    housing_id    VARCHAR(20)   FOREIGN KEY REFERENCES Housing(housing_id),
    repair_type   NVARCHAR(50)  NOT NULL,               -- 水电维修 / 家电维修 / 墙面维修 / 其他
    description   NVARCHAR(500),                        -- 问题描述
    urgency       NVARCHAR(10)  DEFAULT N'普通',         -- 普通 / 紧急
    apply_time    DATETIME      DEFAULT GETDATE(),
    status        NVARCHAR(10)  DEFAULT N'待审核',       -- 待审核 / 已派工 / 审核不通过 / 已取消 / 已完成
    reject_reason NVARCHAR(500) NULL,
    admin_id      VARCHAR(20)   NULL FOREIGN KEY REFERENCES Staff(staff_id)
);

-- 25. MaintenanceWorkOrder（维修工单表）
CREATE TABLE MaintenanceWorkOrder (
    work_order_id  VARCHAR(20)   NOT NULL PRIMARY KEY,
    request_id     VARCHAR(20)   FOREIGN KEY REFERENCES RepairRequest(request_id),
    staff_id       VARCHAR(20)   FOREIGN KEY REFERENCES Staff(staff_id),
    admin_id       VARCHAR(20)   FOREIGN KEY REFERENCES Staff(staff_id),
    assign_time    DATETIME      DEFAULT GETDATE(),
    receive_time   DATETIME      NULL,
    start_time     DATETIME      NULL,
    complete_time  DATETIME      NULL,
    confirm_time   DATETIME      NULL,
    repair_content NVARCHAR(1000) NULL,                 -- 维修工人提交结果
    materials_used NVARCHAR(500)  NULL,                 -- 使用材料
    work_hours     DECIMAL(4,1)  NULL,                   -- 工时
    status         NVARCHAR(10)  DEFAULT N'待接单',      -- 待接单 / 已接单 / 维修中 / 待确认 / 已完成
    rating         INT           NULL,                  -- 评分 1-5
    comment        NVARCHAR(500) NULL                  -- 评价内容
);

-- =============================================
-- 车位管理模块
-- =============================================

-- 26. ParkingSpace（车位表）
CREATE TABLE ParkingSpace (
    space_id    VARCHAR(20)  NOT NULL PRIMARY KEY,
    space_no    VARCHAR(20)  NOT NULL,
    location    NVARCHAR(50) NOT NULL,
    type        NVARCHAR(20),
    status      NVARCHAR(10) DEFAULT N'空闲',
    resident_id VARCHAR(20)  NULL,
    created_at  DATETIME     DEFAULT GETDATE(),
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id)
);

-- 27. ParkingStandard（车位月费标准表）
CREATE TABLE ParkingStandard (
    standard_id    VARCHAR(20)   NOT NULL PRIMARY KEY,
    parking_type   NVARCHAR(50)  NOT NULL,
    price          DECIMAL(10,2) NOT NULL,
    effective_date DATETIME      NULL,
    status         NVARCHAR(10)  DEFAULT N'生效'
);

-- 28. ParkingFeeRecord（车位费记录表）
CREATE TABLE ParkingFeeRecord (
    record_id      VARCHAR(20)   NOT NULL PRIMARY KEY,
    space_id       VARCHAR(20)  NOT NULL,
    bill_month     NVARCHAR(7),
    amount         DECIMAL(10,2) NOT NULL,
    status         NVARCHAR(10)  DEFAULT N'UNPAID',
    create_date    DATETIME      DEFAULT GETDATE(),
    paid_date      DATETIME      NULL,
    pay_method     NVARCHAR(20)  NULL,
    transaction_no VARCHAR(50)   NULL,
    FOREIGN KEY (space_id) REFERENCES ParkingSpace(space_id)
);

-- 29. ParkingApply（车位绑定申请表）
CREATE TABLE ParkingApply (
    apply_id      VARCHAR(20)  NOT NULL PRIMARY KEY,
    space_id      VARCHAR(20)  NOT NULL,
    resident_id   VARCHAR(20)  NOT NULL,
    apply_time    DATETIME     DEFAULT GETDATE(),
    status        NVARCHAR(10) DEFAULT N'待审核',
    admin_id      VARCHAR(20)  NULL,
    audit_time    DATETIME     NULL,
    reject_reason NVARCHAR(500) NULL,
    months        INT          DEFAULT 1,
    FOREIGN KEY (space_id) REFERENCES ParkingSpace(space_id),
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id),
    FOREIGN KEY (admin_id) REFERENCES Staff(staff_id)
);

-- =============================================
-- 创建索引
-- =============================================
CREATE INDEX IX_SystemUser_username ON SystemUser(username);
CREATE INDEX IX_SystemUser_phone ON SystemUser(phone);
CREATE INDEX IX_Staff_worktype ON Staff(worktype_id);
CREATE INDEX IX_PropertyFeeDetail_batch ON PropertyFeeDetail(batch_id);
CREATE INDEX IX_PropertyFeeDetail_housing ON PropertyFeeDetail(housing_id);
CREATE INDEX IX_PropertyFeeDetail_status ON PropertyFeeDetail(status);
CREATE INDEX IX_WaterFeeBill_meter ON WaterFeeBill(meter_id);
CREATE INDEX IX_WaterFeeBill_month ON WaterFeeBill(bill_month);

-- 维修相关索引
CREATE INDEX IX_RepairRequest_resident ON RepairRequest(resident_id);
CREATE INDEX IX_RepairRequest_housing ON RepairRequest(housing_id);
CREATE INDEX IX_RepairRequest_status ON RepairRequest(status);
CREATE INDEX IX_RepairRequest_create_time ON RepairRequest(create_time);
CREATE INDEX IX_MaintenanceWorkOrder_request ON MaintenanceWorkOrder(request_id);
CREATE INDEX IX_MaintenanceWorkOrder_staff ON MaintenanceWorkOrder(staff_id);
CREATE INDEX IX_MaintenanceWorkOrder_status ON MaintenanceWorkOrder(status);

-- 车位相关索引
CREATE INDEX IX_ParkingSpace_status ON ParkingSpace(status);
CREATE INDEX IX_ParkingSpace_resident ON ParkingSpace(resident_id);
CREATE INDEX IX_ParkingStandard_type_status ON ParkingStandard(parking_type, status);
CREATE INDEX IX_ParkingFeeRecord_space ON ParkingFeeRecord(space_id);
CREATE INDEX IX_ParkingFeeRecord_status ON ParkingFeeRecord(status);
CREATE INDEX IX_ParkingApply_space ON ParkingApply(space_id);
CREATE INDEX IX_ParkingApply_resident ON ParkingApply(resident_id);
CREATE INDEX IX_ParkingApply_status ON ParkingApply(status);

-- =============================================
-- 初始化数据
-- =============================================

-- 插入工种
INSERT INTO WorkType (worktype_id, worktype_name) VALUES
('WT001', '维修-水电'),
('WT002', '维修-木工'),
('WT003', '维修-管道'),
('WT004', '保洁'),
('WT005', '安保'),
('WT006', '绿化'),
('WT007', '管理员');

-- 插入工作地点
INSERT INTO WorkLocation (location_id, location_name) VALUES
('LOC001', '客服中心'),
('LOC002', '维修部'),
('LOC003', '保洁部'),
('LOC004', '安保中心');

-- 插入车位月费标准数据
INSERT INTO ParkingStandard (standard_id, parking_type, price, effective_date, status) VALUES
('PS001', N'地下一层A区', 200.00, GETDATE(), N'生效'),
('PS002', N'地下一层B区', 200.00, GETDATE(), N'生效'),
('PS003', N'地下一层C区', 180.00, GETDATE(), N'生效'),
('PS004', N'户外停车场', 100.00, GETDATE(), N'生效');

GO