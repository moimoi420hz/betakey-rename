@PowerShell -NoProfile -ExecutionPolicy Bypass "&([ScriptBlock]::Create((cat \"%~f0\" | ?{$_.ReadCount -gt 1}) -join \"`n\"))" %*  & goto:eof
# 2�s�ڈȍ~��PowerShell�X�N���v�g���L��
# ���[�U�[�����擾
$userName = [System.Environment]::UserName

# �t�@�C���p�X��ݒ�
$filePath = "C:\Users\$userName\AppData\Roaming\XIVLauncher\dalamudConfig.json"

# JSON�t�@�C���̓��e��ǂݍ���
$jsonContent = Get-Content -Path $filePath -Raw | ConvertFrom-Json

# �����̓��e�Ɗm�F
$title = 'Beta-Key�ւ̏�������'
$message = "�t�@�C���p�X: ${filePath}`n��L��Config�����������܂��B��낵���ł����H"
$cdType = 'System.Management.Automation.Host.ChoiceDescription'
$yes = New-Object $cdType "&Yes", "${title}�����s���܂�"
$no  = New-Object $cdType "&No",  "${title}�𒆎~���܂�"

# PromptForChoice�ɂ�鏈��

$input = $host.ui.PromptForChoice($title, $message, @($yes, $no), 0) 

switch ($input)
{
    0 {
	# Yes��I��
	# �l��ύX
	$jsonContent.DalamudBetaKey = "burrito"
	$jsonContent.DalamudBetaKind = "stg"

	# �ύX�������e���t�@�C���ɏ�������
	$jsonContent | ConvertTo-Json -Depth 100 | Set-Content -Path $filePath

	# ���ʂ�\��
	Write-Output "DalamudBetaKey:`"$($jsonContent.DalamudBetaKey)`""
	Write-Output "DalamudBetaKind:`"$($jsonContent.DalamudBetaKind)`""
	Write-Output "�������������܂����B�C�ӂ̃L�[�������ďI�����܂�..."
	[void][System.Console]::ReadKey($true)
	}
    1 {
	# No��I��
	Write-Output "�����𒆎~���܂����B�C�ӂ̃L�[�������ďI�����܂�..."
	[void][System.Console]::ReadKey($true)
	}
}

