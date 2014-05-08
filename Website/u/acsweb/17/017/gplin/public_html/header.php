<!-- Start header -->
<div class="header">
  <table class="header table">
    <tr class="header table row">
      <td class="header table row data">
        <?php
          if (($here) == "http://acsweb.ucsd.edu/~gplin/")
          {
        ?>
          <span style="font-weight:bold">Home</span>
        <?php
          }
          else
          {
        ?>
          <a href="http://acsweb.ucsd.edu/~gplin/">Home</a>
        <?php
          }
        ?>
      </td>
      <td class="header table row data">
        <?php
          if (($here) == "http://acsweb.ucsd.edu/~gplin/profile/")
          {
        ?>
          <span style="font-weight:bold">Profile</span>
        <?php
          }
          else
          {
        ?>
          <a href="http://acsweb.ucsd.edu/~gplin/profile/">Profile</a>
        <?php
          }
        ?>
      </td>
      <td class="header table row data">
        Repositories:
        <?php
          if (($here) == "http://acsweb.ucsd.edu/~gplin/svn/")
          {
        ?>
          <span style="font-weight:bold">SVN</span>
        <?php
          }
          else
          {
        ?>
          <a href="http://acsweb.ucsd.edu/~gplin/svn">SVN</a>
        <?php
          }
        ?>
        -
        <?php
          if (($here) == "http://acsweb.ucsd.edu/~gplin/git/")
          {
        ?>
          <span style="font-weight:bold">Git</span>
        <?php
          }
          else
          {
        ?>
          <a href="http://acsweb.ucsd.edu/~gplin/git">Git</a>
        <?php
          }
        ?>
      </td>
      <td class="header row data">
        <?php
          if (($here) == "http://acsweb.ucsd.edu/~gplin/files/")
          {
        ?>
          <span style="font-weight:bold">Other Files</span>
        <?php
          }
          else
          {
        ?>
          <a href="http://acsweb.ucsd.edu/~gplin/files/">Other Files</a>
        <?php
          }
        ?>
      </td>
      <td class="header table row data">
        <?php
          if (($here) == "http://acsweb.ucsd.edu/~gplin/cs110x/")
          {
        ?>
          <span style="font-weight:bold">CSE 110 Project</span>
        <?php
          }
          else
          {
        ?>
          <a href="http://acsweb.ucsd.edu/~gplin/cs110x/">CSE 110 Project</a>
        <?php
          }
        ?>
      </td>
    </tr>
  </table>
</div>
<!-- End header -->
