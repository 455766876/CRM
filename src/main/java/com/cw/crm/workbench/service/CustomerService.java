package com.cw.crm.workbench.service;

import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    PaginationVO<Customer> pageList(Map<String, Object> map);

    Map<String, Object> save(Customer customer);

    Customer getCustomerById(String id);

    Map<String, Object> update(Customer customer);

    Map<String, Object> delete(String[] id);

    Customer getCustomerDetailById(String id);

    List<String> getCustomerByName(String name);
}
