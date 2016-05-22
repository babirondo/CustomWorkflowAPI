<?php
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Notificacoes{
	function Notificacoes( ){
		
		require_once("classes/class_postos.php");
		require_once("classes/class_campo.php");
                include_once("classes/globais.php");   
		require_once("classes/class_db.php");
		
		$this->con = new db();
		$this->con->conecta();		
                $this->globais = new Globais();
                $this->posto = new Postos();
		$this->campos = new Campos();
		 
		$this->debug = null;
               
	}
	
                
        function LoadbyChave($chave, $idsla)
        {
            $sql = "select * from sla where id = $idsla  "; 
            //    echo "<BR> $sql";
            $this->con->executa( $sql);
            $this->con->navega(0);
            $tipo_chave = $this->con->dados["tabela"];
            
            $sql = "select  ".$this->con->dados["campo_localizador"]." chave, *
                    from ".$this->con->dados["tabela"]."   
                    WHERE  ".$this->con->dados["campo_localizador"]." = $chave   ";    
                
            $this->con->executa( $sql); 
            $this->con->navega(0);
            
            
            //echo "<BR>tipo chave: $tipo_chave";
            switch ($tipo_chave)
            {
                case("workflow_tramitacao wt"):
                    $idposto =$this->con->dados["idworkflowposto"];
                    $this->idprocesso =$this->con->dados["idprocesso"];
                    
                    $data = $this->posto->LoadCampos($idposto,$this->idprocesso );
                break;
            
                case("processos p"):
                  
                    $this->idprocesso =$this->con->dados["id"];
                    
                    $data = $this->posto->LoadCamposbyProcesso(  $this->idprocesso );
                break;    
            }
            
            return $data;      
        }
           

        
	function TraduzirEmail ($texto_original, $data){
		
		 
		$de = $this->campos->getCampos(); // 11 nome
                
                if (is_array($data["FETCH"][$this->idprocesso]))
		{
                
			foreach ($data["FETCH"][$this->idprocesso] as $campo => $val){
				
				//$valor[ $campo   ] = $val;  //       11 bruno
                                $valor [$de[$campo]] = $val;
                               // echo "\n -$campo- -$val- "  ;
			}
		}
		// TODO: REsolver a adicao de campos especiais para resolver no email de notificacao
                $valor = $this->globais->ArrayMergeKeepKeys ($valor, $this->globais->SYS_CAMPOS_ESPECIAIS );
                //var_dump($valor);exit;  
                
        	$texto_original = str_replace("{idprocesso}", $this->idprocesso ,$texto_original);
                
		foreach ($de as $idcampo => $campo){
			 
                    $texto_original = preg_replace_callback( '%{.*?}%i',
                            
                        function($match) use ($valor) {
                            return    (($valor[str_replace(array('{', '}'), '', strtolower(  $match[0] ) )])
                                       ? $valor[str_replace(array('{', '}'), '', strtolower(  $match[0] ) )]
                                       : "<font color=#ff0000>$match[0]</font>")       ; // nome
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
		
		$debug .= "<PRE>
de: $de
para: $para
titulo: ".$titulo."
corpo: ".$corpo."
		
		
header: $headers</PRE> ";

                
               echo "\n".$debug;
                
		//mail($para, $titulo, $corpo, $headers);
                
                
                return $debug;
	}
	
	function notif_entrandoposto($idprocesso, $idposto)
	{	
            echo " \n Entrando no Posto $idposto " ;
               
            if ($idposto > 0){
                
                
            
                $this->idprocesso= $idprocesso;
                // puxa dados do posto atual
                $data2 = $this->posto->LoadCampos($idposto, $this->idprocesso );
                //echo " \n vardump do retorno ".$this->idposto."\n ";
                //var_dump($data2);


                //foreach ($data2["DADOS_POSTO"] [avanca_processo] as $avanca_processo)
                    {
                        
                     if ($data2["DADOS_POSTO"] [notif_entrandoposto] > 0 )
                     {
                        // puxa dados do proximo posto
                       // $data = $this->posto->LoadCampos($avanca_processo, $idprocesso,"entrando" );
                       // var_dump($data);
                //	echo "\n avanca ".$data["DADOS_POSTO"] [avanca_processo] ."\n";

                    
                            $titulo = $this->TraduzirEmail($data2["DADOS_POSTO"] [titulo], $data2);
                            $corpo = $this->TraduzirEmail($data2["DADOS_POSTO"] [corpo], $data2);
                            $de = $this->TraduzirEmail($data2["DADOS_POSTO"] [de], $data2);
                            $para = $this->TraduzirEmail($data2["DADOS_POSTO"] [para], $data2);

                            //var_dump($data);
                            return $this->EnviaEmail($de, $para, $titulo, $corpo);
                                       
                    }

                }
            }    
	}
	
	function  notif_saindoposto( $idprocesso,   $idposto )
	{
           echo " \n Saindo no Posto $idposto " ;
               
            // puxa dados do posto atual
            $data_atual = $this->posto->LoadCampos($idposto , $idprocesso , "saindo", 1, "TODOS");
            $this->idprocesso = $idprocesso;
       //   var_dump($data_atual);
            if ( $data_atual["DADOS_POSTO"] [notif_saindoposto]   > 0 )
            {
            
            //    foreach ($data_atual["DADOS_POSTO"] [avanca_processo] as $avanca_processo)
                {
                       // if ($avanca_processo >0)
                        {
                            
                              //echo "\n $avanca_processo , $idprocesso , saindo, $debug, TODOS"; 
                            // posto que esta indo
                             // $data = $this->posto->LoadCampos( $avanca_processo , $idprocesso , "saindo", 1, "TODOS");
                            //var_dump($data);
                              //$debug = 1;
                              // posto que esta no momento
                            //  $data_atual=  $this->posto->LoadCampos( $idposto , $idprocesso , "saindo", $debug, "TODOS");

                              

                                  $titulo = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [titulo], $data_atual);
                                  $corpo = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [corpo], $data_atual);
                                  $de = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [de], $data_atual);
                                  $para = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [para], $data_atual);
                                  
                                 
                                  return $this->EnviaEmail($de, $para, $titulo, $corpo);
                               
                        }

                }


            }
             
	}
        
        
        
        function LoadCampos($idnotificacao)
        {
            
            //buscando dados do posto
            $sql ="Select * FROM notificacoes_email WHERE id =  $idnotificacao  ";
            //echo $sql;
            $this->con->executa($sql);

            $p=0;
            while ($this->con->navega($p)){

  
                $array  [de]  = $this->con->dados["de"];
                $array  [para]  = $this->con->dados["para"];
                $array  [titulo]  = $this->con->dados["titulo"];
                $array [corpo]  = $this->con->dados["corpo"];
                
                $p++;
            }
            return $array;
        }
        function notifica_sla_vencido($idsla,   $idnotificacao, $chave)
	{	
          echo "<BR> id notificacao:$idnotificacao"
                . "<BR> SLA $idsla "
                      . "<BR> idprocesso $idprocesso "
                  . "<BR> Chave $chave <BR> "     ;
          
            // puxa dados da notificacao
            $dados_notificacao = $this->LoadCampos($idnotificacao);
          // echo "<Pre>"; var_dump($dados_notificacao);   echo "</Pre>";      
            // puxa dados do posto atual
            $data_atual = $this->LoadbyChave($chave, $idsla);
                
                
         //  echo "<Pre>"; var_dump($data_atual);   echo "</Pre>";
           //exit;
         
            $titulo = $this->TraduzirEmail($dados_notificacao  [titulo], $data_atual);
            $corpo = $this->TraduzirEmail($dados_notificacao [corpo], $data_atual);
            $de = $this->TraduzirEmail($dados_notificacao  [de], $data_atual);
            $para = $this->TraduzirEmail($dados_notificacao  [para], $data_atual);
 
            $this->registranotificacao($idsla,   $idnotificacao, $chave);
            return $this->EnviaEmail($de, $para, $titulo, $corpo);
         
 
	}
        
        function registranotificacao( $idsla,   $idnotificacao, $chave)
	{	
            
                $sql = "select  *
                        from sla s
                               left join sla_notificacoes sn ON (sn.idsla = s.id)
                        where s.id=$idsla and sn.chave=  CAST ( $chave AS VARCHAR)   and NOW() < (sn.datanotificacao+CAST(s.sla_emhorascorridas || ' minutes' AS INTERVAL))   " ;
             
               $this->con->executa( $sql);
                 
               if ($this->con->nrw==0)
               {          
                     echo "<BR> Notificacao registrada: idsla $idsla,  idnotif $idnotificacao, chave $chave";
                    $sql ="insert into sla_notificacoes ( idsla, datanotificacao, chave) values ($idsla,  NOW(), $chave) ";
                    $this->con->executa($sql);
               }
             
	}
	
	
 	 	
}