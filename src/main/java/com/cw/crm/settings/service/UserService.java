package com.cw.crm.settings.service;

import com.cw.crm.settings.domain.User;
import com.cw.crm.exception.LoginException;

import java.util.List;

public interface UserService {


    User find(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
