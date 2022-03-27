# Java 8 如何正确使用 Optional

Optional是Java8提供的为了解决null安全问题的一个API。善用Optional可以使我们代码中很多繁琐、丑陋的设计变得十分优雅。这篇文章是建立在你对Optional的用法有一定了解的基础上的，如果你还不太了解Optional，可以先去看看相关教程，或者查阅Java文档。

使用Optional，我们就可以把下面这样的代码进行改写。

```java
public static String getName(User u) {
    if (u == null)
        return "Unknown";
    return u.name;
}

```
不过，千万不要改写成这副样子。

```java
public static String getName(User u) {
    Optional<User> user = Optional.ofNullable(u);
    if (!user.isPresent())
        return "Unknown";
    return user.get().name;
}

```
这样改写非但不简洁，而且其操作还是和第一段代码一样。无非就是用isPresent方法来替代u==null。这样的改写并不是Optional正确的用法，我们再来改写一次。

```java
public static String getName(User u) {
    return Optional.ofNullable(u)
                    .map(user->user.name)
                    .orElse("Unknown");
}

```
这样才是正确使用Optional的姿势。那么按照这种思路，我们可以安心的进行链式调用，而不是一层层判断了。看一段代码：

```java
public static String getChampionName(Competition comp) throws IllegalArgumentException {
    if (comp != null) {
        CompResult result = comp.getResult();
        if (result != null) {
            User champion = result.getChampion();
            if (champion != null) {
                return champion.getName();
            }
        }
    }
    throw new IllegalArgumentException("The value of param comp isn't available.");
}

```
由于种种原因（比如：比赛还没有产生冠军、方法的非正常调用、某个方法的实现里埋藏的大礼包等等），我们并不能开心的一路comp.getResult().getChampion().getName()到底。而其他语言比如kotlin，就提供了在语法层面的操作符加持：comp?.getResult()?.getChampion()?.getName()。所以讲道理在Java里我们怎么办！

让我们看看经过Optional加持过后，这些代码会变成什么样子。

```java
public static String getChampionName(Competition comp) throws IllegalArgumentException {
    return Optional.ofNullable(comp)
            .map(c->c.getResult())
            .map(r->r.getChampion())
            .map(u->u.getName())
            .orElseThrow(()->new IllegalArgumentException("The value of param comp isn't available."));
}

```
这就很舒服了。Optional给了我们一个真正优雅的Java风格的方法来解决null安全问题。虽然没有直接提供一个操作符写起来短，但是代码看起来依然很爽很舒服。更何况?.这样的语法好不好看还见仁见智呢。

还有很多不错的使用姿势，比如为空则不打印可以这么写：

```java
string.ifPresent(System.out::println);

```
Optional的魅力还不止于此，Optional还有一些神奇的用法，比如Optional可以用来检验参数的合法性。

```java
public void setName(String name) throws IllegalArgumentException {
    this.name = Optional.ofNullable(name).filter(User::isNameValid)
                        .orElseThrow(()->new IllegalArgumentException("Invalid username."));
}

```
这样写参数合法性检测，应该足够优雅了吧。
