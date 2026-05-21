-- =============================================
-- 小区物业管理系统 - 数据库初始化脚本
-- 数据库名: PropertyManagementDB
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

-- 系统用户表
CREATE TABLE SystemUser (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    user_type VARCHAR(20) NOT NULL,  -- admin, staff, resident
    create_time DATETIME DEFAULT GETDATE()
);

-- 住户表
CREATE TABLE Resident (
    resident_id INT PRIMARY KEY IDENTITY(1,1),
    resident_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    phone VARCHAR(20),
    id_card VARCHAR(18),
    create_time DATETIME DEFAULT GETDATE()
);

-- 房屋表
CREATE TABLE Housing (
    building VARCHAR(20),      -- 楼栋
    unit VARCHAR(10),           -- 单元
    room_no VARCHAR(20),        -- 房号
    area DECIMAL(10,2),        -- 面积
    PRIMARY KEY (building, unit, room_no)
);

-- 住户-房屋关联表
CREATE TABLE ResidentHousing (
    resident_id INT,
    building VARCHAR(20),
    unit VARCHAR(10),
    room_no VARCHAR(20),
    relationship VARCHAR(20),  -- owner, tenant
    start_date DATE,
    PRIMARY KEY (resident_id, building, unit, room_no),
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id)
);

-- =============================================
-- 工作人员表（管理员 + 员工 合并）
-- =============================================

-- 工种表
CREATE TABLE WorkType (
    work_type_id INT PRIMARY KEY IDENTITY(1,1),
    work_type_name VARCHAR(50) NOT NULL,
    description VARCHAR(200)
);

-- 工作地点表
CREATE TABLE WorkLocation (
    location_id INT PRIMARY KEY IDENTITY(1,1),
    location_name VARCHAR(100) NOT NULL,
    address VARCHAR(200)
);

-- 员工表（is_admin=1管理员, is_admin=0员工, work_type_id区分工种）
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY IDENTITY(1,1),
    staff_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(100),
    work_type_id INT,
    location_id INT,
    is_admin INT DEFAULT 0,  -- 1=管理员, 0=普通员工
    create_time DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (work_type_id) REFERENCES WorkType(work_type_id),
    FOREIGN KEY (location_id) REFERENCES WorkLocation(location_id)
);

-- 考勤记录表
CREATE TABLE ShiftRecord (
    shift_id INT PRIMARY KEY IDENTITY(1,1),
    staff_id INT NOT NULL,
    shift_date DATE NOT NULL,
    check_in_time DATETIME,
    check_out_time DATETIME,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- =============================================
-- 物业费模块
-- =============================================

-- 物业费标准表
CREATE TABLE PropertyStandard (
    standard_id INT PRIMARY KEY IDENTITY(1,1),
    housing_type VARCHAR(20),  -- 普通, 高档, 别墅
    price_per_area DECIMAL(10,4) NOT NULL,  -- 元/平方米
    description VARCHAR(200)
);

-- 物业费批次表（按年月生成）
CREATE TABLE PropertyFeeBatch (
    batch_id INT PRIMARY KEY IDENTITY(1,1),
    year_month VARCHAR(7) NOT NULL,  -- 2024-01
    generate_date DATE,
    total_amount DECIMAL(12,2),
    status VARCHAR(20) DEFAULT 'pending'
);

-- 物业费明细表
CREATE TABLE PropertyFeeDetail (
    detail_id INT PRIMARY KEY IDENTITY(1,1),
    batch_id INT,
    building VARCHAR(20),
    unit VARCHAR(10),
    room_no VARCHAR(20),
    area DECIMAL(10,2),
    unit_price DECIMAL(10,4),
    total_fee DECIMAL(10,2),
    is_paid INT DEFAULT 0,  -- 0未缴, 1已缴
    due_date DATE,
    paid_date DATETIME,
    FOREIGN KEY (batch_id) REFERENCES PropertyFeeBatch(batch_id)
);

-- 缴费订单表
CREATE TABLE PaymentOrder (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    fee_type VARCHAR(20),  -- property, water, parking
    order_no VARCHAR(50) UNIQUE,
    resident_id INT,
    amount DECIMAL(10,2),
    payment_method VARCHAR(20),
    payment_time DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id)
);

-- 电子凭证表
CREATE TABLE ElectronicVoucher (
    voucher_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    file_path VARCHAR(200),
    upload_time DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES PaymentOrder(order_id)
);

-- 物业费申诉表
CREATE TABLE PropertyFeeAppeal (
    appeal_id INT PRIMARY KEY IDENTITY(1,1),
    detail_id INT,
    resident_id INT,
    appeal_reason VARCHAR(500),
    appeal_time DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'pending',  -- pending, approved, rejected
    handle_time DATETIME,
    handle_result VARCHAR(200),
    FOREIGN KEY (detail_id) REFERENCES PropertyFeeDetail(detail_id),
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id)
);

-- 催缴记录表
CREATE TABLE CollectionRecord (
    record_id INT PRIMARY KEY IDENTITY(1,1),
    detail_id INT,
    staff_id INT,
    contact_time DATETIME,
    contact_result VARCHAR(200),
    FOREIGN KEY (detail_id) REFERENCES PropertyFeeDetail(detail_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- =============================================
-- 水费模块
-- =============================================

-- 水表表
CREATE TABLE WaterMeter (
    meter_id INT PRIMARY KEY IDENTITY(1,1),
    building VARCHAR(20),
    unit VARCHAR(10),
    room_no VARCHAR(20),
    meter_no VARCHAR(50) UNIQUE,
    install_date DATE,
    status VARCHAR(20) DEFAULT 'active'
);

-- 水费计费规则表
CREATE TABLE WaterBillingRule (
    rule_id INT PRIMARY KEY IDENTITY(1,1),
    tier_name VARCHAR(50),
    min_usage INT,  -- 吨
    max_usage INT,
    price_per_ton DECIMAL(10,4),
    effective_date DATE
);

-- 水费账单表
CREATE TABLE WaterFeeBill (
    bill_id INT PRIMARY KEY IDENTITY(1,1),
    meter_id INT,
    year_month VARCHAR(7),
    previous_reading INT,
    current_reading INT,
    usage_tons INT,
    amount DECIMAL(10,2),
    is_paid INT DEFAULT 0,
    due_date DATE,
    paid_date DATETIME,
    FOREIGN KEY (meter_id) REFERENCES WaterMeter(meter_id)
);

-- =============================================
-- 车位费模块
-- =============================================

-- 车位表
CREATE TABLE ParkingSpace (
    space_id INT PRIMARY KEY IDENTITY(1,1),
    space_code VARCHAR(20) UNIQUE,  -- A001
    space_type VARCHAR(20),  -- ground, underground, mechanical
    status VARCHAR(20) DEFAULT 'available',  -- available, occupied, reserved
    building VARCHAR(20),
    monthly_fee DECIMAL(10,2)
);

-- 车位费标准表
CREATE TABLE ParkingStandard (
    standard_id INT PRIMARY KEY IDENTITY(1,1),
    space_type VARCHAR(20),
    monthly_fee DECIMAL(10,2),
    yearly_fee DECIMAL(10,2),
    description VARCHAR(200)
);

-- 车位费记录表
CREATE TABLE ParkingFeeRecord (
    record_id INT PRIMARY KEY IDENTITY(1,1),
    space_id INT,
    resident_id INT,
    year_month VARCHAR(7),
    fee_amount DECIMAL(10,2),
    is_paid INT DEFAULT 0,
    due_date DATE,
    paid_date DATETIME,
    FOREIGN KEY (space_id) REFERENCES ParkingSpace(space_id),
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id)
);

-- =============================================
-- 维修模块
-- =============================================

-- 维修申请表
CREATE TABLE RepairRequest (
    request_id INT PRIMARY KEY IDENTITY(1,1),
    resident_id INT,
    building VARCHAR(20),
    unit VARCHAR(10),
    room_no VARCHAR(20),
    repair_type VARCHAR(50),
    description VARCHAR(500),
    request_time DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'pending',  -- pending, assigned, in_progress, completed, cancelled
    urgency_level INT DEFAULT 2,  -- 1=紧急, 2=一般, 3=不急
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id)
);

-- 维修工单表
CREATE TABLE MaintenanceWorkOrder (
    work_order_id INT PRIMARY KEY IDENTITY(1,1),
    request_id INT,
    staff_id INT,
    assign_time DATETIME,
    start_time DATETIME,
    complete_time DATETIME,
    result_description VARCHAR(500),
    score INT,  -- 住户评分 1-5
    FOREIGN KEY (request_id) REFERENCES RepairRequest(request_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- =============================================
-- 广告模块
-- =============================================

-- 广告公司表
CREATE TABLE ExternalAdCompany (
    company_id INT PRIMARY KEY IDENTITY(1,1),
    company_name VARCHAR(100),
    contact_person VARCHAR(50),
    phone VARCHAR(20),
    address VARCHAR(200),
    credit_level VARCHAR(10)
);

-- 广告位标准表
CREATE TABLE AdSlot (
    slot_id INT PRIMARY KEY IDENTITY(1,1),
    slot_code VARCHAR(20) UNIQUE,
    slot_type VARCHAR(50),  -- billboard, doorframe, elevator
    location_description VARCHAR(200),
    width DECIMAL(10,2),
    height DECIMAL(10,2),
    standard_fee DECIMAL(10,2)  -- 元/月
);

-- 广告位申请审批表
CREATE TABLE AdApplication (
    application_id INT PRIMARY KEY IDENTITY(1,1),
    company_id INT,
    slot_id INT,
    ad_content VARCHAR(500),
    start_date DATE,
    end_date DATE,
    fee_amount DECIMAL(10,2),
    application_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (company_id) REFERENCES ExternalAdCompany(company_id),
    FOREIGN KEY (slot_id) REFERENCES AdSlot(slot_id)
);

-- 审批记录表
CREATE TABLE ApprovalRecord (
    record_id INT PRIMARY KEY IDENTITY(1,1),
    application_id INT,
    approver_id INT,
    approve_time DATETIME,
    approve_result VARCHAR(20),  -- approved, rejected
    comments VARCHAR(200),
    FOREIGN KEY (application_id) REFERENCES AdApplication(application_id),
    FOREIGN KEY (approver_id) REFERENCES Staff(staff_id)
);

-- =============================================
-- 初始化数据
-- =============================================

-- 插入工种
INSERT INTO WorkType (work_type_name, description) VALUES
('管理员', '系统管理员'),
('维修工', '负责维修'),
('保洁员', '负责清洁'),
('保安', '负责安保');

-- 插入工作地点
INSERT INTO WorkLocation (location_name, address) VALUES
('客服中心', '小区南门'),
('维修部', '地下室'),
('保洁部', '物资仓库'),
('安保中心', '北门');

GO