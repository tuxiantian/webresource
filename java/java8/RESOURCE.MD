在Java 8的新功能特性中，最棒的特性就是允许我们去表达我们想要完成什么而不是要怎样做。这正是循环的不足之处。要确保循环的灵活性是需要付出代价的。  
return、break 或者 continue都会显著地改变循环的实际表现。这迫使我们不仅要清楚我们要实现怎样的代码，还要了解循环是怎样工作的。  
现在我们要看看怎样把这些循环转换为更简洁，可读性更高的代码。  

以文章为例子。一篇文章拥有一个标题，一个作者和几个标签。  
```
private class Article {
 
        private final String title;
        private final String author;
        private final List<String> tags;
 
        private Article(String title, String author, List<String> tags) {
            this.title = title;
            this.author = author;
            this.tags = tags;
        }
 
        public String getTitle() {
            return title;
        }
 
        public String getAuthor() {
            return author;
        }
 
        public List<String> getTags() {
            return tags;
        }
    }
```
每个例子都会包含一个使用传统循环的方案和一个使用Java 8新特性的方案。

在第一个例子里，我们要在集合中查找包含“Java”标签的第一篇文章。

看一下使用for循环的解决方案。
```
public Article getFirstJavaArticle() {
 
    for (Article article : articles) {
        if (article.getTags().contains("Java")) {
            return article;
        }
    }
 
    return null;
}
```
现在我们使用Stream API的相关操作来解决这个问题。
```
public Optional<Article> getFirstJavaArticle() {  
    return articles.stream()
        .filter(article -> article.getTags().contains("Java"))
        .findFirst();
    }
```
是不是很酷？我们首先使用 filter 操作去找到所有包含Java标签的文章，然后使用 findFirst() 操作去获取第一次出现的文章。因为Stream是“延迟计算”（lazy）的并且filter返回一个流对象，所以这个方法仅在找到第一个匹配元素时才会处理元素。

现在，让我们获取所有匹配的元素而不是仅获取第一个。

首先使用for循环方案。
```
public List<Article> getAllJavaArticles() {
 
    List<Article> result = new ArrayList<>();
 
    for (Article article : articles) {
        if (article.getTags().contains("Java")) {
            result.add(article);
        }
    }
 
    return result;
}
```
使用Stream操作的方案。
```
public List<Article> getAllJavaArticles() {  
    return articles.stream()
        .filter(article -> article.getTags().contains("Java"))
        .collect(Collectors.toList());
    }
```
在这个例子里我们使用 collection 操作在返回流上执行少量代码而不是手动声明一个集合并显式地添加匹配的文章到集合里。

到目前为止还不错。是时候举一些突出Stream API强大的例子了。

根据作者来把所有的文章分组。

照旧，我们使用循环方案。
```
public Map<String, List<Article>> groupByAuthor() {
 
    Map<String, List<Article>> result = new HashMap<>();
 
    for (Article article : articles) {
        if (result.containsKey(article.getAuthor())) {
            result.get(article.getAuthor()).add(article);
        } else {
            ArrayList<Article> articles = new ArrayList<>();
            articles.add(article);
            result.put(article.getAuthor(), articles);
        }
    }
 
    return result;
}
```
我们能否找到一个使用流操作的简洁方案来解决这个问题？
```
public Map<String, List<Article>> groupByAuthor() {  
    return articles.stream()
        .collect(Collectors.groupingBy(Article::getAuthor));
}
```
很好！使用 groupingBy 操作和 getAuthor 方法，我们得到了更简洁、可读性更高的代码。

现在，我们查找集合中所有不同的标签。

我们从使用循环的例子开始。
```
public Set<String> getDistinctTags() {
 
    Set<String> result = new HashSet<>();
 
    for (Article article : articles) {
        result.addAll(article.getTags());
    }
 
    return result;
}
```
好，我们来看看如何使用Stream操作来解决这个问题。
```
public Set<String> getDistinctTags() {  
    return articles.stream()
        .flatMap(article -> article.getTags().stream())
        .collect(Collectors.toSet());
}
```
棒极了！flatmap 帮我把标签列表转为一个返回流，然后我们使用 collect 去创建一个集合作为返回值。

Stream综合示例
```
class User
{
    private String userID;
    private boolean isVip;
    private int balance;

    public User(String userID, boolean isVip, int balance)
    {
        this.userID = userID;
        this.isVip = isVip;
        this.balance = balance;
    }

    public boolean isVip()
    {
        return this.isVip;
    }

    public String getUserID()
    {
        return this.userID;
    }

    public int getBalance()
    {
        return this.balance;
    }
}

public class HelloWorld
{    
    public static void main(String[] args)
    {
        ArrayList<User> users = new ArrayList<>();
        users.add(new User("2017001", false, 0));
        users.add(new User("2017002", true, 36));
        users.add(new User("2017003", false, 98));
        users.add(new User("2017004", false, 233));
        users.add(new User("2017005", true, 68));
        users.add(new User("2017006", true, 599));
        users.add(new User("2017007", true, 1023));
        users.add(new User("2017008", false, 9));
        users.add(new User("2017009", false, 66));
        users.add(new User("2017010", false, 88));

        //普通实现方式
        ArrayList<User> tempArray = new ArrayList<>();
        ArrayList<String> idArray = new ArrayList<>(3);
        for (User user: users)
        {
            if (user.isVip())
            {
                tempArray.add(user);
            }
        }
        tempArray.sort(new Comparator<User>(){
            public int compare(User o1, User o2) {
                return o2.getBalance() - o1.getBalance();
            }
        });
        for (int i = 0; i < 3; i++)
        {
            idArray.add(tempArray.get(i).getUserID());
        }
        for (int i = 0; i < idArray.size(); i++)
        {
            System.out.println(idArray.get(i));
        }

        //Stream API实现方式
        //也可以使用parallelStream方法获取一个并发的stream，提高计算效率
        Stream<User> stream = users.stream();
        List<String> array = stream.filter(User::isVip).sorted((t1, t2) -> t2.getBalance() - t1.getBalance()).limit(3).map(User::getUserID).collect(Collectors.toList());
        array.forEach(System.out::println);
    }
}
```