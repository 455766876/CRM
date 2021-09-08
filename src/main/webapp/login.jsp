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
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<script>
    $(function () {

        if (window.top != window){
            window.top.location = window.location;
        }
        // 每次刷新都清空输入框
        $("#loginAct").val("");
        $("#loginPwd").val("");

        // 自动账号框获取焦点
        $("#loginAct").focus();

        // 输入框获取焦点时，去掉提示信息
        $("#loginAct,#loginPwd").focus(function () {
            $("#msg").html("");
        })

        // 登录操作
        $("#btn").click(function () {
            login();
        });
        // 回车键登录
        $("#loginAct,#loginPwd").keydown(function (event) {
            if (event.keyCode === 13){
                login();
            }
        })

    });
    // 登录方法
    function login() {
        // 排除掉空字符串
        var loginAct = $("#loginAct").val().trim();
        var loginPwd = $.trim($("#loginPwd").val());

        if (loginAct == "" || loginPwd == ""){
            $("#msg").html("账号密码不能为空！")
            return false;
        }
        var loginAcp = $("#loginAct").val();
        var loginPwd = $("#loginPwd").val();
        $.ajax({
            url:"settings/user/login.do",
            data:{
                "loginAct":loginAct,
                "loginPwd":loginPwd
            },
            dataType:"json",
            type:"post",
            success:function (data) {
              if (data.success){
                  document.location.href = "workbench/index.jsp";
              }else {
                  $("#msg").html(data.msg);
              }
            }
        })
    }
</script>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2017 &nbsp; 动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd">
                </div>
                <div class="checkbox" style="position: relative;top: 25px; left: 10px; color: red">

                    <span id="msg"></span>

                </div>
                <button type="button" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;" id="btn">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>