package com.cw.crm.workbench.dao;

import com.cw.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> showRemarkList(String id);

    int updateRemark(ClueRemark clueRemark);

    int saveRemark(ClueRemark clueRemark);

    int deleteRemark(String id);

    List<ClueRemark> getListByClueId(String clueId);

    int deleteRemarkByClueId(String clueId);
}
