<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<!DOCTYPE html>
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

            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            // 打开添加市场活动页面的操作-- 查询所有的【所有者】
            $("#addBtn").click(function () {

                // 为创建按钮绑定事件，打开添加操作的模态窗口
              /*  $(".time").datetimepicker({
                    minView: "month",
                    language: 'zh-CN',
                    format: 'yyyy-mm-dd',
                    autoclose: true,
                    todayBtn: true,
                    pickerPosition: "bottom-left"
                });*/

                // 清空所有者的下拉框的内容
                $("#create-owner").empty();

                var html = "<option></option>"
                $.ajax({
                    url: "workbench/activity/getUserList.do",
                    dataType: "json",
                    type: "get",
                    success: function (data) {
                        $.each(data, function (index, element) {
                            html = html + "<option value='" + element.id + "'>" + element.name + "</option>"
                        });
                        $("#create-owner").html(html);

                        // 获取当前用户的 id
                        var id = "${user.id}"
                        // 设置默认值为登录的当前用户
                        $("#create-owner").val(id);
                    }
                })

                // 打开模态窗口
                $("#createActivityModal").modal("show");


            });

            // 添加市场活动
            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/save.do",
                    data: {

                        "owner": $.trim($("#create-owner").val()),
                        "name": $.trim($("#create-name").val()),
                        "startDate": $.trim($("#create-startDate").val()),
                        "endDate": $.trim($("#create-endDate").val()),
                        "cost": $.trim($("#create-cost").val()),
                        "description": $.trim($("#create-description").val())
                    },
                    dataType: "json",
                    type: "post",
                    success: function (data) {
                        if (data.success) {
                            alert("添加市场活动成功")
                            // 刷新市场活动列表
                            // pageList(1, 2)
                            /*两个参数：
                                $("#activityPage").bs_pagination('getOption', 'currentPage')
                                   操作后停留在当前页
                                $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                                    操作后维持已经设置好的每页展现的记录条数
                                    pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                           */
                                // 执行添加操作后，回到第 1 页 ，维持展现的记录条数
                                pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            // 关闭添加操作的模态窗口
                            $("#createActivityModal").modal("hide");
                            // 重置添加例表
                            $("#createActivityForm")[0].reset();
                        } else {
                            alert("添加失败")
                        }
                    }
                })
            })

            // 默认搜索分页记录
            pageList(1, 4);

            // 点击查询
            $("#searchBtn").click(function () {
                // 点击查询按钮的时候，将搜索框中的信息保存到隐藏域
                $("#hidden-name").val($("#search-name").val().trim());
                $("#hidden-owner").val($("#search-owner").val());
                $("#hidden-startDate").val($("#search-startDate").val().trim());
                $("#hidden-endDate").val($("#search-endDate").val().trim());

                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            })

            /*
            pageList方法：就是发出 Ajax 请求到后台，从后台取得最新的市场活动信息列表数据
                         通过响应回来的数据，局部刷新市场活动列表
            */











            // 为删除按钮绑定事件，执行市场活动删除操作
            $("#deleteBtn").click(function () {


                    // 所有的选中的复选框的按钮
                    var $xz = $("input[name=dx]:checked");
                    if ($xz.length == 0) {
                        alert("请选择需要删除的记录")
                    } else {
                        if (confirm("您确认要删除吗？")) {
                            // 遍历单选框 将$xz 中的每一个dom对象遍历出来，取其 value值，就相当于取得了需要删除的记录的id
                            var parm = ""; // 参数
                            for (var i = 0; i < $xz.length; i++) {
                                parm += "id=" + $($xz[i]).val();
                                // 加上 & 符号
                                if (i < $xz.length - 1) {
                                    parm += "&";
                                }
                            }
                            $.ajax({
                                url: "workbench/activity/delete.do",
                                data: parm,
                                dataType: "json",
                                // type: "post",
                                success: function (data) {
                                    if (data.success) {
                                        alert("删除市场活动成功");
                                        // pageList(1, 2)
                                        pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                                    } else {
                                        alert("删除市场活动失败");
                                    }
                                }
                            })
                        }
                    }
                }
            )

            // 为修改按钮绑定事件
            $("#editBtn").click(function () {

                var $xz = $("input[name=dx]:checked");
                if ($xz.length == 0) {
                    alert("请勾选一条要修改的记录")
                } else if ($xz.length > 1) {
                    alert("对不起，一次只能勾选一条记录")
                } else {
                    // 通过Ajax 来获取 所有者列表 userList 通过id获取一条记录信息
                    var id = $xz.val();
                    $.ajax({
                        url: "workbench/activity/getUserListAndActivity.do",
                        data: {
                            "id": id
                        },
                        dataType: "json",
                        type: "get",
                        success: function (data) {
                            var html = "<option></option>";
                            $.each(data.userList, function (index, element) {
                                html += "<option value='" + element.id + "'>" + element.name + "</option>";
                            });
                            // 下拉框中的 所有者
                            $("#edit-owner").html(html);

                            //z 处理单条 activity 记录
                            $("#edit-owner").val(data.activity.owner); // 所有者
                            $("#edit-id").val(data.activity.id);
                            $("#edit-name").val(data.activity.name);  // 活动名
                            $("#edit-startDate").val(data.activity.startDate);
                            $("#edit-endDate").val(data.activity.endDate);
                            $("#edit-cost").val(data.activity.cost);
                            $("#edit-description").val(data.activity.description);
                        }

                    });
                    // 打开模态窗口
                    $("#editActivityModal").modal("show");
                }
            });


            // 执行更新操作
            $("#updateBtn").click(function () {

                $.ajax({
                    url: "workbench/activity/update.do",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "startDate": $.trim($("#edit-startDate").val()),
                        "endDate": $.trim($("#edit-endDate").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-description").val())
                    },
                    dataType: "json",
                    type: "post",
                    success: function (data) {
                        if (data.success) {
                            alert("添加市场活动成功")
                            // 刷新市场活动列表
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            // 关闭添加操作的模态窗口
                            $("#editActivityModal").modal("hide");

                        } else {
                            alert("添加失败")
                        }
                    }
                })
            })
        });
        function pageList(pageNo, pageSize) {

            // 取消全选按钮的状态
            $("#qx").prop("checked", false);

            // alert("第"+pageNo+"页"+pageSize+"条记录")
            // 使用隐藏域中的内容
            $("#search-name").val($("#hidden-name").val().trim());
            $("#search-owner").val($("#hidden-owner").val().trim());
            $("#search-startDate").val($("#hidden-startDate").val().trim());
            $("#search-endDate").val($("#hidden-endDate").val().trim());
            $.ajax({
                url: "workbench/activity/pageList.do",
                data: {
                    "pageNo": pageNo, // 分页开始的
                    "pageSize": pageSize, // 每页展示的记录数
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val()),
                },
                dataType: "json",
                type: "post",
                success: function (data) {
                    var html = '';  // 拼接市场活动的表单内容
                    // 每一个 n 就是一个市场活动对象
                    $.each(data.dataList, function (index, element) {
                        html += '<tr class="active">' +
                            '<td><input type="checkbox" name="dx" value="' + element.id + '"/></td>' +
                            '<td><a style="text-decoration: none; cursor: pointer;"' +
                            'onclick="window.location.href=\'workbench/activity/detail.do?id='+element.id+'\';">' + element.name + '</a></td>' +
                            '<td>' + element.owner + '</td>' +
                            '<td>' + element.startDate + '</td>' +
                            '<td>' + element.endDate + '</td>' +
                            '</tr>'

                    });
                    // 给表单添加内容
                    $("#activityBody").html(html);

                    // 分页插件
                    // 计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : (data.total / pageSize) + 1
                    $("#activityPage").bs_pagination({
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
            });

            // 设置全选和全不选
            $("#qx").click(function () {
                // 设置 input 标签中 name=dx 的 checked 属性值
                $("input[name=dx]").prop("checked", this.checked);
            });
            // 动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
            /*
            * 动态生成的元素，我们要用 on 方法的形式来触发事件
            * 语法：
            *   $(需要绑定元素的有效的外层元素).on(绑定事件的方式，需要绑定的元素的 jQuery对象，回调函数)
            * */
            $("#activityBody").on("click", $("input[name=dx]"), function () {
                $("#qx").prop("checked", $("input[name=dx]").length == $("input[name=dx]:checked").length)
                //
            });
        }


    </script>
</head>
<body>
<%--隐藏域，存储用户输入的信息--%>
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>
<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="createActivityForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <%--所有者下拉框--%>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate" readonly>
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id"/> <%--隐藏域，存储记录的id--%>
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate" readonly>
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">

                            <textarea class="form-control" rows="3" id="edit-description"></textarea>

                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
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
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate" readonly>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">

                <button type="button" class="btn btn-primary" id="addBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>

                <button type="button" class="btn btn-default" id="editBtn">
                    <span class="glyphicon glyphicon-pencil"></span> 修改
                </button>

                <button type="button" class="btn btn-danger" id="deleteBtn">
                    <span class="glyphicon glyphicon-minus"></span> 删除
                </button>

            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/>&nbsp;全选</td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%-- <tr class="active">
                     <td><input type="checkbox"/></td>
                     <td><a style="text-decoration: none; cursor: pointer;"
                            onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                     <td>zhangsan</td>
                     <td>2020-10-10</td>
                     <td>2020-10-20</td>
                 </tr>
                 <tr class="active">
                     <td><input type="checkbox"/></td>
                     <td><a style="text-decoration: none; cursor: pointer;"
                            onclick="window.location.href='detail.jsp';">发传单</a></td>
                     <td>zhangsan</td>
                     <td>2020-10-10</td>
                     <td>2020-10-20</td>
                 </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage"></div>
        </div>

    </div>

</div>
</body>
</html>