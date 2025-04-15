# Configuração do título da janela
$host.ui.RawUI.WindowTitle = "Setup Inicial"

Write-Host "Configurando winget para aceitar termos automaticamente"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 1

Write-Host "Instalando 7-Zip via winget"
Start-Process winget -ArgumentList "install --id=7zip.7zip -e" -Wait

Write-Host "Instalando VideoLAN via winget"
Start-Process winget -ArgumentList "install --id=VideoLAN.VLC -e" -Wait

Write-Host "Instalando Firefox via winget"
Start-Process winget -ArgumentList "install --id=Mozilla.Firefox -e --accept-source-agreements --accept-package-agreements --locale pt-BR" -Wait

Write-Host "Instalando Adobe Reader via winget"
Start-Process winget -ArgumentList "install --id=Adobe.Acrobat.Reader.64-bit -e --accept-source-agreements --accept-package-agreements --locale pt-BR" -Wait

Write-Host "Instalando uBlock Origin no Microsoft Edge"
$edgeExtensionId = "odfafepnkmbhccpbejgmiehpchacaeak"
Start-Process "microsoft-edge:https://microsoftedge.microsoft.com/addons/detail/$edgeExtensionId"

Write-Host "Instalando uBlock Origin no Firefox"
$firefoxExtensionId = "ublock-origin@mozilla.org"
Start-Process "firefox.exe" -ArgumentList "--install-addon https://addons.mozilla.org/firefox/downloads/latest/$firefoxExtensionId"

Write-Host "Instalando WinRAR via winget"
Start-Process winget -ArgumentList "install --id=RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements" -Wait

Write-Host "Instalando Visual C++ Redistributable Runtimes"
Start-Process winget -ArgumentList "install --id=Microsoft.VCRedist.2015+.x64 -e" -Wait
Start-Process winget -ArgumentList "install --id=Microsoft.VCRedist.2015+.x86 -e" -Wait
Start-Process winget -ArgumentList "install --id=Microsoft.VCRedist.2013.x64 -e" -Wait
Start-Process winget -ArgumentList "install --id=Microsoft.VCRedist.2013.x86 -e" -Wait
Start-Process winget -ArgumentList "install --id=Microsoft.VCRedist.2012.x64 -e" -Wait
Start-Process winget -ArgumentList "install --id=Microsoft.VCRedist.2012.x86 -e" -Wait

Write-Host "Baixando e Instalando Office 2016 PT-BR"
# Criar arquivo de configuração XML
@"
<Configuration>
  <Add OfficeClientEdition="64" Channel="PerpetualVL2016">
    <Product ID="ProPlusRetail">
      <Language ID="pt-br" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
  <Property Name="AUTOACTIVATE" Value="1" />
</Configuration>
"@ | Out-File -FilePath $configPath -Encoding UTF8

$officeUrl = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_16026.20170.exe"
$officePath = "$env:TEMP\ODT.exe"
$configPath = "$env:TEMP\configuration.xml"

# Download Office Deployment Tool
Invoke-WebRequest -Uri $officeUrl -OutFile $officePath

# Extrair ODT
Start-Process -FilePath $officePath -ArgumentList "/extract:$env:TEMP\ODT" -Wait

# Instalar Office
Start-Process -FilePath "$env:TEMP\ODT\setup.exe" -ArgumentList "/configure $configPath" -Wait

# Limpar arquivos temporários
Remove-Item $officePath -Force
Remove-Item $configPath -Force
Remove-Item "$env:TEMP\ODT" -Recurse -Force

Write-Host "Atualizando Windows via winget"
Start-Process winget -ArgumentList "upgrade --all --accept-source-agreements --accept-package-agreements --include-unknown" -Wait

Write-Host "Executando script de ativação"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ScriptWeb = "https://massgrave.dev/get"
$ScriptContent = (Invoke-WebRequest -Uri $ScriptWeb -UseBasicParsing).Content
Invoke-Expression $ScriptContent

Write-Host "------- CONCLUIDO COM SUCESSO! -------"
Read-Host "Pressione Enter para sair" 
