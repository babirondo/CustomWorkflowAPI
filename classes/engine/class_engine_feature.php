<?php
namespace raiz;
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Engine_Feature{
	function __construct( ){

		require_once("classes/class_db.php");
		include_once("classes/globais.php");
		require_once("classes/class_campo.php");

		$this->con = new db();
		$this->con->conecta();


    $this->globais = new Globais();
		$this->campo = new Campos();

	}


	function getCampos($app, $idfeature, $jsonRAW ){
		$data = $this->LoadCampos($jsonRAW, $idfeature  );
		$app->render ('default.php',$data,200);
	}



	function getLista($app,   $idfeature , $jsonRAW){


    	$debug= 0;
		//$array = $this->BuscarDadosdoFilhoePai($idfeature ); // xxx

  	$array = $this->LoadCampos($jsonRAW,   $idfeature);
	                //  var_dump($array );
			$sql = "select *
							from engine_acao
							where idfeature =  $idfeature    ";
			$this->con->executa($sql );

			//$this->con->navega();
			$i=0;
			while ($this->con->navega(0)){
				$array["ACOES"]  [$this->con->dados["id"] ][acao]   = $this->con->dados["acao"];
				$array["ACOES"]  [$this->con->dados["id"] ][ir]   = $this->con->dados["goto"];
				$array["ACOES"]  [$this->con->dados["id"] ][lista]   = $this->con->dados["lista"];
				$array["ACOES"]  [$this->con->dados["id"] ][idworkflow]   = $this->con->dados["id_workflow"];

				$i++;
			}

      //$array["ACOES"]  [$this->con->dados["idprocesso"] ][idworkflowdado]   = $this->con->dados["idworkflowdado"]; // L ou F

/*
      switch ($array["DADOS_feature"][tipodesignacao])
      {
          case("AUTO-DIRECIONADO"):
          case("Assumir"):
	    			$array["ACOES"]  [$array["DADOS_feature"][tipodesignacao] ][acao]   = "Assumir"; // Nome do Link
	    			$array["ACOES"]  [$array["DADOS_feature"][tipodesignacao] ][ir]   = $idfeature; // proximo feature
	    			$array["ACOES"]  [$array["DADOS_feature"][tipodesignacao] ][lista]   = "L"; // L ou F
	    			$array["ACOES"]  [$array["DADOS_feature"][tipodesignacao] ][idworkflow]   = $array["DADOS_feature"][idworkflow];//$this->con->dados["id_workflow"];
	    			$array["ACOES"]  [$array["DADOS_feature"][tipodesignacao] ][assumir]   = 1;//$this->con->dados["id_workflow"];
          break;

          default:
		//$array["ACOES"]  [$array["DADOS_feature"][tipodesignacao] ][acao]   = $array["DADOS_feature"][tipodesignacao]; // Nome do Link
      }
			*/


		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);


	}


/*
        function Usuariosdofeature($app, $idfeature  ){
            $array = $this->getUsuarios($idfeature);

            $array["resultado"] = "SUCESSO";

            $data =  	$array;

            $app->render ('default.php',$data,200);
        }

	function getUsuarios($idfeature  ){

            $sql = "select ua.idusuario, ua.idator, wp.id idfeature, u.nome
                    from usuario_atores ua
                            INNER JOIN workflow_features wp ON (wp.idator = ua.idator)
                            INNER JOIN usuarios u ON (u.id = ua.idusuario)
                    where wp.id= $idfeature and u.admin is null ";
         //   echo "\n\n\n".$sql;
            $this->con->executa( $sql);

            while ($this->con->navega(0)){
                $array["USUARIOS_feature"]
                        [$this->con->dados["idfeature"]]
                        [$this->con->dados["idusuario"]]   = $this->con->dados["nome"];
            }

            return $array;
	}


	function getUsuariosbyTecnologia($tecnologia , $idprocesso, $idfeature ){

            $sql = "select *
										from usuarios_avaliadores_tecnologias
										where lower(trim(campo)) like lower(trim('$tecnologia'))
										 and idusuario NOT IN ( select id_usuario_associado from workflow_tramitacao where idprocesso = (select id from processos where idpai = (select idpai from processos where id = $idprocesso) and id != $idprocesso) and idworkflowfeature IN (3,287) )    ";

            $this->con->executa( $sql);
						//FIXME: features de avaliacao tecnica chumbados na query, favor tipos_processo_para_preencher


            while ($this->con->navega(0)){
                $array["USUARIO_TECNOLOGIA"] [$tecnologia][]    = $this->con->dados["idusuario"];
            }

            return $array;
	}
*/
/*
	function getfeatures($app, $idworkflow , $jsonRAW){
		$json = json_decode( $jsonRAW, true );
		IF ($json == NULL) {
			$data = array("data"=>

					array(	"resultado" =>  "ERRO",
							"erro" => "JSON zuado - $jsonRAW" )
			);


			$app->render ('default.php',$data,500);
			return false;
		}
		$sql = "Select wp.*
            from workflow_features wp
                  inner join workflow wk ON (wk.id = wp.id_workflow)
                  left join   usuario_atores ua ON (ua.idator = wp.idator)
                  left join usuarios u ON (u.id = ua.idusuario)
            WHere (wp.id_workflow = $idworkflow and wp.principal = 1) and (u.id = ".$json[idusuario]."  OR wp.idator is null)
            ORDER BY ordem_cronologica ";
	//echo $sql;exit;
		$this->con->executa( $sql);
		//$this->con->navega();

		$i=0;
		while ($this->con->navega(0)){
			$array["FETCH"][$i]["feature"]  = $this->con->dados["feature"];
			$array["FETCH"][$i]["idfeature"]  = $this->con->dados["id"];
			$array["FETCH"][$i]["lista"]  = $this->con->dados["lista"];



			$i++;
		}

		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);

	}

	function BuscarDadosProcesso($idprocesso , $idfeature,  $debug = null, $listar="Lista", $feature, $jsonfiltros = null)
	{
            // buscando dados -> indexado por idprocesso
            $array_dopai = $this->BuscarDadosdoFilhoePai($idfeature, $idprocesso, $debug, $listar, $feature, $jsonfiltros);

            return $array_dopai;
	}
*/
	function LoadCampos($jsonRAW,  $idfeature, $idprocesso =null){
					$json = json_decode( $jsonRAW, true );



            if ($idfeature>0)
            {
							/*
                // busca o email dos atores do feature
                $sql ="select u.email
                        from workflow_features wp
                            inner join atores  a ON (a.id = wp.idator)
                            inner join usuario_atores ua ON (ua.idator = a.id)
                            inner join usuarios u ON (u.id = ua.idusuario)
                        where  wp.id = $idfeature ";
                $this->con->executa($sql);

                $emails = null;
                while ($this->con->navega(0)){
                    $emails[$this->con->dados["email"]]  = $this->con->dados["email"];
                }
                if (is_array($emails))
                        $array["DADOS_feature"] [atoresdofeature]  = implode(",",$emails);
*/
              //buscando funcoes do feature
                $sql ="SELECT ef.*, func.goto, func.funcao
												from menus m
													inner join eng_features ef ON (ef.id = m.irpara)
													inner join engine_funcoes func ON (func.idfeature = ef.id  )

                        where m.id=  $idfeature  ";
                // echo $sql;
                $this->con->executa($sql);

                $p=0;
                while ($this->con->navega($p)){

                    $array["FUNCOES_FEATURE"][$this->con->dados["funcao"]]["goto"]  = $this->con->dados["goto"];
                    //$array["FUNCOES_FEATURE"][$this->con->dados["funcao"]][lista]  = $this->con->dados["lista"];
                    $p++;
                }
/*
								//buscando opcoes de filtro do feature
								$sql ="select fp.id, pc.campo, fp.tipofiltro
												from filtros_features fp
													inner join features_campo pc ON (pc.id = fp.idfeaturecampo)
												where fp.idfeature = $idfeature  ";
								//echo $sql;
								$this->con->executa($sql);


								while ($this->con->navega($p)){

										$array["FILTROS_feature"] [$this->con->dados["id"]][FILTRO]  = $this->con->dados["campo"];
										$array["FILTROS_feature"] [$this->con->dados["id"]][TIPO]  = $this->con->dados["tipofiltro"];

								}


                //buscando dados do feature
                $sql ="Select wp.*, nsp.de, nsp.para, nsp.titulo, nsp.corpo, rp.avanca_processo
                        from workflow_features  wp
                                LEFT JOIN notificacoes_email nsp ON (nsp.id = wp.".(($feature=="entrando")?"notif_entrandofeature":"notif_saindofeature").")
                                LEFT JOIN relacionamento_features rp ON (rp.idfeature_atual = wp.id)
                        WHERE wp.id = $idfeature  ";
                //echo $sql;
                $this->con->executa($sql);

                $p=0;
                while ($this->con->navega($p)){

                    $array["DADOS_feature"] [nomefeature]  = $this->con->dados["feature"];
                    $array["DADOS_feature"] [idworkflow]  = $this->con->dados["id_workflow"];
                    $array["DADOS_feature"] [starter]  = $this->con->dados["starter"];
                    $array["DADOS_feature"] [de]  = $this->con->dados["de"];
                    $array["DADOS_feature"] [para]  = $this->con->dados["para"];
                    $array["DADOS_feature"] [titulo]  = $this->con->dados["titulo"];
                    $array["DADOS_feature"] [corpo]  = $this->con->dados["corpo"];
                    $array["DADOS_feature"] [notif_entrandofeature]  = $this->con->dados["notif_entrandofeature"];
                    $array["DADOS_feature"] [notif_saindofeature]  = $this->con->dados["notif_saindofeature"];
                    $array["DADOS_feature"] [tipodesignacao]  = $this->con->dados["tipodesignacao"];
                    $array["DADOS_feature"] [avanca_processo][$p]  = $this->con->dados["avanca_processo"];
                    $p++;
                }
*/
								$sql = "Select *
												from menus m
													inner join eng_features ef ON (ef.id = m.irpara)
													inner join engine_feature_campos efc ON (efc.idfeature = ef.id)
													inner join engine_campos ec ON (ec.id = efc.idcampo)
												where m.id = $idfeature  ";
                 //echo ($sql);
								 $this->con->executa($sql );


                while ($this->con->navega(0)){
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["obrigatorio"]  = $this->con->dados["obrigatorio"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["maxlenght"]  = $this->con->dados["maxlenght"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["inputtype"]  = $this->con->dados["inputtype"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["dica_preenchimento"]  = $this->con->dados["dica_preenchimento"];

                        if ($this->globais->Traduzir( $this->con->dados["valor_default"] ) == false )
                                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["valor_default"]  =  $this->con->dados["valor_default"];
                        else {
                                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["valor_default"]  =  $this->campo->BuscarValoresCampo( array( "valor_default" => $this->con->dados["valor_default"] ));
                        }
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["txtarea_cols"]  = $this->con->dados["txtarea_cols"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["txtarea_rows"]  = $this->con->dados["txtarea_rows"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["campo"]  = $this->con->dados["campo"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["idcampo"]  = $this->con->dados["id"];
                }
            }


            // buscando os registros do feature, direcionado pelo idprocesso
            //$array_dados = $this->BuscarDadosProcesso($idprocesso , $idfeature, $debug, $listar, $feature, $jsonfiltros);
						$array_dados = $this->BuscarDadosdoFilhoePai($idfeature, $json["processo"]["valor"] );



						if (is_array($array_dados) && is_array($array) ){
							$array_completo =  array_replace_recursive($array_dados, $array);
						}
						else if (is_array($array_dados)   ){
							$array_completo =  $array_dados;
						}
						else if (is_array($array)   ){
							$array_completo =  $array;
						}


								//echo "<PRE>"; var_dump($array);
								//echo "<PRE>"; var_dump($array_dados);
					//			echo "<PRE>"; var_dump($array_completo );



            $array_completo["resultado"] = "SUCESSO";

            if ($debug){
                  //  var_dump($array_completo);
                    //echo $feature;
            }

            return $array_completo;

	}


/*
  function LoadCamposbyProcesso(  $idprocesso  ){

            $array = $this->LoadCampos( null, $idprocesso, null, null, null );
            return $array;

	}
	*/
	function BuscarDadosList($idfeature, $idprocesso){
		if ($idfeature > 0 ) $and[] = " m.id = $idfeature ";
		if ($idprocesso > 0 ) $and[] = " ed.idprocesso = $idprocesso ";

		$where = ((is_array($and))?  " WHERE ".implode(" and ",$and): null);

		$sql = "select ed.idprocesso chave, ed.idfeaturecampo idcampo, ed.valor valor, ec.campo
						from menus m
							inner join eng_features ef ON (ef.id = m.irpara)
							inner join eng_feature_campos_lista efcl ON (efcl.idfeature = ef.id )
							inner join engine_campos ec ON (ec.id = efcl.idfeaturecampo)
							LEFT JOIN engine_dados ed ON (ed.idfeaturecampo = ec.id)
						$where";
//						echo $sql;
		$this->con->executa( $sql, 0, __LINE__  );
		//echo "\n SQL GERADO";

		while ($this->con->navega(0) ){

					$array["FETCH"] [$this->con->dados["chave"]][$this->con->dados["idcampo"] ]   =   $this->con->dados["valor"] ;
					$array["FETCH_CAMPO"] [$this->con->dados["idcampo"]]["valor"]   =   $this->con->dados["valor"] ;
		   		$array["TITULO"] [$this->con->dados["idcampo"]]   = $this->con->dados["campo"];
		}
		return $array;
	}

	function BuscarDadosForm($idfeature, $idprocesso){

		if ($idfeature > 0 ) $and[] = " m.id = $idfeature ";
		if ($idprocesso > 0 ) $and[] = " ed.idprocesso = $idprocesso ";

		$where = ((is_array($and))?  " WHERE ".implode(" and ",$and): null);

		$sql = "select   ec.id idcampo,  ec.campo, ed.valor, ed.id iddado
						from menus m
							inner join eng_features ef ON (ef.id = m.irpara)
							INNER JOIN engine_feature_campos efc ON (efc.idfeature = ef.id)
							INNER JOIN engine_campos ec ON (ec.id = efc.idcampo)
							LEFT JOIN engine_dados ed ON (ed.idfeaturecampo = ec.id )
							$where";
							//echo $sql;
		$this->con->executa( $sql, 0, __LINE__  );
		//echo "\n SQL GERADO";

		while ($this->con->navega(0) ){

			$array["FETCH_CAMPO"] [$this->con->dados["idcampo"]]["valor"]   =   $this->con->dados["valor"] ;
			$array["FETCH_CAMPO"] [$this->con->dados["idcampo"]]["idworkflowdado"]   =   $this->con->dados["iddado"] ;
		}
		return $array;
	}

	function BuscarDadosdoFilhoePai($idfeature, $idprocesso=null)
	{

		$sql = "Select *
						from menus m
							inner join eng_features ef ON (ef.id = m.irpara)
						where m.id = $idfeature";

		$this->con->executa( $sql, 0, __LINE__  ); $sql = null;
		$this->con->navega(0);

		$lista = $this->con->dados["lista"];


		switch ($lista){
			case("L"):
				$array = $this->BuscarDadosList($idfeature, $idprocesso);
			break;

			case("F"):
				if ($idprocesso > 0 ){
					$array = $this->BuscarDadosForm($idfeature, $idprocesso);
				}
			break;
		}


/*
				$busca_so_dados_do_feature = "left";
			  $busca_entidades = "wt.idprocesso = p.id";

        switch ($listar)
        {
            case ("Lista"):
                $comp = "left join features_campo_lista pcl ON (pcl.idfeaturecampo = pc.id and pcl.idfeature = wp.id)";
                $camp = ", pcl.id estaprevistapralista";
            break;

						case ("VidaProcesso"):
                $busca_so_dados_do_feature = "inner";
								$orderby = " ORDER BY wt.inicio";
//								$feature = "saindo";
								$busca_entidades = "wt.idprocesso IN (ap.proprio, ap.avo, ap.filho, ap.bisavo )";
								$sodados_dofeature = "and w.idworkflowtramitacao = wt.id";
            break;


        }
        if ($idfeature>0){
            $comp_ini = "wp.id=$idfeature and wt.idworkflowfeature =$idfeature and ";
        }
				//FIXME: criar recorrencia na arvore_processo via banco.... hoje ta estatico
        $sql = "SELECT pc.campo, w.valor, p.id idprocesso, p.idpai, wt.id idworkflowtramitacao,
											w.idworkflowtramitacao idworkflowtramicao_dados,
                     p.status, w.idfeaturecampo idcampo, wt.id_usuario_associado tramitacao_idusuario,
                     u.nome tramitacao_usuario, u.nome usuarioassociado,
                     wp.tipodesignacao  $camp
                     , wt.idworkflowfeature, wt.fim, w.idfeature,
										 wt.inicio wt_inicio, wt.fim wt_fim, fp.tipofiltro, fp.id idfiltro
             FROM  arvore_processo ap
					  		 INNER JOIN processos p ON (p.id = ap.proprio)
                 INNER JOIN workflow_tramitacao wt ON ( $busca_entidades  ".(($feature=="saindo")?"  ": " and wt.fim is null " )."  )
                 $busca_so_dados_do_feature JOIN workflow_dados w ON (w.idprocesso IN (ap.proprio, ap.avo, ap.filho, ap.bisavo ) $sodados_dofeature )
                 INNER JOIN workflow_features wp ON (wp.id = wt.idworkflowfeature)
                 LEFT JOIN  features_campo pc ON ( pc.id = w.idfeaturecampo )
                 LEFT JOIN usuarios u ON (u.id = wt.id_usuario_associado)
								 LEFT JOIN filtros_features fp ON (fp.idfeature = wp.id and fp.idfeaturecampo = pc.id)
                 $comp
             WHERE  $comp_ini w.idfeaturecampo > 0 ".(($idprocesso>0)?" and ap.proprio = $idprocesso":"")."
						 	$gowhere_filtro
						 $orderby ";
        $this->con->executa( $sql, 0, __LINE__  );
      //	echo "<PRE>".$sql."</pre>"; exit;
        //echo "\n SQL GERADO";
        $i=0;

        while ($this->con->navega($i) ){
               $idworkflowdado_assumir = null;


							$array["FETCH_feature"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ]   = $array["FETCH"] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ]   =  $this->campo->BuscarValoresCampo (  $this->con->dados["valor"] ,  $this->con->dados["idcampo"] );
							$array["FETCH_feature"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"]."-original" ]   = $array["FETCH"] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"]."-original" ]   = $this->con->dados["valor"];

							// seta a info para o filtro
							if ($this->con->dados["idfiltro"] > 0)
								$array["FILTROS_feature"] [$this->con->dados["idfiltro"]] ["ITENS"][$array["FETCH_feature"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ]] = $array["FETCH_feature"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ];

               $array["FETCH"] [$this->con->dados["idprocesso"]][tramitacao_idusuario ]   = $this->con->dados["tramitacao_idusuario"];

            //   $array["FETCH"] [$this->con->dados["idprocesso"]]["feature_ATUAL" ][$this->con->dados["idworkflowfeature"]]   = $this->con->dados["idworkflowfeature"];


               if ($this->con->dados["tramitacao_idusuario"]>0){
                    $array["FETCH_feature"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ."-ID"] = $array["FETCH"] [$this->con->dados["idprocesso"]][ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ."-ID"]   = $this->con->dados["tramitacao_idusuario"];
                    $array["FETCH_feature"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ] = $array["FETCH"] [$this->con->dados["idprocesso"]][ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ]   = $this->con->dados["tramitacao_usuario"];
                    $idworkflowdado_assumir = "teve";
               }

                // adiciona ao Fetch os valores que sao buscados na traducao dos colchetes nos emails
                foreach ($this->globais->SYS_ADD_CAMPOS as $idx => $val){
                    $array["FETCH_feature"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$idx] = $array["FETCH"] [$this->con->dados["idprocesso"]][$idx]   =   $this->con->dados["$val"]  ;
                }

                $array["FETCH"] [$this->con->dados["idprocesso"]][idworkflowtramitacao ]   = $this->con->dados["idworkflowtramitacao"];

               if ($this->con->dados["estaprevistapralista"])
                   $array["TITULO"] [$this->con->dados["idcampo"]]   = $this->con->dados["campo"];
               else if ($idworkflowdado_assumir == "teve")
                   $array["TITULO"] [-1]   = array_search(-1, $this->globais->SYS_DEPARA_CAMPOS);

//							 $array["FETCH_feature"] [$this->con->dados["idfeature"]] [$this->con->dados["idprocesso"]]  = $this->globais->ArrayMergeKeepKeys($array["FETCH_feature"] [$this->con->dados["idfeature"]] [$this->con->dados["idprocesso"]], $array["FETCH"] [$this->con->dados["idprocesso"]])		 	;

               $i++;
        }

    // BUSCANDO ATRIBUTOS DO PROCESSO
		$sql = "
                    select *, p.status p_status, p.id idprocesso, to_char(wt.inicio, 'dd/mm/yyyy') wt_inicio ,
                                    to_char(p.inicio, 'dd/mm/yyyy') p_inicio ,wt.idworkflowfeature, p.inicio entradanofeature,
                                    u.nome usuarioassociado
                    from workflow_tramitacao wt
                            inner join features_campo_lista pcl ON (pcl.idfeature = wt.idworkflowfeature)
                            INNER JOIN workflow_features wp ON (wp.id = pcl.idfeature)
                            inner join processos p ON (p.id = wt.idprocesso)
                            left join usuarios u ON (u.id  = wt.id_usuario_associado)


                    where wt.fim is null $comp_ini and pcl.idfeaturecampo is null   ".(($idprocesso>0)?" and p.id = $idprocesso":"");

		$this->con->executa( $sql,0, __LINE__);
		//echo $sql;
		$i=0;
		while ($this->con->navega(0)){
      $array["FETCH"] [$this->con->dados["idprocesso"]][$this->con->dados["atributo_campo"] ]   = $this->con->dados [ $this->con->dados["atributo_valor"] ];
      $array["TITULO"] [$this->con->dados["atributo_campo"]]   = $this->con->dados["atributo_campo"];

      $i++;
		}
		*/

		return $array;
	}





}
