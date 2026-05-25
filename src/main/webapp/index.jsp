<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>物业管理系统 - 测试入口</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", Arial, sans-serif; background: #f0f2f5; min-height: 100vh; }
        .page-header { background: linear-gradient(135deg, #1B5E20, #2E7D32); color: white; padding: 24px; text-align: center; }
        .page-header h1 { font-size: 24px; }
        .page-header p { font-size: 13px; opacity: 0.85; margin-top: 4px; }
        .container { max-width: 1100px; margin: 24px auto; padding: 0 20px; }
        .card { background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .card-header { padding: 16px 20px; border-bottom: 1px solid #e8e8e8; font-size: 16px; font-weight: bold; color: #333; display: flex; justify-content: space-between; align-items: center; }
        .card-body { padding: 20px; }

        .btn { padding: 8px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; display: inline-flex; align-items: center; gap: 6px; }
        .btn-primary { background: #2E7D32; color: white; }
        .btn-primary:hover { background: #1B5E20; }
        .btn-blue { background: #1976D2; color: white; }
        .btn-blue:hover { background: #1565C0; }
        .btn-orange { background: #FF6F00; color: white; }
        .btn-orange:hover { background: #E65100; }
        .btn-outline { background: white; color: #2E7D32; border: 1px solid #2E7D32; }
        .btn-outline:hover { background: #E8F5E9; }
        .btn:disabled { opacity: 0.5; cursor: not-allowed; }

        .status-bar { padding: 10px 16px; border-radius: 4px; margin-bottom: 12px; font-size: 13px; display: none; }
        .status-success { background: #E8F5E9; color: #2E7D32; border: 1px solid #A5D6A7; }
        .status-error { background: #FFEBEE; color: #C62828; border: 1px solid #EF9A9A; }

        .form-row { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 12px; }
        .form-group { flex: 1; min-width: 160px; }
        .form-group label { display: block; font-size: 13px; color: #666; margin-bottom: 4px; }
        .form-group input, .form-group select { width: 100%; padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #2E7D32; }

        table { width: 100%; border-collapse: collapse; }
        th { background: #fafafa; padding: 10px 12px; text-align: left; font-size: 13px; color: #666; border-bottom: 2px solid #e8e8e8; }
        td { padding: 10px 12px; border-bottom: 1px solid #f0f0f0; font-size: 14px; }
        tr:hover td { background: #f9f9f9; }
        .badge { padding: 2px 10px; border-radius: 12px; font-size: 12px; }
        .badge-admin { background: #FFF3E0; color: #E65100; }
        .badge-owner { background: #E8F5E9; color: #2E7D32; }
        .badge-staff { background: #E3F2FD; color: #1565C0; }
        .badge-orange { background: #FFF3E0; color: #E65100; }
        .login-link { color: #2E7D32; text-decoration: none; font-weight: bold; cursor: pointer; }
        .login-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="page-header">
    <h1>物业管理系统</h1>
    <p>本地测试入口 — 选择账号即可快速登入</p>
</div>
<div class="container">

    <% if ("noresident".equals(request.getParameter("error"))) { %>
    <div style="background:#FFF3E0;border:1px solid #FFB74D;color:#E65100;padding:16px 20px;border-radius:6px;margin-bottom:20px;font-size:14px;display:flex;align-items:center;gap:8px;">
        <span style="font-size:18px;">&#9888;</span>
        <span>该业主账号尚未绑定住户信息，请先在右上角删除该账号后重新创建，或联系管理员手动绑定 Resident 记录。</span>
    </div>
    <% } %>

    <!-- 1. 数据库联通测试 -->
    <div class="card">
        <div class="card-header">
            数据库连接测试
            <button class="btn btn-blue" onclick="testDB()" id="btnTestDB">测试连接</button>
        </div>
        <div class="card-body">
            <div id="dbStatus" class="status-bar"></div>
            <p style="font-size:13px;color:#999;">服务器：LAPTOP-B23PEHD3\MSSQLSERVER01 &nbsp;|&nbsp; 数据库：PropertyManagementDB</p>
        </div>
    </div>

    <!-- 2. 新增测试账号 -->
    <div class="card">
        <div class="card-header">新增测试账号</div>
        <div class="card-body">
            <div id="addStatus" class="status-bar"></div>

            <!-- 基础信息（所有角色必填） -->
            <div class="form-row">
                <div class="form-group">
                    <label>用户名 <span style="color:red;">*</span></label>
                    <input type="text" id="username" placeholder="登录用户名">
                </div>
                <div class="form-group">
                    <label>密码 <span style="color:red;">*</span></label>
                    <input type="text" id="password" value="123456">
                </div>
                <div class="form-group">
                    <label>角色 <span style="color:red;">*</span></label>
                    <select id="userType" onchange="onRoleChange()">
                        <option value="业主">业主</option>
                        <option value="管理员">管理员</option>
                        <option value="维修员">维修员</option>
                        <option value="广告公司">广告公司</option>
                    </select>
                </div>
            </div>

            <!-- 详细信息（根据角色动态显示） -->
            <div id="detailFields" style="border-top:1px dashed #ddd;padding-top:12px;margin-top:4px;">
                <!-- 所有角色通用 -->
                <div class="form-row">
                    <div class="form-group">
                        <label>姓名 <span style="color:red;">*</span></label>
                        <input type="text" id="detailName" placeholder="真实姓名">
                    </div>
                    <div class="form-group">
                        <label>电话 <span style="color:red;">*</span></label>
                        <input type="text" id="detailPhone" placeholder="手机号">
                    </div>
                    <div class="form-group">
                        <label>身份证号 <span style="color:red;">*</span></label>
                        <input type="text" id="detailIdCard" placeholder="18位身份证号">
                    </div>
                </div>

                <!-- 业主专属 -->
                <div id="ownerFields">
                    <div class="form-row">
                        <div class="form-group">
                            <label>入住日期</label>
                            <input type="date" id="checkInDate">
                        </div>
                    </div>
                    <p style="font-size:13px;color:#666;margin-bottom:8px;font-weight:bold;">房屋信息</p>
                    <div class="form-row">
                        <div class="form-group">
                            <label>楼栋 <span style="color:red;">*</span></label>
                            <input type="text" id="building" placeholder="如：A">
                        </div>
                        <div class="form-group">
                            <label>单元 <span style="color:red;">*</span></label>
                            <input type="text" id="unit" placeholder="如：1">
                        </div>
                        <div class="form-group">
                            <label>房号 <span style="color:red;">*</span></label>
                            <input type="text" id="roomNo" placeholder="如：101">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>面积(m²) <span style="color:red;">*</span></label>
                            <input type="number" step="0.01" id="area" placeholder="如：89.50">
                        </div>
                        <div class="form-group">
                            <label>楼层 <span style="color:red;">*</span></label>
                            <input type="number" id="floor" placeholder="如：1">
                        </div>
                        <div class="form-group">
                            <label>户型 <span style="color:red;">*</span></label>
                            <select id="houseType">
                                <option value="">请选择</option>
                                <option value="一室一厅">一室一厅</option>
                                <option value="两室一厅">两室一厅</option>
                                <option value="三室一厅">三室一厅</option>
                                <option value="三室两厅">三室两厅</option>
                                <option value="四室两厅">四室两厅</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 维修员专属 -->
                <div class="form-row" id="staffFields" style="display:none;">
                    <div class="form-group" style="max-width:300px;">
                        <label>工种</label>
                        <select id="workTypeId">
                            <option value="">加载中...</option>
                        </select>
                    </div>
                </div>

                <!-- 广告公司专属 -->
                <div id="companyFields" style="display:none;">
                    <div class="form-row">
                        <div class="form-group">
                            <label>公司名称 <span style="color:red;">*</span></label>
                            <input type="text" id="companyName" placeholder="广告公司全称">
                        </div>
                        <div class="form-group">
                            <label>联系人 <span style="color:red;">*</span></label>
                            <input type="text" id="companyContact" placeholder="联系人姓名">
                        </div>
                    </div>
                </div>
            </div>

            <button class="btn btn-primary" onclick="addUser()">创建账号</button>
        </div>
    </div>

    <!-- 3. 选择账号登入 -->
    <div class="card">
        <div class="card-header">
            已有账号列表
            <button class="btn btn-outline" onclick="loadUsers()">刷新列表</button>
        </div>
        <div class="card-body">
            <table>
                <thead>
                    <tr><th>用户ID</th><th>用户名</th><th>角色</th><th>姓名</th><th>电话</th><th>操作</th></tr>
                </thead>
                <tbody id="userTableBody">
                    <tr><td colspan="6" style="text-align:center;color:#999;">点击"刷新列表"加载账号数据</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';
var workTypes = [];

function showStatus(id, type, msg) {
    var el = document.getElementById(id);
    el.className = 'status-bar status-' + (type === 'success' ? 'success' : 'error');
    el.textContent = msg;
    el.style.display = 'block';
    setTimeout(function(){ el.style.display = 'none'; }, 5000);
}

function onRoleChange() {
    var role = document.getElementById('userType').value;
    var ownerFields = document.getElementById('ownerFields');
    var staffFields = document.getElementById('staffFields');
    var companyFields = document.getElementById('companyFields');

    if (role === '业主') {
        ownerFields.style.display = '';
        staffFields.style.display = 'none';
        companyFields.style.display = 'none';
    } else if (role === '维修员') {
        ownerFields.style.display = 'none';
        staffFields.style.display = '';
        companyFields.style.display = 'none';
    } else if (role === '广告公司') {
        ownerFields.style.display = 'none';
        staffFields.style.display = 'none';
        companyFields.style.display = '';
    } else {
        ownerFields.style.display = 'none';
        staffFields.style.display = 'none';
        companyFields.style.display = 'none';
    }
}

function loadWorkTypes() {
    fetch(ctx + '/test?action=workTypes')
        .then(function(r) { return r.json(); })
        .then(function(list) {
            workTypes = list;
            var sel = document.getElementById('workTypeId');
            sel.innerHTML = '';
            list.forEach(function(w) {
                sel.innerHTML += '<option value="' + w.worktypeId + '">' + w.worktypeName + '</option>';
            });
        })
        .catch(function() {
            document.getElementById('workTypeId').innerHTML = '<option value="">加载失败</option>';
        });
}

function testDB() {
    var btn = document.getElementById('btnTestDB');
    btn.disabled = true;
    btn.textContent = '测试中...';
    fetch(ctx + '/test?action=db')
        .then(function(r) { return r.json(); })
        .then(function(data) {
            showStatus('dbStatus', data.success ? 'success' : 'error', data.message);
            btn.disabled = false;
            btn.textContent = '测试连接';
        })
        .catch(function() {
            showStatus('dbStatus', 'error', '请求失败，请检查服务器');
            btn.disabled = false;
            btn.textContent = '测试连接';
        });
}

function addUser() {
    var username = document.getElementById('username').value.trim();
    var password = document.getElementById('password').value.trim();
    var userType = document.getElementById('userType').value;
    var name = document.getElementById('detailName').value.trim();
    var phone = document.getElementById('detailPhone').value.trim();
    var idCard = document.getElementById('detailIdCard').value.trim();

    if (!username) { showStatus('addStatus', 'error', '请输入用户名'); return; }
    if (!password) { showStatus('addStatus', 'error', '请输入密码'); return; }
    if (!name) { showStatus('addStatus', 'error', '请输入姓名'); return; }
    if (!phone) { showStatus('addStatus', 'error', '请输入电话'); return; }
    if (!idCard) { showStatus('addStatus', 'error', '请输入身份证号'); return; }
    if (idCard.length !== 18) { showStatus('addStatus', 'error', '身份证号必须为18位'); return; }

    var params = new URLSearchParams();
    params.append('action', 'addUser');
    params.append('username', username);
    params.append('password', password);
    params.append('userType', userType);
    params.append('name', name);
    params.append('phone', phone);
    params.append('idCard', idCard);

    if (userType === '业主') {
        var checkInDate = document.getElementById('checkInDate').value;
        if (!checkInDate) { showStatus('addStatus', 'error', '请选择入住日期'); return; }
        var building = document.getElementById('building').value.trim();
        var unit = document.getElementById('unit').value.trim();
        var roomNo = document.getElementById('roomNo').value.trim();
        var area = document.getElementById('area').value.trim();
        var ffloor = document.getElementById('floor').value.trim();
        var houseType = document.getElementById('houseType').value;
        if (!building) { showStatus('addStatus', 'error', '请输入楼栋'); return; }
        if (!unit) { showStatus('addStatus', 'error', '请输入单元'); return; }
        if (!roomNo) { showStatus('addStatus', 'error', '请输入房号'); return; }
        if (!area) { showStatus('addStatus', 'error', '请输入面积'); return; }
        if (!ffloor) { showStatus('addStatus', 'error', '请输入楼层'); return; }
        if (!houseType) { showStatus('addStatus', 'error', '请选择户型'); return; }
        params.append('checkInDate', checkInDate);
        params.append('building', building);
        params.append('unit', unit);
        params.append('roomNo', roomNo);
        params.append('area', area);
        params.append('floor', ffloor);
        params.append('houseType', houseType);
    }
    if (userType === '维修员') {
        var workTypeId = document.getElementById('workTypeId').value;
        if (!workTypeId) { showStatus('addStatus', 'error', '请选择工种'); return; }
        params.append('workTypeId', workTypeId);
    }
    if (userType === '广告公司') {
        var companyName = document.getElementById('companyName').value.trim();
        var companyContact = document.getElementById('companyContact').value.trim();
        if (!companyName) { showStatus('addStatus', 'error', '请输入公司名称'); return; }
        if (!companyContact) { showStatus('addStatus', 'error', '请输入联系人'); return; }
        params.append('companyName', companyName);
        params.append('companyContact', companyContact);
    }

    fetch(ctx + '/test?' + params.toString())
        .then(function(r) { return r.json(); })
        .then(function(data) {
            showStatus('addStatus', data.success ? 'success' : 'error', data.message);
            if (data.success) {
                document.getElementById('username').value = '';
                document.getElementById('detailName').value = '';
                document.getElementById('detailPhone').value = '';
                document.getElementById('detailIdCard').value = '';
                document.getElementById('checkInDate').value = '';
                document.getElementById('building').value = '';
                document.getElementById('unit').value = '';
                document.getElementById('roomNo').value = '';
                document.getElementById('area').value = '';
                document.getElementById('floor').value = '';
                document.getElementById('houseType').value = '';
                loadUsers();
            }
        })
        .catch(function() {
            showStatus('addStatus', 'error', '创建失败，请检查服务');
        });
}

function loadUsers() {
    var tbody = document.getElementById('userTableBody');
    tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;color:#999;">加载中...</td></tr>';
    fetch(ctx + '/test?action=users')
        .then(function(r) { return r.json(); })
        .then(function(users) {
            if (users.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;color:#999;">暂无账号，请先新增</td></tr>';
                return;
            }
            var html = '';
            var badgeMap = {'管理员': 'badge-admin', '业主': 'badge-owner', '维修员': 'badge-staff', '广告公司': 'badge-orange'};
            users.forEach(function(u) {
                html += '<tr>';
                html += '<td>' + u.userId + '</td>';
                html += '<td>' + u.username + '</td>';
                html += '<td><span class="badge ' + (badgeMap[u.userType] || '') + '">' + u.userType + '</span></td>';
                html += '<td>' + (u.realName || '-') + '</td>';
                html += '<td>' + (u.phone || '-') + '</td>';
                html += '<td><a class="login-link" href="' + ctx + '/login?userId=' + u.userId + '">进入系统</a></td>';
                html += '</tr>';
            });
            tbody.innerHTML = html;
        })
        .catch(function() {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;color:red;">加载失败，请检查服务</td></tr>';
        });
}

// 页面加载时初始化
window.onload = function() {
    loadUsers();
    loadWorkTypes();
    onRoleChange();
};
</script>
</body>
</html>