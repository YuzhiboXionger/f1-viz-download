# 界面截图说明

`shot-1.jpg` / `shot-2.jpg` / `shot-3.jpg` 是页面「界面预览」区展示的三张 App 截图（已压缩到 300KB 以内）。

## 更换截图

1. 截图命名为 `shot-1.png` / `shot-2.png` / `shot-3.png`（对应：积分榜、赛历/成绩、聊天室），放在本目录。
2. 在仓库根执行压缩脚本（长边缩到 1280px、转 JPEG、删原 PNG）：

   ```powershell
   powershell -File scripts/compress-screenshots.ps1
   ```

3. 完成。`index.html` 固定引用 `shot-N.jpg`，无需改动。

> 注意：脚本**不备份**原图，会直接删除 PNG，请自行保留原图。
> 若换的图数量或文件名有变化，需同步改 `index.html` 截图区的 `<img src>`。
