<?php
namespace raiz;
set_time_limit(2);
//error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Engine{
	function __construct( ){

	  require_once("classes/globais.php");

	  require_once("classes/engine/class_engine_feature.php");
	  require_once("classes/class_campo.php");
	  require_once("classes/class_db.php");
	  require_once("classes/class_notificacoes.php");
	  //require_once("classes/class_auxiliar.php");

	  $this->con = new db();
	  $this->con->conecta();

	  $this->feature = new Engine_Feature();
	  $this->campos = new Campos();
	  $this->notificacoes = new Notificacoes();
	  //$this->auxiliar = new Auxiliar();
	  $this->globais = new GLobais();

	  $this->idfeature = null;
	  $this->idprocesso = null;
	  $this->debug = null;



	}

/*
        function DesassociarRegistronofeature($jsonRAW, $idfeature){
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
            // var_dump($json);

            $this->con->executa( "update   workflow_tramitacao set id_usuario_associado = null where id = '".$json[$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]][idtramitacao]."'", null, __LINE__);
        }

        function AssociarRegistronofeature($jsonRAW, $idfeature){
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
            //var_dump($json);
						if ($json[$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]][valor] > 0)
						{
							// caso não haja avaliador, continua o processo.. caso contrario estava causando erro
							$sql = "update  workflow_tramitacao set id_usuario_associado = '".$json[$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]][valor]."' where id = '".$json[$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]][idtramitacao]."'";
	            $this->con->executa(    $sql, null, __LINE__);

						}
        }


	function    SalvarHistorico($idprocesso, $idfeature , $idworkflowtramitacao_original, $proximo_feature ){

                $sql =  "select  rp.avanca_processo, wp.starter


                            from workflow_features wp
                                inner join relacionamento_features rp ON (rp.idfeature_atual = wp.id)
                                inner join workflow w ON (w.id = wp.id_workflow)
                            where wp.id=$idfeature  and rp.avanca_processo = $proximo_feature  ";
                  //  echo "\n Buscando informacoes de feature final, penultimo, proximo feature e starter = $sql\n";
                    $this->con->executa(   $sql, null, __LINE__);
                    $this->con->navega(0);

                   // $idfeature_final = $this->con->dados["feature_final"];
                   // $idfeature_penultimo  = $this->con->dados["penultimo_feature"];
                    $avanca_processo = $this->con->dados["avanca_processo"];
                    $starter = $this->con->dados["starter"];

                    if ($starter){
                        $c1 = " , fim";
                        $c2 = " , NOW()" ;
                    }




                    $sql = "INSERT INTO workflow_tramitacao (idprocesso, idworkflowfeature, inicio  $c1 )
                            VALUES(   $idprocesso, $idfeature, NOW()   $c2 )
                            RETURNING id" ;
                    if (  $this->con->executa( $sql , 1 , __LINE__) === false )
                        $erro = 1;
                    else{
                      //  echo "\n Tramitacao de chegada no novo feature criada: ".$this->con->dados["id"]." ( idprocesso $idprocesso idfeature $idfeature) \n";
                        //echo " \n Entrando em novo feature de mesmo nivel";
                        $idtramitacao_criada = $this->con->dados["id"];
                        $this->AutoAssociarProcessonofeature($idprocesso, $idfeature, null, $idtramitacao_criada);

                        //$this->notificacoes->notif_entrandofeature($idprocesso , $idfeature); // funcionando
                        $this->notificacoes->notif_entrandofeature($idprocesso , $idfeature, $avanca_processo);

                        if ($starter){
                         //   echo "aa $idprocesso $idfeature $avanca_processo ";
                            $this->notificacoes->notif_saindofeature($idprocesso, $idfeature);
                        }

                       // echo "Alterando processo para Em Andamento \n";
                        $sql =  "UPDATE processos SET status = 'Em Andamento' WHERE id  = $idprocesso  ";
                        $this->con->executa(   $sql, null, __LINE__);
                    }




                 //   echo "Checkando se a movimentacao encerra o processo ...";
                    //finalizando o status de um processo
                    if ($idfeature_final == $avanca_processo && $avanca_processo > 0){
                      //  echo "Encerra \n";
                        if ( $idfeature_penultimo == $idfeatureanterior)
                            $sql =  "UPDATE processos SET status = 'Concluído' WHERE id  = $idprocesso  ";
                        else
                            $sql =  "UPDATE processos SET status = 'Arquivado' WHERE id  = $idprocesso  ";
                        $this->con->executa(   $sql, null, __LINE__);
                    }
                    //else
                      //  echo "Nao Encerra \n";


                 //   echo  "\n  chegou aqui ..... ($idworkflowtramitacao_original)";
                     //salvar historico de feature que nao tem proximo
                     if ($idworkflowtramitacao_original )
                     {
                       //  echo "\n XXXXX \n ";
                         //se mesma entidade, fechando o feature
                         $sql =  " UPDATE workflow_tramitacao SET   fim = NOW() WHERE id  = ".$idworkflowtramitacao_original ."  ";
                        // echo "Finalizando feature $idfeature , idworkflowtramitacao = ".$idworkflowtramitacao_original." \n";
                         $this->con->executa(   $sql, null, __LINE__);


                        // resolver tramitacao em idprocesso, idfeature, featureanterior
                        $sql =  "select wt.idworkflowfeature , wt.idprocesso , rp.idfeature_atual, rp.avanca_processo
                                from workflow_tramitacao wt
                                       inner join relacionamento_features rp ON (rp.idfeature_atual = wt.idworkflowfeature)
                                where wt.id =   $idworkflowtramitacao_original      ";
                        $this->con->executa(   $sql, 0, __LINE__);
                        $this->con->navega(0);

                        $this->notificacoes->notif_saindofeature($this->con->dados["idprocesso"],  $this->con->dados["idfeature_atual"] );


                     }


                //}
            //}
             return $idtramitacao_criada;
	}


	function getWorkflows($app ){

		$this->con->executa( "Select * from workflow", null, __LINE__);
		//$this->con->navega();

		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["workflow"]  = $this->con->dados["workflow"];
			$array["FETCH"][$i]["idworkflow"]  = $this->con->dados["id"];
			$array["FETCH"][$i]["featureinicial"]  = $this->con->dados["feature_inicial"];
			$i++;
		}

		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);


	}
	*/

 	function Registrar($app , $jsonRAW, $idfeature){
            $json = json_decode( $jsonRAW, true );
            IF ($json == NULL) {
                    $data = array("data"=>
                                array(	"resultado" =>  "ERRO",
                                        "erro" => "JSON zuado - $jsonRAW" )
                    );


                    $app->render ('default.php',$data,500);
                    return false;
            }

            $array = $this->SalvarnoBanco(  $json , $idfeature, "Salvando", $app); // indo array ?

            $array["resultado"] = "SUCESSO";
            $array["DEBUG"] = $this->notificacoes->debug;

            $data =  	$array;

            $app->render ('default.php',$data,200);

	}

/*
        function AutoAssociarProcessonofeature($idprocesso, $avanca_processo , $app, $idtramitacao )
        {

            $sql = "select   wp.tipodesignacao
                    from workflow_features wp

                          left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                      where wp.id  = $avanca_processo";
              $this->con->executa( $sql, null, __LINE__);
             //  echo "\n $sql";
              $this->con->navega(0);
              $tipodesignacao = $this->con->dados["tipodesignacao"];

            //rotina de associação
            $this->feature_Usuario = new feature_Usuario();

            switch ($tipodesignacao){
                CASE("AUTO-DIRECIONADO"):
                    $vida_processo = $this->feature->LoadCampos( null, $idprocesso, null, null, null );

                    $idtec = $vida_processo["FETCH"][$idprocesso][$this->globais->SYS_DEPARA_CAMPOS["Tecnologias_do_teste"]."-original"];
                    $usuarios = $this->feature->getUsuariosbyTecnologia($idtec);
                    $usuario_aleatorio = rand(0, (COUNT( $usuarios["USUARIO_TECNOLOGIA"] [$idtec])-1) );

                    $associarRegistro [ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ][valor]  =   $usuarios["USUARIO_TECNOLOGIA"] [$idtec][$usuario_aleatorio]   ;
                    $associarRegistro [$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]]["idtramitacao"]  = $idtramitacao ;
                    $associarRegistro [$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]]["idworkflowdado"]  = null ;
                    $associarRegistro [processo][valor]  = $idprocesso;
                    //echo "\n associado: $idprocesso feature: $avanca_processo usuario:  ".$associarRegistro [ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ][valor];

                    $this->feature_Usuario->AssociarProcessonofeature($app, json_encode($associarRegistro) , $avanca_processo );
                BREAK;
            }


            return $associarRegistro [ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ][valor];
        }
*/

        function ControlaCriacaoProcesso($json , $idfeature, $proximo_feature, $app)
        {
						if (!$json[processo][valor]  )
							$idprocesso = $this->CriarProcesso(  $json );
						else
							$idprocesso = $json[processo][valor];

                if (is_array($json))
                {
                      // Registra os dados que foram submetidos no form
                      $valor=null;
                      //var_dump($json);
                      //echo "Iniciando gravacao dos dados do form ~ ".count($json)." \n  [";
                      foreach ($json as $campo => $valor){
                          if ($campo == "processo") continue;
                          //echo ".";

                          $this->registraDadosdofeature($valor, $idfeature, $idprocesso, $campo, $idtramitacao_gerada);
                      }
                }

            return $idprocesso;
        }


        function CriarProcesso(  $json  )
        {


            $sql = "INSERT INTO  processos ( idtipoprocesso, idpai, inicio, idworkflow )
                    VALUES (   /*aqui*/ 5   ,null, NOW() , null )

                    RETURNING idtipoprocesso, id       ";
          //  echo "\n".$sql." \n";
            if (  $this->con->executa( $sql , 1 , __LINE__) === false )
               return false;
            else{
                $idprocesso =  $this->con->dados["id"];
                $tipoprocesso_jacriado[$idtpproc] = $idprocesso;
              //  echo "Processo criado com sucesso: $idprocesso. Tipo de Processo: $idtpproc \n ";
            }

             return $idprocesso;

        }

        function registraDadosdofeature($valor, $idfeature, $idprocesso, $campo, $idworkflowtramitacao = "null")
        {
            //TODO nÃo está dando load nos salvos no feature
            if ( $valor["idworkflowdado"] > 0 )
            {
								$sql = "UPDATE engine_dados SET valor = '".$valor[valor]."' WHERE id  ='".$valor[idworkflowdado]."'" ;
                if (!$this->con->executa(   $sql , null, __LINE__ ))
                $erro++;
            }
            else
            {
								$sql =  "INSERT INTO engine_dados (idfeaturecampo, valor, idprocesso, registro, idmenu)
                                        VALUES ( '$campo','$valor[valor]', $idprocesso, NOW(), $idfeature)  " ;
                if (!$this->con->executa( $sql , null, __LINE__ ))
                $erro++;
            }
						//echo "<br> $sql";

        }
/*

        function HandoverSemDestino( $idtramitacao )
        {
         //  $idtramitacao
            //echo "\n Dentro do handover sem destino";

            $sql =  " UPDATE workflow_tramitacao SET   fim = NOW() WHERE id  = $idtramitacao returning idworkflowfeature ";
            $this->con->executa(   $sql, 1, __LINE__);


            // resolver tramitacao em idprocesso, idfeature, featureanterior
            $sql =  "select  wt.idprocesso , rp.idfeature_atual, rp.avanca_processo, wt.idworkflowfeature
                    from workflow_tramitacao wt
                           left join relacionamento_features rp ON (rp.idfeature_atual = wt.idworkflowfeature)
                    where wt.id =   $idtramitacao      ";
            $this->con->executa(   $sql, 0, __LINE__);
            $this->con->navega(0);
           //  echo "Handover sem destino \n";
            $this->notificacoes->notif_saindofeature($this->con->dados["idprocesso"],   $this->con->dados["idworkflowfeature"]);

            // BUSCA O TIPO DE HANDOVER DO TIPO DE PROCESSO PAI
            $sql =  "select tp_pai.regra_handover
                    from workflow_tramitacao wt
                            inner join processos p ON (p.id = wt.idprocesso)
                            inner join tipos_processo tp ON (tp.id = p.idtipoprocesso)
                            inner join tipos_processo tp_pai ON (tp_pai.id = tp.id_pai)
                    where wt.id = $idtramitacao
                    ";
            $this->con->executa(   $sql, 0, __LINE__);

            $this->con->navega(0);

            switch ($this->con->dados["regra_handover"]){
                case("TODOS_FILHOS_FECHADOS"):

                $sql = "select COUNT(wt2.id) as total, COUNT(wt2.fim) as finalizados, COUNT(wt2.inicio) as inicializados
                from workflow_tramitacao wt
                        inner join processos p ON (p.id = wt.idprocesso)

                        inner join processos p_pai ON (p_pai.idpai = p.idpai)
                        inner join workflow_tramitacao wt2 ON (wt2.idprocesso = p_pai.id)

                where wt.id = $idtramitacao ";
                $this->con->executa(   $sql, 0, __LINE__);

                $this->con->navega(0);

                if ($this->con->dados["inicializados"] == $this->con->dados["finalizados"]){
                    // executa o handover do feature pai
                  //  echo "\n Todos os filhos fechados, fechar o processo pai";


                    $sql = "select p_pai.id, tp.avanca_processo_filhos_fechados
                            from workflow_tramitacao wt
                                    inner join processos p ON (p.id = wt.idprocesso)
                                    inner join processos p_pai ON (p_pai.id = p.idpai)
                                    inner join tipos_processo tp ON (tp.id = p_pai.idtipoprocesso)
                            where wt.id = $idtramitacao ";
                    $this->con->executa(   $sql, 0, __LINE__);

                    $this->con->navega(0);

                    //echo "\n Fechando feature pai - idprocesso ".$this->con->dados["id"]." avanca_processo ".$this->con->dados["avanca_processo_filhos_fechados"];
                    $this->SalvarHistorico($this->con->dados["id"], $this->con->dados["avanca_processo_filhos_fechados"], null, $this->con->dados["avanca_processo_filhos_fechados"]);
                   // echo "\n Movendo entidade pai \n";
                    $this->notificacoes->notif_entrandofeature($this->con->dados["id"],   $this->con->dados["avanca_processo_filhos_fechados"]);


                }


                break;
            }

        }

				function Tipos_Processo_Faltantes($idtipoprocesso, $idprocesso_pai){
						$sql = "select idtipoprocesso from processos where id = $idprocesso_pai";
						///echo $sql;
						$this->con->executa(   $sql, 0, __LINE__);

						$this->con->navega(0);
						$tipoprocesso_pai = $this->con->dados["idtipoprocesso"];

						//echo "\n  idtipoprocesso $idtipoprocesso idtipoprocesso-pai $tipoprocesso_pai \n ";
						$tentar_tipo_processo = $idtipoprocesso;

								while  ($this->con->dados["id_pai"] != $tipoprocesso_pai )
								{
										$sql = "select * from tipos_processo where id = $tentar_tipo_processo";
										//echo "\n $sql;";
										$this->con->executa(   $sql, 0, __LINE__);

										$this->con->navega(0);


										// echo  "\n ".$this->con->dados["id_pai"]." == $tipoprocesso_pai";

										if ($this->con->dados["id_pai"] == $tipoprocesso_pai){
//											$array[] = $this->con->dados["id_pai"];
										//	var_dump($array);
											return $array;
										}
										else{
											$array[] = $this->con->dados["id_pai"];
											$tentar_tipo_processo = $this->con->dados["id_pai"];
										}
								}


				}



*/

        function SalvarnoBanco($json, $idfeature, $origem  , $app)
        {

            $idprocesso = $this->ControlaCriacaoProcesso($json,$idfeature, $proximos_feature, $app);


            if (!$idprocesso) {
                  $RETORNO_function["ERRO"] = "Id Processo nulo";

                  return $RETORNO_function;
            }



        }

}
