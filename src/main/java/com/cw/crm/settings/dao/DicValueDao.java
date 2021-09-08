package com.cw.crm.settings.dao;

import com.cw.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getDisValueListByTypeCode(String code);
}
