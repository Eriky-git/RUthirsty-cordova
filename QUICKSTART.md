# 快速开始指南

## 🚀 立即测试应用

### 在浏览器中测试（无需Android设备）

1. 启动HTTP服务器：
```bash
python3 -m http.server 8000 --directory www
```

2. 在浏览器中打开：`http://localhost:8000`

3. 测试功能：
   - 点击"喝水打卡"按钮
   - 选择不同的饮水量
   - 查看今日统计更新
   - 查看记录列表
   - 删除记录
   - 刷新页面验证数据持久化

### 在Android设备上测试

#### 前提条件
- 安装Android SDK
- 设置ANDROID_HOME环境变量
- 启用设备的USB调试模式

#### 步骤

1. **安装依赖**
```bash
npm install
```

2. **构建APK**
```bash
./build.sh
# 或手动执行
cordova build android
```

3. **安装到设备**
```bash
# 方法1：直接运行
cordova run android

# 方法2：手动安装APK
adb install platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

## 📦 构建发布版APK

### 1. 生成签名密钥

```bash
keytool -genkey -v -keystore ruthirsty.keystore -alias ruthirsty -keyalg RSA -keysize 2048 -validity 10000
```

### 2. 创建build.json配置

创建 `build.json` 文件：

```json
{
  "android": {
    "release": {
      "keystore": "ruthirsty.keystore",
      "storePassword": "your-password",
      "alias": "ruthirsty",
      "password": "your-password"
    }
  }
}
```

### 3. 构建发布版

```bash
cordova build android --release
```

生成的APK位置：`platforms/android/app/build/outputs/apk/release/app-release.apk`

## 🔧 开发调试

### 使用Chrome DevTools调试

1. 在Android设备上运行应用
2. 在Chrome浏览器中访问：`chrome://inspect`
3. 找到你的设备和应用
4. 点击"inspect"开始调试

### 查看日志

```bash
# 查看所有日志
adb logcat

# 只查看应用日志
adb logcat | grep "RUthirsty"

# 清除日志
adb logcat -c
```

## 📝 修改应用

### 修改应用名称和图标

1. 编辑 `config.xml`：
```xml
<name>你的应用名称</name>
<widget id="com.yourcompany.app" ...>
```

2. 添加应用图标：
   - 将图标放在 `www/img/` 目录
   - 在 `config.xml` 中配置：
```xml
<icon src="www/img/icon.png" />
```

### 添加启动画面

```bash
cordova plugin add cordova-plugin-splashscreen
```

在 `config.xml` 中配置：
```xml
<preference name="SplashScreenDelay" value="3000" />
<splash src="www/img/splash.png" />
```

## 🐛 常见问题解决

### 问题1：构建失败 - ANDROID_HOME未设置

**解决方案**：
```bash
# Linux/Mac
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# 添加到 ~/.bashrc 或 ~/.zshrc 使其永久生效
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc
```

### 问题2：Gradle构建失败

**解决方案**：
```bash
# 清理构建缓存
cd platforms/android
./gradlew clean

# 重新构建
cd ../..
cordova build android
```

### 问题3：设备未识别

**解决方案**：
```bash
# 检查设备连接
adb devices

# 如果显示"unauthorized"，在设备上允许USB调试
# 如果没有显示设备，检查USB驱动和连接
```

### 问题4：应用安装后闪退

**解决方案**：
```bash
# 查看崩溃日志
adb logcat | grep -E "AndroidRuntime|FATAL"

# 检查Android版本是否 >= 5.1
adb shell getprop ro.build.version.sdk
```

## 📊 性能优化建议

1. **图片优化**：使用压缩的PNG或WebP格式
2. **代码压缩**：使用Webpack或Rollup打包
3. **懒加载**：对大型列表实现虚拟滚动
4. **缓存策略**：合理使用localStorage和IndexedDB

## 🔐 安全建议

1. 不要在代码中硬编码敏感信息
2. 使用HTTPS进行网络请求
3. 验证用户输入
4. 定期更新Cordova和插件版本

## 📚 更多资源

- [Cordova官方文档](https://cordova.apache.org/docs/en/latest/)
- [Android开发者文档](https://developer.android.com/)
- [Material Design指南](https://material.io/design)
