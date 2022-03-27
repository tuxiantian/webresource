```java
public class SupplierVO {
  private Long ssuId;
  private String name;
  private String description;
  private String image;
  private Long serviceProviderId;
  private String serviceProviderName;
  private Long templateId;
  private String self;
  private List<CapacityDTO> capacityDTOList;
  public Long getSsuId() {
    return ssuId;
  }
  public void setSsuId(Long ssuId) {
    this.ssuId = ssuId;
  }
  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }
  public String getDescription() {
    return description;
  }
  public void setDescription(String description) {
    this.description = description;
  }
  public String getImage() {
    return image;
  }
  public void setImage(String image) {
    this.image = image;
  }
  public Long getServiceProviderId() {
    return serviceProviderId;
  }
  public void setServiceProviderId(Long serviceProviderId) {
    this.serviceProviderId = serviceProviderId;
  }
  public String getServiceProviderName() {
    return serviceProviderName;
  }
  public void setServiceProviderName(String serviceProviderName) {
    this.serviceProviderName = serviceProviderName;
  }
  public Long getTemplateId() {
    return templateId;
  }
  public void setTemplateId(Long templateId) {
    this.templateId = templateId;
  }
  public String getSelf() {
    return self;
  }
  public void setSelf(String self) {
    this.self = self;
  }
  public List<CapacityDTO> getCapacityDTOList() {
    return capacityDTOList;
  }
  public void setCapacityDTOList(List<CapacityDTO> capacityDTOList) {
    this.capacityDTOList = capacityDTOList;
  }
  @Override
  public boolean equals(Object o) {
    if (this == o) { return true; }
    if (o == null || getClass() != o.getClass()) { return false; }
    SupplierVO supplierVO = (SupplierVO) o;
    return Objects.equals(templateId, supplierVO.templateId) && Objects.equals(serviceProviderId,supplierVO.serviceProviderId);
  }
  @Override
  public int hashCode() {
    return (templateId==null ? 0 : Objects.hash(templateId)) ^ (serviceProviderId==null ? 0 : Objects.hash(serviceProviderId));
  }
}
```
```java
@Override
public boolean equals(Object o) {
    if (this == o) {
        return true;
    }
    if (!(o instanceof LangVO)) {
        return false;
    }
    LangVO langVO = (LangVO) o;
    return Objects.equals(getLabel(), langVO.getLabel()) &&
            Objects.equals(getValue(), langVO.getValue()) &&
            Objects.equals(getResourceCount(), langVO.getResourceCount());
}
@Override
public int hashCode() {
    return Objects.hash(getLabel(), getValue(), getResourceCount());
}
```