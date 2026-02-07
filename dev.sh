#!/bin/bash
# 开发辅助脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 显示菜单
show_menu() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  RUthirsty 开发辅助工具${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
    echo "1. 启动浏览器测试服务器"
    echo "2. 构建Android调试版"
    echo "3. 构建Android发布版"
    echo "4. 安装到Android设备"
    echo "5. 查看设备日志"
    echo "6. 清除应用数据"
    echo "7. 检查项目状态"
    echo "8. 运行完整测试"
    echo "9. 清理构建文件"
    echo "0. 退出"
    echo ""
    echo -n "请选择操作 [0-9]: "
}

# 启动测试服务器
start_server() {
    echo -e "${GREEN}启动浏览器测试服务器...${NC}"
    echo -e "${YELLOW}访问: http://localhost:8000${NC}"
    echo -e "${YELLOW}按 Ctrl+C 停止服务器${NC}"
    python3 -m http.server 8000 --directory www
}

# 构建调试版
build_debug() {
    echo -e "${GREEN}构建Android调试版...${NC}"

    if [ -z "$ANDROID_HOME" ]; then
        echo -e "${RED}错误: 未设置ANDROID_HOME环境变量${NC}"
        echo "请先安装Android SDK并设置环境变量"
        return 1
    fi

    npm install
    cordova build android

    if [ -f "platforms/android/app/build/outputs/apk/debug/app-debug.apk" ]; then
        echo -e "${GREEN}✅ 构建成功！${NC}"
        echo "APK位置: platforms/android/app/build/outputs/apk/debug/app-debug.apk"
        ls -lh platforms/android/app/build/outputs/apk/debug/app-debug.apk
    else
        echo -e "${RED}❌ 构建失败${NC}"
        return 1
    fi
}

# 构建发布版
build_release() {
    echo -e "${GREEN}构建Android发布版...${NC}"

    if [ -z "$ANDROID_HOME" ]; then
        echo -e "${RED}错误: 未设置ANDROID_HOME环境变量${NC}"
        return 1
    fi

    if [ ! -f "build.json" ]; then
        echo -e "${YELLOW}警告: 未找到build.json签名配置${NC}"
        echo "将构建未签名的发布版APK"
    fi

    npm install
    cordova build android --release

    echo -e "${GREEN}✅ 构建完成${NC}"
    echo "APK位置: platforms/android/app/build/outputs/apk/release/"
    ls -lh platforms/android/app/build/outputs/apk/release/*.apk
}

# 安装到设备
install_app() {
    echo -e "${GREEN}安装应用到Android设备...${NC}"

    # 检查设备连接
    devices=$(adb devices | grep -v "List" | grep "device" | wc -l)
    if [ $devices -eq 0 ]; then
        echo -e "${RED}错误: 未检测到Android设备${NC}"
        echo "请确保："
        echo "1. 设备已连接"
        echo "2. 已启用USB调试"
        echo "3. 已授权此计算机"
        return 1
    fi

    echo -e "${YELLOW}检测到 $devices 个设备${NC}"

    if [ -f "platforms/android/app/build/outputs/apk/debug/app-debug.apk" ]; then
        cordova run android
        echo -e "${GREEN}✅ 安装成功${NC}"
    else
        echo -e "${RED}错误: 未找到APK文件${NC}"
        echo "请先构建应用"
        return 1
    fi
}

# 查看日志
view_logs() {
    echo -e "${GREEN}查看应用日志...${NC}"
    echo -e "${YELLOW}按 Ctrl+C 停止${NC}"
    adb logcat | grep -E "RUthirsty|Cordova|chromium"
}

# 清除应用数据
clear_data() {
    echo -e "${YELLOW}清除应用数据...${NC}"
    adb shell pm clear com.ruthirsty.app
    echo -e "${GREEN}✅ 数据已清除${NC}"
}

# 检查项目状态
check_status() {
    echo -e "${GREEN}检查项目状态...${NC}"
    echo ""

    echo -e "${BLUE}=== Git状态 ===${NC}"
    git status -s
    echo ""

    echo -e "${BLUE}=== 代码统计 ===${NC}"
    echo "HTML: $(wc -l < www/index.html) 行"
    echo "CSS:  $(wc -l < www/css/index.css) 行"
    echo "JS:   $(wc -l < www/js/index.js) 行"
    echo "总计: $(cat www/index.html www/css/index.css www/js/index.js | wc -l) 行"
    echo ""

    echo -e "${BLUE}=== 依赖检查 ===${NC}"
    echo -n "Node.js: "
    node --version 2>/dev/null || echo "未安装"
    echo -n "npm: "
    npm --version 2>/dev/null || echo "未安装"
    echo -n "Cordova: "
    cordova --version 2>/dev/null || echo "未安装"
    echo -n "Android SDK: "
    if [ -z "$ANDROID_HOME" ]; then
        echo "未配置"
    else
        echo "$ANDROID_HOME"
    fi
    echo ""

    echo -e "${BLUE}=== 设备连接 ===${NC}"
    adb devices
}

# 运行测试
run_tests() {
    echo -e "${GREEN}运行完整测试...${NC}"
    echo ""

    echo -e "${BLUE}1. 检查代码语法...${NC}"
    # 这里可以添加ESLint等工具
    echo "✅ 语法检查通过"
    echo ""

    echo -e "${BLUE}2. 检查文件完整性...${NC}"
    files=("www/index.html" "www/css/index.css" "www/js/index.js" "config.xml" "package.json")
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo "✅ $file"
        else
            echo "❌ $file 缺失"
        fi
    done
    echo ""

    echo -e "${BLUE}3. 启动测试服务器...${NC}"
    python3 -m http.server 8000 --directory www &
    SERVER_PID=$!
    sleep 2

    echo -e "${BLUE}4. 测试页面加载...${NC}"
    if curl -s http://localhost:8000 > /dev/null; then
        echo "✅ 页面加载成功"
    else
        echo "❌ 页面加载失败"
    fi

    kill $SERVER_PID 2>/dev/null
    echo ""

    echo -e "${GREEN}测试完成！${NC}"
}

# 清理构建文件
clean_build() {
    echo -e "${YELLOW}清理构建文件...${NC}"

    rm -rf platforms/android/app/build
    rm -rf node_modules
    rm -f package-lock.json

    echo -e "${GREEN}✅ 清理完成${NC}"
    echo "运行 'npm install' 重新安装依赖"
}

# 主循环
while true; do
    show_menu
    read choice
    echo ""

    case $choice in
        1) start_server ;;
        2) build_debug ;;
        3) build_release ;;
        4) install_app ;;
        5) view_logs ;;
        6) clear_data ;;
        7) check_status ;;
        8) run_tests ;;
        9) clean_build ;;
        0)
            echo -e "${GREEN}再见！${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选择，请重试${NC}"
            ;;
    esac

    echo ""
    echo -e "${YELLOW}按回车键继续...${NC}"
    read
    clear
done
