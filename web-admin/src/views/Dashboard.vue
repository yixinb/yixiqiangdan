<template>
  <el-container class="dashboard">
    <el-aside width="220px" class="sidebar">
      <div class="logo">
        <el-icon :size="32" color="#6C5CE7"><Monitor /></el-icon>
        <span>GameGrab Pro</span>
      </div>
      <el-menu :default-active="activeMenu" background-color="#16213e" text-color="#fff" active-text-color="#6C5CE7" router>
        <el-menu-item index="/dashboard/codes">
          <el-icon><Ticket /></el-icon>
          <span>卡密管理</span>
        </el-menu-item>
        <el-menu-item index="/dashboard/stats">
          <el-icon><DataLine /></el-icon>
          <span>数据统计</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <span class="title">管理后台</span>
        <el-button type="danger" text @click="logout">退出登录</el-button>
      </el-header>
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Monitor, Ticket, DataLine } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()

const activeMenu = computed(() => route.path)

const logout = () => {
  localStorage.removeItem('admin_token')
  router.push('/login')
}
</script>

<style scoped>
.dashboard {
  min-height: 100vh;
}
.sidebar {
  background: #16213e;
  border-right: 1px solid rgba(255, 255, 255, 0.1);
}
.logo {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 20px;
  color: #fff;
  font-weight: bold;
  font-size: 16px;
}
.header {
  background: #1a1a2e;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}
.title {
  color: #fff;
  font-size: 18px;
}
.main {
  background: #0f0f23;
  padding: 24px;
}
</style>
