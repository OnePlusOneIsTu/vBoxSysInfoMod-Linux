#!/bin/bash

# Vars
TITLE='vBoxSysInfoMod Linux Remake v1.0'
VBOXMAN=`which vboxmanage`

# INTRO
clear
echo $TITLE
echo 
echo Originally based on a Windows batch script created by JayMontana36, this script is a remake for linux users
echo as there does not seem to be a linux alternative.
echo 
echo This script is licensed under the Creative Commons Atribution-NonCommercial-ShareAlike 4.0 International License.
echo A copy of this licensed can be viewed at http://creativecommons.org/licenses/by-nc-sa/4.0/
echo 
echo If there are any issues or suggestions, please contact me by:
echo Discord - burning\#0001
echo Github  - http://github.com/oneplusoneistu/vBoxSysInfoMod-linux/issues
echo
read -n 1 -s -r -p 'Press any key to continue...'

if [[ -z "$VBOXMAN" ]]; then
	# TODO: Add way for user to input vboxmanage location
	echo ERROR: VirtualBoxManager not found, please
	exit
fi

# COMMANDS
while true
do
	clear
	echo $TITLE
	echo 
	echo Commands: 
	echo \"ModifyVM\" - Change System Info for a VM.
	echo \"ResetVM\" - Reset System Info for a VM.
	echo \"Exit\" - Exit program.
	echo 
	read -p '>> ' CMD
	CMD=`echo $CMD | tr '[:upper:]' '[:lower:]'`

	# MODIFYVM
	if [[ "$CMD" == "modifyvm" ]]; then
		while true
		do
			clear
			echo $TITLE
			echo 
			echo Registered VMs: # List VMs
			eval $VBOXMAN list vms
			echo
			echo Which VM would you like to modify? [Last: \'$VMNAME\']
			echo \'q\' to quit
			read -p '>> ' VMNAME

			if [[ "$VMNAME" == "q" ]] || [[ "$VMNAME" == "q" ]]; then
				VMNAME=''
				break	
			fi

			# Find firmware
			VMMODE=`"$VBOXMAN" showvminfo "$VMNAME" --machinereadable | grep firmware | tr "firmware=" "\n" | tr -d '[:space:]'`
			if [[ "$VMMODE" == *"BIOS"* ]] || [[ "$VMMODE" == *"bios"* ]]; then
				FW="pcbios"
			elif [[ "$VMMODE" == *"EFI"* ]] || [[ "$VMMODE" == *"efi"* ]]; then
				FW="efi"
			else
				continue
			fi
			
			# Task Killer
			clear
			echo $TITLE
			echo
			echo WARINING: Please ensure that all vBox VMs are safely closed as all vBox-related windows will be closed
			echo and failure to do so may result in result in corruption or data loss.
			echo
			read -n 1 -s -r -p 'Press any key to continue...'
			echo
			killall VirtualBox

			# Initial Information
			clear
			echo $TITLE
			echo
			echo Modding the System
			echo
			read -p 'System Manufacturer: ' SYSven
			read -p 'System Model: ' SYSprod
			echo
			echo Starting modifications...
			echo "Modifying DMI BIOS Information (type 0)..."
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSVendor" "$SYSven"`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSVersion" "$SYSprod"`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSReleaseDate" "12/01/2006"` # random
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSReleaseMajor" $((0 + RANDOM % 9))` # random
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSReleaseMinor" $((0 + RANDOM % 9))` # random
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSFirmwareMajor" $((0 + RANDOM % 9))` # random
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSFirmwareMinor" $((0 + RANDOM % 9))` # random
			
			# DMI System Information
			echo "Modifying DMI System Information (type 1)..."
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemVendor" "$SYSven"`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemProduct" "$SYSprod"`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemVersion" "$((1 + RANDOM % 10)).$RANDOM"` # random
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemSerial" "string:$RANDOM"` # random
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemSKU" "string:$RANDOM"` # random
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemFamily" "<EMPTY>"`
			#`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemUUID" ""` # Causes ERR

			# DMI Board Information
			echo "Modifying DMI Board Information (type 2)..."
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardVendor" "$SYSven"`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardProduct" "$SYSprod"`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardVersion" "$((1 + RANDOM % 10)).$RANDOM"`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardSerial" "string:$RANDOM"` # random
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardAssetTag" "string:$RANDOM"` # random
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardLocInChass" "<EMPTY>"`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardBoardType" $((1 + RANDOM % 10))` # random

			# DMI Processor Information
			echo "Modifying DMI Processor Information (type 4)..."
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiProcManufacturer" "$SYSven"`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiProcVersion" "$SYSprod"`
			
			# Reset Vars
			VMNAME=''
			FW=''

			echo Completed.
			echo
			read -n 1 -s -r -p 'Press any key to continue...'
			
			break
		done

	# RESETVM
	elif [[ "$CMD" == "resetvm" ]]; then
		while true
		do
			clear
			echo $TITLE
			echo 
			echo Registered VMs: # List VMs
			eval $VBOXMAN list vms
			echo
			echo Which VM would you like to modify? [Last: \'$VMNAME\']
			echo \'q\' to quit
			read -p '>> ' VMNAME

			if [[ "$VMNAME" == "q" ]] || [[ "$VMNAME" == "q" ]]; then
				VMNAME=''
				break	
			fi

			# Find firmware
			VMMODE=`"$VBOXMAN" showvminfo "$VMNAME" --machinereadable | grep firmware | tr "firmware=" "\n" | tr -d '[:space:]'`
			if [[ "$VMMODE" == *"BIOS"* ]] || [[ "$VMMODE" == *"bios"* ]]; then
				FW="pcbios"
			elif [[ "$VMMODE" == *"EFI"* ]] || [[ "$VMMODE" == *"efi"* ]]; then
				FW="efi"
			else
				continue
			fi
			
			clear
			echo $TITLE
			echo
			echo Clearing all DMI data for "$VMNAME".
			echo WARNING: Are you sure you want to reset these settings?
			echo 
			echo \(Y/N\)
			read -n 1 -p '>> ' INPUT
			if [[ "$INPUT" == "N" ]] || [[ "$INPUT" == "n" ]]; then
				break
			elif [[ "$INPUT" == "Y" ]] || [[ "$INPUT" == "y" ]]; then
				echo
			else
				continue
			fi
			
			# Task Killer
			clear
			echo $TITLE
			echo
			echo WARINING: Please ensure that all vBox VMs are safely closed as all vBox-related windows will be closed
			echo and failure to do so may result in result in corruption or data loss.
			echo
			read -n 1 -s -r -p 'Press any key to continue...'
			echo
			killall VirtualBox

			clear
			echo $TITLE
			echo
			echo Starting reset...
			echo "Resetting DMI BIOS Information (type 0)..."
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSVendor" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSVersion" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSReleaseDate" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSReleaseMajor" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSReleaseMinor" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSFirmwareMajor" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBIOSFirmwareMinor" ""`
			
			# DMI System Information
			echo "Resetting DMI System Information (type 1)..."
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemVendor" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemProduct" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemVersion" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemSerial" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemSKU" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemFamily" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiSystemUUID" ""`

			# DMI Board Information
			echo "Resetting DMI Board Information (type 2)..."
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardVendor" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardProduct" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardVersion" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardSerial" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardAssetTag" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardLocInChass" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiBoardBoardType" ""`

			# DMI Processor Information
			echo "Resetting DMI Processor Information (type 4)..."
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiProcManufacturer" ""`
			`"$VBOXMAN" setextradata "$VMNAME" "VBoxInternal/Devices/$FW/0/Config/DmiProcVersion" ""`
			
			# Reset Vars
			VMNAME=''
			FW=''
			
			echo Completed.
			read -n 1 -s -r -p 'Press any key to continue...'
		done

	# EXIT
	elif [[ "$CMD" == "exit" ]]; then
		exit
	fi
done
