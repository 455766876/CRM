<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

    <script type="text/javascript">

        $(function () {
           /* $("#searchBtn").click(function () {
                pageList(1,2);
            });
            pageList(1,2)*/


        });


        /*function pageList(pageNo, pageSize) {
            var owner = $("#owner").val().trim();
            var name = $("#name").val().trim();
            var customerId = $("#customerId").val().trim();
            var stage = $("#stage").val().trim();
            var type = $("#type").val().trim();
            var source = $("#create-clueSource").val().trim();
            var contactsId = $("#contactsId").val().trim();

            $.ajax({
                url: "workbench/transaction/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "owner": owner,
                    "name": name,
                    "customerId": customerId,
                    "stage": stage,
                    "type": type,
                    "source": source,
                    "contactsId": contactsId
                },
                dataType:"json",
                success: function (data) {
                    var html = '';
                    $.each(data.dataList,function (i,e) {

                        });
                    $("#tranBody").html(html);
                }
            })
        }*/


    </script>
</head>
<body>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>????????????</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">?????????</div>
                        <input class="form-control" type="text" id="owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <input class="form-control" type="text" id="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">????????????</div>
                        <input class="form-control" type="text" id="customerId">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <select class="form-control" id="stage">
                            <option></option>
                            <c:forEach items="${stage}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                            <%--<option>????????????</option>
                            <option>????????????</option>
                            <option>????????????</option>
                            <option>???????????????</option>
                            <option>??????/??????</option>
                            <option>??????/??????</option>
                            <option>??????</option>
                            <option>???????????????</option>
                            <option>?????????????????????</option>--%>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <select class="form-control" id="type">
                            <option></option>
                            <c:forEach items="${transactionType}" var="t">
                                <option value="${t.value}">${t.text}</option>
                            </c:forEach>
                            <%--<option>????????????</option>
                            <option>?????????</option>--%>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">??????</div>
                        <select class="form-control" id="create-clueSource">
                            <option></option>
                            <c:forEach items="${source}" var="r">
                                <option value="${r.value}">${r.text}</option>
                            </c:forEach>
                            <%--<option>??????</option>
                            <option>????????????</option>
                            <option>????????????</option>
                            <option>????????????</option>
                            <option>????????????</option>
                            <option>????????????</option>
                            <option>????????????</option>
                            <option>????????????</option>
                            <option>?????????????????????</option>
                            <option>???????????????</option>
                            <option>?????????</option>
                            <option>web??????</option>
                            <option>web??????</option>
                            <option>??????</option>--%>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">???????????????</div>
                        <input class="form-control" type="text" id="contactsId">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">??????</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"
                        onclick="window.location.href='workbench/transaction/openSave.do';"><span
                        class="glyphicon glyphicon-plus"></span> ??????
                </button>
                <button type="button" class="btn btn-default"
                        onclick="window.location.href='workbench/transaction/edit.jsp';"><span
                        class="glyphicon glyphicon-pencil"></span> ??????
                </button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> ??????</button>
            </div>


        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>??????</td>
                    <td>????????????</td>
                    <td>??????</td>
                    <td>??????</td>
                    <td>?????????</td>
                    <td>??????</td>
                    <td>???????????????</td>
                </tr>
                </thead>
                <tbody id="tranBody">
                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/transaction/detail.jsp';">????????????-??????01</a></td>
                    <td>????????????</td>
                    <td>??????/??????</td>
                    <td>?????????</td>
                    <td>zhangsan</td>
                    <td>??????</td>
                    <td>??????</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/transaction/detail.jsp';">????????????-??????01</a></td>
                    <td>????????????</td>
                    <td>??????/??????</td>
                    <td>?????????</td>
                    <td>zhangsan</td>
                    <td>??????</td>
                    <td>??????</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 20px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">???<b>50</b>?????????</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">??????</button>
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
                <button type="button" class="btn btn-default" style="cursor: default;">???/???</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">??????</a></li>
                        <li class="disabled"><a href="#">?????????</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">?????????</a></li>
                        <li class="disabled"><a href="#">??????</a></li>
                    </ul>
                </nav>
            </div>
        </div>

    </div>

</div>
</body>
</html>