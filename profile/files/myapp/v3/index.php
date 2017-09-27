<?php
header('X-Source: ' . gethostname());
header('Content-Type: text/html');
?>
<html>
  <head>
    <style>
    BODY {
      margin: 0;
      font-family: Roboto;
      font-size: 16pt;
    }
    #banner {
      background-color: gray;
      padding: 6pt;
    }
    #banner IMG {
      height: 48px;
      vertical-align: middle;
    }
    #content {
      margin: 16pt;
    }
    CODE {
      border: 1px solid green;
      border-radius: 4pt;
      color: green;
      padding: 4pt;
      padding-right: 8pt;
      padding-left: 8pt;
      margin-left: 8pt;
      margin-right: 8pt;
    }
    #amp {
      font-weight: bold;
      color: white;
      font-size: 36pt;
      margin-left: 16pt;
      margin-right: 16pt;
      vertical-align: middle;
    }
    </style>
  </head>
  <body>
    <div id='banner'>
      <img id='gcp' src='google-cloud-platform-logo.png'>
      <span id='amp'>+</span>
      <img id='puppet' src='puppet-logo.png'>
    </div>
    <div id='content'>
<?php 
  $cols = $_GET['cols'];
  if (empty($cols)) {
    $cols = 5;
  }
  $requests = $_GET['load'];
  if (empty($requests)) {
    $requests = 15;
  }
  $rows = $requests / $cols;
?>
  <head>
    <style>
    IFRAME {
      border: 1px solid gray;
      width: <?= 100/$cols - 1 ?>%;
    }
    </style>
  </head>
  <body>
<?php
  for ($j = 0; $j < $cols; $j++) {
    for ($i = 0; $i < $rows; $i++) {
      echo "<iframe src='frame.php?refresh=${_GET['refresh']}'></iframe>\n";
    }
  }
?>
    </div>
  </body>
</html>
<html>
