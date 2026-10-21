# 轨速 — App 下载页

「轨速」Android 安装包下载页：纯静态单页（HTML/CSS/JS，无构建步骤、无 CDN 依赖）。

- **独立仓库**：`github.com/YuzhiboXionger/f1-viz-download`（与 App 主仓库 `f1-viz-server` 分开）
- 部署：GitHub Pages（`.github/workflows/deploy-pages.yml` 自动发布仓库根目录）
- 页面中央二维码指向**本页 URL**（`js/main.js` 动态取 `location.origin + location.pathname`，不硬编码地址）
- 下载按钮指向**本仓库 GitHub Release** 的 `releases/latest/download/app-release.apk`——该链接永远指向最新版资产，**发版无需改页面**

页面地址：`https://yuzhiboxionger.github.io/f1-viz-download/`

## 目录

| 路径 | 说明 |
|---|---|
| `index.html` / `css/` / `js/` | 页面本体；`js/qrcode-generator.min.js` 是 vendor 的二维码库 |
| `assets/app-icon.png` | App 图标（复制自 App 仓库 `f1-viz-app` 的 `assets/icon/app_icon.png`） |
| `assets/screenshots/` | 界面截图（当前为占位 SVG，替换方法见该目录 README） |
| `scripts/publish-release.*` | 把 APK 发布为本仓库的 GitHub Release 资产 |
| `.github/workflows/deploy-pages.yml` | push main 自动发布到 GitHub Pages |

二维码库：[qrcode-generator](https://github.com/kazuhikoarase/qrcode-generator) v1.4.4（MIT），一次性 vendor 入库，页面运行时零网络请求。

## 1. 发布 APK（GitHub Release）

APK 在主仓库（`f1-viz-server`）构建（见主仓库 `deploy/README.md` 第三节；`DEFAULT_BASE_URL` 换成后端公网地址）：

```bash
cd Z_F1_Frontend
flutter build apk --release --dart-define=DEFAULT_BASE_URL=http://你的公网IP
```

然后在**本仓库**发布为 Release 资产（需安装并登录 [gh CLI](https://cli.github.com)）：

```powershell
# Windows
powershell -File scripts/publish-release.ps1 -Version 1.0.0
```

```sh
# bash / WSL / macOS
sh scripts/publish-release.sh 1.0.0
```

脚本会创建 `v1.0.0` Release 并上传 `app-release.apk`；Release 已存在时覆盖上传同名资产。

> 脚本默认从 `../../Z_F1_Frontend/build/...` 取 APK，即本仓库与 App 仓库目录 `Z_F1_Frontend` 是兄弟目录。若目录布局变了，改脚本开头的 `$src` / `SRC` 路径即可。

## 2. 本地预览

**不要**直接双击 `index.html`（`file://` 下 `location.origin` 为 null，二维码内容会错），起一个本地 HTTP 服务：

```bash
python -m http.server 8080    # 在本仓库根目录执行
# 打开 http://localhost:8080/
```

- 桌面宽窗口：左侧图标/下载按钮、右侧大二维码
- F12 设备模拟器（手机）：全宽大下载按钮置顶，二维码缩小

## 3. 部署（GitHub Pages）

1. 一次性设置：仓库 **Settings → Pages → Build and deployment → Source** 选 **GitHub Actions**。
2. 推送到 `main` 即自动部署；页面地址 `https://yuzhiboxionger.github.io/f1-viz-download/`
3. 验证：桌面浏览器打开页面 → 手机扫二维码 → 点大按钮下载 APK。

> 提示：GitHub Pages 在中国大陆访问可能不稳定，若主要面向国内用户，可另备国内服务器/对象存储分发渠道。

## 发版清单

1. 改 `index.html` 里的版本徽标（`Android · v1.0.0`）和文件大小文案
2. 主仓库 `flutter build apk --release` → 本仓库跑 `scripts/publish-release.*` 上传 APK
3. 提交 `index.html` 改动并推送，Pages 自动更新
