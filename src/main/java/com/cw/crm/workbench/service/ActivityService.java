package com.cw.crm.workbench.service;

        import com.cw.crm.vo.PaginationVO;
        import com.cw.crm.workbench.domain.Activity;
        import com.cw.crm.workbench.domain.ActivityRemark;

        import javax.servlet.http.HttpSession;
        import java.util.List;
        import java.util.Map;

public interface ActivityService {

    Boolean save(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] id);

    Map<String, Object> getUserListAndActivity(String id);

    Map<String, Object> update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    Map<String, Object> deleteRemarkById(String id);

    boolean saveRemark(ActivityRemark activityRemark);


    int updateRemark(ActivityRemark activityRemark);

    List<Activity> showActivityListByClueId(String clueId);

    List<Activity> getActivityByAnameAndNotRelation(Map<String, Object> map);

    List<Activity> getActivityListByAname(String aname);
}
