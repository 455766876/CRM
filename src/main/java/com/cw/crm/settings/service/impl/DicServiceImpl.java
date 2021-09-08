package com.cw.crm.settings.service.impl;

import com.cw.crm.settings.dao.DicTypeDao;
import com.cw.crm.settings.dao.DicValueDao;
import com.cw.crm.settings.domain.DicType;
import com.cw.crm.settings.domain.DicValue;
import com.cw.crm.settings.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DicServiceImpl implements DicService {
    @Resource
    private DicTypeDao dicTypeDao;

    @Resource
    private DicValueDao dicValueDao;
    @Override

    public List<DicType> getDisTypeList() {
        List<DicType> dicTypeList = dicTypeDao.getDisTypeList();
        return dicTypeList;
    }

    @Override
    public List<DicValue> getDisValueListByTypeCode(String code) {
        List<DicValue> dicValueList = dicValueDao.getDisValueListByTypeCode(code);
        return dicValueList;
    }
}
