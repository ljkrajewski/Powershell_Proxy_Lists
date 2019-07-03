# prep4article-download.ps1
#

$wd = 'C:\Support'
$proxyListFileIn = "$wd\proxy-table.csv"
$proxyListFileOut = "$wd\proxy-list-trimmed.txt"
$testSite = "http://lynx.browser.org/"

## trim proxy list down to working proxies
# get list from http://spys.one/en/free-proxy-list/
if (test-path $proxyListFileOut) { remove-item -Force $proxyListFileOut }
import-csv $proxyListFileIn |% {
  $ip = $_.'Proxy address:port'
  $type = $($_.'Proxy type').tolower()
  $proxy = "$($type)://$ip"
  write-host "Testing proxy $proxy…"
  $return = invoke-webrequest -UseBasicParsing -Uri $testSite -proxy $proxy
  $worked = $? -and ($return -ne $null)
  if (!($worked)) {
    $return = invoke-webrequest -UseBasicParsing -Uri $testSite -proxy $proxy
    $worked = $? -and ($return -ne $null)
  }
  if ($worked) {
    write-host "Working proxy found."
    $proxy | out-file -Append -Encoding ascii $proxyListFileOut
  }
}
#>
