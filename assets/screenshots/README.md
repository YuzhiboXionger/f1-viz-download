# 界面截图替换说明

本目录当前的 `shot-1.svg` ~ `shot-3.svg` 是**占位图**（深色示意框 + 文字标注），仅用于布局展示。替换成真实 App 截图的方法：

## 步骤

1. 在 Android 手机/模拟器上打开 App，截取三张界面图，建议对应：
   - `shot-1`：赛季积分榜
   - `shot-2`：赛历 / 单站成绩
   - `shot-3`：公频聊天室
2. 将图片命名为 `shot-1.png` / `shot-2.png` / `shot-3.png`（或 `.jpg`）放在本目录。
3. 打开 `../../index.html`，把截图区 `<img>` 的 `src` 扩展名从 `.svg` 改成对应扩展名，例如：

   ```html
   <img src="assets/screenshots/shot-1.png" alt="赛季积分榜界面预览" loading="lazy">
   ```

4. （可选）删除对应的 `.svg` 占位文件。

## 图片约定

- 竖屏手机比例（约 9:19.5），短边建议 ≥ 1080px
- 单张体积建议 ≤ 300KB（可用 [squoosh](https://squoosh.app) 或本仓库 `scripts/compress_assets.ps1` 的思路压缩）
- App 本身是深色主题，与下载页视觉一致，无需额外加手机壳外框（页面 CSS 的 `.shot-frame` 已提供）
