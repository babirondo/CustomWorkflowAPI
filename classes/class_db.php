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
	
	
	function executa($sql)
	{
	//	 echo "\n".$sql;
		$this->dados = null;
		
		 
		 if (substr(TRIM(STRTOUPPER($sql)),0,strpos(TRIM(STRTOUPPER($sql)), " " )  ) == "SELECT")
		 {
		 	
		 	//select
		 	$select = 1;
		 	$this->res = $this->pdo->query($sql);
		 	
		 }
		 else{
		 
		 	//others
		 	$this->res = $this->pdo->exec($sql);
		 	
		 }
		 	 
   		
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
