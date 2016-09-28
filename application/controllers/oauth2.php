<?php defined('BASEPATH') OR exit('No direct script access allowed');

class OAuth2 extends CI_Controller
{
	function __construct()
	{	parent::__construct();
		if (!isset($_SESSION))
		{	session_start();
		}
		$this->load->library("Oauth2Server");
	}

	function index()
	{	$this->db->where("expires < NOW()")->delete("oauth_authorization_codes");

		$this->oauth2server->check_client_id();
		if ($code = $this->oauth2server->authorize(true))
		{	$response = new OAuth2\Response(array(
				"access_code" => $code,
			));
			$response->send();
		}
	}

	function token()
	{
		if ($this->input->post("grant_type") === "refresh_token")
		{	$this->db->where("expires < NOW()")->delete("oauth_refresh_tokens");
			$this->oauth2server->refresh_token();
		}
		else
		{	$this->db->where("expires < NOW()")->delete("oauth_access_tokens");
			$this->oauth2server->authorization_code("yes");
		}
	}
}
