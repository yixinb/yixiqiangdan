@echo off
echo ========================================
echo       GameGrab Pro 环境检查脚本
echo ========================================
echo.

echo 1. 检查 Flutter 安装状态...
where flutter
if %errorlevel% neq 0 (
    echo [错误] Flutter 未找到，请安装 Flutter SDK
    goto end
) else (
    echo [成功] Flutter 已安装
    flutter --version
)
echo.

echo 2. 检查 Java 安装状态...
where java
if %errorlevel% neq 0 (
    echo [错误] Java 未找到，请安装 JDK 11+
    goto end
) else (
    echo [成功] Java 已安装
    java -version
)
echo.

echo 3. 检查 Android SDK...
echo 检查 ANDROID_HOME 环境变量...
echo %ANDROID_HOME%
if "%ANDROID_HOME%"=="" (
    echo [错误] ANDROID_HOME 环境变量未设置
    goto end
)
echo.

echo 4. 运行 Flutter Doctor...
echo ========================================
flutter doctor
echo ========================================

:end
echo.
echo 环境检查完成！
pause