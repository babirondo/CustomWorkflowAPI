<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Postos{
	function Postos( ){
		
		require_once("classes/class_db.php");
		include_once("classes/globais.php");
                
		$this->con = new db();
		$this->con->conecta();
                
                
                $this->globais = new Globais();
                
	}
	
        function UsuariosdoPosto($app, $idposto  ){
            $array = $this->getUsuarios($idposto);
            
            $array["resultado"] = "SUCESSO";

            $data =  	$array;

            $app->render ('default.php',$data,200);
        }
        
	function getUsuarios($idposto  ){
                    
            $sql = "select ua.idusuario, ua.idator, wp.id idposto, u.nome
                    from usuario_atores ua
                            INNER JOIN workflow_postos wp ON (wp.idator = ua.idator)
                            INNER JOIN usuarios u ON (u.id = ua.idusuario)
                    where wp.id= $idposto and u.admin is null ";
         //   echo "\n\n\n".$sql;
            $this->con->executa( $sql);

            while ($this->con->navega(0)){
                $array["USUARIOS_POSTO"]
                        [$this->con->dados["idposto"]]
                        [$this->con->dados["idusuario"]]   = $this->con->dados["nome"];
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
			$array["FETCH"][$i]["idposto"]  = $this->con->dados["id"];
			$array["FETCH"][$i]["lista"]  = $this->con->dados["lista"];
			
 
			
			$i++;
		}
		
		$array["resultado"] = "SUCESSO";

		$data =  	$array;
		
		$app->render ('default.php',$data,200);
	
	}
	
	function BuscarDadosProcesso($idprocesso , $idposto,  $debug = null, $listar="Lista")
	{
            // buscando dados -> indexado por idprocesso 
            $array_dopai = $this->BuscarDadosdoFilhoePai($idposto, $idprocesso, $debug, $listar);

            return $array_dopai;
	}
	
	function LoadCampos(  $idposto, $idprocesso, $posto="entrando", $debug=null, $listar="Lista" ){
            // busca o email dos atores do posto
            $sql ="select u.email
                    from workflow_postos wp 
                        inner join atores  a ON (a.id = wp.idator)
                        inner join usuario_atores ua ON (ua.idator = a.id)
                        inner join usuarios u ON (u.id = ua.idusuario)
                    where  wp.id = $idposto ";
            $this->con->executa($sql);

            $emails = null;
            while ($this->con->navega(0)){
                $emails[$this->con->dados["email"]]  = $this->con->dados["email"];
            }
            if (is_array($emails))
                    $array["DADOS_POSTO"] [atores]  = implode(",",$emails);

            //buscando dados do posto
            $sql ="Select wp.*, nsp.de, nsp.para, nsp.titulo, nsp.corpo
                    from workflow_postos  wp
                            LEFT JOIN notificacoes_email nsp ON (nsp.id = wp.".(($posto=="entrando")?"notif_entrandoposto":"notif_saindoposto").")
                    WHere wp.id = $idposto  ";
          //  if ($debug) echo $sql;
            $this->con->executa($sql);

            $this->con->navega(0);
            $array["DADOS_POSTO"] [nomeposto]  = $this->con->dados["posto"];
            $array["DADOS_POSTO"] [idworkflow]  = $this->con->dados["id_workflow"];
            $array["DADOS_POSTO"] [starter]  = $this->con->dados["starter"];
            $array["DADOS_POSTO"] [de]  = $this->con->dados["de"];
            $array["DADOS_POSTO"] [para]  = $this->con->dados["para"];
            $array["DADOS_POSTO"] [titulo]  = $this->con->dados["titulo"];
            $array["DADOS_POSTO"] [corpo]  = $this->con->dados["corpo"];
            $array["DADOS_POSTO"] [avanca_processo]  = $this->con->dados["avanca_processo"];
            $array["DADOS_POSTO"] [notif_entrandoposto]  = $this->con->dados["notif_entrandoposto"];
            $array["DADOS_POSTO"] [notif_saindoposto]  = $this->con->dados["notif_saindoposto"];
            $array["DADOS_POSTO"] [tipodesignacao]  = $this->con->dados["tipodesignacao"];

            $this->con->executa( "Select * from postos_campo WHere idposto = $idposto  ");
            //$this->con->navega();

            while ($this->con->navega(0)){
                    $array["FETCH_CAMPO"][$this->con->dados["id"]] ["obrigatorio"]  = $this->con->dados["obrigatorio"];
                    $array["FETCH_CAMPO"][$this->con->dados["id"]] ["maxlenght"]  = $this->con->dados["maxlenght"];
                    $array["FETCH_CAMPO"][$this->con->dados["id"]] ["inputtype"]  = $this->con->dados["inputtype"];
                    $array["FETCH_CAMPO"][$this->con->dados["id"]] ["txtarea_cols"]  = $this->con->dados["txtarea_cols"];
                    $array["FETCH_CAMPO"][$this->con->dados["id"]] ["txtarea_rows"]  = $this->con->dados["txtarea_rows"];
                    $array["FETCH_CAMPO"][$this->con->dados["id"]] ["campo"]  = $this->con->dados["campo"];
                    $array["FETCH_CAMPO"][$this->con->dados["id"]] ["idcampo"]  = $this->con->dados["id"];
            }		

            //if ($debug) var_dump($array);

            // buscando os registros do posto, direcionado pelo idprocesso
            $array_dados = $this->BuscarDadosProcesso($idprocesso , $idposto, $debug, $listar);

            if ($debug){
              echo "BuscarDadosProcesso = $idprocesso = $idposto"; 
              var_dump($array_dados);
  
            } 
            if (is_array($array_dados))
                    //$array_completo =  array_merge($array_dados, $array);
                    $array_completo =  $this->ArrayMergeKeepKeys($array_dados, $array);

            else
                    $array_completo = $array;

            //if ($debug) var_dump($array_completo);


            $array_completo["resultado"] = "SUCESSO";

            if ($debug){
                    //var_dump($array_completo);
                    //echo $posto;	
            }

            return $array_completo;	
	
	}
	

	function getCampos($app, $idworkflow , $idposto, $idprocesso ){
		$data = $this->LoadCampos($idposto, $idprocesso );		
		$app->render ('default.php',$data,200);
	}
	
	function BuscarDadosdoFilhoePai($idposto, $idprocesso=null, $debug=null, $listar = "Lista")
	{
		// BUSCANDO DADOS DO PAI
		$sql = "
		SELECT pc.campo, w.valor, w.idprocesso, p.idpai, p.status, pc.id idcampo
		FROM postos_campo_lista pcl
		INNER JOIN postos_campo pc ON (pc.id = pcl.idpostocampo)
		INNER JOIN workflow_postos wp ON (wp.id = pcl.idposto)
		LEFT JOIN workflow_dados w ON (w.idpostocampo = pcl.idpostocampo )
		LEFT JOIN processos p ON (p.id = w.idprocesso)
		
		WHERE wp.id  =   $idposto   ". (($idprocesso>0)?" and p.id = $idprocesso":"");
		$this->con->executa($sql );
		//if ($debug) echo "<PRE>$sql</pre>";
		
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
                    $pai[$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ]   = $this->con->dados["valor"];
                  //  $pai[$this->con->dados["idprocesso"]][Designado]   = $this->con->dados["idusuario_designado"];

                    $array["TITULO"][$this->con->dados["idcampo"]]   = $this->con->dados["campo"];
                    $i++;
		}
		
			
		//var_dump($pai);
			
		// BUSCANDO DADOS DO FILHO
		
                switch ($listar)
                {
                    case ("Lista"):
                        $comp = "left join postos_campo_lista pcl ON (pcl.idpostocampo = pc.id and pcl.idposto = wp.id)";
                        $camp = ", pcl.id estaprevistapralista";
                    break;
                }
                
                $sql = " SELECT pc.campo, w.valor, w.idprocesso, p.idpai, wt.id idworkflowtramitacao, 
                                p.status, w.idpostocampo idcampo, w.id idworkflowdado, 
                                wp.tipodesignacao  $camp
                        FROM  processos p 
                            INNER JOIN workflow_tramitacao wt ON ( wt.idprocesso = p.id  and wt.fim is null) --
                            
                            INNER JOIN workflow_postos wp ON (wp.id = wt.idworkflowposto)
                            INNER JOIN workflow_dados w ON (w.idprocesso = p.id  )
                            LEFT JOIN  postos_campo pc ON ( pc.id = w.idpostocampo )   
                            $comp
                        WHERE wp.id=$idposto and ((  w.idposto=wp.id) OR ( w.idpostocampo >0)) ".(($idprocesso>0)?" and p.id = $idprocesso":"");                
        	$this->con->executa( $sql);
 		
             //   echo "<PRE>$sql</pre>";
		$i=0;
		while ($this->con->navega(0)){
                    $idworkflowdado_assumir = null;
                    
                    $array["FETCH"][$this->con->dados["idprocesso"]][$this->con->dados["idcampo"] ]   = $this->con->dados["valor"];
                    $array["FETCH"][$this->con->dados["idprocesso"]][idworkflowtramitacao ]   = $this->con->dados["idworkflowtramitacao"]; 

                    
                  //  var_dump($this->SYS_DEPARA_CAMPOS);
                    
                    switch ( $this->con->dados["idcampo"] )
                    {
                        case( $this->globais->SYS_DEPARA_CAMPOS["Responsável"] ):
                            $array["FETCH"]  [$this->con->dados["idprocesso"] ][idworkflowdado_assumir]   = $this->con->dados["idworkflowdado"];  
                            $idworkflowdado_assumir = "teve";
                        break;
                    }
                   
                    if (is_array($pai[$this->con->dados["idpai"]]) )
                    {
                        $array["FETCH"][$this->con->dados["idprocesso"]] = $this->ArrayMergeKeepKeys($pai[$this->con->dados["idpai"]], $array["FETCH"][$this->con->dados["idprocesso"]] );
                    }

                    if ($this->con->dados["estaprevistapralista"])   
                        $array["TITULO"][$this->con->dados["idcampo"]]   = $this->con->dados["campo"];
                    else if ($idworkflowdado_assumir == "teve")
                        $array["TITULO"][$this->con->dados["idcampo"]]   = array_search($this->con->dados["idcampo"], $this->globais->SYS_DEPARA_CAMPOS);

                    $i++;
		}
		
		
                // BUSCANDO ATRIBUTOS DO PROCESSO
		$sql = "
                    select *, p.status p_status, p.id idprocesso, to_char(wt.inicio, 'dd/mm/yyyy') wt_inicio ,
                                    to_char(p.inicio, 'dd/mm/yyyy') p_inicio 
                    from workflow_tramitacao wt 
                            inner join postos_campo_lista pcl ON (pcl.idposto = wt.idworkflowposto)
                            INNER JOIN workflow_postos wp ON (wp.id = pcl.idposto)
                            inner join processos p ON (p.id = wt.idprocesso)

                    where wt.fim is null and wp.id =$idposto and pcl.idpostocampo is null   ".(($idprocesso>0)?" and p.id = $idprocesso":"");

		$this->con->executa( $sql);
		//if ($debug) echo "<PRE>$sql</pre>";
		//echo "<PRE>$sql</pre>";
		
		//$this->con->navega();
		
		$i=0;
		while ($this->con->navega(0)){
                    $array["FETCH"][$this->con->dados["idprocesso"]][$this->con->dados["atributo_campo"] ]   = $this->con->dados [ $this->con->dados["atributo_valor"] ];
                    $array["TITULO"][$this->con->dados["atributo_campo"]]   = $this->con->dados["atributo_campo"];

                    $i++;
		}
                
		return $array;
	}
	
	Function ArrayMergeKeepKeys() {
		$arg_list = func_get_args();
		
		foreach((array)$arg_list as $arg){
			if (is_array ($arg) )
			{
				foreach((array)$arg as $K => $V){
					$Zoo[$K]=$V;
				}
				
			}
		}
		return $Zoo;
	}
	
	
	function getLista($app,   $idposto ){
                $debug= 0;
		//$array = $this->BuscarDadosdoFilhoePai($idposto, null, $debug, "Lista"); // xxx
               
                $array = $this->LoadCampos(  $idposto, null, null, $debug ,  "Lista" );
                //  var_dump($array );
		
		$this->con->executa( "select * 
                                    from posto_acao pa
                                            inner join workflow_postos wp ON (wp.id = pa.goto)
                                    where pa.idposto =  $idposto    ");
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
			$array["ACOES"]  [$array["DADOS_POSTO"][tipodesignacao] ][ir]   = $idposto; // proximo posto
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