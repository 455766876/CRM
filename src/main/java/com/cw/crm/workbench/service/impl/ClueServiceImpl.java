package com.cw.crm.workbench.service.impl;

import com.cw.crm.exception.ConventException;
import com.cw.crm.utils.DateTimeUtil;
import com.cw.crm.utils.UUIDUtil;
import com.cw.crm.vo.PaginationVO;
import com.cw.crm.workbench.dao.*;
import com.cw.crm.workbench.domain.*;
import com.cw.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import sun.plugin2.os.windows.FLASHWINFO;

import javax.annotation.Resource;
import java.util.*;

@Service
public class ClueServiceImpl implements ClueService {

    // 线索相关表
    @Resource
    private ClueDao clueDao;
    @Resource
    private ClueActivityRelationDao clueActivityRelationDao; // 关联关系表
    @Resource
    private ClueRemarkDao clueRemarkDao;

    // 联系人相关表
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;

    // 客户相关表
    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;

    // 交易相关表
    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;

    public ClueServiceImpl() {
    }


    @Override
    public Map<String, Object> save(Clue clue) {
        int count = clueDao.save(clue);
        Map<String, Object> map = new HashMap<>();
        boolean flag = false;
        if (count == 1) {
            flag = true;
        }
        map.put("success", flag);
        return map;
    }

    @Override
    public PaginationVO<Clue> pageList(Map<String, Object> map) {
        // 获取符合条件的总条数
        Integer total = clueDao.getTotalByCondition(map);

        // 获取符合条件的 线索列
        List<Clue> clueList = clueDao.getClueListByCondition(map);

        PaginationVO<Clue> paginationVO = new PaginationVO<>();
        paginationVO.setTotal(total);
        paginationVO.setDataList(clueList);
        return paginationVO;
    }

    @Override
    public Clue detail(String id) {
        Clue clue = clueDao.getDetailById(id);
        return clue;
    }

    @Override
    public Clue getClueById(String id) {
        Clue clue = clueDao.getClueById(id);
        return clue;
    }

    @Override
    public Map<String, Object> update(Clue clue) {
        int count = clueDao.update(clue);
        boolean flag = false;
        if (count == 1) {
            flag = true;
        }
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        return map;
    }

    @Override
    public Map<String, Object> delete(String[] id) {
        int countId = id.length;
        int count = clueDao.delete(id);
        boolean flag = false;
        if (count == countId) {
            flag = true;
        }
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        return map;
    }

    @Override
    public List<ClueRemark> showRemarkList(String id) {
        List<ClueRemark> remarkList = clueRemarkDao.showRemarkList(id);
        return remarkList;
    }

    @Override
    public int saveRemark(ClueRemark clueRemark) {
        int count = clueRemarkDao.saveRemark(clueRemark);
        return count;
    }

    @Override
    public int updateRemark(ClueRemark clueRemark) {
        int count = clueRemarkDao.updateRemark(clueRemark);
        return count;
    }

    @Override
    public int deleteRemark(String id) {
        int count = clueRemarkDao.deleteRemark(id);
        return count;
    }

    @Override
    public boolean unbund(String id) {
        // 删除关联关系表中的记录
        int count = clueActivityRelationDao.unbund(id);

        boolean flag = false;
        if (count == 1) {
            flag = true;
        }
        return flag;
    }

    @Override
    public boolean bund(String clueId, String[] activityId) {
        boolean flag = true;
        for (String s : activityId) {
            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            String id = UUIDUtil.getUUID();
            clueActivityRelation.setActivityId(s);
            clueActivityRelation.setId(id);
            clueActivityRelation.setClueId(clueId);
            int count = clueActivityRelationDao.bund(clueActivityRelation);
            if (count != 1) {
                flag = false;
            }
        }

        return flag;
    }

    @Transactional
    @Override
    public boolean convert(String clueId, String createBy, Tran tran) {
        boolean flag = true;
        String createTime = DateTimeUtil.getSysTime();
        //  (1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue clue = clueDao.getClueById(clueId);
        //  (2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        // 公司名称
        String company = clue.getCompany();
        Customer customer = customerDao.getCustomerByName(company);
        // 如果customer 为空，说明还没有这个客户，需要新建一个
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(clue.getCompany());
            customer.setAddress(clue.getAddress());
            customer.setContactSummary(clue.getContactSummary());
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);
            customer.setDescription(clue.getDescription());
            customer.setOwner(clue.getOwner());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setNextContactTime(clue.getNextContactTime());

            // 添加客户
            int countCustomer = customerDao.save(customer);
            if (countCustomer != 1) {
                flag = false;
            }
        }

        //  (3) 通过线索对象提取联系人信息，保存联系人
        Contacts contacts = new Contacts();

        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setId(UUIDUtil.getUUID());
        contacts.setFullname(clue.getFullname());
        contacts.setEmail(clue.getEmail());
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(customer.getId());  // 客户的id
        contacts.setCreateTime(createTime);
        contacts.setCreateBy(createBy);
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());

        int countContacts = contactsDao.save(contacts);
        if (countContacts != 1) {
            flag = false;
        }

        //  (4) 线索备注转换到客户备注以及联系人备注
        // 通过 clueId 查询出备注

        List<ClueRemark> clueRemarkList = clueRemarkDao.getListByClueId(clueId);
        for (ClueRemark clueRemark : clueRemarkList) {
            // 创建客户备注对象，添加客户备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(DateTimeUtil.getSysTime());
            customerRemark.setCustomerId(clueRemark.getId()); // 客户id
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setEditFlag("0");

            int countCustomerRemark = customerRemarkDao.save(customerRemark);

            if (countCustomerRemark != 1) {
                flag = false;
            }

            // 创建联系人备注，添加联系人备注
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(DateTimeUtil.getSysTime());
            contactsRemark.setContactsId(clueRemark.getId()); // 客户id
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setEditFlag("0");
            int countContactsRemark = contactsRemarkDao.save(contactsRemark);

            if (countContactsRemark != 1) {
                flag = false;
            }
        }
        //  (5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系

        // 通过cluId 查询市场活动和线索的关联关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByClueId(clueId);
        for (ClueActivityRelation c : clueActivityRelationList) {
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(c.getActivityId());
            contactsActivityRelation.setContactsId(contacts.getId());
            int countContactsActivityRelation = contactsActivityRelationDao.save(contactsActivityRelation);

            if (countContactsActivityRelation != 1){
                flag = false;
            }
        }
        //  (6) 如果有创建交易需求，创建一条交易

        if (tran != null) {
            /*
            * 目前 tran对象中只含有 money，name,expectedDate,stage,activityId
            * 还有 owner，customerId,source,contactsId,createBy,createTime,description
            * */
            tran.setSource(contacts.getSource());
            tran.setOwner(contacts.getOwner());
            tran.setNextContactTime(contacts.getNextContactTime());
            tran.setDescription(contacts.getDescription());
            tran.setCustomerId(contacts.getCustomerId());
            tran.setContactSummary(contacts.getContactSummary());
            tran.setContactsId(contacts.getId());

            int countTran = tranDao.save(tran);
            if (countTran != 1) {
                flag = false;
            }
            //  (7) 如果创建了交易，则创建一条该交易下的交易历史

            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(tran.getStage());
            tranHistory.setTranId(tran.getId());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setCreateTime(createTime);
            tranHistory.setCreateBy(createBy);

            int countTranHistory = tranHistoryDao.save(tranHistory);
            if (countTranHistory != 1) {
                flag = false;
            }
        }
        //  (8) 删除线索备注
        int remarkLen = clueRemarkList.size(); // 线索是clueId的 集合的长度
        int count1 = clueRemarkDao.deleteRemarkByClueId(clueId);
        if (count1 != remarkLen) {
            flag = false;
        }
        //  (9) 删除线索和市场活动的关系
        int activityLen = clueActivityRelationList.size();
        int count2 = clueActivityRelationDao.deleteByClueId(clueId);
        if (count2 != activityLen) {
            flag = false;
        }
        //  (10) 删除线索
        int count3 = clueDao.deleteById(clueId);
        if (count3 != 1) {
            flag = false;
        }

        if (!flag){
            throw new ConventException("转换出现了异常");
        }
        return flag;
    }


}
