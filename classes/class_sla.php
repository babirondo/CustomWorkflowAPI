<?php
class SLA{
	function SLA( ){
		
		require_once("classes/class_db.php");
                require_once("classes/class_notificacoes.php");
		$this->con = new db();
		$this->con->conecta();
                     
		$this->con2 = new db();
		$this->con2->conecta();
                
                
                $this->notificacoes = new Notificacoes();
	}
        
  
        function checkar_todos_SLAs( $idsla )
        {
            $sql = "select * from sla where id=$idsla";
            $sql = "select * from sla  ";
            
            $this->con->executa( $sql);

            while ($this->con->navega(0)){
                $sql = "select ".$this->con->dados["campo_localizador"]." chave
                        from ".$this->con->dados["tabela"]."  
                            
                        where  (NOW() - ".$this->con->dados["campo_calculado"].") >  INTERVAL '".$this->con->dados["sla_emhorascorridas"]." minutes'  "
                              . " and ".$this->con->dados["where_tabela"]." ";
               
                $this->con2->executa( $sql);
                
                if ($this->con2->nrw >0)
                {
                    while ($this->con2->navega(0)){
                        $this->notificacoes->notifica_sla_vencido($this->con->dados["id"], $this->con->dados["idnotificacao"],  $this->con2->dados["chave"] );

                    }                    
                }

               
            }
        }
	
	 
}
?>