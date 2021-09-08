package com.cw.crm.web.listener;

import com.cw.crm.settings.domain.DicType;
import com.cw.crm.settings.domain.DicValue;
import com.cw.crm.settings.service.DicService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

// 监听哪个域就要实现哪个域的监听器
public class SysInitListener implements ServletContextListener {
    /*
     * 这个方法是用来创建上下文对象的方法，当服务器启动，上下文对象创建
     * 对象创建完毕后，马上执行该方法
     * servletContextEvent 该参数能取得监听器的对象，监听的是什么对象，就可以通过该参数取得对象
     * */
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {

        System.out.println("上写文作用域创建了================");
        System.out.println("服务器缓存处理数据字典开始");

        // 获取上下文对象
        ServletContext application = servletContextEvent.getServletContext();

        // 获取 service
        DicService dicService = WebApplicationContextUtils.getRequiredWebApplicationContext(application).getBean(DicService.class);

        /* map 用来存储 数据字典
        *
        * key----字典类型 如： application，source
        * value-----字典值
        * */
        Map<String,List<DicValue>> map = new HashMap<>();

         /*
           通过 DisType来获取 disValue
           获取字典类型的列表
         */
        List<DicType> dicTypeList = dicService.getDisTypeList();
        // 遍历字典类型列表
        for (DicType dt : dicTypeList
        ) {
            // 取得每一种字典类型的编码--code
            String code = dt.getCode();

            // 通过字典类型的编码--获取对应的字典值列表
            List<DicValue> dicValueList = dicService.getDisValueListByTypeCode(code);
            map.put(code, dicValueList);
        }

        // 将map解析为上下文中保存的键值对的形式
        Set<String> set = map.keySet();
        for (String key:set){
            application.setAttribute(key,map.get(key));
            System.out.println("key = " + key);
        }
        System.out.println("服务器缓存处理数据字典结束");
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
