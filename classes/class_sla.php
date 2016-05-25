<?php
error_reporting(E_ALL ^ E_DEPRECATED);

class SLA{
//        void __construct ([ mixed $args [, $... ]] )
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
             if ($idsla)
                $sql = "select * from sla where id IN ($idsla) ";
             else
                $sql = "select * from sla   ";
            //$sql = "select * from sla   ";
            //$sql = "select * from sla where idpai is not null ";
            
            $this->con->executa( $sql);

            while ($this->con->navega(0)){

                // notificacoes simples
                    $sql = "select ".$this->con->dados["campo_localizador"]." chave ,  COUNT(*) as qtde
                            from ".$this->con->dados["tabela"]."  
                            where  (NOW() - ".$this->con->dados["campo_calculado"].") >  INTERVAL '".$this->con->dados["sla_emhorascorridas"]." minutes'  "
                                  . (($this->con->dados["where_tabela"])?" and ".$this->con->dados["where_tabela"]:"")
                            ."  GROUP BY 1  ";
                           
                        ;
                    $this->con2->executa( $sql);

                    if ($this->con2->nrw >0)
                    {
                        while ($this->con2->navega(0)){

                                                                                           
                            if (
                                !$this->notificacoes->notifica_sla_vencido(
                                    $this->con->dados["id"], 
                                    $this->con->dados["idnotificacao"],  
                                    $this->con2->dados["chave"]  ) 
                                )
                            {
                                echo "<BR><font color=#ff0ff> deu erro </font>";
                            }


                            
                        }                    
                    }                    
            }
        }
	
	 
}
?>