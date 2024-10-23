# OPEN IN FFMPEG ROOT
$ffmpegPath = ".\ffmpeg.exe"
$inputDir = "$pwd\input"
$outputDir = "$pwd\output"
$bitrate = "128k"  # OPUS 128kbps

Get-ChildItem -Path $inputDir -Recurse -Include *.wav, *.flac, *.m4a, *.alac | ForEach-Object {
    $inputFile = $_.FullName
    $relativePath = $inputFile.Substring($inputDir.Length)
    $outputFile = Join-Path -Path $outputDir -ChildPath ($relativePath -replace '\.wav$|\.flac$|\.m4a$|\.alac$', '.opus')

    # CREATE OUTPUT DIR IF MISSING
    $outputDirPath = Split-Path -Path $outputFile
    if (-not (Test-Path $outputDirPath)) {
        New-Item -ItemType Directory -Path $outputDirPath | Out-Null
    }

    # ECHO
    Write-Output "Converting: '$inputFile' to '$outputFile' with bitrate $bitrate"

    # CONVERT, COPY METADATA (W/O COVER), TRANSFORM TO ID3v2
    & "$ffmpegPath" -i "`"$inputFile`"" -c:a libopus -b:a $bitrate -map_metadata 0 -map 0:a -map -0:v "`"$outputFile`""
}
