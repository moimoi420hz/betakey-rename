ほぼコメントに記載していますが念のため雑に解説します

@PowerShell -NoProfile -ExecutionPolicy Bypass "&([ScriptBlock]::Create((cat \"%~f0\" | ?{$_.ReadCount -gt 1}) -join \"`n\"))" %*  & goto:eof

@PowerShell 
  WindowsPowerShellを起動
オプション内容
  -NoProfile: ユーザーのPowerShellプロファイルを読み込まない。
  -ExecutionPolicy Bypass: スクリプト実行ポリシーをバイパス。
  "&([ScriptBlock]::Create((cat \"%~f0\" | ?{$_.ReadCount -gt 1}) -join \"`n\"))" %*
    PowerShellスクリプトブロックを作成し、そのスクリプトブロックを実行します。
    cat \"%~f0\"
      現在のバッチファイルの内容を読み取ります。%~f0はバッチファイル自身のフルパスを示します。
    ?{$_.ReadCount -gt 1}
      読み取った内容から、読み取った行数が1より大きいものをフィルタ。
    -join \"n"`
      フィルタリングされた内容を改行で結合。
    [ScriptBlock]::Create(...)
      結合した内容をスクリプトブロックとして作成。
    %*
      バッチファイルに渡されたすべての引数をPowerShellスクリプトに渡します。
    & goto:eof
      バッチファイルの終了。

# ファイルパス指定のためにユーザー名を取得
$userName = [System.Environment]::UserName

# ファイルパスを設定
$filePath = "C:\Users\$userName\AppData\Roaming\XIVLauncher\dalamudConfig.json"

# dalamudConfig.jsonの内容を読み込む
$jsonContent = Get-Content -Path $filePath -Raw | ConvertFrom-Json

# 処理の内容と確認
$title = 'Beta-Keyへの書き換え'
$message = "ファイルパス: ${filePath}`n上記のConfigを書き換えます。よろしいですか？"
$cdType = 'System.Management.Automation.Host.ChoiceDescription'
$yes = New-Object $cdType "&Yes", "${title}を実行します"
$no  = New-Object $cdType "&No",  "${title}を中止します"

# PromptForChoiceによる処理

$input = $host.ui.PromptForChoice($title, $message, @($yes, $no), 0) 

switch ($input)
{
    0 {
	# Yesを選択
	# 値を変更
	$jsonContent.DalamudBetaKey = "burrito"
	$jsonContent.DalamudBetaKind = "stg"

	# 変更した内容をファイルに書き込む
	$jsonContent | ConvertTo-Json -Depth 100 | Set-Content -Path $filePath

	# 結果を表示
	Write-Output "DalamudBetaKey:`"$($jsonContent.DalamudBetaKey)`""
	Write-Output "DalamudBetaKind:`"$($jsonContent.DalamudBetaKind)`""
	Write-Output "処理が完了しました。任意のキーを押して終了します..."
	[void][System.Console]::ReadKey($true)
	}
    1 {
	# Noを選択
	Write-Output "処理を中止しました。任意のキーを押して終了します..."
	[void][System.Console]::ReadKey($true)
	}
}

