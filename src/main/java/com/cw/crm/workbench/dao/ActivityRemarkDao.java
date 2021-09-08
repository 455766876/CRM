package com.cw.crm.workbench.dao;

import com.cw.crm.workbench.domain.ActivityRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ActivityRemarkDao {

    int getCountByAid(String[] id);

    int deleteRemarkByAid(String[] id);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    int deleteRemarkById(String id);

    int saveRemark(ActivityRemark activityRemark);

    int updateRemark(ActivityRemark activityRemark);
}
