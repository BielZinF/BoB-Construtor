extends PanelContainer


func _process(delta: float) -> void:
	
	$vbox/Panel/Vbox/Translate.visible = is_instance_valid(Index.select)
	
	if is_instance_valid(Index.select):
		
		$vbox/Nome.text = Index.select.name
		
		$vbox/Panel/Vbox/Translate/Vbox/X.value = Index.select.transform.origin.x
		$vbox/Panel/Vbox/Translate/Vbox/Y.value = Index.select.transform.origin.y
		$vbox/Panel/Vbox/Translate/Vbox/Z.value = Index.select.transform.origin.z
	else:
		$vbox/Nome.text = "NENHUM NODE SELECIONADO"
		
