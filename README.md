# RUthirsty-cordova

💧 一个基于Cordova的喝水打卡应用，帮助你记录每日饮水习惯。

## 功能特性

- ✅ **一键打卡**：点击大按钮快速记录喝水
- 📊 **今日统计**：实时显示今日喝水次数和总饮水量
- 📝 **记录列表**：查看所有喝水记录，包括时间和饮水量
- 🎯 **自定义饮水量**：支持200ml、250ml、300ml、500ml等选项
- 💾 **本地存储**：使用localStorage保存数据，无需网络
- 🗑️ **记录管理**：可删除单条记录或清空所有记录
- 📱 **响应式设计**：适配各种屏幕尺寸

## 项目结构

```
RUthirsty-cordova/
├── config.xml              # Cordova配置文件
├── package.json            # Node.js项目配置
├── www/                    # Web资源目录
│   ├── index.html         # 主页面
│   ├── css/
│   │   └── index.css      # 样式文件
│   ├── js/
│   │   └── index.js       # 应用逻辑
│   └── img/               # 图片资源
├── platforms/             # 平台特定代码（自动生成）
│   └── android/          # Android平台
└── plugins/              # Cordova插件（自动生成）
```

## 技术栈

- **Cordova**: 12.x
- **Android平台**: cordova-android 12.0.1
- **最低Android版本**: API 22 (Android 5.1)
- **目标Android版本**: API 33 (Android 13)

## 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 安装Android SDK（如果还没有）

#### 方法一：使用Android Studio（推荐）

1. 下载并安装 [Android Studio](https://developer.android.com/studio)
2. 打开Android Studio，进入 SDK Manager
3. 安装以下组件：
   - Android SDK Platform 33
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android SDK Command-line Tools

4. 设置环境变量：

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
```

5. 重新加载配置：

```bash
source ~/.bashrc  # 或 source ~/.zshrc
```

#### 方法二：使用命令行工具

```bash
# 下载Android SDK命令行工具
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip -d $HOME/android-sdk
mkdir -p $HOME/android-sdk/cmdline-tools/latest
mv $HOME/android-sdk/cmdline-tools/* $HOME/android-sdk/cmdline-tools/latest/

# 设置环境变量
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# 安装必要的SDK组件
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
```

### 3. 构建Android应用

```bash
# 构建调试版APK
cordova build android

# 构建发布版APK
cordova build android --release
```

生成的APK文件位置：
- 调试版：`platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- 发布版：`platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`

### 4. 运行应用

#### 在Android设备上运行

```bash
# 连接Android设备并启用USB调试
# 然后运行：
cordova run android
```

#### 在Android模拟器上运行

```bash
# 首先创建AVD（Android Virtual Device）
# 然后运行：
cordova emulate android
```

#### 在浏览器中测试（开发调试）

```bash
# 安装cordova-serve（如果还没有）
npm install -g cordova-serve

# 启动本地服务器
cordova-serve www

# 或者使用简单的HTTP服务器
python3 -m http.server 8000 --directory www
```

然后在浏览器中访问 `http://localhost:8000`

**注意**：在浏览器中测试时，`cordova.js` 不会加载，但应用的核心功能（打卡、记录、统计）仍然可以正常工作。

## 应用使用说明

### 打卡流程

1. 打开应用，查看今日统计
2. 选择本次饮水量（默认250ml）
3. 点击中央的"喝水打卡"按钮
4. 记录自动保存并显示在列表中

### 查看记录

- 记录按时间倒序排列（最新的在上面）
- 显示格式：日期 + 时间 + 饮水量
- 今天的记录显示"今天"，昨天的显示"昨天"

### 管理记录

- **删除单条记录**：点击记录右侧的"删除"按钮
- **清空所有记录**：点击"清空记录"按钮（需要确认）

## 开发说明

### 修改应用配置

编辑 `config.xml` 文件可以修改：
- 应用名称
- 应用ID（包名）
- 版本号
- 应用描述
- 权限设置

### 修改界面和功能

- **HTML结构**：编辑 `www/index.html`
- **样式**：编辑 `www/css/index.css`
- **逻辑**：编辑 `www/js/index.js`

### 添加Cordova插件

```bash
# 例如：添加震动插件
cordova plugin add cordova-plugin-vibration

# 添加状态栏插件
cordova plugin add cordova-plugin-statusbar
```

### 调试

```bash
# 查看设备日志
adb logcat

# 使用Chrome DevTools调试
# 1. 在Chrome中访问 chrome://inspect
# 2. 连接设备并运行应用
# 3. 点击"inspect"开始调试
```

## 数据存储

应用使用 `localStorage` 存储数据，数据结构如下：

```javascript
{
  "waterRecords": [
    {
      "id": 1707123456789,
      "timestamp": 1707123456789,
      "volume": 250,
      "date": "2026-02-07"
    }
  ]
}
```

## 常见问题

### Q: 构建失败，提示找不到ANDROID_HOME？
A: 请确保已安装Android SDK并正确设置环境变量。参考上面的"安装Android SDK"部分。

### Q: 应用安装后无法打开？
A: 检查Android版本是否 >= 5.1（API 22）。

### Q: 数据会丢失吗？
A: 数据存储在设备本地，除非卸载应用或清除应用数据，否则不会丢失。

### Q: 如何导出数据？
A: 当前版本不支持数据导出。未来版本可以添加导出为CSV或JSON的功能。

## 未来计划

- [ ] 添加每日饮水目标设置
- [ ] 添加提醒功能（定时提醒喝水）
- [ ] 添加数据统计图表
- [ ] 添加数据导出功能
- [ ] 添加主题切换（深色模式）
- [ ] 添加多语言支持

## 贡献

欢迎提交Issue和Pull Request！

## 许可证

MIT License

## 联系方式

- GitHub: https://github.com/Eriky-git/RUthirsty-cordova
- Email: dev@ruthirsty.com

---

💧 记得每天喝足够的水！保持健康！