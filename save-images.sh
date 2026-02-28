#!/bin/bash

# 定义保存目录
SAVE_DIR="./docker_backups"
mkdir -p $SAVE_DIR

# 待备份的镜像列表（从你的输出中提取）
IMAGES=(
    "busybox:latest"
    "langgenius/dify-api:1.13.0"
    "langgenius/dify-plugin-daemon:0.5.3-local"
    "langgenius/dify-sandbox:0.2.12"
    "langgenius/dify-web:1.13.0"
    "nginx:latest"
    "postgres:15-alpine"
    "redis:6-alpine"
    "semitechnologies/weaviate:1.27.0"
    "ubuntu/squid:latest"
)

echo "开始备份 Docker 镜像到 $SAVE_DIR..."

for IMAGE in "${IMAGES[@]}"; do
    # 将镜像名中的斜杠 / 和冒号 : 替换为下划线，用于文件名
    FILE_NAME=$(echo $IMAGE | sed 's/[\/:]/_/g').tar
    
    echo "正在保存: $IMAGE -> $FILE_NAME"
    
    # 执行保存命令
    docker save -o "$SAVE_DIR/$FILE_NAME" "$IMAGE"
    
    if [ $? -eq 0 ]; then
        echo "✅ 成功保存 $IMAGE"
    else
        echo "❌ 失败: $IMAGE"
    fi
done

echo "---"
echo "所有镜像已处理完毕。备份文件位于 $SAVE_DIR"
ls -lh $SAVE_DIR