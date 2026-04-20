<template>
  <div class="stats-page">
    <h2>数据统计</h2>

    <el-row :gutter="20" class="stat-cards">
      <el-col :span="6">
        <div class="stat-card">
          <div class="stat-value">{{ stats.totalCodes }}</div>
          <div class="stat-label">卡密总数</div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card">
          <div class="stat-value success">{{ stats.activatedCodes }}</div>
          <div class="stat-label">已激活</div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card">
          <div class="stat-value warning">{{ stats.unsoldCodes }}</div>
          <div class="stat-label">未售出</div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card">
          <div class="stat-value danger">{{ stats.expiredCodes }}</div>
          <div class="stat-label">已过期</div>
        </div>
      </el-col>
    </el-row>

    <div class="chart-section">
      <h3>近7日激活趋势</h3>
      <div class="chart-placeholder">
        <el-empty description="图表功能开发中" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { adminApi } from '../api'

const stats = ref({
  totalCodes: 0,
  activatedCodes: 0,
  unsoldCodes: 0,
  expiredCodes: 0
})

const loadStats = async () => {
  try {
    const { data } = await adminApi.listCodes()
    stats.value.totalCodes = data.length
    stats.value.activatedCodes = data.filter(c => c.status === 'ACTIVATED').length
    stats.value.unsoldCodes = data.filter(c => c.status === 'UNSOLD').length
    stats.value.expiredCodes = data.filter(c => c.status === 'EXPIRED').length
  } catch (e) {
    // ignore
  }
}

onMounted(loadStats)
</script>

<style scoped>
.stats-page {
  color: #fff;
}
h2 {
  margin-bottom: 24px;
}
.stat-cards {
  margin-bottom: 32px;
}
.stat-card {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 24px;
  text-align: center;
}
.stat-value {
  font-size: 36px;
  font-weight: bold;
  color: #6C5CE7;
}
.stat-value.success { color: #00b894; }
.stat-value.warning { color: #fdcb6e; }
.stat-value.danger { color: #d63031; }
.stat-label {
  color: #888;
  margin-top: 8px;
}
.chart-section {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  padding: 24px;
}
h3 {
  margin-bottom: 16px;
}
.chart-placeholder {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
