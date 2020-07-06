import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;

import javax.sql.DataSource;
import java.sql.*;
import java.util.Scanner;

/**
 * program: 2020-06-07-MySQL-JDBC编程.
 * Description:
 * User:
 * Date:2020年07月05日 23
 */
public class use_prepareStatement {
    public static void main(String[] args) throws SQLException {
        // 初始化一次，多次使用
        initDataSource();

        Scanner scanner = new Scanner(System.in);

        // 使用 Statement 的写法
        /*try (Connection connection = getConnection()) {
            // 查询以下 SQL: select * from exam_result where english > 某个值 and chinese > 某个值
            // 这个值需要用户输入
            System.out.print("请输入英语获奖分数> ");
            String ei = scanner.nextLine();
            System.out.print("请输入语文获奖分数> ");
            String ci = scanner.nextLine();

            try (Statement statement = connection.createStatement()) {
                // 自己使用 String 拼接 SQL，很容易出问题
                String sql = "select * from exam_result where english > " + ei + " and chinese > " + ci;
                System.out.println(sql);
                try (ResultSet resultSet = statement.executeQuery(sql)) {
                    while (resultSet.next()) {
                        String id = resultSet.getString("id");
                        String name = resultSet.getString("name");
                        String english = resultSet.getString("english");
                        String chinese = resultSet.getString("chinese");
                        String math = resultSet.getString("math");
                        System.out.println(id + ", " + name + ", " + english + ", " + chinese + ", " + math);
                    }
                }
            }
        }*/

        //使用 PrepareStatement 的方式
        try (Connection connection = getConnection()) {
            // 查询以下 SQL: select * from exam_result where english > 某个值 and chinese > 某个值
            // 这个值需要用户输入
            System.out.print("请输入英语获奖分数> ");
            int ei = scanner.nextInt();
            System.out.print("请输入语文获奖分数> ");
            int ci = scanner.nextInt();
            // 提前把 sql 写好，使用 ? 作为占位符
            String sql = "select * from exam_result where english > ? and chinese > ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                // 使用具体的值，替代占位符
                statement.setInt(1, ei);
                statement.setInt(2, ci);

                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        String id = resultSet.getString("id");
                        String name = resultSet.getString("name");
                        String english = resultSet.getString("english");
                        String chinese = resultSet.getString("chinese");
                        String math = resultSet.getString("math");
                        System.out.println(id + ", " + name + ", " + english + ", " + chinese + ", " + math);
                    }
                }
            }
        }
    }

    private static DataSource dataSource = null;

    private static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    private static void initDataSource() {
        MysqlDataSource mysqlDataSource = new MysqlDataSource();
        mysqlDataSource.setServerName("127.0.0.1");
        mysqlDataSource.setPort(3306);
        mysqlDataSource.setUser("root");
        mysqlDataSource.setPassword("123");
        mysqlDataSource.setDatabaseName("huojian_0604");
        mysqlDataSource.setUseSSL(false);
        mysqlDataSource.setCharacterEncoding("utf8");

        dataSource = mysqlDataSource;
    }
}
