package com.property.util;

/**
 * 格式化工具类
 * 注意：此类仅负责纯粹的字符串格式化，不涉及数据库操作
 */
public class FormatUtil {

    /**
     * 格式化地址（栋/单元/室格式）
     * 例：1栋2单元301室
     */
    public static String formatAddress(String building, String unit, String roomNo) {
        if (building == null) return "";
        return building + "栋"
                + (unit != null ? unit : "") + "单元"
                + (roomNo != null ? roomNo : "") + "室";
    }

    /**
     * 格式化地址（号楼/单元/室格式）
     * 例：1号楼2单元301室
     */
    public static String formatAddressHao(String building, String unit, String roomNo) {
        if (building == null) return "";
        return building + "号楼"
                + (unit != null ? unit : "") + "单元"
                + (roomNo != null ? roomNo : "") + "室";
    }
}
