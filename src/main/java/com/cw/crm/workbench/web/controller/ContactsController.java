package com.cw.crm.workbench.web.controller;

import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.domain.Contacts;
import com.cw.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/workbench/contacts")
public class ContactsController {

    @Resource
    private ContactsService contactsService;

    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Contacts> pageList(Integer pageNo, Integer pageSize, String owner, String source, String customerId, String fullname, String birth){
        // 计算忽略的页码
        int  skipCount = (pageNo-1) * pageSize;

        System.out.println(skipCount + "," + pageSize);
        Map<String,Object> map = new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("owner",owner);
        map.put("source",source);
        map.put("customerId",customerId);
        map.put("fullname",fullname);
        map.put("birth",birth);
        PaginationVO<Contacts> vo = contactsService.pageList(map);
        return vo;
    }
}
