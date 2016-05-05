<?php
class db  
{

	
	
	function conecta() 
	{
		$localhost = "localhost";
		$db ="customworkflow";
		$username = "postgres";
		$password = "rodr1gues";
		
		try { 
			$this->pdo = new PDO("pgsql:host=$localhost;dbname=$db", $username, $password); 
			$this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
			 
		} 
		catch(PDOException $e) { 
			echo 'Error: ' . $e->getMessage();
		}		
	}
	
	
	function executa($sql, $prepared=0)
	{
		$this->dados = null;
	
		
	//	$show_sql = 1;
		 
		 if (substr(TRIM(STRTOUPPER($sql)),0,strpos(TRIM(STRTOUPPER($sql)), " " )  ) == "SELECT")
		 {
		 	
		 	//select
		 	$select = 1;
		 	$this->res = $this->pdo->query($sql);
		 	$this->nrw = $this->res->rowCount();
		 }
		 else{
		 	if ($prepared == 1)
		 	{
		 		$stmt = $this->pdo->prepare($sql);
		 		//$stmt->bindParam(":val", $prepared, PDO::PARAM_STR);
		 		if ($stmt->execute()){
		 			$this->res = true;
		 			$this->dados = $stmt->fetch(PDO::FETCH_ASSOC);
		 			
		 		}
		 		else
		 			$this->res = false;				
		 	}
		 	else{
		 		//others
		 		$this->res = $this->pdo->exec($sql);
		 		//$a =  $this->pdo->fetchAll(); var_dump($a);
		 				 
		 	}		 	
		 }
		 if ($show_sql) echo "\n BBBBBB ".$sql;
		 		
   		
	//	var_dump($this->res);
   		
   		
		
   		
   		if ( $this->res > 0 ){
   			

   			//if ($select == 1)
   			//	$this->navega(0);
   			//else
   				return true;
   		}	
   		else{
   			
   			return false;
   			
   		}
	}
	
	function navega( ){
		
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
