<?php
	$connection = new mysqli("localhost", "root", "", "revoir");
	if (!$connection) {
		echo "connection failed!";
		exit(); 
    }