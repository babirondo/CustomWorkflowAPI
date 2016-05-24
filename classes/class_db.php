<?php 
set_time_limit( 2 ); 
class db  
{
	function conecta() 
	{
                $usar = "windows";
                $usar = "mac";

                if ($usar == "windows"){
                    // windows
                      $localhost = "127.0.0.1";
                      $db ="customworkflow";
                      $username = "postgres";
                      $password = "rodr1gues";

                }
                else{
                            // mac
                       $localhost = "localhost";
                       $db ="customworkflow";
                       $username = "postgres";
                       $password = "rodr1gues";

                }
              
               
		try { 
			$this->pdo = new PDO("pgsql:host=$localhost;dbname=$db", $username, $password); 
			$this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
			$this->pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, true );
                         

                        
		} 
		catch(PDOException $e) { 
			$this->erro =  'Error: ' . $e->getMessage();
                        $this->conectado = false;
                        return false;
		}	
                $this->conectado = true;
              
                
                return true;
	}
	
	
	function executa($sql, $prepared=0, $l=__LINE__, $debug=null)
	{

            $this->dados = null;
           
             if (substr(TRIM(STRTOUPPER($sql)),0,strpos(TRIM(STRTOUPPER($sql)), " " )  ) == "SELECT")
             {
                 
                   
               

		try { 
                    //select

                   
                    $select = 1;
                    $this->res = $this->pdo->query($sql);
                     
                    if ($this->res)
                        $this->nrw = $this->res->rowCount();
                    else
                        $this->nrw = null;

                } 
		catch(PDOException $e) { 

                    // if ($debug == 1)
			echo "Error PDO: <font color=#00aa00>$sql</font>" . $e->getMessage();
                     
		}                
		catch(Exception $e) { 

                    // if ($debug == 1)
			echo 'Error EXCEPTION: ' . $e->getMessage();
                     
		}                

                finally {
                    // após exceptions roda isso
			 
                }

                return $this->res;
             }
             else{
                //echo "\n ($l) $sql";
//                echo "$sql \n"; 
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
		
            $this->dados = $this->res->fetch(PDO::FETCH_ASSOC, $i );	

            if ($this->dados  ){
                    return   true ;
            }	
            else{
                    return   false;
            } 
				
	}
	
}
?>
