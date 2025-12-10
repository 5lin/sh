@echo off
chcp 65001 >nul
setlocal

:MENU
cls
echo ==========================================
echo       H U G O   新文章生成器
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
echo 请输入文章文件名 (例如: my-new-post)
echo *注意: 建议使用英文，不要包含空格，后缀名.md会自动添加
echo.
set /p "FILENAME=文件名: "

:: 执行 Hugo 命令
echo.
echo 正在生成: content/posts/%SECTION%/%FILENAME%.md ...
hugo new posts/%SECTION%/%FILENAME%.md

echo.
echo ==========================================
echo  ✅ 文章创建成功！
echo ==========================================
echo.
pause