import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * program: 2020-06-07-MySQL-JDBC编程.
 * Description:
 * User:
 * Date:2020年07月05日 23
 */
public class use_datasource {
    public static void getConnectionUseDriverManger() throws ClassNotFoundException, SQLException {
        // 1. 注册驱动
        Class.forName("com.mysql.jdbc.Driver");
        // 2. 获取连接
        String url = "jdbc:mysql://127.0.0.1:3306/huojian_0604?useSSL=false&charsetEncoding=utf8";
        String user = "root";
        String password = "123";

        try (Connection connection = DriverManager.getConnection(url, user, password)) {
            // 我的目的就是要获取 Connection 对象
        }
    }

    // 1. 这个是新版 JDBC 标准提供的写法
    // 2. 写法比 url 的方式更加明确，不容易出现拼写错误
    // 3. 支持连接池的方式，所以可能效率更高
    public static void getConnectionUseDataSource() throws SQLException {
        DataSource dataSource;

        MysqlDataSource mysqlDataSource = new MysqlDataSource();
        mysqlDataSource.setServerName("127.0.0.1");
        mysqlDataSource.setPort(3306);
        mysqlDataSource.setUser("root");
        mysqlDataSource.setPassword("123");
        mysqlDataSource.setDatabaseName("huojian_0604");
        mysqlDataSource.setUseSSL(false);
        mysqlDataSource.setCharacterEncoding("utf8");
        // DataSource 也支持 url 的方式指定连接参数
        //或者 mysqlDataSource.setUrl("jdbc:mysql://127.0.0.1:3306/huojianban2_0601?useSSL=false&characterEncoding=utf8");

        dataSource = mysqlDataSource;

        try (Connection connection = dataSource.getConnection()) {
            // 我的目的就是要获取 Connection 对象
        }
    }
}
