<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
</head>

<script type="text/javascript">
    $(function () {

        // 自动补全
        $("#create-customerName").typeahead({
            source: function (query, process) {
                $.post(
                    "workbench/transaction/getCustomerName.do",
                    { "name" : query },
                    function (data) {
                        //alert(data);
                        process(data);
                    },
                    "json"
                );
            },
            delay: 1500
        });


        // 时间控键
        $(".time").datetimepicker({
            minView: "month",
            language: 'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "bottom-left"
        });
        // 时间控键2
        $(".time1").datetimepicker({
            minView: "month",
            language: 'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "top-left"
        });

        // 市场活动 获取键盘输入
        $("#aname").keydown(function (event) {
            if (event.keyCode == 13){
                $.ajax({
                    url:"workbench/transaction/getActivityByAname.do",
                    data:{
                        "aname":$("#aname").val(),
                    },
                    dataType:"json",
                    type:"get",
                    success:function (data) {
                        var html = '';
                        $.each(data,function (i,e) {  // e 是一条 市场活动 activity
                            html +='<tr>';
                            html +='<td><input type="radio" name="dx"  value="'+ e.id  +'"/></td>';
                            html +='<td id="' +e.id+ '">'+ e.name + '</td>';
                            html +='<td>' + e.startDate + '</td>';
                            html +='<td>' + e.endDate + '</td>';
                            html +='<td>' + e.owner + '</td>';
                            html +='</tr>';
                        })
                        $("#bundActivityBody").html(html);
                    }
                });
                // 展现完列表后，记得将模态窗口默认的回车行为禁用掉
                return false;
            }
        })
        // 提交市场活动
        $("#submitActivityBtn").click(function () {
            // 选中的 活动
            var $xz = $("input[name=dx]:checked")
            var id = $xz.val();
            var name = $("#" + id).html()
            $("#create-activity").val(name);
            $("#create-activityId").val(id);
            // 关闭模态窗口
            $("#findMarketActivity").modal("hide");
        })

        // 联系人
        $("#cname").keydown(function (event) {
            if (event.keyCode == 13){
                alert($("#cname").val())
                $.ajax({
                    url:"workbench/transaction/getContactsListByName.do",
                    data: {
                        "cname":$("#cname").val()
                    },
                    dataType: "json",
                    type:"get",
                    success:function (data){
                        var html = '';
                        $.each(data,function (i,e){
                           html += '<tr>';
                           html += '<td><input type="radio" name="activity" value="' +e.id+ '"/></td>';
                           html += '<td id="' +e.id+ '">' +e.fullname+ '</td>';
                           html += '<td>' +e.email+ '</td>';
                           html += '<td>' +e.mphone+'</td>';
                           html += '</tr>';
                        })
                        $("#contactsBody").html(html);
                    }
                })
                return false;
            }
        })
        // 提交联系人
        $("#submitContactsBtn").click(function () {
            // 选中的 活动
            var $xz = $("input[name=activity]:checked")
            var id = $xz.val();
            var name = $("#" + id).html()
            $("#create-name").val(name);
            $("#create-contactsId").val(id);
            // 关闭模态窗口
            $("#findContacts").modal("hide");
        })


        // 新用户的保存按钮
        $("#saveBtn").click(function () {

        })
    })
</script>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
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
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="bundActivityBody">
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

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="cname" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactsBody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <%--添加交易--%>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
        <button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/index.jsp';">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">

            <select class="form-control" id="create-owner">
                <option></option>
                <c:forEach items="${userList}" var="u">
                    <option value="${u.id}" ${user.id eq u.id?"selected":""}>${u.name}</option>
                </c:forEach>
                <%--<option>zhangsan</option>
                <option>lisi</option>
                <option>wangwu</option>--%>
            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-name1">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time" id="create-expectedDate">
        </div>
    </div>

    <div class="form-group">
        <label for="create-accountName" class="col-sm-2 control-label" id="create-fullname">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>

        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionStage">
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
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-type">
                <option></option>
                <c:forEach items="${transactionType}" var="t">
                    <option value="${t.value}">${t.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility">
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-source">
                <option></option>
                <c:forEach items="${source}" var="s">
                <option value="${s.value}">${s.text}</option>
                </c:forEach>
                        <%--<option>广告</option>
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
        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                           data-toggle="modal"
                                                                                           data-target="#findMarketActivity"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activity">
            <input type="hidden" id="create-activityId">
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                            data-toggle="modal"
                                                                                            data-target="#findContacts"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-name">
            <input type="hidden" id="create-contactsId">
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time1" id="create-nextContactTime">
        </div>
    </div>

</form>
</body>
</html>