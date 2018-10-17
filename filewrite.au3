Func _CreateBatch($diskId, $partArray, $isGPT)
	; Create file to write script.
	If Not FileWrite(".\lib\script.bat", "") Then
		MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
		Return False
	EndIf
	; Open the file for writing (overwrite) and store the handle to a variable.
	Local $hFileOpen = FileOpen(".\lib\script.bat", $FO_OVERWRITE)
	If $hFileOpen = -1 Then
		MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
		Return False
	 EndIf
	 FileWrite($hFileOpen, "cd %~dp0" & @CRLF)
	; Write data to the file using the handle returned by FileOpen.
	; If MBR
	If $isGPT = 0 Then
		FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /del:all" & @CRLF)
		FileWrite($hFileOpen, "partassist.exe /rebuildmbr:" & $diskId & " /mbrtype:2" & @CRLF)
		If $partArray[2] = 0 And $partArray[1] = 0 Then
			FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:auto /fs:ntfs /act /align /label:OS /letter:auto" & @CRLF)
		Else
			FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:" & $partArray[0] & "GB /fs:ntfs /act /align /label:OS /letter:auto" & @CRLF)
			If $partArray[2] = 0 Then
				FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:auto /fs:ntfs /align /label:Data /letter:auto" & @CRLF)
			ElseIf $partArray[2] <> 0 Then
				FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:" & $partArray[1] & "GB /fs:ntfs /align /label:Data /letter:auto" & @CRLF)
				FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:auto /fs:ntfs /align /label:Data /letter:auto" & @CRLF)
			EndIf
		EndIf
		;If GPT
	Else
		FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /del:all" & @CRLF)
		FileWrite($hFileOpen, "partassist.exe /init:" & $diskId & "/gpt	" & @CRLF)
		FileWrite($hFileOpen, "partassist.exe /rebuildmbr:" & $diskId & " /mbrtype:2" & @CRLF)
		FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:200MB /fs:fat32 /act /hide /align /label:EFI" & @CRLF)
		If $partArray[2] = 0 And $partArray[1] = 0 Then
			FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:auto /fs:ntfs /align /label:OS /letter:auto" & @CRLF)
		Else
			FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:" & $partArray[0] & "GB /fs:ntfs /align /label:OS /letter:auto" & @CRLF)
			If $partArray[2] = 0 Then
				FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:auto /fs:ntfs /align /label:Data /letter:auto" & @CRLF)
			ElseIf $partArray[2] <> 0 Then
				FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:" & $partArray[1] & "GB /fs:ntfs /align /label:Data /letter:auto" & @CRLF)
				FileWrite($hFileOpen, "partassist.exe /hd:" & $diskId & " /cre /pri /size:auto /fs:ntfs /align /label:Data /letter:auto" & @CRLF)
			EndIf
		EndIf
	EndIf
	; Close the handle returned by FileOpen.
	FileClose($hFileOpen)

	; Delete the temporary file.
	;FileDelete($sFilePath)
EndFunc   ;==>_CreateBatch
