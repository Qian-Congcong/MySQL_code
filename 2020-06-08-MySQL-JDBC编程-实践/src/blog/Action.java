package blog;

/**
 * 有意识的把每个功能的操作，使用一个 Action 接口抽象了
 * 无论是什么功能，最终就是实现 Action.run 方法即可
 * 每个具体功能，都是这个 Action 的一些实现类
 */
public interface Action {
    void run();
}
