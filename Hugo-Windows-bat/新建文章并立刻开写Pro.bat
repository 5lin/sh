@echo off
chcp 65001 >nul
setlocal

:MENU
cls
echo ==========================================
echo       H U G O   新文章生成器 (Pro版)
echo ==========================================
echo.
echo  请选择文章分区：
echo.
echo  [1] 生活 (Life)
echo  [2] 技术 (Techs)
echo.
echo ==========================================
set /p "choice=请输入数字 (1 或 2): "

if "%choice%"=="1" (
    set "SECTION=life"
    goto INPUT_NAME
)
if "%choice%"=="2" (
    set "SECTION=techs"
    goto INPUT_NAME
)

echo 选择无效，请重新选择...
timeout /t 2 >nul
goto MENU

:INPUT_NAME
echo.
echo 你选择了: posts/%SECTION%
echo.
set /p "FILENAME=请输入文件名 (英文, 无需后缀): "

:: 1. 执行 Hugo 命令生成文件
echo.
echo 正在召唤 Hugo...
hugo new posts/%SECTION%/%FILENAME%.md

:: 2. 获取文件的绝对路径 (这是进阶的关键)
:: %cd% 代表当前目录，我们把它拼接成完整的文件路径
set "FULLPATH=%cd%\content\posts\%SECTION%\%FILENAME%.md"

echo.
echo ==========================================
echo  ✅ 文章创建成功！
echo  🚀 正在启动 Obsidian 打开文件...
echo ==========================================

:: 3. 自动打开文件
:: start "" "路径" 会调用系统默认程序(Obsidian)打开它
start "" "obsidian://open?path=%FULLPATH%"

:: 4. 自动关闭黑框框，深藏功与名
exit