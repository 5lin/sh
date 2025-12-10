@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: 1. 基础环境设置
:: ==========================================
chcp 65001 >nul
title GitHub Auto Backup Tool (Smart Mode)
color 0A
cls

echo ========================================================
echo       GitHub 自动同步脚本 (Smart Proxy Mode)
echo ========================================================

:: ==========================================
:: 2. 设置网络代理
:: ==========================================
echo [1/6] 正在配置网络代理...
set http_proxy=http://127.0.0.1:10808
set https_proxy=http://127.0.0.1:10808
set all_proxy=socks5://127.0.0.1:10808
set HTTP_PROXY=http://127.0.0.1:10808
set HTTPS_PROXY=http://127.0.0.1:10808
set ALL_PROXY=socks5://127.0.0.1:10808

:: ==========================================
:: 3. 拉取远程更新
:: ==========================================
echo.
echo [2/6] 正在检查远程更新...
git pull origin main
if %errorlevel% neq 0 (
    echo [警告] 尝试强制合并历史...
    git pull origin main --allow-unrelated-histories
)

:: ==========================================
:: 4. 智能检测变动 (核心升级)
:: ==========================================
echo.
echo [3/6] 正在检测本地变动...

:: 使用 git status --porcelain 检查是否有输出，有输出代表有变动
set "changes="
for /f "delims=" %%i in ('git status --porcelain') do set changes=yes

if not defined changes (
    color 0B
    echo.
    echo ============================================
    echo    (^-^) 本地没有变动，不需要备份
    echo ============================================
    goto end_success
)

:: ==========================================
:: 5. 存在变动，执行提交
:: ==========================================
echo [检测到变动] 开始执行备份流程...

echo.
echo [4/6] 添加文件...
git add .

echo.
echo [5/6] 生成版本...
set "timestamp=%date% %time:~0,8%"
git commit -m "Auto backup: %timestamp%"

:: ==========================================
:: 6. 推送
:: ==========================================
echo.
echo [6/6] 推送到 GitHub...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] 备份上传成功！
) else (
    goto end_error
)

:end_success
echo.
echo 3秒后自动退出...
timeout /t 3 >nul
exit

:end_error
color 0C
echo.
echo [ERROR] 发生错误，请检查上方信息。
pause
exit