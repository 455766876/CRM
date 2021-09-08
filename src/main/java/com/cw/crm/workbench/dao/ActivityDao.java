package com.cw.crm.workbench.dao;

import com.cw.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;


public interface ActivityDao {

    int save(Activity activity);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    int deleteActivityById(String[] id);

    Activity getActivityById(String id);

    int update(Activity activity);

    Activity detail(String id);

    List<Activity> showActivityListByClueId(String clueId);

    List<Activity> getActivityByAnameAndNotRelation(Map<String, Object> map);

    List<Activity> getActivityListByAname(String aname);
}
