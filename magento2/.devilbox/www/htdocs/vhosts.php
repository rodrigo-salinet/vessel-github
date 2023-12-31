<?php require '../config.php'; ?>
<?php loadClass('Helper')->authPage(); ?>
<!DOCTYPE html>
<html lang="en">
	<head>
		<?php echo loadClass('Html')->getHead(true); ?>
	</head>

	<body>
		<?php echo loadClass('Html')->getNavbar(); ?>

		<div class="container" style="margin-left: 15px;">

			<h1>Virtual Hosts</h1>
			<br/>
			<br/>

			<div class="row">
				<div class="col-md-12">
					<?php $vHosts = loadClass('Httpd')->getVirtualHosts(); ?>
					<?php if ($vHosts): ?>
						<table class="table table-striped">
							<thead class="thead-inverse">
								<tr>
									<th>Project</th>
									<th>DocumentRoot</th>
									<th>Config</th>
									<th>Valid</th>
									<th>URL loc</th>
									<th>URL loc admin</th>
									<th>URL prod</th>
									<th>URL prod admin</th>
								</tr>
							</thead>
							<tbody>
								<?php
									$totals = 70;
									$filler = '&nbsp;';
									for ($i=0; $i<$totals; $i++) {
										$filler = $filler. '&nbsp;';
									}
									$mysql_host = "127.0.0.1";
									$mysql_user = "root";
									$mysql_pass = "magento";
								?>
								<?php foreach ($vHosts as $vHost): ?>
									<?php
										$mysql_db = $vHost['name'];

										$mysql_conn = mysqli_connect($mysql_host,$mysql_user,$mysql_pass);
										mysqli_set_charset($mysql_conn,'utf8');
										mysqli_select_db($mysql_conn,$mysql_db);

										$mysql_query = "SELECT value FROM core_config_data WHERE path = 'web/secure/bkp_base_url'";
										if ($sql_bkp_url = mysqli_query($mysql_conn,$mysql_query)) {
											$linha_bkp_url = mysqli_fetch_assoc($sql_bkp_url);
										}
									?>
									<tr>
										<td><?php echo $vHost['name'];?></td>
										<td><?php echo loadClass('Helper')->getEnv('HOST_PATH_HTTPD_DATADIR');?>/<?php echo $vHost['name'];?>/<?php echo loadClass('Helper')->getEnv('HTTPD_DOCROOT_DIR');?></td>
										<td>
											<a title="Virtual host: <?php echo $vHost['name'];?>.conf" target="_blank" href="/vhost.d/<?php echo $vHost['name'];?>.conf"><i class="fa fa-cog" aria-hidden="true"></i></a>
											<?php if (($vhostGen = loadClass('Httpd')->getVhostgenTemplatePath($vHost['name'])) !== false): ?>
												<a title="vhost-gen: <?php echo basename($vhostGen);?> for <?php echo $vHost['name'];?>" href="/info_vhostgen.php?name=<?php echo $vHost['name'];?>"><i class="fa fa-filter" aria-hidden="true"></i></a>
											<?php endif; ?>
										</td>
										<td class="text-xs-center text-xs-small" id="valid-<?php echo $vHost['name'];?>">&nbsp;&nbsp;&nbsp;</td>
										<td id="href-<?php echo $vHost['name'];?>"><?php echo $filler;?></td>
										<td id="href-<?php echo $vHost['name'];?>-admin"><?php echo $filler;?></td>
										<td id="href-<?php echo $vHost['name'];?>-prod"><?php echo $filler;?></td>
										<td id="href-<?php echo $vHost['name'];?>-prod-admin"><?php echo $filler;?></td>
									</tr>
									<input type="hidden" name="vhost[]" class="vhost" value="<?php echo $vHost['name'];?>" />
									<input type="hidden" name="bkp_url_<?php echo $vHost['name'];?>" id="bkp_url_<?php echo $vHost['name'];?>" class="vhost" value="<?php echo $linha_bkp_url['value'];?>" />
									<?php
										@mysqli_free_result($sql_bkp_url);
										@mysqli_close($mysql_conn);
									?>
								<?php endforeach; ?>
							</tbody>
						</table>
					<?php else: ?>
						<h4>No projects here.</h4>
						<p>Simply create a directory in <strong><?php echo loadClass('Helper')->getEnv('HOST_PATH_HTTPD_DATADIR');?></strong> on your host computer (or in <strong>/shared/httpd</strong> inside the php container).</p>
						<p><strong>Example:</strong><br/><?php echo loadClass('Helper')->getEnv('HOST_PATH_HTTPD_DATADIR');?>/my_project</p>
						<p>It will then be available via <strong>http://my_project.<?php echo loadClass('Httpd')->getTldSuffix();?></strong></p>
					<?php endif;?>
				</div>
			</div>

		</div><!-- /.container -->

		<?php echo loadClass('Html')->getFooter(); ?>
		<script>
		// self executing function here
		(function() {
			// your page initialization code here
			// the DOM will be available here


			function updateStatus(vhost) {
				var xhttp = new XMLHttpRequest();

				xhttp.onreadystatechange = function() {
					var error = '';
					var el_valid;
					var el_href;

					if (this.readyState == 4 && this.status == 200) {
						el_valid = document.getElementById('valid-' + vhost);
						el_href = document.getElementById('href-' + vhost);
						error = this.responseText;

						if (error.length && error.match(/^error/)) {
							el_valid.className += ' bg-danger';
							el_valid.innerHTML = 'ERR';
							el_href.innerHTML = error;
						} else if (error.length && error.match(/^warning/)) {
							el_valid.className += ' bg-warning';
							el_valid.innerHTML = 'WARN';
							el_href.innerHTML = error.replace('warning', '');
							checkDns(vhost);
						} else {
							checkDns(vhost);
						}
					}
				};
				xhttp.open('GET', '_ajax_callback.php?vhost=' + vhost, true);
				xhttp.send();
			}

			/**
			 * Check if DNS record is set in /etc/hosts (or via attached DNS server)
			 * for TLD_SUFFIX
			 */
			function checkDns(vhost) {
				var xhttp = new XMLHttpRequest();
				var proto;
				var port;
				var name = vhost + '.<?php echo loadClass('Httpd')->getTldSuffix();?>'
				var name_only = vhost;

				var url = window.location.href.split("/");
				var tmp = url[2].split(":");
				proto = url[0];
				port = tmp.length == 2 ? ':' + tmp[1] : '';

				// Timeout after XXX seconds and mark it invalid DNS
				xhttp.timeout = <?php echo loadClass('Helper')->getEnv('DNS_CHECK_TIMEOUT');?>000;

				xhttp.onreadystatechange = function(e) {
					var el_valid = document.getElementById('valid-' + vhost);
					var el_href = document.getElementById('href-' + vhost);
					var el_href_admin = document.getElementById('href-' + vhost + '-admin');
					var el_href_prod = document.getElementById('href-' + vhost + '-prod');
					var el_href_prod_admin = document.getElementById('href-' + vhost + '-prod-admin');
					var bkp_url = document.getElementById('bkp_url_' + vhost).value;
					var error = this.responseText;

					if (this.readyState == 4 && this.status == 200) {
						clearTimeout(xmlHttpTimeout);
						el_valid.className += ' bg-success';
						if (el_valid.innerHTML != 'WARN') {
							el_valid.innerHTML = 'OK';
						}
						el_href.innerHTML = '<a target="_blank" href="'+proto+'//'+name+port+'">'+name+port+'</a>';
						el_href_admin.innerHTML = '<a target="_blank" href="'+proto+'//'+name+port+'/admin">'+name+port+'/admin</a>';
						el_href_prod.innerHTML = '<a target="_blank" href="'+bkp_url+port+'">'+bkp_url+port+'</a>';
						el_href_prod_admin.innerHTML = '<a target="_blank" href="'+bkp_url+port+'admin">'+bkp_url+port+'admin</a>';
					} else {
						//console.log(vhost);
					}
				}
				xhttp.open('POST', proto+'//'+name+port+'/devilbox-api/status.json', true);
				xhttp.send();

				// Timeout to abort in 1 second
				var xmlHttpTimeout = setTimeout(ajaxTimeout, <?php echo loadClass('Helper')->getEnv('DNS_CHECK_TIMEOUT');?>000);
				function ajaxTimeout(e) {
					var el_valid = document.getElementById('valid-' + vhost);
					var el_href = document.getElementById('href-' + vhost);
					var error = this.responseText;

					el_valid.className += ' bg-danger';
					el_valid.innerHTML = 'ERR';
					el_href.innerHTML = 'No Host DNS record found. Add the following to <code>/etc/hosts</code>:<br/><code>127.0.0.1 '+vhost+'.<?php echo loadClass('Httpd')->getTldSuffix();?></code>';
				}

			}

			var vhosts = document.getElementsByName('vhost[]');

			for (i = 0; i < vhosts.length; i++) {
				updateStatus(vhosts[i].value);
			}
		})();


		</script>
	</body>
</html>
