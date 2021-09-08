package com.cw.crm.workbench.service.impl;

import com.cw.crm.workbench.dao.TranDao;
import com.cw.crm.workbench.service.TranService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class TranServiceImpl implements TranService {

    @Resource
    private TranDao tranDao;


}
