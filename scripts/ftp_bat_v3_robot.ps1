
#ラズパイから取得するデータの日付をセット(1日前で固定)
$nowtimestamp = (get-date).adddays(-1).ToString("yyMMdd")

#取得データ保存先ディレクトリ(ローカル)を指定
$Getdir_endurance = "C:\Sensor\data\XYendurancerobot"
$Getdir_rack = "C:\Sensor\data\XYrackrobot"
$Getdir_ball = "C:\Sensor\data\XYballrobot"

#スクリプト置き場所(バッチファイルを置く)
#$ScriptDir = "C:\Sensor\scripts"

#各基板のデータ格納元をセット
$Connect_dir = @("/dat/daifuku/datfiles/status/$nowtimestamp", "/dat/daifuku/datfiles/audio/$nowtimestamp")

#センサ種別を配列に格納
$Connect_name = @("vibration1", "sound1")

#ラズパイから削除するデータの日付をセット(4日前で固定)
$PyRmDate = (get-date).adddays(-4).ToString("yyMMdd")
#$PyRmDateS = $PyRmDate.Substring(2,6)
#ラズパイから削除するデータの格納元をセット
$rmDatDir = @("/dat/daifuku/datfiles/status/$PyRmDate", "/dat/daifuku/datfiles/audio/$PyRmDate")

#PCから削除するデータの日付をセット(4日前で固定)
$PcRmDate = (get-date).adddays(-4).ToString("yyMMdd")
$PcRmDateZip = (get-date).adddays(-4).ToString("yyMMdd.zip")

#2つのラズパイからデータ吸上げて変換


#**************************************古いデータの削除**************************************#
##################################### 耐久機 vibration1 ######################################
$txtrm = 
"open 172.16.142.239
dfk
dfk
cd $($rmDatDir[0])
mdel *.dat
cd ..
rmdir $($PyRmDate)
bye"

#ファイル削除用のバッチファイルを文字コードUTF8で出力
$txtrm | Out-File data_del.txt -Encoding UTF8

#sftpでファイル削除用のバッチファイルを実行
ftp -i -s:data_del.txt

##################################### 耐久機 sound1 ######################################
$txtrm = 
"open 172.16.142.240
dfk
dfk
cd $($rmDatDir[1])
mdel *.dat
cd ..
rmdir $($PyRmDate)
bye"

#ファイル削除用のバッチファイルを文字コードUTF8で出力
$txtrm | Out-File data_del.txt -Encoding UTF8

#sftpでファイル削除用のバッチファイルを実行
ftp -i -s:data_del.txt

##################################### 量産機 vibration1 ######################################
$txtrm = 
"open 172.16.142.231
dfk
dfk
cd $($rmDatDir[0])
mdel *.dat
cd ..
rmdir $($PyRmDate)
bye"

#ファイル削除用のバッチファイルを文字コードUTF8で出力
$txtrm | Out-File data_del.txt -Encoding UTF8

#sftpでファイル削除用のバッチファイルを実行
ftp -i -s:data_del.txt

##################################### 量産機 sound1 ######################################
$txtrm = 
"open 172.16.142.232
dfk
dfk
cd $($rmDatDir[1])
mdel *.dat
cd ..
rmdir $($PyRmDate)
bye"

#ファイル削除用のバッチファイルを文字コードUTF8で出力
$txtrm | Out-File data_del.txt -Encoding UTF8

#sftpでファイル削除用のバッチファイルを実行
ftp -i -s:data_del.txt

##################################### ボールねじ vibration1 ######################################
$txtrm = 
"open 172.16.142.10
dfk
dfk
cd $($rmDatDir[0])
mdel *.dat
cd ..
rmdir $($PyRmDate)
bye"

#ファイル削除用のバッチファイルを文字コードUTF8で出力
$txtrm | Out-File data_del.txt -Encoding UTF8

#sftpでファイル削除用のバッチファイルを実行
ftp -i -s:data_del.txt

##################################### ボールねじ sound1 ######################################
$txtrm = 
"open 172.16.142.11
dfk
dfk
cd $($rmDatDir[1])
mdel *.dat
cd ..
rmdir $($PyRmDate)
bye"

#ファイル削除用のバッチファイルを文字コードUTF8で出力
$txtrm | Out-File data_del.txt -Encoding UTF8

#sftpでファイル削除用のバッチファイルを実行
ftp -i -s:data_del.txt

##################################### 耐久機 vibration1 ######################################
#lawデータ保存先ディレクトリ(ローカル)に日付フォルダが無ければ作成する
cd $Getdir_endurance\Vibration\Board1
if (-not (test-path ./$nowtimestamp)){
    new-item -itemtype "directory" -name $nowtimestamp
}else{
    Write-Host $f directory [ $nowtimestamp ] is already exists!
}
#cd $nowtimestamp

#ftp接続のバッチ実行用のテキストファイルの中身を記述
$txt1 = 
"open 172.16.142.239
dfk
dfk
cd $($Connect_dir[0])
lcd $Getdir_endurance/Vibration/Board1/$nowtimestamp
binary
mget *.dat
bye"

$txt1 | Out-File data_get.txt -Encoding UTF8

#FTPでデータ取得
ftp -i -s:data_get.txt

#ファイル圧縮
Compress-Archive -Path ($nowtimestamp) -CompressionLevel Optimal -DestinationPath ($nowtimestamp)

#FTPでNASに転送
$txt2 = 
"open 172.16.142.77
anonymous
admin
cd /sataraid1/tap_data/XYendurancerobot/Sensor/Vibration/Board1
lcd $Getdir_endurance/Vibration/Board1
binary
put $nowtimestamp.zip
bye"

$txt2 | Out-File data_put.txt -Encoding UTF8

ftp -i -s:data_put.txt

##################################### 耐久機 sound1 ######################################
#lawデータ保存先ディレクトリ(ローカル)に日付フォルダが無ければ作成する
cd $Getdir_endurance\Sound\Board1
if (-not (test-path ./$nowtimestamp)){
    new-item -itemtype "directory" -name $nowtimestamp
}else{
    Write-Host $f directory [ $nowtimestamp ] is already exists!
}
#cd $nowtimestamp

#ftp接続のバッチ実行用のテキストファイルの中身を記述
$txt1 = 
"open 172.16.142.240
dfk
dfk
cd $($Connect_dir[1])
lcd $Getdir_endurance/Sound/Board1/$nowtimestamp
binary
mget *.dat
bye"

$txt1 | Out-File data_get.txt -Encoding UTF8

#FTPでデータ取得
ftp -i -s:data_get.txt

#ファイル圧縮
Compress-Archive -Path ($nowtimestamp) -CompressionLevel Optimal -DestinationPath ($nowtimestamp)

#FTPでNASに転送
$txt2 = 
"open 172.16.142.77
anonymous
admin
cd /sataraid1/tap_data/XYendurancerobot/Sensor/Sound/Board1
lcd $Getdir_endurance/Sound/Board1
binary
put $nowtimestamp.zip
bye"

$txt2 | Out-File data_put.txt -Encoding UTF8

ftp -i -s:data_put.txt

##################################### 量産機 vibration1 ######################################
#lawデータ保存先ディレクトリ(ローカル)に日付フォルダが無ければ作成する
cd $Getdir_rack\Vibration\Board1
if (-not (test-path ./$nowtimestamp)){
    new-item -itemtype "directory" -name $nowtimestamp
}else{
    Write-Host $f directory [ $nowtimestamp ] is already exists!
}
#cd $nowtimestamp

#ftp接続のバッチ実行用のテキストファイルの中身を記述
$txt1 = 
"open 172.16.142.231
dfk
dfk
cd $($Connect_dir[0])
lcd $Getdir_rack/Vibration/Board1/$nowtimestamp
binary
mget *.dat
bye"

$txt1 | Out-File data_get.txt -Encoding UTF8

#FTPでデータ取得
ftp -i -s:data_get.txt

#ファイル圧縮
Compress-Archive -Path ($nowtimestamp) -CompressionLevel Optimal -DestinationPath ($nowtimestamp)

#FTPでNASに転送
$txt2 = 
"open 172.16.142.77
anonymous
admin
cd /sataraid1/tap_data/XYrackrobot/Sensor/Vibration/Board1
lcd $Getdir_rack/Vibration/Board1
binary
put $nowtimestamp.zip
bye"

$txt2 | Out-File data_put.txt -Encoding UTF8

ftp -i -s:data_put.txt

##################################### 量産機 sound1 ######################################
#lawデータ保存先ディレクトリ(ローカル)に日付フォルダが無ければ作成する
cd $Getdir_rack\Sound\Board1
if (-not (test-path ./$nowtimestamp)){
    new-item -itemtype "directory" -name $nowtimestamp
}else{
    Write-Host $f directory [ $nowtimestamp ] is already exists!
}
#cd $nowtimestamp

#ftp接続のバッチ実行用のテキストファイルの中身を記述
$txt1 = 
"open 172.16.142.232
dfk
dfk
cd $($Connect_dir[1])
lcd $Getdir_rack/Sound/Board1/$nowtimestamp
binary
mget *.dat
bye"

$txt1 | Out-File data_get.txt -Encoding UTF8

#FTPでデータ取得
ftp -i -s:data_get.txt

#ファイル圧縮
Compress-Archive -Path ($nowtimestamp) -CompressionLevel Optimal -DestinationPath ($nowtimestamp)

#FTPでNASに転送
$txt2 = 
"open 172.16.142.77
anonymous
admin
cd /sataraid1/tap_data/XYrackrobot/Sensor/Sound/Board1
lcd $Getdir_rack/Sound/Board1
binary
put $nowtimestamp.zip
bye"

$txt2 | Out-File data_put.txt -Encoding UTF8

ftp -i -s:data_put.txt

##################################### ボールねじ vibration1 ######################################
#lawデータ保存先ディレクトリ(ローカル)に日付フォルダが無ければ作成する
cd $Getdir_ball\Vibration\Board1
if (-not (test-path ./$nowtimestamp)){
    new-item -itemtype "directory" -name $nowtimestamp
}else{
    Write-Host $f directory [ $nowtimestamp ] is already exists!
}
#cd $nowtimestamp

#ftp接続のバッチ実行用のテキストファイルの中身を記述
$txt1 = 
"open 172.16.142.10
dfk
dfk
cd $($Connect_dir[0])
lcd $Getdir_ball/Vibration/Board1/$nowtimestamp
binary
mget *.dat
bye"

$txt1 | Out-File data_get.txt -Encoding UTF8

#FTPでデータ取得
ftp -i -s:data_get.txt

#ファイル圧縮
Compress-Archive -Path ($nowtimestamp) -CompressionLevel Optimal -DestinationPath ($nowtimestamp)

#FTPでNASに転送
$txt2 = 
"open 172.16.142.77
anonymous
admin
cd /sataraid1/tap_data/XYballrobot/Sensor/Vibration/Board1
lcd $Getdir_ball/Vibration/Board1
binary
put $nowtimestamp.zip
bye"

$txt2 | Out-File data_put.txt -Encoding UTF8

ftp -i -s:data_put.txt

##################################### ボールねじ sound1 ######################################
#lawデータ保存先ディレクトリ(ローカル)に日付フォルダが無ければ作成する
cd $Getdir_ball\Sound\Board1
if (-not (test-path ./$nowtimestamp)){
    new-item -itemtype "directory" -name $nowtimestamp
}else{
    Write-Host $f directory [ $nowtimestamp ] is already exists!
}
#cd $nowtimestamp

#ftp接続のバッチ実行用のテキストファイルの中身を記述
$txt1 = 
"open 172.16.142.11
dfk
dfk
cd $($Connect_dir[1])
lcd $Getdir_ball/Sound/Board1/$nowtimestamp
binary
mget *.dat
bye"

$txt1 | Out-File data_get.txt -Encoding UTF8

#FTPでデータ取得
ftp -i -s:data_get.txt

#ファイル圧縮
Compress-Archive -Path ($nowtimestamp) -CompressionLevel Optimal -DestinationPath ($nowtimestamp)

#FTPでNASに転送
$txt2 = 
"open 172.16.142.77
anonymous
admin
cd /sataraid1/tap_data/XYballrobot/Sensor/Sound/Board1
lcd $Getdir_ball/Sound/Board1
binary
put $nowtimestamp.zip
bye"

$txt2 | Out-File data_put.txt -Encoding UTF8

ftp -i -s:data_put.txt

#********PC********#
#PCから5日前のデータを削除（生データ・圧縮ファイル）
Set-Location -Path $Getdir_endurance\Vibration\Board1
if( Test-Path $PcRmDate)
{
    Remove-Item $PcRmDate -Recurse
}
if( Test-Path $PcRmDateZip)
{
    Remove-Item $PcRmDateZip -Recurse
}

Set-Location -Path $Getdir_endurance\Sound\Board1
if( Test-Path $PcRmDate)
{
    Remove-Item $PcRmDate -Recurse
}
if( Test-Path $PcRmDateZip)
{
    Remove-Item $PcRmDateZip -Recurse
}

Set-Location -Path $Getdir_rack\Vibration\Board1
if( Test-Path $PcRmDate)
{
    Remove-Item $PcRmDate -Recurse
}
if( Test-Path $PcRmDateZip)
{
    Remove-Item $PcRmDateZip -Recurse
}

Set-Location -Path $Getdir_rack\Sound\Board1
if( Test-Path $PcRmDate)
{
    Remove-Item $PcRmDate -Recurse
}
if( Test-Path $PcRmDateZip)
{
    Remove-Item $PcRmDateZip -Recurse
}

Set-Location -Path $Getdir_ball\Vibration\Board1
if( Test-Path $PcRmDate)
{
    Remove-Item $PcRmDate -Recurse
}
if( Test-Path $PcRmDateZip)
{
    Remove-Item $PcRmDateZip -Recurse
}

Set-Location -Path $Getdir_ball\Sound\Board1
if( Test-Path $PcRmDate)
{
    Remove-Item $PcRmDate -Recurse
}
if( Test-Path $PcRmDateZip)
{
    Remove-Item $PcRmDateZip -Recurse
}
