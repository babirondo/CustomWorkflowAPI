<?php
<<<<<<< HEAD

 
=======
namespace raiz;

>>>>>>> 1f96ce4823dc26c15f7fc23aa71d9f3171175230
error_reporting(E_ALL ^ E_DEPRECATED);

require_Once("classes/class_sla.php");

$sla = new SLA();

<<<<<<< HEAD
//$sla->checkar_todos_SLAs(  "40,49,50"  );
$sla->checkar_todos_SLAs(   null  );
//NOTE: notaaaa
=======
$sla->checkar_todos_SLAs(null);
>>>>>>> 1f96ce4823dc26c15f7fc23aa71d9f3171175230

?>
