package com.cw.crm.workbench.web.controller;

import com.cw.crm.settings.dao.UserDao;
import com.cw.crm.settings.domain.User;
import com.cw.crm.settings.service.UserService;
import com.cw.crm.utils.DateTimeUtil;
import com.cw.crm.utils.UUIDUtil;
import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.dao.CustomerDao;
import com.cw.crm.workbench.domain.Customer;
import com.cw.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/customer")
public class CustomerController {


    @Resource
    private CustomerService customerService;

    @Resource
    private UserService userService;

    @RequestMapping("/pageList.do")
    @ResponseBody
    public PaginationVO<Customer> pageList(Integer pageNo, Integer pageSize, String name, String owner, String phone, String website){
        Map<String,Object> map = new HashMap<>();
        // 计算忽略的页码
        Integer skipCount = (pageNo-1) * pageSize;
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        PaginationVO<Customer> vo = customerService.pageList(map);
         return vo;
    }

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> userList(){
        List<User> userList = userService.getUserList();
        return userList;
    }

    @RequestMapping("/save.do")
    @ResponseBody
    public Map<String,Object> save(HttpSession session,Customer customer){
        String id= UUIDUtil.getUUID();
        String createBy = ((User)session.getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        customer.setId(id);
        customer.setCreateBy(createBy);
        customer.setCreateTime(createTime);
        Map<String,Object> map = customerService.save(customer);

        return map;
    }

    @ResponseBody
    @RequestMapping("/getUserListAndCustomer")
    public Map<String,Object> getUserListAndCustomer(String id){
        Map<String,Object> map = new HashMap<>();

        List<User> userList = userService.getUserList();
        Customer customer = customerService.getCustomerById(id);
        map.put("userList",userList);
        map.put("customer",customer);
        return map;
    }

    @ResponseBody
    @RequestMapping("/update.do")
    public Map<String,Object> update(Customer customer, HttpSession session){
        String editBy = ((User)session.getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        customer.setEditBy(editBy);
        customer.setEditTime(editTime);

        Map<String,Object> map = customerService.update(customer);
        System.out.println(map.get("success"));
        return map;

    }

    @ResponseBody
    @RequestMapping("/delete.do")
    public Map<String,Object> delete(String[] id){
        Map<String,Object> map = customerService.delete(id);
        return map;
    }

    @ResponseBody
    @RequestMapping("/getCustomerDetailById.do")
    public ModelAndView getCustomerDetailById(String id){
        ModelAndView mv = new ModelAndView();
        Customer customer = customerService.getCustomerDetailById(id);
       mv.addObject("customer",customer);
        mv.setViewName("forward:/workbench/customer/detail.jsp");
        return mv;
    }
}
