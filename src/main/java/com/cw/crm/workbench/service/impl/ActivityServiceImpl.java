package com.cw.crm.workbench.service.impl;

import com.cw.crm.settings.dao.UserDao;
import com.cw.crm.settings.domain.User;
import com.cw.crm.utils.DateTimeUtil;
import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.dao.ActivityDao;
import com.cw.crm.workbench.dao.ActivityRemarkDao;
import com.cw.crm.workbench.domain.Activity;
import com.cw.crm.workbench.domain.ActivityRemark;
import com.cw.crm.workbench.service.ActivityService;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// 市场活动控制器

@Service
public class ActivityServiceImpl implements ActivityService {

    @Resource
    private ActivityDao activityDao;

    @Resource
    private UserDao userDao;

    @Resource
    private ActivityRemarkDao activityRemarkDao;

    @Override
    public Boolean save(Activity activity) {

        int num = activityDao.save(activity);
        Boolean res = true;
        if (num != 1){
            res = false;
        }
        return res;
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {

        // 获取符合条件的记录
        List<Activity> activityList = activityDao.getActivityListByCondition(map);
        // 获取记录条数  返回给插件
        Integer total = activityDao.getTotalByCondition(map);


        PaginationVO<Activity> vo = new PaginationVO<>();

        vo.setDataList(activityList);
        vo.setTotal(total);
        return vo;
    }

    @Override
    public boolean delete(String[] id) {
        // 结果
        boolean flag = true;
        // 查询出需要删除的备注的条数 按照外键 ActivityId 查询
        int count1 = activityRemarkDao.getCountByAid(id);
        // 删除备注，返回受到影响的条数（实际删除的条数）
        int count2 = activityRemarkDao.deleteRemarkByAid(id);

        if (count1 != count2){
            flag = false;
        }
        // 删除市场活动
        int count3 = activityDao.deleteActivityById(id);
        if (count3 != id.length){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {

        // 获取 userList
        List<User> userList = userDao.getUserList();
        // 通过id 获取 Activity
        Activity activity = activityDao.getActivityById(id);
        // 返回 map
        Map<String,Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("activity",activity);
        return map;
    }

    @Override
    public Map<String, Object> update(Activity activity) {
        int flag = activityDao.update(activity);
        boolean res = true;
        if (flag != 1){
            res = false;
        }
        Map<String,Object> map = new HashMap<>();
        map.put("success",res);
        return map;
    }

    @Override
    public Activity detail(String id) {

       Activity activity = activityDao.detail(id);
        return activity;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String activityId) {
        List<ActivityRemark> remarkList = activityRemarkDao.getRemarkListByAid(activityId);
        return remarkList;
    }

    @Override
    public Map<String, Object> deleteRemarkById(String id) {
        int flag = activityRemarkDao.deleteRemarkById(id);
        boolean res = true;
        if (flag != 1) {
            res = false;
        }
        Map<String,Object> map = new HashMap<>();
        map.put("success",res);
        return map;
    }

    @Override
    public boolean saveRemark(ActivityRemark activityRemark) {
       int count = activityRemarkDao.saveRemark(activityRemark);
       boolean flag = true;
       if (count != 1){
           flag = false;
       }
        return flag;
    }

    @Override
    public int updateRemark(ActivityRemark activityRemark) {
        int count = activityRemarkDao.updateRemark(activityRemark);
        return count;
    }

    @Override
    public List<Activity> showActivityListByClueId(String clueId) {
        List<Activity> activityList = activityDao.showActivityListByClueId(clueId);
        return activityList;
    }

    @Override
    public List<Activity> getActivityByAnameAndNotRelation(Map<String, Object> map) {
        List<Activity> activityList = activityDao.getActivityByAnameAndNotRelation(map);
        return activityList;
    }

    @Override
    public List<Activity> getActivityListByAname(String aname) {
        List<Activity> activityList = activityDao.getActivityListByAname(aname);
        return activityList;
    }
}
