package com.cw.crm.workbench.service;

import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    PaginationVO<Contacts> pageList(Map<String, Object> map);


    List<Contacts> getContactsListByName(String cname);
}
