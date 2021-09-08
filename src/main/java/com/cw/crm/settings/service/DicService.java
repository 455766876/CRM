package com.cw.crm.settings.service;

import com.cw.crm.settings.domain.DicType;
import com.cw.crm.settings.domain.DicValue;

import java.util.List;

public interface DicService {
    List<DicType> getDisTypeList();

    List<DicValue> getDisValueListByTypeCode(String code);
}
