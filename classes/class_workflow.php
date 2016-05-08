<?php
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Workflow{
	function Workflow( ){
		
		require_once("classes/class_postos.php");
		require_once("classes/class_db.php");
		
		$this->con = new db();
		$this->con->conecta();		
	
		$this->posto = new Postos();
		
		$this->idposto = null;
		$this->idprocesso = null;
	}
	
	function TraduzirEmail ($texto_original, $data){
		
		$de["{tecnologia}"] = "tecnologia";
		$de["{senioridade}"] = "senioridade";
		$de["{tipovaga}"] = "tipovaga";
		$de["{consultoria}"] = "consultoria";
		$de["{nome}"] = "nome";
		$de["{gestor interessado}"] = "Gestor Interessado";
		
		$de["{atores}"] = $data["DADOS_POSTO"][atores];
		
		if (is_array($data["FETCH"][$this->idprocesso]))
		{
			foreach ($data["FETCH"][$this->idprocesso] as $campo => $val){
			
				$preenchido_no_posto[] = $campo . " = " . $val ;
				$valor[$campo] = $val;
			}
			$texto_original = str_replace("{preenchido_no_posto}", implode("\n",$preenchido_no_posto) ,$texto_original);
		}
	//	var_dump($valor);
		
		// replace simples - pelo nome do campo		
		foreach ($de as $indice => $chave_array){
			if ($valor[$chave_array])
				$texto_original = preg_replace("{{$indice}}",  $valor[$chave_array]   , $texto_original);
			//else
			//	$texto_original = preg_replace("{{$indice}}",  $chave_array   , $texto_original);
				
		}
		
		// replace com tratamentos e valores fora do posto
		$texto_original = str_replace("{idprocesso}", $this->idprocesso ,$texto_original);
		
		return $texto_original;
	}
	
	function EnviaEmail($de, $para, $titulo, $corpo)
	{
		
		$headers = "MIME-Version: 1.1
		    Content-type: text/plain; charset=iso-8859-1
			From: ".$de."
			Return-Path: ".$de."
		    Reply-To: ".$de."  ";
		
		echo "
de: $de
para: $para
titulo: ".$titulo."
corpo: ".$corpo."
		
		
header: $headers
		";
		
		if (mail($para, $titulo, $corpo, $headers))
			echo "Email enviado com sucesso";
		else
			echo "Erro no envio de Email";	
	}
	
	function notif_entrandoposto()
	{	
		
		// puxa dados do posto atual
		$data2 = $this->posto->LoadCampos($this->idposto, $this->idprocesso );
		//echo " \n vardump do retorno ".$this->idposto."\n ";
		//var_dump($data2);
		
		if ($data2["DADOS_POSTO"] [avanca_processo] > 0 )
		{
			// puxa dados do proximo posto
			$data = $this->posto->LoadCampos($data2["DADOS_POSTO"] [avanca_processo], $this->idprocesso,"entrando" );
			
		//	echo "\n avanca ".$data["DADOS_POSTO"] [avanca_processo] ."\n";
			
			if ($data["DADOS_POSTO"] [notif_entrandoposto] > 0 )
			{
				$titulo = $this->TraduzirEmail($data["DADOS_POSTO"] [titulo], $data);
				$corpo = $this->TraduzirEmail($data["DADOS_POSTO"] [corpo], $data);
				$de = $this->TraduzirEmail($data["DADOS_POSTO"] [de], $data);
				$para = $this->TraduzirEmail($data["DADOS_POSTO"] [para], $data);
							
				var_dump($data);
				$this->EnviaEmail($de, $para, $titulo, $corpo);
			}
		}		
	}
	
	function  notif_saindoposto( )
	{
		$data = $this->posto->LoadCampos($this->idposto, $this->idprocesso , "saindo");

		if ($data["DADOS_POSTO"] [avanca_processo] > 0 && $data["DADOS_POSTO"] [notif_saindoposto] >0 )
		{
			$titulo = $this->TraduzirEmail($data["DADOS_POSTO"] [titulo], $data);
			$corpo = $this->TraduzirEmail($data["DADOS_POSTO"] [corpo], $data);
			$de = $this->TraduzirEmail($data["DADOS_POSTO"] [de], $data);
			$para = $this->TraduzirEmail($data["DADOS_POSTO"] [para], $data);
				
			
			$this->EnviaEmail($de, $para, $titulo, $corpo);
		}
	}
	
 	
	function SalvarHistorico($idprocesso, $idposto , $idworkflowtramitacao_original ){
	 
		$this->idposto = $idposto;
		$this->idprocesso = $idprocesso;
		
		$this->con->executa( "SELECT starter, avanca_processo FROM workflow_postos WHERE id =$idposto	");
		$this->con->navega(0);
		$avanca_processo = $this->con->dados["avanca_processo"];
		
		if ($this->con->dados["starter"] == 1) {

			$this->con->executa( "INSERT INTO workflow_tramitacao (idprocesso, idworkflowposto, inicio , fim)
					VALUES($idprocesso, $idposto, NOW()  , NOW() )	");
 			
			$this->notif_saindoposto( );
				
			$this->con->executa( "INSERT INTO workflow_tramitacao (idprocesso, idworkflowposto, inicio )
					VALUES($idprocesso, ".$avanca_processo.", NOW()   )	");
			
			$this->notif_entrandoposto( );
				
		}
		else{
			if ($avanca_processo >0 ){
				$this->con->executa( "INSERT INTO workflow_tramitacao (idprocesso, idworkflowposto, inicio )
						VALUES($idprocesso, $avanca_processo, NOW()   )	");
				$this->notif_entrandoposto();
			}
		 
			/// checando se pode fechar posto de entidade diferente
			$sql = "select tp.id
			from workflow_postos wp
			left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
			where wp.id  = $idposto";
			//	echo "\n $sql";
			
			$this->con->executa($sql );
			$this->con->navega(0);
			$idtipoprocess_posto = 	$this->con->dados["id"];
			
			$sql = "select  tp.id
					from workflow_tramitacao wt
						inner join workflow_postos wp ON (wp.id = wt.idworkflowposto)
						left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
					where wt.id = $idworkflowtramitacao_original ";
			//	echo "\n $sql";
			$this->con->executa( $sql);
			$this->con->navega(0);
			$idtipoprocess_processo = 	$this->con->dados["id"];
			
			if ( $idtipoprocess_posto == $idtipoprocess_processo){
				//echo " \n \n A $idtipoprocess_posto B $idtipoprocess_processo";
				//se mesma entidade, fechando o posto
				$sql =  "UPDATE workflow_tramitacao SET fim = NOW() WHERE id  = $idworkflowtramitacao_original  ";
				$this->con->executa(   $sql);
				
				$this->notif_saindoposto( );
				
			}
	
		}	
	}
	
	
	function getWorkflows($app ){
	 
		$this->con->executa( "Select * from workflow");
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["workflow"]  = $this->con->dados["workflow"];
			$array["FETCH"][$i]["idworkflow"]  = $this->con->dados["id"];
			$array["FETCH"][$i]["postoinicial"]  = $this->con->dados["posto_inicial"];
			$i++;
		}
		
		$array["resultado"] = "SUCESSO";

		$data =  	$array;
		
		$app->render ('default.php',$data,200);
				
		
	}
	
 	function Registrar($app , $jsonRAW, $idposto){
 		$json = json_decode( $jsonRAW, true );
 		IF ($json == NULL) {
			$data = array("data"=>
	
					array(	"resultado" =>  "ERRO",
							"erro" => "JSON zuado - $jsonRAW" )
			);
	
	
			$app->render ('default.php',$data,500);
			return false;
		}	
		$erro = 0;
		
	//	echo "\n $idposto - ".$json[processo][valor];
		$id_pai = "null";
		 if ($idposto && $json[processo][valor] ) {
		 	$sql = "select tp.id
					from workflow_postos wp
					left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
					where wp.id  = $idposto";
		 //	echo "\n $sql";
		 	
			$this->con->executa($sql );
			$this->con->navega(0);
			$idtipoprocess_posto = 	$this->con->dados["id"];
		
		 	$sql = "select idtipoprocesso from processos where id = ".$json[processo][valor];
		 //	echo "\n $sql";
			$this->con->executa( $sql);
			$this->con->navega(0);
			$idtipoprocess_processo = 	$this->con->dados["idtipoprocesso"];
		
			if ( $idtipoprocess_posto != $idtipoprocess_processo){
				$id_pai = $json[processo][valor];
				$json[processo][valor] = null;
			}
			else 	
				$idprocesso = $json[processo][valor];	
		}
		
		if ( !$json[processo][valor]    )  {
 			 
 			$this->con->executa( "select tp.id idtipoprocesso, wp.id_workflow
									from workflow_postos wp
										inner join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
									where wp.id = $idposto " );
 			$this->con->navega(0);
 			
 			$sql = "INSERT INTO  processos (idtipoprocesso, idpai, inicio, idworkflow)
										VALUES ( ".$this->con->dados["idtipoprocesso"]."   ,$id_pai, NOW() , ".$this->con->dados["id_workflow"].")
										RETURNING id ";
			if (  $this->con->executa( $sql , 1 ) === false )
				$erro = 1;
			else{
				$idprocesso =  $this->con->dados["id"];		
			//	$this->PrimeiroHistorico($idprocesso, $idposto);
				
			}
 		}
 				
		//var_dump($json);
				
 	    foreach ($json as $campo => $valor){
 	    	if ($campo == "processo") continue;
 	    	
 	    	if ($valor[idworkflowdado] > 0 )
 	    	{
 	    		if (!$this->con->executa( "UPDATE workflow_dados SET valor = '".$valor[valor]."' WHERE id  ='".$valor[idworkflowdado]."'"  ))
 	    			$erro++;
 	    	}
 	    	else
 	    	{
 	    		if (!$this->con->executa( "INSERT INTO workflow_dados (idpostocampo, valor, idprocesso, registro)
 	    				VALUES ('$campo','$valor[valor]', $idprocesso, NOW()) "  ))
 	    			$erro++;
 	    		
 	    	}
 	    	
 	    }
 	    
		 
 	    if ($json[processo][acao] == "Salvar e Avançar >>>")
 	    { 	   
 	    	$this->SalvarHistorico($idprocesso, $idposto, $json[processo][idworkflowtramitacao_original]);
  	    }
 	    
		
		if ($erro == 0){
			//autenticado
				
			$data = array("data"=>
					array(	"resultado" =>  "SUCESSO",
							"IDPROCESSO" => $idprocesso
					)
			);
		}
		else {
			// nao encontrado
			$data = array("data"=>
		
					array(	"resultado" =>  "ERRO #$erro",
							"erro" => "Nao encontrado" )
			);
		}
		
		$app->render ('default.php',$data,200);		
		
	
	
	}
	
	 
	
}