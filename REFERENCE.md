# 快速参考

## 🚀 常用命令

### 开发测试
```bash
# 启动浏览器测试（最快）
python3 -m http.server 8000 --directory www
# 访问: http://localhost:8000

# 使用开发辅助工具（推荐）
./dev.sh
```

### 构建应用
```bash
# 安装依赖
npm install

# 构建调试版
cordova build android

# 构建发布版
cordova build android --release

# 使用构建脚本
./build.sh
```

### 设备操作
```bash
# 查看连接的设备
adb devices

# 安装应用
cordova run android
# 或
adb install platforms/android/app/build/outputs/apk/debug/app-debug.apk

# 卸载应用
adb uninstall com.ruthirsty.app

# 清除应用数据
adb shell pm clear com.ruthirsty.app
```

### 调试
```bash
# 查看日志
adb logcat | grep "RUthirsty"

# 查看所有日志
adb logcat

# 清除日志
adb logcat -c

# Chrome远程调试
# 1. 在Chrome中访问: chrome://inspect
# 2. 连接设备并运行应用
# 3. 点击"inspect"
```

## 📁 项目结构

```
RUthirsty-cordova/
├── www/                    # Web资源（核心代码）
│   ├── index.html         # 主页面
│   ├── css/
│   │   └── index.css      # 样式
│   ├── js/
│   │   └── index.js       # 逻辑
│   └── img/               # 图片
├── config.xml             # Cordova配置
├── package.json           # 项目配置
├── platforms/             # 平台代码（自动生成）
│   └── android/          # Android平台
├── plugins/              # 插件（自动生成）
├── build.sh              # 构建脚本
├── dev.sh                # 开发工具
├── README.md             # 项目说明
├── QUICKSTART.md         # 快速开始
├── FEATURES.md           # 功能详解
└── TESTING.md            # 测试指南
```

## 🎯 核心文件说明

### www/index.html
- 应用的主页面结构
- 包含统计卡片、打卡按钮、记录列表

### www/css/index.css
- 完整的样式定义
- 渐变背景、卡片阴影、动画效果
- 响应式设计

### www/js/index.js
- 应用的核心逻辑
- 数据存储、统计计算、界面更新
- Cordova设备就绪处理

### config.xml
- 应用ID: com.ruthirsty.app
- 应用名称: RUthirsty
- 版本: 1.0.0
- 最低Android版本: 5.1 (API 22)
- 目标Android版本: 13 (API 33)

## 🔧 修改配置

### 修改应用名称
编辑 `config.xml`:
```xml
<name>你的应用名称</name>
```

### 修改包名
编辑 `config.xml`:
```xml
<widget id="com.yourcompany.app" ...>
```

### 修改版本号
编辑 `config.xml`:
```xml
<widget version="1.0.1" ...>
```

### 修改饮水量选项
编辑 `www/index.html`:
```html
<select id="volumeSelect">
    <option value="150">150ml</option>
    <option value="200">200ml</option>
    <option value="250" selected>250ml</option>
    <option value="300">300ml</option>
    <option value="500">500ml</option>
    <option value="1000">1000ml</option>
</select>
```

## 🎨 自定义样式

### 修改主题颜色
编辑 `www/css/index.css`:
```css
/* 背景渐变 */
body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* 按钮颜色 */
.checkin-btn {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* 统计数字颜色 */
.stat-number {
    color: #667eea;
}
```

### 修改按钮大小
编辑 `www/css/index.css`:
```css
.checkin-btn {
    width: 220px;  /* 默认: 200px */
    height: 220px; /* 默认: 200px */
}
```

## 📊 数据格式

### localStorage结构
```javascript
{
  "waterRecords": [
    {
      "id": 1707123456789,        // 唯一ID
      "timestamp": 1707123456789,  // 时间戳
      "volume": 250,               // 饮水量(ml)
      "date": "2026-02-07"        // 日期
    }
  ]
}
```

### 访问数据
```javascript
// 获取所有记录
const records = JSON.parse(localStorage.getItem('waterRecords') || '[]');

// 添加记录
records.push({
  id: Date.now(),
  timestamp: Date.now(),
  volume: 250,
  date: '2026-02-07'
});
localStorage.setItem('waterRecords', JSON.stringify(records));

// 清空记录
localStorage.removeItem('waterRecords');
```

## 🔌 添加插件

### 常用插件
```bash
# 震动插件
cordova plugin add cordova-plugin-vibration

# 状态栏插件
cordova plugin add cordova-plugin-statusbar

# 网络状态插件
cordova plugin add cordova-plugin-network-information

# 本地通知插件
cordova plugin add cordova-plugin-local-notification

# 文件系统插件
cordova plugin add cordova-plugin-file
```

### 查看已安装插件
```bash
cordova plugin list
```

### 删除插件
```bash
cordova plugin remove <plugin-name>
```

## 🐛 常见问题快速解决

### 问题: ANDROID_HOME未设置
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### 问题: Gradle构建失败
```bash
cd platforms/android
./gradlew clean
cd ../..
cordova build android
```

### 问题: 设备未识别
```bash
# 检查设备
adb devices

# 重启adb服务
adb kill-server
adb start-server
```

### 问题: 应用闪退
```bash
# 查看崩溃日志
adb logcat | grep -E "AndroidRuntime|FATAL"
```

## 📱 APK位置

### 调试版
```
platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### 发布版
```
platforms/android/app/build/outputs/apk/release/app-release.apk
```

## 🔑 快捷键（开发工具）

使用 `./dev.sh` 后：
- `1` - 启动浏览器测试
- `2` - 构建调试版
- `3` - 构建发布版
- `4` - 安装到设备
- `5` - 查看日志
- `6` - 清除数据
- `7` - 检查状态
- `8` - 运行测试
- `9` - 清理构建
- `0` - 退出

## 📞 获取帮助

### 文档
- README.md - 完整项目说明
- QUICKSTART.md - 快速开始指南
- FEATURES.md - 功能详解
- TESTING.md - 测试指南

### 在线资源
- Cordova文档: https://cordova.apache.org/docs/
- Android开发: https://developer.android.com/
- GitHub仓库: https://github.com/Eriky-git/RUthirsty-cordova

### 问题反馈
- GitHub Issues: https://github.com/Eriky-git/RUthirsty-cordova/issues

## 💡 开发技巧

### 快速测试
```bash
# 一键启动测试
python3 -m http.server 8000 --directory www &
# 在浏览器中打开 http://localhost:8000
```

### 快速构建和安装
```bash
# 一条命令完成构建和安装
cordova run android
```

### 实时日志
```bash
# 持续查看应用日志
adb logcat | grep "RUthirsty"
```

### 快速清理
```bash
# 清理并重新构建
rm -rf platforms/android/app/build && cordova build android
```

## 🎓 学习资源

### JavaScript
- localStorage API
- Date对象操作
- DOM操作
- 事件处理

### CSS
- Flexbox布局
- CSS动画
- 渐变背景
- 响应式设计

### Cordova
- 设备就绪事件
- 插件系统
- 平台配置
- 构建流程

---

💧 **记住**: 保持代码简洁，功能实用，用户体验流畅！
