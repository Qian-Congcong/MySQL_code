package blog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

/**
 * program: 2020-06-08-MySQL-JDBC编程-实践.
 * Description:
 * User:
 * Date:2020年07月07日 14
 */
public class ArticlePublishAction implements Action {
    @Override
    public void run() {
        if (!User.isLogined()) {
            System.out.println("**需要先登录，才能操作该功能！！");
            return;
        }

        System.out.println("发表文章中...");
        Scanner scanner = new Scanner(System.in);
        System.out.print("请输入文章标题> ");
        String title = scanner.nextLine();
        System.out.print("请输入文章正文> ");
        String content = scanner.nextLine();
        int authorId = User.getCurrentUser().id;
        Date publishedAt = new Date();  // new 完的对象，本来就是当前时间
        // publishedAt 现在是 Date 对象，我们把 Date 对象 format 成 String 格式
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String publishedAtStr = format.format(publishedAt);

        // 现在信息已经获取完全，通过 jdbc 执行 insert 操作
        try (Connection c = DBUtil.getConnection()) {
            String sql = "insert into articles (author_id, title, published_at, content) values (?, ?, ?, ?)";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, authorId);
                ps.setString(2, title);
                ps.setString(3, publishedAtStr);    // "2020-06-08 20:10:38"
                ps.setString(4, content);

                ps.executeUpdate();

                System.out.println(" 《" + title + "》 文章发表成功！");
            }
        } catch (SQLException e) {
            System.out.println("错误： " + e.getMessage());
        }

    }
}
