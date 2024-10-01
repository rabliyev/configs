#echo $PROFILE

function Add-To-Path  {
<#
        .SYNOPSIS
            Adds directory to the PATH environment variables

        .EXAMPLE
			Add-To-Path Path-To-Add
#> 
       Param(
        [Parameter(Mandatory=$true)]
        [String]$PathToAdd
    )
    $env:Path += ";$PathToAdd"
}


function Reload-Env {
<#
        .SYNOPSIS
            Reloads env variables 

        .EXAMPLE
			Reload-Env
#> 
    refreshenv
}



function No-Proxy {
<#
        .SYNOPSIS
            Disables proxy 

        .EXAMPLE
			No-Proxy
#> 
    [System.Environment]::SetEnvironmentVariable('https_proxy', '')

    [System.Environment]::SetEnvironmentVariable('http_proxy', '')
}

function Set-PgPass {
<#
        .SYNOPSIS
            SET psql PGPASS ENV variable

        .EXAMPLE
            Set-PgPass 
#>
Param(
        [Parameter(Mandatory=$true)]
        [String]$Password
    )
    # .\pg_dump --clean test  > c:\temp\db.sql
    # cat c:\temp\db.sql | .\psql test
    #
    # cat test.sql |  & 'C:\Program Files\PostgreSQL\13\bin\psql.exe' test
    # & 'C:\Program Files\PostgreSQL\13\bin\pg_dump.exe' --clean test > test.sql
    Add-To-Path "C:\Program Files\PostgreSQL\14\bin\"
    [System.Environment]::SetEnvironmentVariable('PGPASSWORD', $Password)
    [System.Environment]::SetEnvironmentVariable('PGUSER', 'postgres')
}


function Qemu-Shell {
<#
        .SYNOPSIS
            Add Qemu and NASM to PATH

        .EXAMPLE
            Qemu-Shell
#>
    Add-To-Path "C:\Program Files\qemu\"
	Add-To-Path "C:\Program Files\NASM"
    # qemu-system-i386.exe -hda .\print-hello-bios -S -s
    # -s == -gdb tcp::1234 
    # target remote tcp::1234
    # br *0x7c00 c
    # layout asm
    # # # https://stackoverflow.com/questions/32955887/how-to-disassemble-16-bit-x86-boot-sector-code-in-gdb-with-x-i-pc-it-gets-tr/32960272
    #https://superuser.com/questions/988473/why-is-the-first-bios-instruction-located-at-0xfffffff0-top-of-ram
    #https://web.archive.org/web/20150901145101/http://www.drdobbs.com/parallel/booting-an-intel-architecture-system-par/232300699?pgno=2
}


function ll { Get-ChildItem -Path $pwd -File }
function reload-profile {
        & $profile
}
function find-file($name) {
        Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
                $place_path = $_.directory
                Write-Output "${place_path}\${_}"
        }
}
function unzip ($file) {
        Write-Output("Extracting", $file, "to", $pwd)
	$fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object{$_.FullName}
        Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function grep($regex, $dir) {
        if ( $dir ) {
                Get-ChildItem $dir | select-string $regex
                return
        }
        $input | select-string $regex
}
function touch($file) {
        "" | Out-File $file -Encoding ASCII
}
function df {
        get-volume
}
function sed($file, $find, $replace){
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}
function which($name) {
        Get-Command $name | Select-Object -ExpandProperty Definition
}
function export($name, $value) {
        set-item -force -path "env:$name" -value $value;
}
function pkill($name) {
        Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
        Get-Process $name
}

#function make-link ($target, $link) {
function make-link {
	 Param(
        [Parameter(Mandatory=$true)]
        [String]$LinkName,
		
		[Parameter(Mandatory=$true)]
		[String]$TargetName
    )
    New-Item -Path $LinkName -ItemType SymbolicLink -Value $TargetName
}

