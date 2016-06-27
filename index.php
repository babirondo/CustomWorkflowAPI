<?php
error_reporting(E_ALL ^ E_DEPRECATED);

//require_Once("classes/globais.php");
require_Once("classes/class_workflow.php");
require_Once("classes/class_postos.php");
require_Once("classes/class_posto_usuario.php");
require_Once("classes/class_Auth.php");
require_Once("classes/class_relatorios.php");
require_Once("classes/class_processos.php");

require 'vendor/autoload.php';
// tentando commitar pro github
 /// teste no atom

//instancie o objeto
$app = new \Slim\Slim( array(
    'debug' => true,
    'templates.path' => './templates'
) );
\Slim\Slim::registerAutoloader();



//defina a rota
//CHANGED: akkaakakk

$app->post('/Relatorios/', function (    ) use ($app)  {
	$Relatorios = new Relatorios(  );
	$Relatorios->extrair_dados($app,   $app->request->getBody());
}  );

$app->get('/getWorkflows/', function () use ($app)  {
	$Workflow = new Workflow();
	$Workflow->getWorkflows($app );
}  );

$app->post('/:idworkflow/getPostos/', function ( $idworkflow ) use ($app)  {
	$Postos = new Postos(  );
	$Postos->getPostos($app, $idworkflow , $app->request->getBody());
}  );

$app->get('/:idworkflow/:processo/getPosto/:idposto', function ( $idworkflow , $processo, $idposto ) use ($app)  {
	$Postos = new Postos(  );
	$Postos->getCampos($app, $idworkflow, $idposto , $processo);
}  );
$app->post('/:idworkflow/getPosto/Lista/:idposto', function ( $idworkflow , $idposto) use ($app)  {
	$Postos = new Postos(  );
	$Postos->getLista($app, $idposto , $app->request->getBody());
}  );

$app->post('/Registrar/:idworkflow/:idposto', function ( $idworkflow , $idposto) use ($app)  {
	$Workflow = new Workflow(  );
	$Workflow->Registrar($app, $app->request->getBody(), $idposto );
}  );

$app->post('/Autenticar/', function () use ($app)  {



	$Auth = new Auth();
	$Auth->Autenticar($app, $app->request->getBody() );
}  );

$app->post('/Posto/Associar/:idposto', function (  $idposto) use ($app)  {
	$Posto_Usuario = new Posto_Usuario(  );
	$Posto_Usuario->AssociarProcessonoPosto($app, $app->request->getBody(), $idposto );
}  );

$app->post('/Posto/Desassociar/:idposto', function (  $idposto) use ($app)  {
	$Posto_Usuario = new Posto_Usuario(  );
	$Posto_Usuario->DesassociarProcessonoPosto($app, $app->request->getBody(), $idposto );
}  );


$app->get('/Usuarios/Posto/:idposto', function (  $idposto) use ($app)  {
	$Postos = new Postos(  );
	$Postos->UsuariosdoPosto($app, $idposto );
}  );


$app->get('/VidaProcesso/:idprocesso', function (  $idprocesso) use ($app)  {
	$Processos = new Processos(  );
	$Processos->Vida_Processo($app, $idprocesso );
}  );


//rode a aplicação Slim
$app->run();
