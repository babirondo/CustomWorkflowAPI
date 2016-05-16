<?php 
set_time_limit( 2 );
class db  
{
	function conecta() 
	{
		$localhost = "localhost";
		$db ="customworkflow";
		$username = "bsiquei";
		$password = "rodr1gues";
		
		try { 
			$this->pdo = new PDO("pgsql:host=$localhost;dbname=$db", $username, $password); 
			$this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
			 
		} 
		catch(PDOException $e) { 
			echo 'Error: ' . $e->getMessage();
		}		
	}
	
	
	function executa($sql, $prepared=0, $l=__LINE__)
	{
            $this->dados = null;

             if (substr(TRIM(STRTOUPPER($sql)),0,strpos(TRIM(STRTOUPPER($sql)), " " )  ) == "SELECT")
             {
                //select
                $select = 1;
                $this->res = $this->pdo->query($sql);
                $this->nrw = $this->res->rowCount();
                
                return $this->res;
             }
             else{
                //echo "\n ($l) $sql";
                 
                if ($prepared == 1)
                {
                      $stmt = $this->pdo->prepare($sql);
                     
                    if ($stmt->execute()){
                           
                        $this->res = true;
                        $this->dados = $stmt->fetch(PDO::FETCH_ASSOC);
                        return true;
                    }
                    else{
                            
                        $this->res = false;	
                         print_r($sql . "\n".$stmt->errorInfo);
                        return false;
                        
                    }
                }
                else{
                    $this->res = $this->pdo->exec($sql);
                    
                    return $this->res;
                }		 	
             }
             
	}
	
	function navega($i ){
		
            $this->dados = $this->res->fetch(PDO::FETCH_ASSOC, $i);	

            if ($this->dados === false ){
                    return   false;
            }	
            else{
                    return   true;
            } 
				
	}
	
}
?>
