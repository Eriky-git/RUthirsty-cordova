// 应用主逻辑
const WaterTracker = {
    // 初始化
    init: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // 设备就绪
    onDeviceReady: function() {
        console.log('Cordova is ready');
        this.bindEvents();
        this.loadRecords();
        this.updateStats();
    },

    // 绑定事件
    bindEvents: function() {
        const checkinBtn = document.getElementById('checkinBtn');
        const clearBtn = document.getElementById('clearBtn');

        checkinBtn.addEventListener('click', this.handleCheckin.bind(this));
        clearBtn.addEventListener('click', this.handleClear.bind(this));
    },

    // 处理打卡
    handleCheckin: function() {
        const volumeSelect = document.getElementById('volumeSelect');
        const volume = parseInt(volumeSelect.value);

        const record = {
            id: Date.now(),
            timestamp: new Date().getTime(),
            volume: volume,
            date: this.formatDate(new Date())
        };

        // 保存记录
        this.saveRecord(record);

        // 更新界面
        this.loadRecords();
        this.updateStats();

        // 按钮动画反馈
        const btn = document.getElementById('checkinBtn');
        btn.style.transform = 'scale(0.95)';
        setTimeout(() => {
            btn.style.transform = 'scale(1)';
        }, 200);

        // 可选：添加震动反馈（如果设备支持）
        if (navigator.vibrate) {
            navigator.vibrate(100);
        }
    },

    // 保存记录到localStorage
    saveRecord: function(record) {
        let records = this.getRecords();
        records.unshift(record); // 添加到数组开头
        localStorage.setItem('waterRecords', JSON.stringify(records));
    },

    // 获取所有记录
    getRecords: function() {
        const data = localStorage.getItem('waterRecords');
        return data ? JSON.parse(data) : [];
    },

    // 获取今日记录
    getTodayRecords: function() {
        const records = this.getRecords();
        const today = this.formatDate(new Date());
        return records.filter(record => record.date === today);
    },

    // 加载并显示记录
    loadRecords: function() {
        const recordsList = document.getElementById('recordsList');
        const records = this.getRecords();

        if (records.length === 0) {
            recordsList.innerHTML = '<div class="empty-message">暂无打卡记录<br>点击上方按钮开始记录吧！</div>';
            return;
        }

        let html = '';
        records.forEach(record => {
            const date = new Date(record.timestamp);
            const timeStr = this.formatTime(date);
            const dateStr = this.formatDateChinese(date);

            html += `
                <div class="record-item" data-id="${record.id}">
                    <div class="record-info">
                        <div class="record-time">${dateStr} ${timeStr}</div>
                        <div class="record-volume">💧 ${record.volume}ml</div>
                    </div>
                    <button class="record-delete" onclick="WaterTracker.deleteRecord(${record.id})">删除</button>
                </div>
            `;
        });

        recordsList.innerHTML = html;
    },

    // 更新统计数据
    updateStats: function() {
        const todayRecords = this.getTodayRecords();
        const todayCount = todayRecords.length;
        const todayVolume = todayRecords.reduce((sum, record) => sum + record.volume, 0);

        document.getElementById('todayCount').textContent = todayCount;
        document.getElementById('todayVolume').textContent = todayVolume;
    },

    // 删除单条记录
    deleteRecord: function(id) {
        let records = this.getRecords();
        records = records.filter(record => record.id !== id);
        localStorage.setItem('waterRecords', JSON.stringify(records));

        this.loadRecords();
        this.updateStats();
    },

    // 清空所有记录
    handleClear: function() {
        if (confirm('确定要清空所有记录吗？此操作不可恢复！')) {
            localStorage.removeItem('waterRecords');
            this.loadRecords();
            this.updateStats();
        }
    },

    // 格式化日期 (YYYY-MM-DD)
    formatDate: function(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    },

    // 格式化时间 (HH:MM:SS)
    formatTime: function(date) {
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const seconds = String(date.getSeconds()).padStart(2, '0');
        return `${hours}:${minutes}:${seconds}`;
    },

    // 格式化中文日期
    formatDateChinese: function(date) {
        const today = new Date();
        const yesterday = new Date(today);
        yesterday.setDate(yesterday.getDate() - 1);

        const dateStr = this.formatDate(date);
        const todayStr = this.formatDate(today);
        const yesterdayStr = this.formatDate(yesterday);

        if (dateStr === todayStr) {
            return '今天';
        } else if (dateStr === yesterdayStr) {
            return '昨天';
        } else {
            const month = date.getMonth() + 1;
            const day = date.getDate();
            return `${month}月${day}日`;
        }
    }
};

// 启动应用
WaterTracker.init();
