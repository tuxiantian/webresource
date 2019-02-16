---
typora-root-url: ..\..
---

![2019-02-14_173450](/images/java/2019-02-14_173450.png)

要生成像上面那样的PDF文件，代码该怎么写呢？

引入itextpdf

```
<!-- https://mvnrepository.com/artifact/com.itextpdf/itextpdf -->
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>itextpdf</artifactId>
    <version>5.5.13</version>
</dependency>

<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>itext-asian</artifactId>
    <version>5.2.0</version>
</dependency>
```

```
public void export(Integer enterprise_id, String nf, HttpServletResponse response) {
        response.setContentType("application/pdf;charset=UTF-8");
        String fileName = null;
        try {
            fileName = java.net.URLEncoder.encode("科创板上市后备申报信息.pdf", "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
//        response.setHeader("content-disposition", "attachment;filename=" + fileName);
        MapBean ret = reportKcbssByEnterpriseId(enterprise_id, nf);
        if (ret.getInt("oerror") == 0) {
            List<MapBean> list = ret.get("result");
            if (list != null && list.size() > 0) {
                MapBean first = list.get(0);
                try {
                    Document document = new Document();
                    ServletOutputStream out = response.getOutputStream();
                    ByteArrayOutputStream stream = new ByteArrayOutputStream();
                    PdfWriter writer = PdfWriter.getInstance(document, stream);
                    document.open();
                    PdfPTable table=new PdfPTable(6);

                    table.addCell(getTitleCellNoBorder("郑州市2019年度科创板上市后备申报",6));

                    table.addCell(getCellBackgroundColor("企业基本信息",6));

                    table.addCell(getCell("企业名称",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("enterprise_name"),"") ,3));
                    table.addCell(getCell("所属县(市)区",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("county"),""),1));

                    table.addCell(getCell("注册地址",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("reg_address"),""),3));
                    table.addCell(getCell("所属行业",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("industry"),""),1));

                    table.addCell(getCell("行业排名",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("industry_ranking"),""),3));
                    table.addCell(getCell("是否科技型企业",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("technological_enterprise"),""),1));

                    table.addCell(getCell("公司性质",1));
                    String company_nature = StringUtils.defaultIfBlank(first.getString("company_nature"), "");
                    PdfPTable table1=new PdfPTable(3);
                    table1.addCell(getCellNoBorder(company_nature.equals("国有企业") ? "⊙国有企业":"○国有企业",1));
                    table1.addCell(getCellNoBorder(company_nature.equals("地方国有企业") ? "⊙地方国有企业":"○地方国有企业",1));
                    table1.addCell(getCellNoBorder(company_nature.equals("民营企业") ? "⊙民营企业":"○民营企业",1));
                    table1.addCell(getCellNoBorder(company_nature.equals("集体企业") ? "⊙集体企业":"○集体企业",1));
                    table1.addCell(getCellNoBorder(company_nature.equals("外商投资企业") ? "⊙外商投资企业":"○外商投资企业",1));
                    if (!company_nature.contains("其他-")){
                        table1.addCell(getOtherCellNoBorder("    ",1,false));
                    }else {
                        table1.addCell(getOtherCellNoBorder(company_nature.substring("其他-".length()),1,true));
                    }

                    PdfPCell  cell1=new PdfPCell(table1);
                    cell1.setColspan(5);
                    table.addCell(cell1);

                    table.addCell(getCell("注册资本",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("registered_capital"),""),1));
                    table.addCell(getCell("成立时间",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("founding_time"),""),1));
                    table.addCell(getCell("股改时间",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("reform_time"),""),1));

                    table.addCell(getCell("法定代表人",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("legal"),""),1));
                    table.addCell(getCell("办公电话",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("legal_office_phone"),""),1));
                    table.addCell(getCell("手机",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("legal_phone"),""),1));

                    table.addCell(getCell("总经理",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("general_manager"),""),1));
                    table.addCell(getCell("办公电话",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("general_manager_office_phone"),""),1));
                    table.addCell(getCell("手机",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("general_manager_phone"),""),1));

                    table.addCell(getCell("董秘",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("secretary"),""),1));
                    table.addCell(getCell("办公电话",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("secretary_office_phone"),""),1));
                    table.addCell(getCell("手机",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("secretary_phone"),""),1));

                    table.addCell(getCell("主营业务",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("legal"),""),5,40));
                    table.addCell(getCell("基本情况(商业盈利模式及竞争力分析)",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("basic_situation"),""),5,40));

                    table.addCell(getCellBackgroundColor("上市基本情况",6));

                    table.addCell(getCell("发行前股本（亿股）",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("pre_issue_equity"),""),1));
                    table.addCell(getCell("拟发股份（亿股）",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("ready_stock"),""),1));
                    table.addCell(getCell("拟筹资额（亿元）",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("ready_premium"),""),1));

                    List<MapBean> gbjgsList=first.get("gbjgs");
                    if (gbjgsList!=null&&!gbjgsList.isEmpty()){
                        PdfPCell cell2=getCell("目前股本结构",0);
                        cell2.setRowspan(gbjgsList.size()+1);
                        table.addCell(cell2);
                        table.addCell(getCell("股东名称",3));
                        table.addCell(getCell("持股比例",1));
                        table.addCell(getCell("所有制性质",1));
                        for (MapBean bean : gbjgsList) {
                            table.addCell(getCell(StringUtils.defaultIfBlank(bean.getString("shareholder_name"),""),3));
                            table.addCell(getCell(StringUtils.defaultIfBlank(bean.getString("ratio"),""),1));
                            table.addCell(getCell(StringUtils.defaultIfBlank(bean.getString("ownership_nature"),""),1));
                        }
                    }else {
                        PdfPCell cell2=getCell("目前股本结构",0);
                        cell2.setRowspan(4);
                        table.addCell(cell2);
                        table.addCell(getCell("股东名称",3));
                        table.addCell(getCell("持股比例",1));
                        table.addCell(getCell("所有制性质",1));
                        for (int i = 0; i < 3; i++) {
                            table.addCell(getCell("",3));
                            table.addCell(getCell("",1));
                            table.addCell(getCell("",1));
                        }
                    }


                    table.addCell(getCell("融资意向",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("financing_intention"),""),5,20));

                    table.addCell(getCell("上市意向",1));
                    PdfPTable table2=new PdfPTable(4);
                    String listing_intention=StringUtils.defaultIfBlank(first.getString("listing_intention"),"");
                    table2.addCell(getCellNoBorder(listing_intention.equals("上海主板") ? "⊙上海主板":"○上海主板",1));
                    table2.addCell(getCellNoBorder(listing_intention.equals("科创板") ? "⊙科创板":"○科创板",1));
                    table2.addCell(getCellNoBorder(listing_intention.equals("深圳中小板") ? "⊙深圳中小板":"○深圳中小板",1));
                    table2.addCell(getCellNoBorder(listing_intention.equals("创业板") ? "⊙创业板":"○创业板",1));
                    table2.addCell(getCellNoBorder(listing_intention.equals("新三板") ? "⊙新三板":"○新三板",1));
                    table2.addCell(getCellNoBorder(listing_intention.equals("境外") ? "⊙境外":"○境外",1));
                    if (!listing_intention.contains("其他-")){
                        table2.addCell(getOtherCellNoBorder("    ",1,false));
                    }else {
                        table2.addCell(getOtherCellNoBorder(listing_intention.substring("其他-".length()),1,true));
                    }

                    table2.addCell(getCellNoBorder("",1));
                    PdfPCell  cell3=new PdfPCell(table2);
                    cell3.setColspan(5);
                    table.addCell(cell3);


                    table.addCell(getCell("符合科创版标准(必填项)",1));
                    PdfPTable table3=new PdfPTable(5);
                    String kcb_standard=StringUtils.defaultIfBlank(first.getString("kcb_standard"),"");
                    table3.addCell(getCellNoBorder(kcb_standard.equals("标准一") ? "⊙标准一":"○标准一",1));
                    table3.addCell(getCellNoBorder(kcb_standard.equals("标准二") ? "⊙标准二":"○标准二",1));
                    table3.addCell(getCellNoBorder(kcb_standard.equals("标准三") ? "⊙标准三":"○标准三",1));
                    table3.addCell(getCellNoBorder(kcb_standard.equals("标准四") ? "⊙标准四":"○标准四",1));
                    table3.addCell(getCellNoBorder(kcb_standard.equals("标准五") ? "⊙标准五":"○标准五",1));
                    PdfPCell cell4=new PdfPCell(table3);
                    cell4.setColspan(5);
                    table.addCell(cell4);

                    table.addCell(getCell("上市进程",1));
                    PdfPTable table4=new PdfPTable(3);
                    String listing_process=StringUtils.defaultIfBlank(first.getString("listing_process"),"");
                    table4.addCell(getCellNoBorder(listing_process.equals("尚无上市意愿（后备）") ? "⊙尚无上市意愿（后备）":"○尚无上市意愿（后备）",1));
                    table4.addCell(getCellNoBorder(listing_process.equals("启动上市资源") ? "⊙启动上市资源":"○启动上市资源",1));
                    table4.addCell(getCellNoBorder(listing_process.equals("改制设立股份公司") ? "⊙改制设立股份公司":"○改制设立股份公司",1));
                    table4.addCell(getCellNoBorder(listing_process.equals("证监局备案") ? "⊙证监局备案":"○证监局备案",1));
                    table4.addCell(getCellNoBorder(listing_process.equals("证监局审核") ? "⊙证监局审核":"○证监局审核",1));
                    table4.addCell(getCellNoBorder(listing_process.equals("终止审查") ? "⊙终止审查":"○终止审查",1));
                    table4.addCell(getCellNoBorder(listing_process.equals("审核被否") ? "⊙审核被否":"○审核被否",1));
                    if (!listing_process.contains("其他-")){
                        table4.addCell(getOtherCellNoBorder("    ",1,false));
                    }else {
                        table4.addCell(getOtherCellNoBorder(listing_process.substring("其他-".length()),1,true));
                    }

                    table4.addCell(getCellNoBorder("",1));
                    PdfPCell cell5=new PdfPCell(table4);
                    cell5.setColspan(5);
                    table.addCell(cell5);

                    table.addCell(getCell("拟报会时间",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("nbh_time"),""),2));
                    table.addCell(getCell("正式报会时间",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("zsbh_time"),""),2));

                    table.addCell(getCell("终止审查时间",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("zzsc_time"),""),2));
                    table.addCell(getCell("过会时间",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("gh_time"),""),2));

                    table.addCell(getCell("是否挂新三板", 1));
                    PdfPTable table5=new PdfPTable(2);
                    String sfgxsb=StringUtils.defaultIfBlank(first.getString("sfgxsb"),"");
                    table5.addCell(getCellNoBorder(sfgxsb.equals("是")?"⊙是":"○是",1));
                    table5.addCell(getCellNoBorder(sfgxsb.equals("否")?"⊙否":"○否",1));
                    PdfPCell cell6 = new PdfPCell(table5);
                    cell6.setColspan(2);
                    table.addCell(cell6);
                    table.addCell(getCell("重点关注企业",1));
                    PdfPTable table6=new PdfPTable(2);
                    String key_enterprise=StringUtils.defaultIfBlank(first.getString("key_enterprise"),"");
                    table6.addCell(getCellNoBorder(key_enterprise.equals("是") ? "⊙是":"○是",1));
                    table6.addCell(getCellNoBorder(key_enterprise.equals("否") ? "⊙否":"○否",1));
                    PdfPCell cell7 = new PdfPCell(table6);
                    cell7.setColspan(2);
                    table.addCell(cell7);

                    table.addCell(getCellBackgroundColor("近三年财务状况（单位：亿元）",6));

                    table.addCell(getCell("财务数据期（年/月/日）",1));
                    table.addCell(getCell("总资产",1));
                    table.addCell(getCell("净资产",1));
                    table.addCell(getCell("营业收入",1));
                    table.addCell(getCell("扣非净利润",1));
                    table.addCell(getCell("预计市值",1));
                    List<MapBean> financialsList=first.get("financials");
                    if (financialsList!=null&&!financialsList.isEmpty()){
                        for (MapBean bean : financialsList) {
                            table.addCell(getCell(StringUtils.defaultIfBlank(bean.getString("financial_period"),""),1));
                            table.addCell(getCell(StringUtils.defaultIfBlank(bean.getString("total_assets"),""),1));
                            table.addCell(getCell(StringUtils.defaultIfBlank(bean.getString("net_assets"),""),1));
                            table.addCell(getCell(StringUtils.defaultIfBlank(bean.getString("business_income"),""),1));
                            table.addCell(getCell(StringUtils.defaultIfBlank(bean.getString("kfjlr"),""),1));
                            table.addCell(getCell(StringUtils.defaultIfBlank(bean.getString("estimated_market_value"),""),1));
                        }
                    }else {
                        for (int i = 0; i < 3; i++) {
                            table.addCell(getCell(" ",1));
                            table.addCell(getCell(" ",1));
                            table.addCell(getCell(" ",1));
                            table.addCell(getCell(" ",1));
                            table.addCell(getCell(" ",1));
                            table.addCell(getCell(" ",1));
                        }
                    }


                    PdfPCell cell8=getCell("成长指标",1);
                    cell8.setRowspan(2);
                    table.addCell(cell8);
                    table.addCell(getCell("最近两年营业收入增长率",2));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("czzb_zjlnyysrzzl"),""),3));
                    table.addCell(getCell("主要产品市场占有率排名",2));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("czzb_zycpsczylpm"),""),3));

                    PdfPCell cell9=getCell("研发指标",1);
                    cell9.setRowspan(3);
                    table.addCell(cell9);
                    table.addCell(getCell("近两年研发投入总和占营业收入总和比例",3));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("yfzb_jlnyftrzhzy"),""), 2));

                    table.addCell(getCell("无形占净资产比例",2));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("yfzb_wxzjzcbl"),""),1));
                    table.addCell(getCell("发明专利数",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("yfzb_fmzls"),""),1));

                    table.addCell(getCell("研发人员占比",2));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("yfzb_yfryzb"),""),3));

                    table.addCell(getCell("目前存在问题",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("current_problems"),""),5,40));

                    table.addCell(getCell("保荐情况",1));
                    PdfPTable table7=new PdfPTable(2);
                    table7.addCell(getCellNoBorder("○是（请填写下表）",1));
                    table7.addCell(getCellNoBorder("○否（不用填写下表）",1));
                    PdfPCell cell10=new PdfPCell(table7);
                    cell10.setColspan(5);
                    table.addCell(cell10);

                    PdfPCell cell11=getCell("保荐机构",1);
                    cell11.setRowspan(2);
                    table.addCell(cell11);
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("bjjg_name"),""),2));
                    table.addCell(getCell("联系人",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("bjjg_linkman"),""),2));
                    table.addCell(getCell("职务",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("bjjg_post"),""),1));
                    table.addCell(getCell("联系方式",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("bjjg_phone"),""),2));

                    PdfPCell cell12=getCell("会计师事务所",1);
                    cell12.setRowspan(2);
                    table.addCell(cell12);
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("kjsws_name"),""),2));
                    table.addCell(getCell("联系人",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("kjsws_linkman"),""),2));
                    table.addCell(getCell("职务",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("kjsws_post"),""),1));
                    table.addCell(getCell("联系方式",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("kjsws_phone"),""),2));

                    PdfPCell cell13=getCell("律师事务所",1);
                    cell13.setRowspan(2);
                    table.addCell(cell13);
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("lssws_name"),""),2));
                    table.addCell(getCell("联系人",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("lssws_linkman"),""),2));
                    table.addCell(getCell("职务",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("lssws_post"),""),1));
                    table.addCell(getCell("联系方式",1));
                    table.addCell(getCell(StringUtils.defaultIfBlank(first.getString("lssws_phone"),""),2));

                    document.add(table);

                    PdfPTable bottomTable=new PdfPTable(6);
                    bottomTable.addCell(getCellNoBorder("填表人：",1));
                    bottomTable.addCell(getCellNoBorder(StringUtils.defaultIfBlank(first.getString("filling_person"),""),1));
                    bottomTable.addCell(getCellNoBorder("填表人联系电话：",2));
                    bottomTable.addCell(getCellNoBorder(StringUtils.defaultIfBlank(first.getString("filling_person_phone"),""),2));
                    document.add(bottomTable);

                    document.close();
                    writer.close();
                    stream.writeTo(out);
                    out.flush();
                } catch (DocumentException e) {
                    logger.error("", e);
                } catch (IOException e) {
                    logger.error("", e);
                }
            }
        }

    }

    private PdfPCell getCellBackgroundColor(String c, int colspan) throws IOException, DocumentException {
        //中文字体
        BaseFont bfChinese = BaseFont.createFont("STSongStd-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        Font font = new Font(bfChinese, 8, Font.NORMAL);
        PdfPCell cell = new PdfPCell(new Phrase(c, font));
        cell.setUseAscender(true); // 设置可以居中
        cell.setHorizontalAlignment(Element.ALIGN_CENTER); // 设置水平居中
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
        cell.setColspan(colspan);
        cell.setMinimumHeight(20);
        cell.setBackgroundColor(new BaseColor(221,217,195));
        return cell;
    }

    private PdfPCell getCell(String c, int colspan) throws IOException, DocumentException {
        //中文字体
        BaseFont bfChinese = BaseFont.createFont("STSongStd-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        Font font = new Font(bfChinese, 8, Font.NORMAL);
        PdfPCell cell = new PdfPCell(new Phrase(c, font));
        cell.setUseAscender(true); // 设置可以居中
        cell.setHorizontalAlignment(Element.ALIGN_CENTER); // 设置水平居中
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
        cell.setColspan(colspan);
        cell.setMinimumHeight(20);
        return cell;
    }

    private PdfPCell getCell(String c,int colspan,float fixedHeight) throws IOException, DocumentException {
        PdfPCell cell=getCell(c,colspan);
        cell.setFixedHeight(fixedHeight);
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        return cell;
    }

    private PdfPCell getCellNoBorder(String c,int colspan) throws IOException, DocumentException {
        //中文字体
        BaseFont bfChinese = BaseFont.createFont("STSongStd-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        Font font = new Font(bfChinese, 8, Font.NORMAL);
        PdfPCell cell = new PdfPCell(new Phrase(c, font));
        cell.setUseAscender(true); // 设置可以居中
        cell.setHorizontalAlignment(Element.ALIGN_LEFT); // 设置水平居中
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setColspan(colspan);
        cell.setMinimumHeight(20);
        return cell;
    }

    private PdfPCell getTitleCellNoBorder(String c,int colspan) throws IOException, DocumentException {
        //中文字体
        BaseFont bfChinese = BaseFont.createFont("STSongStd-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        Font font = new Font(bfChinese, 16, Font.NORMAL);
        PdfPCell cell = new PdfPCell(new Phrase(c, font));
        cell.setUseAscender(true); // 设置可以居中
        cell.setHorizontalAlignment(Element.ALIGN_CENTER); // 设置水平居中
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setColspan(colspan);
        cell.setMinimumHeight(30);
        return cell;
    }

    private PdfPCell getOtherCellNoBorder(String c,int colspan,boolean check) throws IOException, DocumentException {
        //中文字体
        BaseFont bfChinese = BaseFont.createFont("STSongStd-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        Font font = new Font(bfChinese, 8, Font.NORMAL);

        Chunk chunk1=new Chunk(check ? "⊙其他" : "○其他", font);

        Chunk chunk2=new Chunk(c,font);
        chunk2.setUnderline(0.1f, -1f);
        Phrase phrase = new Phrase(chunk1);
        phrase.add(chunk2);
        PdfPCell cell = new PdfPCell();
        cell.setPhrase(phrase);
        cell.setNoWrap(true);
        cell.setUseAscender(true); // 设置可以居中
        cell.setHorizontalAlignment(Element.ALIGN_LEFT); // 设置水平居中
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE); // 设置垂直居中
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setColspan(colspan);
        cell.setMinimumHeight(20);
        return cell;
    }
```

前端下载导出PDF文件代码

```
$("#daochu").click(function () {
    var objectUrl = 'http://y.ilaijia.com/mcp/statement/detail/export?statementId=' + data.statementId;
    var a = document.createElement('a');
    document.body.appendChild(a);
    a.setAttribute('style', 'display:none');
    a.setAttribute('href', objectUrl);
    a.setAttribute('download', '维修结算单.pdf');
    a.click();
    URL.revokeObjectURL(objectUrl);
})
```

前端预览PDF文件代码
```
<a class="btn btn-blue btn-xs" target="_blank" href="http://192.168.0.200:8081/sys/front/common/detail/export?nf=2019&enterprise_id=' + id+'">详情</a>
```

参考资料

http://www.anyrt.com/blog/list/itextpdf.html#2