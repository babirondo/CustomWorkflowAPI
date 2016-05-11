<?php
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Workflow{
	function Workflow( ){
		
		require_once("classes/class_postos.php");
		require_once("classes/class_campo.php");
		require_once("classes/class_db.php");
		
		$this->con = new db();
		$this->con->conecta();		
	
		$this->posto = new Postos();
		$this->campos = new Campos();
		
		$this->idposto = null;
		$this->idprocesso = null;
		$this->debug = null;
	}
	
	function TraduzirEmail ($texto_original, $data){
		
		 
		$de = $this->campos->getCampos(); // 11 nome
		//var_dump($de);
		
		//var_dump($data["FETCH"][$this->idprocesso]);

                if (is_array($data["FETCH"][$this->idprocesso]))
		{
			foreach ($data["FETCH"][$this->idprocesso] as $campo => $val){
				
				//$valor[ $campo   ] = $val;  //       11 bruno
                                $valor [$de[$campo]] = $val;
                               // echo "\n -$campo- -$val- "  ;
			}
		}
		//var_dump($valor);
		
//		$texto_original = str_replace("{email}",  "mudou"   , $texto_original);
		
        	$texto_original = str_replace("{idprocesso}", $this->idprocesso ,$texto_original);

                
		// replace simples - pelo nome do campo		
		foreach ($de as $idcampo => $campo){
			 
                    //$texto_original = str_replace("{{$campo}}",  $valor[$idcampo ]   , $texto_original);
                                        
                 //   $texto_original =  preg_replace('%{.*?}%i', '', $texto_original); 
                    $texto_original = preg_replace_callback( '%{.*?}%i',
                            
                        function($match) use ($valor) {
                    //    var_dump($valor);   
                            return    $valor[str_replace(array('{', '}'), '', strtolower(  $match[0] ) )]       ; // nome
                        },
                    $texto_original);
                    //echo "\n $campo =  ".$valor[$idcampo ]  ;
		}
		
		// replace com tratamentos e valores fora do posto
	//	$texto_original = str_replace("{preenchido_no_posto}", implode("\n",$preenchido_no_posto) ,$texto_original);
		
	//	echo "\n $texto_original";
		return $texto_original;
	}
	
	function EnviaEmail($de, $para, $titulo, $corpo)
	{
		
		$headers = "MIME-Version: 1.1
		    Content-type: text/plain; charset=iso-8859-1
			From: ".$de."
			Return-Path: ".$de."
		    Reply-To: ".$de."  ";
		
		$this->debug .= "
de: $de
para: $para
titulo: ".$titulo."
corpo: ".$corpo."
		
		
header: $headers ";

		//mail($para, $titulo, $corpo, $headers);
	}
	
	function notif_entrandoposto($idposto)
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

                    //var_dump($data);
                    $this->EnviaEmail($de, $para, $titulo, $corpo);
                }
            }		
	}
	
	function  notif_saindoposto( $idposto_proximo )
	{
            // posto que esta indo
            $data = $this->posto->LoadCampos( $idposto_proximo , $this->idprocesso , "saindo", $debug, "TODOS");
            //$debug = 1;
            // posto que esta no momento
            $data_atual= $this->posto->LoadCampos( $this->idposto , $this->idprocesso , "saindo", $debug, "TODOS");
         //   var_dump($data_atual);    

    //	var_dump($data_atual);
            //xxxxx

            if ($data_atual["DADOS_POSTO"] [avanca_processo] > 0 && $data_atual["DADOS_POSTO"] [notif_saindoposto] >0 )
            {
                $titulo = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [titulo], $data);
                $corpo = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [corpo], $data);
                $de = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [de], $data);
                $para = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [para], $data);


                $this->EnviaEmail($de, $para, $titulo, $corpo);
            }
	}
	
 	
	function SalvarHistorico($idprocesso, $idposto , $idworkflowtramitacao_original ){

            $this->idposto = $idposto;
            $this->idprocesso = $idprocesso;

            //TODO trocar starter por workflow.posto_inicial e remover campo starter da table wp

            $sql =  "select posto_final, penultimo_posto
            from workflow_postos wp
            inner join workflow w ON (w.id = wp.id_workflow)
            where wp.id=$idposto  ";
            $this->con->executa(   $sql);
            $this->con->navega(0);
            $idposto_final = $this->con->dados["posto_final"];
            $idposto_penultimo  = $this->con->dados["penultimo_posto"];

            $this->con->executa( "SELECT starter, avanca_processo FROM workflow_postos WHERE id =$idposto	");
            $this->con->navega(0);
            $avanca_processo = $this->con->dados["avanca_processo"];
            $starter = $this->con->dados["starter"];
            
            if ($starter){
                $this->con->executa( "INSERT INTO workflow_tramitacao (idprocesso, idworkflowposto, inicio, fim )
                                        VALUES($idprocesso, $idposto, NOW() , NOW()  )	");

                $this->notif_saindoposto($idposto);
                
            }

            if ($avanca_processo >0 ){
                $this->con->executa( "INSERT INTO workflow_tramitacao (idprocesso, idworkflowposto, inicio )
                                        VALUES($idprocesso, $avanca_processo, NOW()   )	");

                $this->notif_entrandoposto($avanca_processo);

                $sql =  "UPDATE processos SET status = 'Em Andamento' WHERE id  = $idprocesso  ";
                $this->con->executa(   $sql);
            }

            /// checando se pode fechar posto de entidade diferente
            $sql = "select tp.id
            from workflow_postos wp
            left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
            where wp.id  = $idposto";

            $this->con->executa($sql );
            $this->con->navega(0);
            $idtipoprocess_posto = 	$this->con->dados["id"];

            $sql = "select  tp.id, wp.id idpostoanterior
                            from workflow_tramitacao wt
                                    inner join workflow_postos wp ON (wp.id = wt.idworkflowposto)
                                    left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                            where wt.id = $idworkflowtramitacao_original ";

            $this->con->executa( $sql);
            $this->con->navega(0);

            $idtipoprocess_processo = 	$this->con->dados["id"];
            $idpostoanterior = 	$this->con->dados["idpostoanterior"];


            if ($avanca_processo >0 ){
                if ( ($idtipoprocess_posto == $idtipoprocess_processo) || ($idtipoprocess_posto && !$idtipoprocess_processo )){
                    //se mesma entidade, fechando o posto
                    $sql =  "UPDATE workflow_tramitacao SET fim = NOW() WHERE id  = $idworkflowtramitacao_original  ";
                    $this->con->executa(   $sql);

                    $this->notif_saindoposto( $avanca_processo );

                }
            }
            	
            //finalizando o status de um processo
            if ($idposto_final == $avanca_processo && $avanca_processo > 0){
                    if ( $idposto_penultimo == $idpostoanterior)
                            $sql =  "UPDATE processos SET status = 'Concluído' WHERE id  = $idprocesso  ";
                    else
                            $sql =  "UPDATE processos SET status = 'Arquivado' WHERE id  = $idprocesso  ";
                    $this->con->executa(   $sql);				
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
 	    	
 	    	//TODO nÃo está dando load nos salvos no posto
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
							"DEBUG" => $this->debug,
							"IDPROCESSO" => $idprocesso
					)
			);
		}
		else {
			// nao encontrado
			$data = array("data"=>
		
					array(	"resultado" =>  "ERRO #$erro",
							"DEBUG" => $this->debug, 
							"erro" => "Nao encontrado" )
			);
		}
		
		$app->render ('default.php',$data,200);		
		
	
	
	}
	
	 
	
}