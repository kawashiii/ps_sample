$path = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $path

$datetime = (Get-Date).ToString('yyyyMMdd_HHmmss')
$log_file = 'script_log' + $datetime + '.log'
New-Item -ItemType 'file' -Name $log_file

$sleeping_time = 30
Write-Host "Waiting for PLC log saved ($sleeping_time seconds)"
Start-Sleep -Seconds $sleeping_time >> $log_file

$log_dir = 'log' + $datetime
New-Item -ItemType 'directory' -Name $log_dir >> $log_file

$plc_ip_address = '192.168.3.39'

$get_dir_path_cmd = "open $plc_ip_address`n"
$get_dir_path_cmd += "dfk`n"
$get_dir_path_cmd += "dfk`n"
$get_dir_path_cmd += "mls 2:\LOGGING\data mls_info.txt`n"
$get_dir_path_cmd += "bye`n"

$get_dir_path_cmd | Out-File get_dir_path_cmd.txt -Encoding UTF8 >> $log_file


ftp -i -s:get_dir_path_cmd.txt >> $log_file

$target_dir_path = @()
$input_data = (Get-Content mls_info.txt) -as [string[]]
foreach ($dir_path in $input_data) {
    If ($dir_path.StartsWith('2:\LOGGING\data\20')) {
        $target_dir_path += $dir_path + '\*.CSV'
    }
}

foreach ($dir_path in $target_dir_path) {
    $get_log_file_cmd = "open $plc_ip_address`n"
    $get_log_file_cmd += "dfk`n"
    $get_log_file_cmd += "dfk`n"
    $get_log_file_cmd += "mget $dir_path`n"
    $get_log_file_cmd += "bye`n"

    $get_log_file_cmd | Out-File get_log_file_cmd.txt -Encoding UTF8

    Set-Location $path/$log_dir
    ftp -i -s:$path/get_log_file_cmd.txt >> $path/$log_file

    Set-Location $path >> $path/$log_file
}


