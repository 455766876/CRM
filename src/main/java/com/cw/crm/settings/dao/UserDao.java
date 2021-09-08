package com.cw.crm.settings.dao;

import com.cw.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserDao {
    User find(@Param("loginAct") String loginAct, @Param("loginPwd") String loginPwd);

    List<User> getUserList();
}
