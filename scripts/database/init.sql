-- GameGrab Pro 数据库初始化脚本
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS gamegrab DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE gamegrab;

-- 管理员表
CREATE TABLE IF NOT EXISTS admins (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username)
) ENGINE=InnoDB;

-- 卡密表
CREATE TABLE IF NOT EXISTS activation_codes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(32) NOT NULL UNIQUE,
    status ENUM('UNSOLD', 'SOLD', 'ACTIVATED', 'EXPIRED', 'DISABLED') NOT NULL DEFAULT 'UNSOLD',
    duration_days INT DEFAULT 30,
    bind_device_id VARCHAR(128),
    bind_count INT DEFAULT 0,
    activated_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_status (status),
    INDEX idx_device (bind_device_id)
) ENGINE=InnoDB;

-- 激活日志表
CREATE TABLE IF NOT EXISTS activation_logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code_id BIGINT NOT NULL,
    device_id VARCHAR(128) NOT NULL,
    action ENUM('ACTIVATE', 'REBIND', 'CHECK') NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_code_id (code_id),
    INDEX idx_device_id (device_id),
    FOREIGN KEY (code_id) REFERENCES activation_codes(id)
) ENGINE=InnoDB;

-- 用户抢单统计表
CREATE TABLE IF NOT EXISTS grab_statistics (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code_id BIGINT NOT NULL,
    device_id VARCHAR(128) NOT NULL,
    grab_date DATE NOT NULL,
    total_clicks INT DEFAULT 0,
    success_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_code_device_date (code_id, device_id, grab_date),
    FOREIGN KEY (code_id) REFERENCES activation_codes(id)
) ENGINE=InnoDB;


INSERT INTO admins (username, password) VALUES ('yixinb', '20240610')
ON DUPLICATE KEY UPDATE username = username;
