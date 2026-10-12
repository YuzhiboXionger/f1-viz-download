# 压缩界面截图到 300KB 以下：长边缩到 1280px，转 JPEG 后删除原 PNG
# （页面显示宽仅 ~250px，缩到 1280 无视觉损失；原图请自行备份，本脚本不做备份）
# 用法：powershell -File download-site/scripts/compress-screenshots.ps1
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$shotsDir = Join-Path $PSScriptRoot '..\assets\screenshots'
$targetBytes = 300KB

function Compress-ToJpeg {
    param(
        [string]$Src,
        [string]$Dst,
        [int]$Quality,
        [int]$MaxDim
    )

    $loaded = [System.Drawing.Image]::FromFile($Src)
    try {
        $img = New-Object System.Drawing.Bitmap($loaded)  # 深拷贝后立即释放文件句柄
    } finally {
        $loaded.Dispose()
    }

    try {
        # 不放大：仅当原图超过目标尺寸才缩小
        $ratio = [Math]::Min($MaxDim / $img.Width, $MaxDim / $img.Height)
        if ($ratio -gt 1) { $ratio = 1 }
        $w = [int][Math]::Round($img.Width * $ratio)
        $h = [int][Math]::Round($img.Height * $ratio)
        Write-Host ("  {0}x{1} -> {2}x{3} q={4}" -f $img.Width, $img.Height, $w, $h, $Quality)

        if ($w -lt 1 -or $h -lt 1) {
            throw "invalid target size: ${w}x${h}"
        }

        $bmp = New-Object System.Drawing.Bitmap($w, $h)
        try {
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            try {
                $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                $g.DrawImage($img, 0, 0, $w, $h)
            } finally {
                $g.Dispose()
            }

            $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
                Where-Object { $_.MimeType -eq 'image/jpeg' }
            $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
            $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
                [System.Drawing.Imaging.Encoder]::Quality, $Quality)
            $bmp.Save($Dst, $codec, $ep)
        } finally {
            $bmp.Dispose()
        }
    } finally {
        $img.Dispose()
    }
}

Get-ChildItem -Path $shotsDir -Filter 'shot-*.png' | ForEach-Object {
    $src = $_.FullName
    $dst = Join-Path $shotsDir ($_.BaseName + '.jpg')

    # 质量从 85 逐级下调，直到 300KB 以内
    foreach ($q in 85, 80, 75, 70, 65, 60) {
        Compress-ToJpeg -Src $src -Dst $dst -Quality $q -MaxDim 1280
        if ((Get-Item $dst).Length -le $targetBytes) { break }
    }

    $kb = [math]::Round((Get-Item $dst).Length / 1KB, 0)
    Write-Host ("{0}: {1} KB" -f $_.Name, $kb)

    # 压缩成功后删除原 PNG（原图请自行备份）
    Remove-Item $src -Force
}
