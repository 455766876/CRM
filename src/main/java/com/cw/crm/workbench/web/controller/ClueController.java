package com.cw.crm.workbench.web.controller;

import com.cw.crm.settings.domain.User;
import com.cw.crm.settings.service.UserService;
import com.cw.crm.utils.DateTimeUtil;
import com.cw.crm.utils.UUIDUtil;
import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.domain.*;
import com.cw.crm.workbench.service.ActivityService;
import com.cw.crm.workbench.service.ClueService;
import com.sun.org.apache.xpath.internal.operations.Mod;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

    @Resource
    private UserService userService;

    @Resource
    private ClueService clueService;

    @Resource
    private ActivityService activityService;

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> userList() {
        List<User> userList = userService.getUserList();
        return userList;
    }

    @ResponseBody
    @RequestMapping("/save.do")
    public Map<String, Object> save(Clue clue, HttpSession session) {
        String createBy = ((User) session.getAttribute("user")).getName();
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        clue.setId(id);
        clue.setCreateTime(createTime);
        clue.setCreateBy(createBy);
        Map<String, Object> map = clueService.save(clue);
        return map;
    }

    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Clue> pageList(Integer pageNo, Integer pageSize, String fullname, String company, String phone,
                                       String source, String owner, String mphone, String state) {
        // 计算limit 语句的开头行
        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        map.put("fullname", fullname);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        PaginationVO<Clue> pageList = clueService.pageList(map);
        return pageList;
    }

    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView dedail(String id) {
        ModelAndView mv = new ModelAndView();
        Clue clue = clueService.detail(id);

        mv.addObject("clue", clue);
        mv.setViewName("forward:detail.jsp");
        return mv;
    }

    @ResponseBody
    @RequestMapping("/getUserListAndClue.do")
    public Map<String, Object> getUserListAndClue(String id) {
        List<User> userList = userService.getUserList();  // 获取所有者
        Clue clue = clueService.getClueById(id);
        Map<String, Object> map = new HashMap<>();
        map.put("userList", userList);
        map.put("clue", clue);
        return map;
    }

    @ResponseBody
    @RequestMapping("/update.do")
    public Map<String, Object> update(Clue clue, HttpSession session) {
        String editBy = ((User) session.getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        Map<String, Object> map = clueService.update(clue);
        return map;
    }

    @ResponseBody
    @RequestMapping("/delete.do")
    public Map<String, Object> delete(String[] id) {
        Map<String, Object> map = clueService.delete(id);
        return map;
    }

    @ResponseBody
    @RequestMapping("/showRemarkList.do")
    public List<ClueRemark> showRemarkList(String id) {
        List<ClueRemark> remarkList = clueService.showRemarkList(id);
        return remarkList;
    }

    @ResponseBody
    @RequestMapping("/updateRemark.do")
    public Map<String, Object> updateRemark(ClueRemark clueRemark, HttpSession session) {
        String editBy = ((User) session.getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        String editFlag = "1";
        clueRemark.setEditBy(editBy);
        clueRemark.setEditTime(editTime);
        clueRemark.setEditFlag(editFlag);
        int count = clueService.updateRemark(clueRemark);
        Map<String, Object> map = new HashMap<>();
        boolean flag = false;
        if (count == 1) {
            flag = true;
        }
        map.put("success", flag);
        map.put("remark", clueRemark);
        return map;
    }

    @ResponseBody
    @RequestMapping("/saveRemark.do")
    public Map<String, Object> saveRemark(ClueRemark clueRemark, HttpSession session) {
        String id = UUIDUtil.getUUID();
        String createBy = ((User) session.getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String editFlag = "0";
        clueRemark.setId(id);
        clueRemark.setCreateBy(createBy);
        clueRemark.setCreateTime(createTime);
        clueRemark.setEditFlag(editFlag);

        Map<String, Object> map = new HashMap<>();
        int count = clueService.saveRemark(clueRemark);
        boolean flag = false;
        if (count == 1) {
            flag = true;
        }
        map.put("success", flag);
        map.put("remark", clueRemark);
        return map;
    }

    @ResponseBody
    @RequestMapping("/deleteRemark.do")
    public Map<String, Object> deleteRemark(String id) {
        int count = clueService.deleteRemark(id);
        boolean flag = false;
        if (count == 1) {
            flag = true;
        }
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        return map;
    }

    @ResponseBody
    @RequestMapping("/showActivityListByClueId.do")
    public List<Activity> showActivityListByClueId(String clueId) {
        List<Activity> activityList = activityService.showActivityListByClueId(clueId);
        return activityList;

    }

    @ResponseBody
    @RequestMapping("/unbund.do")
    public Map<String, Object> unbund(String id) {
        boolean flag = clueService.unbund(id);
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        return map;
    }

    @ResponseBody
    @RequestMapping("/getActivityByAnameAndNotRelation.do")
    public List<Activity> getActivityByAnameAndNotRelation(String aname, String clueId) {
        Map<String, Object> map = new HashMap<>();
        map.put("aname", aname);
        map.put("clueId", clueId);
        List<Activity> activityList = activityService.getActivityByAnameAndNotRelation(map);
        return activityList;
    }

    @ResponseBody
    @RequestMapping("/bund.do")
    public Map<String, Object> bund(String clueId, String[] activityId) {
        Map<String, Object> map = new HashMap<>();

        boolean flag = clueService.bund(clueId, activityId);
        map.put("success", flag);
        return map;
    }

    @ResponseBody
    @RequestMapping("/getActivityListByAname.do")
    public List<Activity> getActivityListByAname(String aname) {
        List<Activity> activityList = activityService.getActivityListByAname(aname);
        return activityList;
    }

    @RequestMapping("/convert.do")
    public ModelAndView convert(HttpSession session, String clueId, String flag, String money, String name, String expectedDate, String stage, String activityId) {
        ModelAndView mv = new ModelAndView();
        Tran tran = null;
        String createBy = ((User)session.getAttribute("user")).getName();
        if ("a".equals(flag)) {

            // 有交易,接收交易表单中的记录，准备创建表单要用的记录
            // service 可以通过 tran是否为空开判断是否进行了交易
            tran = new Tran();
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setActivityId(activityId);

            tran.setId(UUIDUtil.getUUID());
            tran.setCreateBy(createBy);
            tran.setCreateTime(DateTimeUtil.getSysTime());
        }
        /*
            传递的值必须要有 clueId 不然无法查询线索
            但是，创建客户和联系人表时，还需要 createBy 和 createTime 和 id
            这里，我们只传一个 createBy，其他的在 service中获取
         */
        boolean res = clueService.convert(clueId, createBy, tran);
        if (res) {
            mv.setViewName("redirect:/workbench/clue/index.jsp");
        }else {
            mv.addObject("info","修改失败");
            mv.setViewName("redirect:/workbench/clue/index.jsp");
        }
        return mv;
    }
}
