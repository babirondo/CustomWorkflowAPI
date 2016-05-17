<?php
//set_time_limit(2);
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Workflow{
	function Workflow( ){
		
            require_once("classes/globais.php");
                  
            require_once("classes/class_postos.php");
            require_once("classes/class_campo.php");
            require_once("classes/class_db.php");
            require_once("classes/class_notificacoes.php");
            //require_once("classes/class_auxiliar.php");

            $this->con = new db();
            $this->con->conecta();		

            $this->posto = new Postos();
            $this->campos = new Campos();
            $this->notificacoes = new Notificacoes();
            //$this->auxiliar = new Auxiliar();
            $this->globais = new GLobais();
            
            $this->idposto = null;
            $this->idprocesso = null;
            $this->debug = null;
	}
	
        function DesassociarRegistronoPosto($jsonRAW, $idposto){
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
         
            $this->con->executa( "delete from workflow_dados where id = '".$json[$this->globais->SYS_DEPARA_CAMPOS["Responsável"]][idworkflowdado]."'", null, __LINE__);
        }

                
 	
	function    SalvarHistorico($idprocesso, $idposto , $idworkflowtramitacao_original, $proximo_posto ){
                echo "\n >>>>>>>>>> Criando historico de movimentação normal do processo $idprocesso.   ";

                                /*

            //verifica se existem proximos postos a partir do atual
            $sql = "select avanca_processo
                    from RELACIONAMENTO_POSTOS 
                    where idposto_atual= $idposto";
            echo "Iniciando salvar dados do form = $sql\n";
            $this->con->executa($sql , null, __LINE__);

            while ($this->con->navega(0))
                $proximos_postos [ $this->con->dados["avanca_processo"]]  = $this->con->dados["avanca_processo"];
            
            echo "Verificando se existem proximos postos....". COUNT($proximos_postos)." \n";
            if (is_array($proximos_postos))
            {
                foreach ($proximos_postos as $proximos_posto) 
                {
                    echo "\n Inicio de loop - Proximo posto \n";
                    $this->idposto = $idposto;
                    $this->idprocesso = $idprocesso;

                    //TODO trocar starter por workflow.posto_inicial e remover campo starter da table wp
*/
                        
                    $sql =  "select  rp.avanca_processo, wp.starter 
             -- posto_final, penultimo_posto,  
              
                            from workflow_postos wp
                                inner join relacionamento_postos rp ON (rp.idposto_atual = wp.id)
                                inner join workflow w ON (w.id = wp.id_workflow)
                            where wp.id=$idposto  and rp.avanca_processo = $proximo_posto  ";
                    //echo "\n Buscando informacoes de posto final, penultimo, proximo posto e starter = $sql\n";
                    $this->con->executa(   $sql, null, __LINE__);
                    $this->con->navega(0);
                    
                   // $idposto_final = $this->con->dados["posto_final"];
                   // $idposto_penultimo  = $this->con->dados["penultimo_posto"];
                    $avanca_processo = $this->con->dados["avanca_processo"];
                    $starter = $this->con->dados["starter"];

                    if ($starter){
                        $c1 = " , fim";
                        $c2 = " , NOW()" ;
                    }

                    

                  //  if ($avanca_processo >0 ){
                        
                        // idprocesso de escrita do posto
                      //  echo "\n É um posto que avança o processo \n";
                        $sql = "INSERT INTO workflow_tramitacao (idprocesso, idworkflowposto, inicio  $c1 )
                                VALUES( /*2*/ $idprocesso, $idposto, NOW()   $c2 )	 
                                RETURNING id" ;
                        if (  $this->con->executa( $sql , 1 , __LINE__) === false )
                            $erro = 1;
                        else{ 
                            echo "\n Tramitacao de chegada no novo posto criada: ".$this->con->dados["id"]." ( idprocesso $idprocesso idposto $idposto) \n";

                            //$this->notificacoes->notif_entrandoposto($idprocesso , $avanca_processo);

                            echo "Alterando processo para Em Andamento \n";
                            $sql =  "UPDATE processos SET status = 'Em Andamento' WHERE id  = $idprocesso  ";
                            $this->con->executa(   $sql, null, __LINE__);
                        }    
                  //  }

                        
                        /*
                    echo "Checkando se a movimentacao encerra o processo ...";
                    //finalizando o status de um processo
                    if ($idposto_final == $avanca_processo && $avanca_processo > 0){
                        echo "Encerra \n";
                        if ( $idposto_penultimo == $idpostoanterior)
                            $sql =  "UPDATE processos SET status = 'Concluído' WHERE id  = $idprocesso  ";
                        else
                            $sql =  "UPDATE processos SET status = 'Arquivado' WHERE id  = $idprocesso  ";
                        $this->con->executa(   $sql, null, __LINE__);				
                    }
                    else
                        echo "Nao Encerra \n";
                     */   
                        
                //}
            //}
            

            /*            
            //salvar historico de posto que nao tem proximo
            if ($idworkflowtramitacao_original)
            {
                //se mesma entidade, fechando o posto
                $sql =  " UPDATE workflow_tramitacao SET   fim = NOW() WHERE id  = $idworkflowtramitacao_original  ";
                echo "Finalizando posto $idposto , idworkflowtramitacao =  $idworkflowtramitacao_original \n";
               // $this->con->executa(   $sql, null, __LINE__);
               // $this->notificacoes->notif_saindoposto($idprocesso, $avanca_processo, $idpostoanterior);

                        
                
            }  
            */
                        
            echo "\n  ";
	}
	
	
	function getWorkflows($app ){
	
		$this->con->executa( "Select * from workflow", null, __LINE__);
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
            echo "\n idposto $idposto";
            $this->SalvarnoBanco(  $json , $idposto, "Salvando", $app); // indo array ?

    
	}
        
        
        function AutoAssociarProcessonoPosto() 
        {
            if ($origem  == "Salvando")
            {

                IF ($tipodesignacao)
                {
                    //rotina de associação
                    $this->Posto_Usuario = new Posto_Usuario();

                    switch ($tipodesignacao){
                        CASE("AUTO-DIRECIONADO"):
                            $usuarios = $this->posto->getUsuarios($avanca_processo);

                            $associarRegistro [ $this->globais->SYS_DEPARA_CAMPOS["Responsável"] ][valor]  = array_rand($usuarios["USUARIOS_POSTO"][$avanca_processo],1);
                            $associarRegistro [$this->globais->SYS_DEPARA_CAMPOS["Responsável"]]["idworkflowdado"]  = null ;
                            $associarRegistro [processo][valor]  = $idprocesso;	

                        //    $this->Posto_Usuario->AssociarProcessonoPosto($app, json_encode($associarRegistro) , $avanca_processo );
                        BREAK;
                    }
                }
            } 
            
        }
        
        
        function ControlaCriacaoProcesso($json , $idposto, $proximo_posto)
        {
             echo "\n Iniciando Salvar dados do Form \n";
            // var_dump($json);
            // identifica quais os proximos postos a partir do atual
            $sql = "select avanca_processo
                    from RELACIONAMENTO_POSTOS 
                    where idposto_atual= $idposto";
            $this->con->executa($sql , null, __LINE__);

            while ($this->con->navega(0)) {
                if ($this->con->dados["avanca_processo"]>0)
                    $proximos_postos [ $this->con->dados["avanca_processo"]]  = $this->con->dados["avanca_processo"];
            }
             
            // para os proximos postos, verifica se é preciso criacao de processos
            if (is_array($proximos_postos))
            {
                echo "\n Salvando ".count($proximos_postos)." postos\n";
                $idprocesso_original = $json[processo][valor];
                
                foreach ($proximos_postos as $proximo_posto) 
                {
                     // 8***** INcluido rotina de criacao de processo e historico
                    
                    
                      $erro = 0;

                      //$id_pai = "null";
                      echo "\n )))))))))))))))))) iniciando rotina de controle de criacao de processo ";

                      if ($idposto && $json[processo][valor] ) 
                      {
                          $sql = "select tp.id, rp.avanca_processo, wp.tipodesignacao, tp.id_pai
                                  from workflow_postos wp
                                      inner join relacionamento_postos rp ON (rp.idposto_atual = wp.id)
                                      left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                                  where wp.id  = $idposto and rp.avanca_processo = $proximo_posto ";
                          echo "\n tem idposto e idprocesso do json    ";

                          $this->con->executa($sql, null, __LINE__ );
                          $this->con->navega(0);
                          $idtipoprocess_posto = 	$this->con->dados["id"];
                          $avanca_processo = 	$this->con->dados["avanca_processo"];
                          $idtipopai_posto = 	$this->con->dados["id_pai"];


                          $sql = "select p.idtipoprocesso, tp.id_pai 
                                  from processos p
                                      inner join tipos_processo tp ON (tp.id = p.idtipoprocesso)
                                  where p.id = ".$json[processo][valor];
                         // echo $sql;
                          $this->con->executa( $sql, null, __LINE__);
                          $this->con->navega(0);
                          $idtipoprocess_processo = 	$this->con->dados["idtipoprocesso"];

                          /*
                          if ($avanca_processo){
                              $sql = "select   wp.tipodesignacao
                                      from workflow_postos wp

                                          left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                                      where wp.id  = $avanca_processo    ";
                              $this->con->executa( $sql, null, __LINE__);
                             //  echo "\n $sql";
                              $this->con->navega(0);
                              $tipodesignacao = 	$this->con->dados["tipodesignacao"];
                          }
                          */

                          echo "\n tipo de processo do posto != tipo process do processo =  $idtipoprocess_posto != $idtipoprocess_processo ";

                          if ( $idtipoprocess_posto != $idtipoprocess_processo){
                              $id_pai = $json[processo][valor];
                              $json[processo][valor] = null;
                          }
                          else 	
                              $idprocesso = $json[processo][valor];	
                      }

                      if ( !$json[processo][valor]    )  
                      {
                          // criar processo

                          echo "\n Id Processo do JSON vazio  ";
                          $sql = "select wp2.id idtipoprocesso, wp.id_workflow, rp.avanca_processo, 
                                          wp.idtipoprocesso idtipoprocesso_atual,
                                          wp.tipodesignacao, wp.regra_finalizacao, w.posto_inicial
                                  from workflow_postos wp
                                      inner join relacionamento_postos rp ON (rp.idposto_atual = wp.id)
                                      inner join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                                      inner join workflow_postos wp2 ON (wp2.id = wp.avanca_processo)
                                      inner join workflow w ON (w.id = wp.id_workflow)
                                  where wp.id = $idposto and rp.avanca_processo = $proximo_posto";

                          $this->con->executa( $sql , null, __LINE__);
                       //   echo "\n IDados do Posto:    ";
                          $this->con->navega(0);

                          $avanca_processo = 	$this->con->dados["avanca_processo"];
                          $idposto_inicial = $this->con->dados["posto_inicial"];
                          $idtpproc = $this->con->dados["idtipoprocesso_atual"];
                          $idtpproc_proximo = $this->con->dados["idtipoprocesso"];
                          $idwok = $this->con->dados["id_workflow"];

                          /*
                          $sql = "select   wp.tipodesignacao 
                                  from workflow_postos wp

                                      left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                                  where wp.id  = $avanca_processo";
                          $this->con->executa( $sql, null, __LINE__);
                         //  echo "\n $sql";
                          $this->con->navega(0);
                          $tipodesignacao = $this->con->dados["tipodesignacao"];
                          */


                          echo "\n Processo ainda nao criado  \n ";


                          //while ($idtipoprocess_posto != $idtipoprocess_processo && $idtipoprocesso_dopai != $idtipoprocess_posto  )
                          if ($id_pai> 0 && $idtipoprocess_posto != $idtipoprocess_processo)
                          {
                              echo "\n WHILE -  $idtipoprocess_posto  != $idtipoprocess_processo  ";

                        


                              if (!$jacriou[$idtipopai_posto])
                              {
                                  echo "\n Processo do tipo  $idtipopai_posto da processo $idprocesso_original NÃO existe ";

                                  //cria o pai do processo que nao existe
                                  // se um posto criar uma entidade de mais de um nivel abaixo, entra aqui e cria as entidades
                                  /// para preservar o relacionamento


                                  // TODO, fazer ficar dinamico... por enquanto só completa um nivel
                                  // $id_pai 1

          /*
                              $sql = "select id_pai from tipos_processo where id = (select idtipoprocesso
                                  from workflow_postos wp 
                                  where wp.id= $proximo_posto )";
                              $this->con->executa( $sql , null, __LINE__);
                              $this->con->navega(0);


                              echo  "\n ".$this->con->dados["id_pai"]." == $idtipopai_posto";
            */

                              //if ($this->con->dados["id_pai"] == $idtipopai_posto)
                              {

                                  echo "\n **((** Processo do tipo  $idtipopai_posto da processo $idprocesso_original = criado   ";
                                  $id_pai = $this->CriarProcesso($idtipopai_posto, $id_pai, $idwok, $json, $proximo_posto, $proximo_posto );
                                  echo "  $id_pai ";

                                  if ($json[processo][acao] == "Salvar e Avançar >>>")
                                  { 	  
                                      //$this->SalvarHistorico($id_pai, $idposto, $json[processo][idworkflowtramitacao_original], $proximo_posto);
                                  }
                                  $jacriou[$idtipopai_posto] = $id_pai;

                                  $id_processo =null;

                                  //else 
                                  //    break;
                                  $cria_processo = 1;
                              }

                              }
                              else {
                                  $id_pai = $jacriou[$idtipopai_posto];//$this->con->dados["id"];
                                  echo "\n Processo do tipo  $idtipopai_posto da processo $idprocesso_original  EXISTE =  $id_pai";
                                  $cria_processo = 1;


                              }

                          }


                        
                              if ($id_pai > 0){
                                  echo "\n ID_PAI existente  \n ";

                                  $sql = "select 1 cria_processo from tipos_processo where id= $idtpproc and id_pai=
                                              (select idtipoprocesso from processos where id = $id_pai)";
                                 echo " \n $sql \n";
                                  $this->con->executa( $sql, null, __LINE__);
                                  $this->con->navega(0);   

                                  $cria_processo = $this->con->dados["cria_processo"];
                                  echo "\n Movimento regular para tramitacao: ".$cria_processo;

                              }
                              

                              if ($idposto_inicial == $idposto ) {
                                  // starter
                                  echo " \n Processo Starter  :   ";
                                  $id_pai = $this->CriarProcesso($idtpproc, $id_pai, $idwok, $json, $idposto,  $proximo_posto);   
                                  echo " $id_pai  ";


                                  if ($json[processo][acao] == "Salvar e Avançar >>>")
                                  { 	  
                                      // cria proximo posto em branco ja que o inicial ja nasce fechado
                                      $this->SalvarHistorico($id_pai, $proximo_posto, null, $proximo_posto);

                                  }
                                  //$cria_processo=1;
                              }

                              if ($cria_processo == 1 )
                              {

                                  echo " \n Processo criado (cria_processo==1):    ";
                                  $idprocesso = $this->CriarProcesso($idtpproc, $id_pai, $idwok, $json, $proximo_posto, $proximo_posto );   
                                  echo "  $idprocesso  ";

                                   if ($json[processo][acao] == "Salvar e Avançar >>>")
                                  { 	  
                                      $this->SalvarHistorico($idprocesso, $proximo_posto, $json[processo][idworkflowtramitacao_original], $proximo_posto);
                                  }

                              }
                              else $idprocesso = $id_pai;

                      }                    

                    //$this->AutoAssociarProcessonoPosto();                        
                } // fim for each
            } 
            else{
                $idprocesso = $json[processo][valor];
                // caso o handover seja em posto sem destino ou posto finalizador
                echo "\n handover sem destino";
                $this->HandoverSemDestino( $json[processo][idworkflowtramitacao_original] );

            }


            
            
            
            
            
            //legado **********************************************************************
          
            return $idprocesso;
        }
        
        function CriarProcesso($idtpproc, $id_pai, $idwok, $json, $idposto, $proximo_posto )
        {
            echo "\n\n\n Criando Processo:  
TIpo de Processo:$idtpproc
IDPAI: $id_pai
IDPOSTO: $idposto
PROXIMO POSTO: $proximo_posto
IDPROCESSO: $idprocesso \n ";

            $sql = "INSERT INTO  processos (idtipoprocesso, idpai, inicio, idworkflow )
                    VALUES ( /*aqui*/ $idtpproc   ,$id_pai, NOW() , $idwok )

                    RETURNING idtipoprocesso, id       ";
           // echo $sql." \n";
            if (  $this->con->executa( $sql , 1 , __LINE__) === false )
               return false;
            else{
                $idprocesso =  $this->con->dados["id"];
                $tipoprocesso_jacriado[$idtpproc] = $idprocesso;
                echo "Processo criado com sucesso: $idprocesso. Tipo de Processo: $idtpproc \n ";
            }

             return $idprocesso;

        }
        
        function registraDadosdoPosto($valor, $idposto, $idprocesso, $campo)
        {
            //TODO nÃo está dando load nos salvos no posto
            if ( $valor["idworkflowdado"] > 0 )
            {
                if (!$this->con->executa( "UPDATE workflow_dados SET valor = '".$valor[valor]."' WHERE id  ='".$valor[idworkflowdado]."'" , null, __LINE__ ))
                $erro++;
            }
            else
            {
                if (!$this->con->executa( "INSERT INTO workflow_dados (idpostocampo, valor, idprocesso, registro, idposto)
                                        VALUES (/*4*/ '$campo','$valor[valor]', $idprocesso, NOW(), $idposto)  " , null, __LINE__ ))    
                $erro++;
            }

        }
        
        
        function HandoverSemDestino( $idtramitacao )
        {
         //  $idtramitacao 
            echo "\n Dentro do handover sem destino";
            
            $sql =  " UPDATE workflow_tramitacao SET   fim = NOW() WHERE id  = $idtramitacao returning idworkflowposto ";
            $this->con->executa(   $sql, 1, __LINE__);
            //$this->notificacoes->notif_saindoposto($idprocesso, $avanca_processo, $idpostoanterior);

            echo " \n Finalizando posto ".$this->con->dados["idworkflowposto"]."  , idworkflowtramitacao =  $idtramitacao \n";
            
        }
        
        function SalvarnoBanco($json, $idposto, $origem  , $app)
        {
            
            $idprocesso = $this->ControlaCriacaoProcesso($json,$idposto, $proximos_posto);
            /*
            
            echo "\n Iniciando Salvar dados do Form \n";
            // var_dump($json);
            // identifica quais os proximos postos a partir do atual
            $sql = "select avanca_processo
                    from RELACIONAMENTO_POSTOS 
                    where idposto_atual= $idposto";
            $this->con->executa($sql , null, __LINE__);

            while ($this->con->navega(0)) {
                if ($this->con->dados["avanca_processo"]>0)
                    $proximos_postos [ $this->con->dados["avanca_processo"]]  = $this->con->dados["avanca_processo"];
            }
             
            // para os proximos postos, verifica se é preciso criacao de processos
            if (is_array($proximos_postos))
            {
                echo "\n Salvando ".count($proximos_postos)." postos\n";
                
                foreach ($proximos_postos as $proximos_posto) 
                {
                    echo "\n\n ============ Controla Criacao de Processo idposto=$idposto, proximo_posto =$proximos_posto \n ";
                    $idprocesso = $this->ControlaCriacaoProcesso($json,$idposto, $proximos_posto);
                    //$this->AutoAssociarProcessonoPosto();                        
                } 
            } 
            else{
                $idprocesso = $json[processo][valor];
                // caso o handover seja em posto sem destino ou posto finalizador
                echo "\n handover sem destino";
                $this->HandoverSemDestino( $json[processo][idworkflowtramitacao_original] );

            }

            echo "\n idprocesso - funcao salvar no banco: $idprocesso \n ";
            */
            if (!$idprocesso) die("Id Processo nulo");   
            
           
            /*
            echo "Faz HandOver ? ....";
            // se HandOver, movimenta o historico
            if ($json[processo][acao] == "Salvar e Avançar >>>")
            { 	  
                echo " OK \n";
                $this->SalvarHistorico($idprocesso, $idposto, $json[processo][idworkflowtramitacao_original]);
            }
            else
                echo " FALSO \n";
 */
            

            // Registra os dados que foram submetidos no form
            $valor=null;
            echo "Iniciando gravacao dos dados do form ~ ".count($json)." \n  [";
 	    foreach ($json as $campo => $valor){
 	    	if ($campo == "processo") continue;
                echo ".";
 	        
                $this->registraDadosdoPosto($valor, $idposto, $idprocesso, $campo);
 	    }
            echo "] \n";
                            
 	    
            echo " FIM \n";
            //finalizacao do json
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