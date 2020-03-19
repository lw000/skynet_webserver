/*
 Navicat MySQL Data Transfer

 Source Server         : 192.168.110.240
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.110.240:3306
 Source Schema         : webserver

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 19/03/2020 15:00:41
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for reqLog
-- ----------------------------
DROP TABLE IF EXISTS `reqLog`;
CREATE TABLE `reqLog`  (
  `id` int(11) NOT NULL COMMENT '自增ID',
  `clientIp` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '客户端IP',
  `body` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求内容',
  `header` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求头',
  `updateTime` datetime(0) NULL DEFAULT NULL COMMENT '更新日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
