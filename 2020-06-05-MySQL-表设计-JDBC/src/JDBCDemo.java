
import java.sql.*;

/**
 * program: 2020-06-05-MySQL-表设计-JDBC
 * Created with IntelliJ IDEA.
 * Description:
 * User: YouName
 * Date:2020-06-08 19
 * Time:40
 */
public class JDBCDemo {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        /*Class<?> cls = Class.forName("com.mysql.jdbc.Driver");
        System.out.println(cls.getSimpleName());*/

        //注册驱动 -- 选择了乙方
        Class.forName("com.mysql.jdbc.Driver");

        /**
         *完整的目标是执行 select * from exam_result;
         */

        //建立数据库连接

        //以后写项目，只需要修改默认数据库名称即可
        //写明 MySQL 服务端所在地
        String defaultDatabaseName = "huojian_0604";
        String password = "123"; //填写你自己的 MySQL 密码

        //下面这里，基本上不变
        String user = "root";
        String url = "jdbc:mysql://127.0.0.1:3306/" + defaultDatabaseName + "?useSSL=false&characterEncoding=utf8";

        Connection connection = DriverManager.getConnection(url, user, password);
        //打印 connection 对象，验证是否连接成功
        System.out.println(connection);
        //queryDemo(connection);

        updateDemo(connection);

        //-1. 关闭刚才的连接
        connection.close();
    }

    private static void updateDemo(Connection connection) throws SQLException {
        //获取 Statement 对象
        Statement statement = connection.createStatement();
        String sql = "insert into exam_result (id, name, chinese, math, english) values ('9', '小桐', '67', '98', '74')";
        int affectedRows = statement.executeUpdate(sql);
        System.out.printf("Query OK, %d row affected%n", affectedRows);

        statement.close();
    }

    private static void queryDemo(Connection connection) throws SQLException {
        //要真正的执行 sql 语言， 并且获取数据库连接返回的结果
        //Statement 代表的是 “语句的” 的抽象对象
        Statement statement = connection.createStatement();
        String sql = "select * from exam_result"; // 没有要求必须分号结尾
        //1. executeQuery 用在查询（query）场景下
        //2. ResultSet 代表是结果集的抽象对象
        ResultSet resultSet = statement.executeQuery(sql);

        int count = 0;
        System.out.println("+------+--------+---------+------+---------+");
        System.out.println("| id   | name   | chinese | math | english |");
        System.out.println("+------+--------+---------+------+---------+");
        while (resultSet.next()) {
           String id = resultSet.getString(1);
           String name = resultSet.getString(2);
           String chinese = resultSet.getString(3);
           String math = resultSet.getString(4);
           String english = resultSet.getString(5);

            System.out.format("| %4s | %6s | %7s | %4s | %7s |%n", id, name, chinese, math, english);
            count++;
        }
        System.out.println("+------+--------+---------+------+---------+");
        System.out.format("%d rows in set", count);

        //-3. 管壁 resultSet 对象
        resultSet.close();

        //-2 关闭 statement 对象
        statement.close();
    }
}
