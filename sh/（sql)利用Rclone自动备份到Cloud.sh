#!/bin/bash

# --- 配置部分 ---
DB_USER="your_db_username"      # 你的数据库用户名
DB_PASSWORD="your_db_password"  # 你的数据库密码
DB_NAME="your_database_name"    # 你要备份的数据库名称 (例如：my_website_db)
# 如果想备份所有数据库，请将 DB_NAME 设为 "--all-databases"
# DB_NAME="--all-databases"

BACKUP_DIR="/mnt/gdrive/" # 备份目标路径，请确保这是你的Google Drive挂载点内的目录

# --- 脚本逻辑 ---

# 检查并创建备份目录
mkdir -p "$BACKUP_DIR" || { echo "错误: 无法创建或访问备份目录 $BACKUP_DIR。请检查权限和Rclone挂载状态。" >&2; exit 1; }

# 生成带日期和时间戳的文件名
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${DB_NAME}_${TIMESTAMP}.sql" # 文件扩展名改为 .sql
FULL_BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

echo "开始备份数据库: ${DB_NAME} 到 ${FULL_BACKUP_PATH}..."

# 执行 MySQL 数据库备份 (不进行压缩)
mysqldump --single-transaction --skip-lock-tables -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" > "${FULL_BACKUP_PATH}"

# 检查备份是否成功
if [ $? -eq 0 ]; then # 检查mysqldump的退出状态
    echo "数据库备份成功！文件: ${FULL_BACKUP_PATH}"
else
    echo "错误: 数据库备份失败！请检查数据库凭据、权限或Rclone挂载状态。" >&2
    exit 1
fi

# --- 可选：清理旧备份 ---
# 示例：删除超过7天的备份文件，保留最新的
# find "$BACKUP_DIR" -type f -name "*.sql" -mtime +7 -delete
# echo "旧备份清理完成 (保留最近7天)。"

echo "备份脚本执行完毕。"