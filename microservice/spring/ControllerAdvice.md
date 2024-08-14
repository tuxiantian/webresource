```java
@ControllerAdvice
public class ExceptionInterceptor {
  private static final Logger logger = LoggerFactory.getLogger(ExceptionInterceptor.class);
  @ResponseBody
  @ExceptionHandler(RuntimeException.class)
  public String exceptionHandler(HttpServletRequest req, Exception e) {
    logger.error("Exception occurs, Url: " + req.getRequestURL(), e);
    Integer code = ResponseCodeEnum.internalServerError.getStatusCode();
    if (e instanceof IllegalArgumentException) {
      code = ResponseCodeEnum.paramCheckError.getStatusCode();
    }
    return JSON.toJSONString(ResponsePackUtil.packErrorEntity(e.getMessage(), code));
  }
}
@RequestMapping(value = "/supplier/ssu", method = {RequestMethod.GET})
@ResponseBody
public String getSSu(Long id,Long ssuId) {
  Assert.isTrue(id!=null,"参数id不能为空");
  Assert.isTrue(ssuId!=null,"参数ssuId不能为空");
}
```
```
{"code":501,"errorMsg":"参数id不能为空"`
```