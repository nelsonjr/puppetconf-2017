<html>
  <?php $requests = 40; ?>
  <?php $rows = $requests / 3; ?>
  <frameset cols="33%,33%,*">
    <frameset rows="<?= implode("%,", array_fill(0, $rows, 100/$rows)); ?>%">
    <?php for ($i = 0; $i < $rows; $i++) { ?>
      <frame src="index.php?child">
    <?php } ?>
    </frameset>
    <frameset rows="<?= implode("%,", array_fill(0, $rows, 100/$rows)); ?>%">
    <?php for ($i = 0; $i < $rows; $i++) { ?>
      <frame src="index.php?child">
    <?php } ?>
    </frameset>
    <frameset rows="<?= implode("%,", array_fill(0, $rows, 100/$rows)); ?>%">
    <?php for ($i = 0; $i < $rows; $i++) { ?>
      <frame src="index.php?child">
    <?php } ?>
    </frameset>
  </frameset>
</html>
