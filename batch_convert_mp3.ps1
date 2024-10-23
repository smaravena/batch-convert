# OPEN IN FFMPEG ROOT
$ffmpegPath = ".\ffmpeg.exe"
$inputDir = "$pwd\input"
$outputDir = "$pwd\output"
$vbrQuality = 0 #MP3 V0

Get-ChildItem -Path $inputDir -Recurse -Include *.wav, *.flac, *.m4a, *.alac | ForEach-Object {
    $inputFile = $_.FullName
    $relativePath = $inputFile.Substring($inputDir.Length)
    $outputFile = Join-Path -Path $outputDir -ChildPath ($relativePath -replace '\.wav$|\.flac$|\.m4a$|\.alac$', '.mp3')

    # CREATE OUTPUT DIR IF MISSING
    $outputDirPath = Split-Path -Path $outputFile
    if (-not (Test-Path $outputDirPath)) {
        New-Item -ItemType Directory -Path $outputDirPath | Out-Null
    }

    # ECHO
    Write-Output "Converting: '$inputFile' to '$outputFile' with VBR quality $vbrQuality"

    # CONVERT, COPY METADATA (W/O COVER), TRANSFORM TO ID3v2
    & "$ffmpegPath" -i "`"$inputFile`"" -qscale:a $vbrQuality -map_metadata 0 -map 0:a -map -0:v -id3v2_version 3 "`"$outputFile`""
}
