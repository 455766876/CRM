package com.cw.crm.settings.web.controller;

import com.cw.crm.settings.domain.User;
import com.cw.crm.settings.service.UserService;
import com.cw.crm.settings.service.impl.UserServiceImpl;
import com.cw.crm.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

// 用户控制器

@RequestMapping("/settings/user")
@Controller
public class UserController {

    @Resource
    private UserService service;

    @ResponseBody
    @RequestMapping("/login.do")
    public Map<String,Object> login(HttpServletRequest request,HttpServletResponse response, String loginAct, String loginPwd, HttpSession session) {
        Map<String,Object> map = new HashMap<>();
        // 浏览器ip
        String ip = request.getRemoteAddr();
        // 将密码进行 MD5 加密
        loginPwd = MD5Util.getMD5(loginPwd);

        try {
            User user = service.find(loginAct,loginPwd,ip);
            // 如果程序执行到此处，说明业务层没有为 controller抛出任何异常
            // 表示登录成功
            session.setAttribute("user",user);
            map.put("success",true);
            // 向登录页 传递信息
            // {"success":true}
        }catch (Exception e){
            e.printStackTrace();
            map.put("success",false);
            map.put("msg",e.getMessage());
            // 一旦程序执行了catch 快的的信息，说明业务层为我们验证登录失败，为controller抛出异常
            // {"success":false,"msg",e.getMessage()}
        }
        return map;
    }
}
