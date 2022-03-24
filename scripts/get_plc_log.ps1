$path = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $path

$datetime = (get-date).ToString('yyyyMMdd_HHmmss')
$log_dir = 'log' + $datetime
new-item -itemtype 'directory' -name $log_dir

$plc_ip_address = '192.168.1.201'

$get_dir_path_cmd =
"open $plc_ip_address
dfk
dfk
mls 2:\LOGGING\data mls_info.txt
bye
"
$get_dir_name_cmd | Out-File get_dir_path_cmd.txt -Encoding UTF8

try {
    ftp -i -s:get_folder_name_cmd.txt > $null
    if (-not $?) {
        throw 'FTP failed'
    }

    $target_dir_path = @()
    $input_data = (Get-Content mls_info.txt) -as [string[]]
    foreach ($dir_path in $input_data) {
        If ($dir_path.StartsWith('2:\LOGGING\data\20')) {
            $target_dir_path += $dir_path + '\*.CSV'
        }
    }

    foreach ($dir_path in $target_dir_path) {
        $get_log_file_cmd = 
        "open $plc_ip_address
        dfk
        dfk
        mget $dir_path
        bye
        "

        $get_log_file_cmd | Out-File get_log_file_cmd.txt -Encoding UTF-8

        Set-Location $path/$log_dir
        ftp -i -s:get_logfile_cmd.txt > $null
	if (-not $?) {
	    throw 'FTP failed'
        }

        Set-Location $path
    }
catch {
    Set-Location $path
    $error_log_file = 'error_log' + $datetime + '.txt'
    new-item -itemtype 'file' -name $error_log_file
    Write-Output $_.Exception.Message | Add-Content $error_log_file
}

