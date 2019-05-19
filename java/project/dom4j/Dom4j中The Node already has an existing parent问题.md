# Dom4j中"The Node already has an existing parent"问题

常常需要在两个Document中互相复制Element，可是Dom4j中使用Element.add(Elemnet)方法就会出现出题的错误：

而应用AppendContext()方法，只能将目标元素的内容复制过来，不能将整个元素复制

通过看AbstractElement.java的源码得到解决办法是：调用Element的clone()方法。

root.add((Element) company.clone());



```
public Document createXMLDocument(){
    Document doc = null;
    doc = DocumentHelper.createDocument();
    Element root = doc.addElement("class");
    Element company = root.addElement("company");
    Element person = company.addElement("person");
    person.addAttribute("id","11");
    person.addElement("name").setText("Jack Chen");
    person.addElement("sex").setText("男");
    person.addElement("date").setText("2001-04-01");
    person.addElement("email").setText("[chen@163.com](mailto:chen@163.com)");
    person.addElement("QQ").setText("2366001");
    root.add((Element) company.clone());
    return doc;
}
```

