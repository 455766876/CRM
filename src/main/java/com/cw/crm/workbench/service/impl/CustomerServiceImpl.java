package com.cw.crm.workbench.service.impl;

import com.cw.crm.settings.dao.UserDao;
import com.cw.crm.settings.domain.User;
import com.cw.crm.settings.service.UserService;
import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.dao.CustomerDao;
import com.cw.crm.workbench.domain.Customer;
import com.cw.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Resource
    private CustomerDao customerDao;

    @Override
    public PaginationVO<Customer> pageList(Map<String, Object> map) {
        // 获取符合条件的总条数
        int total = customerDao.getTotalByCondition(map);

        // 获取符合条件的记录
        List<Customer> customerList = customerDao.getListByCondition(map);
        PaginationVO<Customer> vo = new PaginationVO<>();
        vo.setDataList(customerList);
        vo.setTotal(total);
        return vo;
    }

    @Override
    public Map<String, Object> save(Customer customer) {
        Map<String, Object> map = new HashMap<>();
        int flag = customerDao.save(customer);
        boolean res = true;
        if (flag != 1){
            res = false;
        }
        map.put("success",res);
        return map;
    }

    @Override
    public Customer getCustomerById(String id) {
        Customer customer = customerDao.getCustomerById(id);
        return customer;
    }

    @Override
    public Map<String, Object> update(Customer customer) {
        int count = customerDao.update(customer);
        Map<String,Object> map = new HashMap<>();
        boolean flag = true;
        if (count != 1){
            flag = false;
        }
        map.put("success",flag);
        return map;
    }

    @Override
    public Map<String, Object> delete(String[] id) {
        Map<String, Object> map = new HashMap<>();
        int count = customerDao.delete(id);
        boolean flag = true;
        if (count != id.length){
            flag = false;
        }
        map.put("success",flag);
        return map;
    }

    @Override
    public Customer getCustomerDetailById(String id) {
        Customer customer = customerDao.getCustomerDetailById(id);
        return customer;
    }

    @Override
    public List<String> getCustomerByName(String name) {
        List<String> list = customerDao.getCustomer(name);
        return list;
    }
}
