```java
import org.apache.poi.hssf.usermodel.HSSFWorkbookimport org.apache.poi.hssf.usermodel.HSSFWorkbook`;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
/**
 \* excel读写工具类
 \* @author sun.kai
 \* 2016年8月21日
 */
public class POIUtil {
  private static final Logger logger = LoggerFactory.getLogger(POIUtil.class);
  private final static String xls = "xls";
  private final static String xlsx = "xlsx";
  public static void main(String[] args) {
    File file = POIUtil.writeWord("hello 你好 大家好");
    System.out.println(file.getName());
  }
  public static File writeWord(String content) {
    File file = null;
    try {
      //Blank Document
      XWPFDocument document = new XWPFDocument();
      //Write the Document in file system
      CommonUtils.buildDir(Constant.DIR);
      String localPathFile = Constant.DIR + System.currentTimeMillis() + ".docx";
      file = new File(localPathFile);
      FileOutputStream out = new FileOutputStream(new File(localPathFile));
      XWPFParagraph firstParagraph = document.createParagraph();
      XWPFRun run = firstParagraph.createRun();
      run.setText(content);
      run.setFontSize(16);
      document.write(out);
      out.flush();
      out.close();
    } catch (Exception e) {
      logger.error(e.getMessage(), e);
    }
    return file;
  }
  public static File createExcel(List<Map<String, Object>> list, String fileName) {
    CommonUtils.buildDir(Constant.DIR);
    String localPathFile = Constant.DIR + fileName;
    //读取oss 文件 转存到本地文件
    File localFile = new File(localPathFile);
    try {
      //定义一个Excel表格,创建工作薄
      XSSFWorkbook wb = new XSSFWorkbook();
      //创建工作表
      XSSFSheet sheet = wb.createSheet("sheet1");
      for (int i = 0; i < list.size(); i++) {
        XSSFRow row = sheet.createRow(i);
        Map<String, Object> cellData = list.get(i);
        int j = 0;
        for (String key : list.get(i).keySet()) {
          Cell cell = row.createCell(j, CellType.STRING);
          cell.setCellValue(String.valueOf(cellData.get(key)));
          j++;
        }
      }
      //输出流,下载时候的位置
      FileOutputStream outputStream = new FileOutputStream(localFile);
      wb.write(outputStream);
      outputStream.flush();
      outputStream.close();
      logger.error("create excel success,fileName=" + fileName);
    } catch (Exception e) {
      logger.error("create excel fail", e);
      SystemLog.printSystemLogWarning("POIUtil.createExcel","", e.getMessage());
    }
    return localFile;
  }
  public static List<String[]> readExcel(InputStream inputStream,String fileName,Integer cellCount) throws IOException{
    //获得Workbook工作薄对象
    Workbook workbook = getWorkBook(inputStream, fileName);
    //创建返回对象，把每行中的值作为一个数组，所有行作为一个集合返回
    List<String[]> list = new ArrayList<String[]>();
    if(workbook != null){
      for(int sheetNum = 0;sheetNum < workbook.getNumberOfSheets();sheetNum++){
        //获得当前sheet工作表
        Sheet sheet = workbook.getSheetAt(sheetNum);
        if(sheet == null){
          continue;
        }
        //获得当前sheet的开始行
        int firstRowNum = sheet.getFirstRowNum();
        //获得当前sheet的结束行
        int lastRowNum = sheet.getLastRowNum();
        //循环除了第一行的所有行
        for(int rowNum = firstRowNum+1;rowNum <= lastRowNum;rowNum++){
          //获得当前行
          Row row = sheet.getRow(rowNum);
          if(row == null){
            continue;
          }
          //获得当前行的开始列
          int firstCellNum = 0;
          //获得当前行的列数
          int lastCellNum = cellCount;
          String[] cells = new String[cellCount];
          //循环当前行
          for(int cellNum = firstCellNum; cellNum < lastCellNum;cellNum++){
            Cell cell = row.getCell(cellNum);
            cells[cellNum] = getCellValue(cell);
          }
          list.add(cells);
        }
      }
      workbook.close();
    }
    return list;
  }
  public static List<String[]> readExcel(Workbook workbook,int sheetNum,Integer cellCount) throws IOException{
    //创建返回对象，把每行中的值作为一个数组，所有行作为一个集合返回
    List<String[]> list = new ArrayList<String[]>();
    if(workbook != null){
      //获得当前sheet工作表
      Sheet sheet = workbook.getSheetAt(sheetNum);
      if(sheet == null){
        return list;
      }
      //获得当前sheet的开始行
      int firstRowNum = sheet.getFirstRowNum();
      //获得当前sheet的结束行
      int lastRowNum = sheet.getLastRowNum();
      //循环除了第一行的所有行
      for(int rowNum = firstRowNum+1;rowNum <= lastRowNum;rowNum++){
        //获得当前行
        Row row = sheet.getRow(rowNum);
        if(row == null){
          continue;
        }
        //获得当前行的开始列
        int firstCellNum = 0;
        //获得当前行的列数
        int lastCellNum = cellCount;
        String[] cells = new String[cellCount];
        //循环当前行
        for(int cellNum = firstCellNum; cellNum < lastCellNum;cellNum++){
          Cell cell = row.getCell(cellNum);
          cells[cellNum] = getCellValue(cell);
        }
        list.add(cells);
      }
      workbook.close();
    }
    return list;
  }
  public static void checkFile(MultipartFile file) throws IOException{
    //判断文件是否存在
    if(null == file){
      logger.error("文件不存在！");
      throw new FileNotFoundException("文件不存在！");
    }
    //获得文件名
    String fileName = file.getOriginalFilename();
    //判断文件是否是excel文件
    if(!fileName.endsWith(xls) && !fileName.endsWith(xlsx)){
      logger.error(fileName + "不是excel文件");
      throw new IOException(fileName + "不是excel文件");
    }
  }
  public static Workbook getWorkBook(InputStream is,String fileName) {
    //创建Workbook工作薄对象，表示整个excel
    Workbook workbook = null;
    try {
      //根据文件后缀名不同(xls和xlsx)获得不同的Workbook实现类对象
      if(fileName.endsWith(xls)){
        //2003
        workbook = new HSSFWorkbook(is);
      }else if(fileName.endsWith(xlsx)){
        //2007
        workbook = new XSSFWorkbook(is);
      }
    } catch (IOException e) {
      logger.info(e.getMessage());
    }
    return workbook;
  }
  public static String getCellValue(Cell cell){
    String cellValue = "";
    if(cell == null){
      return cellValue;
    }
    //把数字当成String来读，避免出现1读成1.0的情况
    if(cell.getCellType() == CellType.NUMERIC){
      cell.setCellType(CellType.STRING);
    }
    if (cell.getCellType().equals(CellType.STRING)) {
      cellValue = String.valueOf(cell.getStringCellValue());
    } else if (cell.getCellType().equals(CellType.BOOLEAN)) {
      cellValue = String.valueOf(cell.getBooleanCellValue());
    } else if (cell.getCellType().equals(CellType.FORMULA)) {
      cellValue = String.valueOf(cell.getCellFormula());
    }
    return cellValue;
  }
}
public static void buildDir(String localFilePath) {
  File file = new File(localFilePath);
  if (!file.exists()) {
    file.mkdir();
  }
}
```
```xml
<!-- 文档解析 -->
<dependency>
  <groupId>org.apache.poi</groupId>
  <artifactId>poi</artifactId>
  <version>4.1.0</version>
</dependency>
<!-- https://mvnrepository.com/artifact/org.apache.poi/poi-ooxml -->
<dependency>
  <groupId>org.apache.poi</groupId>
  <artifactId>poi-ooxml</artifactId>
  <version>4.1.0</version>
</dependency>
```