#!/bin/bash
# 构建脚本 - 用于有Android SDK的环境

echo "开始构建RUthirsty Android应用..."

# 检查Android SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "错误: 未找到ANDROID_HOME环境变量"
    echo "请先安装Android SDK并设置环境变量"
    exit 1
fi

# 安装依赖
echo "安装依赖..."
npm install

# 构建调试版APK
echo "构建调试版APK..."
cordova build android

# 显示APK位置
if [ -f "platforms/android/app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo "✅ 构建成功！"
    echo "APK位置: platforms/android/app/build/outputs/apk/debug/app-debug.apk"
    ls -lh platforms/android/app/build/outputs/apk/debug/app-debug.apk
else
    echo "❌ 构建失败"
    exit 1
fi
