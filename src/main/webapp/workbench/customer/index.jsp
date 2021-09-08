<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>

<%
    Object user = request.getSession().getAttribute("user");
// 如果 user = null; 说明 user 还没有登陆
    if (user == null) {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
        return;     // 一般请求转发后，就不允许再执行任何代码，这里就直接return了
    }
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript">

        $(function () {
            // 时间控键
            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });
            // 查询按钮
            $("#searchBtn").click(function () {
                $("#hidden-name").val($("#search-name").val().trim())
                $("#hidden-owner").val($("#search-owner").val().trim())
                $("#hidden-phone").val($("#search-phone").val().trim())
                $("#hidden-website").val($("#search-website").val().trim())
                pageList(1, 2);
            });
            // 页面打开时就加载客户记录
            pageList(1, 2);

            // 修改按钮
            $("#editBtn").click(function () {

                // 勾选要修改的客户
                var $xz = $("input[name=dx]:checked");
                if ($xz.length == 0){
                    alert("请勾选一条客户信息");
                }else if ($xz.length > 1) {
                    alert("一次只能修改一条客户信息");
                }else {
                    // 获取选中的id
                    var id = $xz.val();
                    $.ajax({
                        url:"workbench/customer/getUserListAndCustomer.do",
                        data:{
                            "id":id  // customer---Id
                        },
                        dataType:"json",
                        // type: "post",
                        success:function (data) {
                            var html = "<option></option>";
                            // 遍历 userList集合
                            $.each(data.userList,function (i,e) {
                            html += '<option value="' + e.id + '" >' +e.name+ '</option>';
                            })
                            $("#edit-owner").html(html);
                            var id = id;
                            $("#edit-owner").val(id);
                            // 单条 Customer记录
                            $("#edit-owner").val(data.customer.owner)
                            $("#edit-name").val(data.customer.name)
                            $("#edit-website").val(data.customer.website)
                            $("#edit-phone").val(data.customer.phone)
                            $("#edit-description").val(data.customer.description)
                            $("#edit-contactSummary").val(data.customer.contactSummary)
                            $("#edit-nextContactTime").val(data.customer.nextContactTime)
                            $("#edit-address").val(data.customer.address)
                            $("#hidden-id").val(data.customer.id)
                        }
                    })
                    // 打开模态窗口
                    $("#editCustomerModal").modal("show");
                }

            })
            // 修改中的更新按钮
            $("#editCustomerBtn").click(function () {
                $.ajax({
                    url:"workbench/customer/update.do",
                    data:{
                        "id":$("#hidden-id").val(),
                        "owner": $("#edit-owner").val(),
                        "name": $("#edit-name").val(),
                        "website": $("#edit-website").val(),
                        "phone": $("#edit-phone").val(),
                        "description": $("#edit-description").val(),
                        "contactSummary": $("#edit-contactSummary").val(),
                        "nextContactTime": $("#edit-nextContactTime").val(),
                        "address": $("#edit-address").val()
                    },
                    dataType:"json",
                    type:"post",
                    success:function (data){
                        if (data.success){
                            // 刷新客户列表
                            pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
                                , $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
                            // 关闭模态窗口
                            $("#editCustomerModal").modal("hide");
                        }else {
                            alert("修改客户信息失败")
                        }
                    }
                })
            });

            // 删除按钮
            $("#deleteBtn").click(function (){
                // 获取选中的复选框
                var $xz = $("input[name=dx]:checked")

                if ($xz.length == 0){
                    alert("请勾选要删除的客户");
                }else {
                    if (confirm("您确定要删除吗")){
                        // 遍历选中框
                        var parm = "";
                        for (var i = 0; i < $xz.length; i++) {
                            parm += "id="+$($xz[i]).val();
                            if (i < $xz.length - 1){
                                parm += "&"
                            }
                        }
                        $.ajax({
                            url:"workbench/customer/delete.do",
                            data: parm,
                            dataType:"json",
                            success:function (data){
                                if (data.success){
                                    // 刷新客户列表
                                    pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

                                }else {
                                    alert("删除失败")
                                }
                            }
                        })
                    }
                }

            })


            // 全选/取消全选
            $("#qx").click(function () {
                $("input[name=dx]").prop("checked", this.checked)
            });
            $("#customerBody").on("click", $("input[name=dx]"), function () {
                $("#qx").prop("checked", $("input[name=dx]:checked").length == $("input[name=dx]").length)
            });

            // 创建按钮绑定事件
            $("#createBtn").click(function () {
                // 获取所有者
                $.ajax({
                    url: "workbench/customer/getUserList.do",
                    dataType: "json",
                    success: function (data) {
                        var html = "<option></option>";
                        $.each(data, function (i, e) {
                            html += '<option value="' + e.id + '">' + e.name + '</option>'
                        })
                        $("#create-owner").html(html);
                        $("#createCustomerModal").modal("show");
                        var id = "${user.id}"
                        $("#create-owner").val(id);
                    }
                })

                // 保存按钮绑定事件
                $("#saveBtn").click(function () {
                    $.ajax({
                        url: "workbench/customer/save.do",
                        data: {
                            "owner": $("#create-owner").val().trim(),
                            "name": $("#create-name").val().trim(),
                            "website": $("#create-website").val().trim(),
                            "phone": $("#create-phone").val().trim(),
                            "contactSummary": $("#create-contactSummary").val().trim(),
                            "nextContactTime": $("#create-nextContactTime").val().trim(),
                            "description": $("#create-description").val().trim(),
                            "address": $("#create-address1").val().trim()
                        },
                        dataType: "json",
                        type: "post",
                        success: function (data) {
                            if (data.success) {
                                // 刷新客户列表
                                pageList(1, $("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

                                // 清除添加页的内容
                                $("#createCustomerForm")[0].reset();
                                // 关闭模态窗口
                                $("#createCustomerModal").modal("hide");
                            } else {
                                alert("保存失败")
                            }
                        }
                    })
                })

            });
        });

        function pageList(pageNo, pageSize) {

            // 取消全选按钮的 √
            $("#qx").prop("checked", false);

            $("#search-name").val($("#hidden-name").val().trim())
            $("#search-owner").val($("#hidden-owner").val().trim())
            $("#search-phone").val($("#hidden-phone").val().trim())
            $("#search-website").val($("#hidden-website").val().trim())
            $.ajax({
                url: "workbench/customer/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $("#search-name").val(),
                    "owner": $("#search-owner").val(),
                    "phone": $("#search-phone").val(),
                    "website": $("#search-website").val()
                },
                dataType: "json",
                success: function (data) {
                    var html = '';
                    $.each(data.dataList, function (i, e) {
                        html += ' <tr class="active">';
                        html += ' <td><input type="checkbox" name="dx" value="' +e.id+ '"/></td>';
                        html += ' <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/getCustomerDetailById.do?id=' +e.id+ '\';">' + e.name + '</a></td>';
                        html += ' <td>' + e.owner + '</td>';
                        html += ' <td>' + e.phone + '</td>';
                        html += ' <td>' + e.website + '</td>';
                        html += ' </tr>';
                    })
                    $("#customerBody").html(html);

                    // 计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : (data.total / pageSize) + 1
                    $("#customerPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage); // 参数不能改，方法名可变
                        }
                    });

                }
            })
        }
    </script>
</head>
<body>

<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-website">

<%--存储customer id--%>
<input type="hidden" id="hidden-id">

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createCustomerForm">

                    <div class="form-group">
                        <label for="create-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">


                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>
                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address1"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-customerName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website" />
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="editCustomerBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="search-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="search-website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="customerBody">
                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/customer/detail.jsp';">动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/customer/detail.jsp';">动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="customerPage"></div>
        </div>

    </div>

</div>
</body>
</html>