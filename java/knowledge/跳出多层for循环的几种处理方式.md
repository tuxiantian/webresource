### 跳出多层for循环的几种处理方式
```java
@Test
public void test18(){
    boolean flag=false;
    for (int i=0 ;i<10;i++){
        flag=true;
        for (int j=1;flag&&j<10;j++){
            for (int k=1;flag&&k<10;k++){
                if (k==i+j){
                    flag=false;
                    System.out.println(String.format("i:%s,j:%s,k:%s",i,j,k));
                    continue;
                }
            }
        }
    }
}
```

```java
@Test
public void test19(){
    lable1:for (int i=0 ;i<10;i++){
        for (int j=1;j<10;j++){
            for (int k=1;k<10;k++){
                if (k==i+j){
                    System.out.println(String.format("i:%s,j:%s,k:%s",i,j,k));
                    continue lable1;
                }
            }
        }
    }
}
```

```java
@Test
public void test20(){
    for (int i=0 ;i<10;i++){
        process(i);
    }
}

private void process(int i) {
    for (int j=1;j<10;j++){
        for (int k=1;k<10;k++){
            if (k==i+j){
                System.out.println(String.format("i:%s,j:%s,k:%s",i,j,k));
                return;
            }
        }
    }
}
```
个人认为最后一种方法最好，通过抽取方法让方法变小，程序的可读性更高了。由此可以得出更一般的结论：方法中不允许有3层及以上的for循环。