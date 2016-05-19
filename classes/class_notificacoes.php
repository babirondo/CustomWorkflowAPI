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
//var_dump($data);
                if (is_array($data["FETCH"][$this->idprocesso]))
		{
			foreach ($data["FETCH"][$this->idprocesso] as $campo => $val){
				
				//$valor[ $campo   ] = $val;  //       11 bruno
                                $valor [$de[$campo]] = $val;
                               // echo "\n -$campo- -$val- "  ;
			}
		}
		
        	$texto_original = str_replace("{idprocesso}", $this->idprocesso ,$texto_original);
                
		foreach ($de as $idcampo => $campo){
			 
                    $texto_original = preg_replace_callback( '%{.*?}%i',
                            
                        function($match) use ($valor) {
                            return    $valor[str_replace(array('{', '}'), '', strtolower(  $match[0] ) )]       ; // nome
                        },
                    $texto_original);
		}
		
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

                
                echo "\n".$this->debug;
                
		//mail($para, $titulo, $corpo, $headers);
                
                
                return $this->debug;
	}
	
	function notif_entrandoposto($idprocesso, $idposto)
	{	
		
            // puxa dados do posto atual
            $data2 = $this->posto->LoadCampos($idposto, $this->idprocesso );
            //echo " \n vardump do retorno ".$this->idposto."\n ";
            //var_dump($data2);

           
                foreach ($data2["DADOS_POSTO"] [avanca_processo] as $avanca_processo){
                     if ($avanca_processo > 0 )
                     {
                        // puxa dados do proximo posto
                        $data = $this->posto->LoadCampos($avanca_processo, $idprocesso,"entrando" );

                //	echo "\n avanca ".$data["DADOS_POSTO"] [avanca_processo] ."\n";

                        if ($data["DADOS_POSTO"] [notif_entrandoposto] > 0 )
                        {
                            $titulo = $this->TraduzirEmail($data["DADOS_POSTO"] [titulo], $data);
                            $corpo = $this->TraduzirEmail($data["DADOS_POSTO"] [corpo], $data);
                            $de = $this->TraduzirEmail($data["DADOS_POSTO"] [de], $data);
                            $para = $this->TraduzirEmail($data["DADOS_POSTO"] [para], $data);

                            //var_dump($data);
                            return $this->EnviaEmail($de, $para, $titulo, $corpo);
                        }                    
                    }

                }		
	}
	
	function  notif_saindoposto( $idprocesso,   $idposto )
	{
            
            // puxa dados do posto atual
            $data_atual = $this->posto->LoadCampos($idposto , $idprocesso , "saindo", 1, "TODOS");
            $this->idprocesso = $idprocesso;
          
            if ( $data_atual["DADOS_POSTO"] [notif_saindoposto]   > 0 )
            {
            
                foreach ($data_atual["DADOS_POSTO"] [avanca_processo] as $avanca_processo){
                        if ($avanca_processo >0){
                            
                              //echo "\n $avanca_processo , $idprocesso , saindo, $debug, TODOS"; 
                            // posto que esta indo
                             // $data = $this->posto->LoadCampos( $avanca_processo , $idprocesso , "saindo", 1, "TODOS");
                            //var_dump($data);
                              //$debug = 1;
                              // posto que esta no momento
                            //  $data_atual=  $this->posto->LoadCampos( $idposto , $idprocesso , "saindo", $debug, "TODOS");

                              if ($avanca_processo > 0 && $data_atual["DADOS_POSTO"] [notif_saindoposto] >0 )
                              {

                                  $titulo = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [titulo], $data_atual);
                                  $corpo = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [corpo], $data_atual);
                                  $de = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [de], $data_atual);
                                  $para = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [para], $data_atual);
                                  
                                 
                                  return $this->EnviaEmail($de, $para, $titulo, $corpo);
                              }
                        }

                }


            }
             
	}
	
 	 	
}