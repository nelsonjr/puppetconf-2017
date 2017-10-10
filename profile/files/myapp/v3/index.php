<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<?php
//$r = rand() % 10;
//$host = gethostname() . $r;
$host = gethostname();
?>
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta http-equiv="Cache-Control" content="no-cache, no-store" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="0" />
  <meta http-equiv="refresh" content="5">
  <style>
    body {
      margin: 0;
      padding: 0;
      background-color: #<?= substr(sha1($host), 0, 6); ?>;
      width: 100%;
      height: 100%;
      font: 14px Tahoma, Verdana, Arial, san-serif;
    }
    h1 {
      font-size: calc(8px + 3vw);
      margin: 10px;
      margin-top: 0;
    }
    div.frameT {
      width: 100%;
      padding: 0;
      display: table;
      height: 100%;
      position: absolute;
      top: 0;
      left: 0;
      margin: 0;
      text-align: center;
    }
    div.frameTC {
      padding: 0;
      vertical-align: middle;
      display: table-cell;
      margin: 0;
    }
    div.content {
      display: inline-block;
      background-color: #fff;
      text-align: center;
      padding: 10px;
    }
  </style>
  <title><?= $host ?></title>
</head>
<body>
  <div class="frameT">
    <div class="frameTC">
      <div class="content">
        <h1><script>document.write(document.title);</script></h1>
        <?= date('r') ?>
      </div>
    </div>
  </div>
</body>
</html>
