package com.cw.crm.workbench.web.controller;

import com.cw.crm.settings.domain.User;
import com.cw.crm.settings.service.UserService;
import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.domain.Activity;
import com.cw.crm.workbench.domain.Contacts;
import com.cw.crm.workbench.domain.Tran;
import com.cw.crm.workbench.service.ActivityService;
import com.cw.crm.workbench.service.ContactsService;
import com.cw.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@RequestMapping("/workbench/transaction")
@Controller
public class TranController {

    @Resource
    private UserService userService;

    @Resource
    private ActivityService activityService;

    @Resource
    private ContactsService contactsService;
    @Resource
    private  CustomerService customerService;

    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Tran> pageList(String pageNo, String pageSize, String owner, String name, String customerId, String stage, String type, String source, String contactsId) {
        System.out.println(pageNo);
        System.out.println(pageSize);
        System.out.println(owner);
        System.out.println(name);
        System.out.println(customerId);
        System.out.println(stage);
        System.out.println(type);
        System.out.println(source);
        System.out.println(contactsId);
        return null;
    }

//    @ResponseBody
    @RequestMapping("/openSave.do")
    public ModelAndView openSave() {
        ModelAndView mv = new ModelAndView();
        List<User> userList = userService.getUserList();
        mv.addObject("userList",userList);
        mv.setViewName("forward:/workbench/transaction/save.jsp");
        return mv;
    }

    @ResponseBody
    @RequestMapping("/getActivityByAname.do")
    public List<Activity> getActivityByAname(String aname){
        System.out.println(aname);
        List<Activity> activityList = activityService.getActivityListByAname(aname);
        System.out.println(activityList);
        return activityList;
    }

    @ResponseBody
    @RequestMapping("/getContactsListByName.do")
    public List<Contacts> getContactsListByName(String cname){
        System.out.println(cname);
        List<Contacts> contactsList = contactsService.getContactsListByName(cname);
        System.out.println(contactsList);
        return contactsList;
    }


    @ResponseBody
    @RequestMapping("/getCustomerName.do")
    public List<String> getCustomerName(String name){
        System.out.println(name);
        List<String> list = customerService.getCustomerByName(name);
        System.out.println(list);
        return list;
    }
}








