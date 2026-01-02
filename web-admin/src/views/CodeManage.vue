<template>
  <div class="code-manage">
    <div class="header-bar">
      <h2>卡密管理</h2>
      <el-button type="primary" @click="showGenerate = true">生成卡密</el-button>
    </div>

    <el-table :data="codes" style="width: 100%" v-loading="loading">
      <el-table-column prop="code" label="卡密" width="180" />
      <el-table-column prop="status" label="状态" width="120">
        <template #default="{ row }">
          <el-tag :type="statusType(row.status)">{{ row.status }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="durationDays" label="有效天数" width="100" />
      <el-table-column prop="bindDeviceId" label="绑定设备" show-overflow-tooltip />
      <el-table-column prop="activatedAt" label="激活时间" width="180" />
      <el-table-column prop="expiresAt" label="到期时间" width="180" />
      <el-table-column label="操作" width="120" fixed="right">
        <template #default="{ row }">
          <el-button type="danger" text size="small" @click="handleDisable(row.code)" :disabled="row.status === 'DISABLED'">
            禁用
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="showGenerate" title="生成卡密" width="400px">
      <el-form label-width="100px">
        <el-form-item label="生成数量">
          <el-input-number v-model="generateCount" :min="1" :max="100" />
        </el-form-item>
        <el-form-item label="有效天数">
          <el-input-number v-model="generateDays" :min="1" :max="365" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showGenerate = false">取消</el-button>
        <el-button type="primary" @click="handleGenerate" :loading="generating">生成</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="showResult" title="生成成功" width="500px">
      <p>已生成 {{ generatedCodes.length }} 个卡密：</p>
      <el-input type="textarea" :rows="8" :model-value="generatedCodes.join('\n')" readonly />
      <template #footer>
        <el-button type="primary" @click="copyAll">复制全部</el-button>
        <el-button @click="showResult = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { adminApi } from '../api'

const codes = ref([])
const loading = ref(false)
const showGenerate = ref(false)
const showResult = ref(false)
const generateCount = ref(10)
const generateDays = ref(30)
const generating = ref(false)
const generatedCodes = ref([])

const loadCodes = async () => {
  loading.value = true
  try {
    const { data } = await adminApi.listCodes()
    codes.value = data
  } catch (e) {
    ElMessage.error('加载失败')
  } finally {
    loading.value = false
  }
}

const handleGenerate = async () => {
  generating.value = true
  try {
    const { data } = await adminApi.generateCodes(generateCount.value, generateDays.value)
    if (data.success) {
      generatedCodes.value = data.codes
      showGenerate.value = false
      showResult.value = true
      loadCodes()
    }
  } catch (e) {
    ElMessage.error('生成失败')
  } finally {
    generating.value = false
  }
}

const handleDisable = async (code) => {
  try {
    await adminApi.disableCode(code)
    ElMessage.success('已禁用')
    loadCodes()
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

const copyAll = () => {
  navigator.clipboard.writeText(generatedCodes.value.join('\n'))
  ElMessage.success('已复制到剪贴板')
}

const statusType = (status) => {
  const map = {
    UNSOLD: 'info',
    SOLD: 'warning',
    ACTIVATED: 'success',
    EXPIRED: 'danger',
    DISABLED: 'danger'
  }
  return map[status] || 'info'
}

onMounted(loadCodes)
</script>

<style scoped>
.code-manage {
  color: #fff;
}
.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
h2 {
  margin: 0;
}
</style>
