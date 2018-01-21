function Fix-ZTime{
    param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [String[]]$ComputerName
        ,[switch]$kill #kill HPCA radpinit  in case computer is not responding
    )

    Foreach($cn in $ComputerName)
    {
        if($kill){
            start-process taskkill.exe -ArgumentList "/s $cn  /fi `"imagename eq rad**`" /f" -wait -NoNewWindow
		    start-process taskkill.exe -ArgumentList "/s $cn  /fi `"imagename eq nvdkit*`" /f" -wait -NoNewWindow
            
	    }


        if(Test-Path "\\$cn\c$\Program Files (x86)\Hewlett-Packard\HPCA\Agent\Lib\ZTIMEQ.EDM")
            {
            
                $WriteTime= Get-Item -Path "\\$cn\c$\Program Files (x86)\Hewlett-Packard\HPCA\Agent\Lib\ZTIMEQ.EDM" | Select LastWriteTime
                Write-Host $cn $WriteTime
                Remove-Item -Path "\\$cn\c$\Program Files (x86)\Hewlett-Packard\HPCA\Agent\Lib\ZTIMEQ.EDM" -Force
            }
        else
            {
            
                $WriteTime= Get-Item -Path "\\$cn\c$\Program Files\Hewlett-Packard\HPCA\Agent\Lib\ZTIMEQ.EDM" | Select LastWriteTime
                Write-Host $cn $WriteTime
                Remove-Item -Path "\\$cn\c$\Program Files\Hewlett-Packard\HPCA\Agent\Lib\ZTIMEQ.EDM" -Force
            }
    
        start-process 'C:\Program Files (x86)\Hewlett-Packard\HPCA\Agent\radntfyc.exe' -ArgumentList "$cn radskman cat=prompt,ulogon=n,hreboot=n,dname=Software,log=connect_Software.log,rtimeout=60"
       
    }
}