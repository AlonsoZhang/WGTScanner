<?php
    include_once "js/conf.php";
	$SN     = isset($_REQUEST['SN'])?($_REQUEST['SN']):'';
	$Name   = isset($_REQUEST['Name'])?($_REQUEST['Name']):'';
    if ($SN != '' && $Name != '')
    {
        //$s = "UPDATE wgt_record.WGTrecord SET Becheck='checked', CheckUser = $Name  WHERE Mbsn= $SN and IOleb='inleb'";
        $addcheckstatus =  mysql_query("UPDATE wgt_record.WGTrecord SET Becheck='checked', CheckUser = '$Name'  WHERE Mbsn= '$SN' and IOleb='inleb'");
        // echo $s;
        $check =  mysql_query("SELECT * FROM wgt_record.WGTrecord WHERE Mbsn='$SN' and Becheck='checked' and IOleb='inleb'");
        $row   =  mysql_fetch_array($check);
        if ($row['Mbsn'])
            echo "Pass";
        else
            echo "Fail";
    }
    else
        echo "The SN and Name must not empty!";	
?>