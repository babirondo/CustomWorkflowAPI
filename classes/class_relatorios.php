<?php
error_reporting(E_ALL ^ E_DEPRECATED ^E_NOTICE);

class Relatorios{
	function Relatorios( ){
		
		require_once("classes/class_db.php");
		include_once("classes/globais.php");
        require_Once("classes/class_postos.php");  

		$this->con = new db();
		$this->con->conecta();
                
        $this->globais = new Globais();
        $this->postos = new Postos(  );
                
	}

    function extrair_dados($app, $jsonRAW  ){
        // TODO: Retirar gambi do arvore_processo que nao esta dinamico.... mas por hora ta funcionando...
        // TODO: criar sistema verdadeiro de relatorios... por enquanto tudo hardcoded
        

    $sql = "SELECT p.id idprocesso,  p.idtipoprocesso, TO_CHAR(p.inicio,'DD/MM/YYYY') inicio, 
                    w.valor tipovaga,
                    TO_CHAR(p.inicio + '30 days'::interval ,'DD/MM/YYYY') as expiraem,
        --      ap.bisavo, ap.avo, ap.proprio, ap.filho, ap.neto, p_parente.id, p_parente.idtipoprocesso,
                  COUNT(DISTINCT( CASE WHEN (p_parente.idtipoprocesso = 2) then p_parente.id else null end  )) as candidaturas,
                  COUNT(DISTINCT( CASE WHEN (p_parente.idtipoprocesso = 3) then p_parente.id else null end  )) as avaliacoes,
                  COUNT(DISTINCT( CASE WHEN (wt.idworkflowposto = 4) THEN p_parente.id ELSE NULL end )) as roteamento,
                  COUNT(DISTINCT( CASE WHEN (wt.idworkflowposto = 5) THEN p_parente.id ELSE NULL end )) as entrevista_presencial,
                  COUNT(DISTINCT( CASE WHEN (wt.idworkflowposto = 6) THEN p_parente.id ELSE NULL end )) as entrevistados,
                  COUNT(DISTINCT( CASE WHEN (wt.idworkflowposto = 8) THEN p_parente.id ELSE NULL end )) as negociacao,
                  COUNT(DISTINCT( CASE WHEN (wt.idworkflowposto = 7) THEN p_parente.id ELSE NULL end )) as contratado ,
                  COUNT(DISTINCT( CASE WHEN (wt.idworkflowposto = 280) THEN p_parente.id ELSE NULL end )) as arquivados 

        FROM  processos p 
            INNER join workflow_dados w ON (w.idpostocampo = 13 and w.idprocesso = p.id)

            inner join arvore_processo ap ON (ap.proprio = p.id)
            inner join workflow_tramitacao wt ON (wt.idprocesso IN (ap.proprio, ap.filho, ap.avo, ap.bisavo, ap.neto ) and wt.fim is null)
            INNER JOIN processos p_parente ON (p_parente.id = wt.idprocesso)
        --where p.id =47199   
        where p.idtipoprocesso = 1
        group by p.id,  p.idtipoprocesso , p.inicio, expiraem, tipovaga"; 
        $this->con->executa( $sql, 0, __LINE__  );
      //  echo $sql; exit;
        //echo "\n SQL GERADO";
        $i=0;
      
        while ($this->con->navega($i) ){
           

           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "PROCESSO" ]   = $this->con->dados["idprocesso"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "TIPOVAGA" ]   = $this->con->dados["tipovaga"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "INICIO" ]   = $this->con->dados["inicio"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "EXPIRAEM" ]   = $this->con->dados["expiraem"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "CANDIDATURAS" ]   = $this->con->dados["candidaturas"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "AVALIACOES" ]   = $this->con->dados["avaliacoes"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "ROTEAMENTO" ]   = $this->con->dados["roteamento"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "ENTREVISTA_PRESENCIAL" ]   = $this->con->dados["entrevista_presencial"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "ENTREVISTADOS" ]   = $this->con->dados["entrevistados"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "NEGOCIACAO" ]   = $this->con->dados["negociacao"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "CONTRATADO" ]   = $this->con->dados["contratado"];
           $array["RESULTSET"] [$this->con->dados["idprocesso"]][ "ARQUIVADO" ]   = $this->con->dados["arquivado"];

           $array["TITULO"]  [ "PROCESSO" ]   = $this->con->dados["inicio"];
           $array["TITULO"]  [ "TIPOVAGA" ]   = $this->con->dados["tipovaga"];
           $array["TITULO"]  [ "INICIO" ]   = $this->con->dados["inicio"];
           $array["TITULO"]  [ "EXPIRAEM" ]   = $this->con->dados["expiraem"];
           $array["TITULO"]  [ "CANDIDATURAS" ]   = $this->con->dados["candidaturas"];
           $array["TITULO"]  [ "AVALIACOES" ]   = $this->con->dados["avaliacoes"];
           $array["TITULO"]  [ "ROTEAMENTO" ]   = $this->con->dados["roteamento"];
           $array["TITULO"]  [ "ENTREVISTA_PRESENCIAL" ]   = $this->con->dados["entrevista_presencial"];
           $array["TITULO"]  [ "ENTREVISTADOS" ]   = $this->con->dados["entrevistados"];
           $array["TITULO"]  [ "NEGOCIACAO" ]   = $this->con->dados["negociacao"];
           $array["TITULO"]  [ "CONTRATADO" ]   = $this->con->dados["contratado"];
           $array["TITULO"]  [ "ARQUIVADO" ]   = $this->con->dados["arquivado"];



           $i++;
         }

       // var_dump($array );
        $array["resultado"] = "SUCESSO";

        $data =  	$array;

        $app->render ('default.php',$data,200);
    }

	 
	
}