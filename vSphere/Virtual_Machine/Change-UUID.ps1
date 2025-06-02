 <#
.SYNOPSIS
  PowerCLI script that change UUID for VMware Virtual Machines
.DESCRIPTION
  This script checks the total number of licensed instances and calculates the difference with the number of instances used.
.PARAMETER
  None
.INPUTS
  Virtual Machine name
.OUTPUTS
  None
.NOTES
  Version:        0.1
  Author:         Eduard Roig
  Creation Date:  09/14/2022
  Purpose/Change: Changes the UUID of a VMWare virtual machine before checking that it is stopped.
.EXAMPLE
  Usage: .\changeUUID.ps1 <VM>
#>

if ($args[0].length -gt 0) 
 {
    $VMs = Get-VM $args[0] 
    $VMname = $VMs.name
    if($VMname -eq $args[0])
    {
        echo "To execute the process, the server must be powered off."
        echo ""
        if($VMs.PowerState -eq "PoweredOff")
        {
            echo "--------------------------------------"
            echo "OK - The virtual machine is powered off."
            echo "--------------------------------------"
            echo ""
            echo "Old UUID"
            echo "------------"
            Get-VM  $VMname | %{(Get-View $_.Id).config.uuid}
            $date = get-date -format "dd hh mm ss"
            $newUuid = "56 4d 50 2e 9e df e5 e4-a7 f4 21 3b " + $date
            ###############$newUuid = "42 2b 31 2e 11 e7 a2 cc-e3 32 ac 9d 5a bc b4 73"
            $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
            $spec.uuid = $newUuid
            $VMs.Extensiondata.ReconfigVM_Task($spec)
            echo ""
            echo "New UUID"
            echo "----------"
            echo $newUuid
            start-sleep -s 2

        }
        else 
        {
            echo "--------------------------------------"
            echo "KO - The virtual machine is powered on."
            echo "--------------------------------------"
            echo "The process cannot be completed."
            echo "To process, you must shut down the server."    
        }
    }
    else 
    {
        echo "--------------------------------------"
        echo "The specified virtual machine does not exist" 
    }
 }

 # else {Echo "Must supply Name VM .e.g. .changeUUID.ps1 TEST"}
