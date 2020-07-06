package com.ali;

import java.sql.*;
import java.util.Arrays;
import java.util.Scanner;

/**
 *模拟一个 mysql 命令行客户端
 *  * 1. JDBC 的使用
 *  * 2. 理解我们平时用的 mysql 客户端是怎么工作的，例如，为什么要指定参数？为什么要用分号结尾？不用分号结尾会怎么办？
 *  * 3. 理解 cmd 上，启动 java 的各种知识点
 *
 * Date:2020-06-08 20
 */
public class MySQLClient {
    /**
     * 以下配置， 可以通过 parseArguments 进行替换
     */
    private static String host = "127.0.0.1";
    private static int port = 3306;
    private static String user = null;
    private static String password = "";
    private static String defaultDatabaseName = "";

    public static void main(String[] args) throws ClassNotFoundException {
        //System.out.println(args);
        System.out.println(Arrays.toString(args));
        //args 代表的就是用户输入的参数
        if (args.length == 0) {
            printUsageAndExit();
        }

        // 解析参数，获取连接数据库的信息
        parseArguments(args);
        /*System.out.println(host);
        System.out.println(port);
        System.out.println(user);
        System.out.println(password);
        System.out.println(defaultDatabaseName);*/

        // 1. 进行数据库连接
        Class.forName("com.mysql.jdbc.Driver");
        String url = String.format("jdbc:mysql://%s:%d/%s?useSSL=false&charsetEncoding=utf8",
                host, port, defaultDatabaseName);
        System.out.println("DEBUG: url = " + url);
        System.out.println("DEBUG: user = " + user);
        System.out.println("DEBUG: password = " + password);

        try {
            //一次连接
            Connection connection = DriverManager.getConnection(url, user, password);
            printWelcome();

            // 进入之前所谓的 mysql 界面了
            Scanner scanner = new Scanner(System.in);
            System.out.print("mysql> ");
            //一次连接，多次 sql 执行
            while (true) {
                String cmd = scanner.nextLine();
                //模拟，使用 quit 可以退出
                //quit 不需要输入 分号
                //equalsIgnoreCase()将此String与其他String比较，忽略案例注意事项。 如果两个字符串的长度相同，并且两个字符串中的相应字符等于忽略大小写，则两个字符串被认为是相等的。
                if (cmd.equalsIgnoreCase("quit")) {
                    break;
                }

                //模拟真实 mysql 中，不输入 分号， 一行命令就不结束的现象
                while (!cmd.endsWith(";")) {
                    System.out.print("   ->");
                    cmd += scanner.nextLine();
                }

                //分号 只是 MySQL 程序的要求，不是 SQL 语言的要求
                cmd = cmd.substring(0, cmd.length() - 1);
                System.out.println("DEBUG: " + cmd);

                //select 和 show 开头的 sql， 是会返回结果的
                //所以使用， 带 ResultSet 的查询方式
                //否则，使用 executeUpdate 的执行方式
                //多次 sql 执行
                try {
                    if (cmd.startsWith("select") || cmd.startsWith("show")) {
                        executeQuery(connection, cmd);
                    } else {
                        executeUpdate(connection, cmd);
                    }
                }catch (SQLException e) {
                    //SQL 执行错误，只把错误信息打印下
                    //然后让用户继续下一个 SQL 的执行
                    System.out.println(e.getMessage());
                }

                System.out.print("mysql> ");
            }

            connection.close();
        } catch (SQLException e) {
            printUsageAndExit(e.toString());
        }

    }

    private static void executeUpdate(Connection connection, String sql) throws SQLException {
    long b = System.currentTimeMillis();
    Statement statement = connection.createStatement();
    int count = statement.executeUpdate(sql);

    long e = System.currentTimeMillis();
        System.out.printf("Query OK, %d rows affected (%.2f sec)%n", count, (e - b) / 1000.0);
        statement.close();
    }

    private static void executeQuery(Connection connection, String sql) throws SQLException {
        long b = System.currentTimeMillis();

        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);
        //利用结果集中的“元数据 MetaData” 获取一些基本信息
        //一共有多少列
        //每一列的名称是什么
        int columnCount = resultSet.getMetaData().getColumnCount();
        //打印表头 - 打印列的名称
        for (int i = 0; i < columnCount; i++) {
            String label = resultSet.getMetaData().getColumnLabel(i + 1);
            if (i != columnCount - 1) {
                System.out.print(label + ", ");
            }else {
                System.out.println(label);
            }
        }
        //依次去遍历每一行，打印每一行的结果
        int rowCount = 0;
        while (resultSet.next()) {
            rowCount++;
            for (int i = 0; i < columnCount; i++) {
                String value = resultSet.getString(i + 1);
                if (i != columnCount - 1) {
                    System.out.print(value + ",");
                }else {
                    System.out.println(value);
                }
            }
        }

        long e = System.currentTimeMillis();
        System.out.printf("%d rows in set (%.2f sec)%n", rowCount, (e - b) / 1000.0);

        resultSet.close();
        statement.close();
    }

    private static void printWelcome() {
        System.out.println("欢迎使用 MySQLClient");
        System.out.println();
    }

    /**
     * 解析用户输入的参数，获取连接 MySQL 服务的信息
     * @param args
     */
    private static void parseArguments(String[] args) {
        if (args.length % 2 == 0) {
            printUsageAndExit("必须输入默认数据库名称");
        }

        defaultDatabaseName = args[args.length - 1];
        args = Arrays.copyOfRange(args, 0, args.length - 1);

        for (int i = 0; i < args.length; i++) {
            String arg = args[i];
            switch (arg) {
                case "-h":
                case "--host":
                    host = args[++i];
                    break;
                case "-P":
                case "--port":
                    port = Integer.parseInt(args[++i]);
                    break;
                case "-u":
                case "--user":
                    user = args[++i];
                    break;
                case "-p":
                case "--password":
                    password = args[++i];
                    break;
                default:
                    printUsageAndExit("不认识的选项: " + arg);
            }
        }
    }

    /**
     * 打印帮助信息并退出
     * @param messages
     */
    private static void printUsageAndExit(String... messages) {
        System.out.println("使用帮助: mysql [选项] 默认数据库");
        System.out.println(" -h, --host     连接主机，默认是 127.0.0.1");
        System.out.println(" -P, --port     连接端口，默认是 3306");
        System.out.println(" -u, --user     mysql 用户名，必须设置");
        System.out.println(" -p, --password mysql 密码");

        //1. stream 的操作
        //2. 方法引用
        //等于下面代码的简单版本
        //Arrays.stream(messages).peek(System.out::println);

        for (String s : messages) {
            System.out.println(s);
        }

        System.exit(1);
    }
}
