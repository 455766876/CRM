import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Date;


public class MyTest {


    @Test
    public void test(){
        String oldTime = "2021-08-22 04-11-36";
        Date data = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh-mm-ss");
        String time = sdf.format(data);
        System.out.println("time = " + time);
        System.out.println(oldTime.compareTo(time));
    }
}
