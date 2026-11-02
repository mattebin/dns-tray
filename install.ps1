# DNS Tray installer. Blocks ads, trackers and malware for the whole PC, controlled from one tray icon.
# It installs AdGuard Home with the lists Mullvad used, and Quad9 for the lookups. Run it again to repair.

$ScriptUrl = 'https://raw.githubusercontent.com/mattebin/dns-tray/main/install.ps1'
$Root = "$env:ProgramFiles\DNS Tray"
$AghDir = "$Root\AdGuardHome"
$Tray = "$Root\dns-tray.ps1"
$Api = 'http://127.0.0.1:3053/control'

# Ask for admin rights if we do not have them
$me = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $me.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  if ($PSCommandPath) { $run = "-File `"$PSCommandPath`"" } else { $run = "-Command `"irm $ScriptUrl | iex`"" }
  Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass $run"
  return
}

$config = @'
http:
  pprof:
    port: 6060
    enabled: false
  doh:
    routes:
      - GET /dns-query
      - POST /dns-query
      - GET /dns-query/{ClientID}
      - POST /dns-query/{ClientID}
    insecure_enabled: false
  address: 127.0.0.1:3053
  session_ttl: 30d
users: []
auth_attempts: 5
block_auth_min: 15
http_proxy: ""
language: ""
theme: auto
dns:
  bind_hosts:
    - 127.0.0.1
    - ::1
  port: 53
  anonymize_client_ip: false
  ratelimit: 0
  ratelimit_subnet_len_ipv4: 24
  ratelimit_subnet_len_ipv6: 56
  ratelimit_whitelist: []
  refuse_any: true
  upstream_dns:
    - https://dns.quad9.net/dns-query
  upstream_dns_file: ""
  bootstrap_dns:
    - 9.9.9.9
    - 149.112.112.112
    - 2620:fe::fe
    - 2620:fe::9
  fallback_dns: []
  upstream_mode: load_balance
  fastest_timeout: 1s
  allowed_clients: []
  disallowed_clients: []
  blocked_hosts:
    - version.bind
    - id.server
    - hostname.bind
  trusted_proxies:
    - 127.0.0.0/8
    - ::1/128
  cache_enabled: true
  cache_size: 16777216
  cache_ttl_min: 0
  cache_ttl_max: 0
  cache_optimistic: true
  cache_optimistic_answer_ttl: 30s
  cache_optimistic_max_age: 12h
  bogus_nxdomain: []
  aaaa_disabled: false
  enable_dnssec: true
  edns_client_subnet:
    custom_ip: ""
    enabled: false
    use_custom: false
  max_goroutines: 300
  handle_ddr: true
  ipset: []
  ipset_file: ""
  bootstrap_prefer_ipv6: false
  upstream_timeout: 10s
  private_networks: []
  use_private_ptr_resolvers: false
  local_ptr_upstreams: []
  use_dns64: false
  dns64_prefixes: []
  serve_http3: false
  use_http3_upstreams: false
  serve_plain_dns: true
  hostsfile_enabled: true
  pending_requests:
    enabled: true
tls:
  enabled: false
  server_name: ""
  force_https: false
  port_https: 443
  port_dns_over_tls: 853
  port_dns_over_quic: 853
  port_dnscrypt: 0
  dnscrypt_config_file: ""
  certificate_chain: ""
  private_key: ""
  certificate_path: ""
  private_key_path: ""
  strict_sni_check: false
querylog:
  dir_path: ""
  ignored: []
  interval: 24h
  size_memory: 1000
  enabled: true
  ignored_enabled: false
  file_enabled: true
statistics:
  dir_path: ""
  ignored: []
  interval: 1d
  enabled: true
  ignored_enabled: false
filters:
  - enabled: true
    url: https://small.oisd.nl/
    name: oisd small
    id: 1
  - enabled: true
    url: https://raw.githubusercontent.com/lassekongo83/Frellwits-filter-lists/master/Frellwits-Swedish-Hosts-File.txt
    name: Frellwits Swedish hosts
    id: 2
  - enabled: true
    url: https://v.firebog.net/hosts/AdguardDNS.txt
    name: AdguardDNS (firebog)
    id: 3
  - enabled: true
    url: https://adguardteam.github.io/AdguardFilters/MobileFilter/sections/adservers.txt
    name: AdGuard mobile adservers
    id: 4
  - enabled: true
    url: https://v.firebog.net/hosts/Easyprivacy.txt
    name: EasyPrivacy (firebog)
    id: 5
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.mini.txt
    name: Hagezi threat intelligence mini
    id: 6
  - enabled: true
    url: https://raw.githubusercontent.com/mullvad/dns-blocklists/main/files/adblock
    name: Mullvad own ads
    id: 7
  - enabled: true
    url: https://raw.githubusercontent.com/mullvad/dns-blocklists/main/files/tracker
    name: Mullvad own trackers
    id: 8
  - enabled: true
    url: https://raw.githubusercontent.com/mullvad/dns-blocklists/main/files/malware
    name: Mullvad own malware
    id: 9
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/popupads.txt
    name: Hagezi popup ads
    id: 11
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/native.amazon.txt
    name: Hagezi Amazon trackers
    id: 12
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/native.apple.txt
    name: Hagezi Apple trackers
    id: 13
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/native.huawei.txt
    name: Hagezi Huawei trackers
    id: 14
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/native.winoffice.txt
    name: Hagezi Windows and Office trackers
    id: 15
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/native.tiktok.extended.txt
    name: Hagezi TikTok trackers
    id: 16
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/native.lgwebos.txt
    name: Hagezi LG TV trackers
    id: 17
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/native.vivo.txt
    name: Hagezi Vivo trackers
    id: 18
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/native.oppo-realme.txt
    name: Hagezi Oppo and Realme trackers
    id: 19
  - enabled: true
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/native.xiaomi.txt
    name: Hagezi Xiaomi trackers
    id: 20
  - enabled: false
    url: https://nsfw.oisd.nl/
    name: Adult sites (oisd)
    id: 31
  - enabled: false
    url: https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/gambling.txt
    name: Gambling sites (Hagezi)
    id: 32
  - enabled: false
    url: https://raw.githubusercontent.com/mullvad/dns-blocklists/main/files/social
    name: Social media (Mullvad)
    id: 33
whitelist_filters: []
user_rules:
  - '! Never blocked in Mullvad either'
  - '@@||mullvad.net^'
  - '@@||hyros.com^'
  - '@@||go.pardot.com^'
dhcp:
  enabled: false
  interface_name: ""
  local_domain_name: lan
  dhcpv4:
    gateway_ip: ""
    subnet_mask: ""
    range_start: ""
    range_end: ""
    lease_duration: 86400
    icmp_timeout_msec: 1000
    options: []
  dhcpv6:
    range_start: ""
    lease_duration: 86400
    ra_slaac_only: false
    ra_allow_slaac: false
filtering:
  blocking_ipv4: ""
  blocking_ipv6: ""
  blocked_services:
    schedule:
      time_zone: Local
    ids: []
  protection_disabled_until: null
  safe_search:
    enabled: false
    bing: true
    duckduckgo: true
    ecosia: true
    google: true
    pixabay: true
    yandex: true
    youtube: true
  blocking_mode: nxdomain
  parental_block_host: family-block.dns.adguard.com
  safebrowsing_block_host: standard-block.dns.adguard.com
  rewrites: []
  safe_fs_patterns: []
  max_http_size: 256MB
  safebrowsing_cache_size: 1048576
  safesearch_cache_size: 1048576
  parental_cache_size: 1048576
  cache_time: 30
  filters_update_interval: 12
  blocked_response_ttl: 10
  filtering_enabled: true
  rewrites_enabled: true
  parental_enabled: false
  safebrowsing_enabled: false
  protection_enabled: true
clients:
  runtime_sources:
    whois: false
    arp: true
    rdns: true
    dhcp: false
    hosts: true
  persistent: []
log:
  enabled: true
  file: ""
  max_backups: 0
  max_size: 100
  max_age: 3
  compress: false
  local_time: false
  verbose: false
os:
  group: ""
  user: ""
  rlimit_nofile: 0
schema_version: 34
'@

$trayScript = @'
# DNS Tray. Left click turns it on or off. Right click for everything else.
param([ValidateSet('Tray', 'Full', 'Live', 'Off', 'Uninstall')][string]$Action = 'Tray')

$Dir = $PSScriptRoot
$StateFile = "$Dir\state.json"
$LogFile = "$Dir\dns-tray.log"
$Api = 'http://127.0.0.1:3053/control'
$Service = 'AdGuardHome'
$Lists = 'https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock'
$BrowserPolicies = 'HKLM:\SOFTWARE\Policies\Google\Chrome', 'HKLM:\SOFTWARE\Policies\Microsoft\Edge', 'HKLM:\SOFTWARE\Policies\BraveSoftware\Brave'

# On only in "All lists". Mullvad published these, but its servers did not use them.
$FullOnly = 'popupads', 'native.amazon', 'native.apple', 'native.huawei', 'native.winoffice', 'native.tiktok.extended', 'native.lgwebos', 'native.vivo', 'native.oppo-realme', 'native.xiaomi' | ForEach-Object { "$Lists/$_.txt" }
$Extras = [ordered]@{
  adult    = 'https://nsfw.oisd.nl/'
  gambling = "$Lists/gambling.txt"
  social   = 'https://raw.githubusercontent.com/mullvad/dns-blocklists/main/files/social'
}
$ExtraNames = @{ adult = 'Adult sites'; gambling = 'Gambling sites'; social = 'Social media' }
$ModeNames = @{ full = 'All lists'; live = 'Same as Mullvad' }

function Log($text) {
  Add-Content -LiteralPath $LogFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $text" -Encoding UTF8
}

function Read-State {
  $state = $null
  if (Test-Path -LiteralPath $StateFile) {
    try { $state = Get-Content -LiteralPath $StateFile -Raw | ConvertFrom-Json } catch { Log "state unreadable: $_" }
  }
  if (-not $state) {
    $state = [pscustomobject]@{
      enabled = $false
      autoOff = $false
      mode    = 'full'
      saved   = [pscustomobject]@{}
      extras  = [pscustomobject]@{ adult = $false; gambling = $false; social = $false }
    }
  }
  $state
}

function Write-State($state) {
  $state | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $StateFile -Encoding UTF8
}

function Get-Adapters {
  @(Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' -and -not $_.Virtual })
}

function Get-SavedDns($guid, $service) {
  (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\$service\Parameters\Interfaces\$guid" -Name NameServer -ErrorAction SilentlyContinue).NameServer
}

function Test-Lookup($server) {
  $options = @{ Name = 'quad9.net'; Type = 'A'; DnsOnly = $true; QuickTimeout = $true; ErrorAction = 'Stop' }
  if ($server) { $options.Server = $server }
  try { [bool](Resolve-DnsName @options | Where-Object { $_.Type -eq 'A' }) } catch { $false }
}

function Invoke-Filter($path, $body, $timeout = 30) {
  if ($null -ne $body) {
    Invoke-RestMethod "$Api/$path" -Method Post -Body ($body | ConvertTo-Json -Depth 5) -ContentType 'application/json' -TimeoutSec $timeout
  } else {
    Invoke-RestMethod "$Api/$path" -TimeoutSec $timeout
  }
}

function Start-Filter {
  if ((Get-Service $Service -ErrorAction Stop).Status -ne 'Running') { Start-Service $Service -ErrorAction Stop }
  foreach ($i in 1..20) {
    try { if ((Invoke-Filter 'status' $null 3).running) { return } } catch {}
    Start-Sleep 1
  }
  throw 'AdGuard Home did not answer'
}

function Set-Lists($state) {
  foreach ($list in (Invoke-Filter 'filtering/status').filters) {
    $want = $true
    if ($FullOnly -contains $list.url) { $want = $state.mode -eq 'full' }
    foreach ($key in $Extras.Keys) {
      if ($Extras[$key] -eq $list.url) { $want = [bool]$state.extras.$key }
    }
    if ([bool]$list.enabled -ne $want) {
      $data = @{ name = $list.name; url = $list.url; enabled = $want }
      [void](Invoke-Filter 'filtering/set_url' @{ url = $list.url; whitelist = $false; data = $data } 120)
    }
  }
  Clear-DnsClientCache
  Log "lists set for mode $($state.mode)"
}

function Set-AdapterOn($adapter, $state) {
  $guid = $adapter.InterfaceGuid
  if (-not ($state.saved.PSObject.Properties.Name -contains $guid)) {
    $old = [pscustomobject]@{ v4 = "$(Get-SavedDns $guid 'Tcpip')"; v6 = "$(Get-SavedDns $guid 'Tcpip6')" }
    $state.saved | Add-Member -NotePropertyName $guid -NotePropertyValue $old
  }
  Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses @('127.0.0.1', '::1') -ErrorAction Stop
}

function Enable-Dns {
  $state = Read-State
  try {
    Start-Filter
    Set-Lists $state
    foreach ($adapter in Get-Adapters) { Set-AdapterOn $adapter $state }
  } catch {
    Log "could not turn on: $_"
    Write-State $state
    Disable-Dns
    return $false
  }
  # A browser's own secure DNS would skip the filter
  foreach ($policy in $BrowserPolicies) {
    if (-not (Test-Path $policy)) { New-Item -Path $policy -Force | Out-Null }
    Set-ItemProperty $policy -Name DnsOverHttpsMode -Value 'off'
  }
  $state.enabled = $true
  $state.autoOff = $false
  Write-State $state
  Clear-DnsClientCache
  foreach ($i in 1..5) {
    Start-Sleep 2
    if (Test-Lookup) {
      Log "on, mode $($state.mode)"
      return $true
    }
  }
  Log 'lookups failed, going back to normal DNS'
  Disable-Dns
  $false
}

function Disable-Dns([bool]$auto = $false) {
  $state = Read-State
  foreach ($item in $state.saved.PSObject.Properties) {
    $adapter = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.InterfaceGuid -eq $item.Name }
    if ($adapter) {
      Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ResetServerAddresses
      $back = "$($item.Value.v4) $($item.Value.v6)" -split '[, ]+' | Where-Object { $_ }
      if ($back) { Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses $back }
    }
  }
  foreach ($policy in $BrowserPolicies) {
    Remove-ItemProperty $policy -Name DnsOverHttpsMode -ErrorAction SilentlyContinue
  }
  $state.enabled = $false
  $state.autoOff = $auto
  $state.saved = [pscustomobject]@{}
  Write-State $state
  Clear-DnsClientCache
  Log "off, automatic: $auto"
}

function Set-Mode($mode) {
  $state = Read-State
  $state.mode = $mode
  Write-State $state
  if ($state.enabled) {
    Set-Lists $state
    return $true
  }
  Enable-Dns
}

# Lists update themselves every 12 hours. This keeps AdGuard Home itself current.
function Update-AdGuard {
  $latest = Invoke-Filter 'version.json' @{ recheck_now = $true } 60
  $current = (Invoke-Filter 'status').version
  if (-not $latest.new_version -or $latest.new_version -eq $current) { return "AdGuard Home $current is up to date" }
  if ($latest.can_autoupdate) {
    [void](Invoke-Filter 'update' @{} 300)
    Log "AdGuard Home updating to $($latest.new_version)"
    return "AdGuard Home is updating to $($latest.new_version)"
  }
  "AdGuard Home $($latest.new_version) is out. Update it from the blocked sites page."
}

function Remove-Everything {
  Start-Sleep 2
  Disable-Dns
  Stop-ScheduledTask -TaskName 'DNS Tray' -ErrorAction SilentlyContinue
  Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" |
    Where-Object { $_.CommandLine -like '*dns-tray.ps1*' -and $_.ProcessId -ne $PID } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
  Unregister-ScheduledTask -TaskName 'DNS Tray' -Confirm:$false -ErrorAction SilentlyContinue
  & "$Dir\AdGuardHome\AdGuardHome.exe" -s uninstall 2>&1 | Out-Null
  Start-Process cmd.exe -WindowStyle Hidden -ArgumentList "/c timeout /t 4 /nobreak >nul & rmdir /s /q `"$Dir`""
}

if ($Action -eq 'Full') { Set-Mode 'full'; return }
if ($Action -eq 'Live') { Set-Mode 'live'; return }
if ($Action -eq 'Off') { Disable-Dns; return }
if ($Action -eq 'Uninstall') { Remove-Everything; return }

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$isFirst = $false
$mutex = New-Object Threading.Mutex($true, 'Global\DnsTray', [ref]$isFirst)
if (-not $isFirst) { return }

function New-TrayIcon($red, $green, $blue) {
  $image = New-Object Drawing.Bitmap 32, 32
  $draw = [Drawing.Graphics]::FromImage($image)
  $draw.SmoothingMode = 'AntiAlias'
  $draw.TextRenderingHint = 'AntiAliasGridFit'
  $draw.FillEllipse((New-Object Drawing.SolidBrush ([Drawing.Color]::FromArgb($red, $green, $blue))), 1, 1, 30, 30)
  $font = New-Object Drawing.Font 'Segoe UI', 18, ([Drawing.FontStyle]::Bold), ([Drawing.GraphicsUnit]::Pixel)
  $center = New-Object Drawing.StringFormat
  $center.Alignment = 'Center'
  $center.LineAlignment = 'Center'
  $draw.DrawString('D', $font, [Drawing.Brushes]::White, (New-Object Drawing.RectangleF 0, 0, 32, 32), $center)
  $draw.Dispose()
  [Drawing.Icon]::FromHandle($image.GetHicon())
}
$iconFull = New-TrayIcon 34 160 84
$iconLive = New-TrayIcon 37 99 235
$iconOff = New-TrayIcon 110 110 110
$iconFailed = New-TrayIcon 217 119 6

$tray = New-Object Windows.Forms.NotifyIcon
$tray.Visible = $true
$menu = New-Object Windows.Forms.ContextMenuStrip
$tray.ContextMenuStrip = $menu
$itemFull = $menu.Items.Add($ModeNames.full)
$itemLive = $menu.Items.Add($ModeNames.live)
$itemOff = $menu.Items.Add('Off')
[void]$menu.Items.Add('-')
$itemAlso = New-Object Windows.Forms.ToolStripMenuItem 'Also block'
[void]$menu.Items.Add($itemAlso)
$itemExtra = @{}
foreach ($key in $Extras.Keys) {
  $itemExtra[$key] = $itemAlso.DropDownItems.Add($ExtraNames[$key])
  $itemExtra[$key].Tag = $key
}
[void]$menu.Items.Add('-')
$itemUpdate = $menu.Items.Add('Update now')
$itemPage = $menu.Items.Add('See what was blocked')
$itemRemove = $menu.Items.Add('Uninstall')

function Update-Tray {
  $state = Read-State
  $itemFull.Checked = $state.enabled -and $state.mode -eq 'full'
  $itemLive.Checked = $state.enabled -and $state.mode -eq 'live'
  $itemOff.Checked = -not $state.enabled -and -not $state.autoOff
  foreach ($key in $Extras.Keys) { $itemExtra[$key].Checked = [bool]$state.extras.$key }
  if ($state.enabled -and $state.mode -eq 'full') {
    $tray.Icon = $iconFull
    $tray.Text = 'DNS Tray is on: all lists'
  } elseif ($state.enabled) {
    $tray.Icon = $iconLive
    $tray.Text = 'DNS Tray is on: same as Mullvad'
  } elseif ($state.autoOff) {
    $tray.Icon = $iconFailed
    $tray.Text = 'DNS Tray failed: normal DNS until it works'
  } else {
    $tray.Icon = $iconOff
    $tray.Text = 'DNS Tray is off'
  }
}

function Show-Note($title, $text, $kind = 'Info') {
  $tray.ShowBalloonTip(3000, $title, $text, $kind)
}

function Use-Mode($mode) {
  try {
    $script:fails = 0
    if (Set-Mode $mode) { Show-Note 'DNS Tray' "$($ModeNames[$mode]) is on. Restart your browser if it was open." }
    else { Show-Note 'DNS Tray' 'It did not work, so your normal DNS is back.' 'Warning' }
  } catch {
    Log "mode error: $_"
    Show-Note 'DNS Tray' "$_" 'Error'
  }
  Update-Tray
}

function Use-Off {
  try {
    $script:fails = 0
    Disable-Dns
    Show-Note 'DNS Tray' 'Off. Your normal DNS is back.'
  } catch {
    Log "off error: $_"
    Show-Note 'DNS Tray' "$_" 'Error'
  }
  Update-Tray
}

$tray.add_MouseClick({
  if ($_.Button -ne [Windows.Forms.MouseButtons]::Left) { return }
  $state = Read-State
  if ($state.enabled -or $state.autoOff) { Use-Off } else { Use-Mode $state.mode }
})
$itemFull.add_Click({ Use-Mode 'full' })
$itemLive.add_Click({ Use-Mode 'live' })
$itemOff.add_Click({ Use-Off })
foreach ($key in $Extras.Keys) {
  $itemExtra[$key].add_Click({
    param($sender, $e)
    try {
      $state = Read-State
      $name = $sender.Tag
      $state.extras.$name = -not [bool]$state.extras.$name
      Write-State $state
      if ($state.enabled) { Set-Lists $state }
    } catch {
      Log "list error: $_"
      Show-Note 'DNS Tray' "$_" 'Error'
    }
    Update-Tray
  })
}
$itemUpdate.add_Click({
  try {
    $result = Invoke-Filter 'filtering/refresh' @{ whitelist = $false } 180
    Show-Note 'DNS Tray' "$($result.updated) lists changed. $(Update-AdGuard)."
  } catch {
    Log "update error: $_"
    Show-Note 'DNS Tray' "$_" 'Error'
  }
})
$itemPage.add_Click({ Start-Process 'http://127.0.0.1:3053' })
$itemRemove.add_Click({
  $answer = [Windows.Forms.MessageBox]::Show('Remove DNS Tray and put your normal DNS back?', 'DNS Tray', 'YesNo')
  if ($answer -eq 'Yes') {
    $tray.Visible = $false
    Start-Process powershell -WindowStyle Hidden -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$Dir\dns-tray.ps1`" -Action Uninstall"
    [Windows.Forms.Application]::Exit()
  }
})

# Keeps the icon out of the hidden tray area
function Show-Always {
  $changed = $false
  foreach ($key in Get-ChildItem 'HKCU:\Control Panel\NotifyIconSettings' -ErrorAction SilentlyContinue) {
    $icon = Get-ItemProperty $key.PSPath
    if ("$($icon.ExecutablePath)" -match 'powershell\.exe$' -and $icon.IsPromoted -ne 1) {
      Set-ItemProperty $key.PSPath -Name IsPromoted -Value 1 -Type DWord
      $changed = $true
    }
  }
  # Windows only moves an icon out of hiding when it is added again
  if ($changed) {
    $tray.Visible = $false
    $tray.Visible = $true
  }
}

$script:fails = 0
$script:ticks = 0
$timer = New-Object Windows.Forms.Timer
$timer.Interval = 20000
$timer.add_Tick({
  try {
    $script:ticks++
    if ($script:ticks % 3 -eq 1) { Show-Always }
    # 5 minutes after start, then every 6 hours
    if ($script:ticks % 1080 -eq 15) { Log (Update-AdGuard) }
    $state = Read-State
    if ($state.enabled) {
      # New network adapters get the filter too
      $changed = $false
      foreach ($adapter in Get-Adapters) {
        $now = (Get-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ErrorAction SilentlyContinue).ServerAddresses
        if ($now -notcontains '127.0.0.1') {
          Set-AdapterOn $adapter $state
          $changed = $true
        }
      }
      if ($changed) {
        Write-State $state
        Clear-DnsClientCache
      }
      if (Test-Lookup) {
        $script:fails = 0
      } else {
        $script:fails++
        Log "lookup failed, $script:fails of 3"
        if ($script:fails -ge 3) {
          $script:fails = 0
          Disable-Dns $true
          Show-Note 'DNS Tray' 'It stopped answering, so your normal DNS is back for now.' 'Warning'
        }
      }
    } elseif ($state.autoOff -and (Test-Lookup '127.0.0.1')) {
      if (Enable-Dns) { Show-Note 'DNS Tray' 'Working again, and back on.' }
    }
    Update-Tray
  } catch {
    Log "check error: $_"
  }
})

Update-Tray
Show-Always
$timer.Start()
[Windows.Forms.Application]::Run()
$mutex.ReleaseMutex()
'@

function Stop-OldTray {
  Stop-ScheduledTask -TaskName 'DNS Tray' -ErrorAction SilentlyContinue
  Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" |
    Where-Object { $_.CommandLine -like '*dns-tray.ps1*' } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
}

function Install-AdGuard {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $arch = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'amd64' }
  $file = "AdGuardHome_windows_$arch.zip"
  $base = 'https://github.com/AdguardTeam/AdGuardHome/releases/latest/download'
  $temp = Join-Path $env:TEMP "dns-tray-$PID"
  New-Item -ItemType Directory -Force $temp | Out-Null
  $old = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'
  Invoke-WebRequest "$base/$file" -OutFile "$temp\$file" -UseBasicParsing
  Invoke-WebRequest "$base/checksums.txt" -OutFile "$temp\checksums.txt" -UseBasicParsing
  $ProgressPreference = $old

  # Stop here if the download is not exactly what AdGuard published and signed
  $hash = (Get-FileHash "$temp\$file" -Algorithm SHA256).Hash.ToLower()
  if (-not (Select-String -LiteralPath "$temp\checksums.txt" -SimpleMatch "$hash  ./$file" -Quiet)) { throw 'The download does not match its checksum.' }
  Expand-Archive "$temp\$file" -DestinationPath "$temp\x" -Force
  $signature = Get-AuthenticodeSignature "$temp\x\AdGuardHome\AdGuardHome.exe"
  if ($signature.Status -ne 'Valid' -or $signature.SignerCertificate.Subject -notmatch 'Adguard Software') { throw 'The download is not signed by AdGuard.' }

  New-Item -ItemType Directory -Force $AghDir | Out-Null
  Copy-Item "$temp\x\AdGuardHome\AdGuardHome.exe" $AghDir -Force
  Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
}

function Wait-ForLists {
  foreach ($i in 1..36) {
    Start-Sleep 5
    try {
      $on = (Invoke-RestMethod "$Api/filtering/status" -TimeoutSec 10).filters | Where-Object enabled
      if ($on -and -not ($on | Where-Object { -not $_.rules_count })) { return }
    } catch {}
  }
  throw 'The block lists did not load. Check your internet and run this again.'
}

function Install-Tray {
  $run = "-NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File `"$Tray`""
  $user = [Security.Principal.WindowsIdentity]::GetCurrent().Name
  $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $run
  $trigger = New-ScheduledTaskTrigger -AtLogOn -User $user
  $who = New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel Highest
  $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit ([TimeSpan]::Zero) -StartWhenAvailable
  Register-ScheduledTask -TaskName 'DNS Tray' -Action $action -Trigger $trigger -Principal $who -Settings $settings -Force | Out-Null
  Start-ScheduledTask -TaskName 'DNS Tray'
}

try {
  $hasService = [bool](Get-Service AdGuardHome -ErrorAction SilentlyContinue)
  if (-not $hasService) {
    if (Get-NetUDPEndpoint -LocalPort 53 -ErrorAction SilentlyContinue) { throw 'Another program is already using the DNS port (53). Close it and run this again.' }
    if (Get-NetTCPConnection -LocalPort 3053 -State Listen -ErrorAction SilentlyContinue) { throw 'Another program is already using port 3053. Close it and run this again.' }
  }

  Write-Host 'Installing DNS Tray...'
  Stop-OldTray
  New-Item -ItemType Directory -Force $Root | Out-Null
  Set-Content -LiteralPath $Tray -Value $trayScript -Encoding UTF8

  if (-not $hasService) {
    Write-Host 'Downloading AdGuard Home...'
    Install-AdGuard
    Set-Content -LiteralPath "$AghDir\AdGuardHome.yaml" -Value $config -Encoding UTF8
    & "$AghDir\AdGuardHome.exe" -s install 2>&1 | Out-Null
  } else {
    Start-Service AdGuardHome -ErrorAction SilentlyContinue
  }

  Write-Host 'Loading the block lists...'
  Wait-ForLists
  & powershell -NoProfile -ExecutionPolicy Bypass -File $Tray -Action Full | Out-Null
  Install-Tray

  $working = -not (Get-Content -LiteralPath "$Root\state.json" -Raw | ConvertFrom-Json).autoOff -and (Get-Content -LiteralPath "$Root\state.json" -Raw | ConvertFrom-Json).enabled
  if ($working) { Write-Host 'Done. Look for the green D next to the clock. If it is not there, click the ^ arrow. Restart your browser.' -ForegroundColor Green }
  else { Write-Host 'Installed, but it could not turn on, so your normal DNS is still in use. Try the tray icon.' -ForegroundColor Yellow }
} catch {
  Write-Host "Install failed: $_" -ForegroundColor Red
}
if (-not $env:DNSTRAY_NOPAUSE) { Read-Host 'Press Enter to close' | Out-Null }
