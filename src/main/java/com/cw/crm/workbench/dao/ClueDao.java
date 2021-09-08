package com.cw.crm.workbench.dao;

import com.cw.crm.workbench.domain.Clue;
import com.cw.crm.workbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int save(Clue clue);

    Integer getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    Clue getDetailById(String id);

    Clue getClueById(String id);

    int update(Clue clue);

    int delete(String[] id);

    int deleteById(String clueId);
}
