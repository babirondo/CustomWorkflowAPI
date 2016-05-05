<?php
error_reporting(E_ALL ^ E_DEPRECATED);
 

// testando o commit do github

//adt for windows 64 http://dl.google.com/android/adt/adt-bundle-windows-x86_64-20140702.zip
// commit feito pelo mac
require_Once("classes/globais.php");
require_Once("classes/class_workflow.php");
require_Once("classes/class_postos.php");

require 'vendor/autoload.php';
// tentando commitar pro github 
 
//instancie o objeto
$app = new \Slim\Slim( array(
    'debug' => true,
    'templates.path' => './templates'
) );
\Slim\Slim::registerAutoloader();
 
//defina a rota

$app->get('/getWorkflows/', function () use ($app)  {
	$Workflow = new Workflow();
	$Workflow->getWorkflows($app );
}  );


$app->get('/:idworkflow/getPostos/', function ( $idworkflow ) use ($app)  {
	$Postos = new Postos(  );
	$Postos->getPostos($app, $idworkflow );
}  );

$app->get('/:idworkflow/getPosto/:idposto', function ( $idworkflow , $idposto) use ($app)  {
	$Postos = new Postos(  );
	$Postos->getCampos($app, $idworkflow, $idposto );
}  );
$app->get('/:idworkflow/getPosto/Lista/:idposto', function ( $idworkflow , $idposto) use ($app)  {
	$Postos = new Postos(  );
	$Postos->getLista($app, $idposto );
}  );

$app->post('/Registrar/:idworkflow/:idposto', function ( $idworkflow , $idposto) use ($app)  {
	$Workflow = new Workflow(  );
	$Workflow->Registrar($app, $app->request->getBody(), $idposto );
}  );


//rode a aplicação Slim 
$app->run();
