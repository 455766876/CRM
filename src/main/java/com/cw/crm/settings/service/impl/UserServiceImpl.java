package com.cw.crm.settings.service.impl;

import com.cw.crm.settings.dao.UserDao;
import com.cw.crm.settings.domain.User;
import com.cw.crm.exception.LoginException;
import com.cw.crm.settings.service.UserService;
import com.cw.crm.utils.DateTimeUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Resource
    private UserDao dao;

    // 登录
    @Override
    public User find(String loginAct, String loginPwd, String ip) throws LoginException {

        User user = dao.find(loginAct,loginPwd);

        // 验证 user 是否为空，空就是未查询到
        if (user == null){
            throw new LoginException("验证失败");
        }
        if (user.getExpireTime().compareTo(DateTimeUtil.getSysTime()) <= 0){
            throw new LoginException("您的账号已失效");
        }
        if ("0".equals(user.getLockState())){
            throw new LoginException("您的账号已经锁定了");
        }

        String allowIps = user.getAllowIps();  // 允许访问的ip
        // 当没有设定ip则是任意ip都能访问
        if(!(allowIps.equals(""))){
            if (!(allowIps.contains(ip))){
                throw new LoginException("浏览器端的 ip 地址无效");
            }
        }
        return user;
    }

    // 获取 用户列表
    @Override
    public List<User> getUserList() {
        List<User> userList = dao.getUserList();
        return userList;
    }
}
