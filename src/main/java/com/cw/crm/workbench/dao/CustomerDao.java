package com.cw.crm.workbench.dao;

import com.cw.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer customer);

    int getTotalByCondition(Map<String, Object> map);

    List<Customer> getListByCondition(Map<String,Object> map);

    Customer getCustomerById(String id);

    int update(Customer customer);

    int delete(String[] id);

    Customer getCustomerDetailById(String id);

    List<String> getCustomer(String name);
}
