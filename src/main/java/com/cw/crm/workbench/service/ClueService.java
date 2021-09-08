package com.cw.crm.workbench.service;

import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.domain.Activity;
import com.cw.crm.workbench.domain.Clue;
import com.cw.crm.workbench.domain.ClueRemark;
import com.cw.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    Map<String, Object> save(Clue clue);

    PaginationVO<Clue> pageList(Map<String, Object> map);

    Clue detail(String id);

    Clue getClueById(String id);

    Map<String, Object> update(Clue clue);

    Map<String, Object> delete(String[] id);

    List<ClueRemark> showRemarkList(String id);

    int updateRemark(ClueRemark clueRemark);

    int saveRemark(ClueRemark clueRemark);

    int deleteRemark(String id);

    boolean unbund(String id);

    boolean bund(String clueId, String[] activityId);


    boolean convert(String clueId, String createBy, Tran tran);
}
