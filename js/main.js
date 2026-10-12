/*
 * 下载页脚本：二维码生成
 * 依赖 js/qrcode-generator.min.js（qrcode-generator@1.4.4，MIT）提供的全局 qrcode()
 * 二维码内容取当前页面 URL —— 不硬编码 IP/域名，部署到任何地址（含 GitHub Pages 项目页）都自动正确
 */

// 页面 URL：去掉可能的 index.html，并统一补上目录尾斜杠（如 https://user.github.io/repo/）
function pageUrl() {
  var path = location.pathname.replace(/index\.html$/, '');
  if (!path.endsWith('/')) path += '/';
  return location.origin + path;
}

function renderQrCode() {
  var host = document.getElementById('qrcode');
  if (!host || typeof qrcode !== 'function') return;

  try {
    var qr = qrcode(0, 'M'); // type 0 = 按内容自动选版本；M 级纠错对短 URL 足够
    qr.addData(pageUrl());
    qr.make();
    // scalable：输出带 viewBox 的 SVG，由 CSS 控制显示尺寸
    host.innerHTML = qr.createSvgTag({ cellSize: 6, margin: 2, scalable: true });
    var svg = host.querySelector('svg');
    if (svg) {
      svg.setAttribute('role', 'img');
      svg.setAttribute('aria-label', '本下载页二维码');
    }
  } catch (e) {
    host.innerHTML = '<p class="qr-fallback">二维码生成失败，请直接复制地址栏链接</p>';
  }
}

document.addEventListener('DOMContentLoaded', renderQrCode);
