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
# Criar um arquivo XML de configuração básico
$configXML = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="Current">
    <Product ID="O365ProPlusRetail">
      <Language ID="pt-br" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
"@

$configXML | Out-File -FilePath "$env:TEMP\configuration.xml" -Encoding UTF8

# Baixar e instalar
$url = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=pt-br&version=O16GA"
$output = "$env:TEMP\OfficeSetup.exe"

Invoke-WebRequest -Uri $url -OutFile $output
Start-Process -FilePath $output -ArgumentList "/configure", "$env:TEMP\configuration.xml" -Wait

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
