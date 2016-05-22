<?php

error_reporting(E_ALL ^ E_DEPRECATED);
echo "funcionando ";

 

require_once("classes/class_db.php");
 
            $con = new db();
            $con->conecta();	

?>