#!/usr/bin/env sh
# 把 Flutter release APK 发布为 GitHub Release 资产（bash / WSL / macOS / 服务器版）
# 用法（需已安装并登录 gh CLI）：sh download-site/scripts/publish-release.sh 1.0.0
set -e

VERSION="${1:-}"
case "$VERSION" in
    [0-9]*.[0-9]*.[0-9]*) ;;
    *) echo "用法：sh $0 <版本号 x.y.z>（例如 1.0.0）" >&2; exit 1 ;;
esac

SRC="$(dirname "$0")/../../Z_F1_Frontend/build/app/outputs/flutter-apk/app-release.apk"
if [ ! -f "$SRC" ]; then
    echo "未找到 APK：$SRC（请先在 Z_F1_Frontend 目录执行 flutter build apk --release）" >&2
    exit 1
fi

TAG="v$VERSION"
if gh release view "$TAG" >/dev/null 2>&1; then
    gh release upload "$TAG" "$SRC" --clobber
else
    gh release create "$TAG" "$SRC" --title "$TAG" --notes "F1 数据可视化 Android 安装包 $TAG"
fi

echo "已发布 $TAG，下载地址：https://github.com/YuzhiboXionger/f1-viz-download/releases/download/$TAG/app-release.apk"
echo "下载页按钮（始终指向最新版）：https://github.com/YuzhiboXionger/f1-viz-download/releases/latest/download/app-release.apk"
