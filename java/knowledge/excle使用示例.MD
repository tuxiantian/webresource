java读写excle需引入的jar如下
```xml
<!-- excle相关 -->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>3.9</version>
    <type>jar</type>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>3.9</version>
    <type>jar</type>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml-schemas</artifactId>
    <version>3.9</version>
    <type>jar</type>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-scratchpad</artifactId>
    <version>3.9</version>
    <type>jar</type>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-excelant</artifactId>
    <version>3.9</version>
    <type>jar</type>
</dependency>
```
写文件示例代码
```java
private String writeFile(List<MapBean> data) {
    XSSFWorkbook xwb=new XSSFWorkbook();
    XSSFSheet sheet = xwb.createSheet("车辆行驶里程");
    XSSFRow firstRow = sheet.createRow(0);
    String[] title={"sn","minMileage","maxMileage","mileage"};
    for (int i=0;i<4;i++){
        firstRow.createCell(i).setCellValue(title[i]);
    }
    if (data!=null) {
        for (int i=1;i<=data.size();i++){
            XSSFRow row = sheet.createRow(i);
            row.createCell(0).setCellValue(data.get(i-1).getString("sn"));
            row.createCell(1).setCellValue(data.get(i-1).getString("minMileage"));
            row.createCell(2).setCellValue(data.get(i-1).getString("maxMileage"));
            if (StringUtils.isNotBlank(data.get(i-1).getString("maxMileage")) && StringUtils.isNotBlank(data.get(i-1).getString("minMileage"))) {
                row.createCell(3).setCellValue(Integer.parseInt(data.get(i-1).getString("maxMileage"))-Integer.parseInt(data.get(i-1).getString("minMileage")));
            }else {
                row.createCell(3).setCellValue("");
            }
        }
    }
    String fileName= PropertiesUtil.getApplicationString("fileName").concat(DateUtil.date2String(new Date(),DateUtil.DATE_PATTERN.YYYYMMDDHHMMSS)).concat(".xlsx") ;
    try {
        xwb.write(new FileOutputStream(fileName));
    } catch (IOException e) {
        e.printStackTrace();
    }
    return fileName;
}
```
excle文件数据解析保存示例
```java
interface EMPLOYEE_TEMPLATE_TITLE {
    int employeeName=0;
    int mobile=1;
    int workCardNo=2;
    int upBusnumName=3;
    int downBusnumName=4;
}

public McpResult upload(Long enteId, MultipartFile employeeFile) {
    XSSFWorkbook xwb = null;
    try {
        xwb = new XSSFWorkbook(employeeFile.getInputStream());
    } catch (IOException e) {
        logger.error("",e);
        return McpResult.code(ERR_EMPLOYEE_TEMPLATE);
    }
    XSSFSheet xssfSheet = xwb.getSheetAt(0);
    List<EnterpriseEmployee> employeeList=new ArrayList<>(xssfSheet.getLastRowNum());
    for (int rowNum = 1; rowNum <= xssfSheet.getLastRowNum(); rowNum++) {
        XSSFRow xssfRow = xssfSheet.getRow(rowNum);
        if (xssfRow != null) {
            EnterpriseEmployee employee=new EnterpriseEmployee();
            employee.setEnteId(enteId);
            employee.setEmployeeName(getValue(xssfRow.getCell(EMPLOYEE_TEMPLATE_TITLE.employeeName)));
            employee.setMobile(getValue(xssfRow.getCell(EMPLOYEE_TEMPLATE_TITLE.mobile)));
            if (StringUtils.isBlank(employee.getEmployeeName())||StringUtils.isBlank(employee.getMobile())){
                return McpResult.code(ERR_EMPLOYEE_INFO_NOT_COMPLETE);
            }
            employee.setWorkCardNo(getValue(xssfRow.getCell(EMPLOYEE_TEMPLATE_TITLE.workCardNo)));
            Integer upBusId= null;
            String upBusnumName=getValue(xssfRow.getCell(EMPLOYEE_TEMPLATE_TITLE.upBusnumName));
            if (StringUtils.isNotBlank(upBusnumName)) {
                upBusId = regularBusEnterpriseService.getBusId(enteId,upBusnumName);
            }
            employee.setUpBusId(upBusId);
            Integer downBusId= null;
            String downBusnumName=getValue(xssfRow.getCell(EMPLOYEE_TEMPLATE_TITLE.downBusnumName));
            if (StringUtils.isNotBlank(downBusnumName)) {
                downBusId = regularBusEnterpriseService.getBusId(enteId,downBusnumName);
            }
            employee.setDownBusId(downBusId);
            employeeList.add(employee);
        }
    }
    employeeList.forEach(this::save);
    return McpResult.success("员工资料保存成功");
}

    private String getValue(XSSFCell xssfCell) {
        if (xssfCell!=null) {
            if (xssfCell.getCellType() == CellType.BOOLEAN) {
                return String.valueOf(xssfCell.getBooleanCellValue());
            } else if (xssfCell.getCellType() == CellType.NUMERIC) {
                return new BigDecimal(xssfCell.getNumericCellValue()).toPlainString();
            } else {
                return String.valueOf(xssfCell.getStringCellValue());
            }
        }else {
            return "";
        }
    }
```
日期被解析为数字，不能作为日期字符串解析
1. 选中-设置单元格格式-自定义（yyyy-mm-dd）
2. 选择-分列-直接下一步-注意最后异步选择**文本**

这样excle解析时，就能把日期列解析为日期字符串