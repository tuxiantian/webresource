```java
package cn.itcast.xml;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

/**
 * xml工具类
 * @author asus
 *
 */
public class XmlHelper {
	//xml文件路径
	private	String filePath;
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String fileName) {
		this.filePath = fileName;
	}

	private	Document doc;

	private Document getDoc() {
		return doc;
	}
	public XmlHelper() {
		super();
	}
	public XmlHelper(String fileName) {
		super();
		try {
			this.doc=read(fileName);
		} catch (DocumentException e) {			
			e.printStackTrace();
		} catch (IOException e) {			
			e.printStackTrace();
		}
	}
	/**
	 * 读取xml文件返回Document对象
	 * @param fileName
	 * @return Document
	 * @throws DocumentException
	 * @throws IOException 
	 */
	private Document read(String fileName) throws DocumentException, IOException {
		SAXReader reader = new SAXReader();
		filePath=new File(this.getClass().getResource("/").getPath()).getParentFile().getAbsolutePath()+"\\"+fileName;		
		filePath=URLDecoder.decode(filePath,"UTF-8");			
		System.out.println(filePath);		
		URL xmlpath = this.getClass().getClassLoader().getResource(fileName);
		Document document = reader.read(xmlpath);
		return document;
	}
	public Element getRootElement(Document doc){
		return doc.getRootElement();
	}
	public Map<String, Object> Bean2Map(Integer id,String beanName){
		Map<String, Object> map=new HashMap<String, Object>();
		String xpathExpression="//"+beanName+"[@id='"+id+"']";
		Node node=doc.selectSingleNode(xpathExpression);
		List<Node> list=node.selectNodes(xpathExpression+"/*");

		for (Node node2 : list) {
			map.put(node2.getName(), node2.getText());				
		}		
		return map;
	}
	public List<Map<String, Object>> Bean2List(String beanName) throws DocumentException, IOException{
		List<Map<String, Object>> data=new ArrayList<Map<String,Object>>();

		Element root=getRootElement(doc);
		List<Node> list= doc.selectNodes("//"+beanName);

		for (Node node : list) {
			Map<String, Object> map=new HashMap<String, Object>();
			List<Node> list2=node.selectNodes(node.getPath()+"[@id='"+node.valueOf("@id")+"']/*");

			for (Node node2 : list2) {
				map.put(node2.getName(), node2.getText());
			}
			data.add(map);		
		}
		return data;
	}
	public Integer getMaxId(String beanName) {
		List list = doc.selectNodes("//"+beanName+"/@id"); 
		Iterator iter = list.iterator();
		Integer maxId = 0;
		while(iter.hasNext()){
			Attribute attribute = (Attribute)iter.next();
			if(Integer.parseInt(attribute.getValue())>maxId){
				maxId=Integer.parseInt(attribute.getValue());
			}   
		}
		return maxId;
	}
	public void AddBean(String beanName,Map<String, Object> map) {
		Element root=getRootElement(doc);
		Element Info=root.addElement(beanName);

		String id=new Integer(getMaxId(beanName).intValue()+1).toString();
		Info.addAttribute("id", id);
		for (Iterator<Entry<String, Object>> iterator = map.entrySet().iterator(); iterator.hasNext();) {
			Entry<String, Object> e  = iterator.next();
			Element element=Info.addElement(e.getKey());
			element.setText(e.getValue().toString());
		}

		write();
	}
	public void RemoveBean(int id,String beanName) throws DocumentException{		
		String xpathExpression="//"+beanName+"[@id='"+id+"']";
		Node node=doc.selectSingleNode(xpathExpression);
		getRootElement(doc).remove(node);

		write();
	}
	public void RepairBean(int id,Map<String, Object> map,String beanName) throws DocumentException, IOException{		
		String xpathExpression="//"+beanName+"[@id='"+id+"']";
		Node node=doc.selectSingleNode(xpathExpression);
		List<Node> list=node.selectNodes(xpathExpression+"/*");

		for (Iterator<Entry<String, Object>> iterator = map.entrySet().iterator(); iterator.hasNext();) {
			Entry<String, Object> e  = iterator.next();
			for (Node node2 : list) {
				if (node2.getName().equals(e.getKey())) {
					node2.setText((String) e.getValue());
					System.out.println(node2.getText());
					break;
				}
			}
		}
		write();
	}
	public void write() {
		XMLWriter writer =null;	      	      
		// 美化格式
		OutputFormat format = OutputFormat.createPrettyPrint();
		File file=new File(filePath);//"ContactXMLFile.xml"
		
		FileOutputStream outputStream = null;
		try {
			outputStream = new FileOutputStream(file);
		} catch (FileNotFoundException e1) {		
			e1.printStackTrace();
		}
		try {
			writer = new XMLWriter(outputStream, format );
		} catch (UnsupportedEncodingException e) {			
			e.printStackTrace();
		}
		try {
			writer.write(doc);
			writer.close();			
		} catch (IOException e) {			
			e.printStackTrace();
		}
	}
}
```

```
支持的Bean格式如下，Bean必须有一个id属性。这里的Bean是元素Info.
<ContactInfo> 
  <Info id="1"> 
    <cid>1</cid>  
    <Address id="1">河南省北京市郑东新区商务外环路13号绿地 峰会天下28楼</Address>  
    <PhoneNumber>（0371）69190125 69190121</PhoneNumber>  
    <FaxNumber>（0371）69190150</FaxNumber>  
    <Email>222</Email> 
  </Info>  
</ContactInfo>
```

