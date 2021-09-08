package com.cw.crm.vo;

import java.util.List;

public class PaginationVO<T> {
    /*
    * 将来分页查询，每个模块都有，所以我们选择使用一个通用 vo 操作起来比较方便
    * 集合使用泛型  类型使用 T
    * */

    private Integer total; // 全部记录条数
    private List<T> dataList; // 查询的记录集合

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }

    @Override
    public String toString() {
        return "PaginationVO{" +
                "total=" + total +
                ", dataList=" + dataList +
                '}';
    }
}
