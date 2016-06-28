<?php
set_time_limit(2);
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
            // var_dump($json);

            $this->con->executa( "update   workflow_tramitacao set id_usuario_associado = null where id = '".$json[$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]][idtramitacao]."'", null, __LINE__);
        }

        function AssociarRegistronoPosto($jsonRAW, $idposto){
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


	function    SalvarHistorico($idprocesso, $idposto , $idworkflowtramitacao_original, $proximo_posto ){

                $sql =  "select  rp.avanca_processo, wp.starter


                            from workflow_postos wp
                                inner join relacionamento_postos rp ON (rp.idposto_atual = wp.id)
                                inner join workflow w ON (w.id = wp.id_workflow)
                            where wp.id=$idposto  and rp.avanca_processo = $proximo_posto  ";
                  //  echo "\n Buscando informacoes de posto final, penultimo, proximo posto e starter = $sql\n";
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




                    $sql = "INSERT INTO workflow_tramitacao (idprocesso, idworkflowposto, inicio  $c1 )
                            VALUES( /*2*/ $idprocesso, $idposto, NOW()   $c2 )
                            RETURNING id" ;
                    if (  $this->con->executa( $sql , 1 , __LINE__) === false )
                        $erro = 1;
                    else{
                      //  echo "\n Tramitacao de chegada no novo posto criada: ".$this->con->dados["id"]." ( idprocesso $idprocesso idposto $idposto) \n";
                        //echo " \n Entrando em novo posto de mesmo nivel";
                        $idtramitacao_criada = $this->con->dados["id"];
                        $this->AutoAssociarProcessonoPosto($idprocesso, $idposto, null, $idtramitacao_criada);

                        //$this->notificacoes->notif_entrandoposto($idprocesso , $idposto); // funcionando
                        $this->notificacoes->notif_entrandoposto($idprocesso , $idposto, $avanca_processo);

                        if ($starter){
                         //   echo "aa $idprocesso $idposto $avanca_processo ";
                            $this->notificacoes->notif_saindoposto($idprocesso, $idposto);
                        }

                       // echo "Alterando processo para Em Andamento \n";
                        $sql =  "UPDATE processos SET status = 'Em Andamento' WHERE id  = $idprocesso  ";
                        $this->con->executa(   $sql, null, __LINE__);
                    }




                 //   echo "Checkando se a movimentacao encerra o processo ...";
                    //finalizando o status de um processo
                    if ($idposto_final == $avanca_processo && $avanca_processo > 0){
                      //  echo "Encerra \n";
                        if ( $idposto_penultimo == $idpostoanterior)
                            $sql =  "UPDATE processos SET status = 'Concluído' WHERE id  = $idprocesso  ";
                        else
                            $sql =  "UPDATE processos SET status = 'Arquivado' WHERE id  = $idprocesso  ";
                        $this->con->executa(   $sql, null, __LINE__);
                    }
                    //else
                      //  echo "Nao Encerra \n";


                 //   echo  "\n  chegou aqui ..... ($idworkflowtramitacao_original)";
                     //salvar historico de posto que nao tem proximo
                     if ($idworkflowtramitacao_original )
                     {
                       //  echo "\n XXXXX \n ";
                         //se mesma entidade, fechando o posto
                         $sql =  " UPDATE workflow_tramitacao SET   fim = NOW() WHERE id  = ".$idworkflowtramitacao_original ."  ";
                        // echo "Finalizando posto $idposto , idworkflowtramitacao = ".$idworkflowtramitacao_original." \n";
                         $this->con->executa(   $sql, null, __LINE__);


                        // resolver tramitacao em idprocesso, idposto, postoanterior
                        $sql =  "select wt.idworkflowposto , wt.idprocesso , rp.idposto_atual, rp.avanca_processo
                                from workflow_tramitacao wt
                                       inner join relacionamento_postos rp ON (rp.idposto_atual = wt.idworkflowposto)
                                where wt.id =   $idworkflowtramitacao_original      ";
                        $this->con->executa(   $sql, 0, __LINE__);
                        $this->con->navega(0);

                        $this->notificacoes->notif_saindoposto($this->con->dados["idprocesso"],  $this->con->dados["idposto_atual"] );


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

            $array = $this->SalvarnoBanco(  $json , $idposto, "Salvando", $app); // indo array ?

            $array["resultado"] = "SUCESSO";
            $array["DEBUG"] = $this->notificacoes->debug;

            $data =  	$array;

            $app->render ('default.php',$data,200);

	}


        function AutoAssociarProcessonoPosto($idprocesso, $avanca_processo , $app, $idtramitacao )
        {

            $sql = "select   wp.tipodesignacao
                    from workflow_postos wp

                          left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                      where wp.id  = $avanca_processo";
              $this->con->executa( $sql, null, __LINE__);
             //  echo "\n $sql";
              $this->con->navega(0);
              $tipodesignacao = $this->con->dados["tipodesignacao"];

            //rotina de associação
            $this->Posto_Usuario = new Posto_Usuario();

            switch ($tipodesignacao){
                CASE("AUTO-DIRECIONADO"):
                    $vida_processo = $this->posto->LoadCampos( null, $idprocesso, null, null, null );

                    $idtec = $vida_processo["FETCH"][$idprocesso][$this->globais->SYS_DEPARA_CAMPOS["Tecnologias_do_teste"]."-original"];
                    $usuarios = $this->posto->getUsuariosbyTecnologia($idtec);
                    $usuario_aleatorio = rand(0, (COUNT( $usuarios["USUARIO_TECNOLOGIA"] [$idtec])-1) );

                    $associarRegistro [ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ][valor]  =   $usuarios["USUARIO_TECNOLOGIA"] [$idtec][$usuario_aleatorio]   ;
                    $associarRegistro [$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]]["idtramitacao"]  = $idtramitacao ;
                    $associarRegistro [$this->globais->SYS_DEPARA_CAMPOS["Responsavel"]]["idworkflowdado"]  = null ;
                    $associarRegistro [processo][valor]  = $idprocesso;
                    //echo "\n associado: $idprocesso Posto: $avanca_processo usuario:  ".$associarRegistro [ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ][valor];

                    $this->Posto_Usuario->AssociarProcessonoPosto($app, json_encode($associarRegistro) , $avanca_processo );
                BREAK;
            }


            return $associarRegistro [ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ][valor];
        }


        function ControlaCriacaoProcesso($json , $idposto, $proximo_posto, $app)
        {

            //TODO: quando cria a prospecao do tipo 1 para tipo 4, ta quebrando (amarra o pai certo mas o tipo errado)


          //   echo "\n Iniciando Salvar dados do Form \n";
         //    var_dump($json);
            // identifica quais os proximos postos a partir do atual
            $sql = "select avanca_processo
                    from RELACIONAMENTO_POSTOS
                    where idposto_atual= $idposto";
            $this->con->executa($sql , null, __LINE__);
//echo $sql;
            while ($this->con->navega(0)) {
                if ($this->con->dados["avanca_processo"]>0)
                    $proximos_postos [ $this->con->dados["avanca_processo"]]  = $this->con->dados["avanca_processo"];
            }

            // para os proximos postos, verifica se é preciso criacao de processos
            if (is_array($proximos_postos))
            {
              //  echo "\n Salvando ".count($proximos_postos)." postos\n";
                $idprocesso_original = $json[processo][valor];
                $id_pai = "null";

                foreach ($proximos_postos as $proximo_posto)
                {
                     // 8***** INcluido rotina de criacao de processo e historico
										 	$rodar_preenchedor_processos = null;

                      $erro = 0;

                        // echo "\n Id Processo do JSON vazio  ";
                        $sql = "select wp2.id idtipoprocesso, wp.id_workflow, rp.avanca_processo,
                                                                                        wp.idtipoprocesso idtipoprocesso_atual,
                                                                                        wp.tipodesignacao, wp.regra_finalizacao, w.posto_inicial
                                                        from workflow_postos wp
                                                                        inner join relacionamento_postos rp ON (rp.idposto_atual = wp.id)
                                                                        inner join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                                                                        inner join workflow_postos wp2 ON (wp2.id = rp.avanca_processo)
                                                                        inner join workflow w ON (w.id = wp.id_workflow)
                                                        where wp.id = $idposto and rp.avanca_processo = $proximo_posto";
                // echo $sql;
                        $this->con->executa( $sql , null, __LINE__);
          //   echo "\n IDados do Posto:    ";
                        $this->con->navega(0);

                        $avanca_processo =  $this->con->dados["avanca_processo"];
                        $idposto_inicial = $this->con->dados["posto_inicial"];
                        $idtpproc = $this->con->dados["idtipoprocesso_atual"];
                        $idtpproc_proximo = $this->con->dados["idtipoprocesso"];
                        $idwok = $this->con->dados["id_workflow"];


                        // dentro de um posto com pai já existente...
                        $sql = "select tp.id, rp.avanca_processo, wp.tipodesignacao, wp.idtipoprocesso posto_idpai , tp.id_pai
                                                        from workflow_postos wp
                                                                        inner join relacionamento_postos rp ON (rp.idposto_atual = wp.id)
                                                                        left  join tipos_processo tp ON (tp.id = wp.idtipoprocesso)
                                                        where wp.id  = $idposto and rp.avanca_processo = $proximo_posto ";
                 //echo $sql;
                //  echo "\n tem idposto e idprocesso do json    ";
         //echo $sql;
                        $this->con->executa($sql, null, __LINE__ );
                        $this->con->navega(0);
                        $idtipoprocess_posto = 	$this->con->dados["id"];
                        $avanca_processo = 	$this->con->dados["avanca_processo"];
                        $idtipopai_posto =  $this->con->dados["id_pai"];
                        $idtipo_proximoposto =  $this->con->dados["posto_idpai"];


                      //$id_pai = "null";
                     // echo "\n )))))))))))))))))) iniciando rotina de controle de criacao de processo ";

                      if ($idposto && $json[processo][valor] )
                      {



                          $sql = "select p.idtipoprocesso, tp.id_pai
                                  from processos p
                                      inner join tipos_processo tp ON (tp.id = p.idtipoprocesso)
                                  where p.id = ".$json[processo][valor];
                          // echo $sql;
                          $this->con->executa( $sql, null, __LINE__);
                          $this->con->navega(0);
                          $idtipoprocess_processo = 	$this->con->dados["idtipoprocesso"];



													//echo "\n aqui";
                          if ( $idtipoprocess_posto != $idtipoprocess_processo){
                              // se o próximo posto tem tipo de processo diferente do atual, entra aqui
                              $id_pai = $json[processo][valor];
                              $json[processo][valor] = null;

                             if ($id_pai > 0){
                                    //  echo "\n ID_PAI existente  \n ";

                                      $sql = "select 1 cria_processo from tipos_processo where id= $idtpproc and id_pai=
                                                  (select idtipoprocesso from processos where id = $id_pai)";
                                     // echo " \n $sql \n";
                                      $this->con->executa( $sql, null, __LINE__);
                                      $this->con->navega(0);

                                      if (!$this->con->dados["cria_processo"]){
                                      //  echo "\n Movimento não permitido:  tipo de processo do posto != tipo process do processo =  $idtipoprocess_posto != $idtipoprocess_processo ";
                                        $rodar_preenchedor_processos = 1;
																			  $idtipopai_posto = $idtpproc;
                                      }
                                      else{
                                        $cria_processo = $this->con->dados["cria_processo"];
                                    //    echo "\n Movimento regular para tramitacao: ".$cria_processo."\n";
                                      }

                              }


                            //  $idtipopai_posto =  $idtipo_proximoposto;

                          }
                          else
                              $idprocesso = $json[processo][valor];
                      }
						if (!$json[processo][valor])
						{

                    if ( $rodar_preenchedor_processos ==1  )
                    {
                        // se precisa criar um processo, quando a tramitacao é de um posto para outro de mesmo tipo
                        // de processo ele nao entra aqui....
												$kk=1;
												$davez = $idtpproc;

												$sql = "select id_pai from tipos_processo where id = $davez";
											//  echo " \n $sql \n";
												$this->con->executa( $sql, null, __LINE__);
												$this->con->navega(0);

												$tipos_processo_para_preencher=null;
												//echo "\n\n processos faltantes ? $idtpproc, $id_pai";
												$tipos_processo_para_preencher = $this->Tipos_Processo_Faltantes($idtpproc, $id_pai);

													//$tipos_processo_para_preencher[] = 2;
											//inicio loop
												  foreach ( $tipos_processo_para_preencher as $tipo_processo)
									    		{

 																$idtipopai_posto = $tipo_processo;
                                //  $idtipopai_posto = $idtpproc;
                                //  echo " \n While: criando processos intermediarios - tipo processo: $idtipopai_posto = jacriou ? (".$jacriou[$idtipopai_posto].")";
                                  if (!$jacriou[$idtipopai_posto])
                                  {
                                     // echo "\n  Processo do tipo  $idtipopai_posto da processo $idprocesso_original = criado   ";
                                    $id_pai = $this->CriarProcesso($idtipopai_posto, $id_pai, $idwok, $json, $proximo_posto, $proximo_posto );
    //                                $id_pai = $this->CriarProcesso($idtpproc, $id_pai, $idwok, $json, $proximo_posto, $proximo_posto );
                                     // echo "  $id_pai ";
                                    $id_processo2 = $id_pai;


                                      $jacriou[$idtipopai_posto] = $id_pai;

                                        //excepcional porque se pode criar processos intermediarios quando ha salto de mais de 1 nivel de tipo processo
                                        // Registra os dados que foram submetidos no form
                                        $valor=null;
                                        //echo "Iniciando gravacao dos dados do form ~ ".count($json)." \n  [";
                                        foreach ($json as $campo => $valor){
                                            if ($campo == "processo") continue;
                                            //echo ".";

                                            $this->registraDadosdoPosto($valor, $idposto, $id_processo2, $campo, $json[processo][idworkflowtramitacao_original]);




                                        }
																				$salvar_dados_form = 1;
                                      $id_processo =null;
                                      $json_bkp=null;

                                      $json_bkp[processo] = $json[processo]  ; $json = null;

                                      $json = $json_bkp;
                                      $cria_processo = 1;

                                  }
                                  else {
                                      $id_pai = $jacriou[$idtipopai_posto];//$this->con->dados["id"];
                                    //  echo "\n Processo do tipo  $idtipopai_posto da processo $idprocesso_original  EXISTE =  $id_pai";
                                      $cria_processo = 1;


                                  }


                                  $sql = "select 1 cria_processo from tipos_processo where id= $idtpproc and id_pai=
                                              (select idtipoprocesso from processos where id = $id_pai)";
                              //   echo " \n $sql \n";
                                  $this->con->executa( $sql, null, __LINE__);
                                  $this->con->navega(0);

                         }  // fim loop
                    }

                   if ($idposto_inicial == $idposto ) {
  									//		echo " \n Processo Starter  :    $id_pai  ";
                        // starter
                        $id_pai = $this->CriarProcesso($idtpproc, $id_pai, $idwok, $json, $idposto,  $proximo_posto);

												if ($json[processo][acao] == $this->globais->SYS_DEPARA_CAMPOS["bt_handover"] )
												{
												//    echo "\n criar tramitacao \n ";
														// cria proximo posto em branco ja que o inicial ja nasce fechado
														$idtramitacaogerada_pai = $this->SalvarHistorico($id_pai, $idposto, null, $proximo_posto);
														$idtramitacaogerada = $this->SalvarHistorico($id_pai, $proximo_posto, null, $proximo_posto);
													//  $this->AutoAssociarProcessonoPosto($id_pai, $proximo_posto, $app, $idtramitacaogerada);

												}
                        if (is_array($json))
                        {
                              // Registra os dados que foram submetidos no form
                              $valor=null;
                              //var_dump($json);
                              //echo "Iniciando gravacao dos dados do form ~ ".count($json)." \n  [";
                              foreach ($json as $campo => $valor){
                                  if ($campo == "processo") continue;
                                  /// ".";

                                  $this->registraDadosdoPosto($valor, $idposto, $id_pai, $campo, $idtramitacaogerada_pai);
                              }
                        }

//                                  $cria_processo=1;
                    }

                              if ($cria_processo == 1 )
                              {

                                  $idprocesso = $this->CriarProcesso($idtpproc, $id_pai, $idwok, $json, $proximo_posto, $proximo_posto );
                            //      echo " \n Processo criado (cria_processo==1):  $idprocesso   ";
																	if ($json[processo][acao] == $this->globais->SYS_DEPARA_CAMPOS["bt_handover"])
																 {
														 //         echo " \n criando tramitacao \n  ";
																	 //  mesma entidade
																		 $idtramitacao_gerada = $this->SalvarHistorico($idprocesso, $proximo_posto, null, $proximo_posto);
																		 // $this->SalvarHistorico($idprocesso, $idposto, null, $proximo_posto);
																		// $this->AutoAssociarProcessonoPosto($idprocesso, $proximo_posto, $app, $idtramitacao_gerada);
																 }

                                   if (is_array($json))
                                  {
                                        // Registra os dados que foram submetidos no form
                                        $valor=null;
                                        //var_dump($json);
                                        //echo "Iniciando gravacao dos dados do form ~ ".count($json)." \n  [";
                                        foreach ($json as $campo => $valor){
                                            if ($campo == "processo") continue;
                                            //echo ".";

                                            $this->registraDadosdoPosto($valor, $idposto, $idprocesso, $campo, $idtramitacao_gerada);
                                        }
                                  }


                              }
                              else {
                                  $idprocesso = $id_pai;
                              }
                      }
                      else{
														if ($json[processo][acao] == $this->globais->SYS_DEPARA_CAMPOS["bt_handover"])
														{
																// se mesma entidade e handover, so tramita
																//echo "\n se mesma entidade e handover, so tramita";
																$idtramitacao_gerada = $this->SalvarHistorico($idprocesso, $proximo_posto, $json[processo][idworkflowtramitacao_original], $proximo_posto);
															//  $this->AutoAssociarProcessonoPosto($idprocesso, $proximo_posto, $app, $idtramitacao_gerada);
														}
                            if (is_array($json))
                             {
                                   // Registra os dados que foram submetidos no form
                                   $valor=null;
                                   //var_dump($json);
                                   //echo "Iniciando gravacao dos dados do form ~ ".count($json)." \n  [";
                                   foreach ($json as $campo => $valor){
                                       if ($campo == "processo") continue;
                                       //echo ".";

                                       $this->registraDadosdoPosto($valor, $idposto, $idprocesso, $campo, $idtramitacao_gerada);
                                   }
                             }

                // ca


                      }


                } // fim for each



            }
            else{
                $idprocesso = $json[processo][valor];
								$salvar_dados_form = 1;
                if (is_array($json))
                {
                      // Registra os dados que foram submetidos no form
                      $valor=null;
                      //var_dump($json);
                      //echo "Iniciando gravacao dos dados do form ~ ".count($json)." \n  [";
                      foreach ($json as $campo => $valor){
                          if ($campo == "processo") continue;
                         // echo "\n $campo = ".$valor[valor];

                          $this->registraDadosdoPosto($valor, $idposto, $idprocesso, $campo, $json[processo][idworkflowtramitacao_original]);
                      }
                }

                if ($json[processo][idworkflowtramitacao_original]){
                    // caso o handover seja em posto sem destino ou posto finalizador
                   // echo "\n handover sem destino";
                    $this->HandoverSemDestino( $json[processo][idworkflowtramitacao_original] );
                }

            }


            //legado **********************************************************************

            return $idprocesso;
        }

        function CriarProcesso($idtpproc, $id_pai, $idwok, $json, $idposto, $proximo_posto )
        {


            $sql = "INSERT INTO  processos (idtipoprocesso, idpai, inicio, idworkflow )
                    VALUES ( /*aqui*/ $idtpproc   ,$id_pai, NOW() , $idwok )

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

        function registraDadosdoPosto($valor, $idposto, $idprocesso, $campo, $idworkflowtramitacao = "null")
        {
            //TODO nÃo está dando load nos salvos no posto
            if ( $valor["idworkflowdado"] > 0 )
            {
                if (!$this->con->executa( "UPDATE workflow_dados SET valor = '".$valor[valor]."' WHERE id  ='".$valor[idworkflowdado]."'" , null, __LINE__ ))
                $erro++;
            }
            else
            {
                if (!$this->con->executa( "INSERT INTO workflow_dados (idpostocampo, valor, idprocesso, registro, idposto, idworkflowtramitacao)
                                        VALUES (/*4*/ '$campo','$valor[valor]', $idprocesso, NOW(), $idposto, $idworkflowtramitacao)  " , null, __LINE__ ))
                $erro++;
            }

        }


        function HandoverSemDestino( $idtramitacao )
        {
         //  $idtramitacao
            //echo "\n Dentro do handover sem destino";

            $sql =  " UPDATE workflow_tramitacao SET   fim = NOW() WHERE id  = $idtramitacao returning idworkflowposto ";
            $this->con->executa(   $sql, 1, __LINE__);


            // resolver tramitacao em idprocesso, idposto, postoanterior
            $sql =  "select  wt.idprocesso , rp.idposto_atual, rp.avanca_processo, wt.idworkflowposto
                    from workflow_tramitacao wt
                           left join relacionamento_postos rp ON (rp.idposto_atual = wt.idworkflowposto)
                    where wt.id =   $idtramitacao      ";
            $this->con->executa(   $sql, 0, __LINE__);
            $this->con->navega(0);
           //  echo "Handover sem destino \n";
            $this->notificacoes->notif_saindoposto($this->con->dados["idprocesso"],   $this->con->dados["idworkflowposto"]);

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
                    // executa o handover do posto pai
                  //  echo "\n Todos os filhos fechados, fechar o processo pai";


                    $sql = "select p_pai.id, tp.avanca_processo_filhos_fechados
                            from workflow_tramitacao wt
                                    inner join processos p ON (p.id = wt.idprocesso)
                                    inner join processos p_pai ON (p_pai.id = p.idpai)
                                    inner join tipos_processo tp ON (tp.id = p_pai.idtipoprocesso)
                            where wt.id = $idtramitacao ";
                    $this->con->executa(   $sql, 0, __LINE__);

                    $this->con->navega(0);

                    //echo "\n Fechando posto pai - idprocesso ".$this->con->dados["id"]." avanca_processo ".$this->con->dados["avanca_processo_filhos_fechados"];
                    $this->SalvarHistorico($this->con->dados["id"], $this->con->dados["avanca_processo_filhos_fechados"], null, $this->con->dados["avanca_processo_filhos_fechados"]);
                   // echo "\n Movendo entidade pai \n";
                    $this->notificacoes->notif_entrandoposto($this->con->dados["id"],   $this->con->dados["avanca_processo_filhos_fechados"]);


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





        function SalvarnoBanco($json, $idposto, $origem  , $app)
        {

            $idprocesso = $this->ControlaCriacaoProcesso($json,$idposto, $proximos_posto, $app);


            if (!$idprocesso) {
                  $RETORNO_function["ERRO"] = "Id Processo nulo";

                  return $RETORNO_function;
            }



        }
}
