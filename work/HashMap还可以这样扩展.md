```java
package com.laijia.core.entity;

import com.laijia.util.DataUtils;
import com.laijia.util.JsonUtil;
import org.apache.commons.lang3.StringUtils;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;


public class MapBean extends HashMap<String, Object> implements Entity {

    private static final long serialVersionUID = 5819387600888005124L;

    public MapBean() {
        super();
    }

    /**
     * 传入0到n对象，创建MapBean
     *
     * @param args
     */
    public MapBean(Object... args) {
        super();
        puts(args);
    }

    /**
     * 当你确切知道返回类型时，才能使用
     *
     * @param key 鍵值
     * @return
     */
    public <X> X get(String key) {
        try {
            X value = (X) super.get(key);
            return value;
        } catch (ClassCastException e) {
            throw new ClassCastException("MapBean中存放的类型，与返回类型不匹配.");
        }

    }

    /**
     * 获得Integer类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Integer getInt(Object key) {
        Object value = get(key);
        if (value != null) {
            if (value instanceof BigDecimal) {
                return ((BigDecimal) value).intValue();
            } else if (value instanceof Long) {
                return ((Long) value).intValue();
            } else if (value instanceof Double) {
                return ((Double) value).intValue();
            } else if (value instanceof String) {
                return Integer.parseInt((String) value);
            }
            return (Integer) value;
        } else {
            return null;
        }
    }

    /**
     * 获得Integer类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Long[] getLongArray(String key) {
        if (StringUtils.isBlank(key)) {
            return null;
        }
        Object value = get(key);
        if (value == null) {
            value = get(key.toLowerCase());
        }
        if (value instanceof String[]) {
            return toLongs((String[]) value);
        } else if (value instanceof String) {
            String[] idsArray = StringUtils.split((String) value, ",");
            return toLongs((String[]) idsArray);
        } else {
            return null;
        }
    }

    /**
     * 根据指定的值返回long型数组，用于删除
     *
     * @param values
     * @return
     */
    private Long[] toLongs(String[] values) {
        if (values != null) {
            List<Long> ret = new LinkedList<Long>();
            for (int i = 0; i < values.length; i++) {
                Long t = DataUtils.toLong(values[i]);
                if (t != null) {
                    ret.add(t);
                }
            }
            return ret.toArray(new Long[ret.size()]);
        }
        return null;
    }

    /**
     * 获得Byte类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Byte getByte(Object key) {
        Integer i = getInt(key);
        return i == null ? null : i.byteValue();
    }

    /**
     * 获得Long类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Long getLong(Object key) {
        Object value = get(key);
        if (value != null) {
            if (value instanceof Long) {
                return (Long) this.get(key);
            } else if (value instanceof BigDecimal) {
                return ((BigDecimal) value).longValue();
            } else if (value instanceof String) {
                return Long.parseLong((String) value);
            }
        }
        return (Long) value;
    }

    /**
     * 获得Double类型的值
     *
     * @param key 键值
     * @return 值
     */
    public Double getDouble(Object key) {
        Object value = get(key);
        if (value != null) {
            if (value instanceof Double) {
                return ((Double) value);
            } else if (value instanceof BigDecimal) {
                return ((BigDecimal) value).doubleValue();
            } else if (value instanceof String) {
                return Double.parseDouble(((String) value).trim());
            }
        }
        return (Double) value;
    }

    /**
     * 获得String类型的值
     *
     * @param key 键值
     * @return 值
     */
    public String getString(Object key) {
        Object v = get(key);
        if (!(v instanceof String) && v != null) {
            return v.toString();
        }
        return (String) v;
    }

    /**
     * 获得Byte类型的值
     *
     * @param key        键值
     * @param defaultVal 无值是的默认值
     * @return 值
     */
    public Byte getByte(Object key, byte defaultVal) {
        Byte b = getByte(key);
        return b == null ? defaultVal : b;
    }

    /**
     * 获得int类型的值
     *
     * @param key        键值
     * @param defaultVal 无值是的默认值
     * @return 值
     */
    public int getInt(Object key, int defaultVal) {
        Integer i = getInt(key);
        return i == null ? defaultVal : i;
    }

    public boolean getBoolean(Object key) {
        return getBoolean(key, false);
    }

    /**
     * 返回boolean类型值
     *
     * @param key
     * @param defaultVal
     * @return
     */
    public boolean getBoolean(Object key, boolean defaultVal) {
        Object v = get(key);
        if (v != null) {
            if (v instanceof Boolean) {
                return (Boolean) v;
            } else if (v instanceof String) {
                return "true".equals((String) v) || "yes".equals(v);
            } else if (v instanceof Number) {
                return ((Number) v).intValue() == 0;
            }
        } else {
            return defaultVal;
        }
        return false;
    }

    /**
     * 获得long类型的值
     *
     * @param key        键值
     * @param defaultVal 无值是的默认值
     * @return 值
     */
    public long getLong(Object key, int defaultVal) {
        Long i = getLong(key);
        return i == null ? defaultVal : i;
    }

    /**
     * 获得String类型的值
     *
     * @param key        键值
     * @param defaultVal 无值是的默认值
     * @return 值
     */
    public String getString(Object key, String defaultVal) {
        String value = getString(key);
        return value == null ? defaultVal : value;
    }

    /**
     * 一次添加多个对象到Map中
     *
     * @param args
     */
    public void puts(Object... args) {
        for (int i = 1; i < args.length; i += 2) {
            put(String.valueOf(args[i - 1]), args[i]);
        }
    }

    /**
     * 将Map转成json格式的字符串
     *
     * @return
     */
    public String toJson() {
        return JsonUtil.toJson(this);
    }

    /**
     * 将Map格式的JSON字符串值，转成Map集合
     *
     * @param keys
     * @return
     */
    public String toJson(Object... keys) {
        Map<Object, Object> map = new HashMap<Object, Object>();
        for (int i = 0; i < keys.length; i++) {
            if (this.containsKey(keys[i]))
                map.put(keys[i], this.get(keys[i]));
        }
        return JsonUtil.toJson(map);
    }

    public static MapBean toMapBean(Map map) {
        if (map != null) {
            MapBean r = new MapBean();
            for (Object key : map.keySet()) {
                r.put(String.valueOf(key), map.get(key));
            }
            return r;
        }
        return null;
    }

    public static MapBean toMapBean(Serializable e) {
        if (e != null) {
            String v = JsonUtil.toJson(e);
            return JsonUtil.toObject(v, MapBean.class);
        }
        return null;
    }

    public Map<String, String> toHashMap() {
        HashMap<String, String> maps = new HashMap<>();
        for (String s : this.keySet()) {
            maps.put(s, this.getString(s));
        }
        return maps;
    }

    @Override
    public Serializable getId() {
        return this.getString("id");
    }
}
```