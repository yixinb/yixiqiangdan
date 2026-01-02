<template>
  <div class="login-container">
    <div class="login-box">
      <div class="logo">
        <el-icon :size="48" color="#6C5CE7"><Monitor /></el-icon>
      </div>
      <h1>GameGrab Pro</h1>
      <p class="subtitle">管理后台</p>
      <el-form @submit.prevent="handleLogin" class="login-form">
        <el-form-item>
          <el-input v-model="username" placeholder="用户名" prefix-icon="User" size="large" />
        </el-form-item>
        <el-form-item>
          <el-input v-model="password" type="password" placeholder="密码" prefix-icon="Lock" size="large" show-password />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" native-type="submit" :loading="loading" size="large" style="width: 100%">
            登录
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Monitor } from '@element-plus/icons-vue'
import { adminApi } from '../api'

const router = useRouter()
const username = ref('')
const password = ref('')
const loading = ref(false)

const handleLogin = async () => {
  if (!username.value || !password.value) {
    ElMessage.warning('请输入用户名和密码')
    return
  }
  loading.value = true
  try {
    const { data } = await adminApi.login(username.value, password.value)
    if (data.success) {
      localStorage.setItem('admin_token', data.token)
      ElMessage.success('登录成功')
      router.push('/dashboard')
    } else {
      ElMessage.error(data.message || '登录失败')
    }
  } catch (e) {
    ElMessage.error('登录失败，请检查网络')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
}
.login-box {
  background: rgba(255, 255, 255, 0.05);
  padding: 48px;
  border-radius: 16px;
  text-align: center;
  width: 380px;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
.logo {
  margin-bottom: 16px;
}
h1 {
  color: #fff;
  margin-bottom: 8px;
  font-size: 24px;
}
.subtitle {
  color: #888;
  margin-bottom: 32px;
}
.login-form {
  text-align: left;
}
</style>
