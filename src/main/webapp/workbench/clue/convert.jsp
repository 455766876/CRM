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
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

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

            $("#isCreateTransaction").click(function () {
                if (this.checked) {
                    $("#create-transaction2").show(200);
                } else {
                    $("#create-transaction2").hide(200);
                }
            });

            $("#openSearchBtn").click(function () {
                $("#searchActivityModal").modal("show")
            })

            $("#aname").keydown(function (event) {
                if (event.keyCode == 13) {
                    $.ajax({
                        url: "workbench/clue/getActivityListByAname.do",
                        data: {
                            "aname": $("#aname").val()
                        },
                        dataType: "json",
                        success: function (data) {
                            var html = "";
                            $.each(data, function (i, e) {
                                html += ' <tr>';
                                html += ' <td><input type="radio" name="xz" value="' + e.id + '"/></td>';
                                html += ' <td id="'+e.id +'">' + e.name + '</td>';
                                html += ' <td>' + e.startDate + '</td>';
                                html += ' <td>' + e.endDate + '</td>';
                                html += ' <td>' + e.owner + '</td>';
                                html += ' </tr>';
                            });
                            $("#activityTbody").html(html);
                        }
                    });

                    return false;
                }
            })

            $("#submitActivityBtn").click(function () {
                // 获取选中按钮
                var $xz = $("input[name=xz]:checked");
                // 选中按钮的 id
                var id = $xz.val()

                // 获取选中按钮的 value
                 var name = $("#"+id).html();
                // 将值赋给市场活动源输入框
                 $("#activityName").val(name);
                 // 将 id 赋值给隐藏域
                 $("#activityId").val(id);

                // 关闭模态窗口
                $("#searchActivityModal").modal("hide")
                 // 清除输入框内容
                $("#aname").val("")
                 // 清空列表
                $("#activityTbody").html("");
            })

            // 转换按钮
            $("#convertBtn").click(function () {
                // alert($("#isCreateTransaction").prop("checked"))
                if ($("#isCreateTransaction").prop("checked")){
                    // 需要提交客户的交易信息
                    /*
                    * 如果需要创建交易，除了要从后台传递 clueId之外，还得为后台传递交易表单中的信息，金额，预计成交日期
                    * 交易名称，市场活动源
                    * 以上传递参数很麻烦，而且表单一旦扩充，挂载的参数有可能超出浏览器地址栏的上限
                    * 我们想到使用提交交易表单的形式来发出本次的传统请求
                    * 提交表单的参数不用我们手动去挂载（表单中写 name 属性），提交表单能够提交post请求
                    *
                    * */

                    $("#tranFrom").submit();

                }else {
                    // 不需要提供客户的交易信息
                    window.location.href='workbench/clue/convert.do?clueId=${param.id}';
                }
            })
        });
    </script>

</head>
<body>

<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="aname" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activityTbody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${param.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${param.fullname}${param.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2"
     style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;">

    <form action="workbench/clue/convert.do" id="tranFrom" method="post">

        <%--用于验证是否添加了交易记录的一个标记--%>
        <input type="hidden" name="flag" value="a">
        <%--clueId 必须传，不然无法找到线索表--%>
        <input type="hidden" value="${param.id}" name="clueId" />

        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney" name="money">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" name="name">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage" class="form-control" name="stage">
                <option></option>
                <c:forEach items="${stage}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
                <%--<option>资质审查</option>
                <option>需求分析</option>
                <option>价值建议</option>
                <option>确定决策者</option>
                <option>提案/报价</option>
                <option>谈判/复审</option>
                <option>成交</option>
                <option>丢失的线索</option>
                <option>因竞争丢失关闭</option>--%>
            </select>
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchBtn"
                                                      style="text-decoration: none;"><span
                    class="glyphicon glyphicon-search"></span></a></label>
            <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>

            <%--市场活动源的id--%>
            <input type="hidden" id="activityId" name="activityId">
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${param.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input class="btn btn-primary" type="button" id="convertBtn" value="转换">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input class="btn btn-default" type="button" value="取消">
    <sapn>${info}</sapn>
</div>
</body>
</html>