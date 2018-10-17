#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Outfile=.\diskmanager v1.Exe
#AutoIt3Wrapper_Compression=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <File.au3>
#include <Array.au3>
#include <filewrite.au3>
#include <diskapi.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <GuiComboBoxEx.au3>
#include <WinAPIFiles.au3>
#Region
$mainForm = GUICreate("Disk Manager", 305, 172, 277, 220)
$listDiskCombo = GUICtrlCreateCombo("Disk 0", 80, 8, 217, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$partition1 = GUICtrlCreateInput("60", 80, 40, 121, 21)
$partition2 = GUICtrlCreateInput("200", 80, 72, 121, 21)
$partition3 = GUICtrlCreateInput("200", 80, 104, 121, 21)
$efiCheckbox = GUICtrlCreateCheckbox("EFI + GPT", 16, 140, 97, 17)
$applyButton = GUICtrlCreateButton("Apply", 128, 136, 75, 25)
$label1 = GUICtrlCreateLabel("Select disk", 16, 8, 56, 17, $SS_CENTERIMAGE)
$label2 = GUICtrlCreateLabel("Partition 1", 16, 40, 51, 17, $SS_CENTERIMAGE)
$label3 = GUICtrlCreateLabel("Partition 2", 16, 72, 51, 17, $SS_CENTERIMAGE)
$label4 = GUICtrlCreateLabel("Partition 3", 16, 104, 51, 17, $SS_CENTERIMAGE)
GUISetState(@SW_SHOW)
#EndRegion

;Initialize data
Local $iPID = RunWait(".\lib\disk.bat", "", @SW_HIDE)
Local $fileHandler = FileOpen(".\lib\text.txt", 0)
$diskArray = _GetDiskArray($fileHandler)
$diskCapacityArray = $diskArray[0]
$diskIndexArray = $diskArray[1]
$diskNameArray = $diskArray[2]
FileClose ($fileHandler)
;Concate disk index to disk name
_GUICtrlComboBox_ResetContent($listDiskCombo)
For $i = 0 To UBound($diskNameArray) - 1
	$diskNameArray[$i] = $diskIndexArray[$i] & ": " & $diskNameArray[$i]
Next

;Initialize form
GUICtrlSetData($listDiskCombo, "|" & _ArrayToString($diskNameArray), $diskNameArray[0])
$index = _GUICtrlComboBox_GetCurSel($listDiskCombo)
Global $diskCapacity = $diskCapacityArray[$index]
GUICtrlSetData($partition1, 60)
Global $partArray[3]
GUICtrlSetData($partition2, ($diskCapacity - 60) / 2)
GUICtrlSetData($partition3, ($diskCapacity - 60) / 2)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $partition1
			If GUICtrlRead($partition1) > $diskCapacity Then
				MsgBox(0, "Error", "Partition cant large than disk capacity")
				GUICtrlSetData($partition1, "")
				GUICtrlSetData($partition1, ($diskCapacity))
				GUICtrlSetData($partition2, 0)
				GUICtrlSetData($partition3, 0)
			Else
				GUICtrlSetData($partition2, "")
				GUICtrlSetData($partition2, ($diskCapacity - GUICtrlRead($partition1)) / 2)
				GUICtrlSetData($partition3, "")
				GUICtrlSetData($partition3, ($diskCapacity - GUICtrlRead($partition1) - GUICtrlRead($partition2)))
			EndIf
		Case $partition2

			If GUICtrlRead($partition2) > ($diskCapacity - GUICtrlRead($partition1)) Then
				MsgBox(0, "Error", "Partition cant large than disk capacity")
				GUICtrlSetData($partition2, "")
				GUICtrlSetData($partition2, ($diskCapacity - GUICtrlRead($partition1)))
				GUICtrlSetData($partition3, 0)
			Else
				GUICtrlSetData($partition3, "")
				GUICtrlSetData($partition3, ($diskCapacity - Int(GUICtrlRead($partition1)) - Int(GUICtrlRead($partition2))))
				GUICtrlSetData($partition3, (Int($diskCapacity) - Int(GUICtrlRead($partition1)) - Int(GUICtrlRead($partition2))))
			EndIf
		Case $partition3
			If GUICtrlRead($partition3) > ($diskCapacity - GUICtrlRead($partition1) - GUICtrlRead($partition2)) Then
				MsgBox(0, "Error", "Partition cant large than disk capacity")
				GUICtrlSetData($partition3, "")
				GUICtrlSetData($partition3, ($diskCapacity - GUICtrlRead($partition1) - GUICtrlRead($partition2)))
			ElseIf Int(GUICtrlRead($partition3)) == 0 Then
				GUICtrlSetData($partition2, ($diskCapacity - GUICtrlRead($partition1)))
			EndIf
		Case $applyButton
			$partArray[0] = GUICtrlRead($partition1)
			$partArray[1] = GUICtrlRead($partition2)
			$partArray[2] = GUICtrlRead($partition3)
			;Get disk  measurements by extracting 2 character from listDiskCombo
			$measurement = ""
			_GUICtrlComboBoxEx_GetItemText($listDiskCombo, _GUICtrlComboBox_GetCurSel($listDiskCombo), $index)
			$measurement = StringRight($measurement, 2)
			;ConsoleWrite("Measurements: " & $measurement & @CRLF)
			;Get disk index by extracting 1st character from listDiskCombo
			$index = ""
			_GUICtrlComboBoxEx_GetItemText($listDiskCombo, _GUICtrlComboBox_GetCurSel($listDiskCombo), $index)
			$index = StringLeft($index, 1)
			ConsoleWrite($index)
			;ConsoleWrite("Index: " & $index & @CRLF)
			If GUICtrlRead($efiCheckbox) = 4 Then
				_CreateBatch($index, $partArray, 0)
			Else
				_CreateBatch($index, $partArray, 1)
			EndIf
			Local $iPID = RunWait(".\lib\script.bat", "", @SW_SHOW)
		Case $listDiskCombo
			$index = _GUICtrlComboBox_GetCurSel($listDiskCombo)
			$diskCapacity = Int($diskCapacityArray[$index])
			If $diskCapacity < 60 Then
				GUICtrlSetData($partition1, $diskCapacity)
				GUICtrlSetData($partition2, 0)
				GUICtrlSetData($partition3, 0)
			 Else
				GUICtrlSetData($partition1, 60)
				GUICtrlSetData($partition2, ($diskCapacity - 60) / 2)
				GUICtrlSetData($partition3, ($diskCapacity - GUICtrlRead($partition2) - GUICtrlRead($partition1)))
			EndIf
				ConsoleWrite("Capacity: " & $diskCapacity & @CRLF)
	EndSwitch
WEnd

