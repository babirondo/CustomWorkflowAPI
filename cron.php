<?php
namespace raiz;

error_reporting(E_ALL ^ E_DEPRECATED);

require_Once("classes/class_sla.php");

$sla = new SLA();

$sla->checkar_todos_SLAs(null);
mail("bruno.siqueira@walmart.com",   "rodou o cron", "cron rodou");

?>
