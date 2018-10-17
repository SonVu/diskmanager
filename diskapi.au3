Global $disk[3]
;3 Function reading disk infomation by calling Partition Assistant batch
Func _GetDiskName($fileHandler)
	FileSetPos($fileHandler, 0, $FILE_BEGIN)
	Dim $diskArray
	For $i = 5 To _FileCountLines($fileHandler)
		$retNew = FileReadLine($fileHandler, $i)
		If IsArray($diskArray) = 1 Then
			$Bound = UBound($diskArray)
			ReDim $diskArray[$Bound + 1]
			$diskArray[$Bound] = $retNew
		Else
			Dim $diskArray[1]
			$diskArray[0] = $retNew
		EndIf
	Next
	For $i = 0 To UBound($diskArray) - 1
		$aArray = StringRegExp($diskArray[$i], '\s+(\d)\s\|\s(\d+\.\d+)(GB|TB|MB)\s+\|\s(.+)', $STR_REGEXPARRAYGLOBALMATCH)
		$diskArray[$i] = ""
		$diskArray[$i] = $aArray[3] & "       " & $aArray[1] & "" & $aArray[2]
	Next
	Return $diskArray
EndFunc   ;==>_GetDiskName

Func _GetDiskCapacity($fileHandler)
	FileSetPos($fileHandler, 0, $FILE_BEGIN)
	Dim $diskArray
	Dim $diskCapacity

	For $i = 5 To _FileCountLines($fileHandler)
		$retNew = FileReadLine($fileHandler, $i)
		If IsArray($diskArray) = 1 Then
			$Bound = UBound($diskArray)
			ReDim $diskArray[$Bound + 1]
			$diskArray[$Bound] = $retNew
		Else
			Dim $diskArray[1]
			$diskArray[0] = $retNew
		EndIf
	Next

	For $i = 0 To UBound($diskArray) - 1
		$aArray = StringRegExp($diskArray[$i], '\s+(\d)\s\|\s(\d+\.\d+)(GB|TB|MB)\s+\|\s(.+)', $STR_REGEXPARRAYGLOBALMATCH)
		$diskArray[$i] = ""
		$diskArray[$i] = $aArray[1]
	Next
	Return $diskArray
EndFunc   ;==>_GetDiskCapacity

Func _GetDiskIndex($fileHandler)
	FileSetPos($fileHandler, 0, $FILE_BEGIN)
	Dim $diskArray
	Dim $diskCapacity

	For $i = 5 To _FileCountLines($fileHandler)
		$retNew = FileReadLine($fileHandler, $i)
		If IsArray($diskArray) = 1 Then
			$Bound = UBound($diskArray)
			ReDim $diskArray[$Bound + 1]
			$diskArray[$Bound] = $retNew
		Else
			Dim $diskArray[1]
			$diskArray[0] = $retNew
		EndIf
	Next

	For $i = 0 To UBound($diskArray) - 1
		$aArray = StringRegExp($diskArray[$i], '\s+(\d)\s\|\s(\d+\.\d+)(GB|TB|MB)\s+\|\s(.+)', $STR_REGEXPARRAYGLOBALMATCH)
		$diskArray[$i] = ""
		$diskArray[$i] = $aArray[0]
	Next
	Return $diskArray
EndFunc   ;==>_GetDiskIndex

Func _GetDiskArray($fileHandler)
	$disk[0] = _GetDiskCapacity($fileHandler) ;
	$disk[1] = _GetDiskIndex($fileHandler) ;
	$disk[2] = _GetDiskName($fileHandler)
	Return $disk
EndFunc   ;==>_GetDiskArray
