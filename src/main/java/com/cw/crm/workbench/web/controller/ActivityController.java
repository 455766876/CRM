package com.cw.crm.workbench.web.controller;

import com.cw.crm.settings.domain.User;
import com.cw.crm.settings.service.UserService;
import com.cw.crm.utils.DateTimeUtil;
import com.cw.crm.utils.UUIDUtil;
import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.domain.Activity;
import com.cw.crm.workbench.domain.ActivityRemark;
import com.cw.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {

    @Resource
    private ActivityService activityService;

    @Resource
    private UserService userService;

    @RequestMapping("/getUserList.do")
    // 为创建查询所有者
    @ResponseBody
    public List<User> getUserList() {
        List<User> users = userService.getUserList();
        return users;
    }

    // 添加市场活动
    @ResponseBody
    @RequestMapping("/save.do")
    public Map<String, Object> save(HttpSession session, Activity activity) {
        String id = UUIDUtil.getUUID(); // 主键 id
        String createTime = DateTimeUtil.getSysTime(); // 创建时间
        String createBy = ((User) session.getAttribute("user")).getName(); // 创建人
        activity.setId(id);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        Map<String, Object> map = new HashMap<>();
        Boolean res = activityService.save(activity);

        map.put("success", res);
        return map;
    }

    // 查询市场活动

    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Activity> activityList(Integer pageNo, Integer pageSize,
                                               String name, String owner, String startDate, String endDate) {
        // 计算出略过的记录数 limit 是左开右闭的 (skipCount,pageSize]
        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        PaginationVO<Activity> vo = activityService.pageList(map);
        return vo;
    }

    // 删除操作
    @ResponseBody
    @RequestMapping("/delete.do")
    public Map<String, Object> delete(String[] id) {

        Map<String, Object> map = new HashMap<>();

        boolean flag = activityService.delete(id);
        map.put("success", flag);
        return map;
    }

    // 获取修改前记录信息
    @ResponseBody
    @RequestMapping("/getUserListAndActivity.do")
    public Map<String, Object> getUserListAndActivity(String id) {
        Map<String, Object> map = activityService.getUserListAndActivity(id);
        return map;
    }

    // 执行更新操作
    @ResponseBody
    @RequestMapping("/update.do")
    public Map<String, Object> update(Activity activity, HttpSession session) {

        // 修改时间
        String editDate = DateTimeUtil.getSysTime();
        // 修改人
        String editBy = ((User) session.getAttribute("user")).getName();

        // 加入到对象中
        activity.setEditTime(editDate);
        activity.setEditBy(editBy);
        Map<String, Object> map = activityService.update(activity);
        return map;
    }

    // 详细信息
    @RequestMapping("/detail.do")
    public ModelAndView detail(String id) {
        // 查询 所有人 + 市场活动信息
        Activity activity = activityService.detail(id);
        ModelAndView mv = new ModelAndView();
        mv.addObject("activity", activity);
        mv.addObject("uid",id);
        mv.setViewName("detail");
        return mv;
    }

    @ResponseBody
    @RequestMapping("getRemarkByAid.do")
    public List<ActivityRemark> getRemarkList(String activityId) {
        List<ActivityRemark> remarkList = activityService.getRemarkListByAid(activityId);
        return remarkList;
    }

    @ResponseBody
    @RequestMapping("/deleteRemark.do")
    public Map<String, Object> deleteRemarkById(String id) {
        Map<String, Object> map = activityService.deleteRemarkById(id);
        return map;
    }

    @ResponseBody
    @RequestMapping("/saveRemark.do")
    public Map<String, Object> saveRemark(ActivityRemark activityRemark, HttpSession session) {
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User) session.getAttribute("user")).getName(); // 创建人，当前登录用户
        String editFlag = "0";
        activityRemark.setId(id);
        activityRemark.setCreateBy(createBy);
        activityRemark.setCreateTime(createTime);
        activityRemark.setEditFlag(editFlag);
        boolean flag = activityService.saveRemark(activityRemark);
        Map<String, Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("remark",activityRemark);
        return map;
    }


    @ResponseBody
    @RequestMapping("/updateRemark.do")
    public Map<String, Object> updateRemark(ActivityRemark activityRemark, HttpSession session) {
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) session.getAttribute("user")).getName();
        String editFlag = "1";
        activityRemark.setEditTime(editTime);
        activityRemark.setEditBy(editBy);
        activityRemark.setEditFlag(editFlag);

        Map<String, Object> map = new HashMap<>();

        int count = activityService.updateRemark(activityRemark);
        boolean flag = true;
        if (count != 1) {
            flag = false;
        }
        map.put("success", flag);
        map.put("remark", activityRemark);
        return map;
    }
}
