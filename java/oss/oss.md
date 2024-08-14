下载文件
```java
@Override

public String getDownLoadUrl(String objectName, String ossBucket) {

  Date expiration = new Date(System.currentTimeMillis() + Constant.EXPIRE_TIME);

  URL url = ossClient.generatePresignedUrl(ossBucket, objectName, expiration);

  return url.toString();

}
```
这个方法生成的视频文件链接只能预览


```java
@Override

public String getRealDownLoadUrl(String objectName, String ossBucket){

  GeneratePresignedUrlRequest generatePresignedUrlRequest = new GeneratePresignedUrlRequest(ossBucket, objectName);

  generatePresignedUrlRequest.setMethod(HttpMethod.GET);

  //设置响应头强制下载

  ResponseHeaderOverrides responseHeaders = new ResponseHeaderOverrides();

  responseHeaders.setContentDisposition("attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));

  generatePresignedUrlRequest.setResponseHeaders(responseHeaders);

  // 设置URL过期时间为1小时。

  Date expiration = new Date(System.currentTimeMillis() + Constant.EXPIRE_TIME);

  generatePresignedUrlRequest.setExpiration(expiration);

  // 生成签名URL。

  URL url = ossClient.generatePresignedUrl(generatePresignedUrlRequest);

  return url.toString();

}
```


这个方法生成的视频文件链接可以下载


```java
@RequestMapping(value = "/downloadVideo", method = {RequestMethod.GET})

@ResponseBody

public void downloadVideo(String fileSavePath){

  try (OutputStream os = response.getOutputStream();

     InputStream is = ossManager.read2InputStream(fileSavePath,Constant.SEAKING_VIDEO_BUCKET)){

    if(StringUtils.isNotBlank(fileSavePath)){

      response.setHeader("Content-Disposition",

          "attachment;filename=" + URLEncoder.encode(fileSavePath, "UTF-8"));

    }

    response.setContentType("application/x-download");

    response.setHeader("Cache-Control", "no-cache");

    IOUtils.copy(is, os);

    os.flush();

    response.flushBuffer();

  } catch (Exception e) {

    logger.error("error, fileName = {}", fileSavePath, e);

    response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());

  }

```
