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
      <p>Hello from <code><?= gethostname() ?></code> !</p>
      <p>It's <code><?= date('r') ?></code> around here</p>
    </div>
  </body>
</html>
