package com.cw.crm.workbench.service.impl;

import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.dao.ContactsDao;
import com.cw.crm.workbench.domain.Contacts;
import com.cw.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Resource
    private ContactsDao contactsDao;

    @Override
    public PaginationVO<Contacts> pageList(Map<String, Object> map) {

        // 获取符合记录的条数
        int total = contactsDao.getTotalByCondition(map);

        // 符合要求的记录
        List<Contacts> contactsList = contactsDao.getListByCondition(map);
        PaginationVO<Contacts> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(contactsList);

        return vo;
    }

    @Override
    public List<Contacts> getContactsListByName(String cname) {
        List<Contacts> contactsList = contactsDao.getContactsListByName(cname);

        return contactsList;
    }
}
