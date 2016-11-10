function cdprofile
{
	cd (split-path $profile)
}

function root
{
    cd C:/Websites
}


function tfscheckinAction([string] $workitemId)
{
	If($workitemId -eq '')
	{
			git tfs rcheckin
	}else
	{
		write-host -foregroundcolor green "Associate to TaskId: " $workitemId
		$checkinCommand = 'git tfs rcheckin -w' + $workitemId
		iex $checkinCommand
	}
}

function tfscheckin([string] $message, [string] $workitemId)
{
	If ($message -ne '')
	{
		write-host -foregroundcolor green "Commit Message: " $message
		git add -A
		git commit -m $message
		tfscheckinAction($workitemId)
	}
	Else
	{
		write-host -foregroundcolor red "Message is required to perform commits!"
		$caption = "Continue to check-in committed items into TFS?";
		$message = "What do you want to do?";
		$no = new-Object System.Management.Automation.Host.ChoiceDescription "&No","No";
		$yes = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Yes";
		$choices = [System.Management.Automation.Host.ChoiceDescription[]]($no,$yes);
		$answer = $host.ui.PromptForChoice($caption,$message,$choices,0)

		switch ($answer)
		{
			0 
			{
				#"You entered No"; 
				break;
			}
			1 {
				#"You entered Yes"; 
				tfscheckinAction($workitemId)
				break;
			}
		}
	}
}

function gitpush([string] $message)
{
	If ($message -ne '')
	{
		write-host -foregroundcolor green "Commit Message: " $message
		git add -A
		git commit -m $message
		git push
	}
	Else
	{
		write-host -foregroundcolor red "Message is required to perform commits!"
		$caption = "Continue to check-in committed items into TFS?";
		$message = "What do you want to do?";
		$no = new-Object System.Management.Automation.Host.ChoiceDescription "&No","No";
		$yes = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Yes";
		$choices = [System.Management.Automation.Host.ChoiceDescription[]]($no,$yes);
		$answer = $host.ui.PromptForChoice($caption,$message,$choices,0)

		switch ($answer)
		{
			0 
			{
				#"You entered No"; 
				break;
			}
			1 {
				#"You entered Yes"; 
				git push
				break;
			}
		}
	}
}

function tfsclone([string] $projectName)
{
	$cloneCommand = "git tfs clone https://iomer.visualstudio.com/DefaultCollection '$/" + $projectName + "'"
	write-host -foregroundcolor green "cloning: " + $cloneCommand
	iex $cloneCommand
}

function forwardslash
{
    $didsomething = $false
    $input | %{
        $didsomething = $true
        forwardslash "$_"
    }
    $args | %{ 
        $didsomething = $true
        "$_".Replace('\','/')
    }
    if (-not $didsomething) 
	{
        write-error "no path(s) is specified"
    }
}

root

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
