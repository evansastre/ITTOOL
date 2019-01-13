::winmtrcmd -c 20 www.google.com | wtee C:\Users\TestUser1\Desktop\winMTRresult.txt

del winMTRresult.txt

.\tools\winmtrcmd -c 11  -r -f .\winMTRresult.txt  www.google.com
echo .>> .\winMTRresult.txt
".\tools\speedtest32.exe" --server 4672  | ".\tools\wtee.exe" -a .\winMTRresult.txt
echo .>> .\winMTRresult.txt
ipconfig /all >> .\winMTRresult.txt
:: .\sendmail.exe