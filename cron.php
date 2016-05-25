<?php
error_reporting(E_ALL ^ E_DEPRECATED);

require_Once("classes/class_sla.php");

$sla = new SLA();
$sla->SLA(  );

//$sla->checkar_todos_SLAs(  "40,49,50"  );
$sla->checkar_todos_SLAs(   null  );
 
?> 