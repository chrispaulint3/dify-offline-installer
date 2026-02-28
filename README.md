# Dify 离线镜像备份与部署

本项目用于在离线环境下备份、传输和加载 Dify Docker 镜像，支持 AMD64 和 ARM64 两种架构。

## 目录结构

```
.
├── dify/                          # Dify 官方源码
│   └── docker/                    # Docker 部署配置
├── dify-images-amd64-backup/      # AMD64 架构镜像备份
├── dify-images-arm64-backup/      # ARM64 架构镜像备份
├── save-images.sh                 # 镜像备份脚本
├── load-image.sh                  # 镜像加载脚本
└── env.example                    # 环境配置示例
```

## 包含的镜像

| 镜像 | 版本 |
|------|------|
| langgenius/dify-api | 1.13.0 |
| langgenius/dify-web | 1.13.0 |
| langgenius/dify-plugin-daemon | 0.5.3-local |
| langgenius/dify-sandbox | 0.2.12 |
| nginx | latest |
| postgres | 15-alpine |
| redis | 6-alpine |
| semitechnologies/weaviate | 1.27.0 |
| ubuntu/squid | latest |
| busybox | latest |

## 自定义配置

本项目已对 Dify 进行以下自定义配置：

### 端口配置

| 环境变量 | 默认值 | 自定义值 | 说明 |
|----------|--------|----------|------|
| `EXPOSE_NGINX_PORT` | 80 | 8086 | Nginx HTTP 端口 |
| `EXPOSE_NGINX_SSL_PORT` | 443 | 8443 | Nginx HTTPS 端口 |

### PyPI 镜像配置

| 环境变量 | 说明 |
|----------|------|
| `PIP_MIRROR_URL` | `http://host.docker.internal:8080/simple` |

> **注意**: `PIP_MIRROR_URL` 指向宿主机上的 PyPI 私有服务器，用于在离线环境下安装 Dify 插件。请确保宿主机上运行着 pypiserver 服务。

## 使用方法

### 1. 加载镜像

根据目标机器的架构选择对应的目录：

```bash
# AMD64 架构
cd dify-images-amd64-backup
bash load-image.sh

# ARM64 架构
cd dify-images-arm64-backup
bash load-image.sh
```

或者使用根目录的脚本：

```bash
# 加载 AMD64 镜像
bash load-image.sh dify-images-amd64-backup/

# 加载 ARM64 镜像
bash load-image.sh dify-images-arm64-backup/
```

### 2. 配置环境变量

```bash
# 复制环境配置示例
cp env.example dify/docker/.env

# 编辑配置（可选，根据需要修改）
vim dify/docker/.env
```

### 3. 启动 Dify

```bash
cd dify/docker

# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps
```

### 4. 访问 Dify

- Web UI: http://localhost:8086
- HTTPS: https://localhost:8443

## 重新打包镜像（可选）

如果需要重新备份镜像或更新版本：

```bash
# 编辑镜像列表
vim save-images.sh

# 执行备份
bash save-images.sh
```

备份的镜像将保存在 `docker_backups/` 目录。

## 依赖服务

确保目标机器上已部署以下服务：

- **PyPI 私有服务器**: 用于提供 Python 包，地址为 `http://host.docker.internal:8080`
- **Docker**: 20.10+
- **Docker Compose**: 2.0+

## 常见问题

### 1. 镜像加载失败

- 确认当前机器架构与镜像架构匹配
- 检查 Docker 是否正常运行

### 2. 插件安装失败

- 确认 PyPI 私有服务器正常运行
- 检查 `host.docker.internal` 是否可访问
- 确认防火墙允许 8080 端口访问

### 3. 端口冲突

- 已将默认的 80/443 端口改为 8086/8443
- 如需修改，编辑 `env.example` 中的 `EXPOSE_NGINX_PORT` 和 `EXPOSE_NGINX_SSL_PORT`

## 版本信息

- Dify 版本: 1.13.0
- 镜像架构: AMD64, ARM64
