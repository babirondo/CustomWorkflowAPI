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

                
 	
	function SalvarHistorico($idprocesso, $idposto , $idworkflowtramitacao_original ){

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

                    $sql =  "select posto_final, penultimo_posto, rp.avanca_processo, wp.starter
                            from workflow_postos wp
                                inner join relacionamento_postos rp ON (rp.idposto_atual = wp.id)
                                inner join workflow w ON (w.id = wp.id_workflow)
                            where wp.id=$idposto and rp.avanca_processo = '$proximos_posto' ";
                    echo "Buscando informacoes de posto final, penultimo, proximo posto e starter = $sql\n";
                    $this->con->executa(   $sql, null, __LINE__);
                    $this->con->navega(0);
                    
                    $idposto_final = $this->con->dados["posto_final"];
                    $idposto_penultimo  = $this->con->dados["penultimo_posto"];
                    $avanca_processo = $this->con->dados["avanca_processo"];
                    $starter = $this->con->dados["starter"];

                    if ($starter){
                        echo "É um posto iniciador \n";
                        $sql = "INSERT INTO workflow_tramitacao (idprocesso, idworkflowposto, inicio, fim )
                                                VALUES( /*1*/ $idprocesso, $idposto, NOW() , NOW()  ) 
                                RETURNING id";

                       if (  $this->con->executa( $sql , 1 , __LINE__) === false )
                           $erro = 1;
                       else{
                           $idtramitacao =  $this->con->dados["id"];
                           $tipoprocesso_jacriado[$idtpproc] = $idprocesso;

                            echo "Tramitacao criada:   ".$this->con->dados["id"]." \n";

                            $this->notificacoes->notif_saindoposto($idprocesso, $idposto, $avanca_processo);
                       }    
                    }

                    if ($avanca_processo >0 ){
                        echo "É um posto que avança o processo \n";
                        $sql = "INSERT INTO workflow_tramitacao (idprocesso, idworkflowposto, inicio )
                                                VALUES( /*2*/ $idprocesso, $avanca_processo, NOW()   )	 
                                    RETURNING id" ;
                        if (  $this->con->executa( $sql , 1 , __LINE__) === false )
                            $erro = 1;
                        else{
                            echo "Tramitacao de chegada no novo posto criada: ".$this->con->dados["id"]."\n";

                            $this->notificacoes->notif_entrandoposto($idprocesso , $avanca_processo);

                            echo "Alterando processo para Em Andamento \n";
                            $sql =  "UPDATE processos SET status = 'Em Andamento' WHERE id  = $idprocesso  ";
                            $this->con->executa(   $sql, null, __LINE__);
                        }    
                    }

                    if ($idworkflowtramitacao_original)
                    {
                        echo "É uma alteracao de dado já cadastrado antes \n";

                        echo "Buscando dados de postos anterior e do posto \n";

                        /// checando se pode fechar posto de entidade diferente
                        $sql = "select tp.id
                        from workflow_postos wp
                        left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                        where wp.id  = $idposto";

                        $this->con->executa($sql, null, __LINE__ );
                        $this->con->navega(0);
                        $idtipoprocess_posto = 	$this->con->dados["id"];

                        $sql = "select  tp.id, wp.id idpostoanterior
                                        from workflow_tramitacao wt
                                                inner join workflow_postos wp ON (wp.id = wt.idworkflowposto)
                                                left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                                        where wt.id = $idworkflowtramitacao_original ";
                        echo " \n  $sql \n";
                        $this->con->executa( $sql, null, __LINE__);
                        $this->con->navega(0);

                        $idtipoprocess_processo = 	$this->con->dados["id"];
                        $idpostoanterior = 	$this->con->dados["idpostoanterior"];

                        if ($avanca_processo >0 ){
                            echo "Avanca Processo ?  ($idtipoprocess_posto == $idtipoprocess_processo) || ($idtipoprocess_posto && !$idtipoprocess_processo )  \n";
                            
                            //TODO
                           // $todas_as_entidades_filhas_fechadas=1;
                            
                            
                            //incluir controle aqui de todos as entidades filhas ja finalizaram pra fechar a mae
                            if ( ($idtipoprocess_posto == $idtipoprocess_processo) 
                              || ($idtipoprocess_posto && !$idtipoprocess_processo )
                              || ($todas_as_entidades_filhas_fechadas == 1 )
                               )
                            //if (($idtipoprocess_posto && !$idtipoprocess_processo ))
                            {
                                
                                //se mesma entidade, fechando o posto
                                $sql =  " UPDATE workflow_tramitacao SET /*3*/ fim = NOW() WHERE id  = $idworkflowtramitacao_original  ";

                                echo "Alterando dados na base = $sql \n";
                                
                                $this->con->executa(   $sql, null, __LINE__);

                                echo "Notificando saida de posto ($idprocesso, $avanca_processo, $idpostoanterior) \n";
                                $this->notificacoes->notif_saindoposto($idprocesso, $avanca_processo, $idpostoanterior);

                            }
                        }
                    }

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
                        
                }
            }
            echo "Verificando se existem proximos postos....". COUNT($proimos_postos)." \n";
            
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
            $idprocesso_original = $json[processo][valor];
            $erro = 0;

            $id_pai = "null";
            echo "\n iniciando rotina de controle de criacao de processo ";

            if ($idposto && $json[processo][valor] ) 
            {
                $sql = "select tp.id, rp.avanca_processo, wp.tipodesignacao
                        from workflow_postos wp
                            inner join relacionamento_postos rp ON (rp.idposto_atual = wp.id)
                            left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                        where wp.id  = $idposto and rp.avanca_processo = $proximo_posto ";
                echo "\n tem idposto e idprocesso do json  $sql ";

                $this->con->executa($sql, null, __LINE__ );
                $this->con->navega(0);
                $idtipoprocess_posto = 	$this->con->dados["id"];
                $avanca_processo = 	$this->con->dados["avanca_processo"];

                $sql = "select idtipoprocesso from processos where id = ".$json[processo][valor];
                $this->con->executa( $sql, null, __LINE__);
                $this->con->navega(0);
                $idtipoprocess_processo = 	$this->con->dados["idtipoprocesso"];

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
                echo "\n IDados do Posto: $sql  ";
                $this->con->navega(0);
                $avanca_processo = 	$this->con->dados["avanca_processo"];
                $idposto_inicial = $this->con->dados["posto_inicial"];
                              
              //  if ($idposto == $this->con->dados["posto_inicial"])
                    // no caso do posto inicial, a tratativa é diferente
                    $idtpproc = $this->con->dados["idtipoprocesso_atual"];
               // else
               //     $idtpproc = $this->con->dados["idtipoprocesso"];
                
                $idwok = $this->con->dados["id_workflow"];
                //$regra_finalizacao = 	$this->con->dados["regra_finalizacao"];

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

                if (!$tipoprocesso_jacriado[$idtpproc]){
                    echo "\n Processo ainda nao criado  \n ";

                    //while ($idtipoprocess_posto != $idtipoprocess_processo && $idtipoprocesso_dopai != $idtipoprocess_posto  )
                    if ($id_pai> 0 && $idtipoprocess_posto != $idtipoprocess_processo)
                    {
                            // se um posto criar uma entidade de mais de um nivel abaixo, entra aqui e cria as entidades
                        /// para preservar o relacionamento
                        
                        // TODO, fazer ficar dinamico... por enquanto só completa um nivel
                        echo "\n WHILE - tipo de processo do posto != tipo process do processo =  $idtipoprocess_posto  != $idtipoprocess_processo";
                        // $id_pai 1
                        $sql = "INSERT into processos (idpai, idtipoprocesso, inicio, idworkflow)
                                values 
                                ( $id_pai,  (select id from tipos_processo where id = (
                                select  id_pai from tipos_processo where id =$idtpproc ) ) , NOW(), $idwok)  
                                  RETURNING idtipoprocesso, id ";
                        if ($this->con->executa( $sql, 1, __LINE__) === true){
                            //$this->con->navega(0);   

                            $idtipoprocess_processo = $this->con->dados["idtipoprocesso"];
                            $id_pai = $this->con->dados["id"];
                            $idtipoprocesso_dopai  = $this->con->dados["idtipoprocesso"];
                        
                        }
                        //else 
                        //    break;
                    }
                    
                    
                    if ($id_pai > 0){
                        echo "\n ID_PAI existente  \n ";

                        $sql = "select 1 cria_processo from tipos_processo where id= $idtpproc and id_pai=
                                    (select idtipoprocesso from processos where id = $id_pai)";
                       // echo " \n $sql \n";
                        $this->con->executa( $sql, null, __LINE__);
                        $this->con->navega(0);   

                        $cria_processo = $this->con->dados["cria_processo"];
                    }
                    if ($idposto_inicial == $idposto ) $cria_processo=1;

                    echo "Cria o Processo (criaprocesso=$cria_processo , IDPAI=$id_pai) \n ";
                    if ($cria_processo == 1 ){
                        echo " \n Tipo de Processo $idtpproc , IDPAI $id_pai \n ";

                        $sql = "INSERT INTO  processos (idtipoprocesso, idpai, inicio, idworkflow, regra_finalizacao)
                               VALUES ( /*aqui*/ $idtpproc   ,$id_pai, NOW() , $idwok, '$regra_finalizacao' )
                               RETURNING id ";
                      // echo $sql." \n";
                       if (  $this->con->executa( $sql , 1 , __LINE__) === false )
                           $erro = 1;
                       else{
                           $idprocesso =  $this->con->dados["id"];
                           $tipoprocesso_jacriado[$idtpproc] = $idprocesso;

                           echo "Processo criado com sucesso: $idprocesso. Tipo de Processo: $idtpproc \n ";
                       }   
                   }
                    else
                        $idprocesso = $id_pai;
                }
                else
                    $idprocesso = $tipoprocesso_jacriado[$idtpproc] ;
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
        
        function SalvarnoBanco($json, $idposto, $origem  , $app)
        {
            echo "\n Iniciando Salvar dados do Form \n";
            var_dump($json);
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
                foreach ($proximos_postos as $proximos_posto) 
                {
                    echo "Controla Criacao de Processo idposto=$idposto, proximo_posto =$proximos_posto \n ";
                    $idprocesso = $this->ControlaCriacaoProcesso($json,$idposto, $proximos_posto);
                    //$this->AutoAssociarProcessonoPosto();                        
                } 
            } 
            else
                $idprocesso = $json[processo][valor];

            echo "idprocesso: $idprocesso \n ";

            if (!$idprocesso) die("Id Processo nulo");   
            
           
            echo "Faz HandOver ? ....";
            // se HandOver, movimenta o historico
            if ($json[processo][acao] == "Salvar e Avançar >>>")
            { 	  
                echo " OK \n";
                $this->SalvarHistorico($idprocesso, $idposto, $json[processo][idworkflowtramitacao_original]);
            }
            else
                echo " FALSO \n";
 
            

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