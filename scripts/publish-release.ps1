# 把 Flutter release APK 发布为 GitHub Release 资产
# 下载页按钮指向 releases/latest/download/app-release.apk，发版无需改页面链接
# 用法（需已安装并登录 gh CLI）：
#   powershell -File download-site/scripts/publish-release.ps1 -Version 1.0.0
param(
    [Parameter(Mandatory = $true)]
    [string]$Version
)
$ErrorActionPreference = 'Stop'

$src = Join-Path $PSScriptRoot '..\..\Z_F1_Frontend\build\app\outputs\flutter-apk\app-release.apk'
if (-not (Test-Path $src)) {
    Write-Error "未找到 APK：$src`n请先在 Z_F1_Frontend 目录执行：flutter build apk --release"
}

$tag = "v$Version"
if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    Write-Error "版本号格式应为 x.y.z（例如 1.0.0），收到：$Version"
}

gh release view $tag *> $null
if ($LASTEXITCODE -eq 0) {
    # Release 已存在：覆盖上传资产
    gh release upload $tag $src --clobber
} else {
    gh release create $tag $src --title $tag --notes "F1 数据可视化 Android 安装包 $tag"
}

if ($LASTEXITCODE -ne 0) {
    Write-Error "发布失败，请检查 gh CLI 登录状态（gh auth status）"
}
Write-Host "已发布 $tag，下载地址：https://github.com/YuzhiboXionger/f1-viz-download/releases/download/$tag/app-release.apk"
Write-Host "下载页按钮（始终指向最新版）：https://github.com/YuzhiboXionger/f1-viz-download/releases/latest/download/app-release.apk"
