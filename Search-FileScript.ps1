# ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
# ファイル名    Search-FileScript
# 概要          指定フォルダから検索条件に一致するファイルを抽出し、CSVファイルに
#               エクスポートします。
# 作成者        naoya-hintex
# 引数          なし
# 戻り値        なし
# ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊

# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
# グローバル変数
# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

$notExistsFolderMsg = "フォルダが存在しません。フォルダパスをご確認ください。"

$notParmMsg = "検索条件が設定されていません。検索条件を設定のうえ、再実行してください。"

# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
# 設定値
# スクリプトを実行する前に、設定を行ってください。
# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

# 検索フォルダ
$targetFolderPath = ""

# 検索条件
$findConditions = ""

# 出力先フォルダ
$outputFolderPath  = ""

# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
# 関数名        Write-InfoLogs
# 概要          ターミナルに「[実行日時][メッセージ]」を出力します。
# 作成者        naoya-hintex
# 引数          出力メッセージ
# 戻り値        なし
# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
function Write-InfoLogs {
    param (
        [string]$message
    )
    
    # ターミナルに「[実行日時][メッセージ]」を出力
    Write-Host "[$(Get-Date -Format 'yyyy/MM/dd HH:mm:ss')] $message"
}

# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
# 関数名        Check-FolderExists
# 概要          引数のフォルダが存在するかチェックします。
# 作成者        naoya-hintex
# 引数          チェック対象のフォルダパス
# 引数          チェック対象のフォルダ名
# 戻り値        True：フォルダが存在する、False：フォルダが存在しない
# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
function Check-FolderExists {
    param (
        [string]$checkFolderPath
    )

    # チェック対象のフォルダパスがブランクの場合、Falseを返却
    if ($checkFolderPath -eq "") {
        return $false
    }

    # チェック対象のフォルダパスが存在しない場合、Falseを返却
    if ((Test-Path $checkFolderPath) -eq $false) {
        return $false
    }
    
    # フォルダパスに問題ないと判断し、Trueを返却
    return $true

}

# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
# メイン処理
# ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

Write-InfoLogs -message "スクリプトの実行を開始します。"

# スクリプト実行日
$executeDate = Get-Date -Format 'yyyyMMdd'

# 出力ファイル名
$outputFileName = $executeDate + '_出力結果.csv'

# ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
# 設定値のチェック
# ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

# 検索フォルダが存在しない場合、スクリプトの実行を終了する
if ((Check-FolderExists -checkFolderPath $targetFolderPath) -eq $false) {
    Write-InfoLogs -message ("検索" + $notExistsFolderMsg)
    return
}

# 出力先フォルダが存在しない場合、スクリプトの実行を終了する
if ((Check-FolderExists -checkFolderPath $outputFolderPath) -eq $false) {
    Write-InfoLogs -message ("出力先" + $notExistsFolderMsg)
    return
}

# 検索条件がブランクの場合、スクリプトの実行を終了する
if ($findConditions -eq "") {
    Write-InfoLogs -message $notParmMsg
    return
}

Write-InfoLogs ("設定値のチェックが完了しました。")

# ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
# ファイル検索の実行とCSVファイルへのエクスポート
# ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

Write-InfoLogs ("ファイル検索の実行とCSVファイルへのエクスポートを開始します。")

Get-ChildItem -Path $targetFolderPath -Recurse -Filter $findConditions -File |
Select-Object Name, FullName, LastWriteTime |
Export-Csv -Path(Join-Path $outputFolderPath -ChildPath $outputFileName) -NoTypeInformation -Encoding UTF8BOM

Write-InfoLogs ("スクリプトの実行を終了しました。")
