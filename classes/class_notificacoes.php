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
            $sql = "select trim(tabela) tabela, trim(campo_localizador) campo_localizador from sla where id = '$idsla'  ";
            $this->con->executa( $sql);
            $this->con->navega(0);
            $tipo_chave = $this->con->dados["tabela"];

            $sql = "select  ".$this->con->dados["campo_localizador"]." chave, *
                    from ".$this->con->dados["tabela"]."
                    WHERE  ".$this->con->dados["campo_localizador"]." = '$chave'  ";
            $this->con->executa( $sql);
            $this->con->navega(0);

            $idsla_procura_principal = $idsla;

            while($tipo_chave == "sla_notificacoes sn")
            {
                    $sql = "select id, trim(tabela) tabela from sla where id = (select idpai from sla where id= '$idsla_procura_principal')";
                    $this->con->executa( $sql);
                    $this->con->navega(0);

                    // tipo chave do pai
                    $tipo_chave = $this->con->dados["tabela"];
                    $idsla_procura_principal = $this->con->dados["id"];
            }

            switch ($tipo_chave)
            {
                case("workflow_tramitacao wt"):
                    $sql = "select * from workflow_tramitacao where id = $chave ";
                    $this->con->executa( $sql);
                    $this->con->navega(0);

                    $this->idprocesso =$this->con->dados["idprocesso"];

                    $data = $this->posto->LoadCampos($this->con->dados["idworkflowposto"],$this->idprocesso );

                break;

                case("processos p"):
                    $this->idprocesso =$chave;

                    $data = $this->posto->LoadCamposbyProcesso(  $this->idprocesso );
                break;

                default:
                    echo "Tipo Chave não mapeado: $tipo_chave";
                    $data = null;
                    return false;
                break;
            }
          //  echo " tipo chave:  $tipo_chave <BR> "            ;



            return $data;
        }



	function TraduzirEmail ($texto_original, $data){

            /*
             PARA ADICIONAR CAMPOS NAO DINAMICOS É PRECISO:
             *  -  ADICIONAR NA CLASS_POSTOS->BuscarDadosdoFilhoePai no FETCH
             *  -  ADICIONAR NO GLOBAIS
             */
  //  echo "<pre>"; var_dump($data);exit;

    $de = $this->campos->getCampos(); // 11 = nome do campo
    //echo "<pre>"; var_dump($de);exit;
   // echo "<pre>"; var_dump($data);exit;
    if (is_array($data["FETCH"][$this->idprocesso]))
		{
			foreach ($data["FETCH"][$this->idprocesso] as $campo => $val){
                            /// campo = 11
                            // val = nome do cara
                            $valor [ $campo] = $val;
                            $valor [ $de[$campo] ] = $val;
			}
			foreach ($data["DADOS_POSTO"]  as $campo => $val){
                            /// campo = ATOR
                            // val = EMAILS@EMAIL, EAMIL@EMAIL
                            $valor [ $campo] = $val;
                            //$valor [ $de[$campo] ] = $val;
			}
		}
                //echo "<PRE>"; var_dump($valor); echo "</pre>";// exit;
		// TODO: REsolver a adicao de campos especiais para resolver no email de notificacao
      $valor = $this->globais->ArrayMergeKeepKeys ( $this->globais->SYS_CAMPOS_ESPECIAIS, $valor);

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

		$this->debug .= "<PRE>
de: $de
para: $para
titulo: ".$titulo."
corpo: ".$corpo."


header: $headers</PRE> ";


              // echo "\n\n\n\n".$this->debug;

		//mail($para, $titulo, $corpo, $headers);


                return $this->debug;
	}

	function notif_entrandoposto($idprocesso, $idposto, $proximo_posto = null)
	{

            if ($idposto > 0){

                $this->idprocesso= $idprocesso;
                // puxa dados do posto atual
                $data2 = $this->posto->LoadCampos($idposto, $this->idprocesso );

                if ($proximo_posto >0)
                    $data_fetch = $this->posto->LoadCampos($proximo_posto, $this->idprocesso );
                else
                    $data_fetch = $data2;


                if ($data2["DADOS_POSTO"] [notif_entrandoposto] > 0 )
                {
									foreach ( explode( ",", $this->TraduzirEmail($data2["DADOS_POSTO"] [para], $data_fetch) ) as $email_vez){

										$titulo = $this->TraduzirEmail($data2["DADOS_POSTO"] [titulo], $data_fetch);
                    $corpo = $this->TraduzirEmail($data2["DADOS_POSTO"] [corpo], $data_fetch);
                    $de = $this->TraduzirEmail($data2["DADOS_POSTO"] [de], $data_fetch);


                    $this->EnviaEmail($de, $email_vez, $titulo, $corpo);
									}
									return true;
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
							foreach ( explode( ",", $this->TraduzirEmail($data_atual["DADOS_POSTO"] [para], $data_atual) ) as $email_vez){
								$titulo = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [titulo], $data_atual);
                $corpo = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [corpo], $data_atual);
                $de = $this->TraduzirEmail($data_atual["DADOS_POSTO"] [de], $data_atual);



                 $this->EnviaEmail($de, $email_vez, $titulo, $corpo);
							}
							return true;
            }

	}



        function LoadCampos($idnotificacao)
        {

            //buscando dados do posto
            $sql ="SELECT * FROM notificacoes_email WHERE id =  $idnotificacao  ";
            $this->con->executa($sql );

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

            // puxa dados da notificacao
             $dados_notificacao = $this->LoadCampos($idnotificacao);
          // echo "<Pre>"; var_dump($dados_notificacao);   echo "</Pre>";

            // puxa dados do posto atual
            $data_atual = $this->LoadbyChave($chave, $idsla);
            if (!$data_atual) {
                return false;
            }


            //echo "<Pre>"; var_dump($data_atual);   echo "</Pre>";
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
                    // echo "<BR> Notificacao registrada: idsla $idsla,  idnotif $idnotificacao, chave $chave";
                    $sql ="insert into sla_notificacoes ( idsla, datanotificacao, chave) values ($idsla,  NOW(), $chave) ";
                    $this->con->executa($sql);
               }

	}



}
