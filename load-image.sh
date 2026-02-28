#!/usr/bin/env bash
set -e

echo "== 开始加载 docker 镜像 =="

count=0

for f in *.tar; do
  if [ -f "$f" ]; then
    echo "----"
    echo "加载镜像: $f"
    docker load -i "$f"
    count=$((count+1))
  fi
done

echo "----"
echo "完成，共加载 $count 个镜像"
docker images
