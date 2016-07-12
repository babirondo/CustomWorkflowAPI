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

        function UsuariosdoPosto($app, $idfeature  ){
            $array = $this->getUsuarios($idfeature);

            $array["resultado"] = "SUCESSO";

            $data =  	$array;

            $app->render ('default.php',$data,200);
        }

	function getUsuarios($idfeature  ){

            $sql = "select ua.idusuario, ua.idator, wp.id idfeature, u.nome
                    from usuario_atores ua
                            INNER JOIN workflow_postos wp ON (wp.idator = ua.idator)
                            INNER JOIN usuarios u ON (u.id = ua.idusuario)
                    where wp.id= $idfeature and u.admin is null ";
         //   echo "\n\n\n".$sql;
            $this->con->executa( $sql);

            while ($this->con->navega(0)){
                $array["USUARIOS_POSTO"]
                        [$this->con->dados["idfeature"]]
                        [$this->con->dados["idusuario"]]   = $this->con->dados["nome"];
            }

            return $array;
	}


	function getUsuariosbyTecnologia($idtecnologia  ){

            $sql = "select u.id
                    from usuarios u
                           inner join usuarios_avaliadores_tecnologias uat ON (uat.idusuario = u.id)
                    where uat.idtecnologia =$idtecnologia ";
           // echo $sql;
            $this->con->executa( $sql);

            while ($this->con->navega(0)){
                $array["USUARIO_TECNOLOGIA"] [$idtecnologia][]    = $this->con->dados["id"];
            }

            return $array;
	}


	function getPostos($app, $idworkflow , $jsonRAW){
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
            from workflow_postos wp
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
			$array["FETCH"][$i]["posto"]  = $this->con->dados["posto"];
			$array["FETCH"][$i]["idfeature"]  = $this->con->dados["id"];
			$array["FETCH"][$i]["lista"]  = $this->con->dados["lista"];



			$i++;
		}

		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);

	}

	function BuscarDadosProcesso($idprocesso , $idfeature,  $debug = null, $listar="Lista", $posto, $jsonfiltros = null)
	{
            // buscando dados -> indexado por idprocesso
            $array_dopai = $this->BuscarDadosdoFilhoePai($idfeature, $idprocesso, $debug, $listar, $posto, $jsonfiltros);

            return $array_dopai;
	}

	function LoadCampos(  $idfeature   ){
            if ($idfeature>0)
            {


                //buscando dados do posto
                $sql ="SELECT * FROM eng_features WHERE id = $idfeature  ";
                //echo $sql;
                $this->con->executa($sql);

                $p=0;
                while ($this->con->navega($p)){

                    $array["DADOS_POSTO"] [nomefeature]  = $this->con->dados["feature"];
                    $p++;
                }

                $this->con->executa( "Select * from eng_feature_campo WHere idfeature = $idfeature  ");

                while ($this->con->navega(0)){
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["obrigatorio"]  = $this->con->dados["obrigatorio"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["maxlenght"]  = $this->con->dados["maxlenght"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["inputtype"]  = $this->con->dados["inputtype"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["dica_preenchimento"]  = $this->con->dados["dica_preenchimento"];

                        if ($this->globais->Traduzir( $this->con->dados["valor_default"] ) == false )
                                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["valor_default"]  =  $this->con->dados["valor_default"];
                        else {
                                $array["FETCH_CAMPO"][$this->con->dados["id"]] ["valor_default"]  =  $this->campo->BuscarValoresCampo($this->con->dados["valor_default"]);
                        }
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["txtarea_cols"]  = $this->con->dados["txtarea_cols"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["txtarea_rows"]  = $this->con->dados["txtarea_rows"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["campo"]  = $this->con->dados["campo"];
                        $array["FETCH_CAMPO"][$this->con->dados["id"]] ["idcampo"]  = $this->con->dados["id"];
                }
            }


            // buscando os registros do posto, direcionado pelo idprocesso
            //$array_dados = $this->BuscarDadosProcesso($idprocesso , $idfeature, $debug, $listar, $posto, $jsonfiltros);


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
                    //echo $posto;
            }

            return $array_completo;

	}


        function LoadCamposbyProcesso(  $idprocesso  ){

            $array = $this->LoadCampos( null, $idprocesso, null, null, null );
            return $array;

	}

	function getCampos($app, $idfeature  ){
		$data = $this->LoadCampos($idfeature  );
		$app->render ('default.php',$data,200);
	}

	function BuscarDadosdoFilhoePai($idfeature, $idprocesso=null, $debug=null, $listar = "Lista", $posto, $jsonfiltros= null)
	{
				$filtros = json_decode( $jsonfiltros, true );
			//  $filtros = json_decode($jsonfiltros);
				if (is_array($filtros))
				{

					foreach ($filtros as $filtrando ){
						if ($filtrando != -1 && $filtrando){
							$fils[] = "'$filtrando'" ;
						}
					}
					if (is_array($fils) )
					{
						$gowhere_filtro = implode(",", $fils);
						if ($gowhere_filtro) $gowhere_filtro = " and w.valor IN (".$gowhere_filtro.")";
					}
				}

				$busca_so_dados_do_posto = "left";
			  $busca_entidades = "wt.idprocesso = p.id";

        switch ($listar)
        {
            case ("Lista"):
                $comp = "left join postos_campo_lista pcl ON (pcl.idfeaturecampo = pc.id and pcl.idfeature = wp.id)";
                $camp = ", pcl.id estaprevistapralista";
            break;

						case ("VidaProcesso"):
                $busca_so_dados_do_posto = "inner";
								$orderby = " ORDER BY wt.inicio";
								$posto = "saindo";
								$busca_entidades = "wt.idprocesso IN (ap.proprio, ap.avo, ap.filho, ap.bisavo )";
								$sodados_doposto = "and w.idworkflowtramitacao = wt.id";
            break;


        }
        if ($idfeature>0){
            $comp_ini = "wp.id=$idfeature and wt.idworkflowposto =$idfeature and ";
        }
				//FIXME: criar recorrencia na arvore_processo via banco.... hoje ta estatico
        $sql = "SELECT pc.campo, w.valor, p.id idprocesso, p.idpai, wt.id idworkflowtramitacao,
											w.idworkflowtramitacao idworkflowtramicao_dados,
                     p.status, w.idfeaturecampo idcampo, wt.id_usuario_associado tramitacao_idusuario,
                     u.nome tramitacao_usuario, u.nome usuarioassociado,
                     wp.tipodesignacao  $camp
                     , wt.idworkflowposto, wt.fim, w.idfeature,
										 wt.inicio wt_inicio, wt.fim wt_fim, fp.tipofiltro, fp.id idfiltro
             FROM  arvore_processo ap
					  		 INNER JOIN processos p ON (p.id = ap.proprio)
                 INNER JOIN workflow_tramitacao wt ON ( $busca_entidades  ".(($posto=="saindo")?"  ": " and wt.fim is null " )."  )
                 $busca_so_dados_do_posto JOIN workflow_dados w ON (w.idprocesso IN (ap.proprio, ap.avo, ap.filho, ap.bisavo ) $sodados_doposto )
                 INNER JOIN workflow_postos wp ON (wp.id = wt.idworkflowposto)
                 LEFT JOIN  postos_campo pc ON ( pc.id = w.idfeaturecampo )
                 LEFT JOIN usuarios u ON (u.id = wt.id_usuario_associado)
								 LEFT JOIN filtros_postos fp ON (fp.idfeature = wp.id and fp.idfeaturecampo = pc.id)
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


							$array["FETCH_POSTO"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ]   = $array["FETCH"] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ]   =  $this->campo->BuscarValoresCampo (  $this->con->dados["valor"] ,  $this->con->dados["idcampo"] );
							$array["FETCH_POSTO"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"]."-original" ]   = $array["FETCH"] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"]."-original" ]   = $this->con->dados["valor"];

							// seta a info para o filtro
							if ($this->con->dados["idfiltro"] > 0)
								$array["FILTROS_POSTO"] [$this->con->dados["idfiltro"]] ["ITENS"][$array["FETCH_POSTO"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ]] = $array["FETCH_POSTO"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ];

               $array["FETCH"] [$this->con->dados["idprocesso"]][tramitacao_idusuario ]   = $this->con->dados["tramitacao_idusuario"];

            //   $array["FETCH"] [$this->con->dados["idprocesso"]]["POSTO_ATUAL" ][$this->con->dados["idworkflowposto"]]   = $this->con->dados["idworkflowposto"];


               if ($this->con->dados["tramitacao_idusuario"]>0){
                    $array["FETCH_POSTO"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ."-ID"] = $array["FETCH"] [$this->con->dados["idprocesso"]][ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ."-ID"]   = $this->con->dados["tramitacao_idusuario"];
                    $array["FETCH_POSTO"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ] = $array["FETCH"] [$this->con->dados["idprocesso"]][ $this->globais->SYS_DEPARA_CAMPOS["Responsavel"] ]   = $this->con->dados["tramitacao_usuario"];
                    $idworkflowdado_assumir = "teve";
               }

                // adiciona ao Fetch os valores que sao buscados na traducao dos colchetes nos emails
                foreach ($this->globais->SYS_ADD_CAMPOS as $idx => $val){
                    $array["FETCH_POSTO"] [$this->con->dados["idworkflowtramitacao"]] [$this->con->dados["idprocesso"]][$idx] = $array["FETCH"] [$this->con->dados["idprocesso"]][$idx]   =   $this->con->dados["$val"]  ;
                }

                $array["FETCH"] [$this->con->dados["idprocesso"]][idworkflowtramitacao ]   = $this->con->dados["idworkflowtramitacao"];

               if ($this->con->dados["estaprevistapralista"])
                   $array["TITULO"] [$this->con->dados["idcampo"]]   = $this->con->dados["campo"];
               else if ($idworkflowdado_assumir == "teve")
                   $array["TITULO"] [-1]   = array_search(-1, $this->globais->SYS_DEPARA_CAMPOS);

//							 $array["FETCH_POSTO"] [$this->con->dados["idfeature"]] [$this->con->dados["idprocesso"]]  = $this->globais->ArrayMergeKeepKeys($array["FETCH_POSTO"] [$this->con->dados["idfeature"]] [$this->con->dados["idprocesso"]], $array["FETCH"] [$this->con->dados["idprocesso"]])		 	;

               $i++;
        }



        if ( $idfeature>0 )
        {
            $comp_ini = " and wp.id =$idfeature ";
        }
                // BUSCANDO ATRIBUTOS DO PROCESSO
		$sql = "
                    select *, p.status p_status, p.id idprocesso, to_char(wt.inicio, 'dd/mm/yyyy') wt_inicio ,
                                    to_char(p.inicio, 'dd/mm/yyyy') p_inicio ,wt.idworkflowposto, p.inicio entradanoposto,
                                    u.nome usuarioassociado
                    from workflow_tramitacao wt
                            inner join postos_campo_lista pcl ON (pcl.idfeature = wt.idworkflowposto)
                            INNER JOIN workflow_postos wp ON (wp.id = pcl.idfeature)
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

		return $array;
	}



	function getLista($app,   $idfeature , $jsonRAW){


    	$debug= 0;
		//$array = $this->BuscarDadosdoFilhoePai($idfeature, null, $debug, "Lista"); // xxx

	    $array = $this->LoadCampos(  $idfeature, null, null, $debug ,  "Lista" , $jsonRAW);
	                //  var_dump($array );

			$this->con->executa( "select *
	                          from posto_acao pa
	                                  inner join workflow_postos wp ON (wp.id = pa.goto)
	                          where pa.idfeature =  $idfeature    ");
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


      switch ($array["DADOS_POSTO"][tipodesignacao])
      {
          case("AUTO-DIRECIONADO"):
          case("Assumir"):
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][acao]   = "Assumir"; // Nome do Link
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][ir]   = $idfeature; // proximo posto
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][lista]   = "L"; // L ou F
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][idworkflow]   = $array["DADOS_POSTO"][idworkflow];//$this->con->dados["id_workflow"];
	    			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][assumir]   = 1;//$this->con->dados["id_workflow"];
          break;

          default:
		//$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][acao]   = $array["DADOS_POSTO"][tipodesignacao]; // Nome do Link
      }



		$array["resultado"] = "SUCESSO";

		$data =  	$array;

		$app->render ('default.php',$data,200);


	}

}
