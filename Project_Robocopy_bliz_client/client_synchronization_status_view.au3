
#include <array.au3>

Local $list[6]= ["Diablo III CN","Hearthstone","Heroes of the Storm","Overwatch","StarCraft_II","World of Warcraft"]


Global $matrix[6][8]

Global $i=0

For $item In $list
	$PROFILEPATH="\\ITTOOL_node1\Ini\Battle.net_client_synchronization_source\"& $item &".ini"
	$sections=IniReadSectionNames($PROFILEPATH)

	
	Local $j=0
	For $sec In $sections
;~ 		
		If $j==0 Then 
			$j+=1
			ContinueLoop 
		EndIf
		

		$matrix[$i][$j-1] = IniRead($PROFILEPATH,$sec,"links",0)
		$j+=1
		
	Next

	
	$i+=1
Next



_ArrayDisplay($matrix)

