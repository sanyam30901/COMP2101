# get-ciminstance is used to get the network configuration
# Where-Object is used to filter out the object with desired propert value of IPEnabled
# ft / format-table is used to show the desired columns

get-ciminstance win32_networkadapterconfiguration | Where-Object {$_.IPEnabled -eq "True"} | ft -Autosize Description, IPAddress, Index, IPSubnet, DNSDomain, DNSServerSearchOrder


