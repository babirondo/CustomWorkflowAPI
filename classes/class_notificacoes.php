<?php
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Notificacoes{
	function Notificacoes( ){
		
		require_once("classes/class_postos.php");
		require_once("classes/class_campo.php");
		require_once("classes/class_db.php");
		
		$this->con = new db();
		$this->con->conecta();		
	
		$this->posto = new Postos();
		$this->campos = new Campos();
		
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
	
	function notif_entrandoposto($idprocesso, $idposto)
	{	
		
            // puxa dados do posto atual
            $data2 = $this->posto->LoadCampos($idposto, $this->idprocesso );
            //echo " \n vardump do retorno ".$this->idposto."\n ";
            //var_dump($data2);

            if ($data2["DADOS_POSTO"] [avanca_processo] > 0 )
            {
                // puxa dados do proximo posto
                $data = $this->posto->LoadCampos($data2["DADOS_POSTO"] [avanca_processo], $idprocesso,"entrando" );

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
	
	function  notif_saindoposto( $idprocesso, $idposto_proximo, $idpostoanterior )
	{
            
            $sql = "select notif_saindoposto from workflow_postos where id= 274";
            $this->con->executa(   $sql, null, __LINE__);
            $this->con->navega(0);

            if ( $this->con->dados["notif_saindoposto"] > 0 )
            {
                echo "Notificando saida de posto ($idprocesso, $idposto_proximo, $idpostoanterior) \n";

                // posto que esta indo
                $data = $this->posto->LoadCampos( $idposto_proximo , $idprocesso , "saindo", $debug, "TODOS");

                //$debug = 1;
                // posto que esta no momento
                $data_atual= $this->posto->LoadCampos( $idpostoanterior , $idprocesso , "saindo", $debug, "TODOS");
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
	}
	
 	 	
}