<?php
header('X-Source: ' . gethostname());
header('X-Version: 3.0');
header('Content-Type: text/html');
header('Cache-Control: must-revalidate');
header('Cache-Control: no-cache');
?>
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
      font-size: calc(8px + 2vw);
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
      background-color: rgba(255, 255, 255, 0.25);
      margin: 0 auto;
      text-align: center;
      padding: 10px;
    }
    #loaded {
      position: absolute;
      font-size: 24pt;
      font-weight: bold;
      bottom: 4pt;
      right: 4pt;
      color: white;
      opacity: 0.5;
    }
  </style>
  <title><?= $host ?></title>
  <script>
    function flashReload() {
      setTimeout(function() {
        document.all.loaded.style.display = 'none';
      }, 1000);
    }
  </script>
</head>
<body onload='flashReload()'>
  <div class="frameT">
    <div class="frameTC">
      <div class="content">
        <h1><script>document.write(document.title);</script></h1>
        <span id='generated'><?= date('r') ?></span>
       <div id='loaded'>&#x21bb;</div>
      </div>
    </div>
  </div>
</body>
</html>
