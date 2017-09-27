<html>
<?php 
  $cols = $_GET['cols'];
  if (empty($cols)) {
    $cols = 3;
  }
  $requests = $_GET['load'];
  if (empty($requests)) {
    $requests = 40;
  }
  $rows = $requests / $cols;
?>
  <frameset cols="<?= implode("%,", array_fill(0, $cols, 100/$cols)); ?>%">
<?php for ($j = 0; $j < $cols; $j++) { ?>
    <frameset rows="<?= implode("%,", array_fill(0, $rows, 100/$rows)); ?>%">
    <?php for ($i = 0; $i < $rows; $i++) { ?>
      <frame src="index.php?stress=1">
    <?php } ?>
    </frameset>
<?php } ?>
  </frameset>
</html>
