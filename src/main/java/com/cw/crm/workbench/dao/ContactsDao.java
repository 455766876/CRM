package com.cw.crm.workbench.dao;

import com.cw.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int save(Contacts contacts);

    int getTotalByCondition(Map<String, Object> map);

    List<Contacts> getListByCondition(Map<String, Object> map);

    List<Contacts> getContactsListByName(String cname);
}
