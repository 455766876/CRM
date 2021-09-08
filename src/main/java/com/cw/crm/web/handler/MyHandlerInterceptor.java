package com.cw.crm.web.handler;

import com.cw.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MyHandlerInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        // 获取会话作用域中登陆时填入的 user对象
        User user = (User) request.getSession().getAttribute("user");

        /*// 获取浏览器访问的URI
        String uri = request.getRequestURI();*/

        if (user != null) {
            return true;
        } else {
            // 非法访问拦截
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
    }
}
