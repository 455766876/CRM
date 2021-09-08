<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

            // 创建按钮
            $("#addClueBtn").click(function () {
                $.ajax({
                    url: "workbench/clue/getUserList.do",
                    dataType: "json",
                    success: function (data) {
                        var html = "<option></option>";
                        $.each(data, function (i, e) {
                            html += "<option value='" + e.id + "'>" + e.name + "</option>"
                        });
                        $("#create-owner").html(html);
                        var id = "${user.id}";
                        $("#create-owner").val(id)
                        $("#createClueModal").modal("show")
                    }
                });
            })

            // 创建线索的保存按钮
            $("#saveClueBtn").click(function () {
                $.ajax({
                    url: "workbench/clue/save.do",
                    data: {
                        "fullname": $("#create-fullname").val().trim(),
                        "appellation": $("#create-appellation").val().trim(),
                        "owner": $("#create-owner").val().trim(),
                        "company": $("#create-company").val().trim(),
                        "job": $("#create-job").val().trim(),
                        "email": $("#create-email").val().trim(),
                        "phone": $("#create-phone").val().trim(),
                        "website": $("#create-website").val().trim(),
                        "mphone": $("#create-mphone").val().trim(),
                        "state": $("#create-state").val().trim(),
                        "source": $("#create-source").val().trim(),
                        "description": $("#create-description").val().trim(),
                        "contactSummary": $("#create-contactSummary").val().trim(),
                        "nextContactTime": $("#create-nextContactTime").val().trim(),
                        "address": $("#create-address").val().trim()
                    },
                    dataType: "json",
                    type: "post",
                    success: function (data) {
                        if (data.success) {

                            // 刷新线索展示框
                            pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                            $("#createClueModal").modal("hide")
                        } else (
                            alert("创建失败")
                        )
                    }
                })
            })


            // 修改按钮
            $("#editBtn").click(function () {
                var $xz = $("input[name=dx]:checked");
                if ($xz.length == 0) {
                    alert("请勾选一条要修改的记录")
                } else if ($xz.length > 1) {
                    alert("对不起，一次只能勾选一条记录")
                } else {
                    var id = $xz.val()
                    // 选择合格，使用 ajax来通过id获取选中的线索和所有者列表
                    $.ajax({
                        url: "workbench/clue/getUserListAndClue.do",
                        data: {
                            "id": id
                        },
                        dataType: "json",
                        success: function (data) {
                            var html = "<option></option>";
                            // data: 所有者列表，一条 Clue 线索信息
                            $.each(data.userList, function (i, e) {
                                html += "<option value='" + e.id + "'>" + e.name + "</option>"
                            });
                            $("#edit-owner").html(html);
                            // 获取所有人
                            // 设置信息
                            $("#edit-id").val(data.clue.id);
                            $("#edit-fullname").val(data.clue.fullname)
                            $("#edit-appellation").val(data.clue.appellation)
                            $("#edit-owner").val(data.clue.owner)
                            $("#edit-company").val(data.clue.company)
                            $("#edit-job").val(data.clue.job)
                            $("#edit-email").val(data.clue.email)
                            $("#edit-phone").val(data.clue.phone)
                            $("#edit-website").val(data.clue.website)
                            $("#edit-mphone").val(data.clue.mphone)
                            $("#edit-state").val(data.clue.state)
                            $("#edit-source").val(data.clue.source)
                            $("#edit-description").val(data.clue.description)
                            $("#edit-contactSummary").val(data.clue.contactSummary)
                            $("#edit-nextContactTime").val(data.clue.nextContactTime)
                            $("#edit-address").val(data.clue.address)

                            // 刷新线索列表
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            // 打开模态窗口
                            $("#editClueModal").modal("show");
                        }
                    })
                }
            });

            // 更新按钮
            $("#updateBtn").click(function () {
                $.ajax({
                    url: "workbench/clue/update.do",
                    data: {
                        "id": $("#edit-id").val().trim(),
                        "fullname": $("#edit-fullname").val().trim(),
                        "appellation": $("#edit-appellation").val().trim(),
                        "owner": $("#edit-owner").val().trim(),
                        "company": $("#edit-company").val().trim(),
                        "job": $("#edit-job").val().trim(),
                        "email": $("#edit-email").val().trim(),
                        "phone": $("#edit-phone").val().trim(),
                        "website": $("#edit-website").val().trim(),
                        "mphone": $("#edit-mphone").val().trim(),
                        "state": $("#edit-state").val().trim(),
                        "source": $("#edit-source").val().trim(),
                        "description": $("#edit-description").val().trim(),
                        "contactSummary": $("#edit-contactSummary").val().trim(),
                        "nextContactTime": $("#edit-nextContactTime").val().trim(),
                        "address": $("#edit-address").val().trim()
                    },
                    dataType: "json",
                    type: "post",
                    success: function (data) {
                        if (data.success) {
                            // 刷新页面
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                , $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                            // 关闭模态窗口
                            $("#editClueModal").modal("hide")
                        } else {
                            alert("修改失败")
                        }
                    }
                })
            })
            pageList(1, 2);


            // 查询按钮
            $("#searchBtn").click(function () {
                // 将查询的内容存储到 隐藏域中
                $("#hidden-fullname").val($("#search-fullname").val().trim())
                $("#hidden-company").val($("#search-company").val().trim())
                $("#hidden-phone").val($("#search-phone").val().trim())
                $("#hidden-source").val($("#search-source").val().trim())
                $("#hidden-owner").val($("#search-owner").val().trim())
                $("#hidden-mphone").val($("#search-mphone").val().trim())
                $("#hidden-state").val($("#search-state").val().trim())


                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

            })


            // 删除按钮
            $("#deleteBtn").click(function () {
                // 取得所选中了的复选框
                var $xz = $("input[name=dx]:checked")
                if ($xz.length == 0) {
                    alert("请勾选需要删除的记录")
                } else {
                    if (confirm("您确定要删除所选项？")) {
                        // 拼接请求参数
                        var page = "id=";
                        for (var i = 0; i < $xz.length; i++) {
                            page += $($xz[i]).val(); // 转换为 jQuery 后 使用jQuery函数
                            if (i < $xz.length - 1) {
                                page += "&"
                            }
                        }
                        $.ajax({
                            url: "workbench/clue/delete.do",
                            data: page,
                            dataType: "json",
                            type: "post",
                            success: function (data) {
                                if (data.success) {
                                    // 刷新列表
                                    pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                                } else {
                                    alert("删除失败");
                                }
                            }
                        })
                    }
                }
            })
        });

        // 线索列表
        function pageList(pageNo, pageSize) {

            $("#qx").prop("checked", false);

            $("#search-fullname").val($("#hidden-fullname").val().trim())
            $("#search-company").val($("#hidden-company").val().trim())
            $("#search-phone").val($("#hidden-phone").val().trim())
            $("#search-source").val($("#hidden-source").val().trim())
            $("#search-owner").val($("#hidden-owner").val().trim())
            $("#search-mphone").val($("#hidden-mphone").val().trim())
            $("#search-state").val($("#hidden-state").val().trim())
            $.ajax({
                url: "workbench/clue/pageList.do",
                data: {
                    "fullname": $("#search-fullname").val().trim(),
                    "company": $("#search-company").val().trim(),
                    "phone": $("#search-phone").val().trim(),
                    "source": $("#search-source").val().trim(),
                    "owner": $("#search-owner").val().trim(),
                    "mphone": $("#search-mphone").val().trim(),
                    "state": $("#search-state>option:selected").val(),
                    "pageNo": pageNo,
                    "pageSize": pageSize
                },
                dataType: "json",
                // type: "post",
                success: function (data) {  // 线索表 + 总线索记录数
                    var html = '';
                    $.each(data.dataList, function (i, e) {
                        html += '<tr>'
                        html += '<td><input type="checkbox" value="' + e.id + '" name="dx"/></td>'
                        html += '<td><a style="text-decoration: none; cursor: pointer;" ' +
                            'onclick ="window.location.href=\'workbench/clue/detail.do?id=' + e.id + '\';">' + e.fullname + '</a></td>'
                        html += '<td>' + e.company + '</td>'
                        html += '<td>' + e.phone + '</td>'
                        html += '<td>' + e.mphone + '</td>'
                        html += '<td>' + e.source + '</td>'
                        html += '<td>' + e.owner + '</td>'
                        html += '<td>' + e.state + '</td>'
                        html += '</tr>'
                    });

                    // 给表单添加内容
                    // $("#clueTbody").empty();
                    $("#clueTbody").html(html);

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
            })

            // 设置全选
            $("#qx").click(function () {
                $("input[name=dx]").prop("checked", this.checked);
            })
            $("#clueTbody").on("click", $("input[name=dx]"), function () {
                $("#qx").prop("checked", $("input[name=dx]").length == $("input[name=dx]:checked").length);
            })
        }
    </script>
</head>
<body>
<input type="hidden" id="hidden-fullname"/>
<input type="hidden" id="hidden-company"/>
<input type="hidden" id="hidden-phone"/>
<input type="hidden" id="hidden-source"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-mphone"/>
<input type="hidden" id="hidden-state"/>


<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">

                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <c:forEach items="${appellation}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>

                                <%-- <option></option>
                                 <option>先生</option>
                                 <option>夫人</option>
                                 <option>女士</option>
                                 <option>博士</option>
                                 <option>教授</option>--%>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <c:forEach items="${clueState}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${source}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                                <%-- <option>广告</option>
                                 <option>推销电话</option>
                                 <option>员工介绍</option>
                                 <option>外部介绍</option>
                                 <option>在线商场</option>
                                 <option>合作伙伴</option>
                                 <option>公开媒介</option>
                                 <option>销售邮件</option>
                                 <option>合作伙伴研讨会</option>
                                 <option>内部研讨会</option>
                                 <option>交易会</option>
                                 <option>web下载</option>
                                 <option>web调研</option>
                                 <option>聊天</option>--%>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveClueBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    // 线索的id
                    <input type="hidden" id="edit-id"/>
                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <%-- <option>zhangsan</option>
                                 <option>lisi</option>
                                 <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company"">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellation}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <c:forEach items="${clueState}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <c:forEach items="${source}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
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
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
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
            <h3>线索列表</h3>
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
                        <input class="form-control" type="text" id="search-fullname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="search-company">
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
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="search-source">
                            <option></option>
                            <c:forEach items="${source}" var="a">
                                <option value="${a.value}">${a.text}</option>
                            </c:forEach>

                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="search-mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="search-state">
                            <option></option>
                            <c:forEach items="${clueState}" var="c">
                                <option value="${c.value}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addClueBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn">
                    <span class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="clueTbody">

                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;">
            <div id="activityPage"></div>


            <%--<div>
                   <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
               </div>
               <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                   <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                   <div class="btn-group">
                       <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                           10
                           <span class="caret"></span>
                       </button>
                       <ul class="dropdown-menu" role="menu">
                           <li><a href="#">20</a></li>
                           <li><a href="#">30</a></li>
                       </ul>
                   </div>
                   <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
               </div>
               <div style="position: relative;top: -88px; left: 285px;">
                   <nav>
                       <ul class="pagination">
                           <li class="disabled"><a href="#">首页</a></li>
                           <li class="disabled"><a href="#">上一页</a></li>
                           <li class="active"><a href="#">1</a></li>
                           <li><a href="#">2</a></li>
                           <li><a href="#">3</a></li>
                           <li><a href="#">4</a></li>
                           <li><a href="#">5</a></li>
                           <li><a href="#">下一页</a></li>
                           <li class="disabled"><a href="#">末页</a></li>
                       </ul>
                   </nav>
               </div>--%>
        </div>

    </div>

</div>
</body>
</html>